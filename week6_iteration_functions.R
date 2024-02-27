# Iteration. Functions.
# AB
# 26 Feb 2024
# SSI2007/3003: week 6

# R for Data Science, ch.25 (Functions): https://r4ds.hadley.nz/functions
# R for Data Science, ch. 26 (Iteration): https://r4ds.hadley.nz/iteration

# Loops

x <- 1:5
x * 2

# a for() loop

y <- numeric()
for (i in x) {
  y[i] <- i * 2
}
y

for (i in 1:10) {
  print(i^2)
}

for (z in c("James", "Katharine", "Maria")) {
  print(z)
}

# while() loops

x <- 0
while (x < 5) {
  print(x)
  x <- x + 1
}

# conditional structure

# ifelse()
x <- 0
y <- ifelse(x == 0, "male", "female")
y

if (x == 0) {
  print("x equals 0")
} else {
  print("x is not equal 0")
}


# working example

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

# Functions

# 1. Write a function checking if a number is even.
# If it is even return “Even”. If it isn’t return “Odd”.
# If it’s 0 return “Zero”. (Use the modulus operator %%).

check_if_even <- function(x) {
  if (x == 0) {
    print("Zero")
  } else {
    if (x %% 2 == 0) {
      print("Even")
    } else {
      print("Odd")
    }
  }
}

check_if_even(4)

# 2. Write a function finding the largest element of 
# a numeric vector.

x <- c(1:5, 18)
x
max(x)

find_largest <- function(vec) {
  # Check if the vector is numeric
  if (!is.numeric(vec)) {
    stop("Input must be a numeric vector")
  }
  
  # Initialize the first element as the largest for comparison
  largest_element <- vec[1]
  
  # Iterate through the vector to find the largest element
  for (element in vec) {
    if (element > largest_element) {
      largest_element <- element
    }
  }
  
  # Return the largest element
  return(largest_element)
}

find_largest(x)
find_largest("Jason")

# Write a function that recodes the sex variable in the 
# UndSoc data from 1 and 2 to "male" and "female"

library(vroom)
m_indresp <- vroom("UKDA-6614-tab/tab/ukhls/m_indresp.tab")

m_indresp |>
  count(m_sex_dv)

recode_sex <- function(df, varname) {
  df |>
    mutate({{varname }} := case_when(
      {{ varname }} == 1 ~ "Male",
      {{ varname }}== 2 ~ "Female",
      TRUE ~ NA_character_
    ))
}

recode_sex(m_indresp) |>
  count(m_sex_dv)

# Write a function to create a variable _immigrant_ in
# the UndSoc data with the values 1 for "immigrant" and
# 0 for "not immigrant"

recode_immigrant <- function(df, varname) {
  df |>
    mutate(immigrant = case_when(
      {{ varname }} == 5 ~ 1,
      {{ varname }} %in% 1:4 ~ 0,
      TRUE ~ NA_real_
    ))
}


recode_immigrant(m_indresp, m_ukborn) |>
  count(immigrant)


