# Frictionless Reasoning About a Resistant World

A presentation project by **Francisco J. Guerrero** on GenAI supported workflows and data equity.

**Venue:** 3rd Annual State of Oregon Data Equity Summit — Building Sustainable Data Equity Practices.
[Official event website](https://www.oregon.gov/odhs/data/Pages/data-equity-summit.aspx) (provided by the author; event details have not yet been independently checked).

## Start here

- [Project overview](docs/project-overview.md)
- [Repository guide](docs/repository-guide.md)
- [Current project state](project.yml)
- [Latest session](sessions/2026-10-12.md)
- [Decisions](admin/decisions-register.md)
- [Working protocol](knowledge-base/09_ai-working-instructions.md)

The talk and documented development process are intended to be shared publicly. The repository is AI-assisted, not AI-dependent: its records are editable by hand, and the author owns every claim and decision.

## Local setup and build

Install R and Quarto, then clone this repository. Open `gen_ai_workflows_data_equity.Rproj`.
On a fresh clone, run `renv::restore()` in R to restore the recorded packages.

From the repository root:

```text
quarto render
```

The build validates provenance and renders both the notebook site and the reveal.js deck.
Open `_site/index.html` for the site and `_site/artifacts/talk/deck.html` for the deck.
Use `quarto preview` for local browsing. See [reproducibility notes](docs/reproducibility-notes.md) for versions and Windows setup.

## Scope and status

The structure and provenance checks are in place. The author successfully rendered and previewed the project site on 2026-10-12 and confirmed it works as expected; see reproducibility notes. For content, the argument, audience requirements, examples, and time budget remain open. The deck is a placeholder, not an approved narrative.

No raw transcripts are stored. Session containers are the session record; the project log and decision register serve the distinct roles specified by the workflow.

Data, source PDFs, generated output, and `nonpublic_notes/` are excluded from version control. Never force-add them. Git ignores do not provide encryption or access control.

## Licensing

Code: MIT. Original written content and slides: CC BY 4.0. Data: excluded.
See [LICENSING.md](LICENSING.md). Third-party material retains its own terms.

Commit only on the author's explicit request. Pushing or publishing requires separate explicit confirmation.
