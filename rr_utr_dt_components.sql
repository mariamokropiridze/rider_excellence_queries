-- ============================================================
-- QUERY 2: Core Efficiency KPIs
-- Sources: efficiency__utr, efficiency__idle_time,
--          delivery_times__delivery_times, order_volumes__order_volumes
-- Metrics: UTR, utilization rate, CDT, DT (food/groceries), WTP,
--          stacking rate, reassignment rate, to-customer time
-- ============================================================

SELECT
    utr.glovo_country_code,
    DATE_TRUNC(utr.p_report_date, MONTH) AS month_date,

    -- UTR components
    SUM(utr.total_orders)                           AS freelance_orders,     -- numerator
    SUM(utr.working_hours)                          AS working_hours,         -- denominator

    -- Utilization rate components
    SUM(it.transition_busy_time_n)                  AS transition_busy_time,  -- numerator
    SUM(it.transition_working_time_d)               AS transition_working_time, -- denominator

    -- Delivery time (all)
    SUM(dt.dt_glovo_n)                              AS dt_glovo_n,
    SUM(dt.dt_glovo_d)                              AS dt_glovo_d,

    -- Courier delivery time
    SUM(dt.courier_delivery_time_in_minutes_n)      AS courier_delivery_time_in_minutes_n,
    SUM(dt.courier_delivery_time_in_minutes_d)      AS courier_delivery_time_in_minutes_d,

    -- Delivery time by vertical
    SUM(dt.dt_glovo_food_n)                         AS dt_glovo_food_n,
    SUM(dt.dt_glovo_food_d)                         AS dt_glovo_food_d,
    SUM(dt.dt_glovo_groceries_n)                    AS dt_glovo_groceries_n,
    SUM(dt.dt_glovo_groceries_d)                    AS dt_glovo_groceries_d,

    -- Food DT over 60 min
    SUM(dt.dt_glovo_food_over_60_n)                 AS dt_glovo_food_over_60_n,

    -- Wait at vendor (WTP)
    SUM(dt.at_vendor_time_in_minutes_n)             AS at_vendor_time_in_minutes_n,
    SUM(dt.at_vendor_time_in_minutes_d)             AS at_vendor_time_in_minutes_d,

    -- To-customer time
    SUM(dt.to_customer_time_in_minutes_n)           AS to_customer_time_in_minutes_n,
    SUM(dt.to_customer_time_in_minutes_d)           AS to_customer_time_in_minutes_d,

    -- Stacking rate components
    SUM(ov.total_stacked_deliveries)                AS stacked_num,
    SUM(ov.total_deliveries_completed)              AS stacked_denom,

    -- Reassignment rate components
    SUM(ov.total_reassignments)                     AS reass_num,
    SUM(ov.total_deliveries)                        AS total_deliveries

FROM `fulfillment-dwh-production.curated_data_shared_glovo.efficiency__utr` utr
LEFT JOIN `fulfillment-dwh-production.curated_data_shared_glovo.efficiency__idle_time` it
    ON utr.city_code = it.city_code
    AND utr.p_report_date = it.p_report_date
LEFT JOIN `fulfillment-dwh-production.curated_data_shared_glovo.delivery_times__delivery_times` dt
    ON dt.city_code = utr.city_code
    AND dt.p_report_date = utr.p_report_date
LEFT JOIN `fulfillment-dwh-production.curated_data_shared_glovo.order_volumes__order_volumes` ov
    ON ov.city_code = utr.city_code
    AND ov.p_report_date = utr.p_report_date
WHERE utr.p_report_date >= DATE('2024-01-01')
GROUP BY 1, 2
ORDER BY 1, 2;
