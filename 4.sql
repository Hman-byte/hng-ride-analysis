
WITH rides_by_month AS (
  SELECT
    rc.driver_id,
    strftime('%Y-%m', rc.pickup_time) AS ym,
    COUNT(*) AS rides_in_month
  FROM rides_completed rc
  GROUP BY rc.driver_id, ym
),
driver_stats AS (
  SELECT
    d.driver_id,
    d.name AS driver_name,
    COUNT(rbm.ym) AS active_months,
    SUM(rbm.rides_in_month) AS total_rides,
    ROUND(SUM(rbm.rides_in_month) * 1.0 / COUNT(rbm.ym), 2) AS avg_rides_per_active_month,
    MIN(d.signup_date) AS signup_date
  FROM drivers d
  JOIN rides_by_month rbm ON d.driver_id = rbm.driver_id
  GROUP BY d.driver_id, d.name
)
SELECT driver_id, driver_name, signup_date, active_months, total_rides, avg_rides_per_active_month
FROM driver_stats
ORDER BY avg_rides_per_active_month DESC, total_rides DESC
LIMIT 5;
