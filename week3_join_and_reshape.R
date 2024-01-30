# Joins/reshaping with dplyr and tidyr.
# AB
# 30 Jan 2024
# SSI2007/3003: week 3


# R for Data Science (2nd ed): https://r4ds.hadley.nz
# ch.19 (Joins): https://r4ds.hadley.nz/joins
# ch.5 (Data tidying): https://r4ds.hadley.nz/data-tidy
# 

# joins:
#   left_join()
#   right_join()
#   full_join()
#   inner_join()
# 
# semi_join()
# anti_join()

# 1. Join the **indresp** data from waves 13 and 12, in such a way that
# a) you keep all the individuals who took part in either wave 13 or wave 12,
# b) you keep only individuals who took part in both wave 13 and wave 12,
# c) you keep the individuals who took part in wave 12.

library(tidyverse)
library(vroom)

m_indresp <- vroom("UKDA-6614-tab/tab/ukhls/m_indresp.tab")
l_indresp <- vroom("UKDA-6614-tab/tab/ukhls/l_indresp.tab")

# a)
m_indresp |> full_join(l_indresp, by = "pidp")

# b)
m_indresp |> inner_join(l_indresp, by = "pidp")

# c) 

m_indresp |> right_join(l_indresp, by = "pidp")
l_indresp |> left_join(m_indresp, by = "pidp")


# 2. Join the **indresp** data from wave 13 and the data on ethnicity
# from the file with individual time constant characteristics. 

# ethn_dv
# racel_dv

xwavedat = vroom("UKDA-6614-tab/tab/ukhls/xwavedat.tab")

xwavedat_ethn <- xwavedat |>
  select(pidp, ethn_dv)
xwavedat_ethn

m_indresp |> left_join(xwavedat_ethn, by = "pidp")

# 3. Join the household data from waves 13 and 12.


m_hhresp <- vroom("UKDA-6614-tab/tab/ukhls/m_hhresp.tab")
l_hhresp <- vroom("UKDA-6614-tab/tab/ukhls/l_hhresp.tab")

l_ind_hh <- l_indresp |>
  full_join(l_hhresp, by = "l_hidp")

m_ind_hh <- m_indresp |>
  full_join(m_hhresp, by = "m_hidp")

l_ind_hh |>
  full_join(m_ind_hh, by = "pidp")

# 4. In wave 12 **indresp** data, create a variable for individuals
# who have not taken part in wave 13. Explore the association between sex, 
# age and the probability of sample attrition.

l_m_ind <- l_indresp |>
  anti_join(m_indresp, by = "pidp")

l_m_ind <- l_m_ind |>
  mutate(dropped = 1) |>
  select(pidp, dropped)

l_m_ind

l_dropped <- l_indresp |>
  left_join(l_m_ind, by = "pidp") |>
  select(pidp, dropped, l_sex, l_dvage) |>
  mutate(dropped = ifelse(is.na(dropped), 0, dropped))

l_dropped

# by sex

l_dropped |>
  count(l_sex)

l_dropped |>
  group_by(l_sex) |>
  summarise(
    mean(dropped)
  )

# by age

l_dropped |>
  count(l_dvage)

l_dropped |>
  filter(l_dvage > 0) |>
  mutate(ageGroup = case_when(
    l_dvage <= 25 ~ "<=25",
    l_dvage %in% 26:40 ~ "26-40",
    l_dvage %in% 41:65 ~ "41-65",
    l_dvage > 65 ~ ">65"
  )) |>
  group_by(ageGroup) |>
  summarise(
    mean(dropped)
  )


l_dropped |>
  filter(l_dvage > 0) |>
  ggplot(aes(x = l_dvage, y = dropped)) +
  geom_smooth()

# Reshaping from wide to long / from long to wide
# pivot_longer()
# pivot_wider()

# # 5. Join the data from waves 10 to 13 from the **indresp** files 
# and reshape to the long format. Include the variables for age, sex 
# and life satisfaction (sclfsato).

m_indresp <- vroom("UKDA-6614-tab/tab/ukhls/m_indresp.tab", 
                   col_select = c(pidp, m_sex_dv, m_age_dv, m_sclfsato))

l_indresp <- vroom("UKDA-6614-tab/tab/ukhls/l_indresp.tab", 
                   col_select = c(pidp, l_sex_dv, l_age_dv, l_sclfsato))

k_indresp <- vroom("UKDA-6614-tab/tab/ukhls/k_indresp.tab", 
                   col_select = c(pidp, k_sex_dv, k_age_dv, k_sclfsato))

waves11to13 <- k_indresp |>
  full_join(l_indresp, by = "pidp") |>
  full_join(m_indresp, by = "pidp")

waves11to13

waves11to13_long <- waves11to13 |>
  pivot_longer(k_sex_dv:m_sclfsato, names_to = "variable", values_to = "value") |>
  separate(variable, into = c("wave", "variable"), sep = "_",
           extra = "merge") |>
  pivot_wider(names_from = variable, values_from = value)


# 6. Add a variable for lagged life satisfaction (life satisfaction 
# in the previous wave).


waves11to13_long |>
  group_by(pidp) |>
  mutate(sclfsato_lag = lag(sclfsato)) |>
  ungroup()

# Analysis of the life satisfaction variable

waves11to13_long |>
  count(sclfsato)


# Mean life satisfaction by wave and gender.
waves11to13_long |>
  mutate(lifesat = ifelse(sclfsato > 0, sclfsato, NA_real_)) |>
  mutate(newSex = case_when(
    sex_dv == 1 ~ "men",
    sex_dv == 2 ~ "women"
  )
  ) |>
  filter(!is.na(newSex)) |>
  group_by(wave, newSex) |>
  summarise(
    meanlifeSat = mean(lifesat, na.rm = TRUE)
  )


# 7. Reshape the data back to the wide format. 
# Produce a table with the distribution for the number of waves individuals
# participated in.

waves11to13_wide <- waves11to13_long |>
  pivot_longer(sex_dv:sclfsato, names_to = "variable", values_to = "value") |>
  unite(variable_name, wave, variable) |>
  pivot_wider(names_from = variable_name, values_from = value)

waves11to13 |>
  # see if age is missing, if missing then it's TRUE (1) -- then add up
  mutate(nWaves = is.na(m_age_dv) + is.na(l_age_dv) + is.na(k_age_dv)) |>
  # change in such a way so that we show the number of waves participated, not missing
  mutate(nWaves = abs(nWaves - 3)) |>
  count(nWaves)


# 8. Join the **indresp** data from all 13 waves of the Understanding Society
# and reshape to the long format. Only keep the variables for pidp, sex, age, region (gor_dv)
# and life satisfaction.

# create a vector with the file names and paths
files <- dir(
  # Select the folder where the files are stored.
  "UKDA-6614-tab/tab/ukhls",
  # Tell R which pattern you want present in the files it will display.
  pattern = "indresp",
  # And finally want R to show us the entire file path, rather than just
  # the names of the individual files.
  full.names = TRUE)

files

# create a vector of variable names
vars <- c("sex_dv", "age_dv", "gor_dv", "sclfsato")
vars


for (i in 1:13) {
  # Create a vector of the variables with the correct prefix.
  varsToSelect <- paste(letters[i], vars, sep = "_")
  # Add pidp to this vector (no prefix for pidp)
  varsToSelect <- c("pidp", varsToSelect)
  # Now read the data.
  data <- vroom(files[i], col_select = varsToSelect)
  if (i == 1) {
    all13 <- data
  }
  else {
    all13 <- full_join(all13, data, by = "pidp")
  }
}

all13

all13Long <- all13 |>
  pivot_longer(cols = a_sex_dv:k_sclfsato, names_to = "vars", values_to = "values") |>
  separate(vars, sep = "_", into = c("wave", "variable"), extra = "merge") |>
  pivot_wider(names_from = variable, values_from = values)

all13Long

# Calculate the number of missed waves for each individual

all13Long |>
  group_by(pidp) |>
  summarise(
    nMissed = sum(is.na(sex_dv))
  ) |>
  mutate(nParticipated = 13 - nMissed) |>
  count(nParticipated)

# For week 4 please read ch. 1 from R for Data Science (2nd ed): https://r4ds.hadley.nz/data-visualize

