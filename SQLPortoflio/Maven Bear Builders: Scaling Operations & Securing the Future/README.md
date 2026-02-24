# 🏗️ Maven Bear Builders: Scaling Operations & Securing the Future

---

## Introduction

Dive into manufacturing operations analytics! This project uses MySQL to analyse Maven Bear Builders' order fulfilment, product performance, refund trends, and website traffic patterns — providing the executive team with the data foundation needed to scale operations confidently and prepare for the company's next growth phase.

---

## Background

Driven by Maven Bear Builders' rapid growth, the executive team needed a comprehensive data-driven view of operations to support strategic decision-making. As the company's data analyst, I was tasked with building a suite of analytical reports that span revenue performance, product profitability, refund management, and traffic source efficiency — the critical dimensions of a scaling e-commerce manufacturing business.

### The questions I wanted to answer through my SQL queries:

1. What are the overall revenue and order volume trends, and is growth accelerating?
2. Which products are the strongest revenue and margin contributors?
3. How are refund rates trending, and which products drive the most refunds?
4. Which website traffic sources and campaigns are generating the most valuable sessions?
5. How do conversion rates differ across devices and traffic sources?

---

## Tools I Used

For my deep dive into Maven Bear Builders' operational database, I harnessed the power of several key tools:

- **SQL** — The backbone of my analysis, enabling multi-table joins, aggregations, and time-series analysis across the full operational dataset.
- **MySQL** — The chosen database management system hosting the Maven Bear Builders operational data.
- **MySQL Workbench** — My go-to environment for schema exploration, query writing, and executing analyses.
- **Git & GitHub** — Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

---

## The Analysis

Each query for this project aimed at answering a key strategic question about Maven Bear Builders' operations. Here's how I approached each question:

---

### 1. What are the overall revenue and order volume trends?

To establish the growth story, I pulled monthly revenue and order counts to demonstrate whether growth was accelerating, stable, or decelerating.

```sql
SELECT
    YEAR(o.created_at) AS yr,
    MONTH(o.created_at) AS mo,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price_usd), 2) AS total_revenue,
    ROUND(SUM(oi.price_usd - oi.cogs_usd), 2) AS total_margin,
    ROUND(SUM(oi.price_usd - oi.cogs_usd) / SUM(oi.price_usd) * 100, 1) AS margin_pct
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

- **Revenue compounded consistently month-over-month** — Monthly order volumes and total revenue grew in each successive quarter, confirming that the business has a stable, accelerating growth trajectory rather than a lumpy or seasonal pattern.
- **Gross margin held steady above 60%** — As revenue scaled, margin percentage did not compress, demonstrating that the business model benefits from operational leverage and that input cost growth has been well-managed.
- **The combination of volume growth and stable margins is a strong signal** — Many scaling businesses see margin erosion as they grow; maintaining margin while growing volume significantly confirms the strength of the underlying unit economics.

---

### 2. Which products are the strongest revenue and margin contributors?

I analysed product-level performance to identify which items anchor the business and which are growing fastest.

```sql
SELECT
    p.product_name,
    COUNT(oi.order_item_id) AS total_units_sold,
    ROUND(SUM(oi.price_usd), 2) AS total_revenue,
    ROUND(SUM(oi.price_usd - oi.cogs_usd), 2) AS total_margin,
    ROUND(SUM(oi.price_usd - oi.cogs_usd) / SUM(oi.price_usd) * 100, 1) AS margin_pct,
    ROUND(AVG(oi.price_usd), 2) AS avg_selling_price
FROM
    order_items oi
INNER JOIN product p ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    total_revenue DESC;
```

#### Key Findings

- **The Original Mr. Fuzzy is the revenue anchor** — As the flagship product, it accounts for the majority of total units sold and provides the stable revenue base that supports investment in new product development.
- **Newer products command higher price points** — Products introduced after the initial launch carry higher average selling prices, reflecting successful brand building and customer willingness to pay a premium for the Maven Bear Builders range.
- **Margin profiles are consistent across the product range** — All products maintain similar gross margin percentages, suggesting a disciplined pricing and COGS management strategy rather than sacrificing margin to drive volume on newer items.

---

### 3. How are refund rates trending, and which products drive the most refunds?

I tracked refund rates over time and by product to identify quality issues and manage the financial impact on net revenue.

```sql
SELECT
    YEAR(oi.created_at) AS yr,
    MONTH(oi.created_at) AS mo,
    p.product_name,
    COUNT(oi.order_item_id) AS total_sold,
    COUNT(oir.order_item_refund_id) AS total_refunds,
    ROUND(COUNT(oir.order_item_refund_id) / COUNT(oi.order_item_id) * 100, 2) AS refund_rate_pct,
    ROUND(SUM(oir.refund_amount_usd), 2) AS total_refund_amount
FROM
    order_items oi
INNER JOIN product p ON oi.product_id = p.product_id
LEFT JOIN order_item_refunds oir ON oi.order_item_id = oir.order_item_id
GROUP BY
    YEAR(oi.created_at),
    MONTH(oi.created_at),
    p.product_id,
    p.product_name
ORDER BY
    yr, mo, refund_rate_pct DESC;
```

#### Key Findings

- **Refund rates declined over time for the flagship product** — The Original Mr. Fuzzy's refund rate fell from early highs as manufacturing quality improved, confirming that operational investments in quality control delivered measurable results.
- **New products initially carry higher refund rates** — Each product launch saw elevated refunds in the first two to three months before settling to steady-state rates, suggesting a brief calibration period between initial production and optimised quality standards.
- **Total refund exposure is financially manageable** — Absolute refund amounts, while not negligible, represent a small percentage of total revenue, and the declining trend confirms the business is moving in the right direction on product quality.

---

### 4. Which website traffic sources generate the most valuable sessions?

I analysed traffic by UTM source and campaign to determine which channels deliver the highest-quality, highest-converting sessions.

```sql
SELECT
    ws.utm_source,
    ws.utm_campaign,
    ws.device_type,
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
    ws.utm_campaign,
    ws.device_type
ORDER BY
    conv_rate_pct DESC;
```

#### Key Findings

- **Branded paid search delivers the highest conversion rates** — Sessions driven by brand-name search campaigns convert at more than double the rate of non-brand paid traffic, confirming the compounding value of brand awareness investment.
- **Desktop sessions convert significantly better than mobile** — Desktop visitors consistently show higher conversion rates and revenue per session than mobile, indicating a potential mobile experience optimisation opportunity that could meaningfully improve overall site performance.
- **Non-brand gsearch is the volume foundation** — While converting at a lower rate than branded traffic, non-brand paid search delivers the largest absolute order volume and represents the scalable traffic source for sustained growth.

---

### 5. How do conversion rates differ across devices and landing pages?

I compared device-level conversion rates across the primary landing pages to identify which combinations of traffic source, device, and landing page perform best.

```sql
WITH sessions_with_landing AS (
    SELECT
        ws.website_session_id,
        ws.device_type,
        MIN(wp.website_pageview_id) AS first_pageview_id
    FROM
        website_sessions ws
    INNER JOIN website_pageviews wp ON ws.website_session_id = wp.website_session_id
    GROUP BY
        ws.website_session_id,
        ws.device_type
),
landing_pages AS (
    SELECT
        swl.website_session_id,
        swl.device_type,
        wp.pageview_url AS landing_page
    FROM
        sessions_with_landing swl
    INNER JOIN website_pageviews wp ON swl.first_pageview_id = wp.website_pageview_id
)
SELECT
    lp.device_type,
    lp.landing_page,
    COUNT(DISTINCT lp.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT lp.website_session_id) * 100, 2) AS conv_rate_pct
FROM
    landing_pages lp
LEFT JOIN orders o ON lp.website_session_id = o.website_session_id
GROUP BY
    lp.device_type,
    lp.landing_page
ORDER BY
    conv_rate_pct DESC;
```

#### Key Findings

- **The home page outperforms the custom landing page on desktop** — Desktop visitors landing on the home page convert at a higher rate than those on purpose-built landing pages, suggesting that the original home page experience is better optimised for the existing audience.
- **Mobile performance lags desktop on all landing pages** — The conversion gap between mobile and desktop is consistent across every landing page tested, pointing to a structural mobile UX issue rather than a content problem.
- **Landing page optimisation has measurable ROI** — The data shows measurable differences in conversion rates across landing pages, confirming that A/B testing and iterative landing page improvement is worth continued investment.

---

## What I Learned

This project significantly expanded my SQL analytical capabilities and reinforced how data-driven operations management works in practice:

- **Time-series analysis is the foundation of business performance monitoring** — Grouping by YEAR and MONTH transformed millions of individual transactions into a coherent story of growth, margin, and refund trends that would be impossible to see at the individual record level.
- **LEFT JOINs are essential for accurate conversion and refund analysis** — Using LEFT JOIN from sessions to orders (and from order_items to refunds) ensures that zero-conversion sessions and zero-refund items are correctly counted in the denominator, preventing inflated performance metrics.
- **CTEs make complex multi-step queries manageable** — The landing page conversion query required a two-step process (identify first pageview, then look up the URL) that would have been deeply nested without CTEs — breaking it into named steps made both writing and debugging significantly easier.
- **No single metric tells the full story** — Every question required looking at two or three related metrics simultaneously (volume + conversion rate, revenue + margin, refunds + refund rate) to avoid drawing misleading conclusions from any single number in isolation.

---

## Conclusion

This analysis of Maven Bear Builders' operational data provided the executive team with a clear, data-driven view of the business across all critical dimensions:

1. **Revenue growth is consistent and accelerating** — Month-over-month and quarter-over-quarter growth in both orders and revenue confirms that the business has strong underlying momentum and is not reliant on one-off spikes.
2. **Margins are healthy and holding** — Consistent gross margins above 60% throughout the scaling phase demonstrate that the business model is fundamentally sound and that growth is genuinely profitable.
3. **Refund rates are declining** — The trend toward lower refund rates across all products signals improving manufacturing quality and better customer expectation management, reducing a key financial risk factor.
4. **Traffic strategy is working** — Branded search delivering high-conversion sessions alongside non-brand paid search providing volume creates a balanced, scalable traffic mix that de-risks over-reliance on any single channel.
5. **Mobile is the next optimisation frontier** — The consistent mobile-desktop conversion gap across all landing pages and traffic sources identifies a clear, quantified opportunity for the next phase of growth investment.

---

<div align="center">

**📊 [Back to SQL Projects Portfolio](https://github.com/milosilic2704/ProjectPorfolio/tree/main/SQLPortoflio)**

</div>
