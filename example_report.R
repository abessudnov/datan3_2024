# Example data linkage and recoding for the report
# 27 March 2023

library(tidyverse)
library(vroom)

# Read 13 waves of the data

# (This code was provided in week 3)

# create a vector with the file names and paths
files <- dir(
  # Select the folder where the files are stored.
  "UKDA-6614-tab/tab/ukhls",
  # Tell R which pattern you want present in the files it will display.
  pattern = "indresp",
  # And finally want R to show us the entire file path, rather than just
  # the names of the individual files.
  full.names = TRUE)

vars <- c("sex_dv", "marstat_dv", "sclfsato")
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

# Reshape to the long format

all13Long <- all13 |>
  pivot_longer(cols = a_sex_dv:m_sclfsato, names_to = "vars", values_to = "values") |>
  separate(vars, sep = "_", into = c("wave", "variable"), extra = "merge") |>
  pivot_wider(names_from = variable, values_from = values)

all13Long

# We want to find all occurrences of 5 (divorced) or 4 (separated but legally married)
# when in the previous wave it was 2 (married)

# tabulate marital status

all13Long |>
  count(marstat_dv)

# Create a variable t_divorced so that it's 1 when marital status is 5 (Divorced) or 4 (Separated)
# and it was 2 (married) in the previous wave.

all13Long  <- all13Long |>
  group_by(pidp) |>
  mutate(t_divorced = if_else(
    ((marstat_dv == 5 | marstat_dv == 4) & lag(marstat_dv) == 2), 1, NA_real_)
  )

# Create a data frame of those who divorced at some point during the study

all13Long_divorced <- all13Long |>
  group_by(pidp) |>
  mutate(divorced_during_study = sum(t_divorced, na.rm = TRUE)) |>
  ungroup() |>
  filter(divorced_during_study == 1)

# the data frame has 4706 rows so it contains the info about 4706 / 13 = 362 people

# Fill in the missing values for t_divorced

all13Long_divorced <- all13Long_divorced |>
  group_by(pidp) |>
  mutate(t_divorced_filled = seq_along(t_divorced) - which(t_divorced == 1)) |>
  ungroup()

# Now t_divorced_filled is the variable indicating time before/after divorce. The first wave when
# divorce is registered was coded as 0, the wave after as 1, the wave before as -1, etc.
# 
# Note that people's marital histories are complex and they can re-marry  or get back together after divorce, etc.
# You may want to take this into account when summarising life satisfaction.
# For example, before separation / divorce (t_divorced_filled < 0),
# you may wnat to look only at the rows when a person was married (marstat_dv == 2).
# After separation / divorce (t_divorced_filled >= 0), you may want to look only at the rows
# when a person was separated or divorced (marstat_dv == 4 | marstat_dv == 5).
# 






