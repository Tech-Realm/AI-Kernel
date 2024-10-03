

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Step 1: Compile the Program](#step-1-compile-the-program)
3. [Step 2: Prepare the Device File](#step-2-prepare-the-device-file)
4. [Step 3: Run the Test Without AI Features](#step-3-run-the-test-without-ai-features)
5. [Step 4: Run the Test With AI Features Enabled](#step-4-run-the-test-with-ai-features-enabled)
6. [Step 5: Analyze the Output Files](#step-5-analyze-the-output-files)
7. [Step 6: Calculate Percentage Change](#step-6-calculate-percentage-change)
8. [Step 7: Interpret the Results](#step-7-interpret-the-results)
9. [Step 8: Clean Up (Optional)](#step-8-clean-up-optional)
10. [Notes and Warnings](#notes-and-warnings)

---

## Prerequisites

- **Linux Environment**: A Linux distribution with terminal access.
- **GCC Compiler**: Ensure `gcc` is installed.
- **Root or Sudo Access**: Required for accessing `/dev/ai_driver`.
- **Basic Knowledge**: Familiarity with compiling and running C programs.

---

## Step 1: Compile the Program

1. Open a terminal in the directory containing `ai_driver_test.c`.

2. Compile the program using GCC:

   ```bash
   gcc -Wall -pthread -o ai_driver_test ai_driver_test.c -lm
   ```

3. If successful, an executable named `ai_driver_test` will be created.

---

## Step 2: Prepare the Device File

1. **Check if `/dev/ai_driver` Exists**:

   ```bash
   ls -l /dev/ai_driver
   ```

2. If it doesn't exist, create a dummy device file (for testing purposes only):

   ```bash
   sudo mknod /dev/ai_driver c 240 0
   sudo chmod 666 /dev/ai_driver
   ```

   - Replace `240` with the appropriate major number if known.

---

## Step 3: Run the Test Without AI Features

1. Execute the test program without AI features:

   ```bash
   sudo ./ai_driver_test > output_no_ai.txt
   ```

2. Wait for the test to complete.

---

## Step 4: Run the Test With AI Features Enabled

1. Execute the test program with AI features enabled:

   ```bash
   sudo ./ai_driver_test --enable-ai > output_with_ai.txt
   ```

2. Wait for the test to complete.

---

## Step 5: Analyze the Output Files

1. **Extract Average I/O Time Without AI Features**:

   ```bash
   avg_time_no_ai=$(grep "I/O Thread" output_no_ai.txt | awk -F'Average time per operation: ' '{print $2}' | awk '{ total += $1; count++ } END { if (count > 0) printf "%.6f", total / count; else print "N/A" }')
   ```

2. **Extract Average I/O Time With AI Features**:

   ```bash
   avg_time_with_ai=$(grep "I/O Thread" output_with_ai.txt | awk -F'Average time per operation: ' '{print $2}' | awk '{ total += $1; count++ } END { if (count > 0) printf "%.6f", total / count; else print "N/A" }')
   ```

3. **Display the Average I/O Times**:

   ```bash
   echo "Average I/O time WITHOUT AI features: ${avg_time_no_ai} milliseconds"
   echo "Average I/O time WITH AI features:    ${avg_time_with_ai} milliseconds"
   ```

---

## Step 6: Calculate Percentage Change

1. **Calculate Difference and Percentage Change**:

   ```bash
   diff=$(echo "$avg_time_with_ai - $avg_time_no_ai" | bc)
   percent_change=$(echo "scale=2; ($diff / $avg_time_no_ai) * 100" | bc)
   ```

2. **Display the Percentage Change**:

   ```bash
   echo "Percentage change in average I/O time: ${percent_change}%"
   ```

---

## Step 7: Interpret the Results

- **Improved Performance**: A negative percentage indicates improved performance with AI features enabled.
- **Degraded Performance**: A positive percentage indicates increased average I/O time with AI features.
- **Consistency**: Consider running the tests multiple times to ensure consistent results.

---

## Step 8: Clean Up (Optional)

1. Remove the executable and output files:

   ```bash
   rm ai_driver_test output_no_ai.txt output_with_ai.txt
   ```

2. Remove the dummy device file if created:

   ```bash
   sudo rm /dev/ai_driver
   ```

---

## Notes and Warnings

- **System Resources**: The test is resource-intensive. Ensure it doesn't disrupt critical services.
- **Permissions**: Accessing `/dev/ai_driver` may require root privileges.
- **Device Driver**: In a production environment, ensure the `ai_driver` kernel module is properly installed.
- **Thread Count**: Adjust `NUM_THREADS` in `ai_driver_test.c` based on your CPU cores.
- **IOCTL Commands**: Ensure IOCTL commands match those defined in your device driver.
- **Security**: Run programs with elevated privileges cautiously.

