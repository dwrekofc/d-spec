# d-spec Instructions

Instructions for AI coding assistants using d-spec for spec-driven development.

## TL;DR Quick Checklist

- Search existing work: use `rg` only for full-text search
- Decide scope: new capability vs modify existing capability
- Pick a unique `change-id`: kebab-case, verb-led, date-stamped (`add-`, `update-`, `remove-`, `refactor-`), format `<verb>-<slug>-YYYY-MM-DD`. Existing non-dated change IDs are grandfathered; new changes must use the date-stamped format.
- Scaffold: `proposal.md`, `tasks.md`, `design.md` (only if needed), and delta specs per affected capability
- Write deltas: use `## ADDED|MODIFIED|REMOVED|RENAMED Requirements`; include at least one `#### Scenario:` per requirement

- Request approval: Do not start implementation until proposal is approved

## Three-Stage Workflow

### Stage 1: Creating Changes
Create proposal when you need to:
- Add features or functionality
- Make breaking changes (API, schema)
- Change architecture or patterns  
- Optimize performance (changes behavior)
- Update security patterns

Triggers (examples):
- "Help me create a change proposal"
- "Help me plan a change"
- "Help me create a proposal"
- "I want to create a spec proposal"
- "I want to create a spec"

Loose matching guidance:
- Contains one of: `proposal`, `change`, `spec`
- With one of: `create`, `plan`, `make`, `start`, `help`

Skip proposal for:
- Bug fixes (restore intended behavior)
- Typos, formatting, comments
- Dependency updates (non-breaking)
- Configuration changes
- Tests for existing behavior

**Workflow**
1. Review `.d-spec/project.md` and `.d-spec/planning/changes/` to understand current context.
2. Choose a unique verb-led, date-stamped `change-id` and scaffold `proposal.md`, `tasks.md`, optional `design.md`, and spec deltas under `.d-spec/planning/changes/<id>/`.
3. Draft spec deltas using `## ADDED|MODIFIED|REMOVED Requirements` with at least one `#### Scenario:` per requirement.

**Before Creating Specs:**
- Always check if a similar change already exists in `.d-spec/planning/changes/` or `.d-spec/planning/archive/`
- Prefer modifying an existing change (or creating a follow-on change) over duplicating requirements
- If the request is ambiguous, ask clarifying questions before scaffolding


### Stage 2: Create Beads Epics and Tasks
Track these steps as TODOs and complete them one by one.
1. **Read proposal.md** - Understand what's being built
2. **Read design.md** (if exists) - Review technical decisions
3. **Read tasks.md** - Get implementation checklist
4. **Read relevant specs** in `.d-spec/planning/changes/<change-id>/specs/[capability]/spec.md`
5. Read `.d-spec/project.md` for conventions
6. **Review for conflicts** and clarify with user
7. **Convert to Epics and Tasks in Beads** - Create an epic and tasks from the approved proposal; each task must include type, priority, status, description, explicit dependencies (beads IDs or "none"), acceptance criteria (observable outcomes + verification), and notes as needed (use the template in `AGENTS.md`)
8. **Definition of "correct and complete" Beads task** - Every task has full metadata, description, acceptance criteria, dependencies, and notes where needed
9. **Have we met that standard?** - If not, fix before execution:
   - Backfill every task with Description + Acceptance Criteria using the template in `AGENTS.md`
   - Add real dependencies between tasks (not just the epic) where sequencing matters
10. **Execution gate** - Do not start implementation until the proposal is approved and Beads tasks meet the standard above

### Stage 3: Archiving d-spec Changes
After successfully executing Beads epics/tasks (and any required deployment), create a separate PR to:
- Confirm all Beads tasks are closed and acceptance criteria verified, then run `bd sync`
- Move `.d-spec/planning/changes/[name]/` → `.d-spec/planning/archive/YYYY-MM-DD-[name]/`
- Confirm archived change specs under `.d-spec/planning/archive/` are correct
Note: This is separate from archiving idea docs in `.d-spec/planning/ideas/archive/`, which happens after proposal approval.



### Search Guidance
- Show details:
- Full-text search (use ripgrep): `rg -n "Requirement:|Scenario:" .d-spec/planning/changes .d-spec/planning/archive`


## Directory Structure

```
```
AGENTS.md
requirements.txt
.d-spec/
├── AGENTS.md
├── master-plan.md              # Overarching product vision and direction
├── project.md                  # Project conventions & standards
├── README.md                   
├── roadmap.md                  # 
├── commands/                   # Agent prompts/commands
├── onboarding/                 # d-spec workflow instructions
└── planning/
    ├── specs/                  # Current truth - what IS built
    │   └── [capability]/       # Single focused capability
    │       ├── spec.md         # Requirements and scenarios
    │           └── design.md   # Technical patterns
    ├── changes/                # Proposals - what SHOULD change
    │   ├── [change-name]/
    │   │   ├── proposal.md     # Why, what, impact
    │   │   ├── tasks.md        # Implementation checklist
    │   │   ├── design.md       # Technical decisions (optional; see criteria)
    │   │   └── specs/          # Delta changes
    │   │       └── [capability]/
    │   │           └── spec.md # ADDED/MODIFIED/REMOVED
    │   └── archive/            # Completed changes
    └── ideas/                  # New ideation, not ready for proposals
        └── archive/            # Completed or discarded ideas
```

```

### Decision Tree

```
New request?
├─ Bug fix restoring spec behavior? → Fix directly
├─ Typo/format/comment? → Fix directly  
├─ New feature/capability? → Create proposal
├─ Breaking change? → Create proposal
├─ Architecture change? → Create proposal
└─ Unclear? → Create proposal (safer)
```

### Proposal Structure

1. **Create directory:** `.d-spec/planning/changes/[change-id]/` (kebab-case, verb-led, date-stamped, unique)

2. **Write proposal.md:**
```markdown
# Change: [Brief description of change]

## Why
[1-2 sentences on problem/opportunity]

## What Changes
- [Bullet list of changes]
- [Mark breaking changes with **BREAKING**]

## Impact
- Affected specs: [list capabilities]
- Affected code: [key files/systems]
```

3. **Create spec deltas:** `.d-spec/planning/changes/[change-id]/specs/[capability]/spec.md`
```markdown
## ADDED Requirements
### Requirement: New Feature
The system SHALL provide...

#### Scenario: Success case
- **WHEN** user performs action
- **THEN** expected result

## MODIFIED Requirements
### Requirement: Existing Feature
[Complete modified requirement]

## REMOVED Requirements
### Requirement: Old Feature
**Reason**: [Why removing]
**Migration**: [How to handle]
```
If multiple capabilities are affected, create multiple delta files under `.d-spec/planning/changes/[change-id]/specs/<capability>/spec.md`—one per capability.

4. **Create tasks.md:**
```markdown
## 1. Implementation
- [ ] 1.1 Create database schema
- [ ] 1.2 Implement API endpoint
- [ ] 1.3 Add frontend component
- [ ] 1.4 Write tests
```

5. **Create design.md when needed:**
Create `design.md` if any of the following apply; otherwise omit it:
- Cross-cutting change (multiple services/modules) or a new architectural pattern
- New external dependency or significant data model changes
- Security, performance, or migration complexity
- Ambiguity that benefits from technical decisions before coding

Minimal `design.md` skeleton:
```markdown
## Context
[Background, constraints, stakeholders]

## Goals / Non-Goals
- Goals: [...]
- Non-Goals: [...]

## Decisions
- Decision: [What and why]
- Alternatives considered: [Options + rationale]

## Risks / Trade-offs
- [Risk] → Mitigation

## Migration Plan
[Steps, rollback]

## Open Questions
- [...]
```

## Spec File Format

### Critical: Scenario Formatting

**CORRECT** (use #### headers):
```markdown
#### Scenario: User login success
- **WHEN** valid credentials provided
- **THEN** return JWT token
```

**WRONG** (don't use bullets or bold):
```markdown
- **Scenario: User login**  ❌
**Scenario**: User login     ❌
### Scenario: User login      ❌
```

Every requirement MUST have at least one scenario.

### Requirement Wording
- Use SHALL/MUST for normative requirements (avoid should/may unless intentionally non-normative)

### Delta Operations

- `## ADDED Requirements` - New capabilities
- `## MODIFIED Requirements` - Changed behavior
- `## REMOVED Requirements` - Deprecated features
- `## RENAMED Requirements` - Name changes

Headers matched with `trim(header)` - whitespace ignored.

#### When to use ADDED vs MODIFIED
- ADDED: Introduces a new capability or sub-capability that can stand alone as a requirement. Prefer ADDED when the change is orthogonal (e.g., adding "Slash Command Configuration") rather than altering the semantics of an existing requirement.
- MODIFIED: Changes the behavior, scope, or acceptance criteria of an existing requirement. Always paste the full, updated requirement content (header + all scenarios). The archiver will replace the entire requirement with what you provide here; partial deltas will drop previous details.
- RENAMED: Use when only the name changes. If you also change behavior, use RENAMED (name) plus MODIFIED (content) referencing the new name.

Common pitfall: Using MODIFIED to add a new concern without including the previous text. This causes loss of detail at archive time. If you aren’t explicitly changing the existing requirement, add a new requirement under ADDED instead.

Authoring a MODIFIED requirement correctly:
1) Locate the existing requirement in `.d-spec/planning/changes/<change-id>/specs/<capability>/spec.md` or `.d-spec/planning/archive/` for prior approved changes.
2) Copy the entire requirement block (from `### Requirement: ...` through its scenarios).
3) Paste it under `## MODIFIED Requirements` and edit to reflect the new behavior.
4) Ensure the header text matches exactly (whitespace-insensitive) and keep at least one `#### Scenario:`.

Example for RENAMED:
```markdown
## RENAMED Requirements
- FROM: `### Requirement: Login`
- TO: `### Requirement: User Authentication`
```

## Troubleshooting

### Common Errors

**"Change must have at least one delta"**
- Check `.d-spec/planning/changes/[name]/specs/` exists with .md files
- Verify files have operation prefixes (## ADDED Requirements)

**"Requirement must have at least one scenario"**
- Check scenarios use `#### Scenario:` format (4 hashtags)
- Don't use bullet points or bold for scenario headers

**Silent scenario parsing failures**
- Exact format required: `#### Scenario: Name`


## Multi-Capability Example

```
.d-spec/planning/changes/add-2fa-notify/
├── proposal.md
├── tasks.md
└── specs/
    ├── auth/
    │   └── spec.md   # ADDED: Two-Factor Authentication
    └── notifications/
        └── spec.md   # ADDED: OTP email notification
```

auth/spec.md
```markdown
## ADDED Requirements
### Requirement: Two-Factor Authentication
...
```

notifications/spec.md
```markdown
## ADDED Requirements
### Requirement: OTP Email Notification
...
```

## Best Practices

### Simplicity First
- Default to <100 lines of new code
- Single-file implementations until proven insufficient
- Avoid frameworks without clear justification
- Choose boring, proven patterns

### Complexity Triggers
Only add complexity with:
- Performance data showing current solution too slow
- Concrete scale requirements (>1000 users, >100MB data)
- Multiple proven use cases requiring abstraction

### Clear References
- Use `file.ts:42` format for code locations
- Reference specs as `.d-spec/planning/changes/<change-id>/specs/auth/spec.md`
- Link related changes and PRs

### Capability Naming
- Use verb-noun: `user-auth`, `payment-capture`
- Single purpose per capability
- 10-minute understandability rule
- Split if description needs "AND"

### Change ID Naming
- Use kebab-case, short and descriptive: `add-two-factor-auth`
- Prefer verb-led prefixes: `add-`, `update-`, `remove-`, `refactor-`
- Ensure uniqueness; if taken, append `-2`, `-3`, etc.

## Tool Selection Guide

| Task | Tool | Why |
|------|------|-----|
| Find files by pattern | Glob | Fast pattern matching |
| Search code content | Grep | Optimized regex search |
| Read specific files | Read | Direct file access |
| Explore unknown scope | Task | Multi-step investigation |

## Error Recovery

### Missing Context
1. Read `.d-spec/project.md` first
2. Check related change specs under `.d-spec/planning/changes/`
3. Review recent archives under `.d-spec/planning/archive/`
4. Ask for clarification

## Quick Reference

### Stage Indicators
- `.d-spec/planning/changes/` - Proposed, not yet built
- `.d-spec/planning/archive/` - Completed changes

### File Purposes
- `proposal.md` - Why and what
- `tasks.md` - Implementation steps
- `design.md` - Technical decisions
- `spec.md` - Requirements and behavior



Remember: Specs are truth. Changes are proposals. Keep them in sync.
