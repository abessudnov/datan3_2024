# Data transformation with dplyr.
# AB
# 23 Jan 2024

# R for Data Science (2nd ed): https://r4ds.hadley.nz
# ch.3 (Data transformation): https://r4ds.hadley.nz/data-transform
# ch.19 (Joins): https://r4ds.hadley.nz/joins
# 

library(tidyverse)
library(vroom)

m_indresp <- read.table("UKDA-6614-tab/tab/ukhls/m_indresp.tab", header = TRUE)
m_indresp <- read_tsv("UKDA-6614-tab/tab/ukhls/m_indresp.tab")
m_indresp <- vroom("UKDA-6614-tab/tab/ukhls/m_indresp.tab")

m_indresp |>
  count(m_age_dv) |>
  print(n = Inf)

# base R: table(m_indresp$m_age_dv)

# Filtering your data

m_indresp |>
  filter(m_age_dv > 25)

# >, >=, ==, <=, <
# & AND
# # | OR
# ! NOR

# Restrict your sample to women aged 18 to 35.

m_indresp |>
  count(m_sex_dv)

# 1 male
# 2 female

# ChatGPT:
# filtered_data <- data %>%
#   filter(gender_variable == "Female", age_variable >= 18, age_variable <= 35)

m_indresp |>
  filter(m_sex_dv == 2, m_age_dv >= 18, m_age_dv <= 35)

m_indresp |>
  filter(m_sex_dv == 2) |>
  filter(m_age_dv %in% 18:35)

# Creating new variables and recoding variables

# recode sex into a dummy variable for female 

m_indresp |>
  mutate(m_female = case_when(
    m_sex_dv == 1 ~ 0,
    m_sex_dv == 2 ~ 1,
    m_sex_dv == 0 | m_sex_dv == -9 ~ NA_integer_,
    TRUE ~ NA_integer_  # Handles any other unexpected values
  )) |>
  count(m_sex_dv, m_female)

# proportion of women
m_indresp |>
  mutate(m_female = case_when(
    m_sex_dv == 1 ~ 0,
    m_sex_dv == 2 ~ 1,
    m_sex_dv == 0 | m_sex_dv == -9 ~ NA_integer_,
    TRUE ~ NA_integer_  # Handles any other unexpected values
  )) |>
  summarise(
    mean(m_female, na.rm = TRUE)
  )

m_indresp |>
  count(m_sex_dv) |>
  mutate(perc_sex = n / sum(n) * 100)


# summarising by group

# mean age in the entire sample

m_indresp |>
summarise(
  mean(m_age_dv, na.rm = TRUE)
)

# mean age by group

m_indresp |>
  group_by(m_sex_dv) |>
  summarise(
    mean(m_age_dv, na.rm = TRUE)
  )

m_indresp |>
  group_by(m_sex_dv, m_gor_dv) |>
  summarise(
    mean(m_age_dv, na.rm = TRUE)
  )

# 3. Recode age into the following age groups:  <= 25, 26-45, 46-65, >65 years old.
# calculate the average life satisfaction in each group


df <- m_indresp  %>%
  select(pidp, m_age_dv, m_sclfsato) %>%
  mutate(m_age_dv = if_else(m_age_dv < 0, NA_real_, m_age_dv)) %>%
  mutate(m_age_group = case_when(
    m_age_dv <= 25 ~ "<= 25",
    m_age_dv >= 26 & m_age_dv <= 45 ~ "26-45",
    m_age_dv >= 46 & m_age_dv <= 65 ~ "46-65",
    m_age_dv > 65 ~ "> 65",
    TRUE ~ NA_character_  # Handles missing or unexpected values
  )) %>%
  mutate(m_life_satisfaction = if_else(m_sclfsato < 0, NA_real_, m_sclfsato))

df %>%
  group_by(m_age_group) %>%
  summarise(mean_life_satisfaction = mean(m_life_satisfaction, na.rm = TRUE))

# For week 3 please read ch. 19 and ch.5 from R for Data Science (2nd ed): https://r4ds.hadley.nz
