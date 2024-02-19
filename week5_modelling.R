# Modelling
# AB
# 19 Feb 2024
# SSI2007/3003: week 5

# Task for today: build the models for the association between income, sex, age
# and region

library(tidyverse)
library(vroom)

m_indresp <- vroom("UKDA-6614-tab/tab/ukhls/m_indresp.tab")

m_indresp <- m_indresp |>
  select(pidp, m_sex_dv, m_age_dv, m_fimnnet_dv, m_gor_dv)

# Always start with looking at the distribution and coding of the variables
# you use in your analysis.

# age

m_indresp |> count(m_age_dv) |> print(n = Inf)

m_indresp <- m_indresp |>
  mutate(m_age_dv = ifelse(m_age_dv != -9, m_age_dv, NA_real_))

# sex

m_indresp <- m_indresp |>
  mutate(sex_label = case_when(
    m_sex_dv == 1 ~ "Male",
    m_sex_dv == 2 ~ "Female",
    TRUE ~ NA_character_)
  )

# income

m_indresp |> count(m_fimnnet_dv) |> print(n = Inf)
m_indresp |> pull(m_fimnnet_dv) |> summary()

# region


# Recoding and cleaning data

# Recode numeric values to region labels
m_indresp <- m_indresp |>
  mutate(region_label = case_when(
    m_gor_dv == 1 ~ "North East",
    m_gor_dv == 2 ~ "North West",
    m_gor_dv == 3 ~ "Yorkshire and the Humber",
    m_gor_dv == 4 ~ "East Midlands",
    m_gor_dv == 5 ~ "West Midlands",
    m_gor_dv == 6 ~ "East of England",
    m_gor_dv == 7 ~ "London",
    m_gor_dv == 8 ~ "South East",
    m_gor_dv == 9 ~ "South West",
    m_gor_dv == 10 ~ "Wales",
    m_gor_dv == 11 ~ "Scotland",
    m_gor_dv == 12 ~ "Northern Ireland",
    m_gor_dv == -9 | is.na(m_gor_dv) ~ NA_character_,
    TRUE ~ NA_character_ # Handles any other unexpected values
  ))

# Regression modelling

lm(m_fimnnet_dv ~ sex_label, data = m_indresp) |> summary()

lm(m_fimnnet_dv ~ m_age_dv, data = m_indresp) |> summary()

m_indresp |>
  ggplot(aes(x = m_age_dv, y = m_fimnnet_dv)) +
  geom_smooth(method = "lm") +
  geom_smooth(colour = "red") +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), color = "purple")

lm(m_fimnnet_dv ~ m_age_dv + I(m_age_dv^2), data = m_indresp) |> summary()




# Solutions for the formative ELE test


xwavedat |>
  count(plbornc) |>
  print(n = Inf)


data_tibble <- tibble(
  generation = c(1, 2, 3, 4, 5, 6),
  propMale = c(0.472, 0.456, 0.427, 0.440, 0.570, 0.565)
)

data_wide <- data_tibble %>% 
  pivot_wider(names_from = generation, values_from = propMale)

xwavedat %>%
  filter(sex_dv == 2 & birthy >= 1970 & birthy <= 1979)


xwavedat %>%
  filter(birthy < 1940) %>%
  mutate(age_group = case_when(
    birthy < 1920 ~ "Before 1920",
    birthy >= 1920 & birthy <= 1929 ~ "1920 to 1929",
    birthy >= 1930 & birthy <= 1939 ~ "1930 to 1939"
  )) %>%
  group_by(age_group) %>%
  summarise(percentage_men = mean(sex_dv == 1, na.rm = TRUE) * 100) %>%
  # Step 2: Plot the data
  ggplot(aes(x = age_group, y = percentage_men, fill = age_group)) +
  geom_bar(stat = "identity") +
  labs(title = "Percentage of Men by Birth Year Range",
       x = "Birth Year Range",
       y = "Percentage of Men") +
  theme_minimal() +
  scale_fill_brewer(palette = "Pastel1")


# Prepare the data
xwavedat_cleaned <- xwavedat %>%
  # Filter men only
  filter(sex_dv == 1) %>%
  # Code specified values as NA in scend_dv
  mutate(scend_dv = replace(scend_dv, scend_dv %in% c(0, -8, -9), NA)) %>%
  # Filter for UK born and first-generation immigrants from India, Pakistan, Bangladesh
  filter(ukborn %in% 1:4 | plbornc %in% c(18, 19, 20)) %>%
  # Create a new variable for group categorization
  mutate(group = case_when(
    ukborn %in% 1:4 ~ "UK",
    plbornc == 18 ~ "India",
    plbornc == 19 ~ "Pakistan",
    plbornc == 20 ~ "Bangladesh"
  )) %>%
  # Remove cases with NA in scend_dv now
  filter(!is.na(scend_dv)) %>%
  group_by(group) %>%
  summarise(average_age_leaving_school = mean(scend_dv, na.rm = TRUE))

xwavedat_cleaned

# Plot the data
ggplot(xwavedat_cleaned, aes(x = group, y = average_age_leaving_school)) +
  geom_point(stat = "identity", size = 3, color = "blue") +
  labs(title = "Average School Leaving Age",
       x = "Group",
       y = "Average Age") +
  theme_minimal()

