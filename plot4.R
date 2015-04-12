# Loading the Data
library(data.table)
dt <- fread(input = "household_power_consumption.txt", sep = ";", na.strings = c("NA","N/A","", "?"), header = TRUE)
column_names = c("Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
indexes <- match(column_names, names(dt))
for(i in seq_along(indexes)) {
  set(dt, NULL, indexes[i], as.numeric(dt[[indexes[i]]]))
}
dt2 <- dt[dt$Date == "1/2/2007" | dt$Date == "2/2/2007", ]
dt2$DateTime = paste(dt2$Date, dt2$Time, sep = " ")
dt2[,DateTime:=as.POSIXct(strptime(dt2$DateTime, "%d/%m/%Y %H:%M:%S"))]

# Setting Device to write PNG
png(filename = "plot4.png", width = 480, height = 480, units = "px", type = "quartz")
Sys.setlocale("LC_TIME", "en_US.UTF-8")
par(mfrow = c(2, 2))

# Plot 1
plot(dt2$DateTime, dt2$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowats)")

# Plot 2
plot(dt2$DateTime, dt2$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

# Plot 3
plot(dt2$DateTime, dt2$Sub_metering_1, type = "n", ,xlab = "", ylab = "Energy Submetering")
lines(dt2$DateTime, dt2$Sub_metering_1, col = "black")
lines(dt2$DateTime, dt2$Sub_metering_2, col = "red")
lines(dt2$DateTime, dt2$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), pch = "", col = c("black", "red", "blue"), lwd = c(2,2,2))

#Plot 4
plot(dt2$DateTime, dt2$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")

dev.off()
