---
name: nxtcoder17-ui-solidjs
description: It is a UI development solidjs skill that tries to guide agents to generate code that has my flavour
---

# Disciplines
- Must seek clarity by prompting doubts prior to jumping on implementation

## Comments
- No comments, unless very special usecases like JSDoc, Parsing etc.
- When adding general comments, it must start with either `TODO`, `INFO`, `NOTE`, `WARN`, `FIXME`, `WHY` etc, so that the intent/action behind the comment is known
- Never ever have the box style comments

## Component API design
- When creating/refactoring components, we must not leak component implementation details in it's API (props/children/custom-hooks) etc. A consumer of the component, does not need to know everything to use the component.
- Must not have too many internal states (>4)  or hook usages (>2)
- Must not have more than 200 lines of JSX rendering, cause post that it is hard to make sense of the layout
- When doing type declarations, it must be placed just above the component declaration
- For component props, interface is more idiomatic:
    - interface: Better for object shapes that may be extended, clearer error messages, supports declaration merging
    - type: Better for unions, intersections, utility types (Partial<T>, Pick<T>)
- prefer composition of signals using createStore/createMutation, instead of scattering createSignals when needed

## Component composition/refactoring rules
- Extract repeated or self-contained UI pieces into separate components when they have:
  - More than 3 event handlers
  - A distinct single responsibility
  - Clear prop boundaries (no leaking parent internals)
- When a JSX block exceeds ~15 lines of nested elements, consider extracting it
- Interactive elements (buttons, drag handles, inputs) should be their own component if they carry logic beyond a simple onClick
- Inline event handlers with >3 lines of logic should be extracted as named functions or components

## Design and Theming
- We will be using TailiwindCSS v4 along with [nsg-ui](https://nsg-ui.pages.dev/) component library. 
  It has the basic foundational components in there, that should serve as building blocks for pages in here.
