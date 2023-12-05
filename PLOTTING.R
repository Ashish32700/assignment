# Load necessary libraries
library(ggplot2)  # Using ggplot2 for plotting

# Read the dataset (assuming the file is named household_power_consumption.csv)
data <- read.csv("household_power_consumption.csv")

# Convert Date and Time columns to DateTime object
data$DateTime <- as.POSIXct(paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S")

# Subset data for the specified 2-day period in February 2007
start_date <- as.POSIXct("2007-02-01", format = "%Y-%m-%d")
end_date <- as.POSIXct("2007-02-02", format = "%Y-%m-%d")
subset_data <- data[data$DateTime >= start_date & data$DateTime <= end_date, ]

# Plot construction
png("plot1.png", width = 480, height = 480)  # Set up PNG device
ggplot(subset_data, aes(x = DateTime, y = Global_active_power)) + 
  geom_line() + 
  labs(title = "Global Active Power Over 2 Days (Feb 2007)", x = "Date", y = "Global Active Power (kW)") +
  theme_minimal()  # You can modify the plot aesthetics as needed
dev.off()  # Close the PNG device
