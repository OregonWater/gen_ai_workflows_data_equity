---
title: 'Reproducibility notes'
sources: [renv-sandbox-docs]
sessions: ["2026-10-12", "2026-10-22", "2026-10-26"]
---

## Environment

Setup detected R 4.6.1 and Quarto 1.10.18 on Windows. The R packages yaml and renv are available. renv.lock records yaml 2.3.12 and renv 1.2.4. Packages were copied from the existing library; no downloads were needed.

Quarto runs tools/build-provenance.R as its R pre-render hook. R must be discoverable by Quarto; QUARTO_R can identify its bin directory. On this machine its directory is C:/Program Files/R/R-4.6.1/bin. In a PowerShell session, prepend that directory to PATH before rendering if necessary. This affects only that terminal session.

## Fresh clone

Install R and Quarto, open the .Rproj, and run renv::restore(). Then run quarto render from the repository root. The .Rprofile activates the project environment.

## Build outputs

`quarto render` defaults to the complete profile. Its site is `_site-complete/index.html`; its deck is `_site-complete/artifacts/talk/deck.html`. The explicit command is `quarto render --profile complete`.

`quarto render --profile focused` builds ten selected pages in `_site-focused/`, including its own copy of the deck. Both outputs are local and ignored. The earlier `_site/` folder is legacy output, not updated by these profiles. No publication is part of the build.

Run `quarto inspect . --profile complete` or `quarto inspect . --profile focused` to inspect selections. The complete count grows with sessions and documentation; focused stays at ten until its explicit list changes. Both run the same full provenance check during rendering. See the repository guide for maintaining selections and repository-link routing.

## Validation

Passed on 2026-10-12:

- Provenance: 17 pages, one session, three sources; zero errors/warnings.
- Broken-copy checks: unknown source, unresolved feeds, and missing component all produced errors and nonzero exit; generated tables were unchanged.
- renv::status(): consistent project library and lockfile (R 4.6.1, renv 1.2.4, yaml 2.3.12).
- Local Markdown links and Git ignore checks passed.
- Example-project residue and placeholder scan clean outside historical handoff briefs (dependency code excluded).
- Quarto inspection recognizes the deck as reveal.js.

The author checked the files, rendered and previewed the project site on 2026-10-12, and confirmed it works as expected. This closes the local rendering blocker based on author-reported validation. Earlier, the managed assistant session could not open the Quarto cache database; that remains a diagnostic limitation of that session, not a current project blocker. No separate assistant visual inspection is claimed.

The managed session's Windows locale and renv sandbox activation required terminal-only diagnostic settings: LC_ALL=English_United States.utf8; RENV_CONFIG_SANDBOX_ENABLED=FALSE; RENV_CONFIG_CACHE_ENABLED=FALSE; RENV_CONFIG_SYNCHRONIZED_CHECK=FALSE; QUARTO_R=C:/Program Files/R/R-4.6.1/bin. These are not project defaults. The script explicitly reads UTF-8.

Local render and preview are confirmed by the author. Clean-machine restore and author comprehension review remain open.

## Windows startup lock repair — October 22

Rendering stalled at `Running script 'tools/build-provenance.R'`. A traced startup reached the shared sandbox lock acquisition; its owner was a live R subprocess launched by VS Code's R language server. This explains why renv waited rather than treating the lock as orphaned. Why that subprocess retained the lock was not established.

The project .Rprofile now sets `RENV_PATHS_SANDBOX` to a directory inside each Windows R session's `tempdir()` before activating renv. This replaces any inherited sandbox path on Windows and avoids waiting on the shared cache. Sandboxing remains enabled; package versions and the project library are unchanged. No global R or VS Code settings were changed. The supported path setting is described in the [renv documentation](https://rstudio.github.io/renv/reference/sandbox.html).

Use plain `quarto render` in a fresh terminal. If the earlier diagnostic settings were set in the current PowerShell terminal, remove `RENV_CONFIG_SANDBOX_ENABLED` with `Remove-Item Env:RENV_CONFIG_SANDBOX_ENABLED -ErrorAction SilentlyContinue` so the sandbox is enabled again. The earlier locale setting addresses warnings in the managed assistant environment and is not a new project default. Clean-machine restore and author comprehension review remain open.

## Limitations

A clean-machine restore is not yet verified. Author comprehension review remains open. No data or substantive analyses are included.
