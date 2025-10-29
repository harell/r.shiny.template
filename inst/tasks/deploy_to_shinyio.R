#!/usr/bin/env Rscript

#' Deploy Golem Application to shinyapps.io
#'
#' Minimal deployment script using credentials from .Renviron
#'
#' Required in .Renviron:
#'   SHINYAPPS_NAME="your-account-name"
#'   SHINYAPPS_TOKEN="your-token"
#'   SHINYAPPS_SECRET="your-secret"

# Load packages
library(rsconnect)
library(desc)

# Configure renv to suppress validation errors for unknown package sources
# This prevents deployment failure when the local Golem package is detected
Sys.setenv(RENV_CONFIG_SNAPSHOT_VALIDATE = "FALSE")
options(renv.warnings.unknown_sources = FALSE)

# Note: We do NOT install the package locally to avoid renv validation issues
# The deployment will handle dependencies from DESCRIPTION file

# Load credentials from .Renviron
if (file.exists(".Renviron")) readRenviron(".Renviron")

# Get credentials
account_name <- Sys.getenv("SHINYAPPS_NAME")
account_token <- Sys.getenv("SHINYAPPS_TOKEN")
account_secret <- Sys.getenv("SHINYAPPS_SECRET")

# Validate
if (account_name == "" || account_token == "" || account_secret == "") {
  stop("Missing credentials in .Renviron. Set SHINYAPPS_NAME, SHINYAPPS_TOKEN, SHINYAPPS_SECRET")
}

# Configure account (only if not already set)
if (!account_name %in% rsconnect::accounts()$name) {
  rsconnect::setAccountInfo(
    name = account_name,
    token = account_token,
    secret = account_secret
  )
}

# Get app info from DESCRIPTION
app_name <- desc::desc_get_field("Package")

# Deploy
# Use appPrimaryDoc to treat this as a document deployment (not a package)
# This prevents rsconnect from trying to reinstall the whitelabel package
rsconnect::deployApp(
  appName = app_name,
  appFiles = c(
    "R/",
    "inst/app",
    "inst/golem-config.yml",
    "NAMESPACE",
    "DESCRIPTION",
    "app.R"
  ),
  appPrimaryDoc = "app.R",
  account = account_name,
  forceUpdate = TRUE,
  lint = FALSE,
  launch.browser = FALSE
)

# Print URL
cat(sprintf("\nDeployed to: https://%s.shinyapps.io/%s/\n", account_name, app_name))
