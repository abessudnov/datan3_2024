# Data import
# AB
# 12 March 2024
# SSI2007/3003: week 9


# 1. Tabular/CSV/SPSS/Stata/SAS files

# readr and haven packages

# 2. Excel files

library(readxl)
library(tidyverse)

read_excel("data/GlobalEconomicProspectsJanuary2021GDPgrowthdata.xlsx")

excel_sheets("data/GlobalEconomicProspectsJanuary2021GDPgrowthdata.xlsx")

path <- c("data/GlobalEconomicProspectsJanuary2021GDPgrowthdata.xlsx")

df_table1_1_numbers <- read_excel(path, sheet = "Table 1.1",
                                  range = "F5:M49",
                                  col_names = c("y2018", "y2019", "y2020e", "y2021f", "y2022f", "space",
                                                "perc_diff_2020e", "perc_diff_2021f")) |>
  select(-space)


df_table1_1_text <- read_excel(path, sheet = "Table 1.1",
                               range = "A5:E49",
                               col_names = c("col1", "col2", "col3", "col4", "col5"))

df_table1_1_text <- df_table1_1_text |>
  unite("region", col1:col5, na.rm = TRUE, remove = TRUE)

df_table1_1 <- df_table1_1_text |>
  bind_cols(df_table1_1_numbers)

df_table1_1 <- df_table1_1 |>
  filter(region != "Memorandum items:") |>
  filter(region != "Real GDP1") |>
  filter(region != "Commodity prices6")


# reading all sheets together at the same time into a list
df <- path |>
   excel_sheets() |>
   set_names() |>
   map(read_excel, path = path)

class(df)
str(df)

df[[1]]


# Exercise: https://www.gov.uk/government/statistical-data-sets/immigration-system-statistics-data-tables

excel_sheets("data/passengers-refused-entry-border-datasets-dec-2023.xlsx")

df_refusals <- read_excel("data/passengers-refused-entry-border-datasets-dec-2023.xlsx",
                          sheet = "Data - Stp_D01", skip = 2,
                          col_names = c("year", "quarter", "nationality", "region", "location",
                                        "n"),
                          n_max = 14549)

df_refusals |>
  pull(n) |>
  str()

df_refusals |>
  group_by(nationality) |>
  summarise(
    total = sum(n, na.rm = TRUE)
  ) |>
  arrange(-total)


# 3. Web scraping

library(rvest)

# The IMO data

# https://www.imo-official.org/year_individual_r.aspx?year=2023

url_imo2023 <- c("https://www.imo-official.org/year_individual_r.aspx?year=2023")

page <- read_html(url_imo2023)
str(page)
page |>
  html_table() 

page |>
  html_table() |> str()

df_2023 <- page |>
  html_table()

class(df_2023)

df_2023 <- df_2023[[1]]
df_2023

# Doing this for many years

base_url_imo <- "https://www.imo-official.org/year_individual_r.aspx?year=%d"
years <- 2021:2023
urls <- sprintf(base_url_imo, years)
# #above will replace %d with each year in the years vector
# 
scrape_year <- function(url) {
   page <- read_html(url)
   table_data <- page %>% 
     html_table() %>%  
     .[[1]]
   return(table_data)
 }

imo_data <- map_dfr(urls, ~scrape_year(.x) |>
                      mutate(Year = readr::parse_number(str_extract(.x, "year=\\d+"))))


# Exercise: scrape this webpage: https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(PPP)_per_capita

url_wiki <- c("https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(PPP)_per_capita")

df_gdp <- url_wiki |>
  read_html() |>
  html_table(na.strings = "—", header = TRUE)

df_gdp <- df_gdp[[2]]

colnames(df_gdp) <- c("country", "region", "imf_estimate", "imf_year",
                      "world_bank_estimate", "world_bank_year",
                      "cia_estimate", "cia_year")

# to change the columns to the numeric format

df_gdp <- df_gdp |>
  # drop the first row
  slice(-1) |>
  mutate(across(c(imf_estimate, world_bank_estimate, cia_estimate), ~parse_number(.x)))



