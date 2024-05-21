library(ggplot2)
library(dplyr)
library(scales)
library(tidyr)
library(gganimate)
library(gifski)
airpline<-read.csv(file.choose())
uniquecarrier<-read.csv(file.choose())
head(airpline)
head(uniquecarrier)
#cancell A B C D
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

#What are the optimal times of day for minimizing flight delays?
hour_delay <- delay %>%
  mutate(DepHour = floor(CRSDepTime / 100)) %>%
  group_by(DepHour) %>%meandelay()

ggplot(hour_delay,aes(x=as.factor(DepHour),y=MeanDelay))+
  geom_bar(stat = "identity",fill="lightblue",colour="steelblue",width = 0.8)+
  geom_text(aes(label=round(MeanDelay, 1)),
            vjust=-0.5, size=3, color='black')+
  labs(title = "Overall Delay Time of Each Hour",
       x = "Departure Hour",
       y = "Average Delay Time(minutes)")+theme_minimal()


#What are the optimal days of the week of the year for minimizing flight delays?
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
  theme_minimal()

#What are the optimal times of the year for minimizing flight delays?

monthly_delays <- delay %>%
  mutate(Month = factor(Month, levels = 1:12, labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                                         "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"))) %>%
  group_by(Month) %>% meandelay()

ggplot(monthly_delays, aes(x = Month, y = MeanDelay)) +
  geom_col(show.legend = FALSE,fill="lightcoral",colour="coral") +
  geom_text(aes(label=round(MeanDelay, 1)),
            vjust=-0.5, size=3, color='black')+
  labs(title = "Overall Delay Time on Each Month", x = "Month", y = "Average Delay Time (minutes)") +
  theme_minimal()


#2.What are the primary factors contributing to flight delays?
delay<-airpline%>%filter(Cancelled==0)
delayfactor <- delay %>%pivot_longer(
    cols = c("CarrierDelay", "WeatherDelay", "NASDelay", "LateAircraftDelay"),
    names_to = "Delaytype",
    values_to = "Delayminutes"
  ) %>% filter(Delayminutes > 0) 
delay_freq <-delayfactor%>%count(Delaytype)
ggplot(data = delay_freq, aes(x = Delaytype, y = n, fill = Delaytype)) +
  geom_col() +
  labs(title = "Frequency of Different Delay Reasons",
       x = "Delay Reason",
       y = "Frequency",
       fill = "Delay Reason") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
library(ggplot2)

# 绘制横向条形图
ggplot(delay_freq, aes(x = n, y = reorder(Delaytype, n))) +  # 请注意这里x和y的位置已交换
  geom_col(fill = "steelblue",colour="darkblue") +  # 使用fill参数直接在geom_col()中设置颜色
  labs(title = "Frequency of Different Delay Reasons",
       x = "Frequency",
       y = "Delay Reason") +theme_minimal() +
  theme(axis.text.y = element_text(angle = 0, hjust = 1))  # 调整y轴标签的角度和对齐方式



###3.What factors predominantly lead to flight cancellations?

cancelled <- airpline %>% filter(Cancelled == 1)%>%
  count(CancellationCode, name = "Frequency")
ggplot(cancelled,aes(x="",y=Frequency,fill=CancellationCode))+
  geom_bar(stat = "identity", width = 1)+
  coord_polar(theta = "y") +
  scale_fill_discrete(labels = c(A = "Carrier", B = "Weather", C = "National Aviation System", D = "Security"))+
  labs(title = "Proportion of Flight Cancellation Reasons",x = NULL,y = NULL,fill = "Reason")+
  theme(axis.text.x = element_blank(),axis.ticks.x = element_blank(),axis.title.x = element_blank(), panel.grid = element_blank()) +
  theme_minimal()


ggplot(data = cancelled, aes(x = "", y = Frequency, fill = CancellationCode)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  scale_fill_discrete(labels = c(A = "Carrier", B = "Weather", C = "National Aviation System", D = "Security")) +
  labs(title = "Proportion of Flight Cancellation Reasons",
       x = NULL,
       y = NULL,
       fill = "Reason") +
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank(),
        panel.grid = element_blank())

###4.Which flight experiences the most frequent and significant delays and cancellations?
#FlightNum,UniqueCarrier

# 计算取消次数
cancelled_count <- airpline %>%
  group_by(UniqueCarrier, FlightNum) %>%
  summarize(
    Cancellations = sum(Cancelled == 1, na.rm = TRUE),
    TotalFlights = n(),
    CancellationRate = Cancellations / TotalFlights,  # 直接在summarize中计算CancellationRate
    .groups = 'drop'
  ) %>%
  filter(TotalFlights > 30)  # 过滤操作保持不变
# 只考虑有足够数据点的航班

# 找出取消率最高的前10个航班
top_cancelled <- cancelled_count %>%arrange(desc(CancellationRate)) %>%
  slice_head(n = 10)

ggplot(top_cancelled, aes(x = reorder(paste(UniqueCarrier, FlightNum), -CancellationRate), y = CancellationRate)) +
  geom_col(fill = "tomato") +
  labs(title = "Top 10 Flights with Highest Cancellation Rates",
       x = "Flight",
       y = "Cancellation Rate") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # 调整X轴标签角度以提高可读性


# 计算每个航班的延误次数和平均延误时间
flight_delays <- airpline %>%
  filter(Cancelled == 1) %>%  # 只考虑实际有延误的情况
  group_by(UniqueCarrier, FlightNum) %>%
  summarize(
    DelayInstances = n(),  # 延误的次数
    AverageDelay = mean((DepDelay + ArrDelay)/2, na.rm = TRUE),  # 计算平均延误时间
    .groups = 'drop'
  )

# 选择延误次数最多的前10个航班
top_delayed_flights <- flight_delays %>%
  arrange(desc(DelayInstances)) %>%
  slice_head(n = 10)
# 可视化最频繁延误的航班
ggplot(top_delayed_flights, aes(x = reorder(paste(UniqueCarrier, FlightNum), -DelayInstances), y = DelayInstances)) +
  geom_col(fill = "steelblue") +
  labs(title = "Top 10 Most Frequently Delayed Flights",
       x = "Flight",
       y = "Number of Delay Instances") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))










                                          

