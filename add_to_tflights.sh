#!/bin/bash

# Database connection parameters
DB_NAME="demo"
DB_USER="amina"
DB_PORT="5434"
F_STATUS=('On Time' 'Delayed' 'Departed' 'Arrived' 'Scheduled' 'Cancelled')

while true; do
    # Generate random data
    flight_id=$(psql -U $DB_USER -d $DB_NAME -p $DB_PORT -t -c "SELECT COALESCE(MAX(flight_id), 0) + 1 FROM flights;")
    flight_no=$(printf "PG%04d" $((RANDOM % 10000)))
    scheduled_departure=$(date -d "$((RANDOM % 30 + 1)) days ago + $((RANDOM % 24)) hours" +"%Y-%m-%d %H:%M:%S%z")
    scheduled_arrival=$(date -d "$scheduled_departure + $((RANDOM % 5 + 1)) hours" +"%Y-%m-%d %H:%M:%S%z")
    departure_airport=$(psql -U $DB_USER -d $DB_NAME -p $DB_PORT -t -c "SELECT airport_code FROM airports_data WHERE length(airport_code) = 3 OFFSET floor(random() * (SELECT COUNT(*) FROM airports_data WHERE length(airport_code) = 3)) LIMIT 1;" | xargs)
    arrival_airport=$(psql -U $DB_USER -d $DB_NAME -p $DB_PORT -t -c "SELECT airport_code FROM airports_data WHERE airport_code <> '$departure_airport' AND length(airport_code) = 3 OFFSET floor(random() * (SELECT COUNT(*) FROM airports_data WHERE airport_code <> '$departure_airport' AND length(airport_code) = 3)) LIMIT 1;" | xargs)
    status=${F_STATUS[$RANDOM % ${#F_STATUS[@]}]}
    aircraft_code=$(psql -U $DB_USER -d $DB_NAME -p $DB_PORT -t -c "SELECT aircraft_code FROM aircrafts_data WHERE length(aircraft_code) = 3 OFFSET floor(random() * (SELECT COUNT(*) FROM aircrafts_data WHERE length(aircraft_code) = 3)) LIMIT 1;" | xargs)

    # Insert random data into the flights table
    psql -U $DB_USER -d $DB_NAME -p $DB_PORT -c "
    INSERT INTO flights (flight_id, flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, status, aircraft_code, actual_departure, actual_arrival)
    VALUES
        ($flight_id, '$flight_no', '$scheduled_departure', '$scheduled_arrival', '$departure_airport', '$arrival_airport', '$status', '$aircraft_code', NULL, NULL);
    "

    echo "Inserted flight with ID: $flight_id"

    # Sleep for a specified interval before inserting the next row
    sleep 1
done
