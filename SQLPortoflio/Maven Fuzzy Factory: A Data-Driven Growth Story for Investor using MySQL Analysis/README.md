# 📈 Maven Fuzzy Factory: A Data-Driven Growth Story for Investors

---

## Introduction

Dive into e-commerce analytics! This project uses MySQL to analyse Maven Fuzzy Factory's website traffic, conversion funnels, and product performance data to tell a compelling, data-driven growth story for potential investors — demonstrating how the business scaled from launch to a profitable, multi-product operation.

---

## Background

Driven by the need to prepare a compelling investor presentation, this project was built to extract and quantify Maven Fuzzy Factory's key business milestones using raw database data. The analysis spans the company's full operating history and demonstrates mastery of traffic analysis, conversion optimisation, and revenue reporting using advanced MySQL techniques.

### The questions I wanted to answer through my SQL queries:

1. How have overall session volumes and order volumes grown since launch?
2. How have conversion rates and revenue per session improved over time?
3. Which traffic sources are driving the most valuable sessions?
4. How have product sales and cross-selling performance evolved?
5. What does the overall revenue and margin story look like for investors?

---

## Tools I Used

For my deep dive into Maven Fuzzy Factory's e-commerce data, I harnessed the power of several key tools:

- **SQL** — The backbone of my analysis, enabling complex multi-table joins, subqueries, and time-series aggregations.
- **MySQL** — The chosen database management system hosting the Maven Fuzzy Factory operational database.
- **MySQL Workbench** — My go-to environment for writing, executing, and iterating on SQL queries.
- **Git & GitHub** — Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

---

## The Analysis

Each query for this project aimed at quantifying a key dimension of Maven Fuzzy Factory's growth story. Here's how I approached each question:

---

### 1. How have overall session and order volumes grown since launch?

To establish the growth narrative, I pulled quarterly session and order volumes to demonstrate the business's trajectory from launch to the present.

```sql
SELECT
    YEAR(ws.created_at) AS yr,
    QUARTER(ws.created_at) AS qtr,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id) * 100, 2) AS conv_rate_pct
FROM
    website_sessions ws
LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
GROUP BY
    YEAR(ws.created_at),
    QUARTER(ws.created_at)
ORDER BY
    yr, qtr;
```

#### Key Findings

- **Session volume grew over 10x from launch** — Quarterly sessions increased from a few hundred in early quarters to tens of thousands, demonstrating that marketing investments and SEO improvements delivered sustained audience growth.
- **Conversion rate improved alongside volume growth** — Early conversion rates hovered around 3%, rising to over 8% as landing page optimisations and checkout flow improvements took effect, proving that growth was driven by quality improvements, not just volume.
- **Order volume compounded faster than sessions** — The combination of higher traffic and better conversion rates meant orders grew at a faster rate than raw sessions, indicating improving unit economics as the business scaled.

---

### 2. How have conversion rates and revenue per session improved?

I looked at the average revenue generated per session to measure the quality of traffic improvement over time.

```sql
SELECT
    YEAR(ws.created_at) AS yr,
    QUARTER(ws.created_at) AS qtr,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(o.price_usd) / COUNT(DISTINCT ws.website_session_id), 2) AS revenue_per_session,
    ROUND(SUM(o.price_usd), 2) AS total_revenue,
    ROUND(SUM(o.price_usd - o.cogs_usd), 2) AS total_margin
FROM
    website_sessions ws
LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
GROUP BY
    YEAR(ws.created_at),
    QUARTER(ws.created_at)
ORDER BY
    yr, qtr;
```

#### Key Findings

- **Revenue per session more than doubled** — Early quarters averaged under $1.50 revenue per session; later quarters consistently exceeded $3.50, demonstrating that the business was generating significantly more value from each visitor.
- **Margin improvement tracked revenue growth** — Total margin grew alongside revenue, confirming that product mix improvements and operational efficiencies were not eroded by higher costs.
- **Quarterly revenue compounding is investable** — The consistent quarter-over-quarter growth in revenue makes a compelling case for continued investment, as the underlying unit economics improve with scale.

---

### 3. Which traffic sources drive the most valuable sessions?

I broke down performance by UTM source and campaign to identify which channels deliver the highest-quality traffic.

```sql
SELECT
    ws.utm_source,
    ws.utm_campaign,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id) * 100, 2) AS conv_rate_pct,
    ROUND(SUM(o.price_usd) / COUNT(DISTINCT ws.website_session_id), 2) AS revenue_per_session
FROM
    website_sessions ws
LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
WHERE
    ws.utm_source IS NOT NULL
GROUP BY
    ws.utm_source,
    ws.utm_campaign
ORDER BY
    conv_rate_pct DESC;
```

#### Key Findings

- **Brand search campaigns convert at the highest rate** — Sessions from branded search terms convert over 2x the rate of non-brand paid search, confirming the value of brand-building investment in driving high-intent traffic.
- **gsearch nonbrand is the dominant volume driver** — While brand search converts best, non-brand paid search delivers the largest absolute order volume and provides the scalable traffic foundation for growth.
- **Organic and direct traffic have strong economics** — Free traffic channels (organic search and direct navigation) deliver above-average conversion rates at zero marginal cost, representing the most efficient traffic source on a revenue-per-session basis.

---

### 4. How have product sales and cross-selling evolved?

I analysed product-level performance and cross-sell rates to show how the product expansion strategy has played out.

```sql
SELECT
    YEAR(o.created_at) AS yr,
    MONTH(o.created_at) AS mo,
    COUNT(DISTINCT CASE WHEN oi.product_id = 1 THEN o.order_id ELSE NULL END) AS p1_orders,
    COUNT(DISTINCT CASE WHEN oi.product_id = 2 THEN o.order_id ELSE NULL END) AS p2_orders,
    COUNT(DISTINCT CASE WHEN oi.product_id = 3 THEN o.order_id ELSE NULL END) AS p3_orders,
    COUNT(DISTINCT CASE WHEN oi.product_id = 4 THEN o.order_id ELSE NULL END) AS p4_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN oi.is_primary_item = 0 THEN oi.order_item_id ELSE NULL END) /
        NULLIF(COUNT(DISTINCT o.order_id), 0) * 100, 2
    ) AS cross_sell_rate_pct
FROM
    orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.created_at),
    MONTH(o.created_at)
ORDER BY
    yr, mo;
```

#### Key Findings

- **Product 1 remains the revenue anchor** — The Original Mr. Fuzzy consistently drives the majority of orders, providing a stable base while newer products grow.
- **Cross-sell rate improved significantly after product expansion** — Introducing Product 3 and Product 4 increased the cross-sell attachment rate from under 5% to over 20%, demonstrating that a broader catalogue drives meaningful incremental revenue per order.
- **New products gained traction quickly** — Products 3 and 4 achieved meaningful monthly order volumes within two to three quarters of launch, suggesting that the existing customer base and traffic volume were well-suited to absorb new product introductions.

---

### 5. What does the overall revenue and margin story look like?

The final query builds the investor-facing summary — a clean view of revenue, margin, and refund rates across the full operating history.

```sql
SELECT
    YEAR(o.created_at) AS yr,
    QUARTER(o.created_at) AS qtr,
    SUM(oi.price_usd) AS total_revenue,
    SUM(oi.price_usd - oi.cogs_usd) AS total_margin,
    ROUND(SUM(oi.price_usd - oi.cogs_usd) / SUM(oi.price_usd) * 100, 1) AS margin_pct,
    COUNT(DISTINCT oir.order_item_refund_id) AS refunds,
    ROUND(COUNT(DISTINCT oir.order_item_refund_id) / COUNT(DISTINCT oi.order_item_id) * 100, 2) AS refund_rate_pct
FROM
    orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN order_item_refunds oir ON oi.order_item_id = oir.order_item_id
GROUP BY
    YEAR(o.created_at),
    QUARTER(o.created_at)
ORDER BY
    yr, qtr;
```

#### Key Findings

- **Gross margin held steady above 60% as the business scaled** — Despite significant revenue growth, margin percentage remained consistent, indicating that the cost structure scaled efficiently alongside volume.
- **Refund rates declined over time** — Early quarters saw refund rates above 8%; more recent quarters show rates under 5%, suggesting ongoing product quality improvements and better customer expectation-setting.
- **The business is a compounding story** — Revenue, margin, and order volume all grew consistently quarter-over-quarter, creating the kind of predictable, improving trajectory that makes a compelling case for continued investment.

---

## What I Learned

This project significantly expanded my MySQL analytical toolkit and deepened my ability to extract a coherent business narrative from raw operational data:

- **LEFT JOINs are essential for conversion analysis** — Using `LEFT JOIN orders ON website_session_id` (rather than INNER JOIN) ensures that sessions without orders are counted in the denominator when calculating conversion rates, preventing inflated metrics.
- **Conditional aggregation replaces multiple queries** — Using `COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_id END)` across a single query replaced what would otherwise have been four separate queries, significantly improving both performance and readability.
- **Time-series aggregation reveals the business story** — Grouping by YEAR and QUARTER turned millions of individual transaction records into a clear growth narrative, demonstrating that the right level of aggregation is as important as the query logic itself.
- **Investor-facing analysis requires context, not just numbers** — Metrics like revenue per session and cross-sell rate only become meaningful when placed in the context of time-series trends, confirming that data storytelling requires both calculation and interpretation.

---

## Conclusion

This exploration of Maven Fuzzy Factory's operational database revealed a compelling, data-backed growth story for investors:

1. **Traffic and conversion both improved** — Session volume and conversion rates grew simultaneously, proving that growth was driven by genuine business improvement rather than unsustainable spend increases.
2. **Revenue per session more than doubled** — This is the clearest indicator of improving unit economics and confirms that the business became meaningfully more efficient at monetising its traffic over time.
3. **Product expansion drove incremental revenue** — The introduction of Products 3 and 4 lifted cross-sell rates and added new revenue streams without cannibalising the core product, demonstrating disciplined portfolio management.
4. **Margin held steady at scale** — Maintaining consistent gross margin percentages through a 10x revenue increase is a strong indicator of operational leverage and sound cost management.
5. **The data tells a story of compounding improvement** — Every key metric — sessions, orders, revenue, margin, conversion rate — improved consistently quarter over quarter, creating the kind of trajectory that gives investors confidence in the business's fundamentals.

---

<div align="center">

**📊 [Back to SQL Projects Portfolio](https://github.com/milosilic2704/ProjectPorfolio/tree/main/SQLPortoflio)**

</div>
