library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(googleVis)

og_bonapp_df <- read_csv("full_bonapp_df.csv")
ingred_badata_df <- read_csv("bonapp_df.csv")

as.Date(og_bonapp_df$Published)
as.Date(ingred_badata_df$published)
