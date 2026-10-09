-- Monthly NYC 311 workload, closures, and resolution-time metrics
-- Analysis period: January 1–October 31, 2021

WITH base_requests AS (
  SELECT
    created_date,
    closed_date
  FROM `bigquery-public-data.new_york_311.311_service_requests`
  WHERE created_date >= TIMESTAMP('2021-01-01')
    AND created_date < TIMESTAMP('2021-11-01')
)

SELECT
  DATE_TRUNC(DATE(created_date), MONTH) AS month_start,
  COUNT(*) AS requests_received,
  COUNTIF(closed_date IS NOT NULL) AS requests_closed,
  COUNTIF(closed_date IS NULL) AS requests_still_open,
  ROUND(
    100 * SAFE_DIVIDE(COUNTIF(closed_date IS NOT NULL), COUNT(*)),
    2
  ) AS closure_rate_pct,
  ROUND(
    AVG(
      IF(
        closed_date >= created_date,
        TIMESTAMP_DIFF(closed_date, created_date, HOUR),
        NULL
      )
    ),
    1
  ) AS avg_resolution_hours,
  APPROX_QUANTILES(
    IF(
      closed_date >= created_date,
      TIMESTAMP_DIFF(closed_date, created_date, HOUR),
      NULL
    ),
    100
  )[OFFSET(50)] AS median_resolution_hours,
  APPROX_QUANTILES(
    IF(
      closed_date >= created_date,
      TIMESTAMP_DIFF(closed_date, created_date, HOUR),
      NULL
    ),
    100
  )[OFFSET(90)] AS p90_resolution_hours
FROM base_requests
GROUP BY 1
ORDER BY 1;
