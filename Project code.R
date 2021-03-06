library (downloader)
library(data.table)
library(sqldf)

if (!file.exists("./household_power_consumption.zip")){
        fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download(fileurl, dest = "household_power_consumption.zip", mode = "wb")
        unzip ("household_power_consumption.zip", exdir = "./")
}

# this reads in only the observations for February 1 and February 2, 2007
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
png(filename = "plot1.png", width = 480, height = 480)
par (mar = c(5.1, 4.1, 4.1, 2.1), mfolc = c(1,1))
with(file, hist(Global_active_power, col = "red", 
xlab= "Global Active Power (kilowatts)", ylab = "Frequency", 
main = "Global Active Power"))
dev.off()

##plot 2
png(filename = "plot2.png", width = 480, height = 480)
par (mar = c(5.1, 4.1, 4.1, 2.1), mfolc = c(1,1))
plot(file$Date_Time, file$Global_active_power, ylab = "Global Active Power (kilowatts)", type= "n", xlab= NA)
lines(file$Date_Time, file$Global_active_power)
dev.off()

##plot 3
png(filename = "plot3.png", width = 480, height = 480)
par (mar = c(5.1, 4.1, 4.1, 2.1), mfolc = c(1,1))
plot(file$Date_Time, file$Sub_metering_1, ylab = "Energy sub metering", type= "n", xlab= NA)
lines(file$Date_Time, file$Sub_metering_1, col = "black")
lines(file$Date_Time, file$Sub_metering_2, col = "red")
lines(file$Date_Time, file$Sub_metering_3, col = "blue")
legend("topright", lwd = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()

##plot 4
png(filename = "plot4.png", width = 480, height = 480)
par (mar = c(1, 4.1, 4.1, 1), mfrow = c(2,2), cex = 0.5)

## first figure for this plot
with(file, plot (Date_Time, Global_active_power, type = "l", ylab = "Global Active Power", xlab = NA))

## second figure for this plot
with(file, plot( Date_Time, Voltage, type ="l", ylab = "Voltage", xlab = "datetime",) )

## third figure for this plot
plot(file$Date_Time, file$Sub_metering_1, ylab = "Energy sub metering", type= "n", xlab= NA)
lines(file$Date_Time, file$Sub_metering_1, col = "black")
lines(file$Date_Time, file$Sub_metering_2, col = "red")
lines(file$Date_Time, file$Sub_metering_3, col = "blue")
legend("topright", lwd = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## fourth figure for this plot
with(file, plot( Date_Time, Global_reactive_power, type ="l", xlab = "datetime",) )
dev.off()

