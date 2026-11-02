# The Memory Price Shock and New Zealand

A short analytical note on how the 2026 global memory (DRAM/NAND) price shock
transmits to the New Zealand economy, with orders of magnitude attached.

Written as a Quarto report over a small, fully auditable set of hand-entered
data files. There is no econometrics in it on purpose — see the callout near
the top of the report.

## The verdict on inflation

The shock adds about **0.3 percentage points** to New Zealand's CPI price level
in total (range 0.19–0.35). Roughly **0.2pp** lands in 2026 annual inflation and
roughly **0.1pp** in 2027, because retail pass-through is lagged. Too small to
threaten the target; the Reserve Bank should look through it. It matters only
because it lands on top of a fuel shock that has already taken inflation to
4.1%, and from 2028 the risk turns disinflationary.

## Reading it

The report is `report/nz-memory-price-shock.qmd`. It covers:

- What the shock is, and why its *duration* and *bimodality* matter more than
  its size
- Five transmission channels into New Zealand: consumer prices, the import
  bill, ICT capital deepening, cloud and the data centre pipeline, and
  fiscal/distributional incidence
- What it means for monetary policy, given the June 2026 starting point
- What would falsify the conclusions

## Building it

```r
# From the project root
Rscript scripts/render.R
```

`scripts/render.R` uses the Quarto CLI when it is on `PATH`, and falls back to
`knitr` + `pandoc` when it is not, so the project builds either way. The
fallback writes `report/nz-memory-price-shock.html` and figures to `figures/`.

Dependencies: `ggplot2`, `dplyr`, `tidyr`, `scales`, `knitr`, `rmarkdown`.

## Layout

```
data/     Every input, as a small CSV a reader can check in a minute
  dram_contract_prices.csv    The shock itself (TrendForce quarterly changes)
  consumer_categories.csv     CPI weights, trend rates, shock sizes by category
  exposure_channels.csv       NZ spend bases and price effects by channel
  nz_macro_context.csv        NZ CPI, OCR and target, June 2026
  sources.csv                 Provenance for every number, with a tier
R/
  params.R    Every judgement call, with a range attached
  data.R      Loading
  calcs.R     The arithmetic (no models), incl. the 2026/2027 pass-through split
  theme.R     Plot styling
report/
  nz-memory-price-shock.qmd
scripts/
  render.R
```

## Ground rules used here

1. If a number is not in `data/sources.csv` with a URL, it lives in
   `R/params.R` labelled as an assumption, with a range.
2. Every estimate is quoted low–central–high. No bare point estimates.
3. Every parameter declared in `R/params.R` is used in the calculations; none
   is stated in the text but left out of the arithmetic.
4. No statistical model is fitted to a four-observation series.
5. Provenance is tiered: `official` / `industry` / `media` / `weak` /
   `assumption`. Readers should discount accordingly.

## Known limitations

Data are as at 25 August 2026; the September 2026 quarter CPI is not
incorporated. Stats NZ, Trading Economics, OEC and CRAN were unreachable from
the environment this was written in. New Zealand official figures come from
search-indexed summaries of Stats NZ and RBNZ releases rather than the releases
themselves, and trade aggregates are secondary sources.

**Before this is used for anything consequential**, replace the CPI weights in
`data/consumer_categories.csv` with the published Stats NZ expenditure weights
and pull the computing equipment sub-index from Infoshare. Everything
downstream recalculates. That is roughly an hour of work and it is the highest
value change anyone could make to this note.
