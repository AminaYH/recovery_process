#!/bin/bash

while true; do
    # Run add_to_tticketflights.sh 10 times
    for i in {1..10}; do
        echo "Running add_to_tticketflights.sh, iteration $i"
        ./add_to_tticketflights.sh
    done

    # Run add_to_tflights.sh 10 times
    for i in {1..10}; do
        echo "Running add_to_tflights.sh, iteration $i"
        ./add_to_tflights.sh
    done
done
