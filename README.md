# d-spec

> A planning-first workflow for AI-assisted development

## What is d-spec?

**d-spec** is a structured planning framework that separates **ideation** from **execution** with explicit approval gates. It provides AI agents with a consistent workflow for capturing ideas, drafting proposals, validating specs, and handing off to execution systems like [Beads](https://github.com/steveyegge/beads).

**Core principles:**
- **Planning is frozen after approval** - d-spec becomes read-only once work begins
- **Execution happens elsewhere** - Beads (or similar) tracks implementation progress
- **TDD-first** - Tasks encode test-first acceptance criteria
- **Explicit gates** - User approval required before creating implementation tasks

## Installation

```bash
brew tap dwrekofc/d-spec
brew install d-spec
```

## Quick Start

```bash
# Initialize d-spec in your project
d-spec init

# Initialize d-spec in current project
d-spec init [--force]

# Update templates to latest version
 d-spec update
 
 # Show version info
 d-spec version
 
 # Show help
 d-spec help

```

## Architecture

```
your-project/
├── CLAUDE.md                      # Root agent instructions (required)
└── .d-spec/
    ├── AGENTS.md                  # Workflow guide for agents
    ├── CLAUDE.md                  # d-spec-specific agent config
    ├── *-master-plan.md           # North star vision (glob pattern)
    ├── project.md                 # Project conventions & standards (template)
    ├── roadmap.md                 # Implementation roadmap (template)
    │
    ├── commands/                  # Slash command templates
    │   ├── d-spec-*.md            # Planning commands (15 files)
    │   └── beads-*.md             # Execution commands (28 files)
    │
    ├── onboarding/                # Step-by-step workflow guides
    │   ├── project-setup.md       # Bootstrap d-spec in a project
    │   ├── discovery-to-spec.md   # Full planning workflow (key doc)
    │   ├── create-ideas.md        # Idea capture process
    │   ├── create-master-vision.md
    │   ├── create-roadmap.md
    │   ├── create-standards.md
    │   ├── vision-doc.md
    │   ├── brownfield-intake.md
    │   └── archive-instructions.md
    │
    └── planning/
        ├── specs/                 # Official specs - source of truth
        │   └── [capability]/      # One folder per capability
        │       └── spec.md        # Requirements + scenarios
        │
        ├── changes/               # Proposals (frozen after Beads handoff)
        │   └── [change-id]/       # Format: verb-slug-YYYY-MM-DD
        │       ├── proposal.md    # Why, what, impact
        │       ├── tasks.md       # Implementation checklist (TDD-encoded)
        │       ├── design.md      # Technical decisions (optional)
        │       └── specs/         # Spec deltas
        │           └── [capability]/
        │               └── spec.md  # ADDED/MODIFIED/REMOVED
        │
        ├── ideas/                 # Intake for new ideas
        │   └── archive/           # Processed ideas (with traceability)
        │
        └── archive/               # Completed change proposals
```

## Workflow Phases

### Phase 1: Ideation
- Capture raw ideas in `.d-spec/planning/ideas/`
- Interview users for ideas/vision
- Add to roadmap as potential changes

### Phase 2: Proposal
- Create change folder: `.d-spec/planning/changes/<change-id>/`
- Write `proposal.md`, `tasks.md`, and spec deltas
- Encode TDD in tasks (Red -> Green -> Refactor)
- Validate with

**Gate: User approval required before proceeding**

### Phase 3: Spec Merge
- Merge approved deltas into `.d-spec/planning/specs/`
- Create Spec Sync commit
- Validate merged specs pass all checks

**Gate: Validation must pass before execution**

### Phase 4: Execution (Beads)
- Create Beads epic + tasks from approved specs
- Archive change to `.d-spec/planning/archive/` as soon as it is captured faithfully in great detail in the beads issue
- d-spec becomes **read-only** (frozen)
- Track all implementation progress in Beads only


## Key Concepts

| Concept | Description |
|---------|-------------|
| **d-spec** | Planning phase: ideas, proposals, specs. Frozen after approval. |
| **Beads** | Execution phase: epics, tasks, progress. Source of truth for implementation. |
| **Spec Delta** | Changes marked as ADDED/MODIFIED/REMOVED in proposal's `specs/` folder. |
| **Official Spec** | Merged deltas in `planning/specs/` - the canonical requirements. |
| **Approval Gate** | User must approve proposal before Beads creation. |
| **Spec Merge Gate** | Deltas must be merged + validated before execution begins. |
| **TDD Encoding** | Tasks include test-first acceptance criteria and Red->Green->Refactor structure. |
