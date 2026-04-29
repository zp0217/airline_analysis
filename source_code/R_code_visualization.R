# Reading data
library(dplyr)
d1<- read.csv("/Users/zp/Desktop/6300_mini_project_csv/mini_project_1.csv")

d2<- read.csv("/Users/zp/Desktop/6300_mini_project_csv/mini_project_2.csv")
d3<- read.csv("/Users/zp/Desktop/6300_mini_project_csv/mini_project_3.csv")
d4<- read.csv("/Users/zp/Desktop/6300_mini_project_csv/mini_project_4.csv")
d5<- read.csv("/Users/zp/Desktop/6300_mini_project_csv/mini_project_5.csv")
d6<- read.csv("/Users/zp/Desktop/6300_mini_project_csv/mini_project_6b.csv")
d7<- read.csv("/Users/zp/Desktop/6300_mini_project_csv/mini_project_7.csv")

#On time performance data contains records of flights by date,airline,originating airport,destination airport and many other details related to flights. Purpose of this report is to examine the dataset to solve various questions that can be questioned from air traffic related topics and provide clear results to suggest what features that need to be noted from airline on time statistics. For this analysis, it used real time data from 09/01/2019 to 09/30/2019 timeframe, with various information that will be used for various data analysis. Questions that will be dealt with in this report include maximal departure delay, maximal early departure, flight performance by week analysis, airline and airport departure delay analysis, cancellation reason analysis and three proceeding day analysis. 
#First topic is departure delay analysis. It is common for airlines to depart later than expected due to various reasons(ie. weather ), for this question, the first analysis is maximum departure delay in minutes for each airline. 


#plot 1

library(ggplot2)
mean_delay <- mean(d1$MaxDelayMinutes)
max_delay <- max(d1$MaxDelayMinutes)
min_delay <- min(d1$MaxDelayMinutes)

# Find corresponding airlines for max and min delays
max_airline <- d1$Airline[which.max(d1$MaxDelayMinutes)]
min_airline <- d1$Airline[which.min(d1$MaxDelayMinutes)]

# Create a bar plot with points for mean, max, and min
plot1<-ggplot(d1, aes(x = reorder(Airline, -MaxDelayMinutes), y = MaxDelayMinutes)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  geom_point(aes(x = max_airline, y = max_delay), color = "red", size = 1) + # Max point
  geom_point(aes(x = min_airline, y = min_delay), color = "blue", size = 1) + # Min point
  geom_hline(yintercept = mean_delay, color = "black", linetype = "dashed", size = 1) + # Highlight mean
  labs(title = "Maximum Delay Minutes by Airline",
       x = "Airline",
       y = "Maximum Delay Minutes",
       caption = "Figure1") +
  annotate("text", x = max_airline, y = max_delay +100, label = paste("Max:", max_delay), 
           color = "red",size = 2) +
  annotate("text", x = min_airline, y = min_delay - 100, label = paste("Min:", min_delay), 
           color = "blue",size = 2) +
  annotate("text", x = 2, y = mean_delay + 100, label = paste("Mean:", round(mean_delay, 1)), 
           color = "black", hjust = 0.5,size = 2) +
  theme_minimal(base_size = 9) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1),
        plot.background = element_rect(fill = "white", color = NA) )
ggsave("my_plot1.png", plot = plot1, width = 6, height = 6)



#plot2 

summary_data <- d2 %>%
  mutate(EarlyDepartureMinutes = abs(EarlyDepartureMinutes)) %>%
  summarise(
    Max = max(EarlyDepartureMinutes),
    Min = min(EarlyDepartureMinutes),
    Mean = mean(EarlyDepartureMinutes)
  )

# Add annotations for the summary statistics
plot2b<-ggplot(d2, aes(x = reorder(Airline, abs(EarlyDepartureMinutes)), y = abs(EarlyDepartureMinutes))) +
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  geom_text(aes(label = abs(EarlyDepartureMinutes)), hjust = -0.2, size = 3.5) +
  labs(title = "Maximum Early Departure Minutes by Airline", 
       x = "Airline", 
       y = " Early Departure in Minutes",caption = "Figure2") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1),
        plot.background = element_rect(fill = "white", color = NA) )
ggsave("my_plot2b.png", plot = plot2b, width = 6, height = 6)



#plot 3.

plot3<-ggplot(d3, aes(x = reorder(Day, -NumberOfFlights), y = NumberOfFlights)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  geom_text(aes(label = paste("Rank", Ranking, "\nFlights:", NumberOfFlights)), vjust = -0.5, color = "black", size = 1.5) +
  labs(title = "bar plot of Number of Flights by Day with Rankings",
       x = "Day of the Week",
       y = "Number of Flights",caption = "Figure3") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1),plot.background = element_rect(fill = "white", color = NA),plot.title = element_text(size = 10))
ggsave("my_plot3.png", plot = plot3, width = 6, height = 6)



#plot 4

library(maps)
library(ggrepel)
a11<-read.csv("/Users/zp/Desktop/a111.csv")
lat1<- 43
long1<- -124
air1<- d4
air1$Latitude<- lat1
air1$Longitude<-long1
usa_map <- map_data("state")
plot4<-ggplot() +
  # Draw the USA map
  geom_polygon(data = usa_map, aes(x = long, y = lat, group = group), 
               fill = "lightblue", color = "white") +
  
  # Plot all airports as points
  geom_point(data = air1, aes(x = Longitude, y = Latitude), 
             color = "red", size = 2) +
  
  # Add labels for all airports
  geom_text_repel(data = air1, 
                  aes(x = Longitude, y = Latitude, 
                      label = paste(AirportName,AvgDelay, sep = "\n")), 
                  size = 3, box.padding = 0.5, point.padding = 0.5, 
                  max.overlaps = 50) + # Adjust overlaps limit
  
  # Titles and themes
  theme_minimal() +
  labs(title = "Airport location for highest average departure delay ", 
       x = "Longitude", y = "Latitude",caption = "Figure4") +
  theme(plot.title = element_text(hjust = 0.5),plot.background = element_rect(fill = "white", color = NA))
ggsave("my_plot4.png", plot = plot4, width = 7, height = 7)



#plot 5

library(ggplot2)
library(ggrepel)
library(maps)
library(usmap)
latitude<-a11$Latitude
longitude<-a11$Longitude
airport<- d5
airport$latitude<-latitude
airport$longitude<-longitude
# Plot with all airports and labels
plot5<-ggplot() +
  # Draw the USA map
  geom_polygon(data = usa_map, aes(x = long, y = lat, group = group), 
               fill = "lightblue", color = "white") +
  
  # Plot all airports as points
  geom_point(data = airport, aes(x = longitude, y = latitude), 
             color = "red", size = 2) +
  
  # Add labels for all airports
  geom_text_repel(data = airport, 
                  aes(x = longitude, y = latitude, 
                      label = paste(AirportName, AirlineName, sep = "\n")), 
                  size = 2, box.padding = 0.5, point.padding = 0.5, 
                  max.overlaps = 50) + # Adjust overlaps limit
  
  # Titles and themes
  theme_minimal() +
  labs(title = "Airport location with highest average departure delays by airlines", 
       x = "Longitude", y = "Latitude",caption = "Figure6") +
  theme(plot.title = element_text(hjust = 0.5),plot.background = element_rect(fill = "white", color = NA))
ggsave("my_plot5.png", plot = plot5, width = 9, height = 7)




# Plot 5c

library(ggplot2)
library(dplyr)

# Identify min and max values
d5 <- d5 %>%
  mutate(
    Highlight = case_when(
      AvgDelay == max(AvgDelay) ~ "Max",
      AvgDelay == min(AvgDelay) ~ "Min",
      TRUE ~ "Normal"
    )
  )


plot5c<-ggplot(d5, aes(x = reorder(AirlineName, -AvgDelay), y = AvgDelay, fill = AirportName)) +
  geom_bar(stat = "identity", aes(alpha = Highlight)) +
  geom_text(aes(label = round(AvgDelay, 1)),vjust = -0.5, size = 4.5) +
  #coord_flip() +
  scale_alpha_manual(
    values = c("Max" = 1, "Min" = 1, "Normal" = 0.8), 
    guide = "none"
  ) +
  labs(
    title = "Airports with Highest Average Departure Delay for Each Airline",
    x = "Airline",
    y = "Average Delays (in minutes)",
    fill = "Airline",caption = "Figure5"
  ) +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 0.5),
    axis.text.y = element_text(angle = 45.,hjust = 0.5,size = 5),
    plot.title = element_text(hjust = 0.5),
    plot.background = element_rect(fill = "white", color = NA,size = 10),
    legend.text = element_text(size = 7),  
    legend.title = element_text(size = 5)
  )

#  theme(plot.title = element_text(hjust = 0.5),plot.background = element_rect(fill = "white", color = NA))
ggsave("my_plot5c.png", plot = plot5c, width = 10, height = 7)



#plot 6A

overall_reasons <- most_frequent_reasons %>%
  group_by(reason) %>%
  summarise(total_cancelcount = sum(total_cancelcount))

# Calculating percentages
overall_reasons <- overall_reasons %>%
  mutate(percentage = total_cancelcount / sum(total_cancelcount) * 100)

# Creating the pie chart with percentages
plot6<-ggplot(overall_reasons, aes(x = "", y = total_cancelcount, fill = reason)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  geom_text(aes(label = paste0(round(percentage, 1), "%")), 
            position = position_stack(vjust = 0.5)) +
  labs(title = "Pie Chart of Cancellation Reasons",caption = "Figure7") +
  theme(plot.title = element_text(hjust = 0.5),plot.background = element_rect(fill = "white", color = NA))
ggsave("my_plot6.png", plot = plot6, width = 9, height = 7)
```

#plot 6b

top_cancellation_airports <- d6 %>%
  group_by(AirportName) %>%
  summarise(cancelcount = sum(cancelcount)) %>%
  arrange(desc(cancelcount)) %>%
  slice(1:10)


plot6b<- ggplot(top_cancellation_airports, aes(x = reorder(AirportName, -cancelcount), y = cancelcount)) +
  geom_bar(stat = "identity", fill = "orange") +
  labs(
    title = "Top 10 Airports by Cancellation Counts(all reasons)",
    x = "Airport Name",
    y = "Number of Cancellations",caption = "Figure8"
  ) +
  theme_minimal() +
  theme(
    
    plot.background = element_rect(fill = "white", color = NA),  # White background
    axis.text.x = element_text(angle = 65, hjust = 1, size = 8),  # Rotate x-axis text
    axis.text.y = element_text(size = 10),  # Adjust y-axis text size
    axis.title = element_text(size = 12),  # Adjust axis title size
    plot.title = element_text(size = 14, face = "bold")  # Larger bold title
  )

ggsave("my_plot6b.png", plot = plot6b, width = 9, height = 7) 


#plot 7

# Load necessary libraries
library(ggplot2)
d7$FlightDate <- as.Date(d7$FlightDate)
# Find max and min flights
max_flights <- d7[which.max(d7$flights_over_preceding_three_days), ]
min_flights <- d7[which.min(d7$flights_over_preceding_three_days), ]
mean_flights <- mean(d7$flights_over_preceding_three_days)
# Create the plot
plot7<-ggplot(d7, aes(x = FlightDate, y = flights_over_preceding_three_days)) +
  geom_line(aes(color = "Trend Line"), size = 1) +  # Add trend line
  geom_point(data = max_flights, aes(x = FlightDate, y = flights_over_preceding_three_days, color = "Max Flights"), size = 4) +  # Highlight max
  geom_point(data = min_flights, aes(x = FlightDate, y = flights_over_preceding_three_days, color = "Min Flights"), size = 4) +  # Highlight min
  geom_hline(aes(yintercept = mean_flights, color = "Mean Flights"), linetype = "dashed", size = 1) +  # Add mean line
  scale_color_manual(values = c("Trend Line" = "orange",
                                
                                "Max Flights" = "red",
                                "Min Flights" = "yellow",
                                "Mean Flights" = "blue")) +  # Define custom colors
  labs(title = "Analysis of Flights Over Preceding Three Days",
       x = "Flight Date",
       y = "Number of Flights",
       color = "Legend",caption = "Plot1") +  # Add labels
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  scale_x_date(breaks = seq(min(d7$FlightDate), max(d7$FlightDate), by = "1 day"))+
  theme(plot.title = element_text(size = 16, face = "bold"),
        plot.background = element_rect(fill = "white", color = NA),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 10),
        legend.background = element_rect(fill = "white", color = "black"))

ggsave("my_plot7.png", plot = plot7, width = 9, height = 7) 
