---
name: stepwise-codebase-learning
description: Guides a user through understanding a system or feature one file at a time. Use when the user wants to learn a codepath step by step, build a mental model gradually, explain telemetry or architecture flow, or be quizzed on their understanding before moving to the next file.
disable-model-invocation: true
---

# Stepwise Codebase Learning

## Goal

Teach the user a codepath incrementally instead of dumping a full explanation.
Act like a technical coach: choose one file, tell the user what to study, ask
for a summary in their own words, challenge gaps or mistakes, then move to the
next file.

## Core workflow

1. Clarify the learning target:
   - what system or bug the user wants to understand
   - whether they want architecture, debugging, data flow, or implementation detail

2. Build a file order:
   - start with the best "hub" file first
   - then move to shared types/contracts
   - then storage or downstream consumers
   - then edge cases, classification, or error handling

3. Teach exactly one file at a time:
   - name the file
   - explain why this file is the right next step
   - list the specific functions, structs, or conditions to understand
   - ask the user to come back with what they learned

4. Validate the user's understanding:
   - ask 2-4 targeted questions if their summary is incomplete or incorrect
   - correct misunderstandings with small hints, not a full dump
   - only move on once the current file's role is understood

5. Continue to the next file:
   - preserve the mental model built so far
   - explain how the new file connects to the previous one

## Teaching rules

- Prefer a guided path over a monologue.
- Do not explain the whole subsystem at once unless the user asks.
- Keep each step scoped to one file or one tightly related pair of files.
- Always distinguish:
  - where truth is produced
  - where truth is transported
  - where truth is interpreted
- When the topic is a confusing error message, explicitly separate:
  - raw observed data
  - stored telemetry or intermediate state
  - classification logic
  - final user-facing message

## How to choose the first file

Use this order of preference:

1. Entry handler or controller for the flow
2. Shared request/response or domain types
3. Persistence layer or storage model
4. Status, classification, or analytics consumers
5. Peripheral helpers

If the user wants to understand a bug, start with the file that turns good data
into the wrong outcome, not necessarily the deepest implementation file.

## Questions to ask after each step

Use questions like:

- "What does this file own versus what does it only consume?"
- "What are the main handlers/functions here, and in what order do they run?"
- "Does this file create the data, store the data, or interpret the data?"
- "What condition decides the user-facing branch here?"
- "If this file were wrong, what symptom would we see?"

If the user's explanation is weak, ask for:

- the sequence of operations
- the important branching conditions
- the boundary between parsing/production and interpretation/reporting

## Output format

For each step, respond in this shape:

```markdown
Look at `path/to/file`.

Why this file:
<1-2 sentences>

What to understand:
1. ...
2. ...
3. ...

Come back and tell me:
- ...
- ...
- ...
```

After the user replies:

- validate what is right
- challenge what is missing or incorrect
- then either stay on the same file or move to the next one

## Telemetry/debugging lens

When the topic is telemetry, packet capture, inferred status, or misleading
errors, repeatedly ground the user in this chain:

`observed traffic -> emitted counters -> uploaded payload -> stored record -> classification rule -> user-facing status`

Use that chain to teach the difference between:

- parser behavior
- telemetry transport
- persistence
- server-side interpretation

## Example application

For a telemetry-flow learning session, a strong file order is often:

1. `services/kings_cross/rest/service/client_telemetry.go`
2. `services/kings_cross/rest/common.go`
3. `services/kings_cross/specs_db/models.go`
4. `services/kings_cross/specs_db/pg.go`
5. route wiring such as `services/kings_cross/new_main.go`

Adjust the order if the user's question is more about routing, storage, or a
specific incorrect status.
