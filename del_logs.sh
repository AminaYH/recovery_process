#!/bin/bash

log_dir="$HOME/pg/data/log"
max_size=$((100 * 1024 * 1024))

check_and_delete_logs() {
    for log_file in "$log_dir"/*.log; do
        if [ -f "$log_file" ]; then
            log_size=$(stat -c%s "$log_file")
            if [ "$log_size" -ge "$max_size" ]; then
                echo "Deleting $log_file (size: $log_size bytes)"
                rm -f "$log_file"
            fi
        fi
    done
}

# Call the function
check_and_delete_logs
