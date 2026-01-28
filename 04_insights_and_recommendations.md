# 04_insights_and_recommendations.md

## Executive Summary

This project presents an end-to-end business data analysis of hotel bookings data, covering data preparation, SQL-based KPI analysis, and interactive Power BI dashboards.

Using structured SQL transformations and analytical views, the analysis focuses on revenue performance, cancellation behavior, seasonality, and customer segmentation. The results highlight that while overall demand is strong, high cancellation rates and segment-level inefficiencies significantly reduce net revenue.

The findings support actionable, data-driven recommendations aimed at improving revenue stability, forecasting reliability, and decision-making quality rather than simply increasing booking volume.

---

## Key Insights (Based on SQL Analysis & Power BI Dashboards)

### 1. High booking volume does not translate directly into revenue
- 119K total bookings generated approximately 26M in net revenue.
- The overall cancellation rate is high (37%), significantly reducing realized revenue.
- Insight: Demand is strong, but revenue quality is weakened by cancellations.

---

### 2. Revenue follows a clear seasonal pattern
- Monthly revenue trends show repeating peaks and troughs across years.
- Low-revenue months are associated with higher volatility.
- Insight: Uniform pricing and booking policies across all months are likely suboptimal.

---

### 3. City Hotels drive more revenue but carry higher cancellation risk
- City Hotels generate higher net revenue compared to Resort Hotels.
- City Hotels also show noticeably higher cancellation rates.
- Insight: City Hotels are the main revenue driver but also the largest source of revenue instability.

---

### 4. Market segments differ significantly in value and reliability
- Some market segments contribute high booking volumes but cancel frequently.
- Other segments generate fewer bookings but are more reliable.
- Insight: Booking volume alone is not a sufficient indicator of segment value.

---

### 5. Distribution channels impact cancellation behavior
- Cancellation rates and lead times vary significantly across distribution channels.
- Certain channels contribute disproportionately to revenue volatility.
- Insight: Channel mix directly affects revenue predictability and operational planning.

---

## Business Recommendations

### 1. Reduce cancellations in high-risk segments
- Introduce stricter cancellation policies or deposits for segments with high cancellation rates.
- Expected impact: Higher realized revenue without increasing booking volume.
- KPIs to monitor:
  - Cancellation rate by segment
  - Net revenue per booking

---

### 2. Apply season-aware pricing and booking policies
- Adjust pricing and cancellation rules based on seasonal demand patterns.
- Expected impact: Improved revenue stability and better demand management.
- KPIs to monitor:
  - Monthly net revenue
  - Cancellation rate by month

---

### 3. Protect City Hotel revenue
- Focus revenue-protection strategies primarily on City Hotels.
- Expected impact: Reduced revenue leakage in the highest-volume hotel category.
- KPIs to monitor:
  - City Hotel cancellation rate
  - Net revenue growth

---

### 4. Optimize distribution channel mix
- Prioritize channels with lower cancellation rates and more predictable demand.
- Reassess reliance on channels associated with high cancellation risk.
- Expected impact: Improved revenue quality and forecasting accuracy.
- KPIs to monitor:
  - Net revenue by channel
  - Cancellation rate by channel

---

## Limitations

- Revenue is estimated using ADR multiplied by total nights.
- Cost data and profitability metrics were not available.
- Customer lifetime value and repeat booking behavior could not be analyzed.

---

## Next Analytical Steps

- Develop a cancellation risk model using lead time, market segment, and channel data.
- Build scenario simulations (e.g. impact of reducing cancellation rate by 5%).
- Extend analysis to include pricing optimization and profitability modeling.

---

## Tools & Workflow

- SQL (SQLite): Data preparation, KPI calculation, analytical views
- Power BI: Data modeling, KPI dashboards, segmentation analysis
- AI-assisted workflow: Structuring analysis, insight validation, documentation

---

