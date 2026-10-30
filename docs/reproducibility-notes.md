---
title: 'Reproducibility notes'
sources: [renv-sandbox-docs, quarto-github-pages]
sessions: ["2026-10-12", "2026-10-22", "2026-10-26", "2026-10-29"]
---

## Environment

Setup detected R 4.6.1 and Quarto 1.10.18 on Windows. The R packages yaml and renv are available. renv.lock records yaml 2.3.12 and renv 1.2.4. Packages were copied from the existing library; no downloads were needed.

Quarto runs tools/build-provenance.R as its R pre-render hook. R must be discoverable by Quarto; QUARTO_R can identify its bin directory. On this machine its directory is C:/Program Files/R/R-4.6.1/bin. In a PowerShell session, prepend that directory to PATH before rendering if necessary. This affects only that terminal session.

## Fresh clone

Install R and Quarto, open the .Rproj, and run renv::restore(). Then run quarto render from the repository root. The .Rprofile activates the project environment.

## Build outputs

`quarto render` defaults to the complete profile. Its site is `_site-complete/index.html`; its deck is `_site-complete/artifacts/talk/deck.html`. The explicit command is `quarto render --profile complete`.

`quarto render --profile focused` builds the selected pages in `_site-focused/`, including its own copy of the deck. Both outputs are local and ignored. The earlier `_site/` folder is legacy output, not updated by these profiles. No publication is part of the build.

Run `quarto inspect . --profile complete` or `quarto inspect . --profile focused` to inspect selections. The complete count grows with sessions and documentation; focused follows its explicit page list. Both run the same full provenance check during rendering. See the repository guide for maintaining selections and repository-link routing.

## Updating and publishing site content

Edit source files, not generated copies in `_site-complete/`, `_site-focused/` or the `gh-pages` branch. The focused profile is the routine review and publication build. The complete profile is a periodic comprehensive check; it does not need to be rendered after every focused-site change.

### Updating existing files

For an existing page already selected by the focused profile, edit the source once and render focused:

```powershell
quarto render --profile focused
```

This runs the full provenance check and refreshes the public-site candidate in `_site-focused/`. Existing supporting files such as CSS or images do not normally need their own `project.render` entries: a selected page or the project configuration incorporates or copies them when referenced. Confirm that new or changed assets are tracked, redistributable and outside ignored or restricted locations.

Review the rendered candidate through the repository's static server:

```powershell
./tools/serve-site.ps1 -Profile focused -Port 7188
```

Open `http://localhost:7188/` for the site, `http://localhost:7188/artifacts/talk/deck.html` for the presentation and `http://localhost:7188/docs/reproducibility-notes.html` for these instructions. Stop the server with Ctrl+C. If port 7188 is already in use, choose another port and use that number in the URLs.

The server presents the existing `_site-focused/` output over local HTTP, which is closer to GitHub Pages behavior than opening an HTML file directly from File Explorer. It allows relative links, scripts, search and copied assets to be checked without the browser restrictions and path differences associated with `file://` URLs. Unlike `quarto preview`, this read-only server does not watch source files, display Quarto's Render dialog or trigger another render during review. The files being reviewed therefore remain the exact publication candidate produced by the preceding focused render.

Check the landing page and focused navigation; the changed pages or slides; deck images, layout and transitions; Speaker View and notes using the `S` key; affected links and search results; and the absence of unintended, ignored or nonpublic files. Do not edit generated files to correct a problem: stop the server, edit the source, render focused again and repeat the review.

Render the complete profile periodically rather than as part of every routine edit:

```powershell
quarto render --profile complete
```

Appropriate checkpoints include a broad project review or close-out, changes to complete-profile selection or navigation, adding or moving pages, reviewing unpushed edits to pages omitted from focused, and checking that the full knowledge base, sessions, documentation and deck still render together. An existing file shared by both profiles requires no profile-configuration change; each output reflects the edit the next time that profile is rendered.

### Adding new files

For a new page, distinguish render selection from navigation. `project.render` determines whether Quarto creates the page. `website.sidebar` or `website.navbar` determines whether readers can discover it through site navigation. A rendered page may intentionally be absent from navigation when another page links to it directly.

The complete profile automatically selects Markdown files directly within `knowledge-base/`, `sessions/` and `docs/`. Those patterns are not recursive and do not cover every directory or file type. Add an explicit entry to `_quarto-complete.yml` when a new page falls outside its existing patterns.

The focused profile is an explicit publication boundary. Add a new public page to `project.render` in `_quarto-focused.yml`, and add a sidebar or navbar entry when it should be discoverable through navigation. Render each affected profile once after adding or restructuring pages to verify its selection, navigation and links. Subsequent routine edits can return to the focused cadence above.

A link alone does not include its target in a profile. During a focused render, `tools/focused-links.lua` keeps local links to selected pages and redirects links to omitted Markdown pages to their source on the repository's `main` branch. A redirected repository link does not make that page part of the GitHub Pages site.

New images, stylesheets and similar supporting assets normally belong in a tracked source location and are referenced by an included page or configuration; they do not normally belong in `project.render`. After rendering, verify that they appear in every intended output and that no ignored, nonpublic or restricted material was copied.

### Commit and publish

After reviewing the affected output, inspect the source changes and exclusions:

```powershell
git status --short
git diff --check
git diff
```

Stage explicit source and provenance files, inspect the staged diff, and commit only with the author's authorization. Do not stage `_site-focused/`, `_site-complete/`, private notes, data, source PDFs or unrelated working files. Use the commit convention in the repository guide. Pushing `main` requires separate explicit authorization.

After an authorized source push and a successful focused render, publish the exact reviewed focused output only with separate publication authorization:

```powershell
quarto publish gh-pages --profile focused --no-render
```

The `--no-render` option prevents publication from silently rebuilding the candidate after review. Quarto updates and pushes the dedicated `gh-pages` branch; `_site-complete/` remains a local review output and is not published. Confirm the new `gh-pages` build, open the public landing page and affected URLs, verify key assets and deck behavior, review Git status again, and record the result in the dated session.

## Validation

For presenting the already-rendered site without Quarto's Render dialog, run:

```powershell
./tools/serve-site.ps1 -Profile focused -Port 7188
```

Open `http://localhost:7188/docs/smart-folder.html`. This read-only local server serves existing output; it does not watch or render source files. Stop it with Ctrl+C. Run `quarto render --profile focused` again when source changes should appear. The same command accepts `-Profile complete` to browse that output instead.

On 2026-10-26, both profile renders completed: complete selected 30 targets and focused selected ten. Full provenance validation passed with 17 content pages, seven sessions and 28 sources; automated checks found no broken local HTML links in either output. The author subsequently previewed both sites and reported that both work. This is author-reported browser validation; no assistant visual inspection is claimed.

For side-by-side review, run these commands in separate terminals:

```powershell
quarto preview --profile complete --port 7186 --render none --no-watch-inputs
quarto preview --profile focused --port 7187 --render none --no-watch-inputs
```

Open `http://localhost:7186` and `http://localhost:7187`. Stop each server with Ctrl+C. `--render none` skips the initial render and `--no-watch-inputs` disables rendering triggered by file changes; the preview server can still render pages during navigation. The author's screenshot shows Quarto's Render dialog, which belongs to preview rather than site content. Static serving of generated HTML remains a separate follow-up; it has not been tested here.

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
