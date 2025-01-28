library(tidyverse)
library(rjson)

# IMPORT SURVEY DATA ----
all_responses <- read_csv("content/slides/data/survey-responses/homework-1-survey.csv") |>
  separate(netid, into = c("netid"), sep = "@", extra = "drop") |>
  mutate(netid = tolower(netid))

responses <- all_responses

enrolled_students <-
  rbind(
    read_csv("content/slides/data/survey-responses/enrollment-sec1-jan27.csv"),
    read_csv("content/slides/data/survey-responses/enrollment-sec2-jan27.csv")
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
      str_detect(degree, "Bachelor of Arts") ~ "BA",
      str_detect(degree, "BS|AEM|Dyson") ~ "BS",
      str_detect(degree, "Applied Economics and Management") ~ "BS",
      str_detect(degree, "MPS") ~ "MPS",
      str_detect(degree, "MPA") ~ "MPA",
      str_detect(degree, "Master of Public Administration") ~ "MPA",
      str_detect(degree, "MS") ~ "MS",
      str_detect(degree, "PhD") ~ "PhD",
      str_detect(degree, "CAS") ~ "BA",
      str_detect(degree, "MILR") ~ "MILR",
      str_detect(degree, "MMH") ~ "MMH",
      str_detect(degree, "MA") ~ "MA",
      str_detect(degree, "bs") ~ "BS",
      TRUE ~ NA
      # TRUE ~ "BS"
    )
  ) |>
  # coarse definition
  mutate(
    program = case_when(
      str_detect(program, "^B") ~ "Bachelor's",
      str_detect(program, "^M") ~ "Master's"
           )
  )

concentrations <- concentrations_raw |>
  mutate(concentration = tolower(concentration)) |>
  mutate(ba = str_detect(concentration, "business analytics"),
         acct = str_detect(concentration, "accounting"),
         dev = str_detect(concentration, "development"),
         econ = str_detect(concentration, "economics") | str_detect(degree, "Econ"),
         # entr = str_detect(concentration, "entrepreneurship"),
         enviro = str_detect(concentration, "sustainable|sustainability|environmental|eere|sbep|sbee"),
         finance = str_detect(concentration, "finance") | str_detect(concentration, "finace"), # BS finance and MPS behavioral finance
         food = str_detect(concentration, "food"),
         mktg = str_detect(concentration, "marketing"),
         mgmt = str_detect(concentration, "management") | concentration=="tm", # management + tech management + agribusiness management
         strategy = str_detect(concentration, "strategy"),
         hr = str_detect(concentration, "human resources|hr ")
         ) |>
  mutate(other = (ba + acct + dev + econ + enviro + finance + food + mktg + mgmt + strategy + hr)==0)


# COMPANIES ----
companies <- responses |>
  select(ticker = "Ticker of your favorite publicly traded company") |>
  mutate(
    ticker = case_match(
      ticker,
      "TSLA/NVDA" ~ "TSLA",
      "None" ~ NA,
      "DOCS (London Stock Exchange)" ~ "DOCS",
      "CVS Health" ~ "CVS",
      "AAPL, GOOGL" ~ "AAPL",
      "NVIDIA Corp" ~ "NVDA",
      "N/A" ~ NA,
      "Apple" ~ "AAPL",
      "APL" ~ "AAPL",
      "APPL" ~ "AAPL",
      "I didn't learnt much about that." ~ NA,
      "Do not really have one" ~ NA,
      "DIS, UTHR" ~ "DIS",
      "NASDAQ: FLNC" ~ "FLNC",
      "DIS (Walt Disney Co)" ~ "DIS",
      "It's hard question, as I don't have any favorite comes to mind right now. Maybe, Netflix Inc." ~ "NFLX",
      "Nvidia" ~ "NVDA",
      "227.44 Apple" ~ "AAPL",
      "Don't have any" ~ NA,
      "NASDAQ:AAPL" ~ "AAPL",
      "Estee Lauder Companies Inc.  (EL)" ~ "EL",
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
      "RIL" ~ "Reliance Industries Ltd",
      "TTM" ~ "Titan Minerals Ltd",
      "002594" ~ "BYD",
      "TATAMOTORS" ~ "Tata Motors Ltd",
      .default = name
    )
  )

# check for missing company names
companies |> filter(is.na(name) & !is.na(ticker))


# SAVE DATA ----
save(prior_programming,
     sports,
     concentrations_raw, concentrations,
     companies,
     file = paste0("content/slides/data/survey-responses/survey-data.RData"))

# export names, concentrations, and prior programming ----
# tibble(name = name, concentration = concentrations_raw, prior_programming = programming) %>%
#   write_csv(paste0(dir,"/student_info.csv"))


# # MAKE LIST OF COMPANIES FOR GROUP PROJECT ----
# load("rstudio-cloud/group-project/sp500.RData")
#
# companies |>
#   rename(symbol = ticker,
#          sec_name = name) |>
#   group_by(symbol, sec_name) |>
#   count() |>
#   ungroup() |>
#   left_join(sp500_companies |> select(symbol, company),
#             join_by(symbol)) |>
#   mutate(name = case_when(
#     is.na(company) ~ str_to_title(sec_name),
#     TRUE ~ company
#   )) |>
#   select(name, n) |>
#   filter(!is.na(name)) |>
#   arrange(name) |>
#   write_csv("rstudio-cloud/group-project/our-companies.csv")
