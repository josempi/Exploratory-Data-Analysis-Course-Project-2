######################################################################################################
##                                                                                                  ##
## This is the Exploratory Data Analysis Assignment1 R script                                       ##
## Title: Plot 2                                                                                    ##
## Week 4                                                                                           ##
##                                                                                                  ##
## Author: Jose M. Pi                                                                               ##
## Date: 1/5/2018                                                                                   ##
## Version 1.0                                                                                      ##
## File source: EPA National Emissions Inventory                                                    ##
## Link: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip                         ##
## Environment: RStudio 1.0.153, R version 3.4.3                                                    ##
## Question: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland              ##
##           (fips == "24510") from 1999 to 2008?                                                    ##
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
## library(ggplot2) - using base plotting functions only
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

##############################
##  DATA LOADING SECTION    ##
##############################

## Emissions Data ##
## Load the PM2.5 Emissions data file into the NEI data frame   
NEI <- readRDS("summarySCC_PM25.rds")

## Load the Source Classification data file into the SCC data frame   
SCC <- readRDS("Source_Classification_Code.rds")

## Clean up Table - Delete all NA rows ##
## NEI table does not contain NA values

## Subset the data for fips == 24510 (City of Baltimore, Maryland)
NEIBaltimore <- subset(NEI, fips=="24510")

######################################
##  FORMAT DATE AND TIME FIELDS     ##
######################################

## Not required - the "year" file in the NEI table is integer type as can be used as is

###############################################
##  Summarize the data by the year field     ##
###############################################

## Group Data by year ##
NEIgroups <- group_by(NEIBaltimore, NEIBaltimore$year)

## Summarize the Data with the mean Emissions for each year ##
NEIsummary <- summarize(NEIgroups, count = n(), SPM2.5 = sum(Emissions, na.rm = T))

##############################
##  Run and Print Plot      ##
##############################

## Run and display the Plot ##
barplot(height=NEIsummary$SPM2.5, names.arg=NEIsummary$`NEIBaltimore$year`, xlab="Years", ylab=expression('Total PM2.5 Emissions'),
        main=expression('City of Baltimore, Maryland, PM2.5 Total Emissions'), col = "red")


## Print the plot to a file
png(filename = "plot2.png", width = 480, height = 480)
barplot(height=NEIsummary$SPM2.5, names.arg=NEIsummary$`NEIBaltimore$year`, xlab="Years", ylab=expression('Total PM2.5 Emissions'),
        main=expression('City of Baltimore, Maryland, PM2.5 Total Emissions'), col = "red")
dev.off()
