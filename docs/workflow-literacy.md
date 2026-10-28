---
title: 'How the workflow works'
sources: [renv-sandbox-docs, quarto-github-pages]
sessions: ["2026-10-12", "2026-10-22", "2026-10-26", "2026-10-28"]
---

## Provenance checker

Think of the source registry as a catalog, session notes as the record of reasoning, and knowledge-base pages as current understanding. Page metadata names the sources and sessions behind it. A session's feeds list points to the pages it informs.

The checker reads these records, reports broken references, and updates three tables in governance.md. It cannot verify whether an argument is true. Edit the records, not the generated tables.

## renv

R packages can change. renv.lock records versions used here. On another machine, renv::restore() installs those versions into a project-specific library. The lockfile is tracked; installed packages are not. Adding a dependency requires an explanation and a deliberate snapshot.

The renv sandbox is a separate library containing links to R's base and recommended packages. It keeps other packages installed beside R from leaking into this project. A lock lets only one process prepare a shared sandbox at a time; another process waits until that lock is released.

On Windows, this project's .Rprofile gives each R session its own sandbox inside R's temporary directory before activating renv. Sessions can prepare their libraries independently. This avoids the shared-cache lock that blocked rendering on October 22 while keeping the sandbox enabled. The project library and renv.lock still control project packages. Each new session recreates its temporary sandbox; this adds a small startup cost. See the [renv sandbox documentation](https://rstudio.github.io/renv/reference/sandbox.html). Author comprehension review remains open.

## Quarto and reveal.js

Quarto converts editable Markdown into a browsable website. The deck uses reveal.js, an HTML slide format. The build profiles select public pages; nonpublic_notes is neither a page nor a resource.

The local build first validates provenance, then renders the site including the deck. An error stops the build. Rendering does not publish anything.

## Publishing the focused site

Rendering and publishing remain separate actions. `quarto render --profile focused` validates the project and builds the selected public pages in `_site-focused/`. After explicit publication authorization and review, `quarto publish gh-pages --profile focused --no-render --no-browser` copies that reviewed output to the dedicated `gh-pages` branch and pushes the branch to GitHub. The generated site remains excluded from `main`.

This is a manual deployment, not an automatic workflow. Repeat the render, review and publish steps when the public site should change. Treat the Pages site as public: the focused deck, its embedded speaker notes and the project-record pages selected in `_quarto-focused.yml` are all within the publication boundary. See the [official Quarto GitHub Pages guide](https://quarto.org/docs/publishing/github-pages.html).

## Author review

A build profile selects settings for a particular view of the same source documents. Complete renders the whole configured site; focused renders the explicitly selected documents. Separate output folders keep one build from overwriting the other. Neither profile publishes files. Both validate the entire provenance record first.

In focused output, a Lua filter (a small program run during document conversion) sends links to omitted Markdown documents to the repository. It reads the profile's render list, so that list is the authority for which pages stay local. Local source edits are unchanged; repository destinations reflect only published versions. Review unpushed omitted documents in the complete build. Profile and filter comprehension review remains open.

Explain these three mechanisms back in your own words before treating the comprehension criterion as complete. That review remains open; implementation approval alone is not evidence of understanding.
