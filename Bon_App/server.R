
library(shiny)

shinyServer(function(input, output, session){
    
#    output$hist <- renderGvis({
#        gvisHistogram(full_badata_df[,"Published", drop=F], options= list(legend="none"))
#    })
    
    output$value <- renderPrint({ input$radio1 })
    
#    ggplot(full_bonapp_df, aes(x=Published, y=Rating)) + geom_point(aes(color=Rating))
    
    output$plot1 <- renderPlot(
        ggplot(og_bonapp_df[months(og_bonapp_df$Published) == as.Date(input$radio1), ], 
           aes(x=Published, y=Rating)) + geom_point(aes(color=Rating))
    )
    
    output$value <- renderPrint({ input$radio2 })
    
    output$plot2 <- renderPlot(
        ggplot(og_bonapp_df[format(og_bonapp_df$Published, "%Y") == format(as.Date(input$radio2), "%Y"), ], 
               aes(x=Published, y=Rating)) + geom_point(aes(color=Rating))
    )

    
    output$max1 <- renderInfoBox({
        max_value <- max(crossdf$Minutes)
        max_day <- crossdf$Day[crossdf$Minutes ==max_value]
        infoBox(title="Longest Puzzle", 
                round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    })
    output$max2 <- renderInfoBox({
        max_value <- max(crossdf$Minutes)
        max_day <- crossdf$Day[crossdf$Minutes ==max_value]
        infoBox(title="Longest Puzzle", 
                round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    })
    output$max3 <- renderInfoBox({
        max_value <- max(crossdf$Minutes)
        max_day <- crossdf$Day[crossdf$Minutes ==max_value]
        infoBox(title="Longest Puzzle", 
                round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    })
    output$max4 <- renderInfoBox({
        max_value <- max(crossdf$Minutes)
        max_day <- crossdf$Day[crossdf$Minutes ==max_value]
        infoBox(title="Longest Puzzle", 
                round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    })
    output$max5 <- renderInfoBox({
        max_value <- max(crossdf$Minutes)
        max_day <- crossdf$Day[crossdf$Minutes ==max_value]
        infoBox(title="Longest Puzzle", 
                round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    })
    output$max6 <- renderInfoBox({
        max_value <- max(crossdf$Minutes)
        max_day <- crossdf$Day[crossdf$Minutes ==max_value]
        infoBox(title="Longest Puzzle", 
                round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    })
    output$max7 <- renderInfoBox({
        max_value <- max(crossdf$Minutes)
        max_day <- crossdf$Day[crossdf$Minutes ==max_value]
        infoBox(title="Longest Puzzle", 
                round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    })
    output$max8 <- renderInfoBox({
        max_value <- max(crossdf$Minutes)
        max_day <- crossdf$Day[crossdf$Minutes ==max_value]
        infoBox(title="Longest Puzzle", 
                round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    })
    output$max9 <- renderInfoBox({
        max_value <- max(crossdf$Minutes)
        max_day <- crossdf$Day[crossdf$Minutes ==max_value]
        infoBox(title="Longest Puzzle", 
                round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    })
    output$max10 <- renderInfoBox({
        max_value <- summarise(ingred_badata_df$ingred, n())
        max_day <- crossdf$Day[crossdf$Minutes ==max_value]
        infoBox(title="Longest Puzzle", 
                round(max_value, 2), subtitle= paste(c("/minutes on ", as.character(max_day)), collapse = ""), icon=icon("angle-double-up"), width=6)
    })
    
    
    
    
    
    
    
    
    
    
    })



# ggplot(full_bonapp_df, aes(x=Published, y=Rating)) + geom_point(aes(color=Rating))
# seq(as.Date("2015-01-01"), by='month', length.out = 12)



format(og_bonapp_df$Published, "%Y") == 2015
