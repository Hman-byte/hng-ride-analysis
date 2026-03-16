
WITH driver_completed AS (
  SELECT driver_id, COUNT(*) AS completed_rides, SUM(p.amount) AS revenue
  FROM rides_completed rc
  JOIN payments p ON p.ride_id = rc.ride_id
  WHERE p.amount > 0
  GROUP BY driver_id
),
driver_all AS (
  SELECT driver_id,
         COUNT(*) AS total_rides,
         SUM(CASE WHEN is_cancelled=1 THEN 1 ELSE 0 END) AS cancelled_rides
  FROM rides_all_for_cancel
  GROUP BY driver_id
),
driver_cancel_rate AS (
  SELECT a.driver_id,
         a.total_rides,
         a.cancelled_rides,
         CASE WHEN a.total_rides>0 THEN (a.cancelled_rides*1.0)/a.total_rides ELSE NULL END AS cancellation_rate
  FROM driver_all a
)
SELECT
  d.driver_id,
  d.name AS driver_name,
  dc.completed_rides,
  ROUND(dr.rating, 2) AS avg_rating,
  ROUND(dcr.cancellation_rate, 4) AS cancellation_rate,
  ROUND(dc.revenue, 2) AS revenue
FROM drivers d
JOIN driver_completed dc ON d.driver_id = dc.driver_id
JOIN driver_cancel_rate dcr ON d.driver_id = dcr.driver_id
JOIN drivers dr ON dr.driver_id = d.driver_id
WHERE dc.completed_rides >= 30
  AND dr.rating >= 4.5
  AND (dcr.cancellation_rate IS NOT NULL AND dcr.cancellation_rate < 0.05)
ORDER BY revenue DESC
LIMIT 10;
