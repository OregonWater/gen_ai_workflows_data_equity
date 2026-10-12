#!/usr/bin/env Rscript

## tools/build-provenance.R
##
## Regenerates the project-state block, source inventory, and session -> content
## map inside admin/governance.md, from:
##   - project.yml                       current-state snapshot (validated, not regenerated)
##   - references/sources.yml            the source registry
##   - knowledge-base/**/*.md, docs/*.md sources:/sessions: frontmatter
##   - sessions/*.md                     date, raw-inputs, and conceptual-note feeds:
##
## Consistency checks (exit status 1 on any ERROR):
##   - a sources: key not in the registry
##   - a sessions: date with no container in sessions/
##   - a note feeds: target that resolves to no page and is not infrastructure
##   - a note feeds: a page whose sessions: frontmatter omits that session
##   - project.yml: bad stage/status enum, unknown last_session, a components or
##     open_decisions `blocks` entry that is not a real file
##     (warns: open_decision id absent from the register; the two sections
##     disagreeing on what is blocked)
##
## Run from the repository root:  Rscript tools/build-provenance.R
## Only dependency beyond base R is the `yaml` package.

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0) b else a
as_chr <- function(x) if (is.null(x)) character(0) else as.character(x)

if (!file.exists("_quarto.yml"))
  stop("run from the repository root (no _quarto.yml in the working directory)")
if (!requireNamespace("yaml", quietly = TRUE))
  stop("the 'yaml' package is required: install.packages('yaml')")

read_frontmatter <- function(path) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  if (length(lines) < 2L || !grepl("^---\\s*$", lines[1])) return(list())
  close_idx <- which(grepl("^---\\s*$", lines))
  close_idx <- close_idx[close_idx > 1L][1]
  if (is.na(close_idx)) return(list())
  out <- tryCatch(yaml::yaml.load(paste(lines[2:(close_idx - 1L)], collapse = "\n")),
                  error = function(e) stop(sprintf("%s: invalid YAML frontmatter: %s", path, conditionMessage(e))))
  if (is.null(out)) list() else out
}

## ---- source registry ------------------------------------------------------

reg <- yaml::read_yaml("references/sources.yml")$sources
source_keys <- names(reg)
input_literals <- c("conversation only", "prior sources revisited")

## ---- project state (project.yml) ----------------------------------------

if (!file.exists("project.yml"))
  stop("project.yml not found in the repository root")
proj <- yaml::read_yaml("project.yml")
stage_enum  <- c("scaffold", "analysis-design", "components-build", "drafting", "review", "submitted")
status_enum <- c("stub", "blocked", "in-progress", "complete")
squish <- function(x) trimws(gsub("\\s+", " ", paste(x, collapse = " ")))

## ---- content pages --------------------------------------------------------

page_files <- c(
  list.files(proj$paths$knowledge_base %||% "knowledge-base", pattern = "\\.md$", recursive = TRUE, full.names = TRUE),
  list.files(proj$paths$docs %||% "docs", pattern = "\\.md$", full.names = TRUE)
)
pages <- lapply(page_files, function(f) {
  fm <- read_frontmatter(f)
  list(path = sub("\\.md$", "", f), file = f,
       sources = as_chr(fm$sources), sessions = as_chr(fm$sessions))
})
names(pages) <- vapply(pages, `[[`, "", "path")
page_paths <- names(pages)

## resolve a feeds: token ("knowledge-base/02", "docs/changelog", …) to a page path
resolve_page <- function(tok) {
  tok <- trimws(tok)
  if (tok %in% page_paths) return(tok)
  hit <- page_paths[startsWith(page_paths, paste0(tok, "_"))]
  if (length(hit) == 1L) return(hit)
  NA_character_
}
is_infra <- function(tok) grepl("^(admin/|LICENSING|data/|_quarto|index|README|references/|tools/|sessions/|artifacts/|outputs/)",
                                trimws(tok))

## ---- session containers -------------------------------------------------

session_files <- list.files("sessions", pattern = "\\.md$", full.names = TRUE)
sessions <- lapply(session_files, function(f) {
  fm <- read_frontmatter(f)
  lines <- readLines(f, warn = FALSE, encoding = "UTF-8")
  feeds <- unlist(lapply(lines, function(l) {
    m <- regmatches(l, regexpr("^\\s*-\\s*feeds:\\s*(.+)$", l, perl = TRUE))
    if (length(m) == 0) return(character(0))
    trimws(strsplit(sub("^\\s*-\\s*feeds:\\s*", "", m), ",")[[1]])
  }))
  list(date = as.character(fm$date %||% sub("\\.md$", "", basename(f))),
       file = f, raw_inputs = as_chr(fm$`raw-inputs`),
       feeds = unique(feeds[nzchar(feeds)]))
})
names(sessions) <- vapply(sessions, `[[`, "", "date")

## ---- consistency checks --------------------------------------------------

errs <- character(0); warns <- character(0)

for (p in pages) {
  bad <- setdiff(p$sources, source_keys)
  if (length(bad)) errs <- c(errs, sprintf("%s: sources not in registry: %s", p$file, paste(bad, collapse = ", ")))
  bad_s <- setdiff(p$sessions, names(sessions))
  if (length(bad_s)) errs <- c(errs, sprintf("%s: sessions with no container: %s", p$file, paste(bad_s, collapse = ", ")))
  if (length(p$sessions) == 0) warns <- c(warns, sprintf("%s: no `sessions:` frontmatter", p$file))
}
for (s in sessions) {
  bad_i <- setdiff(s$raw_inputs, c(source_keys, input_literals))
  if (length(bad_i)) errs <- c(errs, sprintf("%s: raw-inputs not in registry: %s", s$file, paste(bad_i, collapse = ", ")))
  for (tok in s$feeds) {
    if (is_infra(tok)) next
    pg <- resolve_page(tok)
    if (is.na(pg)) {
      errs <- c(errs, sprintf("%s: feeds: unresolved target '%s'", s$file, tok))
    } else if (!(s$date %in% pages[[pg]]$sessions)) {
      warns <- c(warns, sprintf("%s: feeds '%s' but %s omits session %s from its frontmatter",
                                s$file, tok, pg, s$date))
    }
  }
}

## ---- project.yml consistency checks ------------------------------------

register_txt <- if (file.exists("admin/decisions-register.md"))
  paste(readLines("admin/decisions-register.md", warn = FALSE, encoding = "UTF-8"), collapse = "\n") else ""

if (!isTRUE(proj$stage %in% stage_enum))
  errs <- c(errs, sprintf("project.yml: stage '%s' not one of: %s",
                          proj$stage %||% "(missing)", paste(stage_enum, collapse = ", ")))
if (!isTRUE(proj$last_session %in% names(sessions)))
  errs <- c(errs, sprintf("project.yml: last_session '%s' has no container in sessions/",
                          proj$last_session %||% "(missing)"))

pipe <- proj$components %||% list()
for (nm in names(pipe)) {
  if (!file.exists(nm))
    errs <- c(errs, sprintf("project.yml: components entry '%s' is not a file", nm))
  if (!isTRUE(pipe[[nm]] %in% status_enum))
    errs <- c(errs, sprintf("project.yml: components '%s' status '%s' not one of: %s",
                            nm, pipe[[nm]], paste(status_enum, collapse = ", ")))
}
missing_scripts <- setdiff(list.files("scripts", pattern = "\\.R$", full.names = TRUE), names(pipe))
if (length(missing_scripts))
  warns <- c(warns, sprintf("project.yml: scripts absent from components: %s",
                            paste(missing_scripts, collapse = ", ")))

decl_blocked <- character(0)
for (d in proj$open_decisions %||% list()) {
  if (is.null(d$id) || !nzchar(d$id))
    errs <- c(errs, "project.yml: an open_decisions entry has no id")
  else if (!grepl(d$id, register_txt, fixed = TRUE))
    warns <- c(warns, sprintf("project.yml: open_decision id '%s' not found in admin/decisions-register.md", d$id))
  for (b in as_chr(d$blocks)) {
    decl_blocked <- c(decl_blocked, b)
    if (!file.exists(b))
      errs <- c(errs, sprintf("project.yml: open_decision '%s' blocks '%s', which is not a file", d$id, b))
  }
}
## cross-check the two sections agree on what is blocked
pipe_blocked <- names(Filter(function(s) identical(s, "blocked"), pipe))
for (b in setdiff(decl_blocked, pipe_blocked))
  if (file.exists(b) && b %in% names(pipe))
    warns <- c(warns, sprintf("project.yml: '%s' is blocked by an open_decision but its components status is '%s'", b, pipe[[b]]))
for (b in setdiff(pipe_blocked, decl_blocked))
  warns <- c(warns, sprintf("project.yml: components marks '%s' blocked but no open_decision lists it in blocks", b))

if (length(errs)) { cat(paste0("ERROR: ", errs, collapse = "\n"), "\n"); quit(status = 1L) }

## ---- build the three sections ----------------------------------------------

short <- function(path) { prefix <- paste0(proj$paths$knowledge_base %||% "knowledge-base", "/"); ifelse(startsWith(path, prefix), paste0("kb/", substring(path, nchar(prefix) + 1L)), path) }

inv_rows <- vapply(source_keys, function(k) {
  r <- reg[[k]]
  fp <- names(Filter(function(p) k %in% p$sources, pages))
  fs <- names(Filter(function(s) k %in% s$raw_inputs, sessions))
  feeds <- paste(c(sort(vapply(fp, short, "")), paste0("session ", sort(fs))), collapse = ", ")
  sprintf("| `%s` | %s | `%s` | %s | %s |", k, r$name, r$location,
          if (isTRUE(r$tracked)) "yes" else "no", if (nzchar(feeds)) feeds else "—")
}, "")
inv_tbl <- c("| Key | Source | Location | In git? | Feeds |", "|---|---|---|---|---|", inv_rows)

sess_rows <- vapply(sort(names(sessions)), function(d) {
  s <- sessions[[d]]
  cp <- names(Filter(function(p) d %in% p$sessions, pages))
  sprintf("| [**%s**](../sessions/%s.md) | %s | %s |", d, d,
          paste(s$raw_inputs, collapse = "; "),
          paste(sort(vapply(cp, short, "")), collapse = ", "))
}, "")
sess_tbl <- c("| Session | Raw inputs | Content pages touched |", "|---|---|---|", sess_rows)

## project-state block, from project.yml
ls_date <- proj$last_session
status_counts <- table(factor(unlist(pipe), levels = status_enum))
dec_rows <- vapply(proj$open_decisions %||% list(), function(d) {
  tgt <- if (length(as_chr(d$blocks))) paste0("`", as_chr(d$blocks), "`", collapse = ", ")
         else sprintf("_gated on %s_", squish(d$gated_on %||% "?"))
  sprintf("| `%s` — %s | %s |", d$id, squish(d$question %||% ""), tgt)
}, "")
proj_tbl <- c(
  sprintf("**Stage:** %s &nbsp;·&nbsp; **Last session:** [%s](../sessions/%s.md) &nbsp;·&nbsp; **Components:** %s",
          proj$stage, ls_date, ls_date,
          paste(sprintf("%d %s", as.integer(status_counts), names(status_counts)), collapse = " · ")),
  "",
  sprintf("**Critical-path blocker:** %s", squish(proj$critical_path_blocker %||% "—")),
  "",
  "| Open decision | Blocks |", "|---|---|", dec_rows,
  "",
  "**Next actions:**",
  paste0("- ", vapply(as_chr(proj$next_actions), squish, "")))

## ---- splice into governance.md ------------------------------------------

gov_path <- "admin/governance.md"
gov <- readLines(gov_path, warn = FALSE, encoding = "UTF-8")
stamp <- sprintf("_Generated by `tools/build-provenance.R` on %s — do not edit between the markers._",
                 format(Sys.Date()))

splice <- function(lines, tag, body) {
  bi <- which(lines == sprintf("<!-- BEGIN GENERATED: %s -->", tag))
  ei <- which(lines == sprintf("<!-- END GENERATED: %s -->", tag))
  if (length(bi) != 1L || length(ei) != 1L || ei <= bi)
    stop(sprintf("markers for '%s' not found (or malformed) in %s", tag, gov_path))
  c(lines[1:bi], "", stamp, "", body, "", lines[ei:length(lines)])
}
gov <- splice(gov, "project-state", proj_tbl)
gov <- splice(gov, "source-inventory", inv_tbl)
gov <- splice(gov, "session-map", sess_tbl)
writeLines(gov, gov_path)

## ---- report --------------------------------------------------------------

cat(sprintf("provenance: %d pages, %d sessions, %d sources | project.yml: stage=%s, last_session=%s\n",
            length(pages), length(sessions), length(source_keys),
            proj$stage %||% "?", proj$last_session %||% "?"))
for (w in warns) cat("  warn:  ", w, "\n", sep = "")
for (e in errs)  cat("  ERROR: ", e, "\n", sep = "")
if (length(errs)) quit(status = 1L)
cat("admin/governance.md updated.\n")
