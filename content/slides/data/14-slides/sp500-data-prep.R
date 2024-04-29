library(tidyverse)

# PREP S&P 500 DATA FOR STUDENTS ----
# install.packages("tidyquant")
if(FALSE){ # do not repeat this after completing it once manually
  # import list of stocks in the S&P 500
  sp500_stocks.raw <- tidyquant::tq_index("SP500") |>
    filter(symbol!="-") # filter out SPDR S&P 500 ETF's u.s. dollar holdings

  # tack on failed banks for slides
  sp500_stocks.clean <- sp500_stocks.raw |>
    full_join(
      tibble(symbol = c("SIVBQ", "SBNY", "FRCB")),
      join_by(symbol)
    )

  # import prices for S&P 500 stocks
  sp500_prices <- tidyquant::tq_get(
    sp500_stocks.clean$symbol,
    from = "2019-01-01",
    to = "2024-01-01"
  )

  # NOTE: missing stocks do not appear to be an issue as of spring 2023
  # remove missing values from list of stocks
  # a few stocks lack historical data on yahoo finance
  sp500_stocks <- inner_join(
    sp500_stocks.clean,
    sp500_prices |> select(symbol) |> unique(),
    join_by(symbol)
  )
  rm(sp500_stocks.raw, sp500_stocks.clean)
  sp500_companies <- sp500_stocks

  # reweight to account for missing stocks -- make sure they sum up to 1
  sp500_companies <- sp500_companies |>
    mutate(weight = weight / sum(weight, na.rm = TRUE)) # ignore failed banks
  # remove shares_held (this is for SPY S&P 500 index holdings, not to be confused with shares outstanding)
  sp500_companies <- sp500_companies |>
    select(-shares_held)

  stopifnot(nrow(sp500_companies) == length(unique(sp500_prices$symbol)))
  rm(sp500_stocks)

  save(sp500_companies, sp500_prices, file = "content/slides/data/14-slides/sp500.RData")

  # # PREP S&P 500 DATA FOR STUDENTS ----
  # # use attach and detach here to get just the object companies without loading everything else in the .RData file into the global environment
  # attach("../../content/slides/data/survey-responses/survey-data.RData")
  # companies <- companies
  # detach('file:../../content/slides/data/survey-responses/survey-data.RData')
  # companies |>
  #   group_by(ticker) |> count() |>
  #   filter(!is.na(ticker)) |>
  #   write_csv("our-companies.csv")
}
