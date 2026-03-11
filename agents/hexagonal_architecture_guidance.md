# Hexagonal Architecture Guidance

Use this guidance when changing ports, adapters, messaging flows, or composition roots.

## 1) Declare the interaction model first

Before implementation, make the messaging model explicit in `tasks.md` and code notes:
- request/response (RPC-style), or
- command/event (event-driven).

If the model is not explicit, stop and ask before writing code.

## 2) Keep dependency direction inward

- Driving (inbound) adapters depend on input ports/use cases.
- Driven (outbound) adapters implement output ports.
- Domain/application code must not depend on concrete framework adapters.

## 3) Instantiate concretes only in composition roots

Create concrete adapters in startup/composition layers (for example app factory, worker entrypoint, or test wiring), then inject them.

Avoid creating outbound adapters directly inside inbound adapters.

## 4) Put side effects behind output ports

Publishing events/messages, calling external APIs, and persistence writes should be represented as output ports.

Driven adapters implement these ports.

## 5) Keep transport details out of domain/application decisions

Topic names, headers, polling loops, and broker concerns belong in adapters/configuration.

Domain/application logic should model business operations and outcomes.

## 6) Keep BDD features transport-neutral

- `.feature` files should remain business-language only.
- Transport differences belong in glue/fixtures.
- The same scenarios should run across supported transports.

## 7) Validate architecture in tests

Prefer tests that prove:
- composition root wiring injects dependencies rather than constructing them deep in adapters,
- output ports are invoked for external effects,
- transport modes can be swapped without changing feature files.

