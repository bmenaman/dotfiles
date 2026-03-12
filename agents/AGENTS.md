# Global Agent Rules

## Workflow
For any task or work that involves editing a file, consult agents/jj-workflow.md

## Definition of Done
When writing tasks e.g. in a `tasks.md`, consult agents/acceptance_criteria.md.
These also apply to implementation tasks — e.g. when writing code, run the tests before declaring the task complete.

## Completed Tasks
When all tasks in a `tasks.md` are complete, move the tasks.md to archive and number it to avoid conflict.

For example:

before:
```
/projects/foo/
  /archive/tasks1.md
  tasks.md
```
after:
```
/projects/foo/
  archive/
    tasks1.md
    tasks2.md
```

## New Work
When asked to task out some work, create a tasks.md in projects/<project>. If uncertain which project is appropriate, ask.

## BDD
When working on feature tests (`**/*.feature` or `tests/bdd/**/*.py`), consult agents/bdd.md

## Hexagonal Architecture
When work involves ports, adapters, messaging, or composition roots, consult agents/hexagonal_architecture_guidance.md

## Telemetry
When work involves logging, tracing, metrics, observability, or OpenTelemetry, consult agents/telemetry.md

## Running Tests and Project Commands
Refer to the relevant README file.
