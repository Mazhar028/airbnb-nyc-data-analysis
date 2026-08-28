-- =====================================================================
-- AIRBNB OPEN DATA — SQL ANALYSIS
-- Author: Md Mazhar Imam
-- Database: project_airbnb | Table: airbnb_listings
-- Source: Cleaned dataset from Phase 1 (Pandas), 102,036 rows, 22 columns
-- =====================================================================


USE project_airbnb;

-- ---------------------------------------------------------------------
-- TABLE SETUP (for reference — already executed during project build)
-- ---------------------------------------------------------------------

CREATE TABLE airbnb_listings (
    id                              INT PRIMARY KEY,
    NAME                            VARCHAR(255),
    host_id                         BIGINT,
    host_identity_verified          VARCHAR(20),
    host_name                       VARCHAR(100),
    neighbourhood_group             VARCHAR(50),
    neighbourhood                   VARCHAR(100),
    latitude                        DECIMAL(9,6),
    longitude                       DECIMAL(9,6),
    instant_bookable                BOOLEAN,
    cancellation_policy             VARCHAR(20),
    room_type                       VARCHAR(50),
    construction_year               SMALLINT,
    price                           DECIMAL(10,2),
    service_fee                     DECIMAL(10,2),
    minimum_nights                  INT,
    number_of_reviews               INT,
    last_review                     DATE,
    reviews_per_month               DECIMAL(5,2),
    review_rate_number              TINYINT,
    calculated_host_listings_count  INT,
    availability_365                SMALLINT
); 

ALTER TABLE airbnb_listings
RENAME COLUMN lat to latitude;

SHOW TABLES;
DESCRIBE airbnb_listings;

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Airbnb_Cleaned_Data.csv'
INTO TABLE airbnb_listings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, NAME, host_id, host_identity_verified, host_name, neighbourhood_group, neighbourhood,
 latitude, longitude, instant_bookable, cancellation_policy, room_type, construction_year, price,
 service_fee, minimum_nights, number_of_reviews, @last_review, @reviews_per_month,
 review_rate_number, calculated_host_listings_count, availability_365)
SET 
    last_review = NULLIF(@last_review, ''),
    reviews_per_month = NULLIF(@reviews_per_month, '');
    
ALTER TABLE airbnb_listings
MODIFY COLUMN latitude DECIMAL(10, 7),
MODIFY COLUMN longitude DECIMAL(10, 7);

TRUNCATE TABLE airbnb_listings;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Airbnb_Cleaned_Data.csv'
INTO TABLE airbnb_listings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, NAME, host_id, host_identity_verified, host_name, neighbourhood_group, neighbourhood,
 latitude, longitude, instant_bookable, cancellation_policy, room_type, construction_year, price,
 service_fee, minimum_nights, number_of_reviews, @last_review, @reviews_per_month,
 review_rate_number, calculated_host_listings_count, availability_365)
SET 
    last_review = NULLIF(@last_review, ''),
    reviews_per_month = NULLIF(@reviews_per_month, '');


SELECT count(*) FROM airbnb_listings;
SELECT * FROM airbnb_listings LIMIT 5;	


-- """"""""""""""""""""""""""""
--            QUERIES 
-- """"""""""""""""""""""""""""


-- ================================================================================
-- Q) Which neighbourhood groups have the highest average prices?

-- FINDINGS:
-- Price shows almost no variation across groups (approx $8 spread) and
-- does not match real-world NYC pricing expectations (Manhattan should
-- lead but comes in lowest). Flagged as a likely synthetic/unreliable
-- column — see Limitations section of final report.
-- ================================================================================
SELECT * FROM airbnb_listings LIMIT 10;

	SELECT 
		neighbourhood_group, 
		COUNT(*) AS group_count, 
		ROUND(AVG(price), 2) AS average_price
	FROM airbnb_listings
    WHERE neighbourhood_group != 'Unknown'
	GROUP BY neighbourhood_group
	ORDER BY AVG(price) DESC;
    
-- ================================================================================
-- Q) Which room types generate the most listings?

-- FINDINGS: "Entire home/apt" and "Private room" dominate (approx 97% combined);
-- "Shared room" and "Hotel room" are a small minority.
-- ================================================================================
SELECT 
    room_type, 
	COUNT(*) AS most_listings
FROM airbnb_listings 
GROUP BY room_type
ORDER BY most_listings DESC;

-- ================================================================================
-- Q) Which areas have the highest review activity?

-- Finding: Staten Island (35.80 avg reviews) and Queens (33.66) show
-- the highest per-listing engagement despite having far fewer listings
-- than Manhattan (24.11, lowest despite most listings) — likely due to
-- lower competition per listing in smaller boroughs.
-- NOTE: See Q4 — this finding is complicated by availability data,
-- which suggests these are long-standing listings with weaker curent
-- demand, not necessarily "hottest" markets right now.
-- ================================================================================

SELECT 
    neighbourhood_group, 
    COUNT(*) AS listing_count,
    ROUND(AVG(number_of_reviews), 2) AS higest_review_activity
FROM airbnb_listings
WHERE neighbourhood_group != 'Unknown'
GROUP BY neighbourhood_group
ORDER BY higest_review_activity DESC;

-- ================================================================================
-- Q) How does availability vary by neighbourhood? 
                         -- OR 
--    Which areas have the highest average availability?

-- Finding: Staten Island has the highest average availability (196.93
-- days/year unbooked), Brooklyn the lowest (128.78, i.e. most booked).
-- Cross-referencing with Q3: high reviews + high availability together
-- suggest established listings with strong historical engagement but
-- weaker CURRENT booking activity, rather than simple "high demand."
-- ================================================================================

SELECT 
	neighbourhood_group, 
    COUNT(*) AS neighbourhood_count,
    ROUND(AVG(availability_365), 2) AS availability
FROM airbnb_listings
WHERE neighbourhood_group != 'Unknown'
GROUP BY neighbourhood_group
ORDER BY availability DESC;

-- ================================================================================
-- Q) Which hosts have the largest number of listings?

-- Finding: host_id is (near) unique per row — 102,035 unique hosts out
-- of 102,036 rows, so no host owns a meaningful "portfolio" in this
-- dataset. This directly CONTRADICTS the calculated_host_listings_count
-- column, which claims some hosts have 300+ listings. Since host_id can
-- be independently verified by direct count and calculated_host_listings
-- _count cannot, host_id is treated as the trustworthy source.
-- ================================================================================

SELECT 
	host_id, 
    COUNT(*) AS largest_number_of_host_listings
FROM airbnb_listings
GROUP BY host_id
ORDER BY largest_number_of_host_listings DESC
LIMIT 5;

SELECT 
	COUNT(DISTINCT host_id) AS unique_host, 
    COUNT(*) AS total_rows
FROM airbnb_listings;

SELECT 
	calculated_host_listings_count, 
    COUNT(*) as num_listings
FROM airbnb_listings
GROUP BY calculated_host_listings_count
ORDER BY calculated_host_listings_count DESC
LIMIT 10;

-- ================================================================================
-- Q) How does cancellation policy relate to pricing?

-- Finding: No meaningful relationship. Average prices across flexible/
-- moderate/strict policies differ by less than $2 — consistent with
-- price appearing to be randomly distributed.
-- ================================================================================

SELECT 
	cancellation_policy, 
    COUNT(*) AS total_calcellation_policy,
    ROUND(AVG(price), 2) AS avg_price
FROM airbnb_listings
WHERE cancellation_policy != 'Unknown'
GROUP BY cancellation_policy
ORDER BY avg_price DESC;

-- ================================================================================
-- Q) What factors appear associated with higher prices?

-- Tested: room_type, instant_bookable, review_rate_number.
-- Finding: NONE show a meaningful or logically consistent relationship
-- with price. review_rate_number even runs opposite to expectation
-- (rating 1 has the highest avg price, rating 5 the lowest). Combined
-- with Q1 and Q6, this is strong repeated evidence that `price` does
-- not reflect real-world market behavior.
-- ================================================================================
-- room_type vs price

SELECT 
	room_type, 
    COUNT(*) AS count_room_type,
    ROUND(AVG(price), 2) as average_price_as_per_room_type 
FROM airbnb_listings 
WHERE room_type != 'Unknown'
GROUP BY room_type
ORDER BY average_price_as_per_room_type DESC;

-- instant_bookable vs price

SELECT 
	instant_bookable, 
    COUNT(*) AS count_room_type,
    ROUND(AVG(price), 2) as average_price_as_per_room_availibility
FROM airbnb_listings 
GROUP BY instant_bookable
ORDER BY average_price_as_per_room_availibility DESC;

-- review_rate_number vs price

SELECT 
	review_rate_number, 
    COUNT(*) AS count_room_type,
    ROUND(AVG(price), 2) as average_price_as_per_room_review
FROM airbnb_listings 
GROUP BY review_rate_number
ORDER BY average_price_as_per_room_review DESC;

-- ================================================================================
-- Q) Which neighbourhoods offer the best balance of price and reviews?

-- CAVEAT: Because price is unreliable (see Q1, Q6, Q7), this result is
-- illustrative only. Reviews remain the trustworthy half of this query.
-- Finding: Staten Island and Queens show the strongest guest engagement
-- (avg reviews); price differences across boroughs are not meaningful.
-- ================================================================================

SELECT 
	neighbourhood_group, 
    COUNT(*) AS neighbourhood_count,
    ROUND(AVG(price), 2) AS average_price,
    ROUND(AVG(number_of_reviews), 2) AS avg_no_of_reviews
FROM airbnb_listings
WHERE neighbourhood_group != 'Unknown'
GROUP BY neighbourhood_group
ORDER BY average_price DESC;

-- ================================================================================
-- Q) What percentage of listings are instant-bookable?

-- Finding: 49.75% — essentially an even split, no strong platform-wide
-- bias toward either booking style.
-- ================================================================================

SELECT 
	ROUND(SUM(CASE WHEN instant_bookable = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS pct_instant_bookable
FROM airbnb_listings;

-- ================================================================================
-- Q) Top 3 highest-priced listings within each borough

-- Demonstrates RANK() vs ROW_NUMBER() with PARTITION BY, and CTE syntax.
-- NOTE: RANK() produces many tied "#1" rows because dozens of listings
-- share the exact same $1200 ceiling price across boroughs — further
-- evidence of price being artificially capped/generated rather than
-- organic. ROW_NUMBER() is used below for a clean, deterministic top-3
-- per group regardless of ties.
-- ================================================================================

WITH row_listings AS (
		SELECT 
			id, 
			neighbourhood_group, 
			room_type, 
			price,
			ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS price_ranked_row
		FROM airbnb_listings
		WHERE neighbourhood_group != 'Unknown'
)
SELECT * FROM row_listings
WHERE price_ranked_row <= 3;



	





















	






















