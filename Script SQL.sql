create database airbnb;
use airbnb;
CREATE TABLE airbnb_data (
    id INT,
    name VARCHAR(255),
    host_id INT,
    host_name VARCHAR(255),
    district VARCHAR(255),
    neighbourhood VARCHAR(255),
    room_type VARCHAR(255),
    price INT,
    minimum_nights INT,
    number_of_reviews INT,
    last_review char(255),
    reviews_per_month DECIMAL(5, 2),
    calculated_host_listings_count INT,
    availability_365 INT
);
select * from airbnb_data;

drop table airbnb_data;

Alter table airbnb_data
add column last_review_date date;

update airbnb_data
set last_review_Date = Str_to_date(last_review,"%Y-%m-%d");

-- Is there a seasonal trend in pricing?
SELECT EXTRACT(MONTH FROM last_review_date) AS month, AVG(price) AS average_price
FROM airbnb_data
GROUP BY month
ORDER BY month;

-- Which (Top 5) neighborhoods have the highest number of Airbnb listings?
SELECT neighbourhood, COUNT(*) AS listing_count
FROM airbnb_data
GROUP BY neighbourhood
ORDER BY listing_count DESC
limit 5;


-- What's the average availability for listings in each district?
SELECT district, ceil(AVG(availability_365)) AS average_availability
FROM airbnb_data
GROUP BY district
ORDER BY average_availability DESC;

-- How does availability change over time?
SELECT EXTRACT(MONTH FROM last_review_date) AS month,
AVG(availability_365) AS average_availability
FROM airbnb_data
WHERE last_review_date IS NOT NULL
GROUP BY month
ORDER BY month;

-- Which listings have not been reviewed for a long time?
SELECT id, name, last_review, district
FROM airbnb_data
WHERE last_review IS NOT NULL
ORDER BY last_review asc
limit 10;

-- What's the average price for each room type in different districts?
SELECT district, room_type, AVG(price) AS average_price
FROM airbnb_data
GROUP BY district, room_type
ORDER BY district, room_type;

-- Can we identify neighborhoods with the best price-to-availability ratio?
SELECT district, AVG(price / availability_365) AS price_to_availability_ratio
FROM airbnb_data
WHERE availability_365 > 0
GROUP BY district
ORDER By price_to_availability_ratio DESC;