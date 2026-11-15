---
description: Review the diff in a tuicr tmux window, then act on my comments
---

Run `tuicr-popup $ARGUMENTS` from the repo root with the bash tool and a 30 minute timeout (1800000 ms); it blocks while I review in that window.

Its output is my review as markdown with file/line anchors. Address every comment. If it prints "tuicr: no review comments", I approved the changes as they are; say so and stop. Any other "tuicr: ..." line is an error; report it.
