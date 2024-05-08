# Python:
## Bike Sharing Data Integration and Cleaning Project

### Introduction:
This project focuses on integrating and cleaning data from multiple CSV files obtained from a bike sharing service. The aim is to create a unified dataset that can be used for further analysis and insights generation. The dataset consists of information regarding bike trips, including start and end times, stations, and geographical coordinates.

### Objectives:
1. Merge multiple CSV files containing bike sharing data into a single DataFrame.
2. Perform data cleaning to handle missing values and duplicates.
3. Convert data types and standardize the format for consistency.
4. Save the cleaned dataset for future analysis and modeling.

### Methodology:
1. **Data Collection**: The CSV files containing bike sharing data are obtained from the bike sharing service's database.
2. **Data Integration**: The Pandas library in Python is utilized to merge all CSV files into a single DataFrame using the `pd.concat()` function, ensuring that no data is lost during the merging process.
3. **Data Cleaning**:
   - **Null Value Handling**: Missing values in the dataset are identified and addressed using the `fillna()` method. Object-type columns such as station names and IDs are filled with "not specified", while float-type columns such as geographical coordinates are filled with a placeholder value (-999).
   - **Duplicate Detection**: Duplicate rows in the dataset are identified and removed using the `duplicated()` method.
4. **Data Transformation**: Date and time columns are converted to datetime format using the `pd.to_datetime()` function for consistency and ease of analysis.
5. **Data Export**: The cleaned and integrated dataset is saved as a new CSV file named "merged_data.csv" using the `to_csv()` method.

### Results:
- The integration process successfully merged 12 CSV files, each containing over 1.7 million rows, into a single DataFrame.
- Data cleaning operations addressed missing values and removed duplicate rows, ensuring the quality and integrity of the dataset.
- The cleaned dataset is ready for exploratory data analysis, modeling, and generating insights into bike sharing patterns and trends.


# SQL:
## Cyclistic Bike Usage Analysis Project Overview

### Introduction:
This project delves into understanding the disparities in bike usage patterns between annual members and casual riders of Cyclistic, a bike-sharing service. By analyzing a large dataset of bike ride records, the aim is to uncover insights that can inform marketing strategies, service improvements, and operational decisions tailored to each rider segment.

### Objective:
The primary objective of this analysis is to discern how annual members and casual riders utilize Cyclistic bikes differently. This involves investigating various aspects such as ride frequency, preferred ride types, ride durations, and temporal patterns.

### Methodology:
The analysis is conducted using SQL queries on a dataset stored in a PostgreSQL database. The dataset consists of ride records containing information such as ride ID, rideable type, start and end timestamps, rider type (annual member or casual), and ride duration.

### Data Preparation:
1. **Data Import:** The dataset is imported into a PostgreSQL database table named "cyclist" using the `COPY` command.
2. **Data Transformation:** Additional columns are added to the dataset to facilitate analysis, including extracting month, weekday, ride length, and time of day from the timestamp columns using SQL functions such as `TO_CHAR()` and `EXTRACT()`.
3. **Data Cleaning:** Null values are checked and consistent values are ensured for categorical variables such as rideable type and rider type.

### Analysis:
The analysis is divided into several sections to comprehensively explore the differences in bike usage between annual members and casual riders.

1. **General Overview:**
   - Breakdown of ride counts by rider type and rideable type.
   - Average ride length for each rider type and rideable type.

2. **Total Number of Rides:**
   - Analysis of ride counts by months, weekdays, and time of day for each rider type and rideable type.

3. **Average Ride Lengths:**
   - Comparison of average ride lengths across months, weekdays, and time of day for each rider type and rideable type.

### Results:
- **General Overview:**
  - Electric bikes are the most popular among both rider types, followed by classic bikes. Docked bikes have the least usage.
  - Casual riders tend to have longer average ride lengths compared to annual members.
  
- **Total Number of Rides:**
  - Annual members predominantly ride on weekdays, particularly during mornings and afternoons, suggesting commuting patterns.
  - Casual riders show a preference for weekend rides, with longer durations, especially in the afternoons.

- **Average Ride Lengths:**
Annual members tend to take shorter rides, suggesting they use the bikes for practical purposes like commuting. On the other hand, casual riders prefer longer rides, especially during weekends and evenings, indicating they use the service more for leisurely activities.

### Conclusion:
Through SQL-based analysis of Cyclistic bike ride data, this project reveals distinct usage patterns between annual members and casual riders. Annual members primarily use the service for commuting purposes, favoring shorter rides during weekdays. In contrast, casual riders opt for longer, leisurely rides, particularly on weekends and evenings. These findings can inform targeted marketing campaigns, service improvements, and resource allocation strategies to better cater to the diverse needs of Cyclistic's rider base.
