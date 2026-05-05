-- Metric: Average Rating
-- Description: Average customer rating given to couriers for completed deliveries.
-- Filters:
--   :start_date    — period start (inclusive), e.g. '2024-01-01'
--   :end_date      — period end   (inclusive), e.g. '2024-01-31'
--   :city_id       — Glovo city identifier (use NULL to include all cities)
--   :country_code  — ISO-2 country code    (use NULL to include all countries)

SELECT
    DATE_TRUNC('day', r.rated_at)           AS date,
    r.city_id,
    r.country_code,
    COUNT(r.rating)                         AS total_ratings,
    ROUND(AVG(r.rating), 2)                 AS average_rating
FROM courier_ratings r
WHERE r.rated_at BETWEEN :start_date AND :end_date
  AND (:city_id       IS NULL OR r.city_id      = :city_id)
  AND (:country_code  IS NULL OR r.country_code = :country_code)
GROUP BY 1, 2, 3
ORDER BY 1, 2;
