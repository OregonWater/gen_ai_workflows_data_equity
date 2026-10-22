---
title: 'Repository guide'
sources: []
sessions: ["2026-10-12", "2026-10-22"]
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
| _site/ | Ignored local rendered site and deck |

## Root files

README.md introduces the project. AGENTS.md guides assistants. project.yml records current state.
_quarto.yml controls the public site and its deck. renv.lock records R dependencies. LICENSE and LICENSING.md define the agreed split.

## Numbered knowledge base

00 overview; 01 thesis; 02 terms; 03 literature; 04 claims; 05 methods; 06 visuals; 07 narrative; 08 audience/venue; 09 AI protocol.

A feeds token such as knowledge-base/02 resolves to the uniquely numbered page beginning 02_. Keep those prefixes stable.

## Source and session metadata

sources lists registry keys; sessions lists dated containers. Session raw-inputs references registry keys or the literals “conversation only” and “prior sources revisited”. Mark unrouted observations open, then reconcile intentionally.

## One local build

Run quarto render from the repository root. The pre-render check validates provenance; Quarto renders the website and deck together. Deck formatting lives in deck.qmd so it participates in the same website project without a nested project.

## Public boundaries

Render targets are explicit. Do not add nonpublic_notes, data, source PDFs, raw transcripts, or structural example archives as site resources. Publishing the site or pushing the repository requires separate approval.
