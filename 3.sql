
WITH qrev AS (
  SELECT
    CAST(strftime('%Y', rc.pickup_time) AS INT) AS year,
    ((CAST(strftime('%m', rc.pickup_time) AS INT) + 2) / 3) AS quarter,
    SUM(p.amount) AS revenue
  FROM rides_completed rc
  JOIN payments p ON p.ride_id = rc.ride_id
  WHERE p.amount > 0
  GROUP BY 1,2
),
growth AS (
  SELECT
    curr.year,
    curr.quarter,
    curr.revenue AS revenue_curr,
    prev.revenue AS revenue_prev,
    (curr.revenue - prev.revenue) AS yoy_growth_amount,
    CASE WHEN prev.revenue > 0 THEN (curr.revenue - prev.revenue) * 1.0 / prev.revenue ELSE NULL END AS yoy_growth_rate
  FROM qrev curr
  LEFT JOIN qrev prev
    ON prev.quarter = curr.quarter
   AND prev.year = curr.year - 1
)
SELECT * FROM growth
ORDER BY year, quarter;
