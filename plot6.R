######################################################################################################
##                                                                                                  ##
## This is the Exploratory Data Analysis R script for Course Project 2                              ##
## Title: Plot 6                                                                                    ##
## Week 4                                                                                           ##
##                                                                                                  ##
## Author: Jose M. Pi                                                                               ##
## Date: 1/6/2018                                                                                   ##
## Version 1.0                                                                                      ##
## File source: EPA National Emissions Inventory                                                    ##
## Link: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip                         ##
## Environment: RStudio 1.0.153, R version 3.4.3                                                    ##
## Question: How have emissions from motor vehicles sources chnaged from 1999-2008 in Baltimore     ##
##           City?                                                                                  ##
##                                                                                                  ##
######################################################################################################


##############################
##  SETUP WORKING DIRECTORY ##
##############################
setwd("~/Documents/Data Science/Exploratory Data Analysis/Week 4")
## Create the subdirectory "data" if not already found.
if(!file.exists("./Data")){dir.create("./Data")}
setwd("~/Documents/Data Science/Exploratory Data Analysis/Week 4/Data")

######################
##  LOAD LIBRARY    ##
######################
library(ggplot2) 
library(dplyr)

##############################
##  FILE RETRIEVAL SECTION  ##
##############################
## Get the zip file for the project.
## Assign the file link/ location to fileUrl.
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
## Download the file
download.file(fileUrl,destfile="./Dataset.zip",method="curl")

## Unzip the file contents into the data subdirectory.
unzip(zipfile="./Dataset.zip")

#############################################
##  DATA LOADING SECTION AND PREPARATION   ##
#############################################

## Emissions Data ##
## Load the PM2.5 Emissions data file into the NEI data frame   
NEI <- readRDS("summarySCC_PM25.rds")

## Load the Source Classification data file into the SCC data frame   
SCC <- readRDS("Source_Classification_Code.rds")

## Clean up Table - Delete all NA rows ##
## NEI table does not contain NA values

## Subset the data for fips == 24510 (City of Baltimore, Maryland), fips == 06037 (Los Angeles) and type == ON-ROAD
## Per the National Emissions Inventory (NEI) website, most motor vehicle emissions may be measured 
## via the "ON-RAOD" variable
## Ref: https://www.epa.gov/air-emissions-inventories/national-emissions-inventory-nei

## Subset for City of Baltimore and Los Angeles
NEIsubset <- subset(NEI, fips=="24510" | fips == "06037")

## Subset for ON-ROAD
NEIsubset <- subset(NEIsubset, type == "ON-ROAD")

## Sort the Data by Year and FIPS
NEIsubset <- arrange(NEIsubset, year, fips)

######################################
##  FORMAT DATE AND TIME FIELDS     ##
######################################

## Not required - the "year" file in the NEI table is integer type as can be used as is

###############################################
##  Summarize the data by the year field     ##
###############################################

## Group Data by year ##
NEIgroups <- group_by(NEIsubset, NEIsubset$year, NEIsubset$fips)

## Summarize the Data with the mean Emissions for each year ##
NEIsummary <- summarize(NEIgroups, count = n(), SPM2.5 = sum(Emissions, na.rm = T))

## Rename the "type" column to a cleaner name
colnames(NEIsummary)[colnames(NEIsummary) == 'NEIsubset$fips'] <- 'fips_Location_Code'

##############################
##  Run and Print Plot      ##
##############################

## Run and display the Plot ##
ggplot(data=NEIsummary, aes(x=NEIsummary$`NEIsubset$year`, y=NEIsummary$SPM2.5, color = fips_Location_Code)) + 
    geom_line(size=1.5) +
    geom_point(size=3) +
    xlab("Years") + ylab("Total PM2.5 Emissions") +
    ggtitle("Baltimore City (fips 24510) and Los Angeles (fips 06037), PM2.5 Total Vehicle Emissions")

## Print the plot to a file
png(filename = "plot6.png", width = 600, height = 480)
ggplot(data=NEIsummary, aes(x=NEIsummary$`NEIsubset$year`, y=NEIsummary$SPM2.5, color = fips_Location_Code)) + 
    geom_line(size=1.5) +
    geom_point(size=3) +
    xlab("Years") + ylab("Total PM2.5 Emissions") +
    ggtitle("Baltimore City (fips 24510) and Los Angeles (fips 06037), PM2.5 Total Vehicle Emissions")
dev.off()
