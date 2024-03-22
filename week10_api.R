# Working with the API
# AB
# 19 March 2024
# SSI2007/3003: week 10

# List of public APIs: https://github.com/public-api-lists/public-api-lists?tab=readme-ov-file

# The Guardian API: https://open-platform.theguardian.com

# The guardianapi package: https://cran.r-project.org/web/packages/guardianapi/

# Vignette: https://cran.r-project.org/web/packages/guardianapi/vignettes/introduction.html

library(tidyverse)
library(guardianapi)

# Enter the API key
# 
gu_api_key()

badenoch_search <- gu_content(query = "Kemi Badenoch")

str(badenoch_search)
class(badenoch_search)

class(badenoch_search$tags)

badenoch_search_long <- badenoch_search |>
  unnest_longer(tags)

badenoch_search_long |>
  filter(id == "politics/2024/jan/29/kemi-badenoch-member-evil-plotters-tory-whatsapp-group")

# all articles by Pippa Crerar
# https://www.theguardian.com/profile/pippacrerar

pippa_crerar <- gu_items("profile/pippacrerar")

# Film critic Peter Bradshaw

bradshaw_search <- gu_items("profile/peterbradshaw", from_date = "2024-01-01")

# Extract the star rating

bradshaw_search |>
  count(star_rating)

##################################

# Reed.co.uk

# see https://www.youtube.com/watch?v=AhZ42vSmDmE

# Documentation
# https://www.reed.co.uk/developers/jobseeker

library(httr)
library(jsonlite)



# 
# https://www.reed.co.uk/api/{versionnumber}/search?keywords={keywords}
# &locationName={locationName}&employerId={employerId}
# &distanceFromLocation={distance in miles}

# https://www.reed.co.uk/api/1.0/search?keywords=data&locationName=Exeter

# JSON file

jobsearch <- httr::GET("https://www.reed.co.uk/api/1.0/search?keywords=data&locationName=Exeter?details=true",
                 httr::authenticate(
                      # user = Sys.getenv("REED_API_KEY"),
                      user = "ADD YOUR API KEY HERE",
                      password = "",
                      type = "basic")
                 )

str(jobsearch$content)

jobsearchcontent <- httr::content(jobsearch, as = "text")

jobsearch_json <- jsonlite::fromJSON(jobsearchcontent)
jobsearch_json

results <- as_tibble(jobsearch_json$results)

results

results |>
  arrange(-maximumSalary)

##################################


# Guardian project
# Compare the frequency of mentioning the search terms "Russia", "China" and "India"
# over time from 2022

china_search <- gu_content(query = "China", from_date = "2022-01-01")
india_search <- gu_content(query = "India", from_date = "2022-01-01")
russia_search <- gu_content(query = "Russia", from_date = "2022-01-01")

# Save the data image
# save.image("data/countries_week10.RData")

china_df <- china_search |>
  select(id, web_publication_date) |>
  mutate(country = "China")

india_df <- india_search |>
  select(id, web_publication_date) |>
  mutate(country = "India")

russia_df <- russia_search |>
  select(id, web_publication_date) |>
  mutate(country = "Russia")

three_countries_df <- china_df |>
  bind_rows(india_df) |>
  bind_rows(russia_df)

library(lubridate)

three_countries_df <- three_countries_df |>
  mutate(month_year = format(web_publication_date, "%B-%Y"))

three_countries_summary_df <- three_countries_df |>
  mutate(month_year = my(month_year)) |>
  count(month_year, country)

ggplot(three_countries_summary_df, aes(x = month_year, y = n, colour = country)) +
  geom_line(size=1) + # Increase line thickness for better visibility
  scale_x_date(date_labels="%b %Y", date_breaks="1 month") + # Format X-axis labels to show abbreviated month and full year, adjust breaks as needed
  theme_minimal() + # Use a minimal theme for a cleaner look
  labs(
    title = "Monthly Summary by Country",
    x = "Month and Year",
    y = "Value",
    colour = "Country"
  ) +
  theme(
    panel.grid.major.x = element_blank(), # Remove major gridlines on the X-axis for a cleaner look
    panel.grid.minor.x = element_blank(), # Remove minor gridlines on the X-axis
    legend.position = "bottom", # Move the legend to the bottom
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels and adjust horizontal justification
    text = element_text(size = 16) 
  )
