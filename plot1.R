###############################################################################
# R Script
#
# This script generates Plot 1, which is part of Course Project 1.
# Class: Exploratory Data Analysis, Coursera Data Science Sequence
# 
# Author: G. S. Averill
###############################################################################

# URL for the source data .zip archive.
sourceDataZipURL <- "https://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"

# Name of the file to extract from the .zip archive.
sourceDataFile <- "household_power_consumption.txt"

# Download the .zip archive to a temporary file if it's not alreadly 
# available locally.
zipFile <- basename(sourceDataZipURL)
if (!file.exists(zipFile)) {
    # no local copy found of the .zip archive
    zipFile <- tempfile()
    download.file(sourceDataZipURL, zipFile, method = "curl")
    downloadedTempCopy <- TRUE
} else {
    # found local copy of the .zip archive
    downloadedTempCopy <- FALSE
}

# Extract the data file from the .zip archive, 
# and load the data from the data file into a data frame.
hpcData <- read.table(unz(zipFile, sourceDataFile),
                      header = TRUE, 
                      sep = ";",
                      na.strings = "?" # NAs are represented by "?"s.
                     )

# If a temporary copy of the .zip archive was downloaded, we no longer need it,
# so remove it.
if (downloadedTempCopy == TRUE) {
    unlink(zipFile)
}

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
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)"
    )

# Close the graphics device
dev.off()
