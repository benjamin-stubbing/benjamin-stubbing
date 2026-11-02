#!/usr/bin/env Rscript
# Render the report. Prefers Quarto; falls back to knitr + pandoc so the
# project still builds in environments where the Quarto CLI is unavailable.

stopifnot(dir.exists("report"))
qmd <- "report/nz-memory-price-shock.qmd"

if (nzchar(Sys.which("quarto"))) {
  message("Rendering with Quarto...")
  system2("quarto", c("render", qmd))
} else {
  message("Quarto not found; falling back to knitr + pandoc.")
  dir.create("figures", showWarnings = FALSE)
  knitr::opts_chunk$set(fig.path = "figures/", dev = "png", dpi = 160,
                        fig.width = 7, fig.height = 4.2,
                        echo = FALSE, warning = FALSE, message = FALSE)
  md <- knitr::knit(qmd, output = "report/nz-memory-price-shock.md", quiet = FALSE)
  if (nzchar(Sys.which("pandoc"))) {
    out <- "report/nz-memory-price-shock.html"
    system2("pandoc", c(shQuote(md), "-o", shQuote(out), "--standalone", "--toc",
                        "--embed-resources", "--resource-path=.",
                        "--metadata", shQuote("title=The Memory Price Shock and New Zealand")))
    message("Wrote ", out)
  }
}
