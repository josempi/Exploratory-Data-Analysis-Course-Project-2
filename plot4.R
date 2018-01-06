######################################################################################################
##                                                                                                  ##
## This is the Exploratory Data Analysis R script for Course Project 2                              ##
## Title: Plot 4                                                                                    ##
## Week 4                                                                                           ##
##                                                                                                  ##
## Author: Jose M. Pi                                                                               ##
## Date: 1/5/2018                                                                                   ##
## Version 1.0                                                                                      ##
## File source: EPA National Emissions Inventory                                                    ##
## Link: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip                         ##
## Environment: RStudio 1.0.153, R version 3.4.3                                                    ##
## Question: Accross the United States, how have emissions from coal combustion related sources     ##
##           changed from 1999-2008?                                                                ##
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

## Merge the NEI and SCC tables ##
NEISCC <- merge(NEI, SCC, by = "SCC")

## Subset the data for coal combustion-related sources ##
## ID the records that contain the word "coal" in the "Short.Name" field
NEISCCselect  <- grepl("coal", NEISCC$Short.Name, ignore.case=TRUE)

## Subset the selected records
NEISCCsubset <- NEISCC[NEISCCselect, ]


######################################
##  FORMAT DATE AND TIME FIELDS     ##
######################################

## Not required - the "year" file in the NEI table is integer type as can be used as is

###############################################
##  Summarize the data by the year field     ##
###############################################

## Group Data by year ##
NEIgroups <- group_by(NEISCCsubset, NEISCCsubset$year, NEISCCsubset$type)

## Summarize the Data with the mean Emissions for each year ##
NEIsummary <- summarize(NEIgroups, count = n(), SPM2.5 = sum(Emissions, na.rm = T))

## Rename the "type" column to a cleaner name
colnames(NEIsummary)[colnames(NEIsummary) == 'NEISCCsubset$type'] <- 'Sample_Source'

##############################
##  Run and Print Plot      ##
##############################

## Run and display the Plot ##
ggplot(data=NEIsummary, aes(y=NEIsummary$SPM2.5, x=NEIsummary$`NEISCCsubset$year`, color = Sample_Source)) + 
    geom_line(size=1.5) +
    geom_point(size=3) +
    xlab("Years") + ylab("Total PM2.5 Emissions") +
    ggtitle("United States Total Coal Combustion-Related Emissions")


## Print the plot to a file
png(filename = "plot4.png", width = 480, height = 480)
ggplot(data=NEIsummary, aes(y=NEIsummary$SPM2.5, x=NEIsummary$`NEISCCsubset$year`, color = Sample_Source)) + 
    geom_line(size=1.5) +
    geom_point(size=3) +
    xlab("Years") + ylab("Total PM2.5 Emissions") +
    ggtitle("United States Total Coal Combustion-Related Emissions")
dev.off()
