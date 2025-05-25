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


-- Yearly sales
SELECT 
  DATE_TRUNC('year', order_date) AS year,
  SUM(total_revenue) AS revenue_per_year
FROM 
    sales_record
GROUP BY 
    year
ORDER BY
    year;


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


