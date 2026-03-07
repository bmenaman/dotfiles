# Export AGENTS.md to Dotfiles Repo

## Goal
Extend the dotfiles repo to support system-wide agent rules with local overrides, following the same pattern as `.zshrc` with `$DOTFILES_LOCAL`.

## Proposed Structure

### Dotfiles Repo
```
/Users/roger/repos/bmenaman/dotfiles/
├── agents/
│   ├── AGENTS.md                    # System-wide agent rules
│   ├── jj-workflow.md               # VCS workflow
│   ├── bdd.md                       # BDD guidance
│   ├── hexagonal_architecture_guidance.md
│   ├── telemetry.md
│   └── acceptance_criteria.md
└── zsh/
    └── .zshrc                       # Already has DOTFILES_LOCAL pattern
```

### Local Override Structure
```
$DOTFILES_LOCAL/                     # e.g., ~/dotfiles-acme-corp
├── agents/
│   ├── AGENTS.md                    # Org-specific overrides/additions
│   ├── acme-deployment.md           # Org-specific guidance
│   └── acme-security.md
└── .zshrc                           # Already supported
```

## Implementation Steps

### 1. Create agents directory in dotfiles repo
- Copy `agents/` folder from pycalc to dotfiles repo
- Copy `AGENTS.md` from pycalc root to dotfiles/agents/

### 2. Update AGENTS.md for global use
Add section about local extensions:
```markdown
## Local Extensions
If $DOTFILES_LOCAL/agents/AGENTS.md exists, those rules extend/override these.
```

### 3. Add environment variables to .zshrc
After oh-my-zsh source, add:
```bash
export AGENTS_DIR="$DOTFILES/agents"
export AGENTS_DIR_LOCAL="$DOTFILES_LOCAL/agents"
```

### 4. Create helper script (optional)
`agents/load-agents.sh`:
```bash
#!/bin/bash
# Helper to locate agent guidance files
# Usage: load-agents.sh <filename>

AGENT_FILE="$1"

if [ -f "$AGENTS_DIR_LOCAL/$AGENT_FILE" ]; then
  echo "$AGENTS_DIR_LOCAL/$AGENT_FILE"
elif [ -f "$AGENTS_DIR/$AGENT_FILE" ]; then
  echo "$AGENTS_DIR/$AGENT_FILE"
else
  echo "Agent file not found: $AGENT_FILE" >&2
  return 1
fi
```

### 5. Update dotfiles README.md
Add installation instructions:
```bash
cd $DOTFILES
stow --no-folding --verbose --target=$HOME agents
```

### 6. Update project-specific AGENTS.md files
Reference global rules:
```markdown
# Project-Specific Agent Rules

## Global Rules
Consult ~/agents/AGENTS.md for system-wide conventions.

## Local/Org Rules  
If $DOTFILES_LOCAL/agents/ exists, those take precedence.

## Project Rules
[Project-specific rules here]
```

## Benefits

1. **Layered configuration**: Global → Org/Local → Project
2. **Same pattern as .zshrc**: Uses existing `$DOTFILES_LOCAL` convention
3. **Stow-compatible**: Symlinks work naturally
4. **Version controlled**: Global rules in dotfiles repo
5. **Private overrides**: Org-specific rules stay in `$DOTFILES_LOCAL` (not committed)

## Usage Pattern

- Global rules: `~/agents/AGENTS.md` (symlinked from dotfiles)
- Org-specific: `$DOTFILES_LOCAL/agents/AGENTS.md`
- Project-specific: `<project>/AGENTS.md` (references global)
