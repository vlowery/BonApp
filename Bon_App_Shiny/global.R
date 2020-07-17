library(shiny)
library(shinydashboard)
library(DT)
library(tidyverse)
library(lubridate)
library(ggthemes)
library(googleVis)
library(wesanderson)
library(bubbles)
library(RColorBrewer)
library(rex)

og_bonapp_df <- read.csv("data/full_bonapp_df.csv", stringsAsFactors = FALSE, row.names = 1)
ingred_badata_df <- read.csv("data/ingred_bonapp_df.csv", stringsAsFactors = FALSE, row.names = 1)

og_bonapp_df$published <- ymd(og_bonapp_df$published)

df_2020_totals <- og_bonapp_df %>% filter(year(published) == 2020) %>% 
  group_by(published) %>% tally()

year_recipe_totals <- og_bonapp_df %>% group_by(year = year(published)) %>% tally() %>% head(6)

top_rated_dish <- og_bonapp_df %>% arrange(desc(ratings_count)) %>% head(3)

top_reviewed_dish <- og_bonapp_df %>% arrange(desc(review_count)) %>% head(3)

