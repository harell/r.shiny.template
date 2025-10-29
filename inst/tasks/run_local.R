#!/usr/bin/env Rscript

#' Run Golem Application Locally with Hot Reload
#'
#' Development script that launches the app with auto-reload capabilities.
#' Changes to R/ and inst/ files trigger app reload automatically.
#'
#' Usage:
#'   source("inst/tasks/run_local.R")
#'   # or
#'   Rscript inst/tasks/run_local.R

# Set development options for hot reload
options(shiny.autoreload = TRUE)       # Auto-reload when files change
options(shiny.port = httpuv::randomPort())  # Random port to avoid caching

# Install missing packages if needed
pkgs_needed <- c("shiny", "golem", "config")
pkgs_missing <- pkgs_needed[!pkgs_needed %in% rownames(utils::installed.packages())]
if (length(pkgs_missing) > 0) {
  cat("Installing missing packages:", paste(pkgs_missing, collapse = ", "), "\n")
  install.packages(pkgs_missing)
}

# Load the package in development mode
cat("Loading package in development mode...\n")
devtools::load_all(here::here())

# Configure golem with development settings
golem::with_golem_options(
  app = shiny::shinyApp(
    ui = app_ui,
    server = app_server
  ),
  golem_opts = list(
    app_prod = FALSE  # Development mode
  )
)
