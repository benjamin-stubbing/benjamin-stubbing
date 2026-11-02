# ---------------------------------------------------------------------------
# calcs.R - the arithmetic. There is no statistical model here on purpose.
#
# With four quarterly observations of a price series and no NZ micro data,
# a regression would be decoration. What follows is multiplication, addition,
# and a sensitivity grid. Each function returns a low/central/high triple so
# that no single number can be quoted without its range.
# ---------------------------------------------------------------------------

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
})

#' Cumulative DRAM contract price index, rebased to 100 at the base quarter.
dram_index <- function(dram) {
  dram %>%
    arrange(quarter_index) %>%
    mutate(
      index_low     = cumprod(1 + qoq_low_pct / 100)     * 100,
      index_central = cumprod(1 + qoq_central_pct / 100) * 100,
      index_high    = cumprod(1 + qoq_high_pct / 100)    * 100
    )
}

#' Total contribution of each device category to the CPI price level, in
#' percentage points, once the repricing has fully passed through.
#'
#' The counterfactual matters as much as the shock. These categories have
#' been quietly deflating for two decades; the inflationary event is the
#' swing away from that trend, not the level of the price rise.
cpi_contributions <- function(categories) {
  categories %>%
    mutate(
      swing_low       = shock_annual_low_pct     - trend_annual_pct,
      swing_central   = shock_annual_central_pct - trend_annual_pct,
      swing_high      = shock_annual_high_pct    - trend_annual_pct,
      contrib_low     = cpi_weight_pct / 100 * swing_low,
      contrib_central = cpi_weight_pct / 100 * swing_central,
      contrib_high    = cpi_weight_pct / 100 * swing_high
    )
}

#' Split the total contribution between annual inflation in 2026 and 2027.
#'
#' Treats the 2026 repricing as a one-off: the share that passes through in
#' year one lands in 2026, the rest in 2027. The two years always sum to the
#' total. Ranges pair so that each year's low end is genuinely low:
#'   2026 low  = smallest total x slowest pass-through
#'   2027 low  = smallest total x fastest pass-through (least left over)
#' so the 2026 and 2027 ranges are not independent and should not be added.
#' If memory prices keep rising through 2027 (the industry's own guidance),
#' 2027 also carries a fresh shock on top of this spill-over.
cpi_timing <- function(contribs, params) {
  tot <- c(low     = sum(contribs$contrib_low),
           central = sum(contribs$contrib_central),
           high    = sum(contribs$contrib_high))
  pt  <- params$passthrough_year1
  data.frame(
    period  = c("Total (price level)", "2026 annual inflation", "2027 annual inflation"),
    low     = c(tot[["low"]],     tot[["low"]]     * pt[["low"]],     tot[["low"]]     * (1 - pt[["high"]])),
    central = c(tot[["central"]], tot[["central"]] * pt[["central"]], tot[["central"]] * (1 - pt[["central"]])),
    high    = c(tot[["high"]],    tot[["high"]]    * pt[["high"]],    tot[["high"]]    * (1 - pt[["low"]])),
    stringsAsFactors = FALSE
  )
}

#' The fuel shock already in the June 2026 CPI, for scale.
fuel_benchmark <- function(params) {
  params$petrol_cpi_weight_pct / 100 * params$petrol_annual_pct
}

#' Sensitivity grid: total CPI contribution as a function of the two
#' parameters that actually drive it, neither of which is known precisely.
cpi_sensitivity <- function(params) {
  expand_grid(
    weight_pct = params$weight_grid,
    swing_pp   = params$swing_grid
  ) %>%
    mutate(contribution_pp = weight_pct / 100 * swing_pp)
}

#' Annual dollar cost by exposure channel, before behavioural response.
channel_costs <- function(exposure, params) {
  exposure %>%
    mutate(
      cost_low     = base_nzd_bn * price_effect_low_pct     / 100,
      cost_central = base_nzd_bn * price_effect_central_pct / 100,
      cost_high    = base_nzd_bn * price_effect_high_pct    / 100,
      gdp_share_central_pct = cost_central / params$nz_gdp_nzd_bn * 100
    )
}
