
SELECT COUNT(DISTINCT rc.rider_id) AS riders_2021_active_in_2024
FROM rides_completed rc
JOIN riders ri ON rc.rider_id = ri.rider_id
WHERE strftime('%Y', ri.signup_date) = '2021'
  AND strftime('%Y', rc.pickup_time) = '2024';
