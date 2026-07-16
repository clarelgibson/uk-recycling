# UK Recycling

Does the collection system have a meaningful impact on recycling rate?

[**Read the analysis**](https://clarelgibson.github.io/uk-recycling/)

## Description

This project explores the question above. Kerbside sort recycling systems place a high burden on the householder to sort and store their waste in up to seven bins, but do these systems achieve higher recycling rates than the alternative co-mingled system, where all recyclable waste is put into a single bin and sorted off-site?

The analysis compares household recycling rates across 309 English local authorities in 2021, grouped by collection system (Co-Mingled, Two Stream or Multi-Stream). It uses a Kruskal-Wallis test with Dunn's post-hoc comparisons to test for differences, and linear regression to control for authority size.

The headline finding is that collection system is associated with a real but modest difference in recycling rate. The meaningful divide is between mixing everything in one bin and having some level of separation, rather than between separating a little and separating a lot. Most of the variation in recycling rates lies outside the collection system.

## Repository structure

| Path | Description |
|----|----|
| `recycling-systems-analysis.qmd` | The analysis document (source for the published page) |
| `custom.scss` | Data Translator branding for the rendered document |
| `R/theme_datatranslator.R` | Brand palette and ggplot theme, sourced by the analysis |
| `R/1-utils.R` to `R/5-export-data.R` | Data pipeline: acquisition, preparation, modelling and export |
| `data/src/` | Raw source data (not tracked; see Data below) |
| `data/cln/` | Cleaned datasets produced by the pipeline |
| `ref/` | Reference material |

## Getting started

### Prerequisites

- R (\>= 4.0)
- [Quarto CLI](https://quarto.org/docs/download/)
- R packages: `tidyverse`, `here`, `knitr`, `moments`, `rstatix`, `broom`, `showtext`

Rendering downloads the Work Sans and Roboto Mono fonts from Google Fonts, so a network connection is required.

### Data

The cleaned dataset used by the analysis (`data/cln/data_recycling_system.csv`) is included in the repository. To rebuild it from source, download the following into `data/src/` and run the pipeline scripts in `R/` in numbered order.

- [Local Authority Districts (Dec 2021) Names and Codes in the UK](https://geoportal.statistics.gov.uk/documents/d1fab2d9fb0a4576a7e08f89ac7e0b72/about) (Save as `data/src/lad21.xlsx`)
- [Local Authority District to Region (April 2021) Lookup in England](https://geoportal.statistics.gov.uk/datasets/94f38d2d8e7540bcafcfb86e08b18a1c_0/explore) (Save as `data/src/lad21-to-region21.csv`)
- [Local Authority Districts (December 2021) Boundaries GB BFE](https://geoportal.statistics.gov.uk/datasets/505b177be82946b284c947cab91eeb31_0/explore?location=54.961226%2C-3.262782%2C5.91) (Save as `data/src/lad21-shapefile/`)
- [Mid-2021 edition Estimates of the population for the UK, England, Wales, Scotland and Northern Ireland](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland) (Save as `data/src/population-by-lad-2021.xls`)
- [Mid-2019 edition Estimates of the population for the UK, England, Wales, Scotland and Norther Ireland](https://cy.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationestimatesforukenglandandwalesscotlandandnorthernireland/mid2019april2019localauthoritydistrictcodes/ukmidyearestimates20192019ladcodes.xls) (Save as `data/src/population-by-lad-2019.xls`)
- [Local authority collected waste management - annual results](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1144270/LA_and_Regional_Spreadsheet_202122.xlsx) (Save as `data/src/recycling-by-lad-2021.xlsx`)
- [Freedom of Information request for data on recycling systems by local authority for 2021](https://docs.google.com/spreadsheets/d/1M36p2m3Y59JvwW-a8sD-xXGADIkoe10N/edit?usp=share_link&ouid=110132729826719978887&rtpof=true&sd=true) (Save as `data/src/EIR2023_21546.xlsx`)
- [English indices of deprivation 2019](https://www.gov.uk/government/statistics/english-indices-of-deprivation-2019) (Save as `data/src/deprivation-by-lad-2019.xlsx`)
- [2021 rural-urban classification](https://www.ons.gov.uk/methodology/geography/geographicalproducts/ruralurbanclassifications/2021ruralurbanclassification) (save as `data/src/ruc-by-lad-2021.xlsx`)
- [Code History Database (December 2021) for the UK - changes.csv](https://geoportal.statistics.gov.uk/datasets/adb8830e23294ecc82a727c6eea330ce/about) (save as `data/src/chd-2021-changes.csv`)

The links above go to the original source location of the data. Should the links ever go stale, a copy of the same data can also be found on [Kaggle](https://www.kaggle.com/datasets/doublew/household-recycling-in-england-2021).

## Rendering and publishing

Render locally to preview:

``` bash
quarto render recycling-systems-analysis.qmd
```

Publish the rendered document to GitHub Pages:

``` bash
quarto publish gh-pages recycling-systems-analysis.qmd
```

This renders the document, pushes the output to the `gh-pages` branch, and updates the published page at <https://clarelgibson.github.io/uk-recycling/>. The `_publish.yml` file records the publishing target, so subsequent runs do not prompt for confirmation.

## Author

- [Clare Gibson](https://www.datatranslator.co.uk) - [clare\@datatranslator.co.uk](mailto:clare@datatranslator.co.uk)

## Licence

This project is licensed under the CC0 1.0 Universal licence. See the [LICENSE](./LICENSE) file for details.
