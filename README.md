# Airbnb NYC Data Analysis
Built an end-to-end data analytics project using 102K+ NYC Airbnb listings, covering the complete analytics workflow from raw data to business insights. Cleaned and validated the dataset using Python/Pandas, performed business-focused analysis in MySQL, and developed an interactive Power BI dashboard to identify pricing patterns, availability trends, and listing characteristics. Concluded the analysis with a business insights report translating data findings into actionable conclusions.

## Table of Contents
- Project Overview
- Tech Stack
- Pipeline
- Repository Structure
- Data Cleaning Summary
- SQL Business Questions
- Key Findings
- Recommendations
- Dashboard
- Limitations
- How to Reproduce

## Project Overview
### Project Overview

This project analyzes the **NYC Airbnb Open Data** dataset through an end-to-end data analytics workflow. The raw dataset contained **102,599 rows and 26 columns**. After cleaning, validation, and removal of irrelevant or unreliable fields, the dataset was reduced to **102,036 rows and 22 columns**.

The cleaned data was loaded into **MySQL**, using a database named `project_airbnb` and a table named `airbnb_listings`, where business-focused SQL analysis was performed.

The objective was to simulate a **real-world data analyst workflow**, not simply clean the data and create visualizations, but validate whether each metric actually represented what it appeared to measure before using it to draw conclusions or report business insights.

## Tech Stack

1. **Python (Pandas, NumPy)** - Data profiling, transformation, cleaning, and validation
2. **MySQL** - Database schema design, data loading, and business-focused SQL analysis
3. **Power BI** - Three-page interactive dashboard and data visualization
4. **Jupyter Notebook** - Documented data-cleaning workflow and analytical process 

## Pipeline

The project follows a four-phase analytics pipeline, with each phase building on the output of the previous one.

**Phase 1 - Data Cleaning & Validation**
The raw CSV dataset containing **102,599 rows** is profiled and cleaned using **Pandas**. The process includes correcting data types, handling missing values, standardizing inconsistent entries, removing duplicates, and filtering invalid records. This results in a final cleaned dataset of **102,036 rows**.

**Phase 2 - SQL Analysis**
The cleaned dataset is loaded into **MySQL**, where **10 business questions** are investigated using SQL. The analysis uses aggregations, **CTEs, window functions**, and other SQL techniques to identify meaningful patterns and relationships in the data.

**Phase 3 - Power BI Dashboard**
Power BI connects to the MySQL database and transforms the analytical results into a **three-page interactive dashboard**, allowing users to explore key metrics and findings through filters and visualizations.

**Phase 4 - Business Reporting**
The final phase brings the analysis together in a **business insights report**, translating the analytical findings into clear conclusions and explaining their practical implications.

## Repository Structure

- data
  - raw - original Airbnb Open Data CSV
  - cleaned - cleaned dataset, 102,036 rows
- sql
  - airbnb_analysis.sql - schema, table creation, and all 10 business questions
- dashboard
  - airbnb_dashboard.pbix
  - screenshots
- reports
  - business_report.pdf
  - presentation.pptx
- docs
  - data_dictionary.md
  - findings.md
  - data_cleaning_log.md
- .gitignore

## Data Cleaning Summary

Full details are in docs/findings.md and docs/data_cleaning_log.md.  

**Summary of what was done:**

- price and service_fee were stored as text with dollar signs and commas - stripped and converted to numeric
- last_review was stored as plain text - converted to a proper date format so it could be sorted and filtered
- NAME, host_name, and cancellation_policy had missing values - filled with "Unknown"
- price, service_fee, and construction_year had missing values - filled with the mean, since these were fairly evenly distributed
- minimum_nights, number_of_reviews, and calculated_host_listings_count had missing values - filled with the median instead of the mean, since these were skewed
- instant_bookable had missing values - filled with the mode, since it's a true/false field and "Unknown" isn't a valid state for it
- rows missing latitude or longitude were dropped entirely, since guessing coordinates would create fake locations
- missing values in last_review were left as-is on purpose - a blank just means the listing never got a review, so filling it in would be misleading
- minimum_nights had 13 rows with negative values - dropped
- availability_365 had 431 rows with negative values - capped at 0
- availability_365 had about 2,752 rows going above 365 - capped at 365
- one row had an availability value of 3,677 - dropped as an extreme outlier
- neighbourhood_group had typos like "brookln" and "manhatan" - standardized to correct borough names
- 541 exact duplicate rows were found and removed
- country and country_code had only one unique value across the whole dataset - dropped, no analytical value
- license was 99.998% missing - dropped
- house_rules was dropped - over half the values were missing, and the rest was unstructured free text not usable in SQL or Power BI

## SQL Business Questions

Answered using GROUP BY aggregation, RANK() / ROW_NUMBER() with PARTITION BY, and CTEs. Full queries in sql/airbnb_analysis.sql.

1. Which neighbourhood groups have the highest average prices?
2. Which room types generate the most listings?
3. Which areas have the highest review activity?
4. How does availability vary by neighbourhood?
5. Which hosts have the largest number of listings?
6. How does the cancellation policy relate to pricing?
7. What factors appear associated with higher prices?
8. Which neighbourhoods offer the best balance of price and reviews?
9. What percentage of listings are instant-bookable?
10. Which areas have the highest average availability?

## Key Findings 

1. **Engagement is not proportional to listing volume**  
Staten Island and Queens have the highest average reviews per listing despite having substantially fewer listings than Manhattan, which ranks lowest. This suggests that listing volume alone does not explain guest engagement. Lower competition may be one possible factor.

2. **Historical engagement does not necessarily indicate current demand**  
Staten Island has the highest average availability while also having the highest average reviews per listing. This suggests that highly reviewed listings may have accumulated strong historical engagement without necessarily experiencing high current occupancy or demand.

3. **The price field shows little evidence of real-world pricing behavior**  
An IQR-based outlier analysis identified zero price outliers, while the price percentiles appeared unusually uniform. Price also showed no meaningful relationship with room type, borough, cancellation policy, or guest rating. In one counterintuitive case, 1-star listings had higher prices than 5-star listings. Additionally, listings across different boroughs share the exact same maximum price of $1,200.00. Taken together, these patterns strongly suggest that the price field may be synthetically generated or unreliable for business analysis.

4. **Host concentration is inconsistent with the available host metrics**  
The dataset contains 102,035 unique host_id values across 102,036 listings, making the relationship between hosts and listings almost entirely one-to-one. This conflicts sharply with calculated_host_listings_count, which reports some hosts managing more than 300 listings. This inconsistency makes host-level analysis unreliable.

5. **Several categorical variables have unusually balanced distributions**  
instant_bookable, cancellation_policy, and host_identity_verified show distributions that are remarkably close to evenly split across their categories. While balanced distributions are not inherently invalid, seeing this pattern across several unrelated variables raises additional concerns about the authenticity and generation process of the dataset.





















