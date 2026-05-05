
-- ============================================================
-- QUERY 6: Vehicle Mix
-- Source: shifts (via evaluations array)
-- Metrics: Accepted shift counts by vehicle category
-- ============================================================

WITH base_data AS (
    SELECT
        UPPER(SUBSTR(s.country_code, 4))            AS glovo_country_code,
        DATE_TRUNC(DATE(s.shift_start_at, s.timezone), MONTH) AS month_date,
        CASE
            WHEN e.vehicle.name IN ('Electric Car', 'Car')          THEN 'Car'
            WHEN e.vehicle.name IN ('Electric Bicycle', 'Bicycle')  THEN 'Bicycle'
            WHEN e.vehicle.name IN ('Electric Motorbike', 'Motorbike') THEN 'Motorbike'
            WHEN e.vehicle.name = 'Walker'                          THEN 'Walker'
            ELSE NULL
        END AS vehicle_category,
        COUNT(*) AS usage_count
    FROM `fulfillment-dwh-production.curated_data_shared.shifts` s
    CROSS JOIN UNNEST(s.evaluations) e
    WHERE s.shift_state = 'EVALUATED'
      AND e.status = 'ACCEPTED'
      AND DATE(s.shift_start_at) >= DATE('2024-01-01')
    GROUP BY 1, 2, 3
)

SELECT
    glovo_country_code,
    month_date,
    SUM(usage_count)                                                        AS total_usage,
    SUM(CASE WHEN vehicle_category = 'Car'       THEN usage_count ELSE 0 END) AS total_car_orders,
    SUM(CASE WHEN vehicle_category = 'Bicycle'   THEN usage_count ELSE 0 END) AS total_bicycle_orders,
    SUM(CASE WHEN vehicle_category = 'Motorbike' THEN usage_count ELSE 0 END) AS total_motorbike_orders,
    SUM(CASE WHEN vehicle_category = 'Walker'    THEN usage_count ELSE 0 END) AS total_walker_orders
FROM base_data
WHERE vehicle_category IS NOT NULL
GROUP BY 1, 2
ORDER BY 1, 2;
