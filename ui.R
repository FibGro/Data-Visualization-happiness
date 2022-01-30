# untuk design header
header <- dashboardHeader(title = "Life Satisfaction Score")


# untuk design sidebar
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(text = "World Map", icon = icon("globe"), tabName = "map"), # menu 1
    menuItem(text = "Score Movement", icon = icon("chart-line"), tabName = "mov"),
    menuItem(text = "Correlation", icon = icon("connectdevelop"), tabName = "corr"),
    menuItem(text = "Data", icon = icon("table"), tabName = "dat")
    # menu 4
  )
)


# untuk design body dashboard
body <- dashboardBody(
  
  tags$head(tags$style(HTML('/* logo */.skin-blue .main-header .logo {background-color: #E7FF6E;font-family:"Arial Narrow"; font-size: 20px; height:50px;}'))),
  tags$style(HTML(".main-sidebar { font-family:'Arial Narrow'; font-size: 16px; }")),
  tags$p(tags$style(HTML('.box {font-family:"Arial Narrow"; font-size: 17px;}'))),
  tags$p(tags$style(HTML('.nav-tabs>li>a {font-family: "Arial Narrow";font-size: 18px;}'))),
  tags$head(tags$style(type='text/css', ".slider-animate-button { font-size: 16pt !important;}")),
  

  
  
  
 
  use_theme(mytheme),
  
  tabItems(
    # menu tab 1
    tabItem(tabName = "map",
            
            fluidPage(
                mainPanel(width=12,
                
                    h1(strong("Global Life Satisfaction Score"), style = "font-size:30px; font-family: 'Arial Narrow'; color: black;"),
                    br(),
                    p("Are people happy? And are they happier now than in the past? Those questions are very difficult to answer due to the uncertainty of the happiness definition. However",a(href = "https://worldhappiness.report/",
                      "The World Happiness Report"), "generates regularly annual report regarding global happiness and life satisfaction. The score is based on the pooled results from,"  ,a(href = "https://www.gallup.com/analytics/318875/global-research.aspx",
                                                                                                                                                                                             "Gallup World Poll") ,", which is a set of the representative survey more than 160 countries. The survey itself asked: On which step ladder do you imagine your life is?. The possible highest and lowest of level satisfaction is 10 and  0, respectively. This life satisfaction scale is called" , a(href = "https://news.gallup.com/poll/122453/understanding-gallup-uses-cantril-scale.aspx",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     "Cantril Ladder method"), ".The score itself incorporates six factors, which are economic production, social support, life expectancy, freedom, absence of corruption, and generosity. The factors do not affect the total score assigned for each country, but they do describe why some countries rank higher than others. Below animate plot illustrates world life satisfaction score over period of ten years.", style = "font-size:20px; font-family: 'Arial Narrow'; color: black;"), 
                   
                 )
                
              )
            ,
            
            fluidRow(
              column(width = 12, 
                     plotlyOutput(outputId = "plot2", height ="500px"))
            ),
            fluidRow(
              column(3, offset = 5,
                     chooseSliderSkin("Flat"),
                  sliderInput(inputId = "year_data",
                              label = "Year:",
                              min = 2010,
                              max =2021,
                              value= 2010,
                              sep="",
                              animate = TRUE))
              ),
            
    ),

    tabItem(tabName = "corr", 
            fluidRow(
              
              column(width = 12, 
                     plotlyOutput(outputId = "plot1", height ="600px")
            )),# break line untuk jarak 1 enter pada plot1 dan plot2

            fluidRow(
              column(4, offset=4, height="50px",
                     chooseSliderSkin("Modern"),
                     sliderInput(inputId = "year_data_1",
                                 label = "Year:",
                                 min = 2010,
                                 max =2021,
                                 value= 2010,
                                 sep="",
                                 animate = TRUE),
                     tags$script("$(document).ready(function(){
                        setTimeout(function() {$('.slider-animate-button').click()},15);
                    });"))
              
    
            )
              
            ),
    
  tabItem(tabName = "mov",
          fluidRow(
            
            tabBox(width=12,  id = "tabset1", height= "800px",
                   
             
              
              
              tabPanel( strong("Line Chart"), 
               box(width = 9, title = "", status = "warning",
                column(width=12,
                       plotlyOutput(outputId = "plot4", height ="450px"))),
            
               box(width = 3, title = "", status = "warning",
                selectInput(inputId = "country1",
                            choices = levels(happy$Country),
                            selected= "Finland",
                            label = "Choose Country 1:"),
                selectInput(inputId = "country2",
                            choices = levels(happy$Country),
                            selected= "Indonesia",
                            label = "Choose Country 2:"),
                selectInput(inputId = "country3",
                            choices = levels(happy$Country),
                            selected = "South Africa",
                            label = "Choose Country 3:"),
                selectInput(inputId = "country4",
                            choices = levels(happy$Country),
                            selected = "Australia",
                            label = "Choose Country 4:")
            )),
          
            
            tabPanel(strong("Distribution and Bar Chart"), 
                     
            fluidRow(
              
      
              column(4, offset=4, height="50px",
                       chooseSliderSkin("Big"),
                       sliderInput(inputId = "year_data_3",
                                   label = "Year:",
                                   min = 2010,
                                   max =2021,
                                   value= 2010,
                                   sep="",
                                   animate = TRUE)),
              
            box(width = 6, title = "", status = "warning",
            column(width = 12,
                   plotlyOutput(outputId = "plot6", height ="400px"))),
            
    
            box(width = 6, title = "", status = "warning",
            column(width = 12,
                   plotlyOutput(outputId = "plot3", height ="400px"))
            
          )
          
            )
          
          ))
          
          )),
  
  
  tabItem(tabName = 'dat',
          fluidRow(column(width = 12, title = "Dataset",
                          dataTableOutput(outputId = "data_happy"))
          ))
 
  
 
  
  ))


# untuk menggabungkan header, sidebar, dan body dalam 1 page dashboard
dashboardPage(header = header, sidebar = sidebar, body = body)

