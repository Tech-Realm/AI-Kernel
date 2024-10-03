
# World's First AI Kernel

Welcome to the **World's First AI Kernel** project! This repository contains the source code, tests, and utilities to build, install, and run an AI-powered kernel that integrates advanced AI functionalities into the core system. This kernel leverages AI to optimize hardware performance, provide predictive maintenance, and enhance power management for modern computing environments.

The project includes automated tests that stress-test the kernel across all available CPU cores, ensuring robust performance.


## Getting Started

### Installation

To build and install the AI kernel driver, follow the steps in the [AI Kernel Driver README](src/README.md). This README will guide you through the compilation and installation of the kernel module. Below are quick steps for running the automated installation script, along with explanations for each command:

1. First, navigate to the `src` directory where the necessary files for installation are located by running:

   ```bash
   cd src
   ```

   - *Explanation: The `cd` (change directory) command moves your terminal session into the `src` folder, which contains the installation files and scripts needed to build the kernel driver.*

2. Next, make the `automated_testing.sh` script executable:

   ```bash
   chmod +x automated_testing.sh
   ```

   - *Explanation: The `chmod +x` command changes the file permission of `automated_testing.sh` to make it executable. Without this step, you wouldn’t be able to run the script directly from the terminal.*

3. Finally, execute the installation script:

   ```bash
   ./automated_testing.sh
   ```

   - *Explanation: The `./` tells the terminal to run the `automated_testing.sh` script from the current directory. The script will automatically handle the build and installation process for the AI kernel driver, compiling the necessary components and installing them in the appropriate locations.*

Following these steps will simplify the process of building and installing the AI kernel driver. For more detailed guidance, please refer to the [AI Kernel Driver README](src/README.md).

## Thread Tests

Once the AI kernel driver is installed, you can run tests to ensure it is working as expected. Navigate to the `Max_test/` directory and use the testing scripts. More details can be found in the [Testing README](Max_test/readme.md).

### Run Individual Thread Tests

To evaluate how the AI kernel performs under different computational loads, you can run thread tests. This involves testing individual threads or maxing out all CPU cores. Instructions are available in the [Thread Tests README](thread_tests/readme.md).

### Max Test

The **Max Test** pushes the AI kernel to its limits by running computations across all CPU cores. It ensures the kernel can handle heavy loads efficiently. Detailed instructions for running the Max Test are available in the [Max Test README](Max_test/README.md).

### Automated Testing

Automated testing scripts are available in the `ALL directories`. Use these scripts to run a full suite of tests that assess the kernel’s performance across various dimensions. 



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


## Contributing

We welcome contributions to enhance the AI kernel. If you'd like to contribute, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License.

---

## Quick Links

- [AI Kernel Driver README](src/README.md)
- [Automated Testing README](Max_test/readme.md)
- [Thread Tests README](thread_tests/readme.md)

