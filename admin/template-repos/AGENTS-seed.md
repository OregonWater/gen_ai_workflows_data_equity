# AGENTS-seed.md — draft `AGENTS.md` for `research-artifact-template`

2026-10-08 (`sessions/2026-10-08.md`). Hand-off file 2 of 2. This is the **draft** of the new
repository's `AGENTS.md`, adapted from the source repo's. Copy the text below the rule into the
new repo as `AGENTS.md`, fill the `{{placeholders}}`, and polish it in the first working
session. Items marked **[DECIDE]** are open and are for the author to settle there; do not
treat them as rules until they are.

What was changed from the source repo's `AGENTS.md`, so the polish step can check each:

- Dropped: the Companion Repository section; the Loon Lake / information-geometry specifics in
  Role, First Reads and Scientific Guardrails.
- Generalized: "manuscript" → "artifact" where the rule applies to any communication artifact.
- Added: a **Public repository** section, an **AI-use transparency** section, and an **Author
  working preferences** section (project memory does not travel between repositories, so the
  preferences live here).
- Kept verbatim in spirit: the Core Rule, Intake Rule, External AI Contributions, Data and
  Copyright, Generated Content, Git Practice, Default Assistant Behavior.

---

# AGENTS.md

## Role

This repository supports `{{project-name}}`, a scientific-communication artifact (`{{artifact-name}}`,
for `{{venue}}`). Treat it as a research artifact, not just a codebase. Your job is to help
preserve scientific traceability, conceptual consistency, and reproducibility. The process is
**AI-assisted, not AI-dependent** — everything here should be maintainable by hand; the human
author owns every claim, decision, and word regardless of how a draft was produced
(`knowledge-base/09`). **[DECIDE]** the file number once the knowledge-base skeleton is fixed.

## First Reads

Before substantive work, read:

1. `README.md` — public project overview.
2. `docs/repository-guide.md` — folder structure and file roles.
3. `admin/governance.md` — provenance model and session-container rule.
4. `knowledge-base/09_ai-working-instructions.md` — working protocol and guardrails. Follow its
   own pre-session reading list rather than duplicating it here.
5. `project.yml` — current project state, blockers, component status, and next actions.
6. `admin/decisions-register.md` — active decisions; do not silently reverse them.

## Core Rule

Every substantive knowledge-base change must be traceable to a session container in
`sessions/YYYY-MM-DD.md`. Use `admin/new-note-template.md` to start one.

A session container is human-authorable and does not require AI. If an observation is rough or
not yet routed, capture it first in a dated session note, then reconcile it later.

Use this workflow:

1. Record the observation, result, decision, or question in `sessions/YYYY-MM-DD.md`.
2. Add provisional `feeds:` targets if they are obvious.
3. Update affected `knowledge-base/` or `docs/` pages.
4. Update page frontmatter `sessions:` and `sources:` as needed.
5. Update `admin/decisions-register.md`, `admin/project-log.md`, or `project.yml` only when the
   change affects project state.
6. Run `Rscript tools/build-provenance.R` from the repo root.
7. Render/check the Quarto site (and the deck) when appropriate.

## Intake Rule

Do not let structure block capture. If the correct destination is unclear, write the
conceptual note anyway with `status: open` rather than waiting to classify it — that status is
the existing low-friction capture mechanism (`admin/new-note-template.md`), not a separate
inbox section. Routing to the claims register, methods, narrative skeleton, key terms, or a
project decision can happen later, once the observation is well enough formed to feed a
specific page.

## Scientific Guardrails

- Verify before asserting. If evidence is incomplete, say so.
- Distinguish data-supported results, methodological plans, interpretations, hypotheses, and
  speculation. A slide states which of these it is.
- Do not promote a claim to slides, speaker notes, or other artifact prose unless it is
  represented in `knowledge-base/04_claims-evidence-risk-register.md`.
- Do not silently relitigate or reverse decisions recorded in `admin/decisions-register.md`.
- Preserve the distinction between inherited results (the author's earlier work, others'
  published work) and newly derived analyses; label which each slide shows.
- Do not cite a source you have not checked. A citation is a registered source in
  `references/sources.yml` or it is a flagged unverified lead.

## Public repository

This repository is public from the first commit.

- Everything committed is public, including session containers, the decisions register and the
  project log. Write them accordingly.
- **[DECIDE]** the candor rule: material that is candid and should not be public stays local
  and uncommitted (for example, in a git-ignored `private/` folder). State the rule once the
  author confirms it, and add `private/` to `.gitignore` if adopted.
- Never record credentials, tokens, personal data, unpublished third-party results, or other
  people's confidential communications in any committed file.

## Data and Copyright

- Never commit raw, processed, intermediate, or external data files unless the repository
  policy is explicitly changed by the owner.
- Never commit copyrighted PDFs, or images and figures whose licenses do not allow
  redistribution. Slide assets in `artifacts/` must be redistributable or created by the author.
- Use `references/sources.yml` to register source materials.
- Data and PDFs may be described, cited, and summarized, but redistribution is restricted.

## External AI Contributions

Content synthesized in a conversation with an AI assistant other than the one currently
maintaining this repository (e.g. notes produced with a different model or platform, brought in
from outside the working session) is an **external contribution** — it belongs in the raw-sources
layer (`admin/governance.md`), not in a session container and not directly in the knowledge base.
This is deliberately general: it applies to future imports as much as to past ones.

- **Register it as a source**, in `references/sources.yml`, exactly like a paper or dataset — an
  input to be evaluated, not adopted. Give it its own key; do not fold it silently into an
  existing entry.
- **Store the raw files in `references/external-ai-notes/`**, not in an ad hoc top-level folder.
- **Require explicit verification status** on the contribution itself — what has and has not been
  checked against primary sources, equations, or citations. Treat anything unflagged as unverified
  by default.
- **Route it through the ordinary Intake Rule**: capture it in a session container, assess it
  there, and only reconcile it into `knowledge-base/` once it clears the Scientific Guardrails
  above. An external AI's synthesis is never a citable authority in itself — at most a
  citable-provenance record of a line of reasoning that must still be checked.
- This is distinct from the rule that raw chat transcripts of *this* repository's working
  sessions stay outside the repository (`admin/governance.md`). **[DECIDE]** whether selected
  excerpts are published (see `docs/how-this-was-made.md`).

## AI-use transparency

The repository itself is one of the two things shared with the audience; the other is the
artifact. Part of its purpose is to show how generative AI was used.

- Every session container records `assistance:` and `model:` in frontmatter; omit the `model:`
  line for a human-only session.
- `docs/how-this-was-made.md` is written by the author, not by the assistant. The assistant may
  suggest structure and point to the session containers that support each statement; the
  account and its claims are the author's.
- Do not inflate or minimize the assistant's role in session notes. Record what was delegated,
  what the author decided, and what was checked, plainly.

## Coding Standards

- Keep analysis scripts in `scripts/`, numbered in pipeline order.
- Keep reusable R functions in `R/`.
- Prefer reproducible scripts over ad hoc notebook-only results. Figures on slides come from a
  script in `scripts/` and land in `outputs/`.
- Do not rewrite unrelated code or documentation while completing a focused task.
- Do not add unnecessary abstractions.
- Match existing R style and project conventions.
- If a result was produced ad hoc, label it as ad hoc until it is formalized in the pipeline.
- Pin R packages with `renv`; do not add a dependency without saying why.

## Documentation Standards

- `knowledge-base/` stores synthesized current understanding.
- `sessions/` stores how understanding changed during working sessions.
- `admin/` stores governance, project log, and decisions.
- `docs/` stores human-facing project documentation.
- `artifacts/<name>/` stores the shareable artifact (the deck and its notes).
- Keep frontmatter current:
  - `sources:` lists registered source keys from `references/sources.yml`.
  - `sessions:` lists session containers that contributed to the page.

## Generated Content

Do not manually edit generated sections inside `admin/governance.md` between these markers:

- `<!-- BEGIN GENERATED: project-state -->`
- `<!-- BEGIN GENERATED: source-inventory -->`
- `<!-- BEGIN GENERATED: session-map -->`

Regenerate them with:

```text
Rscript tools/build-provenance.R
```

## Git Practice

- Do not commit unless the author explicitly asks.
- Do not push, publish, release data, deploy the site, or perform any outward-facing action
  without explicit confirmation. In a public repository, a push is publication.
- Do not revert user changes unless explicitly asked.
- If changes include AI-assisted work and the author asks for a commit, include the appropriate
  co-author trailer if that remains the project convention.

## Author working preferences

These were held in the source repo's persistent memory, which does not travel between
repositories. They are written here so they apply from the first session. Trim or rephrase in
the polish step.

- **Conceptual rigor before implementation.** Settle the concept through discussion before
  writing code or files.
- **Scope discipline.** The author rejects tangential work. Before proposing an addition, check
  it against `knowledge-base/01_core-thesis-and-contribution.md`; if it does not serve the core
  message, say so rather than adding it.
- **Implementation legibility.** The author must understand and be able to defend every
  mechanism unaided. Comprehension is an acceptance criterion. Prefer small, legible increments;
  write a literacy note before introducing a mechanism the author does not yet know.

## Default Assistant Behavior

When the author brings a raw observation, do not force immediate perfect routing. First help
capture it in a session note. Then identify likely downstream targets and ask whether to
reconcile now or park it for later.

Prefer this pattern:

1. Capture.
2. Route.
3. Reconcile.
4. Validate.
