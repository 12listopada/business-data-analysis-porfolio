-- 03_sql_analysis.sql
-- Project: Business Data Analysis (Hotel Bookings) | AI-assisted workflow
-- Database: SQLite (DB Browser for SQLite)
-- Purpose:
--   1) Prepare clean analytical tables
--   2) Calculate core KPIs
--   3) Build monthly/segment/channel views for Power BI

/* =========================================================
   0) SANITY CHECKS (raw data)
   ========================================================= */

SELECT COUNT(*) AS raw_rows FROM raw_bookings;

/* =========================================================
   1) DATA PREPARATION (clean tables)
   Notes:
   - Convert arrival year/month/day into a proper date (arrival_date)
   - Create booking_id from rowid
   - Create total_nights
   ========================================================= */

-- If you need to rerun, drop existing tables first
-- DROP TABLE IF EXISTS bookings;
-- DROP TABLE IF EXISTS pricing;

CREATE TABLE bookings AS
SELECT
  rowid AS booking_id,
  hotel,
  DATE(
    arrival_date_year || '-' ||
    CASE arrival_date_month
      WHEN 'January' THEN '01'
      WHEN 'February' THEN '02'
      WHEN 'March' THEN '03'
      WHEN 'April' THEN '04'
      WHEN 'May' THEN '05'
      WHEN 'June' THEN '06'
      WHEN 'July' THEN '07'
      WHEN 'August' THEN '08'
      WHEN 'September' THEN '09'
      WHEN 'October' THEN '10'
      WHEN 'November' THEN '11'
      WHEN 'December' THEN '12'
    END || '-' ||
    printf('%02d', arrival_date_day_of_month)
  ) AS arrival_date,
  lead_time,
  stays_in_weekend_nights + stays_in_week_nights AS total_nights,
  adr,
  adults,
  children,
  babies,
  is_canceled,
  market_segment,
  distribution_channel,
  country,
  deposit_type
FROM raw_bookings;

SELECT COUNT(*) AS bookings_rows FROM bookings;

CREATE TABLE pricing AS
SELECT
  booking_id,
  adr,
  total_nights,
  ROUND(adr * total_nights, 2) AS estimated_revenue
FROM bookings;

SELECT COUNT(*) AS pricing_rows FROM pricing;

/* =========================================================
   2) CORE KPIs (overall)
   ========================================================= */

-- Overall bookings + cancellation rate
SELECT
  COUNT(*) AS total_bookings,
  SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS canceled_bookings,
  ROUND(1.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS cancel_rate
FROM bookings;

-- Revenue (gross vs net; net excludes canceled bookings)
SELECT
  ROUND(SUM(p.estimated_revenue), 2) AS revenue_gross,
  ROUND(SUM(CASE WHEN b.is_canceled = 1 THEN 0 ELSE p.estimated_revenue END), 2) AS revenue_net,
  ROUND(AVG(p.estimated_revenue), 2) AS avg_revenue_per_booking
FROM pricing p
JOIN bookings b ON b.booking_id = p.booking_id;

-- ADR, lead time, length of stay
SELECT
  ROUND(AVG(adr), 2) AS avg_adr,
  ROUND(AVG(lead_time), 2) AS avg_lead_time,
  ROUND(AVG(total_nights), 2) AS avg_total_nights
FROM bookings;

/* =========================================================
   3) TIME TRENDS (monthly)
   ========================================================= */

-- Monthly KPIs (bookings, revenue, cancel rate, ADR)
SELECT
  strftime('%Y-%m', b.arrival_date) AS year_month,
  COUNT(*) AS bookings,
  ROUND(AVG(b.adr), 2) AS avg_adr,
  ROUND(SUM(CASE WHEN b.is_canceled = 1 THEN 0 ELSE p.estimated_revenue END), 2) AS revenue_net,
  ROUND(1.0 * SUM(CASE WHEN b.is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS cancel_rate
FROM bookings b
JOIN pricing p ON p.booking_id = b.booking_id
GROUP BY 1
ORDER BY 1;

/* =========================================================
   4) SEGMENTS & CHANNELS
   ========================================================= */

-- Hotel type (City vs Resort)
SELECT
  hotel,
  COUNT(*) AS bookings,
  ROUND(1.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS cancel_rate,
  ROUND(SUM(CASE WHEN is_canceled = 1 THEN 0 ELSE adr * total_nights END), 2) AS revenue_net
FROM bookings
GROUP BY 1
ORDER BY revenue_net DESC;

-- Distribution channel
SELECT
  distribution_channel,
  COUNT(*) AS bookings,
  ROUND(AVG(lead_time), 1) AS avg_lead_time,
  ROUND(1.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS cancel_rate,
  ROUND(SUM(CASE WHEN is_canceled = 1 THEN 0 ELSE adr * total_nights END), 2) AS revenue_net
FROM bookings
GROUP BY 1
ORDER BY revenue_net DESC;

-- Market segment
SELECT
  market_segment,
  COUNT(*) AS bookings,
  ROUND(1.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS cancel_rate,
  ROUND(SUM(CASE WHEN is_canceled = 1 THEN 0 ELSE adr * total_nights END), 2) AS revenue_net
FROM bookings
GROUP BY 1
ORDER BY revenue_net DESC;

-- Top 10 countries by net revenue
SELECT
  country,
  COUNT(*) AS bookings,
  ROUND(SUM(CASE WHEN is_canceled = 1 THEN 0 ELSE adr * total_nights END), 2) AS revenue_net
FROM bookings
GROUP BY 1
ORDER BY revenue_net DESC
LIMIT 10;

/* =========================================================
   5) VIEWS FOR POWER BI
   Purpose:
   - Provide clean, ready-to-use analytical layers
   - Simplify Power BI modeling
   ========================================================= */

-- Monthly KPIs (time series)
CREATE VIEW v_monthly_kpi AS
SELECT
  strftime('%Y-%m', arrival_date) AS year_month,
  COUNT(*) AS bookings,
  ROUND(AVG(adr), 2) AS avg_adr,
  ROUND(
    SUM(CASE WHEN is_canceled = 1 THEN 0 ELSE adr * total_nights END),
    2
  ) AS revenue_net,
  ROUND(
    1.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*),
    4
  ) AS cancel_rate
FROM bookings
GROUP BY 1
ORDER BY 1;


-- Market segment performance
CREATE VIEW v_segment_performance AS
SELECT
  market_segment,
  COUNT(*) AS bookings,
  ROUND(
    1.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*),
    4
  ) AS cancel_rate,
  ROUND(
    SUM(CASE WHEN is_canceled = 1 THEN 0 ELSE adr * total_nights END),
    2
  ) AS revenue_net
FROM bookings
GROUP BY 1
ORDER BY revenue_net DESC;


-- Distribution channel performance
CREATE VIEW v_channel_performance AS
SELECT
  distribution_channel,
  COUNT(*) AS bookings,
  ROUND(AVG(lead_time), 1) AS avg_lead_time,
  ROUND(
    1.0 * SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) / COUNT(*),
    4
  ) AS cancel_rate,
  ROUND(
    SUM(CASE WHEN is_canceled = 1 THEN 0 ELSE adr * total_nights END),
    2
  ) AS revenue_net
FROM bookings
GROUP BY 1
ORDER BY revenue_net DESC;
-- Add analytical views for Power BI (monthly KPI, segments, channels)

