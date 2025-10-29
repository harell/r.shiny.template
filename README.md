# r.shiny.template

<!-- badges: start -->
![Licence](<https://img.shields.io/badge/licence-proprietary-red>)
[![Shiny App](https://img.shields.io/badge/shinyapps.io-whitelabel-1f65cc?logo=rstudio&logoColor=white)](https://tonkintaylor.shinyapps.io/whitelabel/)
<!-- badges: end -->

This repository contains a template for a Golem-based Shiny application, including automation for R CMD checks and deployment to shinyapps.io via GitHub Actions.

## Package version management

This project uses a snapshot approach to package management for reproducibility. Packages are pinned to the CRAN snapshot that was available when the R version in use was released. This ensures consistent package versions across development environments and CI/CD pipelines.

Locally, the snapshot repository is configured automatically via `.Rprofile` when the project is opened in RStudio or Positron (triggered by the `.Rproj` file). The same approach is applied in CI/CD workflows—the `.github/actions/capture-cran-snapshot` composite action determines the snapshot URL based on the R release date and configures it before installing dependencies.

## Required environment variables

The GitHub Actions workflow expects the following secrets to be configured in the repository settings under **Settings → Secrets and variables → Actions**:

- `SHINYAPPS_NAME`: The shinyapps.io account identifier (for example, `your-account-name`).
- `SHINYAPPS_TOKEN`: The API token generated for the account, retrieved via `rsconnect::showTokens()` or the shinyapps.io dashboard.
- `SHINYAPPS_SECRET`: The API secret paired with the token; treat this as sensitive and never commit it to source control.

Add each value as an individual secret to enable the deployment step in `.github/workflows/R-CMD-check.yaml`.

## Customisation

### Update DESCRIPTION file

Edit `DESCRIPTION` to reflect your application:

- **Package**: Change from `whitelabel` to your app name (must match `YOUR_APP_NAME` in the badge above).
- **Title**: Update with a concise title describing your Shiny app.
- **Authors@R**: Replace the author details with your own name, role, and email.
- **Description**: Provide a one-paragraph description of what your application does.

### Update the deployed app badge

Replace the badge URL in `README.md` (near the top under the title) with your own deployed shinyapps.io link:

```markdown
[![Shiny App](https://img.shields.io/badge/shinyapps.io-SHINYAPPS_APPNAME-1f65cc?logo=rstudio&logoColor=white)](https://SHINYAPPS_NAME.shinyapps.io/SHINYAPPS_APPNAME/)
```

- Replace `SHINYAPPS_APPNAME` with the name of your application as listed in `DESCRIPTION`.
- Replace `SHINYAPPS_NAME` with the shinyapps.io account identifier.

### Change the R version

The CI/CD workflows are configured to use a specific R version (currently `4.5.1`) that should ideally match the version used for local development. To update the R version:

1. Search the `.github` directory for both formats of the current version:
   - Dotted format: `4.5.1`
   - Hyphenated format: `4-5-1`
2. Replace all occurrences with your desired R version in the corresponding format (e.g., `4.6.0` and `4-6-0`).
3. Update occurs in:
   - `.github/workflows/R-CMD-check.yaml` (appears in `r-version` and `cache-version`)
   - `.github/workflows/deploy-shinyapps.yaml` (appears in `r-version` and `cache-version`)

This ensures that both testing and deployment use the same R version and package snapshot date.
