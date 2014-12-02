###############################################################################
# R Script
#
# This script generates Plot 1, which is part of Course Project 1.
# Class: Exploratory Data Analysis, Coursera Data Science Sequence
# 
# Author: G. S. Averill
###############################################################################

# Path to the source data.
sourceDataURL <- "https://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"

# Name of the file to extract from the .zip archive.
sourceDataFileName <- "household_power_consumption.txt"

# Download the .zip archive, extract the data file, and load the data from the
# file into a data frame.
tmpFile <- tempfile()
download.file(sourceDataURL,tmpFile, method = "curl")
hpcData <- read.table(unz(tmpFile, sourceDataFileName),
                      header = TRUE, 
                      sep = ";",
                      na.strings = "?" # NAs are represented by "?"s.
                     )
unlink(tmpFile)

# Convert the Date and Time column values, which read.table() brought in as 
# factors, into Date and POSIXlt types.
hpcData$Time <- strptime(paste(hpcData$Date, hpcData$Time), 
                         paste("%d/%m/%Y",   "%H:%M:%S"  )
                        )
hpcData$Date <- as.Date(hpcData$Date, "%d/%m/%Y")

# Grab the subset of the data frame that covers February 1-2, 2007.
beginDate <- as.Date("2007-02-01")
endDate   <- as.Date("2007-02-02")
hpcData <- hpcData[((hpcData$Date >= beginDate) & (hpcData$Date <= endDate)), ]

# Open a PNG graphics device.
png(filename = "plot1.png", 
    width = 480,
    height = 480
   )

# Make the plot.
hist(hpcData$Global_active_power,
     col = "red1",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)"
    )

# Close the graphics device
dev.off()
