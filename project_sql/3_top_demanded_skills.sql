/*
What are the most in-demand skills for data analysts in India?
Providing insights into most valuable skills for job seekers
*/

SELECT 
    skills,
    COUNT(job_postings_fact.job_id) AS job_count
FROM job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND job_country = 'India'
GROUP BY skills
ORDER BY job_count DESC
LIMIT 10

