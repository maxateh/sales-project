-- Revenue growth rate per year
WITH yearly_revenue AS (
  SELECT
    EXTRACT(YEAR FROM order_date)::INT AS year,
    SUM(total_revenue) AS revenue
  FROM sales_record
  GROUP BY year
  ORDER BY year
),
growths AS (
  SELECT
    year,
    revenue,
    LAG(revenue) OVER (ORDER BY year) AS prev_revenue
  FROM yearly_revenue
),
growth_rates AS (
  SELECT
    year,
    revenue,
    ROUND(
      CASE 
        WHEN prev_revenue IS NULL THEN NULL
        ELSE (revenue - prev_revenue) / prev_revenue * 100
      END, 2
    ) AS growth_rate
  FROM growths
),
avg_growth AS (
  SELECT AVG(growth_rate) AS avg_growth_rate FROM growth_rates WHERE growth_rate IS NOT NULL
),
last_year_data AS (
  SELECT year, revenue FROM growth_rates ORDER BY year DESC LIMIT 1
),
projection AS (
  SELECT 
    last_year_data.year + 1 AS year,
    NULL::NUMERIC AS revenue,
    NULL::NUMERIC AS growth_rate,
    ROUND(avg_growth.avg_growth_rate, 2) AS projected_growth_rate
  FROM last_year_data, avg_growth
)
SELECT 
  year, 
  revenue, 
  growth_rate,
  NULL::NUMERIC AS projected_growth_rate
FROM growth_rates

UNION ALL

SELECT 
  year, 
  revenue, 
  growth_rate,
  projected_growth_rate
FROM projection

ORDER BY year;
