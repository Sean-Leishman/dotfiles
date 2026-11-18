import { Plugin } from "@opencode/plugin/tui"

// /tuicr [tuicr args]: run the tuicr-popup launcher directly (no model turn), then send the
// review it prints to the session as a prompt. The launcher owns everything else: tmux window,
// repo picker, jj/git detection, clearing and logging of sent comments.
//
// The docs for TUI plugins cover commands and toasts only; router.current(), data.session.create
// and data.session.prompt were found by inspecting the context object on opencode 2.3.0.
export default Plugin.define({
  id: "local.tuicr",
  setup(context: any) {
    const toast = (message: string) => context.ui.toast.show({ message })

    context.keymap.layer(() => ({
      mode: "global",
      commands: [
        {
          id: "local.tuicr.review",
          title: "Review diff in tuicr",
          group: "Review",
          palette: true,
          slash: { name: "tuicr", arguments: true },
          run: (input?: string) => {
            const args = (input ?? "").split(/\s+/).filter(Boolean)
            // The session to answer is the one on screen when the review starts.
            const route = context.ui.router.current()
            let sessionID: string | undefined = route?.type === "session" ? route.sessionID : undefined

            // Not awaited: a review can take as long as it takes; comments arrive when tuicr closes.
            void (async () => {
              const proc = Bun.spawn(["tuicr-popup", ...args], { stdout: "pipe", stderr: "pipe" })
              const [out, err] = await Promise.all([new Response(proc.stdout).text(), new Response(proc.stderr).text()])
              await proc.exited
              const review = out.trim()

              // "tuicr: ..." lines are the launcher's own status: no comments, or an error.
              if (!review || review.startsWith("tuicr:")) {
                toast(review || err.trim() || "tuicr: closed with no output")
                return
              }
              // Started from the home screen: the comments need a session to go to.
              if (!sessionID) {
                const created = context.data.session.create({ title: "tuicr review" })
                await created.request
                sessionID = created.id
                context.ui.router.navigate({ type: "session", sessionID })
              }
              await context.data.session.prompt({ sessionID, text: review })
            })().catch((error: unknown) => toast(`tuicr: ${String(error)}`))

            toast("tuicr review opened in its own tmux window")
          },
        },
      ],
      bindings: [],
    }))
  },
})
