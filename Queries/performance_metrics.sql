SELECT *
FROM sales_record;

-- Top-selling product types (by units sold)

SELECT
    item_type,
    SUM(units_sold) AS sales_per_item
FROM
    sales_record
GROUP BY
    item_type
ORDER BY
    sales_per_item DESC;


-- Total profit by region or country
SELECT
    region,
    SUM(total_profit) AS profits_per_region
FROM
    sales_record
GROUP BY
    region
ORDER BY
    profits_per_region DESC;


-- Sales performance by channel
SELECT 
  sales_channel,
  SUM(units_sold) AS sales_per_channel
FROM 
    sales_record
GROUP BY 
    sales_channel
ORDER BY
    sales_per_channel;


-- Revenue per by channel
SELECT 
  sales_channel,
  COUNT(*) AS total_orders,
  SUM(units_sold) AS total_units_sold,
  SUM(total_revenue) AS total_revenue,
  SUM(total_cost) AS total_cost,
  SUM(total_profit) AS total_profit,
  ROUND(AVG(total_profit), 2) AS avg_profit_per_order,
  ROUND(AVG(total_revenue), 2) AS avg_revenue_per_order
FROM
    sales_record
GROUP BY
    sales_channel
ORDER BY
    total_revenue DESC;


-- Revenue by region
SELECT
    region,
    SUM(total_revenue) AS total_revenue
FROM
    sales_record
GROUP BY
    region
ORDER BY
    total_revenue DESC;


-- Revenue by type
SELECT
    item_type,
    SUM(total_revenue) AS revenue
FROM
    sales_record
GROUP BY
    item_type
ORDER BY
    revenue DESC;


-- Units sold vs Revenue generated
SELECT
    item_type,
    SUM(units_sold) AS total_units,
    SUM(total_revenue) AS total_revenue
FROM
    sales_record
GROUP BY
    item_type;


-- Top 5 most profitable countries
SELECT
    country,
    SUM(total_profit) AS profit
FROM
    sales_record
GROUP BY
    country
ORDER BY
    profit DESC
LIMIT 5;


-- Total profit over time
SELECT
    order_date,
    SUM(total_profit) AS daily_profit
FROM
    sales_record
GROUP BY
    order_date
ORDER BY
    order_date;


-- Revenue comparison per priority
SELECT
    order_priority,
    SUM(total_revenue) AS revenue
FROM
    sales_record
GROUP BY
    order_priority;


-- Percentage of Profits by Item Type
SELECT 
    item_type,
    SUM(Total_profit) AS total_profit,
    ROUND(SUM(total_profit) * 100.0 / SUM(SUM(total_profit)) OVER (), 2) AS profit_percentage
FROM 
    sales_record
GROUP BY 
    item_type
ORDER BY 
    total_profit DESC
LIMIT 10;