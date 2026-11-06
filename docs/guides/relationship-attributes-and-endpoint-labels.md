# Relationship Attributes and Endpoint Labels

Logical relationships can present information owned by the relationship itself rather than either endpoint entity:

- **Relationship attributes** appear in a boxed panel on the relationship route.
- **Endpoint labels** show source-side and target-side relationship names, such as `works on` and `has assigned employees`.

## Work with endpoint labels

Endpoint labels appear near the corresponding relationship ends. Select a label to reveal its frame and resize handle, then drag the label to position it above or below the route. Resize longer labels when they need additional wrapping space.

Initial placement considers relationship optionality and cardinality so the two endpoint names remain distinguishable. Manual placement and size are saved with the diagram.

## Work with relationship attributes

Relationship-owned attributes appear as a panel attached to the relationship route. The panel distinguishes mandatory attributes, aligns attribute names, and indicates when its chosen height cannot show every row.

Move the panel along or near the relationship route and resize it from its handle. On routes with several bends, the panel remains associated with a nearby route segment.

Use the Diagram Details option for relationship attributes to show or hide these panels for the complete logical diagram.

## Save and restore

Manual endpoint-label and relationship-attribute placement is preserved when the diagram is saved and reopened. It also survives routing changes, Diagram Details changes, and undo or redo operations.

## Graph presentation

The same presentation concepts support graph diagrams:

- SQL Server graph displays use an endpoint label for the visible graph-edge name and a relationship-style panel for edge properties.
- Oracle Label Property Graph edge panels and tooltips can present grouped labels and properties for the complete graph element.
- SQL Server graph-table endpoint lines in the relational display use endpoint-role descriptions instead of exposing generated internal relationship names.

Graph edge names and property panels follow the effective edge color while keeping property text readable.

[Back to Modeling and SDDM Designs](../sddm-designs.md)
