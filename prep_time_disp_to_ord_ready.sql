-- ============================================================
-- QUERY 5: Vendor Prep Time & Dispatch-to-Ready
-- Source: vendor_northstar_metrics_order_level_join__order_level_northstar_metrics_join
-- Metrics: Total orders, dispatch-to-ready time, prep time
-- ============================================================

SELECT
    country_code                                    AS glovo_country_code,
    DATE_TRUNC(p_created_date, MONTH)               AS month_date,
    COUNT(order_id)                                 AS total_orders_dor,
    SUM(
        TIMESTAMP_DIFF(food_is_ready_at, order_dispatched_to_partner_at, SECOND) / 60.0
    )                                               AS total_dispatch_to_order_ready,
    SUM(prep_time_minutes)                          AS total_prep_time_minutes
FROM `fulfillment-dwh-production.curated_data_shared_glovo.vendor_northstar_metrics_order_level_join__order_level_northstar_metrics_join`
WHERE p_created_date >= DATE('2024-01-01')
GROUP BY 1, 2
ORDER BY 1, 2;
