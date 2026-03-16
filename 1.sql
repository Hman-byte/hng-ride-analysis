
SELECT
  rc.ride_id,
  d.name AS driver_name,
  r.name AS rider_name,
  rc.pickup_city,
  rc.dropoff_city,
  rc.distance_km,
  p.method AS payment_method
FROM rides_completed rc
LEFT JOIN drivers d ON rc.driver_id = d.driver_id
LEFT JOIN riders r ON rc.rider_id = r.rider_id
LEFT JOIN payments p ON rc.ride_id = p.ride_id
WHERE p.amount > 0
ORDER BY rc.distance_km DESC
LIMIT 10;
