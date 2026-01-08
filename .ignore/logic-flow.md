# d-spec Logic / File Flow (Progressive Disclosure)

```text
ENTRY
└── AGENTS.md
    ├── Planning (d-spec)
    │   └── .d-spec/AGENTS.md
    │       ├── Canonical discovery docs (read-first)
    │       │   ├── .d-spec/*master-plan*.md
    │       │   ├── .d-spec/project.md
    │       │   ├── .d-spec/standards.md
    │       │   └── .d-spec/roadmap.md
    │       ├── Onboarding modules (detail procedures)
    │       │   ├── .d-spec/onboarding/create-ideas.md
    │       │   │   ├── OUTPUT: .d-spec/planning/ideas/<idea>.md
    │       │   │   └── ALSO UPDATE: .d-spec/*master-plan*.md and/or .d-spec/roadmap.md
    │       │   ├── .d-spec/onboarding/discovery-to-spec.md
    │       │   │   ├── INPUTS: .d-spec/*master-plan*.md + project/roadmap/standards + ideas/
    │       │   │   ├── OUTPUT: .d-spec/planning/changes/<change-id>/
    │       │   │   └── AFTER APPROVAL: Beads handoff + idea archive
    │       │   ├── .d-spec/onboarding/archive-instructions.md
    │       │   │   └── MOVE: .d-spec/planning/ideas/<idea>.md → .d-spec/planning/ideas/archive/<idea>.md
    │       │   ├── .d-spec/onboarding/project-setup.md
    │       │   ├── .d-spec/onboarding/create-roadmap.md
    │       │   ├── .d-spec/onboarding/create-master-vision.md
    │       │   ├── .d-spec/onboarding/create-standards.md
    │       │   └── .d-spec/onboarding/create-vision.md
    │       ├── Planning artifacts (working set)
    │       │   └── .d-spec/planning/
    │       │       ├── ideas/
    │       │       │   └── archive/
    │       │       ├── changes/
    │       │       │   └── <change-id>/
    │       │       │       ├── proposal.md  (write back: "Beads: <epic-id>" after handoff)
    │       │       │       ├── tasks.md     (approval-level; frozen after Beads)
    │       │       │       ├── design.md    (optional)
    │       │       │       └── specs/<capability>/spec.md
    │       │       └── archive/             (archived changes after epic exists)
    │       └── Optional command prompts (wrappers)
    │           └── .d-spec/commands/
    │               ├── d-spec-proposal.md
    │               ├── d-spec-apply.md
    │               ├── d-spec-archive.md
    │               └── beads-*.md
    └── Execution (Beads = source of truth)
        ├── Read workflow: bd prime
        ├── Find work: bd ready
        ├── Work: bd show / bd update / bd close
        └── Sync: bd sync
```

# REVISED LOGIC FLOW

```text
ENTRY (minimal router)
└── AGENTS.md
    ├── If planning/spec work → open .d-spec/AGENTS.md
    ├── If execution work → follow Beads (bd prime → bd ready → bd show/update/close → bd sync)
    └── Session end → landing-the-plane (git pull --rebase → bd sync → git push)

PLANNING ROUTER (minimal, phase + gates)
└── .d-spec/AGENTS.md
    ├── Phase selection (just-in-time)
    │   ├── Setup / standardize repo → .d-spec/onboarding/project-setup.md
    │   ├── Create idea → .d-spec/onboarding/create-ideas.md
    │   ├── Discovery → .d-spec/onboarding/discovery-to-spec.md
    │   ├── Archive idea → .d-spec/onboarding/archive-instructions.md
    │   ├── Roadmap → .d-spec/onboarding/create-roadmap.md
    │   ├── Master plan → .d-spec/onboarding/create-master-vision.md
    │   └── Standards / vision → .d-spec/onboarding/create-standards.md / create-vision.md
    ├── Hard gates (kept short here)
    │   ├── Approval gate (no Beads until explicit chat approval)
    │   └── Beads handoff preread gate (must read project.md + change docs)
    └── Canonical “read-first” docs (referenced, not embedded)
        ├── .d-spec/*master-plan*.md
        ├── .d-spec/project.md
        ├── .d-spec/standards.md
        └── .d-spec/roadmap.md

DETAIL PROCEDURES (step-by-step only)
└── .d-spec/onboarding/
    ├── create-ideas.md
    ├── discovery-to-spec.md
    ├── archive-instructions.md
    ├── project-setup.md
    ├── create-roadmap.md
    ├── create-master-vision.md
    ├── create-standards.md
    └── create-vision.md

REFERENCE MODULES (stable rules; opened only when needed)
└── .d-spec/reference/
    ├── templates.md
    │   ├── Idea YAML template
    │   ├── proposal.md skeleton
    │   ├── tasks.md skeleton
    │   ├── design.md skeleton
    │   └── Beads task template (single canonical copy)
    ├── change-ids.md
    ├── change-folder-structure.md
    ├── spec-deltas-format.md
    ├── design-md-criteria.md
    ├── validation-and-troubleshooting.md
    ├── beads-handoff-standard.md
    └── archive-rules.md

PLANNING ARTIFACTS (examples / working set)
└── .d-spec/planning/
    ├── ideas/
    │   └── archive/
    ├── changes/
    │   └── <change-id>/
    │       ├── proposal.md
    │       ├── tasks.md
    │       ├── design.md
    │       └── specs/<capability>/spec.md
    └── archive/

OPTIONAL PROMPT WRAPPERS (thin; point to onboarding/reference)
└── .d-spec/commands/
    ├── d-spec-proposal.md  → open onboarding + reference modules
    ├── d-spec-apply.md     → open change docs + beads-handoff-standard.md
    ├── d-spec-archive.md   → open archive-rules.md
    └── beads-*.md          → bd commands (no duplicated policy)
```

# REVISED LOGIC FLOW
