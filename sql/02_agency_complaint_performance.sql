-- Agency and complaint-type workload and resolution-time performance
-- Analysis period: January 1–October 31, 2021
-- Keeps categories with at least 500 requests

WITH base_requests AS (
  SELECT
    agency,
    complaint_type,
    created_date,
    closed_date,
    IF(
      closed_date >= created_date,
      TIMESTAMP_DIFF(closed_date, created_date, HOUR),
      NULL
    ) AS resolution_hours
  FROM `bigquery-public-data.new_york_311.311_service_requests`
  WHERE created_date >= TIMESTAMP('2021-01-01')
    AND created_date < TIMESTAMP('2021-11-01')
),

performance AS (
  SELECT
    agency,
    complaint_type,
    COUNT(*) AS requests_received,
    COUNTIF(closed_date IS NOT NULL) AS requests_closed,
    ROUND(
      100 * SAFE_DIVIDE(COUNTIF(closed_date IS NOT NULL), COUNT(*)),
      2
    ) AS closure_rate_pct,
    APPROX_QUANTILES(resolution_hours, 100)[OFFSET(50)]
      AS median_resolution_hours,
    APPROX_QUANTILES(resolution_hours, 100)[OFFSET(90)]
      AS p90_resolution_hours
  FROM base_requests
  GROUP BY 1, 2
)

SELECT *
FROM performance
WHERE requests_received >= 500
ORDER BY median_resolution_hours DESC, requests_received DESC;
