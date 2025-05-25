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
SELECT TO_CHAR(order_date, 'Day') AS weekday, SUM(total_revenue) AS revenue
FROM sales_record
GROUP BY weekday
ORDER BY revenue DESC;


-- Revenue in each month
SELECT TO_CHAR(order_date, 'Month') AS Month, SUM(total_revenue) AS revenue
FROM sales_record
GROUP BY Month
ORDER BY revenue DESC;

