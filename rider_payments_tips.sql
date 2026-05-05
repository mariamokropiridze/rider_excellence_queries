-- ============================================================
-- QUERY 4: Tips & Card Payment
-- Sources: payments__order_payments, rider_compensations__tips
-- Metrics: Card order count, tip amount on card orders
-- ============================================================

SELECT
    UPPER(REGEXP_REPLACE(op.country_code, '^gv-', '')) AS glovo_country_code,
    DATE_TRUNC(op.p_creation_date, MONTH)              AS month_date,
    SUM(IF(payment_1_payment_method <> 'CASH', 1, 0))                              AS card_orders,
    SUM(IF(payment_1_payment_method <> 'CASH', order_tip_local_currency, 0))       AS tip_card_orders
FROM `fulfillment-dwh-production.curated_data_shared_glovo.payments__order_payments` op
LEFT JOIN `fulfillment-dwh-production.curated_data_shared_glovo.rider_compensations__tips` t
    ON op.order_id = t.order_id
LEFT JOIN `fulfillment-dwh-production.curated_data_shared.orders` o
    ON CAST(op.order_id AS STRING) = CAST(o.global_order_id AS STRING)
WHERE op.p_creation_date >= DATE('2024-01-01')
  AND op.payment_1_payment_method <> 'CASH'
GROUP BY 1, 2
ORDER BY 1, 2;
