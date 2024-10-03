# World's First AI Kernel

Welcome to the **World's First AI Kernel** project! This repository contains the source code, tests, and utilities needed to build, install, and run an AI-powered kernel that integrates advanced AI functionalities with the core system. This kernel enables AI-driven hardware optimizations, predictive maintenance, and performance improvements for modern computing environments.

The AI Kernel is designed to maximize system performance by leveraging artificial intelligence to adapt dynamically to workloads. This repository also includes automated tests to ensure the kernel performs optimally across all available CPU cores.

## Project Structure

The repository is organized as follows:

- **`Max_test/`**: This directory contains the primary AI kernel test, designed to push the kernel to its limits by running tests across all CPU cores.
  - **`ai_driver_test.c`**: The source code for testing AI kernel driver functionalities.
  - **`automated_testing.sh`**: A script to automate the testing process for the AI kernel.
  - **`Makefile`**: The build file for compiling the AI kernel driver.
  - **`README.md`**: Detailed information on how to compile and run the AI kernel driver test.
  - **`ai_kernel_driver.c`**: The core AI kernel driver code.
  - **`manage_ai_kernel_driver.sh`**: A script to manage (load/unload) the AI kernel driver.
  - **`tests/`**: Contains scripts and tests for the kernel.
    - **`run_tests.sh`**: Runs the standard tests for the AI kernel.
  - **`thread_tests/`**: Contains code and scripts to test individual threads and run the AI kernel across all available cores.
    - **`individual_thread_test.c`**: Source code to test individual threads.
    - **`run_thread_tests.sh`**: A script to run the individual thread tests.
    - **`readme.md`**: Detailed documentation on how to run the individual thread tests.

## Getting Started

### 1. Build and Install the AI Kernel

To build and install the AI kernel driver, follow the steps provided in the [AI Kernel Driver README](Max_test/README.md).

### 2. Run Kernel Driver Tests

Once the kernel driver is built, you can run the automated tests to verify that everything is functioning correctly. Check out the [Automated Testing README](Max_test/tests/README.md) for detailed instructions on running the tests.

### 3. Run Thread Tests

To test individual threads or run performance tests across all CPU cores, navigate to the `thread_tests/` directory. For more information, refer to the [Thread Tests README](Max_test/thread_tests/readme.md).

### 4. Max Test

The **Max Test** pushes the AI kernel to its limits by utilizing all available CPU cores. It’s designed to ensure that the kernel can handle high computational loads and I/O operations efficiently. The script for this test is located in the `Max_test/` directory. To run the Max Test, follow the steps in the [Max Test README](Max_test/README.md).

### 5. Automated Testing

Automated testing scripts are included in the `tests/` folder to perform various test suites, ensuring that the AI kernel is functioning as expected. Detailed instructions on how to run these tests can be found in the [Automated Testing README](Max_test/tests/README.md).

## Testing the Kernel

After building and installing the AI kernel driver, you can run the various tests to validate its performance. The tests include:

- **Computational Performance Tests**: Ensures the AI kernel can optimize performance across multiple threads.
- **I/O Performance Tests**: Validates the AI kernel's ability to handle read/write operations efficiently.
- **AI Feature Tests**: Tests the kernel’s AI-driven features, such as predictive maintenance, performance optimization, and power management.

### To Run All Tests

Use the `run_tests.sh` script to execute all the kernel and thread tests across all CPU cores:

```bash
./run_tests.sh
