-- Metric: Active Couriers
-- Description: Count of unique couriers who completed at least one delivery in the period.
-- Filters:
--   :start_date    — period start (inclusive), e.g. '2024-01-01'
--   :end_date      — period end   (inclusive), e.g. '2024-01-31'
--   :city_id       — Glovo city identifier (use NULL to include all cities)
--   :country_code  — ISO-2 country code    (use NULL to include all countries)

SELECT
    DATE_TRUNC('day', o.delivered_at)       AS date,
    o.city_id,
    o.country_code,
    COUNT(DISTINCT o.courier_id)            AS active_couriers
FROM orders o
WHERE o.delivered_at BETWEEN :start_date AND :end_date
  AND o.status = 'DELIVERED'
  AND (:city_id       IS NULL OR o.city_id      = :city_id)
  AND (:country_code  IS NULL OR o.country_code = :country_code)
GROUP BY 1, 2, 3
ORDER BY 1, 2;
