# Plot styling. Deliberately plain: this is a note, not a brochure.
suppressPackageStartupMessages({
  library(ggplot2)
})

pal <- c(
  actual     = "#1f4e79",
  forecast   = "#7f9db9",
  base       = "#b0b0b0",
  accent     = "#b5451b",
  neutral    = "#4d4d4d",
  light      = "#d9d9d9"
)

theme_note <- function(base_size = 11) {
  theme_minimal(base_size = base_size) +
    theme(
      panel.grid.minor   = element_blank(),
      panel.grid.major.x = element_blank(),
      plot.title         = element_text(face = "bold", size = base_size + 1),
      plot.subtitle      = element_text(colour = pal[["neutral"]], size = base_size - 1),
      plot.caption       = element_text(colour = pal[["neutral"]], size = base_size - 2,
                                        hjust = 0),
      axis.title         = element_text(size = base_size - 1),
      legend.position    = "top",
      legend.title       = element_blank()
    )
}

#' Hard-wrap a caption so it does not run off the device.
wrap_cap <- function(x, width = 78) paste(strwrap(x, width = width), collapse = "\n")
