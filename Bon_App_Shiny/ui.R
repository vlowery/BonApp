
shinyUI(dashboardPage(
    dashboardHeader(title = "Bon Appetite"),
    dashboardSidebar(sidebarMenu(
        menuItem("Introductions", tabName = "intro", icon = icon("info")),
        menuItem("Broad Picture", tabName = "averages", icon = icon("calendar")),
        menuItem("Reviews/Ratings", tabName = "ratings", icon = icon("thumbs-up")),
        menuItem("Ingredient Trends", tabName = "ingredients", icon = icon("lemon")),
        menuItem("COVID-19 Response", tabName = "corona", icon = icon("briefcase-medical"))
    )),
    dashboardBody(tabItems(
        tabItem(tabName = "intro", 
            fluidPage(
                fluidRow(box(width = 9, h1(tags$b("The Ingredients That Make Bon Appetit")))),
                br(),
                fluidRow(
                    box(
                        p(" For my Web Scraping project, I chose to scrape the cooking magazine 
                        Bon Appetit's online recipe catalog. For it, I built a spider that crawled through 
                        search result pages for all twelve months for every year since 2015. The spider 
                        collected over 3,000 recipes of which I recorded the dish's name, ingredients, 
                        publishing date, rating, and reviews."), 
                        p(" With this information, I analyzed commonly repeated ingredients, trends 
                          in reviews written, ratings given, recipes published, and finally how COVID-19 
                          might be affecting the magazine holistically.")),
                    box(img(src = "Steak_Shot_1.png", height = 200))
                    ),
                fluidRow(
                    h2(tags$b("Expectations")),
                    box(width = 7, 
                        p("Initially, my expectations were that both online publication of recipes and user 
                        involvement would both rise over time. I anticipated more recipes in years closer to 
                        the present as companies slowly become more and more digitally friendly. And as 
                        companies grow with technology, I expected consumers to also become more present 
                        online, writing more reviews and rating recipes more frequently."))
                    ),
                fluidRow(
                    h2(tags$b("Reality")),
                    box(paste("Surprisingly, however, only half of my expectations were true. According to the data scraped,", 
                        tags$b("Bon Appetit is actually decreasing in recipes published per year,"), "and at a pretty steep 
                        decline. While my inclination was to expect more digital presence as the years went on, I might 
                        have misplaced where that presence would be."),
                        paste("In late 2016, Bon Appetit launched a YouTube channel featuring a test kitchen chef making 
                        fermented foods and featuring microbial food cultures. While the series' style was fairly 
                        unproduced and there were plenty of 'real-life' moments and mistakes, it was a hit. Previously 
                        social media had been inundated with POV cooking videos featuring only hands and pans, so to see 
                        the actual chef and", tags$b("to connect with the person cooking the dish made Bon Appetit's channel stand out"), 
                        ". Following the 'It's Alive with Brad' series, Bon Appetit released more and more specialty 
                        channels, some focusing on more posh dishes while other channels play with the notion itself of cooking, 
                        like 'Reverse Engineering' where chef Chris Morocco reverse engineers a recipe for a dish he can 
                        only eat while blindfolded."),
                        p("Bon Appetit has in fact increased their digital presence, just not in the way I had expected. 
                          By spending more time and resources per recipe published through their YouTube channel, 
                          Bon Appetit has pivoted their brand to one that has recipes consistently trending on YouTube 
                          and nearly 50 videos with more than 5 million views each.")),
                    box(width = 5, img(src = "youtube_shot.png", height = 200))
                    )
                )
            ),
        tabItem(tabName = 'averages',
                 fluidPage(
                     fluidRow(
                         box(width = 7, h1(tags$b("Bon Appetit's Recipe Output")), background = "black")
                         ), 
                     fluidRow(
                        box(width = 9, h4(("With the world becoming digital more and more each day, 
                                        one would think online recipe publishing would be on the rise. However,"), 
                                        tags$b("the past three years have seen a decline in recipe publishing.")))
                         ),
                     h2("Total Recipe Output, 2014-2020"),           
                     fluidRow(
                         box(width = 5, plotOutput("yearly_publishing")), 
                         box(width = 4, p("Output in general it seems has been on the decline for a few years. 
                                          The graph to the left clearly illustrates a lessening in new material 
                                          for the past three years. Bon Appetit's online recipe peak looks to fall within 2016, 
                                          where a total of 741 new recipes were published."),
                                        p("After a peak in 2016, following an almost as close year in 2017 with 724 recipes posted, 
                                          content output swiftly declined. 2018 saw only 501 recipes, while 2019 only 
                                          made it into the low 400s. The reduction in output might be a sign of shifting 
                                          priorities in the company."),
                                        p("It's possible the shift in recipe output moved from quantity towards quality. 
                                        Bon Appetit has become famous for its immaculate test kitchen and well-versed 
                                        chefs--as seen in videos uploaded to their Youtube channel. With magazine sales 
                                        struggling to compete with an online world full of video 'how-to's and tasty 
                                        recipes, it's possible this decline in recipes posted is in part due to Bon Appetit 
                                        spending more time with the recipes through different mediums, 
                                        like developing corresponding videos.")), 
                         box(width = 3, align = "center", tableOutput('totals_table'))
                         ),
                 h2("Month by Month, for Each Year"),
                 fluidRow(
                     box(width = 9, plotOutput("plot2")),
                     box(width = 3, p("The graph to the left shows the distribution through the months for all five years. 
                                      While 2020 hasn't reached its halfway point yet, there is still a considerable difference 
                                      in the content output."),
                                      p("Another feature to look at: July seems to be a very slow month for the company in 
                                        terms of new material. For the past two years, and this year included if trends continue, 
                                        July consistently sees a drastic drop in new recipes published.")),
                    ),
                 fluidRow(
                     box(width=10, plotOutput("plot9")),
                     box(width = 2, checkboxGroupInput("checkGroup1", label = h3("Years"), 
                                                       choices = list("2014" = 2014, "2015" = 2015, "2016" = 2016, 
                                                                      "2017" = 2017, "2018" = 2018, "2019" = 2019, 
                                                                      "2020" = 2020), selected = 2014))
                     )
                 )
                ),
        tabItem(tabName = 'ratings',
                 fluidPage(
                     fluidRow( 
                         box(width = 10, h1(tags$b("Reviews and Ratings Through the Years")))
                         ), 
                     h2("Ratings"),  
                     fluidRow(
                        infoBoxOutput("ratings_first"), infoBoxOutput("ratings_second"), infoBoxOutput("ratings_third")
                        ),
                     fluidRow(
                         box(width = 8, plotOutput("timelapse_ratings")),
                         box(width = 4, 
                            p("The graph to the left shows that, except for a few very negative people in 2016 and 
                            2017, recipes have been mostly well-rated.  In fact, the average lowest rating has had a 
                            general upward trend, with an average clustering around 4.0-5.0 stars from the end of 
                            2018 to the present day."), 
                            p("It would seem that before late 2015, however, the rating system operated differently, 
                            as there is an unusual block of highly varied ratings within 2015. After 2015, ratings 
                            seem to often snap to whole numbers, e.g. '3.0', '4.0', and '5.0'. This could be 
                            because a dish's overall rating was averaged from a collection of questions gathering 
                            ratings on facets of the dish (a recipe's clear/poor instructions, the use of certain 
                            ingredients, overall taste, and others). Other possibilities are that users were 
                            given a sliding bar for a number out of 100 or some other scale size rather 
                            than a 1-5 star system."))
                         ),
                    h2("Reviews"),
                    fluidRow(
                        infoBoxOutput("reviews_first"), infoBoxOutput("reviews_second"), infoBoxOutput("reviews_third")
                        ),
                     fluidRow(
                        box(width = 12, 
                            p("The review count below on the left shows an increase in multiple reviews being 
                            written per recipe. Previously, especially in 2015 and 2016, most recipes went 
                            unreviewed, or they recieved only one or two reviews. Since then, customer engagement 
                            has increased, and", 
                            tags$b("recipes are more likely to recieve multiple reviews"), 
                            (". While it is true that fewer recipes are being published each year by Bon Appetit, 
                            thus increasing the likelihood that a recipe is trafficked and reviewed, it is 
                            still the case that customers are engaging more with the material. The chart on the 
                            bottom right illustrates the stark increase in total reviews written each year.")))
                         ### ADD EACH YEARS MOST REVIEWED DISH
                         ### ADD A TABLE TOTALLING REVIEWS WRITTEN
                     ),
                 fluidRow(
                     box(width = 9, plotOutput("timelapse_reviews")), 
                     box(width = 3, tableOutput("reviews_table"))
                     )
                 )
                ),
        tabItem(tabName = 'ingredients',
                fluidPage(
                     fluidRow(
                         box(width = 7, solidHeader = TRUE, h1(tags$b("The Trends in Ingredients"))),
                         hr(),
                         box(width = 8, h3("Bon Appetit's Top Repeated Ingredients"),
                            h5(("While Bon Appetit quite frequently opens our eyes to new ingredients or food 
                            pairings we might not have thought would work, there are still particular staples 
                            that one can never be without when cooking. What is the most important ingredient 
                            to Bon Appetit?"), br(), p("Kosher salt.")),
                            bubblesOutput("ingred_bubbles", width = "100%", height = 600)),
                         box(width = 4, title = "Top Ingredients from 2014-2020", dataTableOutput("pop_ingred_table"))
                        ),
                     fluidRow(
                         h2("Specific Ingredient Trends"),
                         br(),
                         selectInput("ingred_choice", label = h3("Select Ingredient"), 
                                     choices = list("Tomatoes" = "tomatoes", "Potatoes"="potatoes$", "Kale" = "kale", 
                                                    "Oranges" = "oranges", "Pears" = "pears", "Lemons" = "lemon$", 
                                                    "Limes" = "lime$", "Ricotta" = "ricotta", "Pickles" = "pickles$", 
                                                    "Pecorino" = "pecorino", "Cumin" = "cumin", "Sage" = "sage", 
                                                    "Cinnamon" = "cinnamon", "Beans" = "beans", "Maple Syrup" = "maple syrup", 
                                                    "Red Wine" = "red wine", "Cheddar Cheese" = "cheddar", "Lettuce" = "lettuce"),  
                                     selected = "kale"),
                         plotOutput("plot11")
                         ),
                 )
                ),
        tabItem(tabName = 'corona',
                 fluidPage(
                    fluidRow(box(width=10, title = h1(tags$b("Bon Appetit's Response to COVID-19")),
                                h3("How reduced hours, social-distancing, and working from home has affected Bon Appetit"))
                            ),
                 fluidRow(h3(tags$b("Recipe Publishing Repercussions"))),
                 fluidRow(
                    box(
                        p("March 2020 completely altered life as we knew it for most New Yorkers, and for many 
                        Americans across the country. Companies furloughed or terminated many workers, and those 
                        lucky enough to still have a job faced the challenges of working from home. With children 
                        home as schools shut down, and work hours bleeding into personal time (and vice versa), 
                        it's safe to say, productivity has been negatively affected."), 
                        p("However, because Bon Appetit operates around its magazine publication, most of the 
                        work for March's reports was completed in February. According to the chart on the right, 
                        March was the most productive month of the year up to that point. April's output, however, 
                        potentially exhibits signs of dampened productivity due to COVID-19 restrictions. By May, 
                        though, with some adjustments to shipping ingredients to personal addresses, cooking 
                        recipes with the constraints of a New York apartment kitchen, and testing dishes out 
                        on family members, Bon Appetit bounced back. May's level of recipe output matches that of 
                        March, when distancing restrictions hadn't reached full force.")),
                    box(plotOutput("recipes_in_2020"))
                    ),
                 fluidRow(h3(tags$b("Consumer Engagement Repercussions"))),
                 fluidRow(
                     box(
                        p("It's too soon to tell whether consumer engagement has dropped. May recipes haven't been 
                        published for as long as April or March's recipes, and Bon Appetit pulls together collections 
                        of older recipes in blog posts that compete for traffic on the webpage. It's possible we see 
                        fewer reviews logged simply because these recipes haven't been in circulation as much. And 
                        even though many Americans are stuck at home now, only time will tell if writting online 
                        reviews is where customers will spend their extra hours"),
                        p("However, it is worth noting that according to the graph below, review writing has been 
                        on the rise since late 2016. And recipes published during Winter 2019 have already seen 
                        record high review counts. While the start of a new year doesn't see as many reviews 
                        written as the end of one, 2020's review count is not encouraging of similar 
                        customer engagement.")),
                     box(plotOutput("review_count_2020"))
                     ),
                 fluidRow(
                     box("This is the average reviews recieved by month in 2020"),
                     box(align = "center", radioButtons("all_years", "Select Years:", 
                                                              choices = list("Only 2020" = 2020, 
                                                                             "All Years (2014 - 2020)" = 
                                                                                 "2014, 2015, 2016, 2017, 2018, 2019, 2020"), 
                                                              selected = 2020, 
                                                              inline = TRUE),
                         verbatimTextOutput("text_test"),                  
                         plotOutput("avg_review_count"))
                     ),
                 fluidRow(
                     tabBox(title = tagList(shiny::icon("gear"), "Review Counts by Year, Month"), width = 12, 
                            tabPanel("Monthly Review Count", plotOutput("monthly_review_count")),
                            tabPanel("Quarterly Reviews Against Recipe Output")) #plot line plots of the two
                            )
                 )
                )
        )
        )
    )
)
