
shinyUI(dashboardPage(
    dashboardHeader(title = "Bon Appetit"),
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
                fluidRow(column(offset = 2, width = 8, h1(tags$b("The Ingredients That Make Bon Appetit")))),
                br(),
                fluidRow(
                    column(offset = 1, width = 10, box(
                        p("For my web scraping project, I chose to scrape the cooking magazine 
                        Bon Appetit's online recipe catalog. For it, I built a spider that crawled through 
                        search result pages for all twelve months for every year since 2014. The spider 
                        collected nearly 4,000 recipes of which I recorded the dish's name, ingredients, 
                        publishing date, rating, number of ratings, review text, and number reviews written."), 
                        p("With this information, I analyzed commonly repeated ingredients, trends 
                          in reviews and ratings, recipe output by the magazine, and finally how COVID-19 and the 
                          recent c-suite reorganization might be affecting the magazine holistically.")),
                    img(src = "Steak_Shot_1.png", height = 200))
                    ),
                fluidRow(
                    box(width = 6, h2(tags$b("Expectations")), background = "green", 
                        p("Initially, my expectations were that both online publication of recipes and user 
                        involvement would rise over time. I anticipated more recipes in years closer to 
                        the present as companies slowly become more and more digitally friendly. And just as 
                        companies grow with technology, I expected consumers to also become more present 
                        online, writing more reviews and rating recipes more frequently.")), 
                    box(width = 6, h2(tags$b("Reality")), background = "maroon", 
                        p("Surprisingly, however, only half of my expectations were true. According to the data scraped,", 
                        tags$b("Bon Appetit is actually decreasing in recipes published per year,"), "and at a pretty steep 
                        decline. While my inclination was to expect more digital presence as the years went on, I might 
                        have misplaced where that presence would be."))
                    ), 
                fluidRow(
                    column(offset = 2, width = 8, align = "center", 
                           box(width = 12, h2(tags$b("Conclusion")), background = "navy", 
                               p("In late 2016, the last year before recipe output declines, Bon Appetit launched a YouTube channel  
                        featuring a test kitchen chef making fermented foods and featuring microbial food cultures. While the series'  
                        style was fairly unproduced and there were plenty of 'real-life' moments and mistakes, it was a hit. Previously 
                        social media had been inundated with POV cooking videos featuring only hands and pans, so to see 
                        the actual chef and", tags$b("to connect with the person cooking the dish made Bon Appetit's channel stand out. "), 
                                 br(), br(), "Following the 'It's Alive with Brad' series, Bon Appetit released more and more specialty 
                        channels, some focusing on more posh dishes while other channels played with the notion itself of cooking, 
                        like 'Reverse Engineering' where chef Chris Morocco reverse engineers a recipe for a dish he can 
                        only eat while blindfolded."), br(), img(src = "youtube_shot.png", height = 200), br(), br(), 
                        p("Bon Appetit has in fact increased their digital presence, just not in the way I had expected. 
                          By spending more time and resources per recipe published through their YouTube channel, 
                          Bon Appetit has pivoted their brand to one that has recipes consistently trending on YouTube 
                          and nearly 50 videos with more than 5 million views each. Thus the magazine is listing fewer recipes 
                                 but devotes more time and media platforms to each recipe.")))
                )
                )
            ),
        tabItem(tabName = 'averages',
                 fluidPage(
                     fluidRow(
                         column(offset = 2, width = 8, 
                                box(width = 12, h1(tags$b("Bon Appetit's Recipe Output"), br()), align = "center", background = "navy", 
                                    h4(("With the world becoming digital more and more each day, 
                                        one would think"), br(), (" online recipe publishing would be increasing steaily. However,"), 
                                    br(), tags$b("the past three years have seen a decline in recipe publishing."))))
                         ),
                     h2("Total Recipe Output, 2014-2020"),           
                     fluidRow(
                         tabBox(width = 5, 
                                tabPanel("Monthly Trends", plotOutput("monthly_publishing")),
                                tabPanel("Yearly Trends", plotOutput("yearly_publishing"))), 
                         box(width = 4, p("Output in general it seems has been on the decline for a few years. 
                                          The graph to the left illustrates a lessening in new material 
                                          for the past three years. Bon Appetit's online recipe peak looks to fall within 2016, 
                                          where a total of 747 new recipes were published."),
                                        p("After a peak in 2016, followed by an almost as close year in 2017 with 730 recipes posted, 
                                          content output swiftly declined. 2018 saw only 503 recipes, while 2019 only 
                                          made it into the low 400s. The reduction in output might be a sign of shifting 
                                          priorities in the company."),
                                        p("It's possible the shift in recipe output moved from quantity towards quality. 
                                        Bon Appetit has become famous for its immaculate test kitchen and well-versed 
                                        chefs--as seen in videos uploaded to their Youtube channel. With magazine sales 
                                        struggling to compete with an online world full of video 'how-to's and tasty 
                                        recipes, it's possible this decline in recipes posted is in part due to Bon Appetit 
                                        spending more time with the recipes through different mediums, 
                                        like developing corresponding videos.")), 
                         box(width = 3, background = "yellow", align = "center", 
                             h4(tags$b("Recipe Output Totals")), br(), tableOutput('totals_table'))
                         ),
                 h2("Individual Monthly Output Inspection"),
                 fluidRow(
                     box(width = 9, plotOutput("month_totals_dodge"), footer = tags$i("Red diamonds represent the average monthly outputs.")),
                     box(width = 3, p("The graph to the left shows the distribution through the months for all seven years. 
                                      While 2020 has only just passed its halfway point, there is still a considerable difference 
                                      in the content output. Note, when scraped, August's content had only begun to be released to the website. August's 
                                      numbers are not final. "),
                                      p("Another feature to look at: July seems to be a very slow month for the company in 
                                        terms of new material. For the past two years, and this year included, 
                                        July consistently sees a drastic drop in new recipes published."), 
                                        p("The red diamonds, used to denote monthly averages, on the graph to the left aid in illustrating 
                                          how earlier years, which mostly lie above the red diamond, had a higher output than those most recent 
                                          years, which all fall below the red diamond."))
                    ),
                 fluidRow(
                     box(width = 3, p("To compare individual years, the box on the far right allows the selection of specific years.", br(), br(), 
                                      "The comparison of peak output in 2016 against the year 2018 or 2019 displays the stark dropoff of 
                                      output, most noticably at the start of the year in January and during the summer in July."), 
                         title = "Interactive Monthly Graph"),
                     box(width = 7, plotOutput("interactive_year_totals")),
                     box(width = 2, align = "center", checkboxGroupInput("checkGroup1", label = h3("Years"), 
                                                       choices = list("2014" = 2014, "2015" = 2015, "2016" = 2016, 
                                                                      "2017" = 2017, "2018" = 2018, "2019" = 2019, 
                                                                      "2020" = 2020), selected = c(2016, 2019)))
                     )
                 )
                ),
        tabItem(tabName = 'ratings',
                 fluidPage(
                     fluidRow(
                         column(offset = 1, width = 10, 
                                box(width = 12, h1(tags$b("Reviews and Ratings Through the Years"), br()), 
                                    align = "center", background = "navy", 
                                    h4(("Since a consumer can leave a rating without a review or a review without a rating, "), br(), 
                                    ("the two metrics are looked at individually."))))
                         ),
                     h2("Ratings"),  
                     fluidRow(
                        infoBoxOutput("ratings_first"), infoBoxOutput("ratings_second"), infoBoxOutput("ratings_third")
                        ),
                     fluidRow(
                         tabBox(width = 8, 
                                tabPanel("Scatter Plot", plotOutput("timelapse_ratings")),
                                tabPanel("Bar Plot", plotOutput("bar_ratings")),
                                tabPanel("Density Plot", plotOutput("density_ratings"))),
                         box(width = 4, 
                            p("The graph to the left shows that, except for a few very negative people in 2016 and 
                            2017, recipes have been mostly well-rated.  In fact, the average lowest rating has had a 
                            general upward trend, with an average clustering around 4.0-5.0 stars from the end of 
                            2018 to the present day."), 
                            p("It would seem that before late 2015, however, the rating system operated differently, 
                            as there is an unusual block of highly varied ratings up to 2015. After 2015, ratings 
                            seem to often snap to whole numbers, e.g. '3.0', '4.0', and '5.0'. This could be 
                            because a dish's overall rating was once averaged from a collection of questions gathering 
                            ratings on facets of the dish (a recipe's clear/poor instructions, the use of certain 
                            ingredients, overall taste, and others). Other possibilities are that users were 
                            given a sliding bar for a number out of 100 or some other scale size rather 
                            than a 1-5 star system."))
                         ),
                    h2("Reviews"),
                    fluidRow(
                        infoBoxOutput("reviews_first"), infoBoxOutput("reviews_second"), infoBoxOutput("reviews_third")
                        ),
                         ### ADD EACH YEARS MOST REVIEWED DISH
                 fluidRow(
                     box(width = 3, 
                         p("The review count on the left shows an increase in multiple reviews being 
                            written per recipe. Previously, especially in 2015 and 2016, most recipes went 
                            unreviewed, or they received only one or two reviews. Since then, ", tags$b("customer engagement 
                            has increased"), ", and now recipes are more likely to receive multiple reviews."),  
                           p("While it is true that fewer recipes are being published each year by Bon Appetit, 
                            thus increasing the likelihood that a recipe is trafficked and reviewed, it is 
                            still the case that customers are engaging more with the material. The table on the 
                            far right illustrates the stark increase in total reviews written each year. Recipes published 
                            in 2019 acquired over 7,000 reviews."), 
                            p("This is impressive given that time spent on the website, as often recipes are recycled and brought 
                            back into circulation, could have easily favored older recipes to gain more reviews; yet", 
                            tags$b("it is the newest listings that pull in higher and higher numbers of reviews."))),
                     box(width = 7, plotOutput("timelapse_reviews"), footer = tags$i("The graph above excludes the top three reviewed recipes, first 
                     Bon Appetit's chocolate chip recipe from April 2019 with a total of 689 reviews, second a recipe from April 2017 with 202 
                         total reviews, and third a February 2019 recipe with 162 reviews.")), 
                     box(width = 2, align = "center", tableOutput("reviews_table"))
                     ),
                 h2("Each Year's Best Recipes"),
                 fluidRow(
                     box(width = 3, "Grouping by year, I sorted the recipes by review count to ensure the top recipe was one 
                         with a large sample size of reviews, then I sorted by rating.", br(), br(), "The following are each year's 
                         top rated recipes out of the top ten most reviewed listings per year."),
                     box(width = 9, background = "teal", dataTableOutput("years_best"))
                     )
                 )
                ),
        tabItem(tabName = 'ingredients',
                fluidPage(
                    fluidRow(
                        column(offset = 2, width = 8, 
                               box(width = 12, h1(tags$b("The Trends in Ingredients")), 
                                   align = "center", background = "navy"))
                        ),
                    fluidRow(
                         box(width = 8, align = "center", h3("Bon Appetit's Top Repeated Ingredients"),
                            p(("While Bon Appetit quite frequently opens our eyes to new ingredients or food 
                            pairings we might not have thought would work, there are still particular staples 
                            that one can never be without when cooking. What is the most important ingredient 
                            to Bon Appetit?"), br(), p("Kosher salt.")),
                            bubblesOutput("ingred_bubbles", width = "100%", height = 600)),
                         box(width = 4, title = "Top Ingredients from 2014-2020", dataTableOutput("pop_ingred_table"))
                        ),
                    fluidRow(h2("Specific Ingredient Trends")),
                    fluidRow(
                        selectInput("ingred_choice", label = h4("Select Ingredient"), 
                                     choices = list("Tomatoes" = "tomatoes", "Potatoes"="potatoes$", "Kale" = "kale", 
                                                    "Oranges" = "oranges", "Pears" = "pears", "Lemons" = "lemon$", 
                                                    "Limes" = "lime$", "Ricotta" = "ricotta", "Pickles" = "pickles$", 
                                                    "Pecorino" = "pecorino", "Cumin" = "cumin", "Sage" = "sage", 
                                                    "Cinnamon" = "cinnamon", "Beans" = "beans", "Maple Syrup" = "maple syrup", 
                                                    "Red Wine" = "red wine", "Cheddar Cheese" = "cheddar", "Lettuce" = "lettuce"),  
                                     selected = "kale"),
                        box(width = 12, plotOutput("ingred_interactive"), title = "The Proportion of an Ingredient's Use Out of the Total Number of Recipes for the Year")
                         ),
                 )
                ),
        tabItem(tabName = 'corona',
                 fluidPage(
                     fluidRow(
                         column(offset = 2, width = 8, 
                                box(width = 12, h1(tags$b("Bon Appetit's Response to Covid-19"), br()), 
                                    h3("How reduced hours, social-distancing, and working from home has affected Bon Appetit"),
                                    align = "center", background = "navy"))
                     ),
                     fluidRow(h2(tags$b("Recipe Publishing Repercussions"))),
                     fluidRow(
                         box(
                            p("March 2020 completely altered life as we knew it for most New Yorkers, and for many 
                            Americans across the country. Companies furloughed or terminated many workers, and those 
                            lucky enough to still have a job faced the challenges of working from home. With children 
                            home as schools shut down, and work hours bleeding into personal time (and vice versa), 
                            it's safe to say, productivity has not been easy to foster."), 
                            p("However, because Bon Appetit operates around its magazine publication, most of the 
                            work for March's reports was completed in February. According to the chart on the right, 
                            March was the most productive month of the year up to that point. April's output, however, 
                            potentially exhibits signs of dampened productivity due to Covid-19 restrictions. "), 
                            p("By May, though, with some adjustments to shipping ingredients to personal addresses, cooking 
                            recipes with the constraints of a New York apartment kitchen, and testing dishes out 
                            on family members, Bon Appetit bounced back. May's level of recipe output matches that of 
                            March, and June follows very closely to May's high.")),
                        box(plotOutput("recipes_in_2020"))
                        ),
                 fluidRow(h2(tags$b("Consumer Engagement Repercussions"))),
                 fluidRow(
                     box(
                        p("As older recipes have an advantage in gaining reviews, it's too soon to tell whether consumer 
                        engagement has been significantly affected by either Covid-19 or the recent upper management scandals. 
                        July's recipes have had barely half the time of June's recipes to acquire reviews and even less than May's 
                        recipes."), 
                        p("Additionally, Bon Appetit pulls together collections of older recipes in blog posts 
                        that compete for traffic on the webpage. It's very possible we see fewer reviews logged simply 
                        because these recipes haven't been in circulation as much."),  
                        p("Even though many Americans are stuck at home now, only time will tell if writing online 
                        reviews is where customers will spend their extra hours, or if the scandals have lost the company 
                        a significant portion of its fanbase and customers.")),
                     box(plotOutput("review_count_2020"))
                     ),
                 fluidRow(h2(style = 'color:red', tags$b("A Possible Decline for Bon Appetit"))),
                 fluidRow(
                     column(width = 7, box(width = 12, 
                     p("However, it is worth noting that according to the graph below, review writing has been 
                        on the rise since 2016. And recipes published during Winter 2019 have already seen 
                        record high review counts. While the start of a new year doesn't see as many reviews 
                        written as the end of one, 2020's review count is not encouraging of similar 
                        customer engagement patterns."), 
                         p("The line chart to the right shows that summers typically experience a dip in customer engagement.  
                           It might be a while, possibly early winter or the start of next year, before any effects of Covid-19  
                           or the scandals can truly be evaluated."), 
                         p("This may be a decrease in customer engagement simply because summers 
                           experience low engagement. Or this could be the start of the downfall of Bon Appetit's customer base.")),
                     box(solidHeader = TRUE, width = 12, status = "warning", 
                         title = tagList(shiny::icon("chart-line"), "Monthly Review Count"),  
                         plotOutput("monthly_review_count"))), 
                     box(width = 5, align = "center", radioButtons("all_years", "Select Years:", 
                                                              choices = list("Only 2020" = 2020, 
                                                                             "All Years (2014 - 2020)" = 
                                                                                 "2014, 2015, 2016, 2017, 2018, 2019, 2020"), 
                                                              selected = 2020, 
                                                              inline = TRUE),
                         plotOutput("avg_review_count"))
                     )
                 )
                )
        )
        )
    )
)
