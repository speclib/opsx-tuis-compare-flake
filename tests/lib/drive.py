#!/usr/bin/env python3
"""Drive a terminal program on a real pty and print the screen it drew.

This is for exploring the tools by hand, not for a check. Nothing in
`nix flake check` asserts on rendered output, and nothing here should either:
frame content is exactly what upstream is free to change. What this is for is
answering questions the source could not, so a matrix cell can move from
undetermined to observed.

Usage:
  drive.py --keys ':2s,j,j,enter:1s' -- some-tool --flag

Key script is a comma-separated list of key names or literal text. A step of
the form `:500ms` or `:2s` waits.
"""

import argparse
import errno
import os
import pty
import re
import selectors
import signal
import subprocess
import sys
import time

import pyte

KEYS = {
    "enter": "\r",
    "tab": "\t",
    "esc": "\x1b",
    "space": " ",
    "bs": "\x7f",
    "up": "\x1b[A",
    "down": "\x1b[B",
    "right": "\x1b[C",
    "left": "\x1b[D",
    "pgup": "\x1b[5~",
    "pgdn": "\x1b[6~",
    "ctrl-c": "\x03",
    "ctrl-p": "\x10",
    "ctrl-s": "\x13",
    "ctrl-q": "\x11",
}


def parse_delay(token):
    match = re.fullmatch(r":(\d+)(ms|s)", token)
    if not match:
        return None
    value = int(match.group(1))
    return value / 1000.0 if match.group(2) == "ms" else float(value)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--keys", default="")
    parser.add_argument("--cols", type=int, default=110)
    parser.add_argument("--rows", type=int, default=34)
    parser.add_argument("--settle", type=float, default=1.5)
    parser.add_argument("--cwd", default=None)
    parser.add_argument("--label", default=None)
    parser.add_argument("command", nargs=argparse.REMAINDER)
    args = parser.parse_args()

    command = args.command
    if command and command[0] == "--":
        command = command[1:]

    screen = pyte.Screen(args.cols, args.rows)
    stream = pyte.Stream(screen)

    controller, worker = pty.openpty()
    try:
        import fcntl
        import struct
        import termios

        fcntl.ioctl(
            worker, termios.TIOCSWINSZ, struct.pack("HHHH", args.rows, args.cols, 0, 0)
        )
    except Exception:
        pass

    env = dict(os.environ)
    env["TERM"] = "xterm-256color"
    env["COLUMNS"] = str(args.cols)
    env["LINES"] = str(args.rows)

    proc = subprocess.Popen(
        command,
        stdin=worker,
        stdout=worker,
        stderr=worker,
        cwd=args.cwd,
        env=env,
        start_new_session=True,
    )
    os.close(worker)

    selector = selectors.DefaultSelector()
    selector.register(controller, selectors.EVENT_READ)

    def pump(duration):
        end = time.monotonic() + duration
        while time.monotonic() < end:
            for _key, _events in selector.select(timeout=0.05):
                try:
                    chunk = os.read(controller, 65536)
                except OSError as exc:
                    if exc.errno in (errno.EIO, errno.EBADF):
                        return False
                    raise
                if not chunk:
                    return False
                stream.feed(chunk.decode("utf-8", "replace"))
        return True

    pump(args.settle)

    steps = [s for s in args.keys.split(",") if s]
    for step in steps:
        delay = parse_delay(step)
        if delay is not None:
            pump(delay)
            continue
        payload = KEYS.get(step.lower(), step)
        try:
            os.write(controller, payload.encode())
        except OSError:
            break
        pump(0.6)

    pump(0.4)
    exited = proc.poll()

    for sig in (signal.SIGTERM, signal.SIGKILL):
        if proc.poll() is not None:
            break
        try:
            os.killpg(os.getpgid(proc.pid), sig)
            proc.wait(timeout=2)
        except (ProcessLookupError, subprocess.TimeoutExpired):
            continue
    selector.close()
    try:
        os.close(controller)
    except OSError:
        pass

    label = args.label or os.path.basename(command[0])
    lines = [line.rstrip() for line in screen.display]
    while lines and not lines[-1]:
        lines.pop()

    bar = "=" * args.cols
    print(bar)
    print(f"{label}   keys: {args.keys or '(none)'}   "
          f"{'exited ' + str(exited) if exited is not None else 'still running'}")
    print(bar)
    for line in lines:
        print(line)
    print(bar)
    return 0


if __name__ == "__main__":
    sys.exit(main())
