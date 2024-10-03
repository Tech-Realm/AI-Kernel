#!/bin/bash

echo "Compiling individual_thread_test.c..."
gcc -Wall -pthread -o individual_thread_test individual_thread_test.c -lm

if [ $? -ne 0 ]; then
    echo "Compilation failed."
    exit 1
fi

echo "Running individual thread test..."
./individual_thread_test > ../logs/thread_test_output.txt

echo "Thread test completed. Output saved to ../logs/thread_test_output.txt"
