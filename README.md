
# World's First AI Kernel

Welcome to the **World's First AI Kernel** project! This repository contains the source code, tests, and utilities to build, install, and run an AI-powered kernel that integrates advanced AI functionalities into the core system. This kernel leverages AI to optimize hardware performance, provide predictive maintenance, and enhance power management for modern computing environments.

The project includes automated tests that stress-test the kernel across all available CPU cores, ensuring robust performance.

## Repository Structure

Here’s an overview of the project structure:

```
├── Max_test/
│   ├── ai_driver_test.c          # AI kernel driver test source
│   ├── automated_testing.sh      # Script to automate the testing process
│   ├── Makefile                  # Makefile for building the AI kernel driver
│   ├── README.md                 # Instructions for compiling and running AI driver tests
│   ├── ai_kernel_driver.c        # Core AI kernel driver code
│   ├── manage_ai_kernel_driver.sh# Script to load/unload AI kernel driver
│   ├── tests/
│   │   ├── run_tests.sh          # Script to run standard tests for the AI kernel
│   └── thread_tests/
│       ├── individual_thread_test.c # Source code for individual thread tests
│       ├── run_thread_tests.sh   # Script to run thread tests across cores
│       ├── readme.md             # Instructions for running individual thread tests
├── README.md                     # Main documentation (this file)
├── .gitattributes                 # Git configuration file
```

## Getting Started

### 1. Build and Install the AI Kernel

To build and install the AI kernel driver, follow the steps in the [AI Kernel Driver README](Max_test/readme.md). This will guide you through the compilation and installation of the kernel module.

### 2. Run Kernel Driver Tests

Once the AI kernel driver is installed, you can run tests to ensure it is working as expected. Navigate to the `Max_test/tests/` directory and use the testing scripts. More details can be found in the [Testing README](Max_test/readme.md).

### 3. Run Thread Tests

To evaluate how the AI kernel performs under different computational loads, you can run thread tests. This involves testing individual threads or maxing out all CPU cores. Instructions are available in the [Thread Tests README](Max_test/thread_tests/readme.md).

### 4. Max Test

The **Max Test** pushes the AI kernel to its limits by running computations across all CPU cores. It ensures the kernel can handle heavy loads efficiently. Detailed instructions for running the Max Test are available in the [Max Test README](Max_test/README.md).

### 5. Automated Testing

Automated testing scripts are available in the `tests/` directory. Use these scripts to run a full suite of tests that assess the kernel’s performance across various dimensions. Follow the instructions in the [Automated Testing README](Max_test/tests/README.md).

## Running Tests

### To Run All Tests

To run all available tests (kernel and thread tests), you can use the `run_tests.sh` script located in the `tests/` directory:

```bash
cd Max_test/tests
./run_tests.sh
```

This will execute the tests across all CPU cores and log the results.

### Thread Tests

To test individual threads or run a multi-core stress test, use the `run_thread_tests.sh` script in the `thread_tests/` directory:

```bash
cd Max_test/thread_tests
./run_thread_tests.sh
```

This script will execute tests designed to evaluate the performance of threads individually and across all CPU cores.

## Contributing

We welcome contributions to enhance the AI kernel. If you'd like to contribute, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License.

---

## Quick Links

- [AI Kernel Driver README](Max_test/README.md)
- [Automated Testing README](Max_test/tests/README.md)
- [Thread Tests README](Max_test/thread_tests/readme.md)

