library(tidyverse)
library(rjson)

# IMPORT SURVEY DATA ----
all_responses <- read_csv("content/slides/data/survey-responses/lab-1-survey.csv") |>
  separate(netid, into = c("netid"), sep = "@") |>
  mutate(netid = tolower(netid))

responses <- all_responses

enrolled_students <-
  rbind(
    read_csv("content/slides/data/survey-responses/enrollment-feb12-sec1.csv"),
    read_csv("content/slides/data/survey-responses/enrollment-feb12-sec2.csv")
    ) |>
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
  pull(sport) |>
  tolower()


# CONCENTRATIONS ----
concentrations_raw <- responses |>
  select(degree = "Degree program and major", concentration = "Concentration") |>
  mutate(
    program = case_when(
      str_detect(degree, "BA") ~ "BA",
      str_detect(degree, "BS|AEM|Dyson") ~ "BS",
      str_detect(degree, "Applied Economics and Management") ~ "BS",
      str_detect(degree, "MPS") ~ "MPS",
      str_detect(degree, "MPA") ~ "MPA",
      str_detect(degree, "Master of Public Administration") ~ "MPA",
      str_detect(degree, "MS") ~ "MS",
      str_detect(degree, "PhD") ~ "PhD",
      str_detect(degree, "CAS") ~ "BA",
      TRUE ~ "BS"
    )
  )

concentrations <- concentrations_raw |>
  mutate(concentration = tolower(concentration)) |>
  mutate(ba = str_detect(concentration, "business analytics"),
         acct = str_detect(concentration, "accounting"),
         dev = str_detect(concentration, "development"),
         econ = str_detect(concentration, "economics") | str_detect(degree, "Econ"),
         # entr = str_detect(concentration, "entrepreneurship"),
         enviro = str_detect(concentration, "sustainable|sustainability|environmental|eere|sbep"),
         finance = str_detect(concentration, "finance") | str_detect(concentration, "finace"), # BS finance and MPS behavioral finance
         food = str_detect(concentration, "food"),
         mktg = str_detect(concentration, "marketing"),
         mgmt = str_detect(concentration, "management") | concentration=="tm", # management + tech management + agribusiness management
         strategy = str_detect(concentration, "strategy")
         ) |>
  mutate(other = (ba + acct + dev + econ + enviro + finance + food + mktg + mgmt + strategy)==0)


# COMPANIES ----
companies <- responses |>
  select(ticker = "Ticker of your favorite publicly traded company") |>
  mutate(
    ticker = case_match(
      ticker,
      "Not sure" ~ NA,
      "I don't have just one" ~ NA,
      "none" ~ NA,
      "don't have any" ~ NA,
      "apple" ~ "AAPL",
      "$AMD" ~ "AMD",
      "APPL" ~ "AAPL",
      "SPINN" ~ "SPINN.HE",
      "PFE (Pfizer Inc.)" ~ "PFE",
      "Tesla" ~ "TSLA",
      "Tesla, Apple, BYD" ~ "TSLA",
      "I don't really have a favorite, but I'd probably go with MSFT" ~ "MSFT",
      "Tough one... I'd say $NEE" ~ "NEE",
      "ISIN: US88160R1014" ~ "TSLA",
      "None" ~ NA,
      "not sure" ~ NA,
      "NASDAQ" ~ "NDAQ",
      "HBD, AAPL, TCS" ~ "AAPL",
      "PayPal" ~ "PYPL",
      "$AAPL" ~ "AAPL",
      "Apple" ~ "AAPL",
      "no" ~ NA,
      "BOM:500800" ~ "TATACONSUM",
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
