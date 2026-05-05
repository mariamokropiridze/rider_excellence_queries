WITH costs AS (
  SELECT
    glovo_country_code,
    city_code,
    DATE_TRUNC(creation_date_local, ISOWEEK) AS week,
    SUM(IF(not order_final_status = 'cancelled', 1,0)) AS orders,
    SUM(total_compensation_local_currency) AS total_comp_lc,
    SUM(total_compensation_eur) AS total_comp_eur,
    
    -- Local Currency Columns
    SUM(COALESCE(base_cost_local_currency,0)) AS base,
    SUM(COALESCE(waiting_cost_local_currency,0)) AS waiting,
    SUM(COALESCE(extra_points_cost_local_currency,0)) AS extra,
    SUM(COALESCE(stacking_extra_points_cost_local_currency,0) + COALESCE(stacking_extra_cost_local_currency,0)) AS stacking,
    SUM(COALESCE(minimum_compensation_cost_local_currency,0)) AS min_cpo,
    SUM(COALESCE(per_all_distances_basic_cost_local_currency,0)) AS distance,
    SUM(COALESCE(per_dropoff_distances_basic_cost_local_currency,0)) AS dist_per_drop,
    SUM(COALESCE(per_near_dropoff_deliveries_basic_cost_local_currency,0)) AS dist_near_drop,
    SUM(COALESCE(per_return_trip_distances_basic_cost_local_currency,0)) AS dist_per_return,
    SUM(COALESCE(per_near_pickup_deliveries_basic_cost_local_currency,0)) AS dist_near_pickup,
    SUM(COALESCE(per_pickup_distances_basic_cost_local_currency,0)) AS dist_per_pickup,
    SUM(COALESCE(rush_bonus_cost_local_currency,0) + COALESCE(night_rush_bonus_cost_local_currency,0)) AS rush,
    SUM(COALESCE(snow_bonus_cost_local_currency,0) + COALESCE(rain_bonus_cost_local_currency,0) + COALESCE(other_bad_weather_bonus_cost_local_currency,0) + COALESCE(bad_weather_bonus_cost_local_currency,0)) AS bw_bonus,
    SUM(COALESCE(quest_cost_local_currency,0) + COALESCE(long_quest_cost_local_currency,0)) AS quest,
    SUM(COALESCE(other_bonus_cost_local_currency,0) + COALESCE(big_order_bonus_cost_local_currency,0) + COALESCE(supplement_bonus_cost_local_currency,0) + COALESCE(referral_bonus_cost_local_currency,0) + COALESCE(rto_adjustment_bonus_cost_local_currency,0) + COALESCE(holiday_bonus_cost_local_currency,0) + COALESCE(special_operation_day_bonus_cost_local_currency,0) + COALESCE(complex_order_bonus_cost_local_currency,0) + COALESCE(distance_bonus_cost_local_currency,0)) AS other_bonus,
    SUM(COALESCE(per_picked_up_deliveries_basic_cost_local_currency,0)) AS basic_per_pickedup,
    SUM(COALESCE(per_completed_deliveries_basic_cost_local_currency,0)) AS basic_per_delivery,
    SUM(COALESCE(per_not_mapped_basic_cost_local_currency,0)) AS basic_not_map,
    SUM(COALESCE(per_return_trip_deliveries_basic_cost_local_currency,0)) AS basic_per_return,
    SUM(COALESCE(per_hour_cost_local_currency,0)) AS basic,
    SUM(COALESCE(scoring_cost_local_currency,0)) AS scoring,
    SUM(COALESCE(special_payment_cost_local_currency,0)) AS special,
    SUM(COALESCE(hidden_basic_cost_local_currency,0)) AS hidden_basic,
    SUM(COALESCE(cancellation_cost_local_currency,0) + COALESCE(supplement_cost_local_currency,0)) AS other_costs,
    SUM(COALESCE(boost_cost_local_currency,0)) AS boost,
    SUM(COALESCE(distance_cost_local_currency,0)) AS all_distances,
    SUM(COALESCE(rider_earning_multiplier_cost_local_currency,0)) AS multiplier,

    -- EUR Columns
    SUM(COALESCE(base_cost_eur,0)) AS base_eur,
    SUM(COALESCE(waiting_cost_eur,0)) AS waiting_eur,
    SUM(COALESCE(extra_points_cost_eur,0)) AS extra_eur,
    SUM(COALESCE(stacking_extra_points_cost_eur,0) + COALESCE(stacking_extra_cost_eur,0)) AS stacking_eur,
    SUM(COALESCE(minimum_compensation_cost_eur,0)) AS min_cpo_eur,
    SUM(COALESCE(per_all_distances_basic_cost_eur,0)) AS distance_eur,
    SUM(COALESCE(per_dropoff_distances_basic_cost_eur,0)) AS dist_per_drop_eur,
    SUM(COALESCE(per_near_dropoff_deliveries_basic_cost_eur,0)) AS dist_near_drop_eur,
    SUM(COALESCE(per_return_trip_distances_basic_cost_eur,0)) AS dist_per_return_eur,
    SUM(COALESCE(per_near_pickup_deliveries_basic_cost_eur,0)) AS dist_near_pickup_eur,
    SUM(COALESCE(per_pickup_distances_basic_cost_eur,0)) AS dist_per_pickup_eur,
    SUM(COALESCE(rush_bonus_cost_eur,0) + COALESCE(night_rush_bonus_cost_eur,0)) AS rush_eur,
    SUM(COALESCE(snow_bonus_cost_eur,0) + COALESCE(rain_bonus_cost_eur,0) + COALESCE(other_bad_weather_bonus_cost_eur,0) + COALESCE(bad_weather_bonus_cost_eur,0)) AS bw_bonus_eur,
    SUM(COALESCE(quest_cost_eur,0) + COALESCE(long_quest_cost_eur,0)) AS quest_eur,
    SUM(COALESCE(other_bonus_cost_eur,0) + COALESCE(big_order_bonus_cost_eur,0) + COALESCE(supplement_bonus_cost_eur,0) + COALESCE(referral_bonus_cost_eur,0) + COALESCE(rto_adjustment_bonus_cost_eur,0) + COALESCE(holiday_bonus_cost_eur,0) + COALESCE(special_operation_day_bonus_cost_eur,0) + COALESCE(complex_order_bonus_cost_eur,0) + COALESCE(distance_bonus_cost_eur,0)) AS other_bonus_eur,
    SUM(COALESCE(per_picked_up_deliveries_basic_cost_eur,0)) AS basic_per_pickedup_eur,
    SUM(COALESCE(per_completed_deliveries_basic_cost_eur,0)) AS basic_per_delivery_eur,
    SUM(COALESCE(per_not_mapped_basic_cost_eur,0)) AS basic_not_map_eur,
    SUM(COALESCE(per_return_trip_deliveries_basic_cost_eur,0)) AS basic_per_return_eur,
    SUM(COALESCE(per_hour_cost_eur,0)) AS basic_eur_col,
    SUM(COALESCE(scoring_cost_eur,0)) AS scoring_eur,
    SUM(COALESCE(special_payment_cost_eur,0)) AS special_eur,
    SUM(COALESCE(hidden_basic_cost_eur,0)) AS hidden_basic_eur,
    SUM(COALESCE(cancellation_cost_eur,0) + COALESCE(supplement_cost_eur,0)) AS other_costs_eur,
    SUM(COALESCE(boost_cost_eur,0)) AS boost_eur,
    SUM(COALESCE(distance_cost_eur,0)) AS all_distances_eur,
    SUM(COALESCE(rider_earning_multiplier_cost_eur,0)) AS multiplier_eur

  FROM `fulfillment-dwh-production.curated_data_shared_glovo.rider_compensations__payments`
  WHERE creation_date_local >= DATE('2026-01-01')
    AND creation_date_local <= DATE_TRUNC(CURRENT_DATE(), ISOWEEK)
  GROUP BY 1,2,3
),

dh_orders AS (
  SELECT
    glovo_country_code,
    city_code,
    DATE_TRUNC(p_report_date, WEEK) AS week,
    SUM(total_orders_completed) AS total_orders_completed
  FROM `fulfillment-dwh-production.curated_data_shared_glovo.order_volumes__order_volumes`
  WHERE p_report_date >= DATE('2026-01-01')
    AND p_report_date <= DATE_TRUNC(CURRENT_DATE(), ISOWEEK)
  GROUP BY 1,2,3
),

cpo_breakdown AS (
  SELECT
    c.glovo_country_code AS country_code,
    c.city_code,
    c.week,
    SUM(total_orders_completed) AS total_orders_completed,

    -- Grouped LC
    SUM(base + extra + waiting + dist_near_pickup + basic_per_pickedup) AS pickup,
    SUM(dist_near_drop + basic_per_delivery) AS drop_off,
    SUM(min_cpo) AS min_cpo,
    SUM(distance + dist_per_drop + dist_per_return + dist_per_pickup + all_distances) AS distance,
    SUM(basic_not_map + basic_per_return) AS other_return_trip,
    SUM(basic + hidden_basic) AS min_per_hour,
    SUM(rush) AS rush,
    SUM(bw_bonus) AS bw_bonus,
    SUM(quest) AS quest,
    SUM(stacking + other_bonus + scoring + other_costs + boost + multiplier) AS other,
    SUM(special) AS special,
    SUM(c.total_comp_lc) AS total_comp_lc,

    -- Grouped EUR
    SUM(base_eur + extra_eur + waiting_eur + dist_near_pickup_eur + basic_per_pickedup_eur) AS pickup_eur,
    SUM(dist_near_drop_eur + basic_per_delivery_eur) AS drop_off_eur,
    SUM(min_cpo_eur) AS min_cpo_eur,
    SUM(distance_eur + dist_per_drop_eur + dist_per_return_eur + dist_per_pickup_eur + all_distances_eur) AS distance_eur,
    SUM(basic_not_map_eur + basic_per_return_eur) AS other_return_trip_eur,
    SUM(basic_eur_col + hidden_basic_eur) AS min_per_hour_eur,
    SUM(rush_eur) AS rush_eur,
    SUM(bw_bonus_eur) AS bw_bonus_eur,
    SUM(quest_eur) AS quest_eur,
    SUM(stacking_eur + other_bonus_eur + scoring_eur + other_costs_eur + boost_eur + multiplier_eur) AS other_eur,
    SUM(special_eur) AS special_eur,
    SUM(c.total_comp_eur) AS total_comp_eur

  FROM costs c
  LEFT JOIN dh_orders ov ON ov.city_code = c.city_code AND ov.week = c.week
  GROUP BY 1,2,3
)

SELECT * FROM cpo_breakdown ORDER BY 1,2;
