# d-spec Roadmap: Track-Based Task Organization for Multi-Agent Parallelism

## Executive Summary

This roadmap defines how to refactor the d-spec workflow to organize tasks into **prioritized, non-cross-cutting tracks** that enable multiple agents to work asynchronously without code conflicts.

## Design Decisions

- **Track Granularity**: Directory/module-level (tracks own directories or modules)
- **Metadata Storage**: Inline in tasks.md (track annotations within existing file)
- **Enforcement Level**: Hard gate (block Beads creation until tracks validated)

---

## Git/GitHub Best Practices for Multi-Agent Isolation

### Current State

**Already Exists:**
- Git hooks are worktree-aware (`.git/hooks/pre-commit`, `.git/hooks/post-merge`)
- Custom merge driver for `.beads/issues.jsonl` conflicts
- `--no-daemon` flag for worktree usage with beads
- `clean_gone` skill removes stale branches + associated worktrees

**Missing:**
- Branch naming conventions per track
- Worktree setup procedure
- Merge/PR strategy for track completion
- Multi-agent handoff protocol

### Recommended Git Isolation Strategy

**Branch-Per-Track Model:**
```
main (stable)
├── track/auth/bd-10          # Track branch for auth epic
├── track/api/bd-11           # Track branch for api epic
└── track/ui/bd-12            # Track branch for ui epic
```

**Worktree-Per-Track Model:**
```bash
# Each agent works in isolated worktree
git worktree add ../project-track-auth -b track/auth/bd-10 main
git worktree add ../project-track-api -b track/api/bd-11 main
git worktree add ../project-track-ui -b track/ui/bd-12 main

# In each worktree, use --no-daemon for beads
cd ../project-track-auth
bd sync --no-daemon
```

**Merge Strategy:**
1. Each track branch → PR to main
2. Tracks with dependencies merge in priority order
3. `clean_gone` cleans up after merge

### Where to Document Git Isolation

| File | Content |
|------|---------|
| `.d-spec/onboarding/track-organization.md` | Add "Git Isolation" section |
| `.d-spec/commands/beads-daemon.md` | Expand worktree guidance |
| **NEW:** `.d-spec/git/parallel-agent-setup.md` | Complete multi-agent git workflow |

### Integration with Track Organization

The track organization workflow should include git setup:

```
1. Define tracks in tasks.md (code scope isolation)
2. Create branch per track (git isolation)
3. Create worktree per track (environment isolation)
4. Assign agent per worktree (execution isolation)
5. PR per track on completion (merge isolation)
```

---

## Conflict Resolution Strategy

### Types of Conflicts in Multi-Agent Work

| Conflict Type | When It Occurs | Resolution Strategy |
|---------------|----------------|---------------------|
| **File conflict** | Two tracks modify same file | Should be prevented by track scope rules; if occurs, indicates bad track design |
| **Beads JSONL conflict** | Concurrent issue updates | Auto-resolved by custom merge driver (`bd merge`) |
| **Schema/API conflict** | Tracks depend on shared interfaces | Sequence tracks by dependency; shared changes go in priority-1 track |
| **d-spec conflict** | Concurrent spec edits | Rare; d-spec frozen after Beads creation; resolve in planning phase |

### Conflict Prevention (Primary Strategy)

1. **Track scope validation** catches overlapping file boundaries before work begins
2. **Dependency ordering** ensures tracks that must merge first do so
3. **Shared utilities isolation** - any shared code changes go in a dedicated "foundation" track with priority 0

### Conflict Resolution (When Prevention Fails)

```markdown
## Conflict Resolution Protocol

### File Conflicts
1. STOP both agents working on conflicting files
2. Identify which track has rightful ownership of file
3. Either:
   a. Reassign file to one track (fix track scope)
   b. Split file into track-isolated modules
   c. Sequence tracks (add dependency, merge first track before continuing second)

### Beads JSONL Conflicts
1. Custom merge driver handles automatically: `merge.beads.driver = bd merge %A %O %A %B`
2. If manual resolution needed: `bd sync --import` after merge
3. Both agents' issue updates are preserved

### API/Schema Conflicts
1. Create "foundation" track (priority 0) for shared interface changes
2. All other tracks depend on foundation track
3. Foundation merges first, others rebase
```

### Merge Order Protocol

```
Priority 0: Foundation tracks (shared schemas, APIs, types)
     ↓ merge to main first
Priority 1: Core tracks (auth, data layer)
     ↓ rebase on main, then merge
Priority 2+: Feature tracks (can merge in parallel after rebasing)
```

---

## Agent Handoff Protocol

### When Handoff Occurs

1. **Session end** - Agent must stop but track work is incomplete
2. **Expertise change** - Different agent better suited for remaining work
3. **Parallel scaling** - Split track into subtracks for more agents

### Handoff Artifact: `.track-handoff.md`

Create in track worktree root when handing off:

```markdown
# Track Handoff: <track-name>

## Status
- **Track**: auth
- **Branch**: track/auth/bd-10
- **Worktree**: ../project-track-auth
- **Handoff Date**: YYYY-MM-DD HH:MM
- **From Agent**: <agent-id or session-id>

## Work Completed
- [x] Task 1: JWT validation implemented
- [x] Task 2: Tests written for validation

## Work Remaining
- [ ] Task 3: Auth middleware integration
- [ ] Task 4: Error handling

## Current State
- **Files modified**: src/auth/jwt.ts, src/auth/jwt.test.ts
- **Tests passing**: Yes
- **Build status**: Passing
- **Uncommitted changes**: None (all committed)

## Context for Next Agent
- Design decision: Using RS256 for JWT signing (see design.md)
- Known issue: Rate limiting not yet implemented
- Dependency: Waiting on track/api to expose user endpoint

## Beads Status
- Epic: bd-10 (in_progress)
- Completed tasks: bd-11, bd-12
- Current task: bd-13 (in_progress)
- Remaining: bd-14, bd-15

## Pickup Instructions
1. cd ../project-track-auth
2. git pull origin track/auth/bd-10
3. bd sync --no-daemon
4. bd show bd-13  # Current task
5. Continue from src/middleware/authMiddleware.ts
```

### Handoff Checklist (Outgoing Agent)

```markdown
Before handing off:
- [ ] All changes committed and pushed to track branch
- [ ] bd sync completed (issue states current)
- [ ] Tests passing
- [ ] .track-handoff.md created with full context
- [ ] No stashed changes
- [ ] Current task marked in_progress (not completed unless done)
```

### Pickup Checklist (Incoming Agent)

```markdown
When receiving handoff:
- [ ] Read .track-handoff.md completely
- [ ] git pull latest on track branch
- [ ] bd sync --no-daemon to get current issue state
- [ ] Verify tests still pass
- [ ] Review uncommitted changes (should be none)
- [ ] bd show <current-task> to understand context
- [ ] Continue work from documented pickup point
```

---

## Beads Epic Integration

### Track-to-Epic Mapping

Each track maps to exactly one Beads epic:

```
tasks.md Track Section    →    Beads Epic
─────────────────────────────────────────
Track: auth               →    bd-10 (epic)
  - Task 1                →    bd-11 (task, parent: bd-10)
  - Task 2                →    bd-12 (task, parent: bd-10)

Track: api                →    bd-20 (epic)
  - Task 1                →    bd-21 (task, parent: bd-20)
```

### Creating Epics from Tracks

When `d-spec-create-bd-issues` runs:

1. **For each track in tasks.md:**
   ```bash
   bd create "<track-name> implementation" -t epic -p <track-priority>
   ```

2. **For each task in track:**
   ```bash
   bd create "<task-description>" -t task -p <same-priority>
   bd dep add <epic-id> <task-id> --type parent-child
   ```

3. **For inter-track dependencies:**
   ```bash
   # If track:api depends on track:auth
   bd dep add <auth-epic-id> <api-epic-id> --type blocks
   ```

### Track Dependencies → Beads Dependencies

```markdown
## tasks.md format:

### Track: auth
- **Priority**: 1
- **Dependencies**: none
- **Beads Epic**: bd-10  ← Added after creation

### Track: api
- **Priority**: 2
- **Dependencies**: auth  ← Inter-track dependency
- **Beads Epic**: bd-20  ← Added after creation
```

Translates to:
```bash
bd dep add bd-10 bd-20 --type blocks  # auth blocks api
```

### Track Labels in Beads

Apply labels to issues for filtering:

```bash
# Label all issues in a track
bd label bd-11 track:auth
bd label bd-12 track:auth
bd label bd-21 track:api

# Find all work for a track
bd list --label track:auth
```

### Epic Completion = Track Completion

When all tasks in an epic are closed:
```bash
bd epic close-eligible  # Shows epics ready to close
bd close bd-10          # Close the epic
```

After epic closes:
1. Merge track branch to main via PR
2. Run `clean_gone` to remove branch and worktree
3. Update tasks.md with completion status (or archive change)

### Beads Integration Summary

| Track Concept | Beads Implementation |
|---------------|---------------------|
| Track | Epic (type: epic) |
| Task | Task (type: task, parent-child to epic) |
| Track priority | Epic priority (0-4) |
| Inter-track dependency | `blocks` dependency between epics |
| Track scope | Label `track:<name>` |
| Track completion | Epic close + branch merge |

---

## Current Workflow Understanding

### Workflow Stages

```
1. Idea Doc (.d-spec/planning/ideas/*.md)
      ↓
2. Proposal (.d-spec/planning/changes/<change-id>/proposal.md)
      ↓
3. Tasks Definition (.d-spec/planning/changes/<change-id>/tasks.md)  ← APPROVAL-LEVEL
      ↓
4. Spec Deltas (.d-spec/planning/changes/<change-id>/specs/<capability>/spec.md)
      ↓
5. Chat Approval Gate ← HARD STOP
      ↓
6. Spec Merge Gate (merge deltas → .d-spec/planning/specs/)
      ↓
7. Beads Handoff (d-spec-create-bd-issues skill)
      ↓
8. Beads Epic + Tasks (execution tracking)
      ↓
9. Implementation (bd ready → bd close)
```

### Current Limitations for Parallel Work

- **No explicit "tracks" concept** - just labels, priorities, and dependencies
- **No cross-cutting analysis** - tasks can touch overlapping files
- **No track isolation enforcement** - dependencies only express blocking, not scope
- **Single-agent assumption** - workflow assumes sequential execution

---

## Recommended Insertion Points for Track Organization

### Primary Recommendation: Two-Phase Track Organization

**Phase A: Track Planning (during tasks.md creation)**
- **Location**: `.d-spec/onboarding/discovery-to-spec.md` (Section: tasks.md structure)
- **Also reference from**: `.d-spec/AGENTS.md` step 8 (Encode TDD)
- **When**: After proposal drafted, before tasks.md finalized

**Phase B: Track Validation (before Beads handoff)**
- **Location**: `.d-spec/commands/d-spec-create-bd-issues.md`
- **Also add new gate**: `.d-spec/AGENTS.md` between steps 11-12
- **When**: After approval, before Beads epic creation

### Supporting Files to Create/Modify

| File | Action | Purpose |
|------|--------|---------|
| `.d-spec/onboarding/track-organization.md` | **CREATE** | Canonical guide for track-based task organization |
| `.d-spec/onboarding/discovery-to-spec.md` | MODIFY | Reference new track organization guide in tasks.md section |
| `.d-spec/AGENTS.md` | MODIFY | Add "Track Assignment Gate" between approval and Beads handoff |
| `.d-spec/commands/d-spec-create-bd-issues.md` | MODIFY | Add track validation prerequisite |
| `.d-spec/planning/changes/<change-id>/tracks.md` | **NEW ARTIFACT** | Optional: Per-change track assignment file |

---

## Proposed Track Organization Workflow

### New Step: Track Assignment (Between Approval and Beads)

```
After proposal approved, BEFORE creating Beads issues:

1. ANALYZE tasks.md for file/module scope of each task
2. CLUSTER tasks by affected code areas (files, directories, modules)
3. IDENTIFY cross-cutting risks (tasks touching same files)
4. ASSIGN each task to a "track" (isolated workstream)
5. SEQUENCE tracks by priority and dependencies
6. VALIDATE no cross-cutting between tracks
7. DOCUMENT track assignments in tracks.md or inline in tasks.md
8. PROCEED to Beads handoff with track metadata
```

### Track Definition Requirements

Each track should define:
- **Track ID**: e.g., `track-auth`, `track-ui`, `track-api`
- **Scope Boundary**: Which files/directories belong to this track
- **Task List**: Which tasks belong to this track
- **Dependencies**: Which other tracks must complete first (inter-track)
- **Priority**: Execution order relative to other tracks

### Cross-Cutting Detection Rules

A task is "cross-cutting" if:
- It modifies files that another task in a different track also modifies
- It changes shared utilities/types used by tasks in other tracks
- It requires coordinated changes across track boundaries

Cross-cutting work must either:
1. Be consolidated into a single track
2. Be sequenced as a blocking dependency
3. Be split into track-isolated subtasks

---

## tasks.md Track Annotation Format

Based on user preference for inline storage:

```markdown
## Tracks

### Track: auth
- **Scope**: `src/auth/`, `src/middleware/auth*`
- **Priority**: 1 (execute first)
- **Dependencies**: none

### Track: api
- **Scope**: `src/api/`, `src/routes/`
- **Priority**: 2
- **Dependencies**: auth (must complete first)

### Track: ui
- **Scope**: `src/components/`, `src/pages/`
- **Priority**: 2 (can run parallel with api)
- **Dependencies**: none

---

## Tasks

### Track: auth
- [ ] Implement JWT token validation in `src/auth/jwt.ts`
- [ ] Add auth middleware to `src/middleware/authMiddleware.ts`

### Track: api
- [ ] Create user endpoint in `src/api/users.ts`
- [ ] Add route handlers in `src/routes/userRoutes.ts`

### Track: ui
- [ ] Build login form in `src/components/LoginForm.tsx`
- [ ] Create auth context in `src/components/AuthProvider.tsx`
```

---

## Workflow Diagram with New Gate

```
Proposal → Tasks.md Draft → [TRACK ORGANIZATION] → Approval → Spec Merge → [TRACK VALIDATION GATE] → Beads Handoff
                                    ↑                                              ↑
                          Add track annotations                         Validate no cross-cutting
                          to tasks.md                                   Block if tracks invalid
```

---

## Cross-Cutting Detection Rules

Include in track-organization.md:

1. **File overlap check**: No two tracks may list the same file/directory in their scope
2. **Import analysis**: Tasks modifying modules should not import from other track scopes
3. **Shared dependency warning**: If tasks touch shared utilities, consolidate into one track or sequence
4. **Breaking change isolation**: Cross-cutting schema/API changes must be in their own track, executed first

---

## Implementation Order

When ready to implement, modify files in this order:

### Phase 1: Track Organization (Code Scope Isolation)
1. **CREATE** `.d-spec/onboarding/track-organization.md` (canonical track rules + cross-cutting detection)
2. **MODIFY** `.d-spec/AGENTS.md` (add step 11.5 "Track Organization Gate")
3. **MODIFY** `.d-spec/onboarding/discovery-to-spec.md` (update tasks.md format with track sections)
4. **MODIFY** `.d-spec/commands/d-spec-create-bd-issues.md` (enforce track validation before Beads)
5. **MODIFY** `.d-spec/commands/d-spec-validate-specs.md` (add track validation rules)

### Phase 2: Git Isolation (Environment Isolation)
6. **CREATE** `.d-spec/git/parallel-agent-setup.md` (complete multi-agent git workflow)
7. **CREATE** `.d-spec/git/conflict-resolution.md` (conflict types and resolution protocols)
8. **MODIFY** `.d-spec/commands/beads-daemon.md` (expand worktree best practices)
9. **MODIFY** `.d-spec/onboarding/track-organization.md` (add "Git Isolation" section linking to git docs)

### Phase 3: Agent Handoff & Epic Integration
10. **CREATE** `.d-spec/workflows/agent-handoff.md` (handoff artifact template + checklists)
11. **MODIFY** `.d-spec/commands/d-spec-create-bd-issues.md` (add track→epic mapping logic)
12. **MODIFY** `.d-spec/commands/beads-label.md` (add `track:<name>` label convention)

### Phase 4: Integration & Root Docs
13. **MODIFY** Root `CLAUDE.md` (add quick reference to track + git isolation workflow)
14. **MODIFY** `.d-spec/AGENTS.md` (add git setup to Beads handoff step, reference new docs)

---

## Verification

After implementation, test with:

### Track Organization Testing
1. Create a test proposal with intentional cross-cutting tasks
2. Verify the gate blocks Beads creation
3. Fix the cross-cutting, verify gate passes
4. Create Beads issues, verify track labels/structure applied

### Git Isolation Testing
5. Create worktrees for two tracks: `git worktree add ../test-track-a -b track/a main`
6. Verify each worktree can run `bd sync --no-daemon` independently
7. Make changes in both worktrees simultaneously
8. Merge track-a PR, verify no conflicts with track-b
9. Run `clean_gone` to verify cleanup works

### End-to-End Multi-Agent Simulation
10. Spawn two simulated agents in separate worktrees
11. Have each work on their assigned track
12. Verify no cross-cutting file conflicts
13. Merge both tracks to main successfully
