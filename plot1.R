print ("loading in necessary libraries...")
library (downloader)
library(data.table)
library(sqldf)

print ("downloading files...")
if (!file.exists("./household_power_consumption.zip")){
        fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download(fileurl, dest = "household_power_consumption.zip", mode = "wb")
        unzip ("household_power_consumption.zip", exdir = "./")
}


# this reads in only the observations for February 1 and February 2, 2007
print ("reading in data...")
file <- fread("./household_power_consumption.txt", colClasses = c("character", "character", rep("numeric", 7)), skip = 66637, nrows = 2880) 

# this adds in headers
headers <- fread("./household_power_consumption.txt",  skip = 0, nrows = 1, header = F)             
colnames(file) <- as.character(headers) 

# create new column with date and time 
file <- as.data.frame(file)
Date_Time <- paste(file$Date, file$Time)
Date_Time <- strptime(Date_Time, format = "%d/%m/%Y %H:%M:%S")
file$Date_Time <- Date_Time

##plot1
print ("plotting figure...")
png(filename = "plot1.png", width = 480, height = 480)
par (mar = c(5.1, 4.1, 4.1, 2.1), mfrow = c(1,1))
with(file, hist(Global_active_power, col = "red", 
                xlab= "Global Active Power (kilowatts)", ylab = "Frequency", 
                main = "Global Active Power"))
dev.off()
print ("process completed!")