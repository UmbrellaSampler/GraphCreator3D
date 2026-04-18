## Note
This document is preliminary and defines the product direction for the first stable framework release.

## Purpose
GraphCreator3D is a Godot framework for creating and editing spatial, multimodal transport networks in 3D.

The framework models transport systems as a generic network abstraction that can be applied to city and non-city domains. It focuses on authoring network topology and spatial geometry on editable terrain, not on detailed simulation of vehicles, agents, or economics.

A network can include multiple transport modalities such as walking, roads, rail, bus, tram, cargo, utilities, and logistics transfer points, while remaining mode-agnostic at the core data model level.

## Scope

### In Scope
- Definition of a generic 3D network format independent from Godot scene object persistence.
- Core entities:
  - Nodes: spatial anchors and connection points.
  - Links: directed or undirected connections with 3D geometry.
  - Areas: polygonal or volumetric regions for walkable, logistics, or pathfinding semantics.
  - Layers: modality or domain separation within one network asset.
  - Connectors: explicit inter-layer transfer links.
- Terrain-aware authoring:
  - Place and edit nodes, links, and areas on terrain.
  - Terrain conformance rules (snap, follow, or manual elevation).
  - Support for terrain-aware structures such as at-grade, bridge-like, and tunnel-like placement flags.
- Editor capabilities:
  - Create, modify, and validate multimodal network assets.
  - Manage multiple layers and inter-layer connectors.
  - Basic visualization primitives suitable for editing and debugging.
- Validation rules:
  - Topology consistency.
  - Layer and connector compatibility.
  - Geometric constraints (for example slope, curvature, minimum spacing) via configurable profiles.
- Extensibility:
  - Mode-specific behavior through data profiles and plugins, not hardcoded transport-specific core classes.
- Path-query readiness:
  - Data structures and APIs suitable for downstream multi-agent and goods pathfinding systems.

### Out of Scope (Current Phase)
- High-fidelity graphics and final art pipeline.
- Economic simulation, demand generation, and city-management gameplay loops.
- Detailed simulation of concrete transport entities (vehicle physics, schedules, traffic AI, passenger behavior).
- Final balancing of throughput, pricing, resource flow, or logistics optimization.

### Design Principles
- Core-first abstraction: transport modes are profiles over common graph primitives.
- Spatial correctness: topology and geometry must remain valid on editable terrain.
- Separation of concerns: authoring framework first, gameplay simulation later.
- Reusability: the same core asset model should support different domain-specific editors (road, rail, utility, logistics).

### Non-Goals for Initial Release
- Building a full city-builder game.
- Solving all routing and simulation edge cases.
- Delivering production-level runtime UX.

### Initial Success Criteria
- A user can create a multimodal 3D network with multiple layers and explicit transfers.
- The network is saved and loaded from dedicated framework assets.
- Validation catches broken topology and incompatible layer transitions.
- A downstream system can consume the network for path computation without changing core data structures.
