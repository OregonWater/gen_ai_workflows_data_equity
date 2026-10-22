---
title: 'How the workflow works'
sources: [renv-sandbox-docs]
sessions: ["2026-10-12", "2026-10-22"]
---

## Provenance checker

Think of the source registry as a catalog, session notes as the record of reasoning, and knowledge-base pages as current understanding. Page metadata names the sources and sessions behind it. A session's feeds list points to the pages it informs.

The checker reads these records, reports broken references, and updates three tables in governance.md. It cannot verify whether an argument is true. Edit the records, not the generated tables.

## renv

R packages can change. renv.lock records versions used here. On another machine, renv::restore() installs those versions into a project-specific library. The lockfile is tracked; installed packages are not. Adding a dependency requires an explanation and a deliberate snapshot.

The renv sandbox is a separate library containing links to R's base and recommended packages. It keeps other packages installed beside R from leaking into this project. A lock lets only one process prepare a shared sandbox at a time; another process waits until that lock is released.

On Windows, this project's .Rprofile gives each R session its own sandbox inside R's temporary directory before activating renv. Sessions can prepare their libraries independently. This avoids the shared-cache lock that blocked rendering on October 22 while keeping the sandbox enabled. The project library and renv.lock still control project packages. Each new session recreates its temporary sandbox; this adds a small startup cost. See the [renv sandbox documentation](https://rstudio.github.io/renv/reference/sandbox.html). Author comprehension review remains open.

## Quarto and reveal.js

Quarto converts editable Markdown into a browsable website. The deck uses reveal.js, an HTML slide format. The root configuration lists public pages explicitly; nonpublic_notes is neither a page nor a resource.

The local build first validates provenance, then renders the site including the deck. An error stops the build. Rendering does not publish anything.

## Author review

Explain these three mechanisms back in your own words before treating the comprehension criterion as complete. That review remains open; implementation approval alone is not evidence of understanding.
