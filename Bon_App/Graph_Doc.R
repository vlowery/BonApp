# Ratings through the Years
ggplot(og_bonapp_df, aes(x=Published, y=Rating)) + geom_point(aes(color=Rating))

# Recipe Count Through the Years
ggplot(og_bonapp_df, aes(x=Published)) + geom_bar(aes(fill=(format(og_bonapp_df$Published, "%Y"))))

# Review Count Through the Years
obs = nrow(og_bonapp_df) 
for (i in 1:obs) {        
  if (is.na(og_bonapp_df$Reviews[i])) { 
    og_bonapp_df$Reviews[i] = 0
  } else{
    og_bonapp_df$Reviews[i] = length(strsplit(og_bonapp_df$Reviews[i], split=" ,")[[1]])
  }}

og_bonapp_df$Reviews <- as.numeric(og_bonapp_df$Reviews)

ggplot(og_bonapp_df, aes(x=Published, y=Reviews)) + geom_point(aes(color=Reviews))


# COVID-19 Review Count in 2020
obs = nrow(df_2020) 
for (i in 1:obs) {        
  if (is.na(df_2020$Reviews[i])) { 
    df_2020$Reviews[i] = 0
  } else{
    df_2020$Reviews[i] = length(strsplit(df_2020$Reviews[i], split=" ,")[[1]])
  }}

df_2020$Reviews <- as.numeric(df_2020$Reviews)

ggplot(df_2020, aes(x=Published, y=Reviews)) + geom_point(aes(color=Reviews))



# COVID-19 Recipe Count through 2020
df_2020 <- og_bonapp_df %>% filter(., format(og_bonapp_df$Published, "%Y") == 2020)
ggplot(df_2020, aes(x=Published)) + geom_bar(aes(fill=after_stat(count)))





obs = nrow(df_2020) 
for (i in 1:obs) {        
  if (is.na(df_2020$Reviews[i])) { 
    df_2020$Reviews[i] = 0
  } else{
    df_2020$Reviews[i] = length(strsplit(df_2020$Reviews[i], split=" ,")[[1]])
}}

df_2020$Reviews[11]
  

nrow(df_2020)

length(strsplit(df_2020$Reviews[14], split=" ,")[[1]])
