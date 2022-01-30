library(dplyr)
library(ggplot2)
library(ggthemes)
library(tidyr)
library(wesanderson)
library(shinydashboard) 
library(shiny)  
library(tidyverse) 
library(glue) 
library(plotly) 
library(DT) 
library(shinyWidgets)
library(fresh)


mytheme <- create_theme(
  adminlte_color(
    light_blue = "black"
  ),
  adminlte_sidebar(
    width = "200px",
    dark_bg = "#5d6063",
    dark_hover_bg = "black",
    dark_color = "#2E3440"
  ),
  adminlte_global(
    content_bg = "white",
    box_bg = "white", 
    info_box_bg = "white"
  )
)


# Data set covers from 2006 to 2020. 
data1 <- read.csv("world-happiness-report.csv")

# Data set covers 2021 
data2 <- read.csv("world-happiness-report-2021.csv")

# cleaning data 
data1 <- data1 %>% 
  select(Country = Country.name, 
         year, Social.support, Generosity,
         Score = Life.Ladder,  
         Log.GDP = Log.GDP.per.capita, 
         Healthy= Healthy.life.expectancy.at.birth, 
         Freedom=Freedom.to.make.life.choices, 
         Corruption=Perceptions.of.corruption)  

data2 <- data2 %>% 
  select(Country = Country.name,
         Continent= Regional.indicator,
         Score = Ladder.score ,  
         Log.GDP = Logged.GDP.per.capita, 
         Healthy= Healthy.life.expectancy, 
         Freedom=Freedom.to.make.life.choices, 
         Corruption=Perceptions.of.corruption,
         Social.support, Generosity) %>% 
        mutate(year=2021)

# Selecting country and Continent columns in data2 and naming it continent
continent <- data2 %>% 
  select(Country, Continent) 

# Full join data1 and continent by country that creates a new `happy`
data1 <- full_join(data1, continent, by = "Country") 

# Stacking data1 and data2 and naming the newdataframe data
happy <- bind_rows(data1, data2)

# Fill missing values
happy <- happy %>%
  mutate(
    Continent = case_when(Country =="Angola" | Country == "Central African Republic" |
                            Country == "Congo (Kinshasa)" | Country == "Djibouti"| 
                            Country == "Somalia" | Country == "Somaliland region"|
                            Country == "South Sudan" | Country == "Sudan"
                          ~ "Sub-Saharan Africa", TRUE ~ Continent )) %>% 
  mutate(
    Continent = case_when(Country == "Belize" | Country == "Cuba" | Country == "Guyana" |
                            Country == "Suriname" | Country == "Trinidad and Tobago"
                          ~ "Latin America and Caribbean", TRUE ~ Continent )) %>% 
  mutate(
    Continent = case_when(Country == "Oman" |  Country == "Qatar" | Country == "Syria"
                          ~ "Middle East and North Africa", TRUE ~ Continent )) %>% 
  mutate(
    Continent = case_when(Country == "Bhutan"
                          ~ "South Asia", TRUE ~ Continent ))

#Transform data frame
happy <- happy %>% 
  mutate_if(is.character, as.factor) %>% 
  mutate(year=as.factor(year)) 

