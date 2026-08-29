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


