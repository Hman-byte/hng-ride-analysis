
WITH rider_counts AS (
  SELECT rc.rider_id, COUNT(*) AS rides_count
  FROM rides_completed rc
  GROUP BY rc.rider_id
),
rider_payment_methods AS (
  SELECT DISTINCT rc.rider_id, LOWER(p.method) AS method
  FROM rides_completed rc
  JOIN payments p ON rc.ride_id = p.ride_id
  WHERE p.amount > 0
)
SELECT ri.rider_id, rid.name AS rider_name, rc.rides_count
FROM rider_counts rc
JOIN riders rid ON rc.rider_id = rid.rider_id
LEFT JOIN rider_payment_methods rpm_cash
  ON rc.rider_id = rpm_cash.rider_id AND rpm_cash.method = 'cash'
JOIN rider_counts ri ON ri.rider_id = rc.rider_id
WHERE rc.rides_count > 10
  AND rpm_cash.rider_id IS NULL
ORDER BY rc.rides_count DESC;
