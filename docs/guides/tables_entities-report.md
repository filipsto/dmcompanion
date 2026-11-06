# Tables and Entities Reports

The tables/entities report is generated from a relational/logical DMC model tree node as either interactive HTML or an A4 PDF. It can include selected model metadata and SVG renderings of persisted model-linked diagrams.


## User Workflow

1. Run **Generate Tables Report**(**Generate Entities Report**) on a relational/logical model node.
2. Configure the report in the tabbed dialog:
	- Set the Reports folder, report title, and report file name.
	- Select HTML or PDF when `dmc.reports.edgeExecutablePath` is configured. Without that setting, the existing HTML-only output is shown.
	- For PDF, choose whether each object starts on a new page. This is enabled by default. Also **company name** can be provided and it'll be printed on each page.
	- On **Templates**, optionally select an applicable SDDM report template and refine its section checkboxes. Dynamic properties remains a DMC-only section.
	- On **Objects**, optionally apply an SDDM report configuration to set the object and diagram selections. Use **All selected**, **All deselected**, or **Objects in selected diagrams** to update the object selection, then refine object and diagram checkboxes individually.
3. When the Reports folder is empty both in the dialog and in `dmc.reports.folder`, choose a folder from the native picker. The chosen folder is saved in that setting.
4. The extension writes one uniquely named artifact directly in the Reports folder, for example `<model-name>_tables.html`, `<model-name>_tables.pdf`, or a collision-safe `_1` variant. The selected format controls the extension even when another extension was entered.
5. HTML uses a content-addressed default stylesheet named `tables-report.<sha256>.css` and optionally loads `tables-report.custom.css` after it. PDF generation stages the exact `tables-report.html` and matching content-addressed bundled stylesheet in a random temporary directory under the Reports folder, then removes the directory after success or failure. Edge uses an isolated profile in the OS user temporary directory and falls back to the report staging directory when OS temporary storage is unavailable.
6. The generated report is opened with the system's default application.

Cancelling any picker stops generation without writing a report.
The output receives a unique name rather than overwriting an existing report.   
HTML reports provide navigation between object articles and their diagram cards. Links between included related objects and diagrams remain available in PDF where supported by the PDF viewer.

## HTML output

HTML reports include a sidebar object filter and embedded SVG diagrams. Each report references a versioned default stylesheet named `tables-report.<hash>.css`. The extension derives the hash from the bundled CSS, so newly generated reports automatically receive stylesheet fixes while older reports continue using the version with which they were generated.

To customize HTML reports, create `tables-report.custom.css` in the Reports folder before generating the report. The report loads this file after its versioned default stylesheet, allowing custom rules to override the defaults without blocking future stylesheet updates. Versioned stylesheets are extension-owned and should not be edited or deleted while older reports may still reference them.
>**Note:** CSS files `tables-report.<hash>.css` and `tables-report.custom.css` are used for both tables and entities reports

If one persisted diagram cannot be read or rendered, the report identifies that diagram while continuing with the remaining objects and diagrams.

## PDF setup

PDF generation uses a separately installed Microsoft Edge executable in headless mode. Set `dmc.reports.edgeExecutablePath` to its absolute path.

Common locations include:

```text
Windows: C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe
macOS:   /Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge
Linux:   /usr/bin/microsoft-edge or /usr/bin/microsoft-edge-stable
```

When Edge is not configured, the report workflow offers HTML output only. An invalid Edge path or unsuccessful PDF process reports an error rather than silently producing HTML.

When PDF is selected, the dialog shows **Start each object on a new page** and a **Company name** field directly below it. Set `dmc.reports.companyName` in extension settings to prefill the company name. Changes in the dialog apply to that PDF only, except when the setting is empty: after a successful PDF with a nonempty name, the extension saves that name as the new default. HTML reports do not use either PDF option.

PDF input and its versioned bundled CSS are staged in a temporary directory under the configured Reports folder and removed after Edge finishes, including when generation fails. PDF output does not apply `tables-report.custom.css`, keeping generated PDFs deterministic. Only the PDF is retained. Edge normally creates its isolated browser profile in the operating system's user temporary directory; if that location is unavailable, generation falls back to the report staging directory.

## PDF layout

PDF output uses A4 pages. The generator compares portrait and landscape contain scales and selects the orientation that renders each diagram larger. Diagrams are enlarged or reduced to the largest size that fits both the printable page width and the space below the title while preserving aspect ratio. Each diagram begins on a new page. Large diagrams should be arranged or scoped with print readability in mind.

When **Start each object on a new page** is enabled, the first object follows the report metadata and later objects begin on new pages without separator lines above their headings. With the option disabled, objects retain their separator lines. If used user-defined properties are included, their definitions table begins on a new PDF page regardless of this option. HTML reports keep their existing layout.

The PDF includes a table of contents with clickable links where supported by the viewer. Browser-generated outline bookmarks depend on the installed Edge version.

With Microsoft Edge 131 or newer, each page prints the optional company name at bottom left and `Data Modeler Companion · Page X of Y` at bottom right, including contents, object, portrait diagram, and landscape diagram pages. A blank company name leaves the left side empty. Older Edge versions do not support the CSS page-margin boxes used for these footers.

## Diagram selection and navigation

Selecting specific diagrams controls both the diagrams included in the report and the objects derived by the **Objects in selected diagrams** scope. Multi-display diagram workspaces identify each display by name.

When an object appears more than once in one display, report navigation uses one canonical placement. Objects or diagrams excluded from the report remain visible where needed for diagram context but do not receive report navigation targets.
