# GitHub Copilot Instructions

## General Guidelines
- Every time you need to fix linter errors and provide the error messages, update the Linter section in .github/copilot-instructions.md accordingly. Use concise, oneliner instruction. Ensure your future responses avoid repeating the same errors.
- Always use the native pipe operator `|>` instead of the magrittr pipe `%>%` in all R code.
- Use NZ (New Zealand) English spelling for all function names and documentation (e.g., "colour" not "color").

---

## Linter
- Markdown: avoid tab characters and keep blank lines before/after fenced code blocks.

---

## Documentation

### Function Documentation with Child Vignettes

- **Extract detailed methodology to child vignettes**: For functions with complex formulas, algorithms, or methodology details, create a separate `.Rmd` file in `vignettes/functions/` subdirectory (e.g., `vignettes/functions/methodology-details.Rmd`). Keep only brief descriptions, `@param`, `@return`, and `@examples` in the function's roxygen2 comments.

- **Reference child vignettes in roxygen2**: In the function's `@details` section, include the child vignette using `@details \n```{r child = "vignettes/functions/<name>.Rmd"}\n````. When you run `devtools::document()`, the child content will be automatically rendered into the `.Rd` help file, maintaining a single source of truth.

- **Reuse across functions**: Use shared child vignettes (e.g., `vignettes/functions/methodology-details.Rmd`) for methodology that applies to multiple functions. This enforces DRY principles and ensures consistency—update once, reflected everywhere.

- **Organize function vignettes**: All child vignettes referenced in function documentation should be stored in `vignettes/functions/` subdirectory. Add the pattern `^vignettes/functions/` to `.Rbuildignore` to prevent these files from being detected as standalone vignettes.

- **Use .Rd-compatible math notation**: Raw LaTeX (`$$`, `\times`, `\frac`) doesn't work in roxygen2. Use `\deqn{}` for display equations, `\eqn{}` for inline math, `\cdot` for multiplication, `/` for division, and `_{subscript}` for subscripts.

- **Use `\eqn{}` with ASCII fallbacks for symbols in roxygen2**: Instead of raw Unicode characters or plain text, use Rd's math wrappers with ASCII fallbacks in `@param`, `@return`, and other roxygen2 sections:
  - **Syntax**: `\eqn{latex}{ascii}` renders LaTeX in PDF/HTML and uses ASCII text in plain-text help
  - **Note**: Avoid raw Unicode characters (μ, °) or Unicode escapes (`\u03bc`) in roxygen comments—they cause build failures

- **Wrap examples in `\dontrun{}`**: Always wrap function examples in `@examples` sections with `\dontrun{}` to prevent them from being executed during `R CMD check`, unless they are simple, fast, and have no external dependencies.

---

## Plotting Guidelines

- **Use ggplot2 for all plots**: All visualizations should be created using the ggplot2 package to ensure consistency and leverage its powerful layering system.

- **Use the `scales` package for axis formatting**: For formatting axis labels and breaks, always use functions from the `scales` package (e.g., `scales::label_number()`, `scales::breaks_extended()`) to ensure consistent and professional appearance.