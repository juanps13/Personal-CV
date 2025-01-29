/* --- DATA CLEANING PART 1: Removing duplicates --- */

/* Since there is no primary key in the revenues database or unique column, we'll check if there are two exactly equal rows */

WITH duplicates_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY hotel, is_canceled, lead_time, arrival_date_year, arrival_date_month, arrival_date_week_number, arrival_date_day_of_month, stays_in_weekend_nights, stays_in_week_nights,
adults, children, babies, meal, country, market_segment, distribution_channel, is_repeated_guest, previous_cancellations, previous_bookings_not_canceled,
reserved_room_type, assigned_room_type, booking_changes, deposit_type, agent, company, days_in_waiting_list, customer_type, adr, total_of_special_requests, reservation_status, 
reservation_status_date ) AS row_num
FROM (
	SELECT * FROM revenue_2020
	UNION
	SELECT * FROM revenue_2019
	UNION
	SELECT * FROM revenue_2018) AS consolidated_table
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1;

/* There are duplicates. Therefore, we will create a secondary consolidated table (so that raw data is not altered)
 and remove duplicates from it. */

CREATE TABLE revenue_total (
	hotel VARCHAR(30),
	is_canceled BOOLEAN,
	lead_time INT,
	arrival_date_year INT,
	arrival_date_month VARCHAR(30),
	arrival_date_week_number INT,
	arrival_date_day_of_month INT,
	stays_in_weekend_nights INT,
	stays_in_week_nights INT,
	adults INT,
	children INT,
	babies INT,
	meal VARCHAR(50),
	country VARCHAR(3),
	market_segment VARCHAR(50),
	distribution_channel VARCHAR(50),
	is_repeated_guest BOOLEAN,
	previous_cancellations INT,
	previous_bookings_not_canceled INT,
	reserved_room_type VARCHAR(30),
	assigned_room_type VARCHAR(30),
	booking_changes INT,
	deposit_type VARCHAR(30),
	agent INT,
	company INT,
	days_in_waiting_list INT,
	customer_type VARCHAR(50),
	adr FLOAT,
	required_car_parking_spaces INT,
	total_of_special_requests INT,
	reservation_status VARCHAR(50),
	reservation_status_date DATE,
    row_num INT
);

/* The we insert the values to the new table. Note that the new table has also the "row_num" column we used to check duplicates */

INSERT INTO revenue_total
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY hotel, is_canceled, lead_time, arrival_date_year, arrival_date_month, arrival_date_week_number, arrival_date_day_of_month, stays_in_weekend_nights, stays_in_week_nights,
adults, children, babies, meal, country, market_segment, distribution_channel, is_repeated_guest, previous_cancellations, previous_bookings_not_canceled,
reserved_room_type, assigned_room_type, booking_changes, deposit_type, agent, company, days_in_waiting_list, customer_type, adr, total_of_special_requests, reservation_status, 
reservation_status_date ) AS row_num
FROM (
	SELECT * FROM revenue_2020
	UNION
	SELECT * FROM revenue_2019
	UNION
	SELECT * FROM revenue_2018) AS consolidated_table;
    
/* Finally we remove the duplicates from the new table */
    
DELETE
FROM revenue_total
WHERE row_num > 1;

/* --- DATA CLEANING PART 2: blank data --- */

/* There are 8 NULLS in "children" column */

SELECT
	COUNT(*),
    children
FROM revenue_total
GROUP BY children;

/* We will assume that if there is a NULL is because there are no children in that reservation */

UPDATE revenue_total
SET children = 0
WHERE children IS NULL;

/* --- DATA CLEANING PART 3: "adr" issue --- */

/* "ADR" is "average daily rate" and is one of the key columns in the analysis since it represents 
the average amount of dollars that the guest spend daily in the hotel.
Therefore, it shouldn't be below "0" */

SELECT *
FROM revenue_total
WHERE adr < 0;

/* There is one, so we should exclude it from the analysis since probably it's a typo*/

DELETE
FROM revenue_total
WHERE adr < 0;