# SQL Server DDL Formatting (Show Definition)

**Show Definition** is available for SQL Server connections from all providers (SQL Server extension connections and the built-in driver). It works for a single object or for all objects of a connection. The output is a simplified DDL document opened in a new SQL editor. It is meant for reading and reviewing the model, not as a full deployment script.

## Settings

All settings are in the **SQL Server** group (`dmc.mssql.showDefinition.*`).

| Setting | Default | Effect |
| --- | --- | --- |
| `includeCheckConstraints` | `false` | Include check constraints. |
| `includeIndexes` | `false` | Include indexes that do not back a primary key or unique constraint. |
| `includeComments` | `false` | Include `MS_Description` object and column comments as `sys.sp_addextendedproperty` calls. |
| `quoteIdentifiers` | `false` | Bracket every identifier. When off, only identifiers that need it are bracketed (see [Identifiers](#identifiers)). |
| `useGoBatchSeparator` | `false` | End every statement with `;` followed by `GO`. When off, `;` is on its own line and `GO` appears only around views. |
| `constraintsAsAlterTable` | `true` | Emit unique and check constraints as separate `ALTER TABLE` statements after `CREATE TABLE`, so only the primary key remains inline. When off, they are listed inside `CREATE TABLE`. |
| `includeDiagramEdgeConnections` | `true` | For an edge table without a declared `CONNECTION` constraint, write an inline `CONNECTION` built from the node pairs already known to the diagram (see [Edge connections](#edge-connections)). |

## Document structure

1. `USE <database>`, when the database name is known.
2. One line per object that could not be scripted: `-- Failed to script schema.name: <reason>`.
3. Objects in this order: tables, node tables, edge tables, views. Within each kind, the order of the selection is kept. Each object starts with a header comment such as `-- dbo.Person (Node table)`.
4. For each table, in this order:
   1. `CREATE TABLE`
   2. unique constraints (`ALTER TABLE`, when `constraintsAsAlterTable` is on)
   3. check constraints (`ALTER TABLE`, when `constraintsAsAlterTable` is on)
   4. indexes
   5. comments
5. All foreign keys at the end, under `-- Foreign keys`, as `ALTER TABLE ... ADD FOREIGN KEY`.

## Statement terminators and GO

**`useGoBatchSeparator` off (default):** each statement body is followed by `;` on its own line and an empty line.

```sql
CREATE TABLE dbo.City
    (
     ID int NOT NULL
    )
;

CREATE INDEX IX_City ON dbo.City
    (
     ID ASC
    )
;
```

**`useGoBatchSeparator` on:** `;` ends the last line of the statement, `GO` follows on the next line, and there is no empty line after `GO`.

```sql
CREATE TABLE dbo.City
    (
     ID int NOT NULL
    );
GO
CREATE INDEX IX_City ON dbo.City
    (
     ID ASC
    );
GO
```

**Views:** `CREATE VIEW` must be the only statement in its batch, so a view is always preceded and followed by `GO`, regardless of the setting.

## Identifiers

- **`quoteIdentifiers` off:** a name is left unquoted when it is a regular identifier (`[A-Za-z_][A-Za-z0-9_@$#]*`) and not a T-SQL reserved word. Otherwise it is bracketed, with `]` escaped as `]]`.
- **`quoteIdentifiers` on:** every name is bracketed.
- **Case:** names, types and expressions keep the case returned by the database.

## CREATE TABLE

```sql
CREATE TABLE dbo.Person
    (
     ID   int IDENTITY(1,1) NOT NULL ,
     Name nvarchar(100) COLLATE Latin1_General_BIN2 ,
     Code AS (upper([Name])) PERSISTED NOT NULL ,
     CONSTRAINT PK_Person PRIMARY KEY CLUSTERED (ID)
    ) AS NODE
```

- **Layout:** the column list is opened by `(` indented 4 spaces. Items are indented 5 spaces, and each item except the last ends with ` ,`.
- **Column names:** names are padded to the longest name, so the types line up.
- **Nullability:** nullable columns omit `NULL`; non-nullable columns end with `NOT NULL`.
- **Column details:** `COLLATE`, `IDENTITY(seed,increment)` and `DEFAULT` are added when present.
- **Graph tables:** only user columns are listed, followed by `AS NODE` or `AS EDGE`. An edge table with no user columns is written as `CREATE TABLE name AS EDGE`.
  - Internal graph columns used in keys and indexes are shown as `$node_id`, `$edge_id`, `$from_id` and `$to_id`.
- **Kept inline:** the primary key, default constraints and edge `CONNECTION` constraints. With `constraintsAsAlterTable` off, unique and check constraints are inline too.

### Constraint names

Constraints with system-generated names (`is_system_named = 1`) are written without `CONSTRAINT <name>`. This applies to primary keys, unique constraints, check constraints, defaults, foreign keys and `CONNECTION` constraints. SQL Server then generates a new name when the script runs.

### Edge connections

`CONNECTION` constraints are always written inside `CREATE TABLE ... AS EDGE`.

- **Declared constraints:** taken from `sys.edge_constraints`, with name and `ON DELETE CASCADE`.
- **Diagram pairs:** many databases declare no edge constraints. When the diagram was loaded, the node pairs of such edges were read once from the edge data and stored on the diagram. Show Definition run from a diagram reuses these pairs and writes an unnamed `CONNECTION (A TO B, ...)` without `ON DELETE`. No table data is queried again.
- A declared constraint always takes precedence over diagram pairs. Show Definition from the connections tree has no diagram, so only declared constraints appear there.
- Turn off `includeDiagramEdgeConnections` to emit declared constraints only.

```sql
CREATE TABLE dbo.likes
    (
     rating int ,
     CONNECTION (dbo.Person TO dbo.Restaurant, dbo.Person TO dbo.City)
    ) AS EDGE
```

## Unique constraints (ALTER TABLE)

```sql
ALTER TABLE dbo.City
    ADD CONSTRAINT UQ_City_Code UNIQUE NONCLUSTERED
    (
     Code
    )
```

The columns are listed one per line, as in indexes.

## Check constraints

A check expression of 60 characters or less stays on one line:

```sql
ALTER TABLE dbo.City
    ADD CONSTRAINT CK_City_Code CHECK ([Code]>(0))
```

Longer expressions are split:

- **Outer parentheses:** they are removed, and the expression is placed inside `CHECK (` ... `)` on indented lines.
- **OR and AND:** each top-level `OR` starts a new line. When an `OR` is present, the `AND` lines are indented one more level under it; otherwise `AND` lines align with the first operand.
- **Nested groups:** a parenthesized group longer than 60 characters that contains `AND` or `OR` at its own level is opened up as `OR (` / `AND (`. Its contents go one level (4 spaces) deeper, and the closing `)` aligns with the `OR`/`AND`. This repeats for deeper levels.
- **Never split:** `AND`/`OR` inside string literals, inside `[...]` or `"..."` identifiers, inside function calls, and the `AND` of `BETWEEN ... AND ...`.

```sql
ALTER TABLE Production.BillOfMaterials
    ADD CONSTRAINT CK_BillOfMaterials_BOMLevel CHECK (
        [ProductAssemblyID] IS NULL
            AND [BOMLevel]=(0)
            AND [PerAssemblyQty]=(1.00)
        OR [ProductAssemblyID] IS NOT NULL
            AND [BOMLevel]>=(1)
    )

ALTER TABLE Person.Person
    ADD CONSTRAINT CK_Person_PersonType CHECK (
        [PersonType] IS NULL
        OR (
            upper([PersonType])='GC'
            OR upper([PersonType])='SP'
            OR upper([PersonType])='EM'
        )
    )
```

With `constraintsAsAlterTable` off, the same rules apply inside `CREATE TABLE`. The constraint name stays on the item line and `CHECK (` moves to the next, indented line:

```sql
     CONSTRAINT CK_Product_Class
         CHECK (
             upper([Class])='H'
             OR upper([Class])='M'
             OR [Class] IS NULL
         ) ,
```

## Computed columns

Computed column expressions follow the same 60-character rule. Long expressions are moved inside `AS (` ... `)`:

- **Single `CASE` expression:** each `WHEN`/`ELSE` branch goes on its own line between `CASE` and `END`.
- **Otherwise:** the expression is split at `OR`/`AND`, as for check constraints.

```sql
     Status AS (
         case
             when [ID] between (1) and (10) then N'low'
             when [ID]>(100) then N'high'
             else N'mid'
         end
     ) PERSISTED ,
```

An expression with nothing to split on (no `CASE`, `AND` or `OR`) is placed on a single line inside `AS (` ... `)`.

## Indexes

```sql
CREATE UNIQUE INDEX IX_Person ON dbo.Person
    (
     ID DESC
    )
    INCLUDE
    (
     Name
    )
    WHERE ([ID]>(10))
```

- **Key columns:** each one is followed by an explicit `ASC` or `DESC`.
- **Index type:** `UNIQUE` and `CLUSTERED` are kept. `NONCLUSTERED` is omitted for rowstore indexes because it is the default.
- **Optional parts:** `INCLUDE` columns and the `WHERE` filter are added when present.
- **Columnstore indexes:** written as `CREATE NONCLUSTERED COLUMNSTORE INDEX ... (columns)` or `CREATE CLUSTERED COLUMNSTORE INDEX ... ON table`.

## Foreign keys

```sql
ALTER TABLE dbo.City
    ADD CONSTRAINT FK_City_Person FOREIGN KEY
    (
     PersonId
    )
    REFERENCES dbo.Person
    (
     ID
    )
    ON DELETE SET NULL
    ON UPDATE CASCADE
```

`ON DELETE` and `ON UPDATE` are written only when the action is not `NO ACTION`.

## Comments

With `includeComments`, object and column `MS_Description` values are written as `EXEC sys.sp_addextendedproperty`. The call stays on one line when it fits in 60 characters. Otherwise each parameter pair goes on its own line, indented 4 spaces. In practice every call is split:

```sql
EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'People',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Person'
```

## Views

- **Stored definition:** the view text is taken as stored in SQL Server (`OBJECT_DEFINITION`), unchanged except for trailing whitespace.
- **Encrypted views or missing VIEW DEFINITION permission:** a stub `CREATE VIEW name (columns) AS` is written instead, followed by a comment that explains why.
