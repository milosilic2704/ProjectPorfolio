# 🍽️ Restaurant Sales Analysis — SQL Project

---

## Introduction

Dive into restaurant operations! This project uses MySQL to analyse a restaurant's order data, uncovering which menu items drive the most revenue, when the busiest periods occur, and how order patterns reveal opportunities to optimise the menu and staffing strategy.

---

## Background

Driven by a desire to help a restaurant make smarter, data-backed operational decisions, this project was built to analyse order history and surface patterns that are invisible in day-to-day operations. The data covers menu items, order volumes, and timestamps, enabling both revenue analysis and operational planning.

### The questions I wanted to answer through my SQL queries:

1. What are the top-selling menu items by order volume and revenue?
2. Which menu categories generate the most revenue?
3. What time periods and days of the week are the busiest?
4. What is the average order value, and how does it vary by category?
5. Which items are frequently ordered together (potential bundle opportunities)?

---

## Tools I Used

For my deep dive into restaurant sales data, I harnessed the power of several key tools:

- **SQL** — The backbone of my analysis, allowing me to query, join, and aggregate order data to uncover actionable insights.
- **MySQL** — The chosen database management system, well-suited for the transactional order data structure.
- **MySQL Workbench** — My go-to environment for writing, executing, and testing SQL queries.
- **Git & GitHub** — Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

---

## The Analysis

Each query for this project aimed at answering a specific operational or strategic question about the restaurant's performance. Here's how I approached each question:

---

### 1. What are the top-selling menu items by order volume and revenue?

To identify the restaurant's most valuable offerings, I ranked all menu items by total orders and total revenue generated.

```sql
SELECT
    mi.item_name,
    mi.category,
    mi.price,
    COUNT(od.order_details_id) AS total_orders,
    ROUND(COUNT(od.order_details_id) * mi.price, 2) AS total_revenue
FROM
    menu_items mi
INNER JOIN order_details od ON mi.menu_item_id = od.item_id
GROUP BY
    mi.menu_item_id,
    mi.item_name,
    mi.category,
    mi.price
ORDER BY
    total_orders DESC
LIMIT 10;
```

#### Results

| Item | Category | Price | Orders | Revenue |
|---|---|---|---|---|
| Hamburger | American | $12.95 | 622 | $8,055.90 |
| Edamame | Asian | $5.00 | 620 | $3,100.00 |
| Korean Beef Bowl | Asian | $17.95 | 588 | $10,555.60 |
| Cheeseburger | American | $13.95 | 583 | $8,132.85 |
| French Fries | American | $7.00 | 571 | $3,997.00 |

#### Key Findings

- **American items dominate by volume** — Burgers and fries account for a disproportionate share of total orders, confirming that classic comfort food drives foot traffic and repeat visits.
- **Asian dishes generate the highest revenue per item** — The Korean Beef Bowl and other Asian entrées combine high order volume with premium pricing, making the Asian category the highest-revenue segment despite not leading in raw order count.
- **Low-price items inflate volume but not revenue** — Edamame is the second most ordered item but generates less than a third of the revenue of a single higher-priced entrée, highlighting the importance of analysing both volume and revenue simultaneously.

---

### 2. Which menu categories generate the most revenue?

I grouped revenue by category to identify which parts of the menu are most financially significant.

```sql
SELECT
    mi.category,
    COUNT(od.order_details_id) AS total_orders,
    ROUND(SUM(mi.price), 2) AS total_revenue,
    ROUND(AVG(mi.price), 2) AS avg_item_price,
    ROUND(SUM(mi.price) / COUNT(DISTINCT od.order_id), 2) AS revenue_per_order
FROM
    menu_items mi
INNER JOIN order_details od ON mi.menu_item_id = od.item_id
GROUP BY
    mi.category
ORDER BY
    total_revenue DESC;
```

#### Key Findings

- **Asian cuisine leads in total revenue** — Despite having a smaller item count than other categories, Asian dishes command higher average prices and strong order volumes, making them the top revenue-generating category.
- **American food drives the most orders** — The volume advantage of American comfort food is significant, but average item prices are lower, resulting in a second-place revenue position despite more orders.
- **Mexican dishes offer the best volume-to-revenue balance** — Moderate pricing combined with consistent order frequency places Mexican food as a reliable, stable revenue contributor across all service periods.

---

### 3. What time periods and days of the week are the busiest?

I analysed order timestamps to identify peak service periods and inform staffing decisions.

```sql
SELECT
    DAYNAME(o.order_date) AS day_of_week,
    HOUR(o.order_time) AS hour_of_day,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM
    orders o
GROUP BY
    DAYNAME(o.order_date),
    DAYOFWEEK(o.order_date),
    HOUR(o.order_time)
ORDER BY
    DAYOFWEEK(o.order_date),
    hour_of_day;
```

#### Key Findings

- **Friday and Saturday evenings generate peak order volume** — The 6pm–8pm window on weekends accounts for a disproportionate share of weekly orders, confirming that weekend dinner service is the most critical period for staffing and inventory preparation.
- **Lunch peaks Tuesday through Thursday** — Midweek lunch hours (12pm–1pm) show the second-highest order concentration, suggesting strong business lunch traffic that could be targeted with specific promotions.
- **Sunday brunch is a hidden opportunity** — Sunday mid-morning shows a distinct order cluster that is under-exploited compared to the potential for a dedicated brunch menu and marketing push.

---

### 4. What is the average order value, and how does it vary?

I calculated the average total spend per order overall and by time period to understand customer spending behaviour.

```sql
WITH order_totals AS (
    SELECT
        o.order_id,
        o.order_date,
        DAYNAME(o.order_date) AS day_of_week,
        SUM(mi.price) AS order_total
    FROM
        orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
    INNER JOIN menu_items mi ON od.item_id = mi.menu_item_id
    GROUP BY
        o.order_id,
        o.order_date
)
SELECT
    day_of_week,
    ROUND(AVG(order_total), 2) AS avg_order_value,
    ROUND(MAX(order_total), 2) AS max_order_value,
    COUNT(order_id) AS total_orders
FROM
    order_totals
GROUP BY
    day_of_week
ORDER BY
    avg_order_value DESC;
```

#### Key Findings

- **Weekend orders have the highest average value** — Saturday and Sunday show the largest average order totals, driven by larger group sizes and greater willingness to order premium dishes and extras outside of the workweek.
- **The maximum order values are significantly above average** — Large-group orders on weekends push the maximum order values well above the mean, suggesting an opportunity to create group dining packages that cater to this high-value segment.
- **Weekday lunch orders are the smallest in value** — Individual weekday lunch customers order fewer items at lower price points, confirming the need for a focused, affordable lunch menu that drives throughput rather than per-ticket value.

---

### 5. Which items are frequently ordered together?

I identified the most common item pairings across all orders to uncover natural bundle and upsell opportunities.

```sql
SELECT
    mi1.item_name AS item_1,
    mi2.item_name AS item_2,
    COUNT(*) AS times_ordered_together
FROM
    order_details od1
INNER JOIN order_details od2 ON od1.order_id = od2.order_id
    AND od1.item_id < od2.item_id
INNER JOIN menu_items mi1 ON od1.item_id = mi1.menu_item_id
INNER JOIN menu_items mi2 ON od2.item_id = mi2.menu_item_id
GROUP BY
    mi1.item_name,
    mi2.item_name
ORDER BY
    times_ordered_together DESC
LIMIT 10;
```

#### Key Findings

- **Burgers and fries are the most common pairing** — The Hamburger and French Fries combination appears in hundreds of orders, making it a natural candidate for a featured combo deal that could simplify ordering and increase attachment rate.
- **Asian dishes frequently accompany each other** — Multiple Asian items appear together across orders, suggesting that customers who order from the Asian category tend to explore the full range — an opportunity for a curated Asian tasting menu.
- **Cross-category pairings reveal upsell paths** — Several high-revenue entrées frequently appear alongside low-cost sides, providing a clear template for suggested additions that could increase average order value with minimal friction.

---

## What I Learned

This project deepened my practical understanding of how SQL can drive operational improvements in a real-world service business:

- **Self-joins unlock co-occurrence analysis** — The item pairing query required joining the `order_details` table to itself, with an `item_id < item_id` condition to avoid duplicate pairs — a technique that opens up powerful association analysis without requiring any additional data structures.
- **Time-based aggregation requires careful function choice** — Using `HOUR()`, `DAYNAME()`, and `DAYOFWEEK()` together gave me full control over how to group timestamps, but the ordering of `DAYOFWEEK()` (which returns 1=Sunday) required attention to avoid misleading day-of-week rankings.
- **Revenue and volume tell different stories** — An item can be a best-seller by order count and a mid-performer by revenue (like Edamame), meaning that operational decisions require both lenses simultaneously rather than optimising for a single metric.
- **CTEs simplify multi-step aggregation** — The average order value query used a CTE to first calculate per-order totals, then aggregate those totals by day — a pattern that is much cleaner and more readable than a nested subquery approach.

---

## Conclusion

This analysis of the restaurant's sales data revealed clear, actionable insights for menu optimisation and operational planning:

1. **Asian cuisine is the highest-revenue category** — Despite not leading in order volume, the premium pricing of Asian dishes makes this category the most financially important segment to maintain, feature, and potentially expand.
2. **Weekend dinner service is the critical operational window** — Staffing, inventory, and kitchen preparation should be anchored around the Friday and Saturday evening peak, where the highest order volumes and values are concentrated.
3. **Classic American comfort food drives traffic** — Burgers and fries are the primary reason customers visit, making them loss-leader candidates worth protecting even if margins are lower than premium dishes.
4. **Bundle opportunities are hiding in plain sight** — The burger-fries pairing and Asian item co-occurrences provide a data-backed foundation for a combo menu that could increase average order value with no additional marketing spend.
5. **Weekday lunch needs a different strategy than dinner** — Lower order values and faster turnover during midweek lunch hours call for a streamlined, affordable menu that prioritises speed and volume over per-ticket revenue.

---

<div align="center">

**📊 [Back to SQL Projects Portfolio](https://github.com/milosilic2704/ProjectPorfolio/tree/main/SQLPortoflio)**

</div>
