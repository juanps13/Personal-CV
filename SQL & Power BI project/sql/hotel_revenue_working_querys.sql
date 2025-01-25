/* --- PART 1--- */
/* The main question we're trying to answer is if the total revenue is growing by year */

/* Query #1 - Revenue per year*/

SELECT 
	arrival_date_year, 
	ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr),1) AS revenue
FROM revenue_total
GROUP BY arrival_date_year;

/* Apparently revenue increased in 2019 but decreased in 2020. 
However, we're not taking into account the cancelled reservations, discunts, meal costs and 
other issues that should be included in the analysis.*/

/*The first question we should ask is whether we have data for the complete three years or only for certain months." */

/* Query #2 - Explore years and months of the data */

SELECT DISTINCT
	arrival_date_year,
    arrival_date_month
FROM
	revenue_total;

 /* Given that we don't have complete data for 2018 and 2020 we will have to 
 evaluate monthly data on a year-over-year basis */

/* Query #3 - Exploring the reservation statuses */

SELECT COUNT(reservation_status), reservation_status
FROM revenue_total
GROUP BY reservation_status;

/* There some rows as 'no show', we can assume that since there is any revenue from them is because they were not cancelled */

/* Query #4 - Final monthly year-over-year revenue, discounting cost of meal, applying discount as of market segment 
and considering cancelations*/

SELECT
    CONCAT(arrival_date_year, '_', arrival_date_month) AS date_ym,
    ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr*(1-market_segment.discount)),1) AS pre_meal_revenue,
    ROUND(SUM(meal_cost.cost),2) AS cost_of_meal,
    ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr*(1-market_segment.discount)) - SUM(meal_cost.cost),2) AS final_revenue
FROM revenue_total
LEFT JOIN market_segment
ON revenue_total.market_segment = market_segment.segment
LEFT JOIN meal_cost
ON revenue_total.meal = meal_cost.meal
WHERE is_canceled = 0
GROUP BY date_ym;

/* Earnings seem to be increasing year-over-year; with this table, a graph can be created to reflect this information clearly. */

/* --- PART 2 : Market segmentation --- */

/* Another question that can be asked is which are the more profitable market segments
First, we will check which segment has more cancelation rate and then which is the most profitable. */

/* Query #5 - Identify market segments with more cancellation rates */

SELECT
    market_segment,
    COUNT(*) AS total_reserves,
    SUM(is_canceled) AS total_cancelations,
    ROUND(SUM(is_canceled) * 100.0 / COUNT(*), 2) AS cancel_rate
FROM revenue_total
GROUP BY market_segment
ORDER BY cancel_rate DESC;

/* Query #6 - Identify the more profitable market segments */

WITH revenue_total AS (
    SELECT 
        stays_in_weekend_nights,
        stays_in_week_nights,
        adr,
        market_segment,
        meal
    FROM revenue_total
    WHERE is_canceled = 0
)

SELECT
    market_segment,
    COUNT(*) AS total_reserves,
    ROUND(SUM((stays_in_weekend_nights + stays_in_week_nights)*adr*(1-market_segment.discount)) - SUM(meal_cost.cost),2) AS final_revenue,
    ROUND((SUM((stays_in_weekend_nights + stays_in_week_nights)*adr*(1-market_segment.discount)) - SUM(meal_cost.cost)) / COUNT(*), 2) AS average_revenue
FROM revenue_total
LEFT JOIN market_segment
ON revenue_total.market_segment = market_segment.segment
LEFT JOIN meal_cost
ON revenue_total.meal = meal_cost.meal
GROUP BY market_segment
ORDER BY average_revenue DESC;

/* --- PART 3 : Type of guests --- */

/* WE will classify the type guests.
If the reservation has children or babies then it's "family",
If the reservation is for only one adult, then is "single",
if the reservation is for two adults, then is "couple",
if the reservation is for more than two adults, is "group" */

/* We will have to add a new column to the table and then calculate it */

ALTER TABLE revenue_total ADD COLUMN guest_type VARCHAR(10);

/* Then we calculte the new column */

UPDATE revenue_total
SET guest_type = 
	CASE 
    WHEN children > 0 OR babies > 0 THEN 'family'
    WHEN adults = 1 THEN 'single'
    WHEN adults = 2 THEN 'couple'
    ELSE 'group'
END;