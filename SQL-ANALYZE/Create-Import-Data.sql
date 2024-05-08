CREATE TABLE cyclist (
    ride_id VARCHAR(50) PRIMARY KEY NOT NULL, 
    rideable_type VARCHAR(50), 
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    start_station_name TEXT, 
    start_station_id TEXT, 
    end_station_name TEXT, 
    end_station_id TEXT, 
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50) 
);


COPY cyclist
FROM 'D:\MY-DATA\Profession- Stage2\PROFESSIONAL-CERTIFICATES-GOOGLE\GOOGLE\GOOGLE-DATA-ANALYST\google-cyclist\CYCLIST\merged_data.csv'
delimiter ','
ENCODING 'UTF8'
CSV header;