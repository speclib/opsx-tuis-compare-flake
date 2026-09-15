# Design: cutting the alpha

## The roadmap is generated from beans, not by beans

`beans roadmap` emits an empty document in beans 0.4.2. That was reproduced in a
minimal scratch project, so it is the tool and not this repository's data. The
roadmap is therefore generated from `beans query --json`, and the file says so,
so the next person does not spend the same half hour on it.

## What the handover has to say that the README does not

The README is for someone choosing a tool. The handover is for someone
continuing this work, which means it has to carry three things the README has
no place for:

- The findings stated as findings, rather than as matrix rows. The
  language-shaped split in first-paint time, the CLI route being cheaper than
  the briefing expected, and `--store` existing only on the CLI-backed tool.
- What is deliberately not done and why, so nobody rediscovers the reasoning.
- The three rules most likely to be broken by accident, including the
  `openspec` output redirection, which fails in a way that looks like a hang
  rather than an error.

## The gap that cannot be closed by this process

The briefing asks which tool made you quit within 30 seconds, which one you
reached for a second time, and which keymap fought your muscle memory. A run
that reads source and measures startup cannot answer any of those. The handover
says so plainly rather than leaving three empty headings that look like an
oversight.
