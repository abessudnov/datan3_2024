# Working with the GPT API
# AB
# 26 March 2024
# SSI2007/3003: week 11

# library(gptstudio)

library(tidyverse)
library(vroom)
library(rgpt3)
# see https://github.com/ben-aaron188/rgpt3
# devtools::install_github("ben-aaron188/rgpt3")


rgpt_authenticate("access_key.txt")
rgpt_test_completion()


# A single request

example_1 <- rgpt_single(prompt_role = 'user',
                        prompt_content = 'Explain how to work with GPT API in R.',
                        temperature = 0.5,
                        max_tokens = 100,
                        model = 'gpt-3.5-turbo')

example_1


single_name <- rgpt_single(prompt_role = 'user',
                        prompt_content = 'You will be provided with a personal name,
                        and your task is to respond with the most likely country of 
                        origin for this name in ISO 3166-1 alpha-2 format:
                        Alexey Bessudnov',
                        temperature = 0.5,
                        max_tokens = 50,
                        model = 'gpt-3.5-turbo')

single_name

str(single_name)
single_name[[1]]$gpt_content

# Now let's write a function that can be used with any name

name_origin <- function(name) {
  single_name <- rgpt_single(prompt_role = 'user',
                             prompt_content = paste('You will be provided with a personal name,
                        and your task is to respond with the most likely country of 
                        origin for this name in ISO 3166-1 alpha-2 format:',
                        name),
                             temperature = 0.5,
                             max_tokens = 50,
                             model = 'gpt-3.5-turbo')
  return(single_name[[1]]$gpt_content)
}

name_origin("John Smith")

# Apply this to multiple names

beatles_names <- c("John Lennon", "Paul McCartney", "George Harrison", "Ringo Starr")

map(beatles_names, name_origin)


# student_names <- PROVIDE A VECTOR WITH STUDENT NAMES HERE

# map(student_names, name_origin)

##################################################################

# Load the file with the Guardian articles from previous class

# load("data/countries_week10.RData")

classify_example <- rgpt_single(prompt_role = 'user',
            prompt_content = 'You will be provided with a newspaper article title.
            Your task is to classify the tone of the title into one of the three categories:
            positive, negative or neutral.
            Authors ‘excluded from Hugo awards over China concerns’',
            temperature = 0.5,
            max_tokens = 50,
            model = 'gpt-3.5-turbo')

classify_example
classify_example[[1]]$gpt_content

classify_title <- function(title) {
  article <- rgpt_single(prompt_role = 'user',
                             prompt_content = paste('You will be provided with a newspaper article title.
            Your task is to classify the tone of the title into one of the three categories:
            positive, negative or neutral.', title),
                             temperature = 0.5,
                             max_tokens = 50,
                             model = 'gpt-3.5-turbo')
  return(article[[1]]$gpt_content)
}

classify_title("Authors ‘excluded from Hugo awards over China concerns’")

# Example from previous week: sentiment analysis of the Guardian newspaper article
# titles for China, India and Russia.
# 
# china_df <- china_search |>
#   select(web_title) |>
#   mutate(country = "China") |>
#   slice(1:10)
# 
# india_df <- india_search |>
#   select(web_title) |>
#   mutate(country = "India") |>
#   slice(1:10)
# 
# russia_df <- russia_search |>
#   select(web_title) |>
#   mutate(country = "Russia") |>
#   slice(1:10)
# 
# newspaper_title_df <- china_df |>
#   bind_rows(india_df) |>
#   bind_rows(russia_df)
# 
# write_csv(newspaper_title_df, "data/newspaper_title_df.csv")

newspaper_title_df <- vroom("data/newspaper_title_df.csv")

china_titles <- newspaper_title_df |>
  filter(country == "China") |>
  pull(web_title)

india_titles <- newspaper_title_df |>
  filter(country == "India") |>
  pull(web_title)

russia_titles <- newspaper_title_df |>
  filter(country == "Russia") |>
  pull(web_title)


china_titles

china_output <- map(china_titles, classify_title)
india_output <- map(india_titles, classify_title)
russia_output <- map(russia_titles, classify_title)


china_df <- data.frame(titles = china_titles, sentiment = unlist(china_output)) |>
  mutate(country = "China")
india_df <- data.frame(titles = india_titles, sentiment = unlist(india_output)) |>
  mutate(country = "India")
russia_df <- data.frame(titles = russia_titles, sentiment = unlist(russia_output)) |>
  mutate(country = "Russia")

newspaper_title_df <- china_df |>
  bind_rows(india_df) |>
  bind_rows(russia_df)

newspaper_title_df |>
  count(sentiment) |>
  mutate(perc = n / sum(n) * 100)

newspaper_title_df |>
  group_by(country) |>
  count(sentiment) |>
  mutate(perc = n / sum(n) * 100)







