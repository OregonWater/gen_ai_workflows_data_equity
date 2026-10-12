# Repository guidance

## Role and scope
Support Francisco J. Guerrero's presentation, *Frictionless Reasoning About a Resistant World*, for the 2026 Oregon Data Equity Summit. Preserve traceability, conceptual consistency, and reproducibility. This is a presentation project, not a reusable template. The human author owns every claim, decision, and word. Everything must be maintainable without AI.

Borrowed files are structural examples only. Do not import the example project's research, history, affiliations, collaborators, or claims. Do not imply a relationship with that project.

## First reads
1. README.md
2. docs/repository-guide.md
3. admin/governance.md
4. knowledge-base/09_ai-working-instructions.md, including its pre-session reading list
5. project.yml
6. admin/decisions-register.md

Inspect Git status and preserve user changes.

## Core workflow
Every substantive knowledge-base change is traceable to a dated session container.
1. Capture reasoning in sessions/YYYY-MM-DD.md using admin/new-note-template.md. Continue the same file for the same date.
2. Add provisional feeds targets; capture uncertain routing with status: open.
3. Reconcile affected knowledge-base and documentation pages.
4. Update sources and sessions frontmatter.
5. Update decisions, project log, and project.yml when project state changes.
6. Run Rscript tools/build-provenance.R.
7. Render and inspect the site and deck when appropriate.

## Scientific guardrails
Verify before asserting. Distinguish evidence, plans, interpretation, hypotheses, speculation, and illustrative examples. Register claims in knowledge-base/04_claims-evidence-risk-register.md before promoting them to slides or notes.
Register checked sources in references/sources.yml; explicitly label unverified leads. Do not cite unchecked sources as authority.
Distinguish inherited findings from newly produced work. Do not silently reverse recorded decisions.

## Public material and intake
Session notes are public. Raw transcripts and additional session summaries are not stored.
Nonpublic working notes belong in ignored nonpublic_notes/. Do not place confidential information in public session notes.
Never commit credentials, personal data, restricted communications, data files, or nonredistributable PDFs/images.
All data-folder contents except README.md and .gitkeep remain ignored unless the owner explicitly changes policy.
External AI contributions belong in references/external-ai-notes/, with separate registry keys and explicit verification status. Record their assessment in a session before reconciliation; they are reasoning provenance, not factual authority.
The original structural handoff files are retained as template provenance, not project research evidence.

## AI transparency
Session frontmatter records assistance and model; omit model for human-only work. Do not invent an exact model identifier if unavailable.
docs/how-this-was-made.md is author-written. Assistants may suggest structure and supporting session references, not draft the author's account.
Record what was delegated, what the author decided, and what was actually checked.

## Working preferences
Discuss concepts before implementation. Keep changes in scope of knowledge-base/01. Use small, legible increments.
Explain unfamiliar mechanisms in a literacy note before introducing them. Do not equate implementation approval with demonstrated understanding; record outstanding comprehension review.

## Code and documentation
Use numbered scripts/ for analysis and R/ for reusable functions; analysis figures go to outputs/.
Label ad hoc results until formalized. Pin R packages with renv and explain new dependencies.
Keep sources and sessions metadata current. Use artifacts/talk/ for the deck and notes.
Do not manually edit generated sections of admin/governance.md tagged project-state, source-inventory, or session-map; regenerate them.

## Git and publication
Do not commit unless explicitly asked. Do not push, publish, deploy, or release without explicit confirmation. Never revert user changes without authorization.
AI assistance is documented in session records. Do not add AI co-author trailers to commits.
