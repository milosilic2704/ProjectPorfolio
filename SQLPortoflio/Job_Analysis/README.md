# Data Job Market Analysis — SQL Project

## Introduction

Dive into the data job market! Focusing on data analyst roles, this project explores **top-paying jobs**, **in-demand skills**, and **where high demand meets high salary** in data analytics.

SQL queries? Check them out here: [project_sql/](https://github.com/milosilic2704/ProjectPorfolio/tree/main/SQLPortoflio/Job_Analysis/SQL_queries)

---

## Background

Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint **top-paid** and **in-demand skills**, streamlining the search for optimal jobs.

Data hails from the [SQL Course](https://lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

---

## Tools I Used

For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL** — The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL** — The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code** — My go-to for database management and executing SQL queries.
- **Git & GitHub** — Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

---

## The Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

---

### 1. What are the top-paying data analyst jobs?

To identify the highest-paying roles, I filtered data analyst positions available remotely, focusing on job postings with specified salaries.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

#### Results

| Job Title | Company | Avg Yearly Salary |
|---|---|---|
| Associate Director- Data Insights | AT&T | $255,830 |
| Data Analyst, Marketing | Pinterest | $232,423 |
| Data Analyst (Hybrid/Remote) | UCLA Healthcare | $217,000 |
| Principal Data Analyst (Remote) | SmartAsset | $205,000 |
| Director, Data Analyst - HYBRID | Inclusively | $189,309 |
| Principal Data Analyst, AV Performance Analysis | Motional | $189,000 |
| Principal Data Analyst | SmartAsset | $186,000 |
| ERM Data Analyst | Get It Recruit – IT | $184,000 |

<img width="1783" height="1033" alt="image" src="https://github.com/user-attachments/assets/38187466-b58f-4ff0-bf09-dfb1285ff9c1" />


#### Key Findings

- **Wide salary range** — Top remote data analyst roles span from $184,000 to $255,830, showing significant variation even within the top tier.
- **Big-name companies dominate** — AT&T, Pinterest, and SmartAsset are among the top payers, signalling that established tech-adjacent firms value senior analytical talent highly.
- **Senior and director roles earn the most** — Titles like "Associate Director," "Principal," and "Director" command the highest salaries, confirming that experience and scope of ownership are the primary salary drivers.

---

### 2. What skills are required for these top-paying jobs?

I joined the top-paying jobs query with skills data to understand what competencies employers demand at the highest compensation levels.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

<img width="1634" height="883" alt="image" src="https://github.com/user-attachments/assets/481d263d-b54f-4b39-8140-f49186c2bb47" />


#### Key Findings

- **SQL is the undisputed foundation** — It appears in 8 out of the top 10 highest-paying job postings, confirming that relational database querying is non-negotiable at the elite level.
- **Python is a close second** — Required by 7 of the roles, Python is firmly established as the programming language of choice for senior analysts.
- **Tableau leads for visualisation** — Requested in 6 of the roles, Tableau edges out Power BI as the preferred BI tool for top-paying positions.

---

### 3. What skills are most in demand for data analysts?

This query counted how often each skill appeared across all remote data analyst postings, regardless of salary.

```sql
WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact ON skills_to_job.job_id = job_postings_fact.job_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.job_work_from_home = TRUE
    GROUP BY
        skill_id
)
SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM
    remote_job_skills
INNER JOIN skills_dim AS skills ON remote_job_skills.skill_id = skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;
```

#### Results

| Skill | Job Postings |
|---|---|
| SQL | 7,291 |
| Excel | 4,611 |
| Python | 4,330 |
| Tableau | 3,745 |
| Power BI | 2,609 |

<img width="1333" height="733" alt="image" src="https://github.com/user-attachments/assets/27dd9660-4147-4bfe-a86d-bf3353626290" />


#### Key Findings

- **SQL reigns supreme** — With 7,291 postings, SQL appears nearly 60% more often than the second-place skill (Excel), reinforcing it as the single most essential skill for any data analyst.
- **Traditional vs. modern tools coexist** — Excel (4,611) and Python (4,330) are neck and neck, reflecting the industry's parallel reliance on accessible spreadsheet tools and advanced programming languages.
- **Visualisation is a battlefield** — Tableau (3,745) leads Power BI (2,609) by a significant margin, though both are heavily sought after across the job market.

---

### 4. Which skills are associated with higher salaries?

I looked at the average salary tied to each skill for remote data analyst roles with specified salaries.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```

#### Top 10 Results

| Skill | Avg Yearly Salary |
|---|---|
| PySpark | $208,172 |
| Bitbucket | $189,155 |
| Couchbase | $160,515 |
| Watson | $160,515 |
| DataRobot | $155,486 |
| GitLab | $154,500 |
| Swift | $153,750 |
| Jupyter | $152,777 |
| Pandas | $151,821 |
| Elasticsearch | $145,000 |

<img width="1333" height="733" alt="image" src="https://github.com/user-attachments/assets/dd02c273-80d1-48df-9105-93b2ba6e81c1" />


#### Key Findings

- **Big Data & AI command a premium** — The highest salaries are reserved for analysts working with distributed computing tools (PySpark at ~$208K) and enterprise AI/ML platforms (Watson, DataRobot), reflecting the value of handling massive datasets and predictive modelling.
- **The rise of the "Data Engineer" analyst** — Top-paying roles blur the line between analysis and DevOps. Companies pay heavily for analysts who can deploy pipelines and manage infrastructure using version control (Bitbucket, GitLab) and orchestration tools (Kubernetes, Airflow).
- **Specialised databases out-earn standard SQL** — While standard SQL is the most *demanded* skill, knowing how to work with specialised NoSQL and search databases (Couchbase, Elasticsearch at $145K+) significantly boosts compensation over traditional relational databases.

---

### 5. What are the most optimal skills to learn?

The final query combined demand and salary data to identify skills that offer both job security and strong financial returns — the sweet spot for career development.

```sql
WITH skills_demand AS (
    SELECT
        skills_job_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id,
        skills_dim.skills
),
average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 2) AS avg_salary
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id
)
SELECT
    skill_demand.skill_id,
    skill_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand AS skill_demand
INNER JOIN average_salary AS skill_salary ON skill_demand.skill_id = skill_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

<img width="1774" height="1034" alt="image" src="https://github.com/user-attachments/assets/789596d9-9d48-459e-8194-2fcc9867e535" />


#### Key Findings

- **Python and Tableau are the sweet-spot skills** — With 236 and 230 postings respectively and average salaries above $99K, they sit at the intersection of high demand and strong pay — making them the most strategic skills to invest in.
- **Cloud platforms are highly rewarding** — Snowflake (37 postings, ~$113K), Azure (34, ~$111K), and AWS (32, ~$108K) stand out as cloud skills that offer both solid demand and above-average salaries.
- **Looker is an underrated gem** — With 49 postings and ~$104K average salary, Looker offers a compelling demand-to-pay ratio that many analysts overlook in favour of the more widely known Tableau and Power BI.

---

## What I Learned

This project significantly expanded my SQL toolkit and sharpened my ability to draw real-world insights from data:

- **Advanced query composition** — I built complex, multi-CTE queries that join across several tables and aggregate data at scale. Writing readable, well-structured SQL became a core focus throughout.
- **Data aggregation mastery** — Functions like `COUNT()`, `AVG()`, and `ROUND()`, combined with `GROUP BY` and `HAVING`, became my go-to tools for distilling thousands of records into actionable summaries.
- **Translating questions into queries** — The most valuable skill gained was the ability to take a business question ("what skills are worth learning?") and systematically decompose it into precise SQL logic — filtering, joining, and sorting to surface the right answer.
- **Insight-driven thinking** — Quantitative results only tell part of the story. I practised interpreting numbers in context, identifying patterns (e.g., the gap between demanded skills and highest-paying skills) that would directly inform career decisions.

---

## Conclusion

This exploration of the data analyst job market revealed clear, actionable insights for anyone looking to break in or level up:

1. **SQL is non-negotiable** — It is the single most demanded skill and appears in virtually every top-paying job. Mastering it is the baseline.
2. **Python unlocks the upper tier** — Paired with SQL, Python dramatically expands what you can do analytically and is required by the majority of the highest-paying roles.
3. **Visualisation matters** — Tableau and Power BI both feature prominently across demand and salary data. At least one of these should be in every analyst's toolkit.
4. **Cloud and big data skills pay a premium** — If you want to move into the top salary bracket, skills like Snowflake, Azure, AWS, and PySpark offer the strongest return on learning investment.
5. **Optimal = High Demand + High Salary** — The sweet-spot skills (Python, Tableau, cloud platforms) are where job security and financial reward overlap. Focusing your learning here provides the strongest long-term career trajectory.

This project reinforced that data-driven decision-making applies just as well to navigating your own career as it does to any business problem. The numbers point clearly at where to invest your time.

