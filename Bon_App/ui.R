
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
        tabItem( tabName = "intro", 
            
            fluidRow( box( h1(" The Ingredients That Make Bon Appetite"))),
            br(),
            fluidRow( box(
            p(" This page serves to explain Bon Appetite as a company."),
            p(" I will also discuss the top 100 ingredients Bon Appetite lists."),
            p(" Lastly, I will list my own personal information to tag this work as my own.")
                        ))
                ),
        
        tabItem( tabName = 'averages',
                 fluidPage(fluidRow(
                     
                     
                         h2( "Bon Appetite's Recipe Output"), 
                         br(),
                         h3("With the world becoming digital more and more each day, one would think online recipe publishing would be on the rise."),
                        h3("However, the past three years have seen a decline in recipe publishing"),
                        br(),
                        h4("This could be a sign of shifting values, for example boosting their video department and posting recipe creations on Youtube. More research would need to be 
                           done to evaluate the theory that less recipes are being published because more time and energy are being spent on the few recipes focused on each month."),
                         br(),
                     ),
                 fluidRow(
                     plotOutput("plot9"),
                     box(checkboxGroupInput("checkGroup1", label = h3("Years"), 
                                            choices = list("2015" = 2015, "2016" = 2016, "2017" = 2017, "2018" = 2018, "2019" = 2019, "2020" = 2020),
                                            selected = 2015)),
                     box(tableOutput('totals_table'))),
                 h2("Month by Month, for Each Year"),
                     fluidRow(box(plotOutput("plot2")),
                                  box(p("The graph to the left shows the distribution through the months for all five years. While 2020 hasn't reached its halfway point yet, there is still a considerable difference in the content output."),
                                      p("Another feature to look at: July seems to be a very slow month for the company in terms of new material. For the past two years, and this year included if trends continue, July consistently sees a drastic drop in new recipes published."))),
                 h2("Total Recipe Output, 2015-2020"),           
                 fluidRow(box(plotOutput("plot10")),
                                       box(p("Output in general it seems has been on the decline for a few years. The graph to the left clearly illustrates a lessening in new material since the past two years. Bon Appetit's online recipe peak looks to fall within 2016, where a total of 741 new recipes were published."),
                                           p("After a peak in 2016, following an almost as close year in 2017 with 724 recipes posted, content output swiftly declined. 2018 saw only 501 recipes, while 2019 only made it into the low 400s. The reduction in output might be a sign of shifting priorities in the company."),
                                           p("It's possible the shift in recipe output moved from quantity towards quality. Bon Appetit has become famous for its immaculate test kitchen as well-versed chefs--as seen in videos uploaded to their Youtube channel. With magazine sales struggling to compete with an online 
                                           world full of video 'how-to's and tasty recipes, it's possible this decline in recipes posted is in part due to Bon Appetit spending more time with the recipes through different mediums, like developing coorresponding videos." )))
                    
                 )),
        
        tabItem( tabName = 'ratings',
                 fluidPage(fluidRow( h1("Reviews and Ratings Through the Years")),
                    br(),
                    h2("Ratings"),                           
                    br(),
                    fluidRow(
                         box(width = 8, plotOutput("plot7")), 
                         #box(plotOutput("plot1")),
                    
                     box(width = 4, p("The graph to the left shows that, except for a few very negative people in 2016 and 2017,  recipes have been mostly well-rated.
                       In fact, the average lowest rating has had a general upward trend, with an average clustering around 4.0-5.0 stars from the end of 2018 to the present day."),
                                   p("It would seem that in late 2015, however, the rating system changed, as there is an unusual block of highly varied ratings within 2015.  
                                     After 2015, ratings seem to often snap to whole numbers, e.g. '3.0', '4.0', and '5.0'.")
                     )),
                    h2("Reviews"),
                     fluidRow(box(width = 10, p("The review count below on the left shows an increase in multiple reviews being written per recipe. This is matched with an overall increase in reviews written in general, as demonstrated in the chart below on the right."),
                         p("There seems to be a consistent increase of reviews written during the spring time and around the holidays. A considerable dip in customer engagement is noticed each summer.")
                         )
                         ### ADD A TABLE TOTALLING REVIEWS WRITTEN
                     ),
                 fluidRow(
                     box(plotOutput("plot3")), 
                     box(plotOutput("plot8"))))),
        
        tabItem( tabName = 'ingredients',
                 ## LOOK INTO BUBBLE CHART
                 fluidPage(
                     fluidRow(
                         box(width = 7, solidHeader = TRUE, h1("The Trends in Ingredients")),
                         hr(),
                         box(width = 8, h3("Bon Appetit's Top Repeated Ingredients"),
                         br(),
                         h4("While Bon Appetit quite frequently opens our eyes to new ingredients or food pairings we might not have thought would work,
                            there are still particular staples that one can never be without when cooking."),
                     bubblesOutput("ingred_bubbles", width = "100%", height = 600)
                         ),
                     box(width = 4, title = "Top Ingredients from 2015-2020", dataTableOutput("pop_ingred_table"))),
                     fluidRow(
                         h2("Specific Ingredient Trends"),
                         br(),
                         selectInput("ingred_choice", label = h3("Select Ingredient"), 
                                     choices = list("Kale" = "kale", "Oranges" = "oranges", "Pears" = "pears", "Lemons" = "lemon",
                                                    "Limes" = "lime"), 
                                     selected = "kale"),
                         plotOutput("plot11")
                         
                     ),
                 fluidRow(
                     # infoBoxOutput("max1"),
                     # infoBoxOutput("max2"),
                     # infoBoxOutput("max3"),
                     # infoBoxOutput("max4"),
                     # infoBoxOutput("max5"),
                     # infoBoxOutput("max6"),
                     # infoBoxOutput("max7"),
                     # infoBoxOutput("max8"),
                     # infoBoxOutput("max9"),
                     # infoBoxOutput("max10")
                 ))),
        
        tabItem( tabName = 'corona',
                 box(plotOutput("plot4")),
                 fluidRow(box(plotOutput("plot5"))),
                 fluidRow(box(plotOutput("plot6")))
                 )
            )
        )
    )
)
