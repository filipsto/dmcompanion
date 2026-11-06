# Database Projects: Add With Dependencies

**Add With Dependencies** expands a Database Project object selection using dependencies read from the active Oracle Database connection. The project stores the resulting typed object list rather than a dependency graph.
Use object filters and dependency expansion in Edit project dialog to assemble a project. For table, view and materialized view ALL_CONSTRAINTS view is used to get parent and child dependencies for one hop. For view, materialized view and PL/SQL objects ALL_DEPENDENCIES view is used to get used object (again for one hop).   
**Note:** Public objects from SYS schema (like domains or packages) also appear in dependencies list. They can be added to project for information purpose but are excluded from generation functionality.

## Root projects

A root project selects available objects from its live SQL Developer for VS Code connection. Filter the scope, move the required objects to the selected list, and apply dependency expansion before saving.

## Subprojects

A subproject starts with the immediate parent project's stored object scope. Use **From database** when the subproject needs objects outside that parent scope.

1. Select objects from the parent scope or the live database.
2. Choose **Add With Dependencies**.
3. Review the expanded typed object selection. Remove some if not needed.
4. Enable **Update parent objects in project tree** when newly introduced objects should also be added to the parent chain.
5. Save the subproject.

Even when the available list comes from the parent project, dependencies are resolved from the live database. The connection must therefore be available during expansion.

## Dependency rules

Expansion depends on the selected object type:

- Tables, views, and materialized views include foreign-key dependencies.
- Views and materialized views also include objects referenced by their definitions.
- Procedures, functions, packages, package bodies, triggers, and related code objects include referenced database objects.

Discovered names are resolved back to their real database object types before saving. This prevents one object from being stored multiple times under inferred or fabricated types.

## Connection boundary

Dependency expansion uses the selected project's live Oracle connection. It does not silently resolve objects against another connection or database scope.

[Back to Database Projects](../database-projects.md)
