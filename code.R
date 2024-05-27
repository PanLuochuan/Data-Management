# Load necessary packages
library(ggplot2)
library(dplyr)
library(scales)
library(tidyr)
library(gganimate)
library(gifski)
airpline<-read.csv(file.choose())
head(airpline)

# AirTime, ArrDelay and ArrTime are NaN because the flight was cancelled or diverted.
# DepTime and DepDelay are NaN bacause the flight was cancelled.
# Therefore there is no need to go out to NaN value
# arrdelay: difference in minutes between scheduled and actual arrival time. Early arrivals show negative numbers, in minutes
# depdelay: Difference in minutes between scheduled and actual departuretime. Early departures show negative numbers, in minutes
# Cancelled [int]: Flight cancellation (1 - Cancelled, 0 - Not Cancelled)
# Therefore, if ArrDelay and DepDelay are negative, it means that the flight is not delayed
# According to official information, a flight delay refers to a flight landing more than 15 minutes later than the planned landing time.


###1.
#Filter out non-canceled flights

delay <- airpline %>% filter(Cancelled==0)

season <- delay %>%
  mutate(
    Season = case_when(
      Month %in% c(12, 1, 2) ~ "Winter",
      Month %in% c(3, 4, 5) ~ "Spring",
      Month %in% c(6, 7, 8) ~ "Summer",
      Month %in% c(9, 10, 11) ~ "Autumn",
    )
  )

meandelay <- function(data) {
  data %>% summarize(
      TotalFlights = n(),  # 总航班数
      DelayedFlights = sum(ArrDelay > 15, na.rm = TRUE),  # The number of flights delayed by more than 15 minutes
      Percentage = (DelayedFlights / TotalFlights) * 100,  # Percentage of delayed flights
      MeanDelay = mean(ifelse(ArrDelay > 15, ArrDelay, NA), na.rm = TRUE),  
      .groups = "drop"
    )
}

## What are the optimal times of day for minimizing flight delays?
# Answer: 
# # The first is not to consider the seasonal factors.
# The best time of day to reduce flight delays is 5 hour. 
# Because it can be seen from the graph of the percentage of delay time per hour,
# The minimum percentage at 5 hour is 8.1%, while the maximum percentage is 34.2% at 3 hour.

hour_delay <- delay %>%
  mutate(DepHour = floor(CRSDepTime / 100)) %>%
  group_by(DepHour) %>% meandelay()

ggplot(hour_delay,aes(x=as.factor(DepHour),y=Percentage))+
  geom_bar(stat = "identity",fill="lightblue",colour="steelblue",width = 0.8)+
  geom_text(aes(label=round(Percentage, 1)),
            vjust=-0.5, size=3, color='black')+
  labs(title = "Percentage Arrival Delay Time ",
       x = "Departure Hour", y = "Percentage Arrival Delay Time (%)")+
  transition_states(DepHour) + shadow_mark()

# Consider the seasonal factors
# In spring, summer and winter, 5 hour is the best time to reduce flight delays,
# and in autumn 4 hour is the best time to reduce flight delays

hour_delay1 <- season %>%
  mutate(DepHour = floor(CRSDepTime / 100)) %>%
  group_by(Season,DepHour) %>% meandelay()

ggplot(hour_delay1, aes(x = as.factor(DepHour), y = Percentage, group = Season, color = Season)) +
  geom_line(aes(linetype = Season), size = 1) +  
  labs(title = "Percentage Arrival Delay Time (by season)",
       x = "Departure Hour", y = "Percentage Arrival Delay Time (%)") +
  scale_color_manual(values = c("Winter" = "steelblue", "Spring" = "chartreuse3", "Summer" = "khaki", "Autumn" = "darkorange")) +
  theme_minimal() +
  theme(legend.title = element_blank())+transition_reveal(as.numeric(as.factor(DepHour)))


## What are the optimal days of the week of the year for minimizing flight delays?

# Answer :
# The first is not to consider the seasonal factors
# As can be seen from the graph of average weekly delay percentage ,
# The best time of the week to reduce flight delays is Saturday
# The average delay percentage on Saturday was 18.6%,
# Average delay percentage on Friday was highest at 26%

weekly_delays <- delay %>%
  mutate(DayOfWeek = factor(case_when(
    DayOfWeek == 1 ~ 'Monday',
    DayOfWeek == 2 ~ 'Tuesday',
    DayOfWeek == 3 ~ 'Wednesday',
    DayOfWeek == 4 ~ 'Thursday',
    DayOfWeek == 5 ~ 'Friday',
    DayOfWeek == 6 ~ 'Saturday',
    DayOfWeek == 7 ~ 'Sunday'
  ), levels = c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'))) %>%
  group_by(DayOfWeek) %>%meandelay()

ggplot(weekly_delays, aes(x = DayOfWeek, y = Percentage, fill = DayOfWeek)) +
  geom_col(show.legend = F) +
  geom_text(aes(label=round(Percentage, 1)),
            vjust=-0.5, size=3, color='black')+
  labs(title = "Percentage Arrival Delay Time of week ", x = "Week", y = "Percentage Arrival Delay Time (%)") +
  theme_minimal()+transition_states(DayOfWeek) + shadow_mark()

# Consider the seasonal factors
# In spring, summer and autumn, Fridays are the best days to minimize flight delays, 
# and in winter, Tuesdays are the best days to minimize flight delays.

weekly_delays1 <- season %>%
  mutate(DayOfWeek = factor(case_when(
    DayOfWeek == 1 ~ 'Monday',
    DayOfWeek == 2 ~ 'Tuesday',
    DayOfWeek == 3 ~ 'Wednesday',
    DayOfWeek == 4 ~ 'Thursday',
    DayOfWeek == 5 ~ 'Friday',
    DayOfWeek == 6 ~ 'Saturday',
    DayOfWeek == 7 ~ 'Sunday'
  ), levels = c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'))) %>%
  group_by(Season,DayOfWeek) %>%meandelay()

ggplot(weekly_delays1, aes(x = DayOfWeek, y = Percentage, fill = Season)) +
  geom_bar(stat = "identity", position = "stack") +
  geom_text(aes(label=round(Percentage, 1), group = Season),
            position = position_stack(vjust = 0.5), size=3, color='black')+
  labs(title = "Percentage Arrival Delay Time of week (by season)", x = "Week", y = "Percentage Arrival Delay Time (%)") +
  theme_minimal()+
  scale_fill_manual(values = c("Winter" = "steelblue", "Spring" = "chartreuse3", "Summer" = "khaki", "Autumn" = "darkorange"))


## What are the optimal times of the year for minimizing flight delays?

# Delay percentage by month, regardless of seasonal factors
# The best time of year to reduce flight delays is January because from the graph,
# The January percentage was 18.8%,
# The average delay percentage in December was the highest at 25.8%.
monthly_delays <- season %>%
  mutate(Month = factor(Month, levels = 1:12, labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                                         "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"))) %>%
  group_by(Month) %>% meandelay()

ggplot(monthly_delays, aes(x = Month, y = Percentage)) +
  geom_col(show.legend = FALSE,fill="lightcoral",colour="coral") +
  geom_line(aes(group=1), colour="steelblue", size=1)+
  geom_text(aes(label=round(Percentage, 1)),
            vjust=-0.5, size=3, color='black')+
  labs(title = "Percentage Arrival Delay Time of Month ", x = "Month", y = "Percentage Arrival Delay Time of Month (%)") +
  theme_minimal()


## 2.What are the primary factors contributing to flight delays?
# CarrierDelay [int]: Delay caused by carrier in minutes
# WeatherDelay [int]: Delay caused by weather in minutes
# NASDelay [int]: Delay caused by National Aviation System in minutes
# LateAircraftDelay [int]: Delay caused by previous late flight arrivals in minutes

# Answer :
# The first is not to consider the seasonal factors
# The main factor causing flight delays is the National Aviation System, 
# followed by previous late flight arrivals

season <- airpline %>%
  mutate(
    Season = case_when(
      Month %in% c(12, 1, 2) ~ "Winter",
      Month %in% c(3, 4, 5) ~ "Spring",
      Month %in% c(6, 7, 8) ~ "Summer",
      Month %in% c(9, 10, 11) ~ "Autumn",
    )
  )

delay <- season %>%filter(Cancelled == 0, ArrDelay > 15)

delayfactor <- delay %>%pivot_longer(
    cols = c("CarrierDelay", "WeatherDelay", "NASDelay", "LateAircraftDelay"),
    names_to = "Delaytype",
    values_to = "Delayminutes"
  ) %>%
  filter(Delayminutes > 0)

delay_freq <-delayfactor%>%count(Delaytype)
ggplot(delay_freq, aes(x = n, y = reorder(Delaytype, n))) +  
  geom_col(fill = "steelblue",colour="darkblue") + 
  labs(title = "Frequency of Different Delay Reasons",
       x = "Frequency",y = "Delay Reason") +theme_minimal() +
  theme(axis.text.y = element_text(angle = 0, hjust = 1))

# Consider the seasonal factors
# The main factor causing flight delays in any season isthe National Aviation System.

delay_freq <-delayfactor%>%count(Season,Delaytype,sort = TRUE)
ggplot(delay_freq, aes(x = Delaytype, y = n, fill=Season)) +  
  geom_col(position = "dodge") + 
  labs(title = "The primary factors contributing to flight delays (by season)",
       x = "Delay Factors",y = "Count") +
  theme_minimal() +
  scale_fill_manual(values = c("Winter" = "steelblue", "Spring" = "chartreuse3", "Summer" = "yellow", "Autumn" = "darkorange")) 


## 3.What factors predominantly lead to flight cancellations?
# Flight cancellation reason (A - Carrier, B - Weather, C - National Aviation System, D - Security)

# Answer :
# The first is not to consider the seasonal factors
# The main factor causing flight cancellations is the carrier, followed by weather. 
# Flights are rarely canceled for security reasons.

cancelled <- airpline %>% filter(Cancelled == 1)%>%
  count(CancellationCode, name = "Frequency")%>%
  mutate(CancellationCode = factor(CancellationCode, 
                                   levels = c("A", "B", "C", "D"),
                                   labels = c("Carrier", "Weather", "National Aviation System", "Security")))

ggplot(cancelled, aes(x=CancellationCode, y=Frequency, fill=CancellationCode)) +
  geom_col( width = 0.7) + 
  geom_text(aes(label=round(Frequency, 1)),
            vjust=-0.5, size=3, color='black')+
  scale_fill_discrete(labels = c(A = "Carrier", B = "Weather", C = "National Aviation System", D = "Security")) +
  labs(title = "Proportion of Flight Cancellation Reasons", x = "Cancellation Reason", y = "Frequency", fill = "Reason")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Answer :
# Consider the seasonal factors
# For spring, summer and autumn, the top cause of flight cancellations is Carrier, 
# but for winter, the top cause of flight cancellations is weather

cancelled <- season %>% filter(Cancelled == 1)%>%
  count(Season , CancellationCode, name = "Frequency")%>%
  mutate(CancellationCode = factor(CancellationCode, 
                                   levels = c("A", "B", "C", "D"),
                                   labels = c("Carrier", "Weather", "National Aviation System", "Security")))
ggplot(cancelled, aes(x=CancellationCode, y=Frequency, fill=Season)) +
  geom_col(position = "dodge")  + 
  labs(title = "The primary factors contributing to flight cancellation (by season)",
       x = "Cancell Factors",y = "Count") +
  theme_minimal() +
  scale_fill_manual(values = c("Winter" = "steelblue", "Spring" = "chartreuse3", "Summer" = "yellow", "Autumn" = "darkorange")) 


## 4.Which flight experiences the most frequent and significant  cancellations?
# Answer:
# Flight WN20 is the most frequently canceled, as can be seen from the top ten charts with the highest cancellation rate

total_cancellations <- sum(airpline$Cancelled == 1, na.rm = TRUE)
cancell_count <- airpline %>%
  group_by(UniqueCarrier, FlightNum) %>%
  summarize(
    Cancellations = sum(Cancelled == 1, na.rm = TRUE),
    TotalFlights = n(),
    CancellationRate = Cancellations / total_cancellations,  # Use the total number of cancellations to calculate the cancellation rate
    .groups = 'drop'
  ) 

# Find out the top 10 flights with the highest cancellation rate
top_cancell <- cancell_count %>%arrange(desc(CancellationRate)) %>%
  slice_head(n = 10)

ggplot(top_cancell, aes(x = reorder(paste(UniqueCarrier, FlightNum), -CancellationRate), y = CancellationRate* 100)) +
  geom_col(fill = "tomato") +
  labs(title = "Top 10 Flights with Highest Cancellation Rates", x = "Flight's Number", y = "Cancellation Rate") +
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 


## Which flight experiences the most frequent and significant delays ?
# Answer
# WN269 flights are delayed the most frequently, as can be seen from the top ten charts with the highest delay rates

total_delay <- airpline %>%
  filter(Cancelled == 0, ArrDelay > 15) %>%
  summarise(total = n(), .groups = 'drop') %>%
  pull(total)

flight_delay <- airpline %>%
  filter(Cancelled == 0) %>%
  group_by(UniqueCarrier, FlightNum) %>%
  summarize(
    TotalFlights = n(),  
    DelayedFlights = sum(ArrDelay > 15, na.rm = TRUE),  
    .groups = 'drop'
  )

# Select the top 10 flights with the most delays
top_delay <- flight_delay %>%
  arrange(desc(DelayedFlights)) %>%
  slice_head(n = 10)

ggplot(top_delay, aes(x = reorder(paste(UniqueCarrier, FlightNum), -DelayedFlights), y = DelayedFlights)) +
  geom_col(fill = "lavender",colour="violet") +
  labs(title = "Top 10 Most Frequently Delayed Flights",x = "Flight's Number",
       y = "Number of Delay Instances") +theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Flight B6 9024 has the longest average delay

top_delay1 <- flight_delay %>%
  arrange(desc(AverageDelay)) %>%
  slice_head(n = 10)

ggplot(top_delay1, aes(x = reorder(paste(UniqueCarrier, FlightNum), -AverageDelay), y = AverageDelay)) +
  geom_col(fill = "lavender", colour = "violet") +
  labs(title = "Top 10 Flights with the Longest Average Delays", 
       x = "Flight", 
       y = "Average Delay Time (minutes)") +
  theme_minimal() +
  geom_text(aes(label = round(AverageDelay, 1)),
            vjust = -0.5, size = 3, color = 'black') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

delay <- airpline %>% filter(Cancelled == 0)
delay_counts <- delay %>% group_by(FlightNum, UniqueCarrier) %>%
  summarise(Count = n(), .groups = 'drop') %>%
  arrange(desc(Count))
head(delay)
top_delay <- delay_counts %>%top_n(10, Count)




                                          

