#1
SELECT 
    Name AS Airline,
    MAX(DepDelay) AS MaxDelayMinutes
FROM 
    al_perf
JOIN 
    L_AIRLINE_ID 
ON 
   al_perf.DOT_ID_Reporting_Airline = 	L_AIRLINE_ID.ID
GROUP BY 
    Name
ORDER BY 
    MaxDelayMinutes desc;
    
#17 rows returned
# from al_perf, select Name and set as airline,select maximum number of depDelay
#since i am finding maximal departure.  set this name as 
# MaxDelayMinutes
#then join with L_AIRLINE_ID
#with condition al_perf's DOT_ID_Reporting_Airline equals with L_AIRLINE_ID's ID
#then group by Name
#lastly order it by EarlyDEpartureMinutes descending
    
#2.
SELECT 
    Name AS Airline,
    min(DepDelay) AS EarlyDepartureMinutes
FROM 
    al_perf
JOIN 
    L_AIRLINE_ID 
ON 
   al_perf.DOT_ID_Reporting_Airline = 	L_AIRLINE_ID.ID
GROUP BY 
    Name
ORDER BY 
    EarlyDepartureMinutes ASC;

#17 rows returned
# from al_perf, seect Name and set as airline,select minimum number of depDElay
#since i am finding early departure, that is with negative value, set this name as 
# EarlyDeparttureMinutes
#then join with L_AIRLINE_ID
#with condition al_perf's DOT_ID_Reporting_Airline equals with L_AIRLINE_ID's ID
#then group by Name
#lastly order it by EarlyDEpartureMinutes accending(negative values)
    

#3.
SELECT 
    L_WEEKDAYS.Day AS Day,
    COUNT(*) AS NumberOfFlights,
    rank() OVER (ORDER BY COUNT(*) DESC) as Ranking
    
FROM al_perf
JOIN L_WEEKDAYS  on al_perf.DayOfWeek = L_WEEKDAYS.Code
GROUP BY 
    DayOfWeek
ORDER BY 
    NumberOfFlights DESC;
    
#7 rows returned
# select days in L-WEEKDAYS and set as Day, count all and set as NumberOfFlights
#and use rank() over to rank the NUmberOfFlights as set previous step and set this as ranking
#these are from al_perf(Day from L_WEEKDAYS)
#now join with L_WEEKDAYS with condition   al_perf's DayOfWeek is equal to L_WEEKDAYS's Code  
#next group it by DayofWeek
#finally order it respect to NumberOfFlights
    
    
#4.
WITH AirportDelays AS (
    SELECT 
        s.OriginAirportID AS AirportID,
        AVG(s.DepDelayMinutes) AS AvgDelay
    FROM 
        al_perf s
    GROUP BY 
        s.OriginAirportID
)
SELECT 
    a.Name AS AirportName,
    a.ID AS AirportCode,
    d.AvgDelay
FROM 
    AirportDelays d
JOIN 
    L_AIRPORT_ID a
ON 
    d.AirportID = a.ID
ORDER BY 
    d.AvgDelay DESC
LIMIT 1;
#1 row returned
# create temporary relation call as airprotDelays using with, inside, 
#select OriginAirportID,set as AirportID and averaged DepDelayMinutes set as Avgdelay
#DePDelayMInutes set 0 for early departures,so it considers departure delays and 0 minute delay
#all these from al_perf, group it by AirportID
#next, select name and set as AirportName, ID , set as AirportCode,  AvgDelay from AirportDelays
#join this with L_AIRPORT_ID with condition AirportID in AirportDelays equals to L_AIRPORT_ID's ID
#order it repsect to AvgDelay
#finally, output just one line, using limit 1 



#5.
WITH airlineairportdelay AS (
    SELECT 
        s.DOT_ID_Reporting_Airline AS AirlineID,
        s.OriginAirportID AS AirportID,
        AVG(s.DepDelayMinutes) AS AvgDelay
    FROM 
        al_perf s
    GROUP BY 
        s.DOT_ID_Reporting_Airline, s.OriginAirportID
),
maxdelayperairline AS (
    SELECT d.AirlineID,d.AirportID,d.AvgDelay
    FROM airlineairportdelay d
    JOIN (
        SELECT 
            AirlineID,MAX(AvgDelay) AS MaxDelay
        FROM airlineairportdelay
        GROUP BY AirlineID
    ) m
    ON d.AirlineID = m.AirlineID AND d.AvgDelay = m.MaxDelay
)

SELECT a.Name AS AirlineName,p.Name AS AirportName,m.AvgDelay
FROM maxdelayperairline m
JOIN L_AIRLINE_ID a ON m.AirlineID = a.ID
JOIN L_AIRPORT_ID p ON m.AirportID = p.ID;

#17rows returned    
#create temporary relation name as AirlineAirportDelay
#inside,  select DOT_D_reporting_Airline name as airlineID
#OriginAirportID name as AirportID
#averaged DepDelayMinutes name as avgdelay(DepDelayMinuutes set 0 for early departure so it is much
#better to use this rather than using DepDelay )
#now group it by DOT_D_reporting_Airline name,OriginAirportID
#create temporary relation maxdelayperairline
#inside, first select AirlineID,AirportID,AvgDelay from airlineairportdelay
# join with m, where m is a table that select AirlineID,maximum of AvgDelay that i got from
#airlineairportdelay,name as MaxDelay
#these are from airlineairportdelay, then group it by AirlineID,
#this is expected to give maximum average delay for each AirlineID
#join airlineairportdelay with m, 
#with condition airlineairportdelay and m's AirlineID is equal
#and airlineairportdelay's AvgDelay and m's MaxDelay is equal
# select Name from L_AIRLINE_D, avgDelay from maxdelatperairline(one got just before)
#Name from L_AIRPORT_ID name as AirportName
#for join with L_AIRLINE_ID with condition AirlineID from m and ID from L_AIRLINE_ID is equal
# join again with L_AIRPORT_ID with condition AirportID form m and ID from L_AIRPORT_ID is equal

#6a
select * from al_perf
where Cancelled = 1;
#10016 rows returned
# select all from al_perf, with condiion Cancelled = 1, since 
#Cancelled =1 refers to flight has been cancelled

#6b
WITH cancel AS (
    SELECT 
        s.OriginAirportID AS airportID,
        c.Reason AS reason,
        COUNT(*) AS cancelcount
    FROM 
        al_perf s
    JOIN 
        L_CANCELATION c
    ON 
        s.CancellationCode = c.Code
    WHERE 
        s.Cancelled = 1
    GROUP BY 
        s.OriginAirportID, c.Reason
),
frequentreason AS (
    SELECT 
        airportID,
        reason,
        cancelcount
    FROM 
        cancel
    WHERE 
        cancelcount = (
            SELECT 
                MAX(cancelcount)
            FROM 
                cancel cc
            WHERE 
                cc.airportID = cancel.airportID
        )
)
SELECT 
    a.Name AS AirportName,
    m.reason,
    m.cancelcount
FROM 
    frequentreason m
JOIN 
    L_AIRPORT_ID a
ON 
    m.airportID = a.ID;
#285 rows returned
# create temporary relation using with naming as cancel
#inside, select OriginAirportID from al_perf,name as airportID
#Reason from L_CANCELLATION, count all naming as cancelcount 
#join al_perf with L_CANCELATION with condition CancellationCode in al_perf equals to 
#L_CANELATION'S Code. also Cancelled in al_perf is 1(1 if flight cancelled)
#then group by OriginAirportID and Reason
#next set temporary relation naming as frequentreason
##select airportID,reason,cancelcount from cancel(one created before)
#with condition on cancelcount; select maximum of concelcount from cancel name as cc(one created before)
#with condition airportID in cc is equal to airprotID in cancel
#finally selct Name from L_AIRPORT-ID, reason 
#and cancelcount from frequentreason(one created just before)
# join with L_AIRPORT-ID  with condition airportID in frequentreason is equal to L_AIRPORT_ID'S ID



#7
WITH countflight AS (
    SELECT FlightDate,COUNT(*) AS dayflights
    FROM al_perf
    GROUP BY FlightDate
),
averageflightbyday AS (
    SELECT c1.FlightDate,
        CASE 
            WHEN COUNT(c1.dayflights) < 3 THEN NULL
            ELSE AVG(c2.dayflights)
        END AS flights_over_preceding_three_days
    FROM countflight c1
    LEFT JOIN countflight c2
    ON c2.FlightDate BETWEEN DATE_SUB(c1.FlightDate, INTERVAL 3 DAY) 
    AND DATE_SUB(c1.FlightDate, INTERVAL 1 DAY)
    GROUP BY c1.FlightDate
)
SELECT FlightDate,flights_over_preceding_three_days
FROM averageflightbyday
WHERE flights_over_preceding_three_days IS NOT NULL
ORDER BY FlightDate;
#27 rows returned
# create temporary relation name as countflight
#inside flightDate and count it all, name this as dayflights
#from al_perf and group it by FlightDate
# create temporary relation name as averageflightbyday
#inside create condition for first three days, set as null because 
#information needeed average number of flight over the 3 proceeding day
#so for first three days, there would be no average number of flights
# select  flightDate from countflight name as c1
# now left join with countflight that name as c2
# with condition; here i am finding average flights for three day interval
#so by using DATE_SUb, i am subtracting three days from FlightDate,
#which will expected to show start of the range
#for second part in between~and, this will perform same, but subtracting 
#one day from flightDate 
#so this line will give date range needed for three proceeding date
#which is range 1-3 days for computaion on number of flights over the 3 proceeding date
#next, group it by FlightDate
# select FlightDate,flights_over_preceding_three_days from averageflightbyday
# put condition only produce output that is not null, that is 
#exclude first three days(in my case 2019/09/01- 2019/09/03 will be excluded)
#finally, order it by FlightDate


