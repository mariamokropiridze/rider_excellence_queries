-- ============================================================
-- QUERY 3: Payment Distances
-- Source: logistics_orders__orders
-- Metrics: Pickup and dropoff payment distances
-- ============================================================

SELECT
    glovo_country_code,
    DATE_TRUNC(p_creation_date, MONTH) AS month_date,
    COUNT(*)                                        AS orders_with_distance,
    SUM(dropoff_distance_payment_in_meters)         AS dropoff_distance_payment_in_metres,
    SUM(pickup_distance_payment_in_meters)          AS pickup_distance_payment_in_meters
FROM `fulfillment-dwh-production.curated_data_shared_glovo.logistics_orders__orders`
WHERE p_creation_date > DATE('2024-01-01')
  AND order_status = 'completed'
  AND dropoff_distance_google_in_meters > 0
  AND pickup_distance_google_in_meters > 0
GROUP BY 1, 2
ORDER BY 1, 2;
