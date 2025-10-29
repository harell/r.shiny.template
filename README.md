# r.shiny.template

This repository contains a template for a Golem-based Shiny application, including automation for R CMD checks and deployment to shinyapps.io via GitHub Actions.

## Required environment variables

The GitHub Actions workflow expects the following secrets to be configured in the repository settings under **Settings → Secrets and variables → Actions**:

- `SHINYAPPS_NAME`: The shinyapps.io account identifier (for example, `your-account-name`).
- `SHINYAPPS_TOKEN`: The API token generated for the account, retrieved via `rsconnect::showTokens()` or the shinyapps.io dashboard.
- `SHINYAPPS_SECRET`: The API secret paired with the token; treat this as sensitive and never commit it to source control.

Add each value as an individual secret to enable the deployment step in `.github/workflows/R-CMD-check.yaml`.
