function(input, output) {
  
  output$plot1 <- renderPlotly({
    
    # Create a function to divide Continent into three parts.
    convert_continent <- function(y){ 
      if( y == "Western Europe" | y == "Central and Eastern Europe" | y == "Commonwealth of Independent States"){
        y <- "Europe"
      }else 
        if(y == "Sub-Saharan Africa" | y == "Middle East and North Africa"){
          y <- "Africa" 
        }else 
          if(y == "South Asia" | y == "Southeast Asia" | y== "East Asia"){
            y <- "Asia"  
          }else 
            if(y == "Latin America and Caribbean"){
              y <- "South America"
            }else{
              y <- "North America and Australia" 
            }  
    }
    
    # Create a variable called Cat.Continent by using `sapply` and transform data type into factor. Then, check dataframe by using `str()`
    happy$Cat.Continent <- sapply(X = happy$Continent, FUN = convert_continent) 
    happy$Cat.Continent <- as.factor(happy$Cat.Continent)
    
    # visualisasi untuk plot1
    plot1 <- happy %>% 
      filter(year==input$year_data_1) %>% 
      ggplot(mapping =aes(x = Healthy, size= Log.GDP, y= Score,  fill= Cat.Continent, 
                          text = glue("Country :{Country}\nLife Satisfaction Score: {round(Score,2)}\nLog GDP per capita : {round(Log.GDP,2)}\nLife Expentancy :{round(Healthy,2)}"))) +
      geom_point(alpha=0.5, shape=21, color="white") +
      scale_size(range = c(0, 12), name="") +
      scale_fill_manual(values = wes_palette(5, name = "Darjeeling1"), name = "Continent")  +
      scale_x_continuous(breaks = seq(40,80, by=10), limits = c(40,80))+
      ylim(2,9)+
      labs(x = "Life Expectancy", y = "Life Satisfaction Score",
           title = "Correlation between Life Satisfaction Score,\n Age Expectency, and GDP",
           caption = "Source: The World Happiness Report")+
      
      theme_set(theme_minimal() + theme(text = element_text(family="Arial Narrow"))) +
      theme(plot.title = element_text(size= 17, color = 'black', face ='bold'),
            plot.subtitle = element_text(size = 8),
            plot.caption = element_text(size = 10),
            axis.title.x = element_text(size=13, color = 'black'),
            axis.title.y = element_text(size = 13, color = 'black'),
            axis.text.x = element_text(size = 12, color = 'black'),
            axis.text.y = element_text(size = 13, color = 'black'),
            legend.text = element_text(size = 11, color = 'black'),
            legend.title = element_text(size = 12, color = 'black'),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.line = element_line(colour = "black"),
            legend.position = "bottom"
      ) 
    
    ggplotly(plot1, tooltip = "text") %>% 
      layout(title = list(text = paste0('Correlation between Life Satisfaction Score, Age Expectancy, and GDP by Continent',
                                        '<br>',
                                        '<sup>',
                                        'The size of bubbles illustrates the size of log GDP per capita for each country',
                                        '</sup>')))
    
    
  })
  
  output$plot2 <- renderPlotly({
    
    # Create world3 
    world3<- happy %>% 
      group_by(Country) %>% 
      select(Country, Score, year)
    
    # pivot_wider so that all NA value in year can be fill up with 0
    world3<- pivot_wider(data=world3,
                         names_from="year",
                         values_from="Score")
    
    world3[is.na(world3)] <- 0
    
    # Back to pivot_longer
    world3 <- pivot_longer(
      data= world3,
      cols=c("2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021")
    )
    
    # Change the coloum name
    colnames(world3) <- c("Country", "year", "Score")
    
    # Grab the CODE for each Country 
    df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv')
    df <- df %>% 
      rename(Country=COUNTRY) %>% 
      mutate(Country=as.factor(Country)) %>% 
      mutate(Country =recode(Country, 
                             'Congo, Democratic Republic of the'="Congo (Kinshasa)",
                             'Congo, Republic of the'="Congo (Brazzaville)"))
    
    
    # Left join between world3 and df and assign as world4
    world4 <- left_join(world3,df, by="Country")
    
    # light grey boundaries
    l <- list(color = toRGB("white"), width = 0.5)
    
    # specify map projection
    g <- list(
      showframe = FALSE,
      showcoastlines = FALSE,
      projection = list(type = 'Mercator')
    )
    
    plot2 <- world4 %>% 
      filter(year==input$year_data) %>% 
      plot_geo()%>% 
      add_trace(
        z = ~Score, 
        color = ~Score,
        colors = "Spectral",
        text = ~Country, 
        locations = ~CODE, 
        marker = list(line = l))%>% 
      layout(
        title = list(text='', y=0.95, x=0.55, face="bold", size=40),
        geo = g) %>% 
      colorbar(title = "Score") 
    
    
    plot2
    
    
  })
  
  output$plot3 <- renderPlotly({
    
    # Create a function to divide Continent into three parts.
    convert_continent <- function(y){ 
      if( y == "Western Europe" | y == "Central and Eastern Europe" | y == "Commonwealth of Independent States"){
        y <- "Europe"
      }else 
        if(y == "Sub-Saharan Africa" | y == "Middle East and North Africa"){
          y <- "Africa" 
        }else 
          if(y == "South Asia" | y == "Southeast Asia" | y== "East Asia"){
            y <- "Asia"  
          }else 
            if(y == "Latin America and Caribbean"){
              y <- "South America"
            }else{
              y <- "North America and Australia" 
            }  
    }
    
    # Create a variable called Cat.Continent by using `sapply` and transform data type into factor. Then, check dataframe by using `str()`
    happy$Cat.Continent <- sapply(X = happy$Continent, FUN = convert_continent) 
    happy$Cat.Continent <- as.factor(happy$Cat.Continent)
    
    plot3 <- happy %>% 
      filter(year == input$year_data_3) %>% 
      ggplot(aes(x = Score, group = Cat.Continent, fill=Cat.Continent))+
      scale_fill_manual(values = wes_palette(5, name = "Darjeeling1"), name = "Continent") +
      geom_density(adjust=5, alpha=.7, color="white") +
      xlim(0,10)+
      labs(
        x = "Life Satisfaction Score", y = "", fill = "",
        title = "Distribution Plot of Life Satisfaction Score by Continent",
        caption = "Source : The World Happiness Report 2021") +
      theme_set(theme_minimal() + theme(text = element_text(family="Arial Narrow"))) +
      theme(plot.title = element_text(size= 17, color = 'black', face ='bold'),
            plot.subtitle = element_text(size = 8),
            plot.caption = element_text(size = 10),
            axis.title.x = element_text(size=13, color = 'black'),
            axis.title.y = element_text(size = 13, color = 'black'),
            axis.text.x = element_text(size = 12, color = 'black'),
            axis.text.y = element_text(size = 13, color = 'black'),
            legend.text = element_text(size = 11, color = 'black'),
            legend.title = element_text(size = 12, color = 'black'),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.line = element_line(colour = "black"),
            legend.position = "bottom")
    
    
    ggplotly(plot3, tooltip = "x") %>% 
      layout(title = list(text = paste0('Distribution Plot of Life Satisfaction Score by Continent',
                                        '<br>',
                                        '<sup>',
                                        '',
                                        '</sup>')))
    
  })
  
  output$plot4 <- renderPlotly({
    
    plot4 <- happy %>% 
      mutate(year=as.numeric(as.character(year))) %>%
      filter(Country == input$country1 | Country==input$country2 | Country==input$country3 | Country == input$country4) %>% 
      ggplot(aes(x=year, y = Score, label = Score, group=1, text=glue("Score: {round(Score,2)}\nYear : {year}")))+ 
      geom_point(aes(color = Country), size=.09)+
      geom_line(aes(color = Country, group=1))+
      scale_color_manual(values = wes_palette(4, name = "Darjeeling1"))+
      xlim(2005, 2021)+
      ylim(3,9)+
      theme_minimal() +
      labs(x = "", y = "Life Satisfaction Score",
           title = "Life Satisfaction Score Between Country",
           caption = "Source: The World Happiness Report")+
      
      theme_set(theme_minimal() + theme(text = element_text(family="Arial Narrow"))) +
      theme(plot.title = element_text(size= 20, color = 'black', face ='bold'),
            plot.subtitle = element_text(size = 8),
            plot.caption = element_text(size = 10),
            axis.title.x = element_text(size=13, color = 'black'),
            axis.title.y = element_text(size = 13, color = 'black'),
            axis.text.x = element_text(size = 12, color = 'black'),
            axis.text.y = element_text(size = 13, color = 'black'),
            legend.text = element_text(size = 11, color = 'black'),
            legend.title = element_text(size = 12, color = 'black'),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.line = element_line(colour = "black"),
            legend.position = "bottom")
    
    ggplotly(plot4, tooltip = "text")%>% 
      layout(hovermode = 'x',
             title = list(text = paste0('Movement of Life Satisfaction Score',
                                        '<br>',
                                        '<sup>',
                                        'Choose up to four countries to observe score movement from 2005 and 2021',
                                        '</sup>')))
    
    
    
    
    
    
  })
  
  output$plot6 <- renderPlotly({
    
    plot6 <- happy %>% 
      filter(year==input$year_data_3) %>% 
      arrange(-Score) %>% 
      head(7) %>% 
      ggplot(aes(x=Score, y=reorder(Country, Score), text=glue("Score: {round(Score,2)}")))+
      geom_col(aes(fill=Score))+
      scale_fill_gradientn(colors=wes_palette("FantasticFox1", 10, type = "continuous"))+
      labs(title="Top Seven Countries with The Highest Score",
           y="",
           x="Score")+
      xlim(0,10)+
      theme_set(theme_minimal() + theme(text = element_text(family="Arial Narrow"))) +
      theme(plot.title = element_text(size= 17, color = 'black', face ='bold'),
            plot.subtitle = element_text(size = 8),
            plot.caption = element_text(size = 10),
            axis.title.x = element_text(size=12, color = 'black'),
            axis.title.y = element_text(size = 12, color = 'black'),
            axis.text.x = element_text(size = 12, color = 'black'),
            axis.text.y = element_text(size = 12, color = 'black'),
            legend.text = element_text(size = 11, color = 'black'),
            legend.title = element_text(size = 12, color = 'black'),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.line = element_line(colour = "black"),
            legend.position = "bottom")
    
    
    ggplotly(plot6, tooltip = "text")%>% 
      layout(title = list(text = paste0('Top Seven Countries with The Highest Score',
                                        '<br>',
                                        '<sup>',
                                        '',
                                        '</sup>')))
    
    
    
    
  })
  
  output$data_happy<- renderDataTable({
    datatable(happy,
              caption = "Data sets are created by 'The World Happiness Report' and the csv file 'the Kaggle website' (https://www.kaggle.com/ajaypalsinghlo/world-happiness-report-2021)",
              options = list(
                initComplete = JS(
                  "function(settings, json) {",
                  "$('body').css({'font-family': 'Arial Narrow'});",
                  "}")))
              })
  
  
  
}

