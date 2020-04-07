tdf_winners <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-07/tdf_winners.csv')

# Or read in with tidytuesdayR package (https://github.com/thebioengineer/tidytuesdayR)
# PLEASE NOTE TO USE 2020 DATA YOU NEED TO USE tidytuesdayR version ? from GitHub

# Either ISO-8601 date or year/week works!

library(tidyverse)
library(tdf) # install at: https://github.com/alastairrushworth/tdf
devtools::install_github("alastairrushworth/tdf")


devtools::install_github("thebioengineer/tidytuesdayR")
tuesdata <- tidytuesdayR::tt_load('2020-04-07')
tuesdata <- tidytuesdayR::tt_load(2020, week = 15)
tdf_winners <- tuesdata$tdf_winners


####
#cleaning 
####

winners <- tdf::editions %>% 
  select(-stage_results)

all_years <- tdf::editions %>% 
  unnest_longer(stage_results) %>% 
  mutate(stage_results = map(stage_results, ~ mutate(.x, rank = as.character(rank)))) %>% 
  unnest_longer(stage_results) 

stage_all <- all_years %>% 
  select(stage_results) %>% 
  flatten_df()

combo_df <- bind_cols(all_years, stage_all) %>% 
  select(-stage_results)

stage_clean <- combo_df %>% 
  select(edition, start_date,stage_results_id:last_col()) %>% 
  mutate(year = lubridate::year(start_date)) %>% 
  rename(age = age...25) %>% 
  select(edition, year, everything(), -start_date)

winners %>% 
  write_csv(here::here("2020", "2020-04-07", "tdf_winners.csv"))

stage_clean %>% 
  write_csv(here::here("2020", "2020-04-07", "stage_data.csv"))