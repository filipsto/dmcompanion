# Data Types Artifact Import

Data Modeler Companion imports supported Data Types model artifacts into the DMC design so they remain available after the source SDDM folder is no longer present.

## Imported distinct types

For each distinct type, the imported design retains:

- Stable SDDM object identity.
- Display name.
- Underlying logical data type.
- Size or precision and scale.
- Comment and notes when present.

The design also retains the data-type catalogue information needed to resolve references from logical and relational artifacts.

## Type resolution

Distinct types resolve to their underlying logical data type and available size, precision, or scale. This allows entity and table cards to show meaningful type definitions instead of raw SDDM identifiers.

Structured and collection type references resolve to their catalogue names. Their richer artifact definitions are outside the supported import scope described in the [Data Types Artifact Constraints](data-types-artifact-constraints.md).

When a referenced type cannot be resolved, its source identity is preserved rather than replaced with an invented type.

## Self-contained imported designs

Imported type information is written into the DMC design. Reopening and rendering the imported design therefore does not require continued access to the original SDDM design folder.

[Back to Modeling and SDDM Designs](../sddm-designs.md)
