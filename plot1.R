#
# R script
#

# Path to the source data
sourceDataURL <- "https://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"

# Name of the file to extract from the .zip archive
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


