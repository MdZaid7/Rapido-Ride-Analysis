-- Check Total Rows

SELECT COUNT(*) AS Total_Rows
FROM Bookings;


-- Check Duplicate Booking IDs

SELECT Booking_ID,
COUNT(*) AS Duplicate_Count
FROM Bookings
GROUP BY Booking_ID
HAVING COUNT(*) > 1;


-- Check NULL Values

SELECT
COUNT(*) AS Total_Rows,

SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Null_Date,
SUM(CASE WHEN Time IS NULL THEN 1 ELSE 0 END) AS Null_Time,
SUM(CASE WHEN Booking_ID IS NULL THEN 1 ELSE 0 END) AS Null_BookingID,
SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Null_CustomerID,

SUM(CASE WHEN V_TAT IS NULL THEN 1 ELSE 0 END) AS Null_V_TAT,
SUM(CASE WHEN C_TAT IS NULL THEN 1 ELSE 0 END) AS Null_C_TAT,

SUM(CASE WHEN Driver_Ratings IS NULL THEN 1 ELSE 0 END) AS Null_Driver_Ratings,
SUM(CASE WHEN Customer_Rating IS NULL THEN 1 ELSE 0 END) AS Null_Customer_Ratings,

SUM(CASE WHEN Booking_Value IS NULL THEN 1 ELSE 0 END) AS Null_Booking_Value,
SUM(CASE WHEN Ride_Distance IS NULL THEN 1 ELSE 0 END) AS Null_Ride_Distance

FROM Bookings;


-- Check Negative Booking Value

SELECT *
FROM Bookings
WHERE Booking_Value < 0;


-- Check Negative Ride Distance

SELECT *
FROM Bookings
WHERE Ride_Distance < 0;


-- Check Invalid Ratings

SELECT *
FROM Bookings
WHERE Driver_Ratings NOT BETWEEN 1 AND 5
OR Customer_Rating NOT BETWEEN 1 AND 5;


-- Check Booking Status

SELECT DISTINCT Booking_Status
FROM Bookings
ORDER BY Booking_Status;


-- Check Payment Methods

SELECT Payment_Method,
COUNT(*) AS Total
FROM Bookings
GROUP BY Payment_Method
ORDER BY Total DESC;


-- Convert 'null' to SQL NULL

UPDATE Bookings
SET Payment_Method = NULL
WHERE Payment_Method='null';


-- Verify Payment NULLs

SELECT Booking_Status,
COUNT(*) AS Total
FROM Bookings
WHERE Payment_Method IS NULL
GROUP BY Booking_Status;


-- Find 'null' Strings

SELECT

SUM(CASE WHEN Canceled_Rides_by_Customer='null'
THEN 1 ELSE 0 END) AS Customer_Cancel_Null,

SUM(CASE WHEN Canceled_Rides_by_Driver='null'
THEN 1 ELSE 0 END) AS Driver_Cancel_Null,

SUM(CASE WHEN Incomplete_Rides_Reason='null'
THEN 1 ELSE 0 END) AS Incomplete_Reason_Null

FROM Bookings;


-- Convert 'null' to SQL NULL

UPDATE Bookings
SET Canceled_Rides_by_Customer=NULL
WHERE Canceled_Rides_by_Customer='null';

UPDATE Bookings
SET Canceled_Rides_by_Driver=NULL
WHERE Canceled_Rides_by_Driver='null';

UPDATE Bookings
SET Incomplete_Rides_Reason=NULL
WHERE Incomplete_Rides_Reason='null';


-- Check Extra Spaces

SELECT *
FROM Bookings
WHERE Booking_Status<>LTRIM(RTRIM(Booking_Status))
OR Vehicle_Type<>LTRIM(RTRIM(Vehicle_Type))
OR Pickup_Location<>LTRIM(RTRIM(Pickup_Location))
OR Drop_Location<>LTRIM(RTRIM(Drop_Location))
OR Payment_Method<>LTRIM(RTRIM(Payment_Method));


-- Check Date Range

SELECT
MIN(Date) AS Start_Date,
MAX(Date) AS End_Date
FROM Bookings;


-- Check Ride Distance

SELECT
MIN(Ride_Distance) AS Min_Distance,
MAX(Ride_Distance) AS Max_Distance,
AVG(Ride_Distance) AS Avg_Distance
FROM Bookings;


-- Check Booking Value

SELECT
MIN(Booking_Value) AS Min_Booking_Value,
MAX(Booking_Value) AS Max_Booking_Value,
AVG(Booking_Value) AS Avg_Booking_Value
FROM Bookings;


-- Check Vehicle Types

SELECT DISTINCT Vehicle_Type
FROM Bookings
ORDER BY Vehicle_Type;


-- Check Pickup Locations

SELECT COUNT(DISTINCT Pickup_Location) AS Total_Pickup_Locations
FROM Bookings;


-- Check Drop Locations

SELECT COUNT(DISTINCT Drop_Location) AS Total_Drop_Locations
FROM Bookings;


-- Check Booking IDs

SELECT TOP 20 Booking_ID
FROM Bookings;


-- Add Day Type Column

ALTER TABLE Bookings
ADD Day_Type VARCHAR(10);


UPDATE Bookings
SET Day_Type =
CASE
WHEN DATENAME(WEEKDAY,Date) IN ('Saturday','Sunday')
THEN 'Weekend'
ELSE 'Weekday'
END;


-- Add Time Slot Column

ALTER TABLE Bookings
ADD Time_Slot VARCHAR(20);


UPDATE Bookings
SET Time_Slot =
CASE

WHEN CAST(Time AS TIME)>='00:00:00'
AND CAST(Time AS TIME)<'06:00:00'
THEN 'Late Night'

WHEN CAST(Time AS TIME)>='06:00:00'
AND CAST(Time AS TIME)<'12:00:00'
THEN 'Morning'

WHEN CAST(Time AS TIME)>='12:00:00'
AND CAST(Time AS TIME)<'17:00:00'
THEN 'Afternoon'

WHEN CAST(Time AS TIME)>='17:00:00'
AND CAST(Time AS TIME)<'21:00:00'
THEN 'Evening'

ELSE 'Night'

END;