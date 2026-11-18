import type { Register } from 'claude-code'

// /tuicr [tuicr args]: run the tuicr-popup launcher directly (no model turn), then submit the
// review it prints as the next prompt. The launcher owns everything else: tmux window, repo
// picker, jj/git detection, clearing and logging of sent comments.
const NAMES = ['tuicr', 'tuicr-review'] as const

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const spec = {
      description: 'Review the diff in tuicr; your comments go straight to Claude',
      argumentHint: '[tuicr args, e.g. -r main..HEAD]',
    }
    // A session that started while a user command named /tuicr existed keeps refusing the
    // name until it restarts; /tuicr-review is the stand-in there.
    try {
      await $.command.register({ name: NAMES[0], ...spec })
    } catch {
      await $.command.register({ name: NAMES[1], ...spec })
    }

    return next(e)
  })

  for (const command of NAMES) {
    on('command.run', { command }, async ($, e) => {
      const args = e.args.split(/\s+/).filter(Boolean)

      // Not awaited: a review can outlast any hook. The command returns at once and the
      // comments arrive as a prompt whenever tuicr closes.
      void (async () => {
        let out = ''
        let err = ''
        for await (const { stream, text } of $.process.spawn({ argv: ['tuicr-popup', ...args] })) {
          if (stream === 'stdout') out += text
          else err += text
        }
        out = out.trim()

        // "tuicr: ..." lines are the launcher's own status: no comments, or an error.
        if (!out || out.startsWith('tuicr:')) {
          $.ui.toast(out || err.trim() || 'tuicr: closed with no output')
          return
        }
        await $.prompt.submit({ text: out, asUser: true })
      })().catch(error => $.ui.toast(`tuicr: ${String(error)}`))

      return { text: 'tuicr review opened in its own tmux window.' }
    })
  }
}
