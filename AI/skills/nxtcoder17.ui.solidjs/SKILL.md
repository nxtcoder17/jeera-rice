---
name: nxtcoder17.ui.solidjs
description: It is a UI development solidjs skill that tries to guide agents to generate code that has my flavour
---

# Disciplines
- Must seek clarity by prompting doubts prior to jumping on implementation

## Component API design
- When creating/refactoring components, we must not leak component implementation details in it's API (props/children/custom-hooks) etc. A consumer of the component, does not need to know everything to use the component.
- Must not have too many internal states (>4)  or hook usages (>2)
- Must not have more than 200 lines of JSX rendering, cause post that it is hard to make sense of the layout
- When doing type declarations, it must be placed just above the component declaration

