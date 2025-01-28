# Introduction
Focusing on Data Analyst roles in India, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in Data Analytics. 

Check out the SQL Queries used here : [project_sql folder](/project_sql/)
# Background
Through this project, I wanted to get answers for the following questions:
1. What are the top-paying data analyst jobs?
2. What skills are required for this top-paying jobs?
3. What skills are most in demand for Data Analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

Data required for this project was acquired from [here.](https://lukabarousse.com/sql)
# Tools I Used
For this project, I utilised these following tools:
 - **SQL:** The backbone for this project, allowing me to query the database and unearth critical insights.
 - **PostgreSQL:** The chosen database management system, ideal for handling large datasets.
 - **Visual Studio Code:** Enables writing, running, and managing SQL queries and database connections within its editing environment.
 - **Git and Github:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on jobs in India. This query highlights the high paying opportunities in the field.

``` sql
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
```
**Here are some observations from the analysis:**

 - Wide Salary Range: The salaries range from $650,000 to $111,175 per year, indicating a significant variation in pay for Data Analysts in India.
 - Company Variation: The jobs are spread across different companies, including Mantys, ServiceNow, Srijan Technologies, Bosch Group, Eagle Genomics Ltd, Deutsche Bank, ACA Group, and Freshworks. This suggests that high-paying Data Analyst roles are available in various industries.

### 2. Skills required for these top paying jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

``` sql
WITH top_paying_jobs AS
(
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
LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
    FROM top_paying_jobs
    INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

ORDER BY salary_year_avg DESC;
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

SQL is leading and Python follows closely.
Tableau is also highly sought after. Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.

### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

``` sql

SELECT 
    skills,
    COUNT(job_postings_fact.job_id) AS job_count
FROM job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND job_country = 'India'
GROUP BY skills
ORDER BY job_count DESC
LIMIT 10;
```
Here's the breakdown of the most demanded skills for data analysts in 2023

SQL and Python remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation. Visualization Tools like Excel, Tableau, and Power BI are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

``` sql
SELECT
skills_dim.skills,
ROUND(AVG(salary_year_avg),0) AS average_salary

FROM job_postings_fact

LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
AND job_country = 'India'

GROUP BY skills_dim.skills

ORDER BY average_salary DESC

LIMIT 25;
```
- Big Data and Cloud: Skills related to big data technologies (PySpark, Databricks, Spark, Hadoop) and cloud platforms (Snowflake) are in high demand and command competitive salaries.
- Databases: Expertise in various database technologies (PostgreSQL, MySQL, Neo4j, MongoDB, NoSQL) is well-compensated.
- DevOps: Skills like GitLab and Linux are crucial for DevOps practices and are associated with high salaries.
- Data Science and Analysis: While still valuable, skills like Pandas, Matplotlib, and DAX might have slightly lower average salaries compared to big data and cloud technologies.
- General Tech Skills: Skills like Shell, Bash, and Electron are essential for various tech roles and have decent average salaries.

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

``` sql
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
    ROUND(AVG(salary_year_avg),0) AS Average_Salary
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
Average_Salary

FROM
skill_demand

INNER JOIN skill_pay on skill_demand.skill_id = skill_pay.skill_id

ORDER BY job_count DESC;
```
Key Insights:

- SQL Dominates: SQL is the most in-demand skill with 3167 job postings, indicating its continued importance in the data industry.
- Python is Highly Sought After: Python, known for its versatility in data science and machine learning, has a significant job market with 2207 postings and a competitive average salary.
- Data Visualization and Business Intelligence Tools are Popular: Tools like Tableau, Power BI, and Excel are in high demand, reflecting the growing need for data visualization and business intelligence capabilities.
- Cloud Computing Skills are Valuable: Cloud platforms like Azure, AWS, and GCP are increasingly important, and professionals with these skills are well-compensated.
- Big Data Technologies are Highly Paid: Skills like Spark, Hadoop, and Databricks command high salaries, indicating the strong demand for big data professionals.
- Data Science and Machine Learning Skills are Growing: Languages like R, Python, and libraries like PySpark, TensorFlow, and PyTorch are in demand, reflecting the rise of data science and machine learning.
- Business Skills are Valuable: Skills like PowerPoint, Excel, and Word are still in demand, highlighting the importance of communication and presentation skills in data-driven roles.


# What I learned

During this learning journey, I significantly improved my SQL skills.

- I learned to write complex queries: This includes joining multiple tables effectively and using advanced techniques like WITH clauses to create temporary tables for more efficient data manipulation.
- I gained proficiency in data aggregation: I learned how to use functions like COUNT() and AVG() with GROUP BY to summarize and analyze data effectively.
- I developed strong analytical skills: I learned to translate real-world questions and problems into actionable SQL queries to gain valuable insights from the data."


# Closing thoughts

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.

