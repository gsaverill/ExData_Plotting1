#
# R script
#

# Path to the source data.
sourceDataURL <- "https://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"

# Name of the file to extract from the .zip archive.
sourceDataFileName <- "household_power_consumption.txt"

# Download the .zip archive, extract the data, and load into a data frame.
tmpFile <- tempfile()
download.file(sourceDataURL,tmpFile, method="curl")
hpcData <- read.table(unz(tmpFile, sourceDataFileName),
                      header=TRUE, 
                      sep=";",
                      quote="",
                      na.strings ="?"
                     )
unlink(tmpFile)

# Convert the Date and Time column values, which read.table brought in as 
# factors, into Date and POSIXlt types.
hpcData$Time <- strptime(paste(hpcData$Date, hpcData$Time), 
                         paste("%d/%m/%Y",   "%H:%M:%S"  )
                        )

hpcData$Date <- as.Date(hpcData$Date, "%d/%m/%Y")

# Grab the subset of the data frame that covers February 1-2, 2007.
beginDate <- as.Date("2007-02-01")
endDate   <- as.Date("2007-02-02")
hpcData   <- hpcData[hpcData$Date %in% c(beginDate, endDate),]
