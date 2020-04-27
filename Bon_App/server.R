

function(input, output, session){

    # RATINGS through the Years
    
    output$plot7 <- renderPlot(
        ggplot(og_bonapp_df, aes(x=Published, y=Rating)) + geom_point(size = 3, aes(color=Rating)) +
            scale_color_gradientn(colors = wes_palette("Darjeeling1", 3, type = "continuous"))
    )
    
            ## Review Count through the years
    
    output$plot3 <- renderPlot(
        ggplot(og_bonapp_df, aes(x=Published, y=Reviews)) + geom_jitter(aes(color=Reviews)) + 
            xlab("Months of Publishing") + ylab("Reviews Written per Recipe") + ggtitle("Number of Reviews Written per Recipe") +
            labs(color = "Count") 
    )
    output$reviews_table <- renderTable(
        year_review_totals
    )
    
    output$plot8 <- renderPlot(
        ggplot(og_bonapp_df, aes(x=Published, y=Reviews)) + geom_col(aes(fill=format(og_bonapp_df$Published, "%Y"))) +
            theme(legend.title=element_blank()) + xlab("Months of Publishing") + ylab("Total Reviews Written per Month") +
            ggtitle("Total Reviews Written by Month")
    )
    
    output$top_1 <- renderInfoBox(
        infoBox("Most Reviewed Dish", top_reviewed_dish$DishTitle[1], fill = TRUE
        ))
    
    output$top_2 <- renderInfoBox(
        infoBox("Second Most Reviewed", top_reviewed_dish$DishTitle[2], fill = FALSE
        ))
    
    output$top_3 <- renderInfoBox(
        infoBox("Third Most Reviewed", top_reviewed_dish$DishTitle[3], fill = FALSE
        ))
    
    output$best_1 <- renderInfoBox(
        infoBox("Highest Rated Dish", top_rated_dish$DishTitle[1], fill = TRUE
        ))
    
    output$best_2 <- renderInfoBox(
        infoBox("Second Highest Rated", top_rated_dish$DishTitle[2], fill = FALSE
        ))
    
    output$best_3 <- renderInfoBox(
        infoBox("Third Highest Rated", top_rated_dish$DishTitle[3], fill = FALSE
        ))
    
    # INFORMATION Recipe Count Through the Years
    
    output$plot2 <- renderPlot(
        og_bonapp_df %>% filter(!is.na(Published)) %>% ggplot(aes(x=(format(Published, "%m/%B")))) + 
            geom_bar(na.rm = TRUE, position = "dodge", aes(fill=(format(Published, "%Y")))) +
            ggtitle("Number of Recipes Published From 2015-2020") + theme(legend.title=element_blank()) +
            xlab("Months") + ylab("Recipe Count") + theme(axis.text.x = element_text(angle = 45, hjust = 1))

    )
    
    table_totals_per_year <- og_bonapp_df  %>% filter(!is.na(Published)) %>% group_by(., Year = format(Published, "%Y")) %>% 
        summarise(., "Recipe Count" = n_distinct(DishTitle))
    as.data.frame(table_totals_per_year)
    output$totals_table <- renderTable(table_totals_per_year)
    
    output$plot10 <- renderPlot(
        ggplot(og_bonapp_df, aes(x=Published)) + geom_bar(aes(fill=format(og_bonapp_df$Published, "%Y"))) +
            theme(legend.title=element_blank()) + xlab("Publishing Timeline, Months") + ylab("Recipe Count")
    )
            ### THIS IS THE INTERACTIVE GRAPH
                ## RETURN AND ADD BREAKS TO COLORS

    df_input <- reactive({
        og_bonapp_df %>% filter(., format(og_bonapp_df$Published, "%Y") == c(input$checkGroup1))
    })
    
    output$plot9 <- renderPlot(
    df_input() %>% group_by(., year = format(Published, "%Y"), month = format(Published, "%m/%B")) %>% 
        summarise(., recipe_count = n_distinct(DishTitle)) %>% 
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
        ggplot(df_2020_totals, aes(x=Published, y=n)) + geom_bar(stat = "identity", aes(fill=n)) + 
            ggtitle("Monthly Total Recipes Published in 2020") + xlab("Months") + ylab("Recipe Count") + theme(legend.title=element_blank()) +
            scale_fill_gradientn(colors = wes_palette("Darjeeling1", 3, type = "continuous"))
    )
   
    # COVID-19 Review Count 2020
    
    output$plot5 <- renderPlot(
        ggplot(df_2020_by_Pub, aes(x=Published, y=review_count)) + 
            geom_col(aes(fill=(review_count))) + theme(legend.title=element_blank()) + 
            ggtitle("Monthly Total Reviews Written in 2020") + xlab("Months") + ylab("Review Count") +
            scale_fill_gradientn(colors = brewer.pal(n=10, name = "Spectral")) #wes_palette("Zissou1", 3, type = "continuous"))
    )
    
    
}



