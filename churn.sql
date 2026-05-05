-- query calculates churn, churn rate, active riders per city per week.

WITH monthly_activity AS (
    SELECT
        o.country_code,
        o.city_code,
        o.rider_id,
        DATE_TRUNC(DATE(o.p_creation_date), WEEK) AS week
    FROM `fulfillment-dwh-production.curated_data_shared_glovo.logistics_orders__orders` o
    WHERE DATE(o.p_creation_date) >= DATE('2026-01-01')
      AND o.country_code = 'gv-ke'
    GROUP BY 1, 2, 3, 4
    HAVING COUNT(DISTINCT CASE WHEN delivery_status = 'completed' THEN o.order_id END) > 0
),

blocked AS (
    SELECT
        rider_id,
        DATE_TRUNC(created_date, WEEK) AS event_week
    FROM `fulfillment-dwh-production.curated_data_shared.rider_compliance`
    LEFT JOIN UNNEST(violations) v ON TRUE
    LEFT JOIN UNNEST(v.actions) a ON TRUE
    WHERE country_code = 'gv-ke'
      AND v.state = 'PROCESSED'
      AND created_date > DATE('2026-01-01')
      AND a.ended_at IS NULL
),

churn_flag AS (
    SELECT
        m1.rider_id,
        m1.country_code,
        m1.city_code,
        m1.week,
        CASE
            WHEN COUNT(DISTINCT CASE WHEN m2.week > m1.week THEN m2.week END) = 0
            THEN 1 ELSE 0
        END AS churned_next_week
    FROM monthly_activity m1
    LEFT JOIN monthly_activity m2
        ON m1.rider_id = m2.rider_id
        AND m2.week = DATE_ADD(m1.week, INTERVAL 1 WEEK)
    LEFT JOIN blocked f
        ON m1.rider_id = f.rider_id
        AND f.event_week = DATE_ADD(m1.week, INTERVAL 1 WEEK)
    LEFT JOIN blocked f2
        ON m1.rider_id = f2.rider_id
        AND f2.event_week = m1.week
    WHERE f.rider_id IS NULL
      AND f2.rider_id IS NULL
    GROUP BY 1, 2, 3, 4
)

SELECT
    country_code,
    city_code,
    week,
    COUNT(DISTINCT rider_id)                                            AS active_riders,
    SUM(churned_next_week)                                              AS churned_riders,
    SUM(churned_next_week) * 1.0 / NULLIF(COUNT(DISTINCT rider_id), 0) AS churn_rate
FROM churn_flag
WHERE week < DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 1 WEEK), WEEK)
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3
