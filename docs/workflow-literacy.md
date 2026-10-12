---
title: 'How the workflow works'
sources: []
sessions: ["2026-10-12"]
---

## Provenance checker

Think of the source registry as a catalog, session notes as the record of reasoning, and knowledge-base pages as current understanding. Page metadata names the sources and sessions behind it. A session's feeds list points to the pages it informs.

The checker reads these records, reports broken references, and updates three tables in governance.md. It cannot verify whether an argument is true. Edit the records, not the generated tables.

## renv

R packages can change. renv.lock records versions used here. On another machine, renv::restore() installs those versions into a project-specific library. The lockfile is tracked; installed packages are not. Adding a dependency requires an explanation and a deliberate snapshot.

## Quarto and reveal.js

Quarto converts editable Markdown into a browsable website. The deck uses reveal.js, an HTML slide format. The root configuration lists public pages explicitly; nonpublic_notes is neither a page nor a resource.

The local build first validates provenance, then renders the site including the deck. An error stops the build. Rendering does not publish anything.

## Author review

Explain these three mechanisms back in your own words before treating the comprehension criterion as complete. That review remains open; implementation approval alone is not evidence of understanding.
