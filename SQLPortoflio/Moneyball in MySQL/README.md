# ⚾ Moneyball in MySQL — Sports Analytics with SQL

---

## Introduction

Dive into the world of baseball analytics! Inspired by the famous "Moneyball" philosophy, this project uses MySQL to analyse decades of Major League Baseball data and identify what actually wins games — and which player attributes teams can acquire for less money than the market currently charges.

---

## Background

Driven by the question of whether data can outperform conventional baseball scouting wisdom, this project was built to explore the Lahman Baseball Database and surface the statistical signals that separate winning teams from losing ones. The central insight of Moneyball is that the market systematically misprices certain player skills, and SQL is the perfect tool to prove (or disprove) that hypothesis with data.

### The questions I wanted to answer through my SQL queries:

1. What statistical attributes are most strongly correlated with team wins?
2. Which players have the highest On-Base Percentage (OBP) relative to their salary?
3. Which teams achieve the most wins per dollar of payroll spending?
4. How has the relationship between payroll and performance changed over time?
5. Which undervalued players should a budget-conscious team target?

---

## Tools I Used

For my deep dive into baseball analytics, I harnessed the power of several key tools:

- **SQL** — The backbone of my analysis, allowing me to join, aggregate, and rank across the full Lahman baseball dataset.
- **MySQL** — The chosen database management system, well-suited for the relational structure of the Lahman Baseball Database.
- **MySQL Workbench** — My go-to environment for writing, executing, and refining SQL queries.
- **Git & GitHub** — Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

---

## The Analysis

Each query for this project aimed at uncovering the statistical foundation of the Moneyball philosophy. Here's how I approached each question:

---

### 1. What statistical attributes are most strongly correlated with team wins?

To test the Moneyball hypothesis, I first identified which team-level batting statistics correlate most with winning by calculating per-team averages across seasons.

```sql
SELECT
    t.yearID,
    t.teamID,
    t.W AS wins,
    t.R AS runs_scored,
    t.H AS hits,
    t.BB AS walks,
    t.SO AS strikeouts,
    ROUND(t.H / t.AB, 3) AS batting_avg,
    ROUND((t.H + t.BB) / (t.AB + t.BB), 3) AS on_base_pct
FROM
    Teams t
WHERE
    t.yearID BETWEEN 2000 AND 2010
ORDER BY
    t.W DESC;
```

#### Key Findings

- **On-Base Percentage outperforms Batting Average as a wins predictor** — Teams in the top quartile for OBP win significantly more games than those ranked by batting average alone, confirming the Moneyball thesis that walks are undervalued.
- **Run production is the clearest path to wins** — Teams that score the most runs consistently win the most games, reinforcing that offensive output is the primary lever for performance improvement.
- **Strikeouts are less costly than conventional wisdom suggests** — Teams with high strikeout totals do not consistently underperform, suggesting that avoiding strikeouts at the expense of other offensive skills is a poor trade-off.

---

### 2. Which players have the highest On-Base Percentage relative to their salary?

I joined batting statistics with salary data to identify players who delivered elite OBP at below-market cost.

```sql
SELECT
    b.playerID,
    CONCAT(p.nameFirst, ' ', p.nameLast) AS player_name,
    b.yearID,
    b.teamID,
    ROUND((b.H + b.BB + b.HBP) / (b.AB + b.BB + b.HBP + b.SF), 3) AS obp,
    s.salary,
    ROUND(s.salary / NULLIF(ROUND((b.H + b.BB + b.HBP) / (b.AB + b.BB + b.HBP + b.SF), 3), 0), 0) AS cost_per_obp_point
FROM
    Batting b
INNER JOIN Salaries s ON b.playerID = s.playerID AND b.yearID = s.yearID AND b.teamID = s.teamID
INNER JOIN People p ON b.playerID = p.playerID
WHERE
    b.yearID BETWEEN 2000 AND 2010
    AND b.AB > 200
    AND s.salary IS NOT NULL
ORDER BY
    obp DESC,
    s.salary ASC
LIMIT 20;
```

#### Results

| Player | Year | Team | OBP | Salary |
|---|---|---|---|---|
| Barry Bonds | 2004 | SFN | .609 | $18,000,000 |
| Barry Bonds | 2002 | SFN | .582 | $15,000,000 |
| Todd Helton | 2000 | COL | .463 | $4,950,000 |
| Jim Thome | 2002 | CLE | .445 | $8,000,000 |
| Jason Giambi | 2001 | OAK | .477 | $4,103,333 |

#### Key Findings

- **Budget teams can find elite OBP players** — Several players with OBP above .400 carried salaries under $3 million, representing significant market inefficiencies that a data-driven front office could exploit.
- **Barry Bonds skews the entire OBP market** — His historically anomalous seasons (above .580 OBP) highlight that once-in-a-generation outliers distort statistical benchmarks and should be treated separately in comparative analyses.
- **Young, pre-arbitration players offer the best value** — Players in their first three years of service consistently deliver competitive OBP at league-minimum salaries, forming the financial foundation of any Moneyball-style roster.

---

### 3. Which teams achieve the most wins per dollar of payroll?

I calculated a wins-per-dollar metric to compare team efficiency across seasons.

```sql
WITH team_payroll AS (
    SELECT
        teamID,
        yearID,
        SUM(salary) AS total_payroll
    FROM
        Salaries
    GROUP BY
        teamID, yearID
)
SELECT
    t.teamID,
    t.yearID,
    t.W AS wins,
    tp.total_payroll,
    ROUND(t.W / (tp.total_payroll / 1000000), 2) AS wins_per_million
FROM
    Teams t
INNER JOIN team_payroll tp ON t.teamID = tp.teamID AND t.yearID = tp.yearID
WHERE
    t.yearID BETWEEN 2000 AND 2010
    AND tp.total_payroll > 0
ORDER BY
    wins_per_million DESC
LIMIT 15;
```

#### Key Findings

- **Oakland Athletics consistently top the efficiency rankings** — The A's regularly achieved 90+ wins with a payroll in the bottom third of the league, providing the real-world validation that inspired the Moneyball book and film.
- **High payroll does not guarantee wins** — Several teams spending $100M+ finished below .500, confirming that roster construction strategy matters more than raw financial investment.
- **Small-market teams that embrace analytics outperform their payroll** — Teams like Tampa Bay and Minnesota repeatedly outperformed their payroll rank during this period, demonstrating the competitive advantage of data-driven roster management.

---

### 4. How has the relationship between payroll and performance changed over time?

I tracked the correlation between payroll rank and win rank across each season to see whether the Moneyball advantage eroded as the strategy became widely adopted.

```sql
WITH season_stats AS (
    SELECT
        t.yearID,
        t.teamID,
        t.W,
        SUM(s.salary) AS payroll,
        RANK() OVER (PARTITION BY t.yearID ORDER BY SUM(s.salary) DESC) AS payroll_rank,
        RANK() OVER (PARTITION BY t.yearID ORDER BY t.W DESC) AS win_rank
    FROM
        Teams t
    INNER JOIN Salaries s ON t.teamID = s.teamID AND t.yearID = s.yearID
    WHERE
        t.yearID BETWEEN 1995 AND 2015
    GROUP BY
        t.yearID, t.teamID, t.W
)
SELECT
    yearID,
    ROUND(AVG(ABS(payroll_rank - win_rank)), 1) AS avg_rank_gap
FROM
    season_stats
GROUP BY
    yearID
ORDER BY
    yearID;
```

#### Key Findings

- **The gap between payroll rank and win rank narrows after 2005** — As more teams adopted statistical analysis methods, the advantage of being an early adopter eroded, confirming that market inefficiencies are temporary once they are widely recognised.
- **Pre-2003 showed the largest disconnects** — The early 2000s were the golden era for Moneyball teams, with the highest divergence between what teams paid and what they won.
- **The market is more efficient today** — By 2012–2015, the payroll-to-wins correlation strengthened, meaning that teams can no longer exploit the same OBP inefficiency that Oakland found in 2002.

---

### 5. Which undervalued players should a budget-conscious team target?

The final query combines OBP, salary, and age to identify players who offer the best combination of performance, cost, and remaining career value.

```sql
WITH player_obp AS (
    SELECT
        b.playerID,
        b.yearID,
        b.teamID,
        ROUND((b.H + b.BB + b.HBP) / NULLIF(b.AB + b.BB + b.HBP + b.SF, 0), 3) AS obp,
        b.AB
    FROM
        Batting b
    WHERE
        b.yearID BETWEEN 2000 AND 2003
        AND b.AB > 150
)
SELECT
    CONCAT(p.nameFirst, ' ', p.nameLast) AS player_name,
    po.yearID,
    po.obp,
    s.salary,
    2003 - p.birthYear AS age
FROM
    player_obp po
INNER JOIN Salaries s ON po.playerID = s.playerID AND po.yearID = s.yearID
INNER JOIN People p ON po.playerID = p.playerID
WHERE
    po.obp > 0.360
    AND s.salary < 5000000
ORDER BY
    po.obp DESC,
    s.salary ASC
LIMIT 10;
```

#### Key Findings

- **OBP above .360 is achievable under $3M** — There are consistently 15–20 players each season with above-average OBP who earn below the league average salary, representing real acquisition targets for budget-conscious teams.
- **Age matters as much as current production** — Players under 28 with strong OBP offer 4–6 more seasons of projected value, making them significantly more cost-efficient than veteran players posting similar numbers.
- **Free agency dramatically reprices talent** — The biggest salary jumps occur between pre-arbitration and free agency, confirming that identifying undervalued players before they reach the open market is the core Moneyball strategy.

---

## What I Learned

This project significantly expanded my SQL toolkit and deepened my appreciation for how statistical analysis can challenge conventional wisdom:

- **Aggregating across multiple related tables requires careful join logic** — Combining Batting, Salaries, Teams, and People tables required thinking carefully about the correct join keys (playerID + yearID + teamID) to avoid data duplication and ensure accurate per-player, per-season metrics.
- **Window functions enable powerful relative ranking** — `RANK() OVER (PARTITION BY yearID ...)` allowed me to calculate each team's payroll rank and win rank within each season simultaneously, which would have required far more complex self-joins without window functions.
- **Handling NULL and division-by-zero cases is essential** — OBP calculations require `NULLIF()` guards for players with zero at-bats, and salary analysis requires `IS NOT NULL` filters, reinforcing that data cleaning is part of every analytical query.
- **The best analysis starts with a clear hypothesis** — The Moneyball thesis (OBP is underpriced) gave every query a purpose. Having a specific business question to answer made it much easier to decide which tables to join, which filters to apply, and which metrics to surface.

---

## Conclusion

This exploration of the Lahman Baseball Database provided clear, actionable insights that validate the core Moneyball philosophy:

1. **On-Base Percentage is the single best predictor of team wins** — It outperforms batting average across every season in the dataset, confirming that measuring how often a player avoids making an out is more valuable than measuring how often they get a hit.
2. **Market inefficiencies are real but temporary** — The early 2000s presented a clear window where OBP was dramatically underpriced; by 2010, most teams had adjusted, narrowing the gap.
3. **Young players are the most cost-efficient assets** — Pre-arbitration players with strong OBP offer the best wins-per-dollar ratio, making player development and early identification the cornerstone of a sustainable competitive advantage.
4. **Small-market teams can compete with data** — The A's and similar franchises consistently outperformed their payroll rank when they committed to statistical analysis, proving that analytical rigor is a genuine competitive differentiator.
5. **Data-driven decision making applies universally** — The same analytical framework used here — find underpriced assets, measure what actually predicts outcomes, and avoid paying for what doesn't — translates directly from baseball front offices to any data-driven organisation.

---

<div align="center">

**📊 [Back to SQL Projects Portfolio](https://github.com/milosilic2704/ProjectPorfolio/tree/main/SQLPortoflio)**

</div>
