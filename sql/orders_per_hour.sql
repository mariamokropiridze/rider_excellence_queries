-- Metric: Orders Per Hour
-- Description: Average number of delivered orders per active courier per logged hour.
-- Filters:
--   :start_date    — period start (inclusive), e.g. '2024-01-01'
--   :end_date      — period end   (inclusive), e.g. '2024-01-31'
--   :city_id       — Glovo city identifier (use NULL to include all cities)
--   :country_code  — ISO-2 country code    (use NULL to include all countries)

WITH daily_orders AS (
    SELECT
        DATE_TRUNC('day', o.delivered_at)   AS date,
        o.city_id,
        o.country_code,
        o.courier_id,
        COUNT(*)                            AS orders_delivered
    FROM orders o
    WHERE o.delivered_at BETWEEN :start_date AND :end_date
      AND o.status = 'DELIVERED'
      AND (:city_id       IS NULL OR o.city_id      = :city_id)
      AND (:country_code  IS NULL OR o.country_code = :country_code)
    GROUP BY 1, 2, 3, 4
),
daily_hours AS (
    SELECT
        DATE_TRUNC('day', s.shift_start)    AS date,
        s.city_id,
        s.country_code,
        s.courier_id,
        SUM(
            EXTRACT(EPOCH FROM (s.shift_end - s.shift_start)) / 3600.0
        )                                   AS hours_logged
    FROM courier_shifts s
    WHERE s.shift_start BETWEEN :start_date AND :end_date
      AND (:city_id       IS NULL OR s.city_id      = :city_id)
      AND (:country_code  IS NULL OR s.country_code = :country_code)
    GROUP BY 1, 2, 3, 4
)
SELECT
    o.date,
    o.city_id,
    o.country_code,
    ROUND(
        SUM(o.orders_delivered) / NULLIF(SUM(h.hours_logged), 0),
        2
    )                                       AS orders_per_hour
FROM daily_orders o
JOIN daily_hours h
  ON o.date        = h.date
 AND o.city_id     = h.city_id
 AND o.country_code = h.country_code
 AND o.courier_id  = h.courier_id
GROUP BY 1, 2, 3
ORDER BY 1, 2;
