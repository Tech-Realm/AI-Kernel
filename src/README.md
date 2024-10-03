
# AI Kernel Driver Instructions

These instructions will guide you through compiling, installing, and managing the `ai_kernel_driver` kernel module. You will also learn how to load and unload the driver, as well as how to clean up build artifacts.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Step 1: Compile the Kernel Module](#step-1-compile-the-kernel-module)
3. [Step 2: Install (Load) the Kernel Module](#step-2-install-load-the-kernel-module)
4. [Step 3: Verify the Module Installation](#step-3-verify-the-module-installation)
5. [Step 4: Interact with the Device Node](#step-4-interact-with-the-device-node)
6. [Step 5: Uninstall (Unload) the Kernel Module](#step-5-uninstall-unload-the-kernel-module)
7. [Step 6: Clean Build Artifacts](#step-6-clean-build-artifacts)
8. [Notes and Warnings](#notes-and-warnings)

---

## Prerequisites

- **Linux Environment**: A Linux distribution with kernel headers installed.
- **Root or Sudo Access**: Required for installing and removing kernel modules.
- **Kernel Headers**: Ensure kernel headers matching your current kernel version are installed.
- **Basic Knowledge**: Familiarity with compiling kernel modules and using `make`.

---

## Step 1: Compile the Kernel Module

1. Open a terminal in the directory containing `ai_kernel_driver.c`, `Makefile`, and `manage_ai_kernel_driver.sh`.

2. Ensure that the `Makefile` is correctly configured.

3. Compile the kernel module using the provided `make` command:

   ```bash
   make
   ```

   - This command will invoke the kernel build system to compile the module.

4. If the compilation is successful, an object file `ai_kernel_driver.ko` will be created.

---

## Step 2: Install (Load) the Kernel Module

1. Ensure the `manage_ai_kernel_driver.sh` script is executable:

   ```bash
   chmod +x manage_ai_kernel_driver.sh
   ```

2. Use the script to install the module:

   ```bash
   sudo ./manage_ai_kernel_driver.sh install
   ```

   - This script will:

     - Build the module (if not already built).
     - Insert the module into the kernel using `insmod`.
     - Create the device node `/dev/ai_driver`.

3. If prompted, enter your password for `sudo` privileges.

---

## Step 3: Verify the Module Installation

1. **Check if the Module is Loaded**:

   ```bash
   lsmod | grep ai_kernel_driver
   ```

   - This should display a line indicating that `ai_kernel_driver` is loaded.

2. **Check for Device Node**:

   ```bash
   ls -l /dev/ai_driver
   ```

   - Ensure that the device node `/dev/ai_driver` exists with appropriate permissions.

3. **View Kernel Messages**:

   ```bash
   dmesg | tail -n 20
   ```

   - Check the kernel messages for any errors or confirmation messages related to the driver.

---

## Step 4: Interact with the Device Node

You can now interact with the device node `/dev/ai_driver` using standard file operations or through a test application.

1. **Read from the Device**:

   ```bash
   cat /dev/ai_driver
   ```

2. **Write to the Device**:

   ```bash
   echo "Test Data" | sudo tee /dev/ai_driver
   ```

3. **Use the Test Application**:

   - If you have a user-space application (e.g., `ai_driver_test`) that interacts with the driver, you can run it now.

   ```bash
   sudo ./ai_driver_test
   ```

---

## Step 5: Uninstall (Unload) the Kernel Module

1. Use the `manage_ai_kernel_driver.sh` script to remove the module:

   ```bash
   sudo ./manage_ai_kernel_driver.sh uninstall
   ```

   - This script will:

     - Remove the device node `/dev/ai_driver`.
     - Unload the kernel module using `rmmod`.

2. **Verify the Module is Unloaded**:

   ```bash
   lsmod | grep ai_kernel_driver
   ```

   - The module should no longer be listed.

---

## Step 6: Clean Build Artifacts

1. To clean up the build artifacts, run:

   ```bash
   make clean
   ```

2. This will remove files generated during the build process.

---

## Testing

- **System Stability**: Loading kernel modules can affect system stability. Ensure you understand the code before installing.

- **Kernel Version Compatibility**: The module should be compiled against the headers of your currently running kernel.

- **Permissions**: Running commands with `sudo` privileges can have significant effects on your system. Use with caution.

- **Error Handling**: Check `dmesg` for any error messages if something doesn't work as expected.

- **Modify `NUM_THREADS`**: If applicable, adjust the number of threads in your test application based on your CPU cores.

- **Dependencies**: Ensure all dependencies and kernel headers are installed before compiling the module.

---
