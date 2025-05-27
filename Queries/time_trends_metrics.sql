-- Revenue per month trend
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(total_revenue) AS revenue
FROM
    sales_record
GROUP BY
    month
ORDER BY
    month;


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

-- Sales in each weekdays
SELECT 
    TO_CHAR(order_date, 'Day') AS weekday, 
    SUM(total_revenue) AS revenue
FROM 
    sales_record
GROUP BY 
    weekday
ORDER BY 
    revenue DESC;


-- Revenue in each month
SELECT 
    TO_CHAR(order_date, 'Month') AS month, 
    SUM(total_revenue) AS revenue
FROM 
    sales_record
GROUP BY 
    month
ORDER BY 
    revenue DESC;


-- Revenue in each year
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    COUNT(*) AS total_orders,
    SUM(total_revenue) AS revenue
FROM
    sales_record
GROUP BY
    year
ORDER BY
    year;

-- First and Last order per company
SELECT
    country,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM
    sales_record
GROUP BY 
    country;


-- Year-over-Year growth
WITH yearly_sales AS (
  SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(units_sold) AS units_sold
  FROM sales_record
  GROUP BY year
),
growth_rate AS (
  SELECT 
    year,
    units_sold,
    LAG(units_sold) OVER (ORDER BY year) AS previous_year_units
  FROM yearly_sales
)
SELECT 
  year,
  units_sold,
  ROUND(100.0 * (units_sold - previous_year_units) / previous_year_units, 2) AS yoy_growth_percent
FROM growth_rate
WHERE previous_year_units IS NOT NULL;