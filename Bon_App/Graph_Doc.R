library(wesanderson)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(googleVis)
library(RColorBrewer)

og_bonapp_df <- read_csv("./Bon_App/full_bonapp_df.csv")
ingred_badata_df <- read_csv("./Bon_App/bonapp_df.csv")
###### 
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
#####


######## RATINGS through the Years, using the second plot ########
ggplot(og_bonapp_df, aes(x=Published, y=Rating)) + geom_point(aes(color=Rating))
ggplot(og_bonapp_df, aes(x=Published, y=Rating)) + geom_violin(aes(fill=format(og_bonapp_df$Published, "%Y"))) 

# Recipe Count Through the Years, using the second plot
ggplot(og_bonapp_df, aes(x=Published)) + geom_bar(aes(fill=(format(og_bonapp_df$Published, "%Y"))))
og_bonapp_df %>% filter(!is.na(Published)) %>% ggplot(aes(x=(format(Published, "%m/%B")))) + 
  geom_bar(na.rm = TRUE, position = "dodge", aes(fill=(format(Published, "%Y")))) +
  ggtitle("Number of Recipes Published From 2015-2020") + theme(legend.title=element_blank()) +
  xlab("Months") +ylab("Recipe Count")

######### REVIEWS Count Through the Years, both used#########
ggplot(og_bonapp_df, aes(x=Published, y=Reviews)) + geom_point(aes(color=Reviews))
ggplot(og_bonapp_df, aes(x=Published, y=Reviews)) + geom_col(aes(fill=format(og_bonapp_df$Published, "%Y")))


####### GENERAL INFO, 1 is incorrect hist, 2 is all and confusing, 3 is clean totals, 4 is fantastic year by year #######
ggplot(og_bonapp_df, aes(x=Published)) + geom_histogram(bins= 65, binwidth = 35, aes(fill=format(og_bonapp_df$Published, "%Y"))) +
  theme(legend.title=element_blank())

og_bonapp_df %>% filter(!is.na(Published)) %>% ggplot(aes(x=(format(Published, "%m/%B")))) + 
  geom_bar(na.rm = TRUE, position = "dodge", aes(fill=(format(Published, "%Y")))) +
  ggtitle("Number of Recipes Published From 2015-2020") + theme(legend.title=element_blank()) +
  xlab("Months") +ylab("Recipe Count")

og_bonapp_df  %>% filter(!is.na(Published)) %>% group_by(., year = format(Published, "%Y")) %>% 
  summarise(., recipe_count = n_distinct(DishTitle)) %>% ggplot(aes(x=year, y = as.numeric(recipe_count))) + 
  geom_col(aes(fill=year)) +
  ggtitle("Total Recipes by Year, 2015-2020") + theme(legend.title=element_blank()) +
  xlab("Years") + ylab("Recipe Count")

ggplot(og_bonapp_df, aes(x=Published)) + geom_bar(aes(fill=format(og_bonapp_df$Published, "%Y"))) +
  theme(legend.title=element_blank())

table_totals_per_year <- og_bonapp_df  %>% filter(!is.na(Published)) %>% group_by(., year = format(Published, "%Y")) %>% 
  summarise(., recipe_count = n_distinct(DishTitle))
as.data.frame(table_totals_per_year)

########## COVID-19 Recipe Count in 2020 ###########

df_2020_totals <- og_bonapp_df %>% filter(format(og_bonapp_df$Published, "%Y") == 2020) %>% 
  group_by(Published, ) %>% tally()

ggplot(df_2020_totals, aes(x=Published, y=n)) + geom_bar(stat = "identity", aes(fill=n)) + 
  ggtitle("Monthly Recipe Output in 2020") + xlab("Months") + ylab("Recipe Count") +
  scale_fill_gradientn(colors = wes_palette("Darjeeling1", 3, type = "continuous"))

# ggplot(df_2020, aes(x=Published, y=Reviews)) + geom_point(aes(color=Reviews, size = 2)) + 
#   ggtitle("Number of Reviews per Recipe Through 2020") +
#   xlab("Months") +ylab("Review Count per Recipe Instance") +
#   scale_color_gradientn(colors = wes_palette("GrandBudapest2", 4, type = "discrete"))

    ## Monthly Review Count 2020

df_2020_by_Pub <-df_2020 %>% group_by(., Published) %>% summarise(., review_count = sum(Reviews), recipe_count = n_distinct(DishTitle))
ggplot(df_2020_by_Pub, aes(x=Published, y=review_count)) + 
  geom_col(aes(fill=(review_count))) + 
  scale_fill_gradientn(colors = wes_palette("Zissou1", 3, type = "continuous"))

    ## Density of Reviews Written Months of 2020, not good
ggplot(df_2020, aes(x=format(df_2020$Published, "%m"), y=Reviews)) + 
  geom_violin(aes(fill=format(df_2020$Published, "%B"))) +
  ggtitle("Spread of Review Density per Recipe in 2020") + 
  theme(legend.title=element_blank()) +
  xlab("Months") + ylab("Range of Reviews per Recipe") + 
  scale_fill_discrete(breaks=c("January","February","March", "April", "May"), wes_palette("GrandBudapest1"))

## Density of Reviews Written 2015-2020, not good
ggplot(og_bonapp_df, aes(x=format(og_bonapp_df$Published, "%Y"), y=Reviews)) +
    geom_boxplot(aes(fill=format(og_bonapp_df$Published, "%Y"))) +
    ggtitle("Spread of Review Density per Recipe") +
    theme(legend.title=element_blank()) +
    xlab("Years") + ylab("Range of Reviews per Recipe") +
    scale_fill_discrete(wes_palette("GrandBudapest1"))




####### INGREDIENTS ########

popular_ingred_table <- ingred_badata_df %>% group_by(., ingred) %>% 
  summarise(., popularity_count = n_distinct(dishtitle)) %>%
  arrange(., desc(popularity_count))

popular_ingred_table[1:10, ][[1]]

ingred_badata_df %>% group_by(., published, ingred) %>% 
  summarise(., review_count = n_distinct(dishtitle)) %>% 
  ggplot(aes(x = (format(published, "%m/%B")), y = review_count)) + 
  geom_smooth() + coord_polar()

ingred_badata_df %>% group_by(., published, ingred) %>% 
  summarise(., review_count = n_distinct(dishtitle)) %>% 
  filter(ingred == "pickles") %>% 
  ggplot(aes(x = published, y = review_count)) + 
  geom_area() 

##############

obs = nrow(df_2020) 
for (i in 1:obs) {        
  if (is.na(df_2020$Reviews[i])) { 
    df_2020$Reviews[i] = 0
  } else{
    df_2020$Reviews[i] = length(strsplit(df_2020$Reviews[i], split=" ,")[[1]])
}}

df_2020$DishTitle

df_2020_by_Pub <-df_2020 %>% group_by(., Published) %>% summarise(., review_count = sum(Reviews), recipe_count = n_distinct(DishTitle))



df_2016 <- og_bonapp_df %>% filter(., format(og_bonapp_df$Published, "%Y") == 2016)
df_2016 %>% group_by(., month = format(Published, "%m")) %>% summarise(., recipe_count = n_distinct(DishTitle))
og_bonapp_df %>% summarise(., recipe_count = n_distinct(DishTitle))

df_2016 %>% group_by(., month = format(Published, "%m")) %>% 
  summarise(., recipe_count = n_distinct(DishTitle)) %>% 
  ggplot(aes(x=month, y=as.numeric(recipe_count))) + geom_col() 




as.data.frame(table_totals_per_year)

table_totals_per_year <- og_bonapp_df  %>% filter(!is.na(Published)) %>% group_by(., year = format(Published, "%Y")) %>% 
  summarise(., recipe_count = n_distinct(DishTitle)) #%>% ggplot(aes(x=month, y = as.numeric(recipe_count))) + 
  geom_col(position = "dodge", aes(fill=year)) 

+
  ggtitle("Number of Recipes Published From 2015-2020") + theme(legend.title=element_blank()) +
  xlab("Months") +ylab("Recipe Count")

