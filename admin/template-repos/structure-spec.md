# Structure spec — `research-artifact-template`

2026-10-08 (`sessions/2026-10-08.md`). Hand-off file 1 of 2. Read this in the first working
session of the new repository, together with `AGENTS-seed.md` (hand-off file 2, the draft
`AGENTS.md`). This file says **how to build the template's internal structure**: what the
repository contains, what is copied from `loon-lake-compositional-trajectories` (the "source
repo" below) and how, what is rewritten, what is dropped, and what counts as a finished
minimum template.

The name `research-artifact-template` is provisional.

## What the template is for

A starting point for scientific-communication artifacts (first instance: a conference talk)
that preserves the source repo's working practice: a provenance spine (session containers,
source registry, a generated map), a knowledge base of synthesized understanding, an AI
working protocol with scientific guardrails, and a Quarto site. It is **R-first**, **public
from the first commit**, and **one repository with an `artifacts/<name>/` slot**, shipped with
one artifact: a Quarto reveal.js deck. The repository and the deck are both shared with the
audience, so the audience can see how the talk was made (in particular the role of generative
AI) and clone and modify the deck.

## Principles for the build

- **Legibility first.** The author must be able to understand and defend every mechanism
  unaided. Prefer small increments; before introducing a mechanism the author does not know
  (`renv`, GitHub Actions, reveal.js options), write a short literacy note in `docs/` or a
  session note and get the author's understanding first. Comprehension is an acceptance
  criterion, not a courtesy.
- **Everything works by hand.** AI-assisted, not AI-dependent. No step may require a model.
- **No Loon Lake residue.** The finished template contains no Loon Lake data, text, names or
  paths. Final check: `grep -ril "loon\|richardson\|psd\|fisher" .` returns nothing outside
  the seed files' provenance notes.

## Target tree

```text
research-artifact-template/
├── README.md
├── AGENTS.md                     # from AGENTS-seed.md, placeholders filled
├── LICENSE                       # MIT text (code)
├── LICENSING.md                  # code MIT / written content+slides CC BY 4.0 / data excluded
├── .gitignore
├── {{project-slug}}.Rproj
├── .Rprofile                     # activates renv
├── renv.lock                     # pinned R packages (yaml, quarto-related as needed)
├── project.yml                   # current-state snapshot, new `components:` schema (below)
├── _quarto.yml                   # one public site: notebook + deck
├── index.qmd
├── .github/workflows/render.yml  # render + deploy to GitHub Pages (see "Deferred")
├── admin/
│   ├── governance.md             # four layers; generated markers kept
│   ├── decisions-register.md     # empty shell: format note + "Open items" section
│   ├── project-log.md            # empty shell
│   ├── new-note-template.md      # session template, genericized
│   └── template-repos/           # optional: the two hand-off files, kept as provenance
├── sessions/                     # first container = the hand-off (see "First session")
├── knowledge-base/               # generic skeleton (below)
├── references/
│   ├── sources.yml               # registry shell with one commented example
│   ├── references.bib            # empty
│   ├── external-ai-notes/        # README.md only
│   └── source-pdfs/              # README.md only (contents git-ignored)
├── data/{raw,processed,intermediate,external}/   # README.md + .gitkeep each
├── docs/
│   ├── project-overview.md
│   ├── repository-guide.md
│   ├── data-dictionary.md
│   ├── reproducibility-notes.md
│   ├── changelog.md
│   └── how-this-was-made.md      # NEW: author-written account of the AI role
├── R/                            # shared functions (utility-functions.R only, as a stub)
├── scripts/                      # numbered pipeline: 00_setup.R, 01_..., (figures/tables)
├── outputs/{figures,tables}/     # + exploratory/ subfolders (git-ignored contents)
├── artifacts/
│   └── talk/
│       ├── _quarto.yml           # reveal.js format
│       ├── deck.qmd              # skeleton: title, outline, placeholder slides
│       ├── assets/               # images/logos (small, redistributable only)
│       └── speaker-notes.md
└── tools/
    └── build-provenance.R        # parameterized (below)
```

## Disposition of source-repo files

Paths are in the source repo, `loon-lake-compositional-trajectories`. "Genericize" means:
strip project-specific content, keep the structure and the rules.

| Source | Action | Notes |
| --- | --- | --- |
| `AGENTS.md` | rewrite → `AGENTS-seed.md` | Seed already drafted; drop Companion Repository section. |
| `README.md` | rewrite | New: what the template is, how to clone, render, run the init script. |
| `LICENSE` | copy | Update copyright year/holder placeholder. |
| `LICENSING.md` | genericize | Keep the three-way split (code MIT / text+slides CC BY 4.0 / data not licensed here); keep "AI assistance" section. Replace the Loon Lake data paragraph with a generic one. |
| `.gitignore` | copy, trim | Keep data/PDF/R/Quarto/OS patterns and the "NOT tracked" rationale comment, generalized. Remove paths that do not exist in the template. |
| `*.Rproj` | rename | `{{project-slug}}.Rproj`. |
| `_quarto.yml` | rewrite | See "Site" below. |
| `index.qmd` | rewrite | Landing page: the talk, the repo, how to follow the provenance trail. |
| `project.yml` | genericize | New `components:` schema (below). |
| `admin/governance.md` | genericize | Keep the four layers, the session container, the rule, the three generated marker pairs exactly. Remove Loon Lake wording. |
| `admin/decisions-register.md` | empty shell | Keep the entry format and the "Open items requiring a decision" section heading. |
| `admin/project-log.md` | empty shell | |
| `admin/new-note-template.md` | genericize | Remove the `shared-as:` checklist item and the "check against core thesis" wording; point at the template's own `knowledge-base/01`. |
| `admin/reviewer-risk-log.md`, `admin/task-list.md` | **omit** | The source repo excluded these from its site render because they were internal. In a public-from-day-one repo they have no place unless the candor rule (see `AGENTS-seed.md`) says otherwise. |
| `admin/companion-repos/` | omit | |
| `sessions/*` | omit | Start empty; the first container is the hand-off. |
| `knowledge-base/*` | rewrite as skeleton | See "Knowledge-base skeleton". |
| `knowledge-base/16_ai-working-instructions.md` | genericize | The other half of the AI protocol; `AGENTS.md` delegates to it. Keep "The premise", "Before a session", "While working", session close-out. Remove information-geometry reading. |
| `knowledge-base/information-geometry/`, `shared/` | omit | |
| `references/sources.yml` | empty shell | Read the source's file for the schema (`sources:` map with `name`, `location`, `tracked`, …) and keep the same keys, because the build script reads them. |
| `references/external-ai-notes/` | folder + README only | Rule text lives in `AGENTS.md`. |
| `references/companion-notes/` | omit | |
| `references/source-pdfs/README.md` | copy, genericize | |
| `data/*/README.md` | copy, genericize | Keep the "files here are git-ignored" statement. |
| `data/*` contents | **omit** | Never copy data. |
| `docs/*.md` | genericize | `repository-guide.md` becomes the template's own tree and role-of-each-folder; `data-dictionary.md`, `reproducibility-notes.md` become empty shells with the headings retained. |
| `R/`, `scripts/` | stubs | One `utility-functions.R`, one `00_setup.R`. Drop all analysis content. |
| `manuscript/`, `notebooks/`, `supplementary-materials/` | omit | Superseded by `artifacts/<name>/`. |
| `tools/build-provenance.R` | copy, then parameterize | See next section. |

## `tools/build-provenance.R` — required changes

The script was read in full on 2026-10-08. Hardcoded assumptions found, each with the change
to make:

1. **Page discovery** (`page_files`): hardcodes `knowledge-base/` (recursive) and `docs/`.
   Read these directory names from a `paths:` block in `project.yml` (default to the current
   values so the template works unconfigured).
2. **`resolve_page`**: matches `feeds:` tokens like `knowledge-base/02` by the prefix
   `knowledge-base/02_`. Works unchanged if the skeleton keeps numbered files; keep that
   convention and document it.
3. **`is_infra`**: regex `^(admin/|LICENSING|data/|_quarto|index|README|references/|tools/|sessions/)`
   lists tokens that are not content pages. Add `artifacts/` and `outputs/`; remove nothing.
4. **Pipeline checks** (`pipe <- proj$pipeline`, `scripts/*.R` warning, the `blocks` and
   blocked/pipeline cross-checks, the `Pipeline:` count in the project-state block): replace
   `pipeline:` with a general **`components:`** map, each key a real path (a script, or an
   `artifacts/<name>/deck.qmd`) with a status from the same enum. Keep the cross-check logic
   (an open decision that blocks a component ⇒ component status `blocked`). Rename the label
   in the generated block from "Pipeline" to "Components". Keep the `scripts/*.R` warning,
   but point it at `components:`.
5. **`stage_enum`**: the stages (`scaffold` … `submitted`) are manuscript-shaped. Replace by a
   stage list in `project.yml` that the script reads, defaulting to
   `scaffold, outline, drafting, rehearsal, delivered` for a talk. (Choose names with the
   author; they appear in the generated block.)
6. **`short()`** and the source-inventory "Feeds" column: abbreviates `knowledge-base/` to
   `kb/`. Make it derive from the configured knowledge-base directory.
7. **Governance splice**: writes `admin/governance.md` between three marker pairs; fails with
   `stop()` if markers are missing. Keep, and make the missing-marker message name the file
   and tag (it already does).
8. **Startup guard**: `stop("run from the repository root (no _quarto.yml …)")`. Keep.
9. **`input_literals`**: `"conversation only"`, `"prior sources revisited"`. Keep.
10. Dependency: only `yaml`. Keep; record it in `renv.lock`.

Acceptance for the script: on the **empty template** it runs with zero ERRORs and zero
unexplained warnings; on a deliberately broken copy (unknown `sources:` key, `feeds:` target
that does not exist, `components:` entry that is not a file) it reports each as an ERROR and
exits non-zero.

## `project.yml` schema for the template

Keep the header-comment style of the source file. Fields: `project`, `stage`, `last_session`,
`critical_path_blocker`, `open_decisions` (each `id`, `question`, `blocks` or `gated_on`),
`components` (path → status), `external_gates`, `next_actions`, and the optional `paths:` and
`stages:` blocks from the changes above. Ship it filled with a minimal valid example so the
build script passes on day one.

## Knowledge-base skeleton

Numbered like the source so `feeds:` resolution works. Each file is a short stub: frontmatter
(`title`, `sources: []`, `sessions: []`) and the headings that say what belongs there.

| File | Role | Derived from source page |
| --- | --- | --- |
| `00_project-overview.md` | what the artifact is, audience, venue, stage | 00 |
| `01_core-thesis-and-contribution.md` | the one-sentence message; what this adds; what not to claim | 01 |
| `02_key-terms-and-definitions.md` | preferred/discouraged terms | 07 |
| `03_background-and-literature.md` | the literature the talk rests on, as summaries and citation keys | 03 |
| `04_claims-evidence-risk-register.md` | the guardrail: no claim reaches slides without an entry | 08 |
| `05_methods-and-sources.md` | how results were produced / where they come from | 09 |
| `06_figures-and-tables-plan.md` | what each figure shows and its script | 11 |
| `07_narrative-skeleton.md` | slide-by-slide argument and time budget | 12/13 |
| `08_audience-and-venue.md` | audience, time slot, format requirements | 15 |
| `09_ai-working-instructions.md` | genericized `16_ai-working-instructions.md` | 16 |

The renumbering is deliberate: the source's numbering is project history. If the author prefers
to keep `16` for the AI instructions so cross-references in copied text still read the same,
that is acceptable; decide once and update `AGENTS.md` and `governance.md` to match.

## Site

One public Quarto site, no internal/public split.

- `_quarto.yml` renders `index.qmd`, `knowledge-base/*.md`, `sessions/*.md`, `admin/*.md`,
  `docs/*.md`, `LICENSING.md`. The sidebar groups: Start here · Knowledge base · Sessions ·
  Project log & decisions · Repo & workflow.
- Remove the "internal working site — not for distribution" announcement. If the candor rule
  keeps anything local, nothing needs excluding from the render; if some logs are kept
  public but not rendered, use the `!file` exclusion pattern.
- The deck is a separate Quarto output at `artifacts/talk/`, linked from `index.qmd` and the
  navbar. Decide with the author whether it renders as part of the site build (one command)
  or separately.
- Quarto is rendered with `quarto render` from the repository root; document the required
  Quarto version in `docs/reproducibility-notes.md`.

## Init script (placeholders)

Placeholders: `{{project-name}}`, `{{project-slug}}`, `{{author}}`, `{{year}}`,
`{{artifact-name}}`, `{{venue}}`. Provide `tools/init-template.R` that prompts for these (or
takes them as arguments), substitutes in files, renames the `.Rproj`, and deletes itself or
leaves a note. Keep it short enough for the author to read in one sitting. Mark the GitHub
repository as a template repository ("Use this template") — the author's action.

## `docs/how-this-was-made.md`

New. An author-written account of how generative AI was used to make the artifact, structured
around the session containers as evidence: what was delegated, what the human decided, what
was checked and how. Ship as a headed shell with guiding questions, not content. The
transcript question is open (see the session note, `ai-transparency-record`).

## Minimum template — acceptance criteria

The template is "minimum" when all of the following hold. Tick each in the first session's
close-out.

- [ ] The target tree exists; every folder named above is present; no data or PDFs are
      tracked (`git ls-files data references/source-pdfs` shows only READMEs/`.gitkeep`).
- [ ] `Rscript tools/build-provenance.R` runs from the root with zero ERRORs; the broken-copy
      check above reports ERRORs.
- [ ] `quarto render` builds the site, and `artifacts/talk/deck.qmd` renders to a reveal.js
      deck. Both open locally.
- [ ] `tools/init-template.R` replaces every placeholder (verify with
      `grep -r "{{" .` returning nothing) and the no-Loon-Lake grep above is clean.
- [ ] `AGENTS.md` is in place and its "First Reads" list names only files that exist.
- [ ] `README.md` explains clone → init → render in a few lines.
- [ ] `renv.lock` restores on a clean machine, or the limitation is recorded in
      `docs/reproducibility-notes.md`.
- [ ] The author can explain each mechanism (provenance script, `renv`, the render workflow)
      without help. Record any that they cannot as open threads.

## Deferred (not in the minimum template)

- Dev container or Docker setup.
- Content of `how-this-was-made.md` and every knowledge-base page beyond stubs.
- The GitHub Pages deploy workflow, if the author wants to build and review the site locally
  first. Include only a minimal `render.yml` if the author asks; explain it first (literacy
  note), since it is a mechanism the author must be able to defend.
- A second artifact type (poster, paper).

## First session in the new repository

1. Create `sessions/2026-MM-DD.md` from the genericized template. Its `raw-inputs` registers
   this brief and `AGENTS-seed.md` as sources in `references/sources.yml`
   (key suggestion: `template-handoff-2026-10-08`), copied into
   `references/handoff/` or `admin/template-repos/`.
2. Build the structure above in small increments, with a literacy note before each new
   mechanism.
3. Close out per the template's checklist: build script clean, site rendered, nothing
   sensitive staged.
4. **Pushing to GitHub is outward-facing.** Ask the author for explicit confirmation of repo
   name, owner and visibility before `git push`. Do not commit unless asked.
