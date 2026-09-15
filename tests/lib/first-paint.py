#!/usr/bin/env python3
"""Measure time from exec to first byte drawn, on a real pty.

The briefing calls this the most decision-relevant number in the exercise: a
tmux popup binding wants sub-200ms to first paint, and none of the upstream
READMEs report it.

What is measured is deliberately narrow. "First byte drawn" is the first output
the program writes to the terminal, which for a full-screen program is its
initial escape sequence. It is not "fully rendered", which cannot be measured
without asserting on frames, and the briefing forbids that.
"""

import argparse
import errno
import json
import os
import pty
import selectors
import signal
import statistics
import subprocess
import sys
import time


def once(command, cwd, env, timeout):
    controller, worker = pty.openpty()
    started = time.monotonic()
    proc = subprocess.Popen(
        command,
        stdin=worker,
        stdout=worker,
        stderr=worker,
        cwd=cwd,
        env=env,
        start_new_session=True,
    )
    os.close(worker)

    selector = selectors.DefaultSelector()
    selector.register(controller, selectors.EVENT_READ)
    first = None
    deadline = started + timeout

    while time.monotonic() < deadline:
        for _key, _events in selector.select(timeout=0.01):
            try:
                chunk = os.read(controller, 65536)
            except OSError as exc:
                if exc.errno in (errno.EIO, errno.EBADF):
                    chunk = b""
                else:
                    raise
            if chunk:
                first = time.monotonic() - started
                break
        if first is not None:
            break
        if proc.poll() is not None:
            break

    selector.close()
    for sig in (signal.SIGTERM, signal.SIGKILL):
        if proc.poll() is not None:
            break
        try:
            os.killpg(os.getpgid(proc.pid), sig)
            proc.wait(timeout=2)
        except (ProcessLookupError, subprocess.TimeoutExpired):
            continue
    try:
        os.close(controller)
    except OSError:
        pass

    return first


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--runs", type=int, default=5)
    parser.add_argument("--timeout", type=float, default=10.0)
    parser.add_argument("--cwd", default=None)
    parser.add_argument("--label", default=None)
    parser.add_argument("--json", action="store_true")
    parser.add_argument("command", nargs=argparse.REMAINDER)
    args = parser.parse_args()

    command = args.command
    if command and command[0] == "--":
        command = command[1:]

    env = dict(os.environ)
    env.setdefault("TERM", "xterm-256color")

    samples = []
    for _ in range(args.runs):
        value = once(command, args.cwd, env, args.timeout)
        if value is not None:
            samples.append(value * 1000.0)

    label = args.label or os.path.basename(command[0])
    if not samples:
        result = {"tool": label, "runs": args.runs, "drew": 0, "median_ms": None}
    else:
        result = {
            "tool": label,
            "runs": args.runs,
            "drew": len(samples),
            "median_ms": round(statistics.median(samples), 1),
            "min_ms": round(min(samples), 1),
            "max_ms": round(max(samples), 1),
        }

    if args.json:
        print(json.dumps(result))
    else:
        if result["median_ms"] is None:
            print(f"{label:<14} never drew anything in {args.timeout}s")
        else:
            print(
                f"{label:<14} median {result['median_ms']:>7.1f} ms   "
                f"min {result['min_ms']:>7.1f}   max {result['max_ms']:>7.1f}   "
                f"({result['drew']}/{result['runs']} runs drew)"
            )
    return 0


if __name__ == "__main__":
    sys.exit(main())
