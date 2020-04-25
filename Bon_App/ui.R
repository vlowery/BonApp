library(shinydashboard)

shinyUI(dashboardPage(
    dashboardHeader(title = "Bon Appetite"),
    dashboardSidebar(sidebarMenu(
        menuItem("Introductions", tabName = "intro", icon = icon("info")),
        menuItem("Broad Picture", tabName = "averages", icon = icon("calendar")),
        menuItem("Reviews/Ratings", tabName = "ratings", icon = icon("thumbs-up")),
        menuItem("Ingredients Trends", tabName = "ingredients", icon = icon("lemon")),
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
                 fluidRow(
                     box(plotOutput("plot1")),
                     
                     box(
                         "Bon Appetite's recipe output through the years for particular months.", 
                         br(),
                         radioButtons("radio1", label = h3("Months"), choices = list("January" = 01, 
                                        "February" = 02, "March" = 03, "April" = 04, "May" = 05, "June" = 06, 
                                        "July" = 07, "August" = 08, "September" = 09, "October" = 10, "November" = 11, "December" = 12), 
                                      selected = 01)
                         )
                     ),
                 fluidRow(
                     box(plotOutput("plot2")),
                     
                     box(
                         radioButtons("radio2", label = h3("Years"), choices = list("2015" = 2015, "2016" = 2016, 
                                     "2017" = 2017, "2018" = 2018, "2019" = 2019, "2020" = 2020))
                     )
                    )
                 ),
        
        tabItem( tabName = 'ratings'
                 ),
        
        tabItem( tabName = 'ingredients',
                 fluidRow(
                     infoBoxOutput("max1"),
                     infoBoxOutput("max2"),
                     infoBoxOutput("max3"),
                     infoBoxOutput("max4"),
                     infoBoxOutput("max5"),
                     infoBoxOutput("max6"),
                     infoBoxOutput("max7"),
                     infoBoxOutput("max8"),
                     infoBoxOutput("max9"),
                     infoBoxOutput("max10")
                 )),
        
        tabItem( tabName = 'corona'
                 )
            )
        )
    )
)
