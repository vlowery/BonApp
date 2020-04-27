

function(input, output, session){

    # RATINGS through the Years
    
    output$plot1 <- renderPlot(
        ggplot(og_bonapp_df, aes(x=Published, y=Rating)) + geom_violin(aes(fill=format(og_bonapp_df$Published, "%Y"))) +
            theme(legend.title=element_blank())
    )
    output$plot7 <- renderPlot(
        ggplot(og_bonapp_df, aes(x=Published, y=Rating)) + geom_point(size = 2, aes(color=Rating))
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
    
    # INFORMATION Recipe Count Through the Years
    
    output$plot2 <- renderPlot(
        og_bonapp_df %>% filter(!is.na(Published)) %>% ggplot(aes(x=(format(Published, "%m/%B")))) + 
            geom_bar(na.rm = TRUE, position = "dodge", aes(fill=(format(Published, "%Y")))) +
            ggtitle("Number of Recipes Published From 2015-2020") + theme(legend.title=element_blank()) +
            xlab("Months") +ylab("Recipe Count")
    )
    
    table_totals_per_year <- og_bonapp_df  %>% filter(!is.na(Published)) %>% group_by(., year = format(Published, "%Y")) %>% 
        summarise(., recipe_count = n_distinct(DishTitle))
    as.data.frame(table_totals_per_year)
    output$totals_table <- renderTable(table_totals_per_year)
    
    output$plot10 <- renderPlot(
        ggplot(og_bonapp_df, aes(x=Published)) + geom_bar(aes(fill=format(og_bonapp_df$Published, "%Y"))) +
            theme(legend.title=element_blank())
    )
            ### THIS IS THE INTERACTIVE MAP
                ## RETURN AND ADD BREAKS TO COLORS

    df_input <- reactive({
        og_bonapp_df %>% filter(., format(og_bonapp_df$Published, "%Y") == c(input$checkGroup1))
    })
    
    output$plot9 <- renderPlot(
    df_input() %>% group_by(., year = format(Published, "%Y"), month = format(Published, "%m")) %>% 
        summarise(., recipe_count = n_distinct(DishTitle)) %>% 
        ggplot(aes(x=month, y=as.numeric(recipe_count))) + geom_col(position = "dodge", aes(fill=year)) 

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
        ingred_badata_df %>% filter(ingred == input$ingred_choice) %>% 
            group_by(., published, ingred) %>% 
            summarise(., review_count = n_distinct(dishtitle))
    })
    
    output$plot11 <- renderPlot(
        ingred_input_df() %>% ggplot(aes(x = published, y = review_count)) + 
        geom_area() 
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
    
    # output$plot6 <- renderPlot(
    # 
    # )
    
    
}
    # output$max1 <- renderInfoBox({
    #     max_value <- max(crossdf$Minutes)
    #     max_day <- crossdf$Day[crossdf$Minutes ==max_value]
    #     infoBox(title="Longest Puzzle", 
    #             round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    # })
    # output$max2 <- renderInfoBox({
    #     max_value <- max(crossdf$Minutes)
    #     max_day <- crossdf$Day[crossdf$Minutes ==max_value]
    #     infoBox(title="Longest Puzzle", 
    #             round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    # })
    # output$max3 <- renderInfoBox({
    #     max_value <- max(crossdf$Minutes)
    #     max_day <- crossdf$Day[crossdf$Minutes ==max_value]
    #     infoBox(title="Longest Puzzle", 
    #             round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    # })
    # output$max4 <- renderInfoBox({
    #     max_value <- max(crossdf$Minutes)
    #     max_day <- crossdf$Day[crossdf$Minutes ==max_value]
    #     infoBox(title="Longest Puzzle", 
    #             round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    # })
    # output$max5 <- renderInfoBox({
    #     max_value <- max(crossdf$Minutes)
    #     max_day <- crossdf$Day[crossdf$Minutes ==max_value]
    #     infoBox(title="Longest Puzzle", 
    #             round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    # })
    # output$max6 <- renderInfoBox({
    #     max_value <- max(crossdf$Minutes)
    #     max_day <- crossdf$Day[crossdf$Minutes ==max_value]
    #     infoBox(title="Longest Puzzle", 
    #             round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    # })
    # output$max7 <- renderInfoBox({
    #     max_value <- max(crossdf$Minutes)
    #     max_day <- crossdf$Day[crossdf$Minutes ==max_value]
    #     infoBox(title="Longest Puzzle", 
    #             round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    # })
    # output$max8 <- renderInfoBox({
    #     max_value <- max(crossdf$Minutes)
    #     max_day <- crossdf$Day[crossdf$Minutes ==max_value]
    #     infoBox(title="Longest Puzzle", 
    #             round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    # })
    # output$max9 <- renderInfoBox({
    #     max_value <- max(crossdf$Minutes)
    #     max_day <- crossdf$Day[crossdf$Minutes ==max_value]
    #     infoBox(title="Longest Puzzle", 
    #             round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    # })
    # output$max10 <- renderInfoBox({
    #     max_value <- summarise(ingred_badata_df$ingred, n())
    #     max_day <- crossdf$Day[crossdf$Minutes ==max_value]
    #     infoBox(title="Longest Puzzle", 
    #             round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    # })
    # 
    
    
    
    
    
    
    
    
    
 

# ggplot(og_bonapp_df[format(og_bonapp_df$Published, "%Y") == format(as.Date(input$radio2), "%Y"), ], 
#        aes(x=Published, y=Rating)) + geom_point(aes(color=Rating))


# ggplot(full_bonapp_df, aes(x=Published, y=Rating)) + geom_point(aes(color=Rating))
# seq(as.Date("2015-01-01"), by='month', length.out = 12)


