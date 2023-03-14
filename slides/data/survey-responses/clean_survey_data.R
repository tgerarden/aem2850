library(tidyverse)
library(rjson)

# IMPORT SURVEY DATA ----
all_responses <- read_csv("content/slides/data/survey-responses/lab-1-survey.csv") |>
  separate(netid, into = c("netid"), sep = "@") |>
  mutate(netid = tolower(netid))

enrolled_students <- read_csv("content/slides/data/survey-responses/enrollment-feb6.csv") |>
  select(netid = `NET ID`)

responses <- inner_join(all_responses, enrolled_students, by = "netid")


# EXTRACT DATA OF DIFFERENT TYPES----


# NAMES ----
# name <- vector(mode = "character", length = length(survey_raw))
# for (i in 1:length(survey_lines)){
#   name[i] <- survey_lines[i][[1]][grepl("Name:", survey_lines[i][[1]])] %>%
#     stringr::str_replace(., ".*Name:", "") %>%
#     str_trim(.)
# }


# PRIOR CODING EXPERIENCE ----
prior_programming <- responses |>
  select(prior_programming = "Have you done any programming before?")


# SPECTATOR SPORTS ----
sports <- responses |>
  select(sport = "Favorite spectator sport") |>
  pull(sport)


# CONCENTRATIONS ----
concentrations_raw <- responses |>
  select(degree = "Degree program and major", concentration = "Concentration") |>
  mutate(
    program = case_when(
      str_detect(degree, "BA") ~ "BA",
      str_detect(degree, "BS") ~ "BS",
      str_detect(degree, "MPS") ~ "MPS",
      str_detect(degree, "MS") ~ "MS",
      TRUE ~ "BS"
    )
  )

concentrations <- concentrations_raw |>
  mutate(concentration = tolower(concentration)) |>
  mutate(ba = str_detect(concentration, "business analytics"),
         finance = str_detect(concentration, "finance") | str_detect(concentration, "finace"), # BS finance and MPS behavioral finance
         strategy = str_detect(concentration, "strategy"),
         # accounting = str_detect(concentration, "accounting"),
         dev = str_detect(concentration, "development"),
         entr = str_detect(concentration, "entrepreneurship"),
         enviro = str_detect(concentration, "sustainable") | str_detect(concentration, "environmental") | str_detect(concentration, "eere"),
         food = str_detect(concentration, "food"),
         mkting = str_detect(concentration, "marketing"),
         tech = str_detect(concentration, "tech") & str_detect(concentration, "manage")) |>
  mutate(other = (ba + finance + strategy + dev + entr + enviro + food + mkting + tech)==0)


# COMPANIES ----
companies <- responses |>
  select(ticker = "Ticker of your favorite publicly traded company") |>
  mutate(
    ticker = case_match(
      ticker,
      "Not sure" ~ NA,
      "Haven't invested in stocks." ~ NA,
      "I do not really follow the stock market" ~ NA,
      "I don't have one unfortunately" ~ NA,
      "Don't have one" ~ NA,
      "Don't have a preference" ~ NA,
      "GOOG (Google)" ~ "GOOGL",
      "NASDAQ: ULTA" ~ "ULTA",
      "Blackstone" ~ "BX",
      "Apple" ~ "AAPL",
      "Ike" ~ "IKE",
      .default = ticker
    )
  )

# join tickers with company names
tickers <- fromJSON(file = "content/slides/data/survey-responses/company_tickers.json")
tickers <- do.call(bind_rows, tickers) |>
  rename(name = title) |>
  select(ticker, name)

companies <- left_join(companies, tickers, join_by(ticker)) |>
  mutate(
    name = case_match(
      ticker,
      "CICC" ~ "China International Capital Corp",
      "601318" ~ "Ping An Insurance",
      "IKE" ~ "ikeGPS",
      .default = name
    )
  )




# SAVE DATA ----
save(prior_programming,
     sports,
     concentrations_raw, concentrations,
     companies,
     file = paste0("content/slides/data/survey-responses/survey-data.RData"))

# export names, concentrations, and prior programming ----
# tibble(name = name, concentration = concentrations_raw, prior_programming = programming) %>%
#   write_csv(paste0(dir,"/student_info.csv"))


# MAKE LIST OF COMPANIES FOR GROUP PROJECT ----
load("rstudio-cloud/group-project/sp500.RData")

companies |>
  rename(symbol = ticker,
         sec_name = name) |>
  group_by(symbol, sec_name) |>
  count() |>
  ungroup() |>
  left_join(sp500_companies |> select(symbol, company),
            join_by(symbol)) |>
  mutate(name = case_when(
    is.na(company) ~ str_to_title(sec_name),
    TRUE ~ company
  )) |>
  select(name, n) |>
  filter(!is.na(name)) |>
  arrange(name) |>
  write_csv("rstudio-cloud/group-project/our-companies.csv")
