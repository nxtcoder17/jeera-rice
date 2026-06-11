## Session Handoff
On New Session start
    - go through the project's `.secrets/LLM.md` and ensure it exists
    - NEVER create any specific files like CLAUDE.md, GEMINI.md etc., instead use `.secrets/LLM.md` as the target file.
    - ensure .secrets is gitignored.
    - Read Session Handoff, throw a description of what was done/being done last time, and then resume from there.

- Session Handoff Format:
  ```markdown
  ## Session Handoff

  ### Last Updated: [timestamp]
  ### Status: [in-progress | blocked | completed]

  ### Current Task [<task-id>]
  [Brief description]

  **Blockers**
  <[What's blocking, if any]>

  Next Steps, when current is done
  1. [First action/task]
  2. [Second action/task]

  ### Progress
  - [ ] [t-01] pending 1
  - [x] [t-02] done 1
  - [x] [t-03] done 2

  ### Context Files
  - `path/to/file` - [why relevant]
  ```

- Update Session Handoff sections when:
  - On task completion
  - On compaction (manual or auto)

## Prompt Input Guidelines
- Be concise, feel free to sacrifice grammar for brevity
- On every prompt, seek clarity in case of any ambiguity by prompting for your doubts, and proceed only when clear on the next tasks
- Input smells over-engineering, point that out to my face

## Prompt Output Guidelines
- Post Completion, put follow-up tasks (label them as recommended, must do, should do) that could be done.
- notify the user

## Notification Discipline
- Essentially: anytime you need the user back at the terminal, or to help you un-stuck, Notify.
- Notify using this shell command `curl http://localhost:17171/notify`.
    - ✓ Significant task completion
    - ✓ Blocking questions needing your input
    - ✓ Before permission prompts (edit/read/execute approvals)
    - ✓ Errors needing your decision
- when it fails, continue silently, don't vomit on the terminal

## SubAgent Guidelines
Ask: "Do I need the result, or do I need to do the work myself?"
- Need result → subagent
- Need to edit/write/commit → main context

## Code Guidelines
If commenting, keep it simple, no need to go overboard with boxed style comments

