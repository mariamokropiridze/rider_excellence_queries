-- Metric: Completion Rate
-- Description: Share of accepted orders that were successfully completed by couriers.
-- Filters:
--   :start_date    — period start (inclusive), e.g. '2024-01-01'
--   :end_date      — period end   (inclusive), e.g. '2024-01-31'
--   :city_id       — Glovo city identifier (use NULL to include all cities)
--   :country_code  — ISO-2 country code    (use NULL to include all countries)

SELECT
    DATE_TRUNC('day', o.accepted_at)        AS date,
    o.city_id,
    o.country_code,
    COUNT(*)                                AS accepted_orders,
    COUNT(CASE WHEN o.status = 'DELIVERED' THEN 1 END) AS completed_orders,
    ROUND(
        COUNT(CASE WHEN o.status = 'DELIVERED' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    )                                       AS completion_rate_pct
FROM orders o
WHERE o.accepted_at BETWEEN :start_date AND :end_date
  AND o.courier_id IS NOT NULL
  AND (:city_id       IS NULL OR o.city_id      = :city_id)
  AND (:country_code  IS NULL OR o.country_code = :country_code)
GROUP BY 1, 2, 3
ORDER BY 1, 2;
