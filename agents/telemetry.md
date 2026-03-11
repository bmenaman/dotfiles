# Telemetry guidance

Use this guidance when work touches logging, tracing, metrics, observability, or OpenTelemetry.

## Default strategy

- Use a **hybrid OTEL** approach:
  - auto instrumentation for framework/transport visibility,
  - explicit instrumentation only where domain semantics or testability require it.
- Prefer OTLP export and avoid vendor-specific SDK use in core layers.

## Layer rules (hexagonal architecture)

- **Domain/Application**:
  - instrument code in an idiomatic way through canonical APIs (logger/meter/tracer),
  - avoid wiring exporter/backend concerns directly in domain/application code.
- **Ports**:
  - prefer provider-style ports that expose canonical APIs instead of task-specific methods,
  - example pattern: `TelemetryProviderPort` exposing `logger(name)`, `meter(name)`, `tracer(name)`.
- **Adapters**:
  - provide concrete logger/meter/tracer instances and map them to OTEL/logging backends,
  - keep backend/exporter details here.
- **Composition root/bootstrap**:
  - wire providers/exporters/instrumentors,
  - inject telemetry adapters into application services.

## Decision matrix

- Use **auto instrumentation** for HTTP/messaging/DB boundaries first.
- Use **explicit business telemetry** when you need operation/outcome-level observability.
- Use **ports + adapters** when you need replaceable telemetry providers or fast unit tests with mocks/stubs.
- Do not add direct vendor SDK calls in domain/application code.

## Metrics and attribute constraints

- Keep attributes bounded and queryable (for example: `operation`, `outcome`, `transport`).
- Never use high-cardinality identifiers in metric attributes (`request_id`, `user_id`, raw payload values).
- Ensure aggregate views remain meaningful after grouping and summing.

## Test-first expectations

- Before concrete adapters, define failing tests for:
  - domain/application behavior using mocked telemetry providers,
  - expected adapter mapping from provider APIs to emitted telemetry fields/attributes.
- Land unit tests alongside the implementation they verify whenever practical.
