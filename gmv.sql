-- ============================================================
-- QUERY 7: GMV
-- Source: financial_reports_pnl__pnl_order_level
-- Metrics: EUR GMV by country and month
-- ============================================================

SELECT
    order_country_code                              AS glovo_country_code,
    DATE(DATE_TRUNC(order_started_local_at, MONTH)) AS month_date,
    SUM(DHEGMV_eur)                                 AS gmv_value
FROM `fulfillment-dwh-production.curated_data_shared_glovo.financial_reports_pnl__pnl_order_level`
WHERE DATE(order_started_local_at) >= DATE('2024-01-01')
GROUP BY 1, 2
ORDER BY 1, 2;
