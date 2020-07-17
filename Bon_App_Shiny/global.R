library(shiny)
library(shinydashboard)
library(DT)
library(tidyverse)
library(ggthemes)
library(googleVis)
library(wesanderson)
library(bubbles)
library(RColorBrewer)
library(rex)

og_bonapp_df <- read_csv("./data/full_bonapp_df.csv")
ingred_badata_df <- read_csv("./data/bonapp_df.csv")

as.Date(og_bonapp_df$published)
as.Date(ingred_badata_df$published)

#####
df_2020 <- og_bonapp_df %>% filter(., format(og_bonapp_df$published, "%Y") == 2020)
######
# obs = nrow(og_bonapp_df) 
# for (i in 1:obs) {        
#   if (is.na(og_bonapp_df$review_count[i])) { 
#     og_bonapp_df$review_count[i] = 0
#   } else{
#     og_bonapp_df$review_count[i] = length(strsplit(og_bonapp_df$Reviews[i], split=" ,")[[1]])
#   }}
# 
# og_bonapp_df$Reviews <- as.numeric(og_bonapp_df$Reviews)

year_review_totals <- og_bonapp_df %>% filter(!is.na(review_count)) %>% group_by(year = format(og_bonapp_df$published, "%Y")) %>% summarise("Review Count" = as.integer(sum(review_count)))
year_review_totals <- year_review_totals[1:6, ]
year_review_totals
  
######
# obs = nrow(df_2020) 
# for (i in 1:obs) {        
#   if (is.na(df_2020$Reviews[i])) { 
#     df_2020$Reviews[i] = 0
#   } else{
#     df_2020$Reviews[i] = length(strsplit(df_2020$Reviews[i], split=" ,")[[1]])
#   }}
# 
# df_2020$Reviews <- as.numeric(df_2020$Reviews)
#####
df_2020_by_Pub <- df_2020 %>% group_by(., published) %>% summarise(., review_count = sum(review_count), recipe_count = n_distinct(dishtitle))

df_2020_totals <- og_bonapp_df %>% filter(format(og_bonapp_df$published, "%Y") == 2020) %>% 
  group_by(published, ) %>% tally()

#####
popular_ingred_table <- ingred_badata_df %>% group_by(., ingred) %>% 
  summarise(., frequency_count = n_distinct(dishtitle)) %>%
  arrange(., desc(frequency_count))

######
year_recipe_totals <- og_bonapp_df %>% group_by(., year = format(published, "%Y")) %>% tally() %>% head(6)

####
top_rated_dish <- og_bonapp_df %>% arrange(desc(ratings_count)) %>% head(3)

#####
top_reviewed_dishes <- og_bonapp_df %>% arrange(desc(review_count)) %>% head(3)

