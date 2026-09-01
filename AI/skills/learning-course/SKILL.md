---
name: learning-course
description: Create structured, guided project courses for self-directed learning. Use when user wants to learn a topic by building, needs a learning path, COURSE.md, phased curriculum with concepts, builds, verification and checkpoints. Supports creating many courses for a learning management platform.
---

# Learning Course — Guided Project Course Builder

## Goal

Turn any "I want to learn X by building Y" into a **phased, minimal, build-as-you-learn course** that lives in `COURSE.md`. Each course teaches one thing at a time, proves it with a runnable checkpoint, and makes the learner explain it back before moving on.

This skill is for your learning management platform — you will reuse it to spin up many learning paths (e.g., nxtedit, Zig, Rust, compilers, databases) with consistent structure.

## When to Use

- User says "I want to learn ..." / "prepare a learning plan" / "create a course for ..."
- User wants to build a project to understand internals (editor, DB, compiler, OS, network, etc.)
- User wants `COURSE.md` or `LEARNING.md` with phases, tasks, verification
- You need to scaffold a new repo with a guided path

## Core Workflow

### 1. Clarify Before Writing (ask 2-4 questions if not already known)

- **Outcome:** What will they have built at the end? (runnable artifact, not "understood X")
- **Constraints:** Language/stack? Minimal vs production-grade? Superfast/small vs feature-rich?
- **Level:** Beginner / intermediate / advanced in that domain? Adjust depth.
- **Time:** Hours/week and total duration? Controls phase count/size.
- **Why:** What "behind the scenes" do they care about? (allocators, syscalls, protocol, algorithms)

Do not guess. If they said "Go for now, Zig later" — respect it. Record decision in `COURSE.md:Overview`.

### 2. Design the Course Structure

Every course gets:

```markdown
# {PROJECT} — {Tagline}
### A Guided Project Course: Learn by Building From Scratch in {STACK}

> Goal, Method, Truth Flow

## 0. Course Overview
  0.1 Philosophy (3 rules max)
  0.2 What "Done" Means (measured targets table)
  0.3 Prerequisites
  0.4 Repo Structure You Will Build (tree)
  0.5 How to Use This Course (Concept -> Build -> Verify -> Trap -> Come back)

## Phase 0: Foundations (always first)
  Concepts, Reading (30 min max), Build (one file, <100 lines), Verify, Trap, Come back and tell me
## Phase 1..N: Core Layers (in dependency order)
## Phase N+1: Essentials (file I/O, undo, persist, etc.)
## Phase N+2: Performance & Polish (bench, profile, zero-alloc)
## Phase N+3: Dynamic Modules / Plugins (if requested, WASM vs Lua vs dlopen tradeoffs)
## Phase N+4: Extensions (pick 1/week, keeps minimal)
## Appendix A: Reference (grammar, commands, cheat sheet)
## Appendix B: Debugging Checklist
## Appendix C: Daily Ritual
## Your Next Action
```

**Phase sizing rules:**
- 1 phase = 1-3 days, 1-2 files, <250 lines, one verifiable checkpoint
- No phase without `Verify` ( `go test`, `bench`, manual demo)
- No phase without `Trap` (common mistake that makes it slow/buggy)
- No phase without `Come back and tell me:` (3 questions that force explanation)

### 3. Choose File Order (dependency order)

Prefer:
1.  Where truth is **produced** (data/storage/buffer)
2.  Where truth is **transported** (state machine / core types)
3.  Where truth is **interpreted** (parser, motions, query engine)
4.  I/O boundary (raw mode, network, FS)
5.  Rendering / output
6.  Event loop / wiring
7.  Cross-cutting (undo, plugins, config)

If topic is debugging/misleading output, use chain: `observed -> emitted -> transported -> stored -> classified -> user-facing`.

### 4. Write `COURSE.md`

- Path: `{projectRoot}/COURSE.md` (or `LEARNING.md` if repo already has COURSE.md). Ask if ambiguous via `@path`.
- Use full file reads before edits if file exists.
- Keep each phase's `Build` as a code skeleton with `File: path (lines)` + `Tasks in order` — learner implements, not you.
- Add `Benchmark` or `Measure` targets for "superfast/minimal" courses.
- For plugin/dynamic-module requests: document `dlopen` vs `go-plugin RPC` vs `Lua` vs `WASM (wazero)` with table, then commit to one and scaffold `plugin/api.go, loader.go, registry.go`.

### 5. Teach Stepwise After Scaffolding

Do not dump whole course verbally. Switch to stepwise mode:

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

Validate reply: what is right, what is missing, hint don't dump. Stay on same file until understood.

### 6. Track Progress (for LMS)

Suggest the learner keeps `PROGRESS.md` or issues/tasks:

```markdown
- [ ] Phase 0: Foundations — 2026-08-22
- [ ] Phase 1: Buffer
```

Or integrate with your LMS: each phase = one module with `status: pending|in_progress|completed`, `verify: go test ...`.

## Writing Rules

- **Minimal = Fast:** Every abstraction needs proof. Call out cost.
- **Measured, not guessed:** Targets table with metric, target, how achieved.
- **One file at a time:** Never teach 3 files in one step.
- **Distinguish Produces / Transports / Interprets** in every phase header.
- **No magic:** Every `Build` task explains *why* line exists.
- **Traps are mandatory:** e.g., "Using `len(string)` bytes vs runes breaks `w` on emoji" or "Growing gap by 1 = O(n²)".
- **Keep LOC budget:** State total (e.g., `<5k LOC`, `<10 files`) and keep it.

## Templates

### Phase Template

```markdown
## Phase N: Title (Day X-Y, ~H hours)

> One-line why this phase matters.

### Concepts
1. ...
2. ...

### Reading (30 min)
- ...

### Build
**File: `path/file.go` (N lines)**
```go
type Foo struct { ... }
func New(...) ...
```

**Tasks in order:**
1. ...
2. ...

### Verify
```bash
go test ./... -run TestFoo
```

### Trap
...

### Come back and tell me:
- ...
- ...
```

### Plugin Phase Template (when requested)

Include tradeoff table, choose `WASM + wazero` for Go (pure Go, sandboxed, hot reload) vs `Lua` for simplicity. Scaffold `api.go` (contract + api_version + caps), `loader.go` (CompileModule → Instantiate → plugin_init), `registry.go` (OnKey/OnSave fan-out, HotReload). Example plugins: `hello.wasm`, `fmt-on-save.wasm`.

## Example Courses to Generate

- `nxtedit` — Vim motions, gap buffer, raw mode, diff renderer, WASM plugins (Go) — reference: `/nxtedit/COURSE.md`
- `zig-from-go` — Allocators, comptime, `termios` without `x/term`, manual memory
- `db-from-scratch` — B-Tree, WAL, MVCC, SQL parser
- `compiler` — Lexer → Parser → IR → Codegen

## Output

After creating `COURSE.md`, respond with:

- Path to course
- Phase count + total hours
- Repo tree preview
- Next action: `start phase 0` → stepwise `Look at file` mode

## Integration Notes for LMS

- Each `COURSE.md` phase maps to 1 LMS module.
- `Verify` block maps to automated check (`go test` / `bench`).
- `Come back and tell me:` maps to review gate (learner must answer before unlock next module).
- Store courses under `~/learning/courses/{slug}/COURSE.md` if you centralize, or per-project root.

## File Location

This skill lives at `~/.agents/learning-course/SKILL.md` and is also linked at `~/.agents/skills/learning-course/SKILL.md` for opencode discovery.

