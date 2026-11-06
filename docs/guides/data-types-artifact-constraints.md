# Data Types Artifact Constraints

This page defines the supported boundary for SDDM Data Types artifacts.

## Supported scope

- Distinct types are imported as complete supported artifacts.
- Structured and collection types remain catalog entries used for identity and display-name resolution.
- Data-type identity follows the stable SDDM object ID rather than display name.
- Imported designs remain readable without the source SDDM folder.

## Resolution behavior

- A distinct type resolves to its underlying logical data type and size or precision and scale.
- A structured type reference resolves to the structured type name.
- A collection type reference resolves to the collection type name.
- An unresolved reference falls back to its source identifier instead of an inferred type.

When a distinct type contains size as well as precision and scale, size takes precedence. Numeric precision and scale are accepted whether SDDM stores them as text or numbers. Comments and notes are optional and preserved when supplied.

## Outside this scope

The Data Types artifact import does not provide:

- Editing of imported type definitions.
- Full structured or collection type artifact import.
- Re-export to SDDM.
- Additional DDL generation behavior for these artifacts.

[Read the import overview](data-types-artifact-import.md)
