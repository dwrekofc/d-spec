# Project Setup (Ideation Docs Structure)

Use this workflow when bootstrapping a project (or standardizing an existing one) for the ideation → d-spec → Beads process.

All user interviews and context gathering MUST be facilitated with `AskUserTool`.

## Target Structure

Create (or confirm) the following:

- `.d-spec/` (planning + standards)
  - `.d-spec/*master-plan*.md` (north star; agent reads first)
  - `.d-spec/project.md` (project conventions)
  - `.d-spec/standards.md` (project standards)
  - `.d-spec/roadmap.md` (optional but preferred)
  - `.d-spec/vision.md` (optional)
  - `.d-spec/planning/ideas/` (intake ideas and half-formed specs)
  - `.d-spec/planning/ideas/archive/` (processed ideas; archived after approval)
  - `.d-spec/planning/changes/` (change proposals)
  - `.d-spec/planning/archive/` (archived changes)

## Setup Steps

1. **Create folders**: ensure `.d-spec/planning/ideas/`, `.d-spec/planning/ideas/archive/`, `.d-spec/planning/changes/`, and `.d-spec/planning/archive/` exist.
2. **Create/choose master plan**:
   - Ensure one file in `.d-spec/` contains `master-plan` in the filename.
   - Keep it concise and stable (see `.d-spec/onboarding/create-master-vision.md`).
3. **Create standards**:
   - Ensure `.d-spec/standards.md` exists and contains defaults an agent can apply (see `.d-spec/onboarding/create-standards.md`).
4. **Set idea intake conventions**:
   - New idea docs go in `.d-spec/planning/ideas/` with filename `YYYY-MM-DD-<verb>-<slug>.md`.
   - Use the minimal YAML frontmatter (see `.d-spec/onboarding/create-ideas.md`).
5. **Reconcile legacy markdown (if any)**:
   - If there are root-level or miscellaneous markdown docs, use `AskUserTool` to decide whether each is:
     - a new idea → move into `.d-spec/planning/ideas/`
     - historical → move into `.d-spec/planning/ideas/archive/`
     - standards/master-plan content → merge into the canonical doc

## Exit Criteria

- Master plan is discoverable via `.d-spec/*master-plan*.md`
- Idea intake location and naming is established (`.d-spec/planning/ideas/`)
- Archive location exists (`.d-spec/planning/ideas/archive/`)
- Standards exist (`.d-spec/standards.md`)
