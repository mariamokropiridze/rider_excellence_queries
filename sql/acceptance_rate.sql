-- Metric: Acceptance Rate
-- Description: Share of orders accepted by couriers out of total orders offered.
-- Filters:
--   :start_date    — period start (inclusive), e.g. '2024-01-01'
--   :end_date      — period end   (inclusive), e.g. '2024-01-31'
--   :city_id       — Glovo city identifier (use NULL to include all cities)
--   :country_code  — ISO-2 country code    (use NULL to include all countries)

SELECT
    DATE_TRUNC('day', o.offered_at)         AS date,
    o.city_id,
    o.country_code,
    COUNT(*)                                AS total_offers,
    COUNT(CASE WHEN o.accepted = TRUE THEN 1 END) AS accepted_offers,
    ROUND(
        COUNT(CASE WHEN o.accepted = TRUE THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    )                                       AS acceptance_rate_pct
FROM order_offers o
WHERE o.offered_at BETWEEN :start_date AND :end_date
  AND (:city_id       IS NULL OR o.city_id      = :city_id)
  AND (:country_code  IS NULL OR o.country_code = :country_code)
GROUP BY 1, 2, 3
ORDER BY 1, 2;
