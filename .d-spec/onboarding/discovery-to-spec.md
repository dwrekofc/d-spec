# Discovery → d-spec → Beads (Proposal → Execution)

This doc is the detailed procedure behind the “Discovery → Spec → Beads → Implement” section in `AGENTS.md`.

## Triggers

Use this workflow when the user asks for a workflow, proposal, spec, plan, or to turn ideas into implementation tasks.

## Inputs

- North star (read first): `.d-spec/*master-plan*.md`
- Project overview: `.d-spec/project.md`
- Roadmap: `.d-spec/roadmap.md`
- Standards: `.d-spec/standards.md`
- Intake ideas: `.d-spec/planning/ideas/*.md`
- Existing changes: `.d-spec/planning/changes/`
- Archived changes (context): `.d-spec/planning/archive/`

## Outputs

- d-spec change: `.d-spec/planning/changes/<change-id>/...` (proposal + specs for approval)
- Beads epic + tasks (only after chat approval; **execution source of truth**)
- Archived idea doc with YAML traceability (only after chat approval)

## Workflow

### 1) Discovery (read-only)

1. Read the master plan doc in `.d-spec/` (first match for `*master-plan*.md`).
2. Read `.d-spec/project.md`, `.d-spec/roadmap.md`, and `.d-spec/standards.md`.
3. Enumerate idea docs in `.d-spec/planning/ideas/` and select 3–5 candidate ideas to summarize.
4. Summarize candidates and ask the user to pick which one to process next.

Notes:
- Prefer `rg --files -g'*.md'` for enumeration and `rg -n "TODO|FIXME|NEEDS"` for gaps.
- If the chosen idea overlaps an existing change in `.d-spec/planning/changes/`, surface the overlap and ask the user to decide case-by-case.

### 2) Interview (clarify scope)

Use `AskUserTool` for all user interviews and context gathering:
- Ask one question at a time
- Provide 2–4 concrete options with tradeoffs
- Stop and wait for the answer

Target questions:
- scope boundaries (in/out)
- priority ordering
- breaking changes and migrations
- impacted capabilities (multi-cap allowed)

### 3) Draft d-spec change (no Beads yet)

1. Choose a verb-led, date-stamped change id: `<verb>-<slug>-YYYY-MM-DD`. Existing non-dated change IDs are grandfathered; new changes must use the date-stamped format.
2. Scaffold:
   - `.d-spec/planning/changes/<change-id>/proposal.md`
   - `.d-spec/planning/changes/<change-id>/tasks.md` (approval-level checklist; not execution source)
   - `.d-spec/planning/changes/<change-id>/specs/<capability>/spec.md` deltas (one per impacted capability)
   - `.d-spec/planning/changes/<change-id>/design.md` when needed
3. Ensure each new/modified requirement includes at least one scenario.
4. Run: `d-spec validate <change-id> --strict` and fix issues.

Approval gate:
- Do not generate Beads issues or start implementation until the user approves the proposal in chat.

### 4) After chat approval

1. **Required reads before Beads**:
   - `.d-spec/project.md`
   - `.d-spec/planning/changes/<change-id>/proposal.md`
   - `.d-spec/planning/changes/<change-id>/design.md` (if present)
   - `.d-spec/planning/changes/<change-id>/specs/**/spec.md`
   - `.d-spec/planning/changes/<change-id>/tasks.md`
2. Decompose the approved proposal/specs/tasks into a **detailed** Beads epic + tasks per `bd prime` (each task must include a clear description and acceptance criteria; expand beyond `tasks.md` as needed).
3. Add traceability:
   - Add `Beads: <epic-id>` to `.d-spec/planning/changes/<change-id>/proposal.md`
   - Add bidirectional YAML links between the idea doc and change
4. Archive the processed idea doc (see `.d-spec/onboarding/archive-instructions.md`) and fill `beads_epic_id` in the YAML header.
5. Freeze d-spec: do not update `.d-spec/planning/changes/<change-id>/tasks.md` during implementation; all execution tracking happens in Beads.
