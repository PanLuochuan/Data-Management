# Explore-flight-delays-and-cancellations-R-Pig

### Data set introduction ：

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

### Information reference ：

Flight delay refers to a flight landing more than 15 minutes later than the planned landing time. Season is also a key factor in flight delays and cancellations, so this factor is included in the reanalysis.

### Analysis and insights on output charts :

In order to more intuitively compare which time period can best reduce delays, we segment it based on the departure time period and calculate the percentage of its delay time.

From the figure below, we can see that the 5 hour time period can best reduce delays because of its delay The lowest percentage is 8.1%. The highest delay percentage was 34.2% for 3 hours,

![1 3](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/31e01fbc-303a-426c-a5ce-7a2dcc65f7d0)

The following figure adds the influencing factor of season, and you can see how each time period changes with the season, which can help people plan their travel time more reasonably. 

In spring, summer and winter, 5 hour is the best time to reduce flight delays,but in autumn 4 hour is the best time to reduce flight delays. Delay rates are highest at 3 hour in summer, fall, and winter, while delays are highest at 19 hour in spring.

![2 3](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/bbe1cc84-5e4a-48cd-a1a6-cdf9636c680d)

