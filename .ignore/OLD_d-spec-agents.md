# Agent Instrucitons
this file contains instructions for the agent on how to work in this folder and understand the combined d-spec planning and beads execution workflow.

## Start Here
This folder contains deeper, reusable workflow docs referenced from `AGENTS.md`.

## End-to-End Workflow (Discovery → Spec → Beads → Implement)

### Planning Phase
1. **Discovery (read-only)**: read the north star (`docs/*master-plan*.md`) and skim candidates in `docs/ideas/` (`.d-spec/discovery-to-spec.md`).
2. **Interview (AskUserTool)**: ask one question at a time, option-based; stop and wait for answers (`.d-spec/discovery-to-spec.md`).
3. **Draft Spec (d-spec)**: create `d-spec/changes/<change-id>/` (verb-led, date-stamped) and write `proposal.md`, `tasks.md`, and spec deltas (`d-spec/AGENTS.md` Stage 1). Existing non-dated change IDs are grandfathered; new changes must use the date-stamped format.
4. **Validate**: run `d-spec validate <change-id> --strict`; ensure each new/modified requirement has ≥1 scenario (`d-spec/AGENTS.md`).
5. **Approval Gate**: do not create Beads issues or implement until the user approves the proposal in chat.

### Execution Phase
6. **Beads (after approval)**: decompose the approved d-spec proposal/specs/tasks into a **detailed** Beads epic + tasks per `bd prime` (each task must have a clear description and acceptance criteria). Add `Beads: <epic-id>` to `d-spec/changes/<change-id>/proposal.md`. After this step, **Beads is the source of truth**.
7. **Archive Idea (after approval)**: move `docs/ideas/<idea>.md` → `docs/archive/<idea>.md` and prepend YAML traceability keys (including `beads_epic_id`) (`.d-spec/archive-instructions.md`).
8. **Implement**: execute Beads tasks sequentially and update Beads statuses/fields as you work. Do **not** update `d-spec/changes/<change-id>/tasks.md` during implementation (d-spec is frozen after approval).
9. **Wrap Up**: follow the session completion checklist (below).


## d-spec → Beads Handoff

- Use d-spec only to draft/iterate proposals, specs, and approval-level tasks.
- Do not create Beads issues until the proposal is approved in chat.
- After approval, decompose into **detailed** Beads epics/tasks and make Beads the **single source of truth** for execution.
- Freeze d-spec after Beads creation; do not update `d-spec/changes/<change-id>/tasks.md` during implementation.

## Beads Task Template (use for every task)

```text
Title: <concise action>
Description: <what/why; 2-4 sentences>
Acceptance Criteria:
- [ ] <observable outcome>
- [ ] <test or verification>
Dependencies: <beads ids or "none">
Notes: <risks, edge cases, or references>
```

## Gates

- **Approval**: d-spec proposals require explicit chat approval before Beads creation or implementation.
- **Spec hygiene**: `d-spec validate <change-id> --strict` must pass before requesting approval.
- **Beads handoff**: once Beads is created, execution tracking happens only in Beads; d-spec remains read-only.
- **Archiving clarity**: idea docs are archived after approval; d-spec change folders are archived after execution.
- **Session completion**: work is not done until `git push` succeeds (see Wrap Up).


## Reference (d-spec; managed)

Consult this when drafting or validating d-spec changes; the workflow above is primary.

<!-- d-spec:START -->
# d-spec Instructions

These instructions are for AI assistants working in this project.

Open `@/d-spec/AGENTS.md` when a request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Is ambiguous and you need the authoritative d-spec format/conventions before drafting

Use `@/d-spec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

<!-- d-spec:END -->

## Entrypoints

- Project setup (docs ideation structure): `.d-spec/project-setup.md`
- Discovery → Spec → Beads → Implement: `.d-spec/discovery-to-spec.md`
- Brownfield intake (existing docs/specs): `.d-spec/brownfield-intake.md`
- Archiving processed ideas: `.d-spec/archive-instructions.md`
- Creating new idea docs (YAML + AskUserTool): `.d-spec/create-ideas.md`
- Creating/updating the master plan: `.d-spec/create-master-plan.md`
- Defining project standards: `.d-spec/create-standards.md`
- Creating a vision doc: `.d-spec/create-vision.md`
- Creating/updating a roadmap: `.d-spec/create-roadmap.md`

## Directory Anchors (Project Convention)

- North star: `docs/*master-plan*.md`
- Intake: `docs/ideas/`
- Archive: `docs/archive/`
- Specs (truth): `openspec/specs/`
- Proposals (changes): `openspec/changes/`
