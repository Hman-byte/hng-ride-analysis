
WITH revenue_by_city_driver AS (
  SELECT
    rc.pickup_city AS city,
    rc.driver_id,
    d.name AS driver_name,
    SUM(p.amount) AS revenue
  FROM rides_completed rc
  JOIN payments p ON p.ride_id = rc.ride_id
  JOIN drivers d ON d.driver_id = rc.driver_id
  WHERE p.amount > 0
  GROUP BY rc.pickup_city, rc.driver_id, d.name
),
ranked AS (
  SELECT
    city, driver_id, driver_name, revenue,
    ROW_NUMBER() OVER (PARTITION BY city ORDER BY revenue DESC) AS rn
  FROM revenue_by_city_driver
)
SELECT city, driver_id, driver_name, revenue
FROM ranked
WHERE rn <= 3
ORDER BY city, revenue DESC;
