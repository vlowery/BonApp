

function(input, output, session){
    
    # Averages
    
    output$monthly_publishing <- renderPlot(
        og_bonapp_df %>% select(dishtitle, published) %>% 
            group_by(published) %>% summarise(monthly_totals = n_distinct(dishtitle)) %>% 
            ggplot() + geom_col(aes(x = published, y = monthly_totals, fill = as.character(year(published)))) +
            theme(legend.title=element_blank()) + theme(legend.position="none") + 
            xlab("Publishing Timeline, Months") + ylab("Recipe Count")
    )
    
    output$yearly_publishing <- renderPlot(
        og_bonapp_df %>% select(dishtitle, published) %>% group_by(year(published)) %>%
             na.omit() %>% summarise(yearly_totals = n_distinct(dishtitle)) %>% 
            ggplot() + geom_line(aes(x = year(published), y = yearly_totals)) + 
            theme(legend.title=element_blank()) + theme(legend.position="none") + 
            xlab("Publishing Timeline, Years") + ylab("Recipe Count")
    )
    
    output$plot2 <- renderPlot(
        og_bonapp_df %>% filter(!is.na(published)) %>% ggplot(aes(x=(format(published, "%m/%B")))) + 
            geom_bar(na.rm = TRUE, position = "dodge", aes(fill=(format(published, "%Y")))) +
            ggtitle("Number of Recipes Published From 2015-2020") + theme(legend.title=element_blank()) +
            xlab("Months") + ylab("Recipe Count") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
        
    )
    
    table_totals_per_year <- og_bonapp_df  %>% filter(!is.na(published)) %>% group_by(., Year = format(published, "%Y")) %>% 
        summarise(., "Recipe Count" = n_distinct(dishtitle))
    as.data.frame(table_totals_per_year)
    output$totals_table <- renderTable(table_totals_per_year)
    
    
    ### THIS IS THE INTERACTIVE GRAPH
    ## RETURN AND ADD BREAKS TO COLORS
    
    df_input <- reactive({
        og_bonapp_df %>% filter(., format(og_bonapp_df$published, "%Y") %in% c(input$checkGroup1))
    })
    
    output$plot9 <- renderPlot(
        df_input() %>% group_by(., year = format(published, "%Y"), month = format(published, "%m/%B")) %>% 
            summarise(., recipe_count = n_distinct(dishtitle)) %>% 
            ggplot(aes(x=month, y=as.numeric(recipe_count))) + geom_col(position = "dodge", aes(fill=year)) +
            ylab("Total Recipes") + xlab("Months") + labs(fill = "Year") + 
            theme(axis.text.x = element_text(angle = 45, hjust = 1))
        
    )
    
    
    # Ratings through the Years
    
    output$timelapse_ratings <- renderPlot(
        ## Add a mean bar for each year to see progression of sentiment
        ggplot(og_bonapp_df, aes(x=published, y=rating)) + geom_point(size = 3, alpha = .6, aes(color=rating)) +
            scale_color_gradientn(colors = wes_palette("Darjeeling1", 3, type = "continuous"))
    )

        output$ratings_first <- renderInfoBox(
        infoBox(title = "Most Rated Dish", value = top_rated_dish$dishtitle[1], 
                subtitle = paste(top_rated_dish$ratings_count[1], "Total Ratings"), href = top_rated_dish$url[1], fill = TRUE)
    )
    
    output$ratings_second <- renderInfoBox(
        infoBox(title = "Second Most Rated", value = top_rated_dish$dishtitle[2], 
                subtitle = paste(top_rated_dish$ratings_count[2], "Total Ratings"), href = top_rated_dish$url[2], fill = TRUE)
    )
    
    output$ratings_third <- renderInfoBox(
        infoBox(title = "Third Most Rated", value = top_rated_dish$dishtitle[3], 
                subtitle = paste(top_rated_dish$ratings_count[3], "Total Ratings"), href = top_rated_dish$url[3], fill = TRUE)
    )
    
    
    ## Review Count through the years
    
    output$reviews_first <- renderInfoBox(
        infoBox(title = "Most Reviewed Dish", value = top_reviewed_dish$dishtitle[1], 
                subtitle = paste(top_reviewed_dish$review_count[1], "Total Reviews"), href = top_reviewed_dish$url[1], fill = TRUE)
        )
    
    output$reviews_second <- renderInfoBox(
        infoBox(title = "Second Most Reviewed", value = top_reviewed_dish$dishtitle[2], 
                subtitle = paste(top_reviewed_dish$review_count[2], "Total Reviews"), href = top_reviewed_dish$url[2])
        )
    
    output$reviews_third <- renderInfoBox(
        infoBox(title = "Third Most Reviewed", value = top_reviewed_dish$dishtitle[3], 
                subtitle = paste(top_reviewed_dish$review_count[3], "Total Reviews"), href = top_reviewed_dish$url[3])
        )
    
    output$timelapse_reviews <- renderPlot(
        ggplot(og_bonapp_df, aes(x=published, y=review_count)) + geom_jitter(aes(color=review_count)) + 
            xlab("Year, Month Published") + ylab("Total Reviews Written") + ggtitle("Total Reviews Written per Recipe") +
            labs(color = "Count") 
    )
    output$reviews_table <- renderTable(
        og_bonapp_df %>% group_by(Year = as.character(year(published))) %>% summarise("Review Count" = sum(review_count)) %>% 
            filter(!is.na(Year))
    )

    
    # Ingredients
    
    output$ingred_bubbles <- renderBubbles({
        
        bubble_df <- popular_ingred_table %>% head(50)
        
        bubbles(bubble_df$frequency_count, bubble_df$ingred, 
                key = bubble_df$ingred, 
                color =  as.vector(wes_palette(50, name = "Moonrise3", type = "continuous")))
    })
    
    output$pop_ingred_table <- renderDataTable(
        ingred_badata_df %>% group_by(Ingredient = ingred) %>% 
            summarise(frequency_count = n_distinct(dishtitle)) %>%
            arrange(desc(frequency_count)) %>% rename("Frequency Count" = frequency_count)
    )
    
    ingred_input_df <- reactive({
        ingred_badata_df %>% filter(grepl(input$ingred_choice, ingred)) %>% 
        group_by(Year = year(published)) %>% tally() %>% mutate(., Ratio = n/year_recipe_totals$n) 
    })
    
    output$plot11 <- renderPlot(
        ingred_input_df() %>% ggplot(aes(x = Year, y=Ratio)) + geom_bar(aes(fill = n), stat="identity") + 
        scale_fill_gradientn(colors = brewer.pal(n=10, name = "Spectral")) +
        theme(legend.title=element_blank()) + 
        ylab("Proportion of Ingredient to Total Recipes") + xlab("Yearly Timeline") + ggtitle("Interactive Ingredient Tracking: The Proportion of an Ingredient's Use Out of the Total Number of Recipes for the Year")
    )
    
    
    # COVID-19
    
    output$recipes_in_2020 <- renderPlot(
        og_bonapp_df %>% filter(year(published) == 2020) %>% group_by(published) %>% 
            summarise(recipe_count = n_distinct(dishtitle)) %>% 
        ggplot(aes(x=published, y=recipe_count)) + geom_col(fill="blue") + 
            ggtitle("Monthly Total Recipes Published in 2020") + xlab("Months") + ylab("Recipe Count") + 
            theme(legend.title=element_blank())
    )
   
    output$review_count_2020 <- renderPlot(
        og_bonapp_df %>% filter(year(published) == 2020) %>% group_by(published) %>% 
            summarise(review_count = sum(review_count)) %>% 
        ggplot(aes(x=published, y=review_count)) + 
            geom_col(fill="blue") + theme(legend.title=element_blank()) + 
            ggtitle("Monthly Total Reviews Written in 2020") + xlab("Months") + ylab("Review Count")
    )
    
    output$avg_review_count <- renderPlot(
        og_bonapp_df %>% filter(year(published) %in% c(as.integer(unlist(strsplit(input$all_years, ", "))))) %>%
            group_by(Year = as.character(year(published)), published) %>%
            summarise(avg_reviews = sum(review_count) / n_distinct(dishtitle)) %>%
            ggplot(aes(x=month(published, label = TRUE), y=avg_reviews)) +
            geom_line(size = 1, aes(group=factor(Year), color=factor(Year))) +
            theme(legend.title=element_blank()) +
            ggtitle("Average Reviews Recieved, by Year") + xlab("Months") + ylab("Average Review Count")
    )
    
    output$monthly_review_count <- renderPlot(
        ggplot(og_bonapp_df, aes(x=published, y=review_count)) + geom_col(aes(fill=year(published))) +
            theme(legend.title=element_blank()) + xlab("Months of Publishing") + ylab("Total Reviews Written per Month") +
            ggtitle("Total Reviews Written by Month")
    )
    
}

