---
description: Review the diff in a tuicr tmux window, then act on my comments
argument-hint: "[tuicr args, e.g. -r main..HEAD] (default: -w)"
allowed-tools: Bash(tuicr-popup:*)
---

Run `tuicr-popup $ARGUMENTS` from the repo root with the Bash tool, using `run_in_background: true` (I may review for longer than any timeout). Do nothing else while it runs.

When it exits, its output is my review as markdown with file/line anchors. Address every comment. If it prints "tuicr: no review comments", I approved the changes as they are; say so and stop. Any other "tuicr: ..." line is an error; report it.
