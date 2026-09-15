#!/usr/bin/env python3
"""Run a command on a real pty, bounded by a timeout.

The briefing forbids faking a TTY and forbids asserting on rendered frames, so
the only honest signal a terminal program can give is whether it stayed up.
This runner judges it on exactly that:

  still running when the deadline hits -> pass (it started and stayed up)
  exited zero before the deadline      -> pass (a --help style run)
  exited non-zero before the deadline  -> fail (it died on its own)

Nothing here inspects what the program drew. Output is captured only so a
failure can be explained.

Usage: pty-run.py --timeout SECONDS -- COMMAND [ARGS...]
"""

import argparse
import errno
import os
import pty
import selectors
import signal
import subprocess
import sys
import time


def main() -> int:
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--timeout", type=float, default=5.0)
    parser.add_argument("--cols", type=int, default=100)
    parser.add_argument("--rows", type=int, default=30)
    parser.add_argument("--help", action="help")
    parser.add_argument("command", nargs=argparse.REMAINDER)
    args = parser.parse_args()

    command = args.command
    if command and command[0] == "--":
        command = command[1:]
    if not command:
        print("pty-run: no command given", file=sys.stderr)
        return 2

    controller, worker = pty.openpty()

    try:
        import fcntl
        import struct
        import termios

        fcntl.ioctl(
            worker,
            termios.TIOCSWINSZ,
            struct.pack("HHHH", args.rows, args.cols, 0, 0),
        )
    except Exception:
        # Window size is a nicety. A pty without it is still a pty.
        pass

    env = dict(os.environ)
    env.setdefault("TERM", "xterm-256color")

    proc = subprocess.Popen(
        command,
        stdin=worker,
        stdout=worker,
        stderr=worker,
        env=env,
        close_fds=True,
        start_new_session=True,
    )
    os.close(worker)

    captured = bytearray()
    selector = selectors.DefaultSelector()
    selector.register(controller, selectors.EVENT_READ)

    deadline = time.monotonic() + args.timeout
    status = None

    while True:
        remaining = deadline - time.monotonic()
        if remaining <= 0:
            break

        for _key, _events in selector.select(timeout=min(remaining, 0.25)):
            try:
                chunk = os.read(controller, 65536)
            except OSError as exc:
                if exc.errno in (errno.EIO, errno.EBADF):
                    chunk = b""
                else:
                    raise
            if chunk:
                captured.extend(chunk)

        status = proc.poll()
        if status is not None:
            break

    selector.close()

    timed_out = status is None
    if timed_out:
        # Still up at the deadline. Ask it to leave, then insist.
        _terminate(proc)
        status = proc.poll()

    try:
        os.close(controller)
    except OSError:
        pass

    text = captured.decode("utf-8", "replace")

    if timed_out:
        print(f"pty-run: still running at {args.timeout}s deadline: PASS")
        return 0

    if status == 0:
        print(f"pty-run: exited 0 before the deadline: PASS")
        return 0

    print(f"pty-run: exited {status} before the {args.timeout}s deadline: FAIL",
          file=sys.stderr)
    if text.strip():
        print("--- captured output ---", file=sys.stderr)
        print(text[-4000:], file=sys.stderr)
    return 1


def _terminate(proc: "subprocess.Popen[bytes]") -> None:
    for sig in (signal.SIGTERM, signal.SIGKILL):
        if proc.poll() is not None:
            return
        try:
            os.killpg(os.getpgid(proc.pid), sig)
        except ProcessLookupError:
            return
        try:
            proc.wait(timeout=3)
            return
        except subprocess.TimeoutExpired:
            continue


if __name__ == "__main__":
    sys.exit(main())
