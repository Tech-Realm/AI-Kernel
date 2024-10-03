# Individual Thread Test

This project is designed to test individual threads running computational and I/O tasks. The `individual_thread_test.c` file contains code that creates multiple threads, performs computational tasks, and reads/writes from/to a file. The provided Bash script compiles the C code and saves the output to a log file.

## Prerequisites

Before running this script, ensure that the following tools and libraries are installed on your system:

- **GCC**: Ensure GCC is installed and supports multi-threading.
  - Installation (Ubuntu/Debian):
    ```bash
    sudo apt update
    sudo apt install gcc
    ```
- **POSIX Threads (`pthread`)**: Make sure the pthread library is available, as it is required for multi-threading support.
- **Math Library (`-lm`)**: Ensure the math library is linked during compilation for handling mathematical functions.

## Files

- **individual_thread_test.c**: The source code containing the individual thread test logic.
- **run_thread_tests.sh**: A Bash script to compile the C file and run the individual thread test, saving the output to a log file.

## Compilation & Execution

To compile and run the test, execute the provided `compile_and_run.sh` script. The script will:

1. Compile the `individual_thread_test.c` file with `gcc`.
2. Check if the compilation was successful.
3. Run the compiled program and save the output to a log file.

### Running the Script

```bash
./run_thread_tests.sh
