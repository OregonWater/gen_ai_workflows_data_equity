# Keep Windows R sessions from waiting on a shared sandbox lock.
# See docs/workflow-literacy.md; project packages still use renv.lock.
if (.Platform$OS.type == "windows") {
  Sys.setenv(RENV_PATHS_SANDBOX = file.path(tempdir(), "renv-sandbox"))
}

source("renv/activate.R")
