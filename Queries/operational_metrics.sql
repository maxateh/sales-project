-- Average Delivery Time for Each Order Priority
SELECT 
  order_priority,
  COUNT(*) AS total_orders,
  ROUND(AVG(ship_date - order_date), 2) AS avg_delivery_days
FROM
    sales_record
GROUP BY
    order_priority
ORDER BY
    avg_delivery_days ASC;


-- Profit per Order by Priority
SELECT 
  order_priority,
  COUNT(*) AS total_orders,
  SUM(total_profit) AS total_profit,
  ROUND(AVG(total_profit), 2) AS avg_profit_per_order
FROM
    sales_record
GROUP BY
    order_priority
ORDER BY
    avg_profit_per_order DESC;


-- Delayed orders of more than 7 days
SELECT 
  order_id,
  region,
  country,
  order_priority,
  order_date,
  ship_date,
  (ship_date - order_date) AS delivery_days
FROM
    sales_record
WHERE
    (ship_date - order_date) > 25
ORDER BY
    delivery_days DESC;


-- Top 10 products by profit margin
SELECT 
    item_type, 
    SUM(total_profit) / SUM(total_cost) AS profit_margin
FROM 
    sales_record
GROUP BY 
    item_type
ORDER BY 
    profit_margin DESC
LIMIT 10;