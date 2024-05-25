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

airpline <- airpline %>%select(-CancellationCode)
unique(airpline$CancellationCode)
sum(is.na(airpline))
airpline<-na.omit(airpline)

str(airpline)
unique(airpline1$Cancelled)
airpline1$Cancelled<-ifelse(airpline1$Cancelled==0,"No cancelled","cancelled")

###1.

#Filter out non-canceled flights
delay<-airpline%>%filter(Cancelled==0)
meandelay<-function(data) {
  data %>%
    summarize(MeanDelay = mean((ArrDelay + DepDelay) / 2, na.rm = TRUE))
}

## What are the optimal times of day for minimizing flight delays?
# answer : The best time of day to reduce flight delays is 5 a.m. 
# because as can be seen from the graph, the total delay time per hour,
# the average delay time at 5 a.m. is at least 0.3 minutes.

hour_delay <- delay %>%
  mutate(DepHour = floor(CRSDepTime / 100)) %>%
  group_by(DepHour) %>%meandelay()

ggplot(hour_delay,aes(x=as.factor(DepHour),y=MeanDelay))+
  geom_bar(stat = "identity",fill="lightblue",colour="steelblue",width = 0.8)+
  geom_text(aes(label=round(MeanDelay, 1)),
            vjust=-0.5, size=3, color='black')+
  labs(title = "Overall Delay Time of Each Hour",
       x = "Departure Hour", y = "Average Delay Time(minutes)")+
  transition_states(DepHour) + shadow_mark()


## What are the optimal days of the week of the year for minimizing flight delays?
# The best time of the week to reduce flight delays is Saturday, because from the figure, 
# the average delay time per week, the average delay time on Saturday is at least 6.7 minutes,
# and the average delay time on Friday is at most 12.7 minutes

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
ggplot(weekly_delays, aes(x = DayOfWeek, y = MeanDelay, fill = DayOfWeek)) +
  geom_col(show.legend = F) +
  geom_text(aes(label=round(MeanDelay, 1)),
            vjust=-0.5, size=3, color='black')+
  labs(title = "Overall Weekly Delay Time", x = "Week", y = "Average Delay Time (minute)") +
  theme_minimal()+transition_states(DayOfWeek) + shadow_mark()


## What are the optimal times of the year for minimizing flight delays?
# The best time of year to reduce flight delays is January, because from the figure,
# the average delay time per month, the average delay time in January is at least 6.8 minutes, 
# and the average delay time in June is at most 12.5 minutes

monthly_delays <- delay %>%
  mutate(Month = factor(Month, levels = 1:12, labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                                         "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"))) %>%
  group_by(Month) %>% meandelay()

ggplot(monthly_delays, aes(x = Month, y = MeanDelay)) +
  geom_col(show.legend = FALSE,fill="lightcoral",colour="coral") +
  geom_line(aes(group=1), colour="steelblue", size=1) +
  geom_text(aes(label=round(MeanDelay, 1)),
            vjust=-0.5, size=3, color='black')+
  labs(title = "Overall Delay Time on Each Month", x = "Month", y = "Average Delay Time (minutes)") +
  theme_minimal()


## 2.What are the primary factors contributing to flight delays?
# The main factor causing flight delays is the National Aviation System, 
# followed by previous late flight arrivals
delay<-airpline%>%filter(Cancelled==0)
delayfactor <- delay %>%pivot_longer(
    cols = c("CarrierDelay", "WeatherDelay", "NASDelay", "LateAircraftDelay"),
    names_to = "Delaytype",
    values_to = "Delayminutes"
  ) %>% filter(Delayminutes > 0) 
delay_freq <-delayfactor%>%count(Delaytype)


ggplot(delay_freq, aes(x = n, y = reorder(Delaytype, n))) +  
  geom_col(fill = "steelblue",colour="darkblue") + 
  labs(title = "Frequency of Different Delay Reasons",
       x = "Frequency",y = "Delay Reason") +theme_minimal() +
  theme(axis.text.y = element_text(angle = 0, hjust = 1)) 

# CarrierDelay [int]: Delay caused by carrier in minutes
# WeatherDelay [int]: Delay caused by weather in minutes
# NASDelay [int]: Delay caused by National Aviation System in minutes
# LateAircraftDelay [int]: Delay caused by previous late flight arrivals in minutes



###3.What factors predominantly lead to flight cancellations?
# Flight cancellation reason (A - Carrier, B - Weather, C - National Aviation System, D - Security)
# The main factor causing flight cancellations is the carrier, followed by weather. 
# Flights are rarely canceled for security reasons.

sum(is.na(delay$CancellationCode))
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

###4.Which flight experiences the most frequent and significant  cancellations?
# Flight YV7499 is the most frequently canceled, as can be seen from the top ten charts with the highest cancellation rate

# 计算取消次数
cancell_count <- airpline %>%
  group_by(UniqueCarrier, FlightNum) %>%
  summarize(
    Cancellations = sum(Cancelled == 1, na.rm = TRUE),
    TotalFlights = n(),
    CancellationRate = Cancellations / TotalFlights,  # 直接在summarize中计算CancellationRate
    .groups = 'drop'
  ) %>%
  filter(TotalFlights > 30)  
# Only consider flights with sufficient data points

total_cancellations <- sum(airpline$Cancelled == 1, na.rm = TRUE)
cancell_count <- airpline %>%
  group_by(UniqueCarrier, FlightNum) %>%
  summarize(
    Cancellations = sum(Cancelled == 1, na.rm = TRUE),
    TotalFlights = n(),
    CancellationRate = Cancellations / total_cancellations,  # 使用总取消数来计算取消率
    .groups = 'drop'
  ) %>%
  filter(TotalFlights > 30) 

# Find out the top 10 flights with the highest cancellation rate
top_cancell <- cancell_count %>%arrange(desc(CancellationRate)) %>%
  slice_head(n = 10)

ggplot(top_cancell, aes(x = reorder(paste(UniqueCarrier, FlightNum), -CancellationRate), y = CancellationRate)) +
  geom_col(fill = "tomato") +
  labs(title = "Top 10 Flights with Highest Cancellation Rates", x = "Flight", y = "Cancellation Rate") +
  theme_minimal() +
  geom_line(aes(group=1), colour="darkred", size=1)+
  geom_text(aes(label=round(CancellationRate, 1)),
            vjust=-0.5, size=3, color='black')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

## Which flight experiences the most frequent and significant delays ?
# AS65 flights are delayed the most frequently, as can be seen from the top ten charts with the highest delay rates

# 计算每个航班的延误次数和平均延误时间
# Calculate overall delay: average of departure and arrival delays
# Sort by number of delays
flight_delay <- airpline %>%
  filter(Cancelled == 0) %>%  # 只考虑实际有延误的情况
  group_by(UniqueCarrier, FlightNum) %>%
  summarize(
    DelayInstances = n(),  # 延误的次数
    AverageDelay = mean((DepDelay + ArrDelay)/2, na.rm = TRUE),  # 计算平均延误时间
    .groups = 'drop'
  )

# 选择延误次数最多的前10个航班
top_delay <- flight_delay %>%
  arrange(desc(DelayInstances)) %>%
  slice_head(n = 10)

ggplot(top_delay, aes(x = reorder(paste(UniqueCarrier, FlightNum), -DelayInstancesy), y = DelayInstances)) +
  geom_col(fill = "lavender",colour="violet") +
  labs(title = "Top 10 Most Frequently Delayed Flights",x = "Flight",
       y = "Number of Delay Instances") +theme_minimal() +
  geom_text(aes(label=round(DelayInstances, 1)),
            vjust=-0.5, size=3, color='black')+
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








                                          

