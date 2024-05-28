# Explore-flight-delays-and-cancellations-R-Pig

The data set contains over 11 million observations of flight data with 29 columns. Based on the meta data provided by Harvard:

Year [int]: Year of the dataset (1999 & 2000)
Month [int]: Month of the observation (1 - Jan, 2 - Feb, etc.)
DayofMonth [int]: Day of the month (1 - 31, if applicable)
DayOfWeek [int]: Day of the week (1 - Mon, 2 - Tue, etc.)
DepTime [int]: Actual departure time (local time zone %H%M format)
CRSDepTime [int]: Scheduled departure time (local time zone %H%M format)
ArrTime [int]: Actual arrival time (local time zone %H%M format)
CRSArrTime [int]: Scheduled arrival time (local time zone %H%M format)
UniqueCarrier [int]: Unique carrier code to identify the carriers in carriers.csv
FlightNum [int]: Flight number
TailNum [str]: Unique tail number to identify the planes in plane-data.csv
ActualElapsedTime [int]: Difference between ArrTime and DepTime in minutes, also sum of AirTime, TaxiIn, TaxiOut
CRSElapsedTime [int]: Difference between CRSArrTime and CRSDepTime in minutes
AirTime [int]: Air time in minutes
ArrDelay [int]: Difference between ArrTime and CRSArrTime in minutes
DepDelay [int]: Difference between DepTime and CRSDepTime in minutes
Origin [str]: Unique IATA airport code that flight was departed from, can be identified in airports.csv
Dest [str]: Unique IATA airport code for flight destination, can be identified in airports.csv
Distance [int]: Flight distance in miles
TaxiIn [int]: Taxi-in time in minutes
TaxiOut [int]: Taxi-out time in minutes
Cancelled [int]: Flight cancellation (1 - Cancelled, 0 - Not Cancelled)
CancellationCode [str]: Flight cancellation reason (A - Carrier, B - Weather, C - National Aviation System, D - Security)
Diverted [int]: Fight diverted (1 - Diverted, 0 - Not diverted)
CarrierDelay [int]: Delay caused by carrier in minutes
WeatherDelay [int]: Delay caused by weather in minutes
NASDelay [int]: Delay caused by National Aviation System in minutes
LateAircraftDelay [int]: Delay caused by previous late flight arrivals in minutes

![1](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/b25bfa66-c139-4fe1-95fa-5e0db97cc0f8)
![2](https://github.com/PanLuochuan/Explore-flight-delays-and-cancellations-R-Pig/assets/152348928/a760bee4-5d08-4eff-92a5-a0b0c154462a)
