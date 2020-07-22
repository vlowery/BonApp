

function(input, output, session){
    
    # Averages
    
    output$monthly_publishing <- renderPlot(
        og_bonapp_df %>% select(dishtitle, published) %>% 
            group_by(published) %>% summarise(monthly_totals = n_distinct(dishtitle)) %>% na.omit() %>% 
            ggplot() + geom_col(aes(x = published, y = monthly_totals, fill = as.character(year(published)))) +
            theme_minimal() + theme(legend.position="none") + ggtitle("Monthly New Recipe Totals") + 
            xlab("Publishing Timeline, Months") + ylab("Recipe Count") + 
            scale_fill_manual(aesthetics = "fill", values = rep_len(c("#376c8b", "#aabad6"), 7))
    )
    
    output$yearly_publishing <- renderPlot(
        og_bonapp_df %>% select(dishtitle, published) %>% group_by(Year = year(published)) %>%
            summarise(yearly_totals = n_distinct(dishtitle)) %>% na.omit() %>% 
            ggplot(aes(x = Year, y = yearly_totals)) + geom_line(size =2, color = "darkblue") + 
            geom_point(color = "darkblue", size = 5) + geom_point(color = "pink", size = 4) +
            theme_minimal() + theme(legend.position="none") + ggtitle("Yearly New Recipe Totals") + 
            xlab("Publishing Timeline, Years") + ylab("Recipe Count")
    )
    
    output$totals_table <- renderTable(
        og_bonapp_df %>% group_by(Year = factor(year(published))) %>% 
            summarise("Recipe Count" = n_distinct(dishtitle)) %>% na.omit()
    )
    
    output$month_totals_dodge <- renderPlot(
        og_bonapp_df %>% select(published, dishtitle) %>% 
            group_by(Year = as.character(year(published)), Month = month(published, label = TRUE)) %>% 
            summarise(totals = n_distinct(dishtitle)) %>% group_by(Month) %>% 
            mutate(mean_totals = mean(totals)) %>% na.omit() %>% ggplot() + 
            geom_col(aes(x = Month, y = totals, fill = Year), position = "dodge") +
            geom_point(aes(x = Month, y = mean_totals), shape = 23, size = 3, fill = "red", color = "black") + 
            ggtitle("Number of Recipes Published From 2014-2020") + #theme(legend.title=element_blank()) +
            xlab("Months") + ylab("Recipe Count") + theme_dark() + scale_fill_brewer(palette = "YlGnBu")
    )
    
    output$interactive_year_totals <- renderPlot(
        og_bonapp_df %>% filter(year(published) %in% c(input$checkGroup1)) %>% 
            group_by(Year = as.character(year(published)), Month = month(published, label = TRUE)) %>% 
            summarise(recipe_count = n_distinct(dishtitle)) %>% 
            ggplot(aes(x=Month, y=recipe_count)) + geom_col(position = "dodge", aes(fill=Year)) +
            theme_bw() + ylab("Total Recipes") + xlab("Months") + labs(fill = "Year") + 
            theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
            scale_fill_manual(breaks = c("2014", "2015", "2016", "2017", "2018", "2019", "2020"), 
                              aesthetics = "fill", values = brewer.pal(7, "Set3"))
    )
    
    
    # Ratings

    output$ratings_first <- renderInfoBox(
        infoBox(title = "Most Rated Dish", value = top_rated_dish$dishtitle[1], color = "green",
                subtitle = paste(scales::comma(top_rated_dish$ratings_count[1]), "Total Ratings"), href = top_rated_dish$url[1], fill = TRUE)
    )
    
    output$ratings_second <- renderInfoBox(
        infoBox(title = "Second Most Rated", value = top_rated_dish$dishtitle[2], color = "green", 
                subtitle = paste(scales::comma(top_rated_dish$ratings_count[2]), "Total Ratings"), href = top_rated_dish$url[2])
    )
    
    output$ratings_third <- renderInfoBox(
        infoBox(title = "Third Most Rated", value = top_rated_dish$dishtitle[3], color = "green", 
                subtitle = paste(scales::comma(top_rated_dish$ratings_count[3]), "Total Ratings"), href = top_rated_dish$url[3])
    )
    
    output$timelapse_ratings <- renderPlot(
        ggplot(og_bonapp_df, aes(x=published, y=rating)) + geom_point(size = 3, alpha = .6, aes(color=rating)) +
            scale_color_gradientn(colors = wes_palette("Darjeeling1", 3, type = "continuous")) + theme_bw() + 
            theme(legend.position="none") + xlab("Published Date (Months)") + ylab("Rating") + 
            ggtitle("Distribution of Ratings Given Since 2014") + scale_x_date(date_breaks = "1 year", date_labels = "%Y")
    )
    
    output$bar_ratings <- renderPlot(
        og_bonapp_df %>% group_by(Year = year(published)) %>% summarise(total_ratings = sum(ratings_count)) %>% 
        ggplot(aes(x = Year, y = total_ratings)) + 
            geom_col(alpha = .8, size = 2, fill = "darkblue") + 
            geom_text(aes(label=ifelse(Year != 2016 & Year != 2020, scales::comma(total_ratings), "")), vjust = 1.5, color = "pink", size = 6) + 
            geom_text(aes(label=ifelse(Year == 2016 | Year == 2020, scales::comma(total_ratings), "")), vjust = -.5, color = "#ff8d8d", size = 6) + 
            theme(legend.position="none") + xlab("Published Date (Years)") + ylab("Total Ratings Received") + 
            ggtitle("Frequency of Ratings Given Since 2014") + theme_minimal() #+ 
            # scale_x_continuous(breaks=seq(2014, 2020))
    )
    
    output$density_ratings <- renderPlot(
        ggplot(og_bonapp_df, aes(x = rating, group = year(published))) + 
            geom_density(size = 2, aes(color = as.character(year(published)))) + theme_bw() + 
            scale_color_manual(values = brewer.pal(7, "Spectral")) + labs(color = "Year") + 
            ylab("Popularity of Rating Score") + xlab("Rating") + ggtitle("Density of Ratings Given Since 2014") 
    )
    
    
    ## Reviews
    
    output$reviews_first <- renderInfoBox(
        infoBox(title = "Most Reviewed Dish", value = top_reviewed_dish$dishtitle[1], color = "green", 
                subtitle = paste(top_reviewed_dish$review_count[1], "Total Reviews"), href = top_reviewed_dish$url[1], fill = TRUE)
        )
    
    output$reviews_second <- renderInfoBox(
        infoBox(title = "Second Most Reviewed", value = top_reviewed_dish$dishtitle[2], color = "green", 
                subtitle = paste(top_reviewed_dish$review_count[2], "Total Reviews"), href = top_reviewed_dish$url[2])
        )
    
    output$reviews_third <- renderInfoBox(
        infoBox(title = "Third Most Reviewed", value = top_reviewed_dish$dishtitle[3], color = "green", 
                subtitle = paste(top_reviewed_dish$review_count[3], "Total Reviews"), href = top_reviewed_dish$url[3])
        )
    
    output$timelapse_reviews <- renderPlot(
        ggplot(og_bonapp_df, aes(x=published, y=review_count)) + geom_jitter(aes(color=review_count)) + 
            xlab("Year, Month Published") + ylab("Total Reviews Written") + ggtitle("Total Reviews Written per Recipe") +
            labs(color = "Count") + ylim(1, 150) + scale_color_gradient(low = "yellow", high = "blue", trans = "log") + 
            theme(legend.position="none")
    )
    output$reviews_table <- renderTable(
        og_bonapp_df %>% group_by(Year = as.character(year(published))) %>% 
            summarise("Review Count" = scales::comma(sum(review_count))) %>% 
            filter(!is.na(Year))
    )

    output$years_best <- renderDataTable(
        og_bonapp_df %>% group_by(Year = year(published)) %>% arrange(desc(review_count)) %>% 
            top_n(n = 10, wt = review_count) %>% arrange(desc(rating)) %>% top_n(n = 1, wt = rating) %>% 
            mutate("Dish Title" = paste0("<a href='", url, "'>", dishtitle, "</a>"), rating = round(rating, 2)) %>% 
            select(Year, "Dish Title", Published = published, Rating = rating, "Ratings Count" = ratings_count, 
                          "Reviews Count" = review_count, -url) %>% arrange(Year) %>% 
            datatable(escape = 1, rownames = FALSE, options = list(dom = 't'))
    )
    
    # Ingredients
    
    output$ingred_bubbles <- renderBubbles({
        
        bubble_df <- ingred_badata_df %>% group_by(ingred) %>% 
            summarise(frequency_count = n_distinct(dishtitle)) %>%
            arrange(desc(frequency_count)) %>% head(50)
        
        bubbles(value = bubble_df$frequency_count, label = bubble_df$ingred, 
                key = bubble_df$ingred, tooltip = bubble_df$ingred, 
                color =  as.vector(wes_palette(50, name = "Moonrise3", type = "continuous")))
    })
    
    output$pop_ingred_table <- renderDataTable(
        ingred_badata_df %>% group_by(Ingredient = ingred) %>% 
            summarise(frequency_count = n_distinct(dishtitle)) %>%
            arrange(desc(frequency_count)) %>% transmute(Ingredient, "Frequency Count" = scales::comma(frequency_count))
    )
    
    output$ingred_interactive <- renderPlot( 
        ingred_badata_df %>% group_by(Year = year(published)) %>% 
            mutate(total_recipes = n_distinct(dishtitle)) %>% filter(grepl(input$ingred_choice, ingred)) %>% 
            mutate(Ratio = n()/total_recipes) %>% top_n(wt = dishtitle, n = 1) %>% 
        ggplot(aes(x = Year, y = Ratio, fill = input$ingred_choice)) + geom_col() + 
            ylab("Percentage of Use") + xlab("Yearly Timeline") + theme(legend.position="none") + 
            scale_y_continuous(labels = scales::percent_format(accuracy = .1)) + 
            scale_fill_manual(aesthetics = "fill", 
                              values = ifelse(input$ingred_choice == "tomatoes", "#c8393c", 
                                              ifelse(input$ingred_choice == "potatoes$", "#482d26", 
                                                     ifelse(input$ingred_choice == "kale", "#225540", 
                                                            ifelse(input$ingred_choice == "oranges", "#f15404", 
                                            ifelse(input$ingred_choice == "pears", "#92bda8", 
                                                ifelse(input$ingred_choice == "lemon$", "#fbe487", 
                                                    ifelse(input$ingred_choice == "lime$", "#a0cb83", 
                                                        ifelse(input$ingred_choice == "ricotta", "#ffd2da", 
                                                            ifelse(input$ingred_choice == "pickles$", "#6eaa0f", 
                                                                ifelse(input$ingred_choice == "pecorino", "#b0c7d5", 
                                            ifelse(input$ingred_choice == "cumin", "#bf834e", 
                                                ifelse(input$ingred_choice == "sage", "#75a7ab", 
                                                    ifelse(input$ingred_choice == "cinnamon", "#3c2d37", 
                                                        ifelse(input$ingred_choice == "beans", "#552237", 
                                                            ifelse(input$ingred_choice == "maple syrup", "#f19431", 
                                            ifelse(input$ingred_choice == "red wine", "#7a314f", 
                                                ifelse(input$ingred_choice == "cheddar", "#f0a72f", 
                                                    ifelse(input$ingred_choice == "lettuce", "#4e822f", "teal")
                                                    ))))))))))))))))))
    )
    
    
    # COVID-19
    
    output$recipes_in_2020 <- renderPlot(
        og_bonapp_df %>% filter(year(published) == 2020) %>% group_by(published) %>% 
            summarise(recipe_count = n_distinct(dishtitle)) %>% 
        ggplot(aes(x=published, y=recipe_count)) + geom_col(fill="#376c8b") + 
            ggtitle("Monthly Total Recipes Published in 2020") + xlab("Months") + ylab("Recipe Count") + 
            theme(legend.title=element_blank())
    )
   
    output$review_count_2020 <- renderPlot(
        og_bonapp_df %>% filter(year(published) == 2020) %>% group_by(published) %>% 
            summarise(review_count = sum(review_count)) %>% 
        ggplot(aes(x=published, y=review_count)) + 
            geom_col(fill="#aabad6") + theme(legend.title=element_blank()) + 
            ggtitle("Monthly Total Reviews Written in 2020") + xlab("Months") + ylab("Review Count")
    )
    
    output$avg_review_count <- renderPlot(
        og_bonapp_df %>% filter(year(published) %in% c(as.integer(unlist(strsplit(input$all_years, ", "))))) %>%
            group_by(Year = as.character(year(published)), published) %>%
            summarise(avg_reviews = sum(review_count) / n_distinct(dishtitle)) %>%
            ggplot(aes(x = month(published, label = TRUE), y = avg_reviews)) +
            geom_line(size = 1.3, aes(group = factor(Year), color = factor(Year))) +
            theme(legend.title=element_blank()) + 
            ggtitle("Average Reviews Recieved, by Year") + xlab("Months") + ylab("Average Review Count") + 
            scale_color_manual(breaks = c("2014", "2015", "2016", "2017", "2018", "2019", "2020"), 
                              values = rev(brewer.pal(7, "Set3")))
    )
    
    output$monthly_review_count <- renderPlot(
        ggplot(og_bonapp_df, aes(x=published, y=review_count)) + geom_col(aes(fill=as.character(year(published)))) +
            theme(legend.title=element_blank()) + xlab("Months of Publishing") + ylab("Total Reviews Written per Month") +
            ggtitle("Total Reviews Written by Month") + 
            scale_fill_manual(breaks = c("2014", "2015", "2016", "2017", "2018", "2019", "2020"), 
                               values = rev(brewer.pal(7, "Set3"))) + theme(legend.position="none")
    )
    
}

