---
inclusion: always
---

# Jujutsu (jj) Squash Workflow

This project uses **jujutsu (jj)** for version control with a squash-based workflow. When making code changes, follow this workflow:

## Quick Reference: The 7-Step Workflow

1. **`jj describe -m "what I'm doing"`** ← Do this FIRST
2. **`jj new`** ← Do this SECOND
3. **Make your code changes** ← Now you can edit files
4. **Verify/test your changes** ← Ensure everything works
5. **Request user code review** ← REQUIRED: Present changes for review
6. **`jj squash`** ← Do this ONLY after user approval
7. **`jj log`** ← Verify commit history

### Optional: Discard Uncommitted Work
If you need to throw away work in progress:
```bash
jj abandon
```

## CRITICAL: Agent Pre-Coding Requirements

**BEFORE writing, editing, or creating ANY files, you MUST:**

### Step 1: Describe the Work (REQUIRED FIRST STEP)
```bash
jj describe -m "Brief description of what you're about to do"
```
**Do this BEFORE touching any files.** This is not optional.

### Step 2: Create Staging Area (REQUIRED SECOND STEP)
```bash
jj new
```
**Do this BEFORE making any edits.** This creates your working space.

### Step 3: Now Make Your Code Changes
Only after steps 1 and 2 are complete, proceed with:
- Creating new files
- Editing existing files

### Step 4: Verify and Test Your Changes (REQUIRED BEFORE CODE REVIEW)
**Do NOT request code review until you've verified your work is correct:**
- Run relevant tests (unit tests, integration tests, etc.)
- Check for syntax errors or linting issues
- Verify the code builds successfully
- Confirm the changes meet the requirements
- Test the functionality manually if needed

**If verification fails:**
- Fix the issues (you're still in the staging area)
- Re-test until successful
- Only proceed to code review when everything works

**If you need to start over:**
```bash
jj abandon  # Discard all changes and start fresh
```

### Step 5: Request User Code Review (REQUIRED BEFORE SQUASHING)
**STOP and present your changes to the user for review:**
- Summarize what you changed and why
- List all modified/created files
- Highlight any important decisions or trade-offs
- Wait for explicit user approval before proceeding

**The user will either:**
- **Approve** → Proceed to step 6 (squash)
- **Request changes** → Make adjustments and return to step 4 (verify)
- **Reject** → Use `jj abandon` to discard changes

**NEVER squash without user approval when working on spec tasks.**

### Step 6: Squash Your Changes (ONLY AFTER USER APPROVAL)
```bash
jj squash
```
**Do this ONLY AFTER the user has reviewed and approved your changes.** This commits your work.

### Step 7: Verify Commit (REQUIRED FINAL STEP)
```bash
jj log
```
**Always verify** the commit history looks correct.

## Workflow Enforcement

- **NO file edits without `jj describe` + `jj new` first**
- **NO squashing without user code review approval**
- **NO marking tasks as completed without `jj squash` + `jj log` after user approval**
- If you're asked to "add a feature", "fix a bug", "create a file" - these ALL require the full 7-step workflow
- Even small changes (one-line edits) require the full workflow including code review
- Think of `jj describe` + `jj new` as "opening your workspace"
- Think of verification/testing as "quality gate"
- Think of user code review as "approval gate"
- Think of `jj squash` + `jj log` as "closing your workspace"

## Important Notes

- **Do NOT use `git` commands** - This project uses jj, not git directly
- **The @ symbol** represents the current working copy change
- **Squashing is not optional** - Always squash your changes to keep history clean
- **Each logical change** should be one described commit after squashing
- **Always use `--no-pager` flag for commands with long output** - Commands like `jj diff`, `jj log`, `jj show`, and `--help` use an interactive pager by default. Use the global `--no-pager` flag (e.g., `jj --no-pager diff` or `jj diff --no-pager`) to output directly to the terminal without requiring manual intervention to quit
- don't use task and phase numbers in commits. Wrong: `jj describe -m "Task 1: added a foo"`. Right `jj describe -m "Added a foo"`

## CRITICAL: Git Command Prohibition

**NEVER use git commands directly without explicit user permission.** This project uses jujutsu (jj) exclusively for version control.

### Common Mistakes and Correct Alternatives

| ❌ WRONG (git) | ✅ CORRECT (jj) | Purpose |
|----------------|-----------------|---------|
| `git checkout <file>` | `jj restore <file>` | Revert file changes |
| `git reset --hard` | `jj abandon` | Discard all working changes |
| `git add <file>` | Not needed - jj tracks all changes automatically | Stage files |
| `git commit -m "msg"` | `jj describe -m "msg"` then `jj squash` | Commit changes |
| `git status` | `jj status` or `jj log` | Check status |
| `git diff` | `jj diff --no-pager` | View changes |
| `git branch` | `jj branch list` | List branches |
| `git log` | `jj log` | View history |
| `git revert <commit>` | `jj backout <commit>` | Revert a commit |
| `git stash` | `jj new` (creates new change) | Temporarily save work |

### When Reverting Changes Based on User Feedback

If the user asks you to revert or undo changes:

1. **If changes are NOT yet squashed** (still in working copy):
   - To revert specific files: `jj restore <file>`
   - To discard all changes: `jj abandon`

2. **If changes ARE already squashed** (committed):
   - Ask the user how they want to proceed
   - Options include: `jj backout`, `jj edit`, or creating a new change

3. **NEVER use `git checkout`, `git reset`, or any git command**

### Why This Matters

- Git commands can corrupt the jj repository state
- Git and jj have different mental models and workflows
- Using git bypasses the squash workflow entirely
- Git commands may create conflicts that are hard to resolve

### If You're Unsure

**When in doubt, ask the user.** If you need to perform a version control operation and don't know the jj equivalent, stop and ask rather than falling back to git commands.

## Example Complete Workflow

```bash
# Agent is asked to add a new feature
jj describe -m "Add user authentication module"
jj new
# (agent edits files: auth.py, config.py, tests/test_auth.py)

# VERIFY BEFORE CODE REVIEW
python -m pytest tests/test_auth.py  # Run tests
python -m pylint auth.py              # Check linting
# Tests pass ✓

# REQUEST CODE REVIEW (agent stops here and presents changes to user)
# Agent: "I've completed the authentication module. Changes include:
#   - auth.py: Added login/logout functions
#   - config.py: Added auth configuration
#   - tests/test_auth.py: Added unit tests
# All tests pass. Ready for your review."

# USER REVIEWS AND APPROVES

# NOW squash (only after user approval)
jj squash
jj log  # verify the change is recorded
```

## Reference

Based on the [Squash Workflow](https://steveklabnik.github.io/jujutsu-tutorial/real-world-workflows/the-squash-workflow.html) from the Jujutsu tutorial.
