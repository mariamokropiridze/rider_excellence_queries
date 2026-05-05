# rider_excellence_queries

Central place for source of truth queries for the Rider Excellence department at Glovo.

## What is this?

This repository contains the canonical SQL queries used by the Rider Excellence team to monitor and evaluate courier performance and operational health. Each metric has its own dedicated `.sql` file under the `sql/` directory.

## Metrics Guide — What to Check Where

| Metric | Description | SQL File |
|---|---|---|
| Acceptance Rate | Share of orders accepted by couriers out of total orders offered | [sql/acceptance_rate.sql](sql/acceptance_rate.sql) |
| Completion Rate | Share of accepted orders that were successfully completed | [sql/completion_rate.sql](sql/completion_rate.sql) |
| On-Time Delivery Rate | Share of orders delivered within the promised time window | [sql/on_time_delivery_rate.sql](sql/on_time_delivery_rate.sql) |
| Average Rating | Average customer rating given to couriers | [sql/average_rating.sql](sql/average_rating.sql) |
| Active Couriers | Count of unique couriers active in a given period | [sql/active_couriers.sql](sql/active_couriers.sql) |
| Orders Per Hour | Average number of orders delivered per active courier per hour | [sql/orders_per_hour.sql](sql/orders_per_hour.sql) |

## Repository Structure

```
rider_excellence_queries/
├── README.md          ← this guide (start here)
└── sql/
    ├── acceptance_rate.sql
    ├── completion_rate.sql
    ├── on_time_delivery_rate.sql
    ├── average_rating.sql
    ├── active_couriers.sql
    └── orders_per_hour.sql
```

## How to Use

1. Identify the metric you need from the table above.
2. Open the corresponding `.sql` file in the `sql/` folder.
3. Adjust the date filters (`:start_date`, `:end_date`) and the city/country filters (`:city_id`, `:country_code`) to match your analysis window.
4. Run the query against the relevant data warehouse table.

## Contributing

When adding a new metric:
1. Create a new `.sql` file in the `sql/` directory named after the metric (snake_case).
2. Add a row for the new metric in the table above in this README.
