# NYC 311 Service Operations & Resolution Performance Intelligence

**Live dashboard:** [View on Tableau Public](PASTE_TABLEAU_PUBLIC_URL_HERE)

## Project Overview

Independent portfolio analysis of **2.32 million NYC 311 service requests** created from **January through October 2021**. Using BigQuery SQL and Tableau, this project examines service-request workload, closures, resolution-time trends, agency and complaint-type bottlenecks, and borough demand.

## Business Questions

- How did request workload and closures change over time?
- How did typical and long-tail resolution time change?
- Which agency and complaint-type combinations combine high volume with long P90 resolution times?
- How does workload and resolution performance vary across NYC boroughs?

## Dashboard

The Tableau dashboard contains four views:

1. **Monthly Workload & Closures** — tracks incoming requests and closed requests by month.
2. **Resolution Time Trend** — compares average closure time with P90 closure time.
3. **High-Volume Service Bottlenecks** — identifies agency and complaint-type categories with substantial workload and long resolution-time tails.
4. **Borough Workload & P90 Resolution Time** — compares request demand and long-tail closure time across the five boroughs.

## Data and Methodology

- **Source:** `bigquery-public-data.new_york_311.311_service_requests`
- **Analysis period:** January 1–October 31, 2021
- **Records analyzed:** 2,316,214 service requests
- Resolution time is calculated as the hours between request creation and closure.
- Records with missing or negative closure durations are excluded from resolution-time calculations.
- Agency/complaint combinations with fewer than 500 requests are excluded from the bottleneck comparison.

## Key Metric

**P90 resolution time** is the point at which 90% of valid closed requests were resolved at or before that number of hours. It highlights long-tail service delays that an average can hide.

P90 is an observed analytical metric—not an official NYC service-level agreement.

## Tools

- Google BigQuery
- SQL
- Tableau Public
- GitHub

## Repository Structure

```text
sql/
  01_monthly_operations_metrics.sql
  02_agency_complaint_performance.sql
  03_borough_service_demand.sql

data/
  monthly_operations_metrics.csv
  agency_complaint_performance.csv
  borough_service_demand.csv
```

## Interpretation Notes

Request volume is a measure of service demand, not customer satisfaction or agency quality. Changes in closure-time metrics can also reflect changes in the mix of service-request types.
