# ---------------------------------------------------------------------------
# params.R - every judgement call in this report, in one place.
#
# Rule for this project: if a number is not in data/sources.csv with a URL,
# it lives here, labelled as an assumption, with a range attached. Nothing
# is allowed to be a bare constant buried in a chart.
# ---------------------------------------------------------------------------

params <- list(

  # Nominal GDP, NZ$ billion. Order-of-magnitude only; used as a denominator
  # to turn dollar exposures into "share of the economy" intuitions.
  nz_gdp_nzd_bn = 440,

  # CPI weight of petrol, percent of the basket. Used solely to benchmark the
  # memory shock against the fuel shock already in the June 2026 numbers.
  petrol_cpi_weight_pct = 3.3,

  # Petrol's annual price change, June 2026 quarter (sourced: Stats NZ).
  petrol_annual_pct = 27.5,

  # Share of the landed-cost increase that reaches the shelf within the first
  # year. NZ retail runs on inventory bought forward, so pass-through is
  # lagged: whatever does not land in 2026 lands in 2027. Applied in
  # cpi_timing() in R/calcs.R.
  passthrough_year1 = c(low = 0.5, central = 0.7, high = 0.9),

  # Sensitivity grid for the CPI arithmetic (total effect on the price level).
  weight_grid = seq(1.0, 2.6, by = 0.2),   # total device weight, % of CPI
  swing_grid  = seq(6, 26, by = 2)         # avg swing vs trend, pct points
)

# Tier ordering for the provenance table: how much weight a reader should
# put on each number.
source_tiers <- c("official", "industry", "media", "weak", "assumption")
