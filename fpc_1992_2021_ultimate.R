#This R-script will import a cleaned csv dataset for percent change in CPI of various food items
#Data is from USDA ERS
#After loading the csv file, it will be restructured with melt()
#Restructured data will be plotted with ggplot2 and plotly

# Clear your workspace
rm(list = ls())

getwd()
#Set the working directory
setwd("/m13/Documents/R")

#Import data
#Note: assigned the read.csv to variable fpc (food price change)
#Note: check.names = False overrides the check.names argument of prepending X to numbers
#Note: fileEncoding="UTF-8-BOM" solves the bizarre character input to "Item" cell
fpc <- read.csv("FPC_1992_2021.csv", check.names = FALSE, fileEncoding="UTF-8-BOM")
#View data
fpc

#Alternative way to load FPC data by selecting via file explorer UI
fpc <- read.csv(file.choose(), check.names = FALSE, fileEncoding="UTF-8-BOM")

#Quickly reference plotting documentation
?plot

install.packages("plotly")  #Install plotly package
install.packages("ggplot2")  #Install ggplot2 package
install.packages("reshape2")  #Install reshape package
install.packages("quantmod")  #Install quantmod package

library(reshape2)  #Load reshape2
library(ggplot2)  #Load ggplot2 
library(plotly)  #Load the plotly package
library(quantmod) #Load the quantmod package

#melt fpcdata frame to collapse the row of years into one column
#conserve "Item" column and enumerate newly created "Years" column with corresponding values
fpc_long <- melt(data = fpc, 
                 id.vars = c("Item"),
                 variable.name = "Year",
                 value.name = "PercentChange")

#Generate plot and assign to p
p <- ggplot(data=fpc_long, aes(x=Year, y=PercentChange, group = Item, color = Item)) +
  geom_point()+
  geom_line() +
  labs(title = " %Δ CPI of Various Food Items 1992-2021", y = "%Δ CPI") +
  theme(axis.text.x = element_text(angle = 315)) +
  scale_y_continuous(breaks = seq(-25, 30, by = 5))

#Assign plotly figure of p to fig
fig <- ggplotly(p)
#Add range slider to x-axis
fig <- fig %>% layout(
  xaxis = list(rangeslider = list(type = "Year")))
#Generate the figure
fig
