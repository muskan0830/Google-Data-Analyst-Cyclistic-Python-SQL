-- Create a temporary table for the analysis
--The dataset is very large, so in order to improve the performance of query we are creating temporary table with only necessary columns.

CREATE TEMPORARY TABLE riders_analysis AS
SELECT ride_id,
       rideable_type, 
       started_at, 
	   ended_at, 
	   member_casual 
FROM cyclist;



--DATA TRANSFORMATION
-- Add new columns
ALTER TABLE riders_analysis
ADD COLUMN month VARCHAR(20),
ADD COLUMN weekday VARCHAR(20),
ADD COLUMN ride_length TIME,
ADD COLUMN time_of_day VARCHAR;

-- Update the new columns with extracted values
UPDATE riders_analysis
SET 
    month = TO_CHAR(started_at, 'Month'),
    weekday = TO_CHAR(started_at, 'Day'),
	ride_length = ended_at - started_at,
	time_of_day = CASE
                       WHEN EXTRACT(HOUR FROM started_at) >= 5 AND EXTRACT(HOUR FROM started_at) < 12 THEN 'Morning'
                       WHEN EXTRACT(HOUR FROM started_at) >= 12 AND EXTRACT(HOUR FROM started_at) < 17 THEN 'Afternoon'
                       WHEN EXTRACT(HOUR FROM started_at) >= 17 AND EXTRACT(HOUR FROM started_at) < 20 THEN 'Evening'
                       ELSE 'Night'
                  END;


-- Let's create a new table with the columns necessary for our analysis

CREATE TABLE riders_cyclist AS
SELECT ride_id,
       rideable_type,
       member_casual,
	   started_at,
	   month,
	   weekday,
	   ride_length,
	   time_of_day
FROM riders_analysis;



-- DATA CLEANING

-- Check for null values
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'riders_cyclist'
  AND table_schema = 'public'
  AND EXISTS (
    SELECT 1
    FROM riders_cyclist
    WHERE column_name IS NULL
  );
-- no null values

-- check if values are consistent

SELECT DISTINCT rideable_type
FROM riders_cyclist;
-- electric, classic, docked 

SELECT DISTINCT member_casual
FROM riders_cyclist;
-- casual, member



-- ANALYSIS

-- A. GENERAL OVERVIEW

-- A1. What's the breakdown between members and casual riders?

SELECT COUNT(ride_id) AS Count_by_member_type,
       member_casual
FROM riders_analysis
GROUP BY 2
ORDER BY 1 DESC;
-- RESULT: 3.6M-MEMBER, 2M-CASUAL



-- A2. What's the breakdown between ride types?

SELECT COUNT(ride_id) AS Count_by_ride_type,
      rideable_type
FROM riders_analysis
GROUP BY 2
ORDER BY 1 DESC;
-- RESULT: 2.9m - electric bike, 2.6m - classic bike, 0.07m - docked bike
 


--A3. Average Ride Length

SELECT AVG(ride_length) AS Average_ride_length
FROM riders_cyclist;
-- average ride length: 15 mins 25 sec



--A4. Total number of rides

SELECT COUNT(ride_id) AS Total_no_of_rides
FROM riders_cyclist;
-- Total no of rides: 5719877


-- A5. which ride type member or casual riders prefer?
SELECT COUNT(rideable_type) AS count,
       rideable_type,
	   member_casual
FROM riders_cyclist
GROUP BY 2,3
ORDER BY 1 DESC;
-- electric bike: 1.84m- member, 1.1m - casual; classic bike: 1.81-member, 0.8m-casual; docked bike- 0.07m - casual


--A6. Average ride length for member type
SELECT AVG(ride_length) AS average_ride_length,
       member_casual
FROM riders_cyclist
GROUP BY 2
ORDER BY 1 DESC;
-- On average: 21 mins-casual, 12 minutes-member


--A7. Average ride length for rideable type
SELECT AVG(ride_length) AS average_ride_length,
       rideable_type
FROM riders_cyclist
GROUP BY 2
ORDER BY 1 DESC;
-- on average: 1 hour 6 mins: docked_bike, 17 mins: classic_bike, 12mins : electric_bike



-- B. TOTAL NUMBER OF RIDES

-- B1. Most Ride count by months, member type and ride types
SELECT COUNT(ride_id) AS ride_count,
	   month,
	   rideable_type,
	   member_casual
FROM riders_cyclist
GROUP BY 2,3,4
ORDER BY 1 DESC;
-- Most rides for members:
--   August: 248,367 rides (classic bike)
--   June: 221,436 rides (electric bike)
--   July: 219,248 rides (classic bike)
--
-- Least rides for members:
--   March: 25,287 rides (docked bike)
--   January: 24,361 rides (electric bike)
--   February: 24,299 rides (electric bike)
--
-- Most rides for casual users:
--   July: 170,052 rides (electric bike)
--   June: 169,662 rides (electric bike)
--   August: 146,579 rides (electric bike)
--
-- Least rides for casual users:
--   January: 1,738 rides (docked bike)
--   February: 2,495 rides (docked bike)
--   March: 3,020 rides (docked bike)
--
-- Insights:
--   - Classic bikes are the most popular rideable type for both members and casual users.
--   - Electric bikes are also popular, particularly among members, with significant usage in August, June, and July.
--   - Docked bikes have the least usage overall, with particularly low usage in January, February, and March.
--   - Casual users show a preference for electric bikes, especially in July, June, and August, possibly indicating a preference for leisurely rides.
--   - Member usage is more evenly distributed across rideable types, with classic bikes being the most preferred choice.


-- B2. Most Ride count by week days, member type and ride types
SELECT COUNT(ride_id) AS ride_count,
	   weekday,
	   rideable_type,
	   member_casual
FROM riders_cyclist
GROUP BY 2,3,4
ORDER BY 1 DESC;
-- Most rides for members:
--   Thursday: 301,117 rides
--   Wednesday: 297,302 rides
--   Tuesday: 290,240 rides

-- Most rides for casual users:
--   Saturday: 20,276 rides
--   Sunday: 16,541 rides
--   Friday: 17,271 rides

-- Least rides overall:
--   Docked bike: 17,286 rides (Saturday)
--   Docked bike: 14,933 rides (Sunday)
--   Docked bike: 11,450 rides (Friday)

-- Insights:
--   - Members tend to ride more on weekdays, with Thursday, Wednesday, and Tuesday being the busiest days.
--   - Casual users, on the other hand, prefer weekends, especially Saturday and Sunday.
--   - Docked bikes are the least popular option overall, with the fewest rides occurring on Saturdays, Sundays, and Fridays.



-- B3. Most Ride count by time of day, member type and ride types
SELECT COUNT(ride_id) AS ride_count,
	   time_of_day,
	   rideable_type,
	   member_casual
FROM riders_cyclist
GROUP BY 2,3,4
ORDER BY 1 DESC;

-- Most rides for members:
--   "Afternoon" on "electric_bike": 594,404 rides
--   "Afternoon" on "classic_bike": 584,564 rides
--   "Morning" on "classic_bike": 539,787 rides

-- Most rides for casual riders:
--   "Afternoon" on "electric_bike": 386,153 rides
--   "Afternoon" on "classic_bike": 331,743 rides
--   "Morning" on "electric_bike": 234,986 rides

-- Least rides:
--   "Night" on "classic_bike": 146,146 rides (for casual riders)
--   "Morning" on "docked_bike": 14,637 rides (for casual riders)

-- Insights:
-- - Members prefer electric bikes for afternoon rides, while classic bikes are popular for both morning and afternoon rides.
-- - Casual riders also favor electric bikes for afternoon rides, but the number of rides is notably lower compared to members.
-- - Nighttime rides, particularly on classic bikes, are the least common among casual riders.
-- - Docked bikes are least used for morning rides by casual riders, indicating a potential area for promotion or encouragement.




-- C. AVERAGE RIDE LENGTHS

-- C1. Months with highest average ride length by rider type and rideable_type
SELECT AVG(ride_length) AS average_ride_length,
	   month,
	   rideable_type
FROM riders_cyclist
WHERE member_casual ='casual'
GROUP BY 2,3
ORDER BY 1 DESC;
-- Casual:
-- Most: July-1hour 10 minutes - docked bike;
-- Least: January - 9 minutes - electric bike

SELECT AVG(ride_length) AS average_ride_length,
	   month,
	   rideable_type
FROM riders_cyclist
WHERE member_casual ='member'
GROUP BY 2,3
ORDER BY 1 DESC;

-- Member:
-- highest: July&August: 14 minutes - classic_bike 
-- Lowest: March, January, December, Feb: 9 mins - electric bike



-- C2. Weekdays with highest average ride length by rider type and rideable_type
SELECT AVG(ride_length) AS average_ride_length,
	   weekday,
	   member_casual,
	   rideable_type
FROM riders_cyclist
GROUP BY 2,3,4
ORDER BY 1 DESC;
--Most rides for members:
--   Friday: with an average ride length of 14 minutes, 33 seconds, mostly on classic bikes
--   Saturday: with an average ride length of 14 minutes, 33 seconds, mostly on classic bikes

-- Most rides for casual riders:
--   Sunday: with an average ride length of 1 hour, 9 minutes, 54 seconds, mostly on docked bikes
--   Saturday: with an average ride length of 1 hour, 9 minutes, 20 seconds, mostly on docked bikes

-- Least rides:
--   February: with an average ride length of 19 minutes, 1 second, mostly by casual riders on docked bikes

-- Insights:
--   1. Sundays and Saturdays see the most rides, particularly for casual riders, possibly due to weekend leisure activities.
--   2. Fridays and Saturdays are popular for members, likely for both commuting and leisure.
--   3. Electric bikes are popular among both members and casual riders, with shorter average ride lengths compared to docked bikes.
--   4. Classic bikes are predominantly used by members, whereas casual riders prefer docked bikes for longer rides.
--   5. There's a significant difference in ride lengths between casual and member riders, with casual rides often being much longer.


-- C3. Time of day with highest average ride length by rider type and rideable_type
SELECT AVG(ride_length) AS average_ride_length,
	   time_of_day,
	   rideable_type
FROM riders_cyclist
WHERE member_casual = 'casual'
GROUP BY 2,3
ORDER BY 1 DESC;
-- on docked bike: over 1 hour for evening, morning, night and afternoon
-- 27 mins on classic_bike in afternoon
--least: Morning, Night: 13 mins on electric bike


SELECT AVG(ride_length) AS average_ride_length,
	   time_of_day,
	   rideable_type
FROM riders_cyclist
WHERE member_casual = 'member'
GROUP BY 2,3
ORDER BY 1 ASC;

-- highest: 13 mins: Afternoon, Night, evening - classic_bike
-- lowest: Morning: 10 mins - electric_bike