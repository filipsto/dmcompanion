# Reports generated from imported Oracle SQL Developer Data Modeler design
Functionality to generate report appears in context menu on nodes for imported DMC Logical and Relational models.

## SDDM design
Relational model is based on reverse engineering of some tables from my test HR schema.
After that relational model is engineered to Logical model.
Logical model is extended by adding new entity Project and defined relationship attributes in relationship with Employee entity.
Source and target labels are set on some of relationships.
**Driver License** entity is added to show non transferable relationship.

If you wonder about strange .css file read [description](../../../docs/guides/tables_entities-report.md#html-output) how it's constructed and how correctly to change appearance with your own `tables-report.custom.css` 
CSS file is used for tables and entities reports.

New elements in tables and entities reports are inclusion of dynamic and user defined properties in content and TOC.

## Tables report
Remote objects are presented in report TOC and in content part with trailing link symbol, on diagram they have usual SDDM presentation with link symbol at top left corner.
![Remote Objects presentation](../../../media/screenshots/Remote_objects.png)

New abbreviations appear in column for Mandatory (M) status - Id(identity) and DoN(Default on Null) as well definition of identity/sequence used:
![example for identity and default on null column](../../../media/screenshots/Identity_and_Default_On_Null.png)

Here is the [Tables HTML report](Demo_report_for_tables.html) generated from DMC relational model.

And [PDF version of Tables Report](Demo_report_for_tables.pdf)
For PDF version "Start each object on new page" is selected and company name is "© Data Test Company".

## Entity report

In addition to information in SDDM entities report support for details of relationship attributes is added.
 You kan see  [presentation on diagram](Demo_report_for_entities.html#diagram-object-%5B%223AD4B2F6-41FD-D0E5-4209-1D9779C35F52%22%2C%22Logical.dmcmd%22%2C%22tab%3AED66000A-F7E0-656D-5935-4D39CD6DEBEC%22%5D)   
 or can find details in content section for [Employee](Demo_report_for_entities.html#entity-3AD4B2F6-41FD-D0E5-4209-1D9779C35F52)