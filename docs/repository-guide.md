---
title: 'Repository guide'
sources: []
sessions: ["2026-10-12", "2026-10-22", "2026-10-25", "2026-10-26"]
---

## Folder roles

| Location | Role |
| --- | --- |
| admin/ | Governance, decisions, project log, session template |
| admin/template-repos/ | Historical structural handoff briefs; not current instructions |
| sessions/ | One dated session container per day |
| knowledge-base/ | Ten numbered pages of current understanding |
| references/ | Source registry, bibliography, external-input guidance |
| references/source-assessments/ | Public, source-keyed reading assessments; use references/source-assessment-guide.md |
| docs/ | Human-facing project and workflow documentation |
| artifacts/talk/ | Editable reveal.js deck, notes, and reusable assets |
| scripts/ and R/ | Numbered analysis scripts and reusable functions |
| tools/ | Provenance checker |
| data/ | Local ignored data; tracked README files explain roles |
| outputs/ | Ignored generated figures/tables |
| nonpublic_notes/ | Entirely ignored local notes |
| renv/ | Environment bootstrap/settings; installed libraries ignored |
| _site-complete/ and _site-focused/ | Ignored local rendered sites and decks |

## Root files

README.md introduces the project. AGENTS.md guides assistants. project.yml records current state.
_quarto.yml controls the public site and its deck. renv.lock records R dependencies. LICENSE and LICENSING.md define the agreed split.

## Numbered knowledge base

00 overview; 01 thesis; 02 terms; 03 literature; 04 claims; 05 methods; 06 visuals; 07 narrative; 08 audience/venue; 09 AI protocol.

A feeds token such as knowledge-base/02 resolves to the uniquely numbered page beginning 02_. Keep those prefixes stable.

## Source and session metadata

sources lists registry keys; sessions lists dated containers. Session raw-inputs references registry keys or the literals “conversation only” and “prior sources revisited”. Mark unrouted observations open, then reconcile intentionally.

## Local builds

Run `quarto render` (or `quarto render --profile complete`) for the complete review site in `_site-complete/`. Run `quarto render --profile focused` for the ten selected pages in `_site-focused/`. Preview either with `quarto preview --profile complete` or `quarto preview --profile focused`. Use one profile at a time.

Shared settings and the default profile group live in `_quarto.yml`. Each `_quarto-{name}.yml` holds its render selection and sidebar. Complete uses anchored directory globs; focused uses explicit paths, including the current selected session. To replace that session, edit both its render entry and sidebar entry. Both profiles exclude `tmp/` and run the full provenance check. Deck formatting stays in deck.qmd.

`tools/focused-links.lua` reads the focused profile's target list and redirects links to omitted Markdown pages to their sources on the repository's main branch. Included pages retain local links. Repository links show published content, so use the complete build to review unpushed changes to omitted pages. The filter changes output only. No documents are deleted or copied into a separate source tree.

## Commit messages

Use `type(scope): description`, or `type: description` when a scope adds no useful detail. Choose the type by the purpose of the change.

| Type | Purpose | Example |
| --- | --- | --- |
| `docs` | Develop written content, including knowledge, references, administration, slides and notes | `docs(knowledge): clarify mediation model and story scope` |
| `fix` | Correct something broken or demonstrably incorrect | `fix(build): prevent shared renv sandbox lock` |
| `chore` | Maintain configuration, dependencies or tooling | `chore(deps): update renv lockfile` |

Use singular `fix` and `chore`; do not add overlapping `bugs`, `fixes` or `chores` types. Developing an interpretation is `docs`; correcting a wrong citation date is `fix(references)`.

Recurring optional scopes are `admin` (sessions, decisions, governance and project state), `knowledge` (conceptual development and synthesis), `references` (bibliography, source registry and assessments), and `talk` (deck, speaker notes and presentation assets). Use `build` or `deps` when needed. Omit the scope for changes spanning several areas. Supporting session and governance updates can accompany the main change in the same commit.

This section is the authoritative convention; AGENTS.md points here. Commit and publication authorization rules still apply.

## Public boundaries

Render targets are explicit. Do not add nonpublic_notes, data, source PDFs, raw transcripts, or structural example archives as site resources. Publishing the site or pushing the repository requires separate approval.
