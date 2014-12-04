###############################################################################
# R Script
#
# This script generates Plot 3, which is part of Course Project 1.
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
png(filename = "plot3.png",
    width = 480,
    height = 480
   )

# Make the base plot with one of three sets of X data.
plot(hpcData$Time, hpcData$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energy sub metering"
    )

# Add the other two sets of data.
lines(hpcData$Time, hpcData$Sub_metering_2, col = "red")
lines(hpcData$Time, hpcData$Sub_metering_3, col = "blue")

# Add the legend.
legend("topright", lty = 1, lwd = 1,
        col    = c("black",          "red",            "blue"          ),
        legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
      )

# Close the graphics device
dev.off()
