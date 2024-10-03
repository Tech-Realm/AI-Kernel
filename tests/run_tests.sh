#!/bin/bash

echo "Compiling ai_driver_test.c..."
gcc -Wall -pthread -o ai_driver_test ai_driver_test.c -lm

if [ $? -ne 0 ]; then
    echo "Compilation failed."
    exit 1
fi

echo "Running the stress test..."
sudo ./ai_driver_test > ../logs/test_output.txt

echo "Stress test completed. Output saved to ../logs/test_output.txt"
