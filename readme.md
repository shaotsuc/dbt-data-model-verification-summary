# dbt Data Model - Verification Summary Analysis

## Table of Content
+ [Description](#Description)
+ [Task (Business Question Asked)](#Description)
+ [Tech Stack](#Tech-Stack)
+ [Database Schema](#Database-Schema)
+ [Tables](#Tables)
+ [Deliverables](#Deliverables)
    + [Thought Process](#Thought-Process)
    + [Data Models](./dbt/models/)
    + [Business Question Answered](#Business-Question-Answered)



## Description
Stakeholders need data to make informed decisions, but that data doesn't exist in a clean, accessible format. 

The task is to solve the problem of messy data. Taking raw data and preparing it for consumption by data analysts, data scientists, and decision makers through considerate, optimized data modeling.

<br>

## Task (Business Question Asked)
To design and implement a data model using dbt to optimize for analytics of verification sessions.

Below are the questions this model should be able to answer:
1. Which regions have the most declined sessions?
2. Which document types get resubmitted the most?
3. Which is the most popular industry in each region?

<br>

## Tech Stack
![Docker](./media/docker-icon.png)
![dbt](./media/dbt-icon.png)
![PostgresSQl](./media/postgresql-icon.png)

<br>

## Database Schema
![schema](./media/schema.png)

This schema represents raw data in the data warehouse. It contains data from our production database in the prod schema and data from our CRM in the CRM schema. 

We don't want to expose this data to our reporting tools because it is highly normalized and has not had any business logic applied to it.

<br>

### Tables

*verification_sessions*
> Each verification has a status of 
> + Approved 
> + Declined 
> + Resubmission


*documents*
>Three types of document are supported: 
> - Passport
> - Residence Permit
> - Drivers License

*countries*
> Countries that issue documents are grouped into regions that share some similar characteristics such as language. 
> 
> Regions are a slowly changing dimension. The region a country belongs to can change over time. 

*regions*
> This table contains a list of the regions that countries are group into. 

*employees*
> This table contains all the employees in the company, along with their roles.

*roles*
>This table contains a list of roles in the company. There are three roles: 
> - Verification Specialist
> - Region Lead
> - Account Manager


*clients*
> This table keeps track of all clients. It also contains information about the industry those clients operate in.

*accounts*
> It contains information about the clients and their account values. 
>
> Each client has an account manager who is an employee in the company.

*account_managers*
> This table contains information about account managers in our CRM. The employees are from the same company.

<br>

## Deliverables

### Thought Process {#Thought-Process}
I have created 3 folders in dbt to separate the data models to be used: 
+ staging
    + stg_account
    + stg_account_manager
    + stg_client
    + stg_country
    + stg_document
    + stg_employee
    + stg_region
    + stg_role
    + stg_verification_session
+ dm
    + d_country_region
    + d_employee
    + f_client_account_summary
    + f_verification_overview
+ production
    + pd_client_verification_overview

The final table `dbt_production.pd_client_verification_overview` provides analytics on verification sessions and is optimized for use the BI platforms.

<br>

### Business Question Answered {#Business-Question-Answered}

<code> **Which regions have the most declined sessions?** </code>
```sql
SELECT
    region_name,
    SUM(declined_cnt) AS declined_cnt
FROM dbt_production.pd_client_verification_overview 
GROUP BY 
    region_name
ORDER BY 
    declined_cnt DESC
```
|   | region_name *text* | declined_cnt *numeric* |
| - | ---------------- | --------------------: |
| 1 | north_hemisphere | 120                  |
| 2 | oceania          | 59                   |
| 3 | tropical         | 30                   |
| 4 | arctic           | 22                   |

<br>

<code> **Which document types get resubmitted the most?** </code>
```sql
SELECT
       document_type,
    SUM(resubmission_cnt) AS resubmission_cnt 
FROM dbt_production.pd_client_verification_overview 
GROUP BY 
    document_type
ORDER BY 
    resubmission_cnt DESC
```
|   | document_type *text* | resubmission_cnt *numeric* |
| - | --------------------- | ------------------------: |
| 1 | PASSPORT              | 302                      |
| 2 | DRIVERS_LICENSE       | 247                      |
| 3 | RESIDENCE_PERMIT      | 193                      |

<br>

<code> **Which is the most popular industry in each region?** </code>
```sql
WITH ranking AS ( 
    SELECT
        region_name,
        client_industry,
        verification_session_cnt,
        RANK() OVER (PARTITION BY region_name ORDER BY verification_session_cnt DESC) AS rank_nr
    FROM ( 
        SELECT 
            region_name,
            client_industry,
            SUM(verification_session_cnt) AS verification_session_cnt
        FROM dbt_production.pd_client_verification_overview
        GROUP BY 
            region_name, 
            client_industry
    ) AS t1
)
SELECT *
FROM ranking 
WHERE rank_nr = 1
```
|   | region_name *text* | client_industry *text* | verification_session_cnt *numeric* |
| - | ---------------- | -------------------- | --------------------------------: |
| 1 | arctic           | FINTECH              | 130                              |
| 2 | north_hemisphere | FINTECH              | 523                              |
| 3 | oceania          | FINTECH              | 273                              |
| 4 | tropical         | FINTECH              | 195                              |