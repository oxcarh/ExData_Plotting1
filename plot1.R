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

# Plot 1
png(filename = "plot1.png", width = 480, height = 480, units = "px", type = "quartz")
hist(dt2$Global_active_power, xlab = "Global Active Power (kilowats)", col = "red", main = "Global Active Power")
dev.off()
