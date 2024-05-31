# Explore-flight-delays-and-cancellations(by using R and Pig)

## Analyze and explore the following questions :

What are the optimal times of day, days of the week, and times of the year for minimizing flight delays?

What are the primary factors contributing to flight delays?

What factors predominantly lead to flight cancellations?

Which flight experiences the most frequent and significant delays and cancellations?

## Data set introduction ：

The analysis used data on arrival and departure details for all commercial flights on major U.S. airlines during Data Expo 2006. You can download the dataset from this link https://tinyurl.com/u8rzvdsx , or from 2006.csv on the page.
This data set contains over 11 million observations of flight data with 29 columns:

**Year [int]:** Year of the dataset (1999 & 2000)

**Month [int]:** Month of the observation (1 - Jan, 2 - Feb, etc.)

**DayofMonth [int]:** Day of the month (1 - 31, if applicable)

**DayOfWeek [int]:** Day of the week (1 - Mon, 2 - Tue, etc.)

**DepTime [int]:** Actual departure time (local time zone %H%M format)

**CRSDepTime [int]:** Scheduled departure time (local time zone %H%M format)

**ArrTime [int]:** Actual arrival time (local time zone %H%M format)

**CRSArrTime [int]:** Scheduled arrival time (local time zone %H%M format)

**UniqueCarrier [int]:** Unique carrier code to identify the carriers in carriers.csv

**FlightNum [int]:** Flight number

**TailNum [str]:** Unique tail number to identify the planes in plane-data.csv

**ActualElapsedTime [int]:** Difference between ArrTime and DepTime in minutes, also sum of AirTime, TaxiIn, TaxiOut

**CRSElapsedTime [int]:** Difference between CRSArrTime and CRSDepTime in minutes

**AirTime [int]:** Air time in minutes

**ArrDelay [int]:** Difference between ArrTime and CRSArrTime in minutes

**DepDelay [int]:** Difference between DepTime and CRSDepTime in minutes

**Origin [str]:** Unique IATA airport code that flight was departed from, can be identified in airports.csv

**Dest [str]:** Unique IATA airport code for flight destination, can be identified in airports.csv

**Distance [int]:** Flight distance in miles

**TaxiIn [int]:** Taxi-in time in minutes

**TaxiOut [int]:** Taxi-out time in minutes

**Cancelled [int]:** Flight cancellation (1 - Cancelled, 0 - Not Cancelled)

**CancellationCode [str]:** Flight cancellation reason (A - Carrier, B - Weather, C - National Aviation System, D - Security)

**Diverted [int]:** Fight diverted (1 - Diverted, 0 - Not diverted)

**CarrierDelay [int]:** Delay caused by carrier in minutes

**WeatherDelay [int]:** Delay caused by weather in minutes

**NASDelay [int]:** Delay caused by National Aviation System in minutes

**LateAircraftDelay [int]:** Delay caused by previous late flight arrivals in minutes

## Information reference ：

Flight delay refers to a flight landing more than 15 minutes later than the planned landing time. Season is also a key factor in flight delays and cancellations, so this factor is included in the reanalysis.

## Analysis and insights on output charts :
### The optimal times of day for minimizing flight delays

In order to more intuitively compare which time period can best reduce delays, we segment it based on the departure time period and calculate the percentage of its delay time.

From the figure below, we can see that the 5 hour time period can best reduce delays because of its delay The lowest percentage is 8.1%. The highest delay percentage was 34.2% for 3 hours,

![1 3](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/31e01fbc-303a-426c-a5ce-7a2dcc65f7d0)

The following figure adds the influencing factor of season, and you can see how each time period changes with the season, which can help people plan their travel time more reasonably. 

In spring, summer and winter, 5 hour is the best time to reduce flight delays,but in autumn 4 hour is the best time to reduce flight delays. Delay rates are highest at 3 hour in summer, fall, and winter, while delays are highest at 19 hour in spring.

![2 3](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/bbe1cc84-5e4a-48cd-a1a6-cdf9636c680d)

### The optimal days of the week for minimizing flight delays

The best time of the week to reduce flight delays is Saturday. The average delay percentage on Saturday was 18.6%, Average delay percentage on Friday was highest at 26%.

![2 4](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/60ac57d4-afb0-423b-b00b-7d7e20f5c6fb)

In spring, summer and autumn, Fridays are the best days to minimize flight delays, and in winter, Tuesdays are the best days to minimize flight delays.

![2add9f62bac3f019e93ee5b8a67cb0d](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/ce80f7a0-cad8-49df-87fc-0a9c5988af85)


### The optimal times of the year for minimizing flight delays

The lowest delay rate in January was 18.4%, and the highest delay rate in December was 25%. May be affected by thunderstorms, the delay rate is generally higher in summer.

![0dbf06579406bd6b8cfc989c3dd4185](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/d7a83c0b-066b-41f0-a073-8a7b205f3534)



### The primary factors contributing to flight delays

The main factor causing flight delays is the National Aviation System, followed by previous late flight arrivals.

![c1961229b9ce24e97f5962f074d07b7](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/c30ae693-35a1-4128-a798-153fc1b22da0)

The main factor causing flight delays in any season is the National Aviation System.

![7598688e26107ec908a232a0c08c585](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/1160492f-27e3-4381-bd76-6387f36d8a7e)


### The primary factors lead to flight cancellations

The main factor causing flight cancellations is the carrier, followed by weather. Flights are rarely canceled for security reasons.

![b39f02e64603c44d04fca77b06755cb](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/9628581e-e209-46ac-9f97-1d8cc978ea17)

For spring, summer and autumn, the top cause of flight cancellations is Carrier, but for winter, the top cause of flight cancellations is weather.

![f40d5d44e0524a9667bbba1a16b7ccc](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/880d3cfa-9c40-4f22-82ac-596fa1146030)


### The most frequent and significant delays and cancellations of flights

Flight WN20 is the most frequently canceled, as can be seen from the top ten charts with the highest cancellation rate.

![image](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/3bd9bb19-ab52-49a9-8244-730cab3daf81)

The WN269 flights are delayed the most frequently, as can be seen from the top ten charts with the highest delay rates.

![image](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/6478d9a8-4aeb-4f99-8979-4d4712c9eaf7)








