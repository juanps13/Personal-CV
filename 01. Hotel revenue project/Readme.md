# Hotel Revenue project

In this project, I analysed the dataset 'hotel_revenue' utilizing Excel, SQL and Power BI. All necessary files are available to enable the reproducibility of my analysis.

The original raw data is contained within the 'hotel_revenue_full.xlsx' file. The 'raw_data' folder contains CSV files with the data after the data preparation stage.

## Problem statement

1. Is the total hotel revenue growing by year?
2. Which is the most profitable market segment?
3. Which type of guests are staying in the hotel?

## Steps

1. Data preparation (Excel)
2. SQL
   - Database creation
   - Data cleaning
   - Data analysis
4. Dashboard creation (Power BI)
5. PPT presentation

## Data Preparation

1. Split the original .xlsx file into 5 separate .csv files
2. Replace the "NULL" and "NA" values with blank cells (using "replace" tool in Excel)
3. Replace commas (,) with periods (.) in all decimal numbers.
4. Format date columns as YYYY-MM-DD (using "format cell" tool)
5. Check which number columns in the files contain empty cells (this will be important when loading the data into the SQL database).

## SQL

The following files can be found in the SQL folder:
1. hotel_revenue_database_definition: Contains the script for defining the database.
2. hotel_revenue_data_load: Contains the script for loading data into the database (ensure you select the correct folder path for the raw data).
3. hotel_revenue_cleaning: Contains the data cleaning queries (that must be executed before the next stage).
4. hotel_revenue_working_querys: Contains the analysis queries.

Detailed explanations of the steps followed are provided within each file.

## Power BI Dashboard

Overview of the dashboard:

![alt text](05.%20images/dashboard.png)
![alt text](05.%20images/dashboard2.png)

### Tables Connections

The following connections were made.

![alt text](05.%20images/tables_connections.png)

\[Hotel_revenue market_segment](segment) -> \[Hotel_revenue revenue_total](market_segment)

\[Hotel_revenue meal_cost](meal) -> \[Hotel_revenue revenue_total](cost)

### Measures and calculated columns

The following measures and columns were created.

1. Measure - NetProfit

![alt text](05.%20images/measure_net_profit.png)

2. Column - Date

![alt text](05.%20images/column_date.png)

3. Column - NetProfit_column

![alt text](05.%20images/column_net_profit.png)

4. Column - total_nights

![alt text](05.%20images/column_total_nights.png)

5. Column - meal_cost

![alt text](05.%20images/column_meal_cost.png)

## PPT Presentation

![alt text](05.%20images/ppt1.png)
![alt text](05.%20images/ppt2.png)
![alt text](05.%20images/ppt3.png)
![alt text](05.%20images/ppt4.png)
![alt text](05.%20images/ppt5.png)
