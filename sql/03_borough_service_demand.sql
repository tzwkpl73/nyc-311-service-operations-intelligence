-- Borough-level NYC 311 workload and resolution-time comparison
-- Analysis period: January 1–October 31, 2021

WITH base_requests AS (
  SELECT
    CASE
      WHEN borough IS NULL OR TRIM(borough) = '' THEN 'Unspecified'
      ELSE borough
    END AS borough,
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
)

SELECT
  borough,
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
GROUP BY 1
ORDER BY requests_received DESC;
