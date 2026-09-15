# Design: completing the e2e suite

## The count assertion is the point

Starting six named tools and reporting success proves that those six start. It
does not prove the suite still covers the environment, and the failure mode is
silent: a seventh tool is added, nobody edits this file, and the check keeps
passing while covering less.

So the scenario counts what it started and compares that against the `ost-`
commands the environment exposes, excluding the two harness commands. Adding a
tool without covering it is then a failure with an obvious message.

## Why ost-opsx is invoked differently

Every other tool is started bare. `ost-opsx` gets `--project`, because with no
project it exits 0 after 46 bytes, having drawn nothing. A pty start check
counts a clean early exit as a pass, so a bare invocation would report it as
started when it had not started.

Rather than hide that in a comment, the scenario ends by demonstrating it: it
runs `ost-opsx` bare from a directory with no OpenSpec root and reports the
byte count. That keeps the reason for the special case visible in the check's
own output, and it will notice if upstream ever changes that behaviour.

## What is deliberately not asserted

Nothing about rendered output. The briefing forbids it, and a check that
asserted on frames would break on any redesign while proving nothing about
whether the tool works.
