# d-spec Agent Instructions

This folder contains the d-spec planning workflow and links to the onboarding docs used by agents.

## Start Here

- Use this file for the high-level planning → execution workflow.
- Use `.d-spec/onboarding/` for detailed step-by-step guides.

## End-to-End Workflow (Ideation → Spec → Beads → Implement)

### Planning Phase
1. **Create idea doc**: capture intent and scope with `AskUserTool`; save in `.d-spec/planning/ideas/` (see `.d-spec/onboarding/create-ideas.md`).
2. **Add to plan**: record the idea as an unimplemented/future item in `.d-spec/*master-plan*.md` and/or `.d-spec/roadmap.md`.
3. **Discovery (read-only)**: read `.d-spec/*master-plan*.md`, `.d-spec/project.md`, `.d-spec/roadmap.md`, `.d-spec/standards.md`, then review `.d-spec/planning/ideas/` (see `.d-spec/onboarding/discovery-to-spec.md`).
4. **Interview (AskUserTool)**: ask one question at a time, option-based; stop and wait for answers (see `.d-spec/onboarding/discovery-to-spec.md`).
5. **Draft change (d-spec)**: create `.d-spec/planning/changes/<change-id>/` (verb-led, date-stamped) and write `proposal.md`, `tasks.md`, and spec deltas under `specs/` (see `.d-spec/onboarding/discovery-to-spec.md`). Existing non-dated change IDs are grandfathered; new changes must use the date-stamped format.
6. **Validate**: run `d-spec validate <change-id> --strict`; ensure each new/modified requirement has ≥1 scenario.
7. **Link + archive idea**: add bidirectional YAML links between idea and change, then move the idea to `.d-spec/planning/ideas/archive/` (see `.d-spec/onboarding/archive-instructions.md`).
8. **Approval gate**: do not create Beads issues or implement until the user approves the proposal in chat.

### Execution Phase
9. **Beads handoff (after approval)**: before creating Beads issues, read `.d-spec/project.md` plus the change’s `proposal.md`, `design.md` (if present), all `specs/**/spec.md`, and `tasks.md`. Then create a **detailed** Beads epic + tasks per `bd prime` and add `Beads: <epic-id>` to `.d-spec/planning/changes/<change-id>/proposal.md`.
10. **Archive change doc**: move the change to `.d-spec/planning/archive/` with YAML traceability once the Beads epic exists.
11. **Implement via Beads**: execute Beads tasks sequentially and update Beads statuses/fields as you work. Do **not** update `.d-spec/planning/changes/<change-id>/tasks.md` during implementation (d-spec is frozen after approval).
12. **Wrap up**: follow the session completion checklist in root `AGENTS.md`.

## d-spec → Beads Handoff (Explicit Requirements)

- Do not create Beads issues until the proposal is approved in chat.
- Before creating Beads issues, **must read**:
  - `.d-spec/project.md`
  - `.d-spec/planning/changes/<change-id>/proposal.md`
  - `.d-spec/planning/changes/<change-id>/design.md` (if present)
  - `.d-spec/planning/changes/<change-id>/specs/**/spec.md`
  - `.d-spec/planning/changes/<change-id>/tasks.md`
- After Beads creation, execution tracking happens only in Beads; d-spec remains read-only.

## Entrypoints

- Project setup (docs ideation structure): `.d-spec/onboarding/project-setup.md`
- Discovery → Spec → Beads → Implement: `.d-spec/onboarding/discovery-to-spec.md`
- Brownfield intake (existing docs/specs): `.d-spec/onboarding/brownfield-intake.md`
- Archiving processed ideas: `.d-spec/onboarding/archive-instructions.md`
- Creating new idea docs (YAML + AskUserTool): `.d-spec/onboarding/create-ideas.md`
- Creating/updating the master plan: `.d-spec/onboarding/create-master-vision.md`
- Defining project standards: `.d-spec/onboarding/create-standards.md`
- Creating a vision doc: `.d-spec/onboarding/create-vision.md`
- Creating/updating a roadmap: `.d-spec/onboarding/create-roadmap.md`

## Directory Anchors (Project Convention)

- North star: `.d-spec/*master-plan*.md`
- Project overview: `.d-spec/project.md`
- Standards: `.d-spec/standards.md`
- Roadmap: `.d-spec/roadmap.md`
- Ideas (intake): `.d-spec/planning/ideas/`
- Ideas (archive): `.d-spec/planning/ideas/archive/`
- Changes (proposals): `.d-spec/planning/changes/`
- Archived changes: `.d-spec/planning/archive/`
