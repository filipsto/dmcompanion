# Add to Diagram with ALL Dependencies

**Add to Diagram with ALL Dependencies** builds a relational neighborhood from one or more selected database objects by recursively following foreign-key parents and children.

This live database command is separate from **Add With Dependencies** in Database Projects and model-linked diagrams.

## Configurable neighbors

**Add to Diagram With Neighbors** is available alongside both dependency shortcuts on the same object nodes in the Oracledb, SQL Developer, and MSSQL connection trees. It reveals the compatible open diagram and displays an options modal over its canvas, with the qualified tree objects shown as the starting selection. The objects do not need to be on the diagram already.

- **Direction:** All follows both directions at each step; Parent follows referencing objects to their referenced parents; Child follows parents to their referencing children.
- **Number of zones:** a positive integer counting foreign-key hops from the selected seeds. The default is All directions and one zone.
- **All Zones:** follows the chosen direction until no new objects remain and disables the zone count.

Multiple selected objects must share a compatible connection scope; MSSQL objects must also share a database. Their neighborhoods are combined, including the seeds. Objects already on the diagram remain eligible for traversal and are not added twice.

All directions with one zone produces the complete neighborhood of **With Dependencies**; All directions with All Zones matches **With ALL Dependencies**. Configurable neighbors use the discovery checkpoints below even for a single zone, whereas the existing one-hop shortcut has a separate confirmation above 150 new objects, with Continue/Cancel and no partial add.

**Cancel**, Escape, or closing the options modal leaves the diagram unchanged. Once discovery starts, **Stop** at a size checkpoint adds the objects discovered so far. Changing the target tab or connection invalidates the request instead of importing into a different target. Successful imports use the existing placement behavior and one add-objects undo/history operation.

## Availability

The command is available from individual relational object nodes in these connection trees:

- Oracle connections using the node-oracledb driver.
- Oracle SQL Developer for VS Code connections.
- Microsoft SQL Server connections.

Select one object or multiple objects from the same compatible connection scope. The command is not available from schema or folder nodes.

## Workflow

1. Open a diagram backed by the same database connection scope as the selected objects.
2. Select one or more relational object nodes.
3. Choose **Add to Diagram with ALL Dependencies**.
4. Review size checkpoints if the discovered component is large.
5. Continue traversal or stop and add the objects discovered so far.

The traversal visits each qualified object once, so self-references, reciprocal relationships, duplicate foreign-key rows, and longer cycles terminate without repeatedly adding objects.

## Provider scope

For Oracle, traversal can follow visible foreign-key relationships across schemas on the selected connection. Dictionary privileges determine which relationships and object definitions can be read. Cross-schema targets retain their owner-qualified identities.

For SQL Server, traversal can follow foreign-key relationships across schemas within the selected database. It does not cross into another database or connection.

## Size checkpoints

The extension pauses after discovering 150 objects and after every additional 100 objects.

- **Continue** resumes traversal.
- **Stop**, Escape, or dismissing the prompt stops traversal and adds the accumulated result.

Stopping at a checkpoint does not discard objects already discovered.

## Dependency boundary

**ALL Dependencies** means every reachable **foreign-key** parent and child in the current database scope. It does not traverse:

- View or materialized-view definition dependencies.
- Procedures, packages, functions, or triggers.
- Property graphs or SQL Server graph endpoint relationships.
- Database links, other connections, or other SQL Server databases.

The one-hop **Add to Diagram with Dependencies** command remains useful when only immediate foreign-key neighbors are needed. Database Projects use a separate object-type-specific dependency workflow.

[Back to Diagramming](../diagramming.md)
