-- Average delivery time
SELECT 
    ROUND(AVG(ship_date - order_date), 2) AS avg_delivery_days
FROM 
    sales_record;


-- Delivery time by priority
SELECT 
    order_priority, 
    AVG(ship_date - order_date) AS avg_delivery_days
FROM 
    sales_record
GROUP BY 
    order_priority;


-- Average delivery days per country
SELECT 
    country, 
    ROUND(AVG(ship_date - order_date), 0) AS avg_delivery_days
FROM 
    sales_record
GROUP BY 
    country
ORDER BY 
    avg_delivery_days;


-- Orders with delayed shipping (> average)
SELECT 
    *
FROM 
    sales_record
WHERE 
    (ship_date - order_date) > (
        SELECT AVG(ship_date - order_date) 
        FROM sales_record
    );


-- Total orders by shipping duration bucket
SELECT 
    CASE 
        WHEN (ship_date - order_date) <= 10 THEN '0-9 days'
        WHEN (ship_date - order_date) <= 20 THEN '10-19 days'
        WHEN (ship_date - order_date) <= 30 THEN '20-29 days'
        WHEN (ship_date - order_date) <= 40 THEN '30-39 days'
        ELSE '40+ days'
    END AS delivery_bucket,
    COUNT(*) AS total_orders
FROM 
    sales_record
GROUP BY 
    delivery_bucket
ORDER BY 
    delivery_bucket;