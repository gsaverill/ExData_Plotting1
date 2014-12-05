###############################################################################
# R Script
#
# This script generates Plot 4, which is part of Course Project 1.
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
png(filename = "plot4.png",
    width = 480,
    height = 480
   )

# Set up the charts to be output in two rows of two columns.
par(mfrow = c(2, 2))

#
# Make the Global Active Power plot.
#

plot(hpcData$Time, hpcData$Global_active_power, 
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)"
    )

#
# Make the Voltage plot.
#

plot(hpcData$Time, hpcData$Voltage, 
     type = "l",
     xlab = "datetime",
     ylab = "Voltage"
    )

#
# Make the Energy Sub Metering plot
#

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
        legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
        bty = "n" # Turn off the border around the legend.
      )

#
# Make the Global Reactive Power plot.
#

plot(hpcData$Time, hpcData$Global_reactive_power, 
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power"
    )

# Close the graphics device
dev.off()
