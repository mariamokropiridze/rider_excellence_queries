-- ============================================================
-- QUERY 1: Delivery Time Variants
-- Sources: logistics_orders__orders + rider_compensations__payments_order_level (bw flag)
-- Metrics: DT by good/bad weather, stacked/non-stacked, food, non-groceries
-- ============================================================

WITH bw_flag_dh AS (
    SELECT
        order_id,
        global_order_id,
        glovo_country_code,
        p_creation_date,
        IF(
            (other_bad_weather_bonus_cost_local_currency +
             bad_weather_bonus_cost_local_currency +
             snow_bonus_cost_local_currency +
             rain_bonus_cost_local_currency) > 0,
            TRUE,
            FALSE
        ) AS is_bw
    FROM `fulfillment-dwh-production.curated_data_shared_glovo.rider_compensations__payments_order_level`
    WHERE order_final_status <> 'CanceledStatus'
      AND p_creation_date >= DATE('2024-01-01')
)

SELECT
    o.glovo_country_code,
    DATE_TRUNC(report_date, MONTH) AS month_date,

    -- All orders, good weather
    SUM(CASE
        WHEN delivery_status = 'completed' AND is_bw = FALSE
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_glovo_gw_n,
    COUNT(CASE
        WHEN delivery_status = 'completed' AND is_bw = FALSE
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_glovo_gw_d,

    -- All orders, bad weather
    SUM(CASE
        WHEN delivery_status = 'completed' AND is_bw = TRUE
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_glovo_bw_n,
    COUNT(CASE
        WHEN delivery_status = 'completed' AND is_bw = TRUE
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_glovo_bw_d,

    -- Food, good weather
    SUM(CASE
        WHEN delivery_status = 'completed' AND is_bw = FALSE AND vertical_type = 'restaurants'
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_food_glovo_gw_n,
    COUNT(CASE
        WHEN delivery_status = 'completed' AND is_bw = FALSE AND vertical_type = 'restaurants'
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_food_glovo_gw_d,

    -- Food, bad weather
    SUM(CASE
        WHEN delivery_status = 'completed' AND is_bw = TRUE AND vertical_type = 'restaurants'
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_food_glovo_bw_n,
    COUNT(CASE
        WHEN delivery_status = 'completed' AND is_bw = TRUE AND vertical_type = 'restaurants'
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_food_glovo_bw_d,

    -- Stacked
    SUM(CASE
        WHEN delivery_status = 'completed' AND total_stacked_deliveries > 0
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_glovo_stacked_n,
    COUNT(CASE
        WHEN delivery_status = 'completed' AND total_stacked_deliveries > 0
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_glovo_stacked_d,

    -- Non-stacked
    SUM(CASE
        WHEN delivery_status = 'completed' AND total_stacked_deliveries = 0
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_glovo_non_stacked_n,
    COUNT(CASE
        WHEN delivery_status = 'completed' AND total_stacked_deliveries = 0
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_glovo_non_stacked_d,

    -- Non-groceries
    SUM(CASE
        WHEN delivery_status = 'completed' AND vertical_type <> 'supermarket'
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_glovo_non_groceries_n,
    COUNT(CASE
        WHEN delivery_status = 'completed' AND vertical_type <> 'supermarket'
        THEN CASE WHEN is_preorder
            THEN CAST(DATETIME_DIFF(rider_dropped_off_at, order_queued_at, SECOND) AS FLOAT64) / 60
            ELSE CAST(actual_delivery_time_in_seconds AS FLOAT64) / 60 + COALESCE(CAST(at_customer_time_in_seconds AS FLOAT64) / 60, 0)
        END
    END) AS dt_glovo_non_groceries_d

FROM `fulfillment-dwh-production.curated_data_shared_glovo.logistics_orders__orders` o
LEFT JOIN bw_flag_dh bw
    ON CAST(bw.order_id AS STRING) = o.global_order_id
    AND o.glovo_country_code = bw.glovo_country_code
    AND o.report_date = bw.p_creation_date
WHERE report_date >= DATE('2024-01-01')
GROUP BY 1, 2
ORDER BY 1, 2;
