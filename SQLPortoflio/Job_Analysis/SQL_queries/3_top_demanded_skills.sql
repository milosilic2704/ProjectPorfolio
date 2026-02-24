/*
? Questions to Answer
1. What are the top-paying jobs for my role?
2. What are the skills required for these top-paying roles?
3. What are the most in-demand skills for my role?
4. What are the top skills based on salary for my role?
5. What are the most optimal skills to learn?
    a. Optimal: High Demand AND High Paying
*/

WITH remote_job_skills AS(
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



/*
Here is the analysis and insights based on the JSON dataset you provided:

1. SQL is the Undisputed King
SQL dominates the list by a massive margin with 7,291 postings.

It appears nearly 60% more often than the second-place skill (Excel). This strongly reinforces that, regardless of how advanced tools get, relational databases and the ability to query them remain the most essential requirement for data professionals.

2. Traditional vs. Modern Programming
Excel holds strong in second place with 4,611 mentions, proving that spreadsheet software is still a cornerstone of business operations and data analysis worldwide.

Python is right behind it with 4,330 mentions. The closeness of these two numbers shows the ongoing transition in the industry: while advanced programming languages (Python) are highly sought after for automation and advanced analytics, traditional, accessible spreadsheet tools (Excel) are still just as practically relevant.

3. The Visualization Battle: Tableau vs. Power BI
For business intelligence and data visualization, two major players are highlighted:

Tableau leads the visualization category with 3,745 mentions.

Power BI follows with 2,609 mentions.

This indicates that while both are heavily utilized, Tableau appears to have a stronger foothold in this specific dataset's job market.
[
  {
    "skill_id": 0,
    "skill_name": "sql",
    "skill_count": "7291"
  },
  {
    "skill_id": 181,
    "skill_name": "excel",
    "skill_count": "4611"
  },
  {
    "skill_id": 1,
    "skill_name": "python",
    "skill_count": "4330"
  },
  {
    "skill_id": 182,
    "skill_name": "tableau",
    "skill_count": "3745"
  },
  {
    "skill_id": 183,
    "skill_name": "power bi",
    "skill_count": "2609"
  }
]
*/