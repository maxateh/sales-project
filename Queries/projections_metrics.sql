-- Revenue growth rate per year
-- CTE for total revenue per year from the sales_record table
WITH yearly_revenue AS (
  SELECT
    EXTRACT(YEAR FROM order_date)::int AS year,  -- Extract year from order_date
    SUM(total_revenue) AS revenue                 -- Total revenue for each year
  FROM
    sales_record
  GROUP BY 
    year
  ORDER BY
    year
),
-- CTE to Add previous year's revenue for growth calculation using LAG
growths AS (
  SELECT
    year,
    revenue,
    LAG(revenue) OVER (ORDER BY year) AS prev_revenue  -- Previous year's revenue
  FROM
    yearly_revenue
),
-- CTE to calculate year-over-year revenue growth rate as a percentage
growth_rates AS (
  SELECT
    year,
    revenue,
    ROUND(
      CASE 
        WHEN prev_revenue IS NULL THEN NULL  -- No growth rate for first year
        ELSE (revenue - prev_revenue) / prev_revenue * 100
      END, 2
    ) AS growth_rate
  FROM
    growths
),
-- CTE to compute average yearly growth rate (excluding the first year)
avg_growth AS (
  SELECT AVG(
    CASE 
      WHEN prev_revenue IS NULL THEN NULL
      ELSE (revenue - prev_revenue) / prev_revenue
    END
  ) AS avg_growth_rate
  FROM
    growths
),
-- CTE to get the most recent year and its revenue for projection
latest_year AS (
  SELECT
    year,
    revenue
  FROM
    yearly_revenue
  ORDER BY
    year DESC
  LIMIT 1
),
-- CTE to get projection for the next year's revenue using the average growth rate
projection AS (
  SELECT 
    (latest_year.year + 1) || ' (Projection)' AS year,             -- Label the year as a projection
    ROUND(latest_year.revenue * (1 + avg_growth.avg_growth_rate), 2) AS revenue, -- Projected revenue
    ROUND(avg_growth.avg_growth_rate * 100, 2) AS growth_rate      -- Projected growth rate as a %
  FROM
    latest_year,
    avg_growth
)
-- Combine actual growth data with the projection and show the result
SELECT
  year::text AS year,
  revenue,
  growth_rate
FROM
  growth_rates
UNION ALL  -- Add the projected row to the bottom
SELECT 
  year,
  revenue,
  growth_rate
FROM
  projection
ORDER BY
  year;  -- Order results chronologically (projection comes last)


-- Sales Growth Rate per year
-- Total units sold per year
WITH yearly_sales AS (
  SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(units_sold) AS units_sold
  FROM
    sales_record
  GROUP BY
    year
),
-- Step 2: Calculate growth between consecutive years
growth_calc AS (
  SELECT 
    year,
    units_sold,
    LAG(units_sold) OVER (ORDER BY year) AS previous_units
  FROM
    yearly_sales
  WHERE
    year < 2021
),
-- Step 3: Calculate average yearly growth rate (as a decimal)
avg_growth AS (
  SELECT 
    AVG((units_sold - previous_units) * 1.0 / previous_units) AS avg_growth_rate
  FROM
    growth_calc
  WHERE
    previous_units IS NOT NULL
),
-- Step 4: Get most recent year's sales (assumes last year with data is 2020)
last_year AS (
  SELECT 
    year,
    units_sold
  FROM
    yearly_sales
  WHERE
    year = (SELECT MAX(year) FROM yearly_sales)
)
-- Step 5: Final projection for 2021 with growth percentage column
SELECT 
  2021 AS projected_year,
  ROUND(last_year.units_sold * (1 + avg_growth.avg_growth_rate)) AS projected_units_sold,
  ROUND(avg_growth.avg_growth_rate * 100, 2) AS growth_percent_used
FROM
  last_year, avg_growth;

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