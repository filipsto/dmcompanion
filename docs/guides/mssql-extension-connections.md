# MSSQL Extension Connections

Data Modeler Companion can use connection profiles saved by the Microsoft **SQL Server (mssql)** extension (`ms-mssql.mssql`). You do not need to define the same server twice, and credentials stay in the MSSQL extension.

## Requirements

- The SQL Server (mssql) extension is installed and enabled. Its version must provide the shared connections API.
- At least one connection profile is saved in that extension. Profiles are read from the `mssql.connections` setting, at user, workspace and workspace-folder level.

## The MSSQL Connections view

The **MSSQL Connections** view has two branches:

| Branch | Content |
| --- | --- |
| **DMC Connections** | Connections created in Data Modeler Companion and run with its built-in `mssql` driver. |
| **MSSQL Extension Connections** | Profiles saved in the SQL Server (mssql) extension. |

The second branch refreshes automatically when profiles are added, edited or removed in the MSSQL extension, or when the extension is installed or uninstalled.

If the MSSQL extension is not installed, the branch shows a node that opens the extension in the Extensions view.

## Connection groups

Profiles in the **MSSQL Extension Connections** branch are arranged in the same groups as in the MSSQL extension (`mssql.connectionGroups`).

- Groups can be nested. Child groups appear before connections, sorted by the group's order and then by name.
- Groups that contain no connections, directly or in child groups, are hidden.
- Profiles without a group, or whose group no longer exists, appear directly under the branch.
- A group's color from the MSSQL extension is applied to its folder icon and label. Connections themselves are not coloured.
- The connection picker shows the group path, for example `MSSQL extension › Prod / Sales`.

Groups are read-only here. Create, rename or recolor them in the MSSQL extension; the view refreshes automatically.

## Connecting

Select a profile and choose **Connect**, or expand the profile.

- The MSSQL extension handles authentication: SQL Login, Windows Integrated, or Microsoft Entra ID. If a sign-in is needed, its prompt appears.
- Passwords are never stored by Data Modeler Companion.
- **Disconnect** closes the connections Data Modeler Companion opened through the MSSQL extension. Connections opened by the MSSQL extension's own editors are not affected.

## Database is optional

Unlike DMC connections, an MSSQL extension profile does not need a database.

- **Profile with a database:** expanding it shows that database's schemas and objects, as for DMC connections.
- **Profile without a database:** expanding it lists the databases on the server. Each database can be expanded and used as a diagram source.
- **Profile-level actions** such as **New Diagram** and **Create Diagram** ask you to pick a database when the profile has none.

The database you choose is saved with the diagram, so reopening it uses the same database.

## Schema filters

For both **DMC Connections** and **MSSQL Extension Connections**, schema filters are saved separately for each database within each connection.

- **On a connection with a configured database:** **Filter Schemas** edits the filter for that database only.
- **On a database node:** **Filter Schemas** edits that database's filter, including databases under **Other Databases** and profiles without a configured database.
- **On a connection without a configured database:** the action displays: "Data Modeler Companion: this connection has no default database configured. Expand the connection and use Filter Schemas on a database."

Filters apply to schema lists in the connection tree and the **Add Objects** dialog for the diagram's database. A database without a filter shows all available schemas, regardless of filters saved for other databases. Existing default/current-schema inclusion rules remain unchanged, including keeping `dbo` visible.

Clear all selections to remove only that database's filter. Cancelling leaves the filter unchanged. Filters are saved in the current VS Code workspace and restored when it is reopened.

Previous connection-wide SQL Server filters are not migrated or used. Select schemas again for each database.

## Available actions

All diagram actions work the same way as for DMC connections:

- Connect, Disconnect and Test Connection
- Filter Schemas
- New Diagram and Create Diagram, on the connection or on a database
- Schema, folder and object actions: Create Diagram, Add to Diagram, Add with Dependencies, Add with Recursive Dependencies and Add with Neighbors
- The Add Objects dialog in an open diagram

### Show Create Script

MSSQL extension connections also offer **Show Create Script**. The MSSQL extension generates the script.

- **In the connection tree:** right-click a table, graph table or view. If you select several objects from one database, they are scripted together.
- **In a diagram:** right-click a table, graph table or view. If the object is part of the current selection, every selected supported object is scripted.
- **For the whole display:** right-click the empty canvas and choose **Show Create Script (All Objects)** to script every supported object on the current display.

The scripts open in one untitled `.sql` editor. Objects that fail are listed as `--` comments at the end of the document.

Schema and object names keep the case they have in the database. 

DMC connections do not offer this action.

>**Note:** **Edit**, **Clone** and **Delete** are not available, because the MSSQL extension owns these profiles. Manage them in the MSSQL extension instead.

## Reopening saved diagrams

When a saved MSSQL diagram is reopened, Data Modeler Companion looks for its connection by name in both branches.

If no connection matches, a picker lists connections from both branches. Each entry is labelled **DMC** or **MSSQL extension**.

## Notes and limitations

- **One query at a time:** queries on the same profile and database run one after another.
- **Reconnects:** if a connection was dropped, for example after the MSSQL extension restarts or the sign-in changes, Data Modeler Companion reconnects once and retries the query.
- **Separate state:** schema filters are scoped to each connection and database. MSSQL extension profiles have separate filters and cache entries from DMC connections that point to the same server.
- **Disconnect on exit:** connections opened through the MSSQL extension are closed when VS Code shuts down.
