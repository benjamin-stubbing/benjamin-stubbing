# Loading layer. Everything is a small hand-entered CSV: the point of this
# project is that a reader can open data/ and check every input in a minute.

read_project_csv <- function(name) {
  path <- file.path(project_root(), "data", name)
  utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
}

# Works whether code is sourced from the project root or from report/.
project_root <- function() {
  if (dir.exists("data") && dir.exists("R")) return(".")
  if (dir.exists("../data") && dir.exists("../R")) return("..")
  stop("Cannot locate project root: expected data/ and R/ alongside each other.")
}

load_all_data <- function() {
  list(
    dram       = read_project_csv("dram_contract_prices.csv"),
    categories = read_project_csv("consumer_categories.csv"),
    exposure   = read_project_csv("exposure_channels.csv"),
    macro      = read_project_csv("nz_macro_context.csv"),
    sources    = read_project_csv("sources.csv")
  )
}
