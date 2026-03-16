
WITH city_totals AS (
  SELECT pickup_city, COUNT(*) AS total_rides
  FROM rides_all_for_cancel
  GROUP BY pickup_city
),
city_cancels AS (
  SELECT pickup_city, COUNT(*) AS cancelled_rides
  FROM rides_all_for_cancel
  WHERE is_cancelled = 1
  GROUP BY pickup_city
)
SELECT
  ct.pickup_city AS city,
  ct.total_rides,
  COALESCE(cc.cancelled_rides, 0) AS cancelled_rides,
  ROUND(COALESCE(cc.cancelled_rides, 0) * 1.0 / NULLIF(ct.total_rides,0), 4) AS cancellation_rate
FROM city_totals ct
LEFT JOIN city_cancels cc ON ct.pickup_city = cc.pickup_city
ORDER BY cancellation_rate DESC NULLS LAST, total_rides DESC;
