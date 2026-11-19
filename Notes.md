# Notes

Running log of decisions made in this repo. Newest first.

### 2026-11-19 — tuicr review workflow, agenmux, opencode plugins

**What was built**

- `bin/.local/scripts/tuicr-popup`: opens tuicr in its own tmux window, hands the review back. `prefix R` pastes it into the launching pane; `/tuicr` in Claude Code (mod, `claude-plugins/tuicr`) and opencode (TUI plugin, `opencode/.config/opencode/plugins/tuicr`) run it with no model turn and submit the comments as a prompt.
- agenmux via tpm (`prefix A` sidebar, `prefix e` popup) plus an agent count in the status bar.
- `detach-on-destroy off`: closing a session's last window goes to the last-used session.

**Decisions and why**

- tuicr over Plannotator/Crit/revdiff: wanted a terminal reviewer; revdiff has no Alacritty overlay; Hunk's notes run agent to human, the wrong way.
- Own window, not a tmux popup: asked for after trying the popup.
- Comments are cleared after each send and appended to `~/.local/share/tuicr-popup/reviews.md`; recurring comments there are candidates for CLAUDE.md rules or lints.
- Slash commands moved from markdown commands to a mod / TUI plugin because the markdown versions cost a model turn just to launch.

**Hard-won facts**

- tuicr exports only on `:wq`/`:x`/`ZZ`/`y`; after `:q` the comments are in the saved session, which resolves only from the repo root. The launcher cds to the root and reads the session as a fallback.
- tuicr names a session on stderr even when it saved none (no comments); treat lookup failure as "no comments".
- From a parent repo tuicr shows a submodule as a one-line pointer change; review from inside the submodule.
- agenmux fills `#{agenmux}` only during first-time setup, and the tokyo-night theme rewrites status-right on every load, so the placeholder never sticks. The config calls the documented `agenmux status` command instead.
- tpm clones agenmux past its release tag, so it builds its engine with cargo on first load.
- A Claude Code session keeps refusing a mod's command name that a user markdown command held when the session started (seen once; it cleared without a restart).
- opencode 2.3.0 TUI plugins: `router.current()`, `data.session.create` and `data.session.prompt` are undocumented, found by inspecting the context. Same for server plugins' tool-event `sessionID` and `session.execution.*` events. Expect breakage on upgrade.
- A markdown command and a plugin slash command with the same name both show in opencode's menu, and the markdown one wins on Enter.

**Open**

- Real usage is unproven: as of 2026-11-18 no real review had delivered comments on this machine.
- opencode: the no-comments toast and question logging in md-log are unconfirmed.
- Possible upstream issue for agenmux's placeholder not being refilled on reload (not filed).
