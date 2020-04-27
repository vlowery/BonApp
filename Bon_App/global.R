library(shiny)
library(shinydashboard)
library(DT)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(googleVis)
library(wesanderson)
library(bubbles)

og_bonapp_df <- read_csv("./data/full_bonapp_df.csv")
ingred_badata_df <- read_csv("./data/bonapp_df.csv")

as.Date(og_bonapp_df$Published)
as.Date(ingred_badata_df$published)

#####
df_2020 <- og_bonapp_df %>% filter(., format(og_bonapp_df$Published, "%Y") == 2020)
######
obs = nrow(og_bonapp_df) 
for (i in 1:obs) {        
  if (is.na(og_bonapp_df$Reviews[i])) { 
    og_bonapp_df$Reviews[i] = 0
  } else{
    og_bonapp_df$Reviews[i] = length(strsplit(og_bonapp_df$Reviews[i], split=" ,")[[1]])
  }}

og_bonapp_df$Reviews <- as.numeric(og_bonapp_df$Reviews)

year_review_totals <- og_bonapp_df %>% filter(!is.na(Reviews)) %>% group_by(Year = format(og_bonapp_df$Published, "%Y")) %>% summarise("Review Count" = as.integer(sum(Reviews)))
year_review_totals <- year_review_totals[1:6, ]
year_review_totals
  
######
obs = nrow(df_2020) 
for (i in 1:obs) {        
  if (is.na(df_2020$Reviews[i])) { 
    df_2020$Reviews[i] = 0
  } else{
    df_2020$Reviews[i] = length(strsplit(df_2020$Reviews[i], split=" ,")[[1]])
  }}

df_2020$Reviews <- as.numeric(df_2020$Reviews)
#####
df_2020_by_Pub <-df_2020 %>% group_by(., Published) %>% summarise(., review_count = sum(Reviews), recipe_count = n_distinct(DishTitle))

df_2020_totals <- og_bonapp_df %>% filter(format(og_bonapp_df$Published, "%Y") == 2020) %>% 
  group_by(Published, ) %>% tally()

#####
popular_ingred_table <- ingred_badata_df %>% group_by(., ingred) %>% 
  summarise(., frequency_count = n_distinct(dishtitle)) %>%
  arrange(., desc(frequency_count))
