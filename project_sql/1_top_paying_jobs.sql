/*
To Identify the top-paying Data Analyst Jobs
 - Identify top-10 highest paying Data Analyst jobs that are available in India
 - Focus on job postings with specified salary(Remove nulls)
 - Offer insights into top-paying opportunities for Data Analysts and finding optimal skills required for Data Analysts
 */

SELECT
    job_id,
    job_title,
    salary_year_avg,
    company_dim.name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_country = 'India' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;