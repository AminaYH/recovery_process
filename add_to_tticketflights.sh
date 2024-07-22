#!/bin/bash

# Database connection parameters
DB_NAME="demo"
DB_USER="amina"
DB_PORT="5434"
F_STATUS=('Economy' 'Comfort' 'Business')

while true; do
    # Generate random data
    ticket_no=$(psql -U $DB_USER -d $DB_NAME -p $DB_PORT -t -c "SELECT TRIM(ticket_no::CHAR(13)) AS ticket_no_char13 FROM tickets ORDER BY RANDOM() LIMIT 1;" | xargs)

    flight_id=$(psql -U $DB_USER -d $DB_NAME -p $DB_PORT -t -c "SELECT flight_id FROM flights ORDER BY RANDOM() LIMIT 1;")
    fare_conditions=${F_STATUS[$RANDOM % ${#F_STATUS[@]}]}
    amount=$(printf "%.2f" $(echo "scale=2; $RANDOM*1000/32767" | bc))

    # Insert random data into the ticket_flights table
    psql -U $DB_USER -d $DB_NAME -p $DB_PORT -c "
    INSERT INTO ticket_flights (ticket_no, flight_id, fare_conditions, amount)
    VALUES ('$ticket_no', $flight_id, '$fare_conditions', $amount);
    "

    echo "Inserted ticket flight with Ticket No: $ticket_no"

    # Sleep for a specified interval before inserting the next row
    sleep 1
done
