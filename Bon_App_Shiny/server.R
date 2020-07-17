

function(input, output, session){

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
    
    output$plot3 <- renderPlot(
        ggplot(og_bonapp_df, aes(x=published, y=review_count)) + geom_jitter(aes(color=review_count)) + 
            xlab("Months of Publishing") + ylab("Reviews Written per Recipe") + ggtitle("Number of Reviews Written per Recipe") +
            labs(color = "Count") 
    )
    output$reviews_table <- renderTable(
        year_review_totals
    )
    
    output$plot8 <- renderPlot(
        ggplot(og_bonapp_df, aes(x=published, y=review_count)) + geom_col(aes(fill=format(og_bonapp_df$published, "%Y"))) +
            theme(legend.title=element_blank()) + xlab("Months of Publishing") + ylab("Total Reviews Written per Month") +
            ggtitle("Total Reviews Written by Month")
    )

    
    # INFORMATION Recipe Count Through the Years
    
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
    
    output$plot10 <- renderPlot(
        ggplot(og_bonapp_df, aes(x=published)) + geom_bar(aes(fill=format(og_bonapp_df$published, "%Y"))) +
            theme(legend.title=element_blank()) + xlab("Publishing Timeline, Months") + ylab("Recipe Count")
    )
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
    
    
    # Ingredients
    
    output$ingred_bubbles <- renderBubbles({
        
        bubble_df <- popular_ingred_table %>% head(50)
        
        bubbles(bubble_df$frequency_count, bubble_df$ingred, 
                key = bubble_df$ingred, 
                color =  as.vector(wes_palette(50, name = "Moonrise3", type = "continuous")))
    })
    
    output$pop_ingred_table <- renderDataTable(popular_ingred_table)
    
    ingred_input_df <- reactive({
        ingred_badata_df %>% filter(grepl(input$ingred_choice, ingred)) %>% 
        group_by(., Year = format(published, "%Y")) %>% tally() %>% mutate(., Ratio = n/year_recipe_totals$n) 
    })
    
    output$plot11 <- renderPlot(
        ingred_input_df() %>% ggplot(aes(x = Year, y=Ratio)) + geom_bar(aes(fill = n), stat="identity") + 
        scale_fill_gradientn(colors = brewer.pal(n=10, name = "Spectral")) +
        theme(legend.title=element_blank()) + 
        ylab("Proportion of Ingredient to Total Recipes") + xlab("Yearly Timeline") + ggtitle("Interactive Ingredient Tracking: The Proportion of an Ingredient's Use Out of the Total Number of Recipes for the Year")
    )
    
    
    # COVID-19 Recipe Count in 2020
    
    output$plot4 <- renderPlot(
        ggplot(df_2020_totals, aes(x=published, y=n)) + geom_bar(stat = "identity", aes(fill=n)) + 
            ggtitle("Monthly Total Recipes Published in 2020") + xlab("Months") + ylab("Recipe Count") + theme(legend.title=element_blank()) +
            scale_fill_gradientn(colors = wes_palette("Darjeeling1", 3, type = "continuous"))
    )
   
    # COVID-19 Review Count 2020
    
    output$plot5 <- renderPlot(
        ggplot(df_2020_by_Pub, aes(x=published, y=review_count)) + 
            geom_col(aes(fill=(review_count))) + theme(legend.title=element_blank()) + 
            ggtitle("Monthly Total Reviews Written in 2020") + xlab("Months") + ylab("Review Count") +
            scale_fill_gradientn(colors = brewer.pal(n=10, name = "Spectral")) #wes_palette("Zissou1", 3, type = "continuous"))
    )
    
    
}

