# Data visualisation
# AB
# 13 Feb 2024
# SSI2007/3003: week 4

library(tidyverse)
library(vroom)

# 1. Read the indresp file from Wave 13 and keep the following variables: pidp, derived sex and age , 
# and net personal income (fimnnet_dv). Visualise the distribution of income with a histogram, 
# a density plot and a box plot.
# 


m_indresp <- vroom("UKDA-6614-tab/tab/ukhls/m_indresp.tab")
  
m_indresp <- m_indresp |>
  select(pidp, m_sex_dv, m_age_dv, m_fimnnet_dv, m_gor_dv)

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

m_indresp <- m_indresp |>
  mutate(sex_label = case_when(
    m_sex_dv == 1 ~ "Male",
    m_sex_dv == 2 ~ "Female",
    TRUE ~ NA_character_)
    )

m_indresp |> count(m_age_dv) |> print(n = Inf)

m_indresp <- m_indresp |>
  mutate(m_age_dv = ifelse(m_age_dv != -9, m_age_dv, NA_real_))

# Visualising income

# as a histogram

# Assuming m_indresp is your data frame and m_fimnnet_dv is the variable of interest


# Create a histogram for m_fimnet_dv with specified x-axis range
ggplot(data = m_indresp, aes(x = m_fimnnet_dv)) +
  geom_histogram(bins = 100, fill = "blue", color = "black") +
  scale_x_continuous(limits = c(-100, 10000)) +
  theme_minimal() +
  labs(x = "Net personal income",
       y = "Frequency")


ggplot(data = m_indresp, aes(x = m_fimnnet_dv)) +
  geom_histogram(aes(y = ..density..), binwidth = 100, fill = "blue", color = "black") + # Use density for y
  geom_density(aes(y = ..density..), colour = "red", size = 1) + # Add density plot
  scale_x_continuous(limits = c(-100, 10000)) +
  labs(x = "Net personal income", y = "Density") + # Adjust y label to "Density"
  theme_minimal()

# as a boxplot

ggplot(data = m_indresp, aes(x = "", y = m_fimnnet_dv)) +
  geom_boxplot(fill = "lightblue", color = "black") +
  # scale_y_continuous(limits = c(-100, 10000)) +
  labs(x = "", y = "Net personal income") +
  theme_minimal()


# 2. Visualise the distribution of sex with a bar chart. 

m_indresp |>
  filter(!is.na(sex_label)) |>
  ggplot(aes(x = sex_label, fill = sex_label)) +
  geom_bar(stat = "count") +
  scale_fill_manual(values = c("Male" = "blue", "Female" = "pink")) +
  labs(x = "Sex", y = "Count") +
  theme_minimal()

# region

m_indresp %>%
    filter(!is.na(region_label)) %>%
    ggplot(aes(x = fct_reorder(region_label, region_label, .fun = length))) +
    geom_bar(stat = "count") +
    labs(x = "Region", y = "Count") +
    theme_minimal() +
    theme(
      text = element_text(size = 16), # Adjusts global text size
      axis.title = element_text(size = 18), # Adjusts axis titles size
      axis.text = element_text(size = 16), # Adjusts axis text size
      plot.title = element_text(size = 18),
      axis.text.x = element_text(angle = 45, hjust = 1) # Rotates x-axis labels
    )

# as percentages

library(tidyverse)

m_indresp %>%
  filter(!is.na(region_label)) %>%
  ggplot(aes(x = fct_reorder(region_label, region_label, .fun = length), y = ..prop.., group = 1)) +
  geom_bar(aes(y = ..prop..), stat = "count") +
  scale_y_continuous(labels = scales::percent_format(), name = "Percentage") +
  labs(x = "Region", y = "Percentage") +
  theme_minimal() +
  theme(
    text = element_text(size = 16), # Adjusts global text size
    axis.title = element_text(size = 18), # Adjusts axis titles size
    axis.text = element_text(size = 16), # Adjusts axis text size
    plot.title = element_text(size = 18),
    axis.text.x = element_text(angle = 45, hjust = 1) # Rotates x-axis labels
  )


# Create a variable for age groups and visualise 
# # the distribution of  age, both as a continuous and categorical variable.
# # 

ggplot(data = m_indresp, aes(x = m_age_dv)) +
  geom_histogram(binwidth = 1) + # Use density for y
  labs(x = "Age", y = "Density") + # Adjust y label to "Density"
  theme_minimal()


# 3. Think of the best way to visualise the relationship between sex, age, region and income.
# 
m_indresp |>
  filter(!is.na(sex_label)) |>
  filter(!is.na(region_label)) |>
  ggplot(aes(x = m_age_dv, y = m_fimnnet_dv, color = sex_label)) +
  # stat_summary(fun = mean, geom = "line", aes(group = sex_label), na.rm = TRUE, size = 2) +
  geom_smooth(aes(group = sex_label), size = 2) +
  scale_x_continuous(limits = c(16, 75)) +
  labs(x = "Age", y = "Mean Income", color = "Sex") +
  theme_minimal() +
  theme(
    text = element_text(size = 14),
    axis.title = element_text(size = 16),
    axis.text = element_text(size = 14),
    plot.title = element_text(size = 16)
  ) +
  facet_wrap( ~ region_label)


# Median income by region


# Calculate median income by region and reorder regions
m_indresp_summary <- m_indresp %>%
  group_by(region_label) %>%
  summarize(median_income = median(m_fimnnet_dv, na.rm = TRUE)) %>%
  arrange(median_income) %>%
  mutate(region_label = fct_inorder(region_label))

# Create a horizontal bar chart
m_indresp_summary |>
  filter(!is.na(region_label)) |>
  ggplot(aes(x = region_label, y = median_income)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() + # Make the bar chart horizontal
  labs(x = "Region", y = "Median Income", title = "Median Income by Region") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.title = element_blank() # Remove the legend title if not needed
  )


# 
# Homework for next week: revise the material from weeks 1-4.

