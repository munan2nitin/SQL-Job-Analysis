/*
What are the most optimal skills to learn as a Data Analyst in India?
Those skills that are both high in demand and offer high pay.
*/



WITH skill_demand AS
(
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS job_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND job_country = 'India'
GROUP BY skills_dim.skill_id
),

skill_pay AS
(
SELECT
    skills_job_dim.skill_id,
    ROUND(AVG(salary_year_avg),0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
AND job_country = 'India'
GROUP BY skills_job_dim.skill_id
)

SELECT
skill_demand.skill_id,
skill_demand.skills,
job_count,
average_salary

FROM
skill_demand

INNER JOIN skill_pay on skill_demand.skill_id = skill_pay.skill_id

ORDER BY job_count DESC
