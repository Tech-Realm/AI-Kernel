#!/bin/bash

# manage_ai_kernel_driver.sh
# A script to create, build, install, remove, and clean the AI Kernel Driver with AI Features.

# Variables
DRIVER_NAME="ai_kernel_driver"
DEVICE_NAME="ai_driver"
CLASS_NAME="ai"
VERSION="0.1"
AUTHOR="Waleed Ajmal"
DESCRIPTION="A Kernel Driver with AI Features"
MAJOR_NUMBER=0  # 0 lets the system assign a major number
WORK_DIR="./ai_kernel_driver"
C_FILE="${WORK_DIR}/${DRIVER_NAME}.c"
MAKEFILE="${WORK_DIR}/Makefile"
DEVICE_NODE="/dev/${DEVICE_NAME}"

# Function to display usage
usage() {
    echo "Usage: sudo $0 {setup|build|install|remove|clean|all}"
    echo ""
    echo "Options:"
    echo "  setup    - Create working directory and necessary files."
    echo "  build    - Compile the kernel module."
    echo "  install  - Load the module into the kernel and create device node."
    echo "  remove   - Unload the module and remove device node."
    echo "  clean    - Remove build artifacts."
    echo "  all      - Perform setup, build, and install."
    echo ""
    exit 1
}

# Function to check dependencies
check_dependencies() {
    echo "Checking for required tools and dependencies..."

    # Check for gcc
    if ! command -v gcc &> /dev/null
    then
        echo "gcc could not be found. Please install gcc."
        exit 1
    fi

    # Check for make
    if ! command -v make &> /dev/null
    then
        echo "make could not be found. Please install make."
        exit 1
    fi

    # Check for kernel headers
    KERNEL_HEADERS="/lib/modules/$(uname -r)/build"
    if [ ! -d "$KERNEL_HEADERS" ]; then
        echo "Kernel headers not found for current kernel version."
        echo "Please install the appropriate kernel headers."
        exit 1
    fi

    echo "All dependencies are met."
}

# Function to create driver source and Makefile with AI Features implemented
setup_files() {
    echo "Setting up working directory and files..."

    mkdir -p "$WORK_DIR" || { echo "Failed to create directory $WORK_DIR"; exit 1; }

    # Create the C source file with AI Features implemented
    cat << 'EOF' > "$C_FILE"
/* ai_kernel_driver.c */
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>           // For file operations
#include <linux/uaccess.h>      // For copy_to_user, copy_from_user
#include <linux/mutex.h>        // For mutexes
#include <linux/device.h>       // For device_create, class_create, etc.
#include <linux/cdev.h>         // For cdev utilities
#include <linux/slab.h>         // For kmalloc and kfree
#include <linux/timer.h>        // For kernel timers
#include <linux/workqueue.h>    // For workqueues
#include <linux/errno.h>        // For error codes
#include <linux/random.h>       // For random numbers

#define DEVICE_NAME "ai_driver"
#define CLASS_NAME  "ai"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Your Name");
MODULE_DESCRIPTION("A Kernel Driver with AI Features");
MODULE_VERSION("0.1");

// Define IOCTL commands
#define AI_IOC_MAGIC 'a'
#define AI_IOC_PERF_OPT _IO(AI_IOC_MAGIC, 1)
#define AI_IOC_PRED_MAINT _IO(AI_IOC_MAGIC, 2)
#define AI_IOC_SEC_ENHANCE _IO(AI_IOC_MAGIC, 3)
#define AI_IOC_PWR_MGMT _IO(AI_IOC_MAGIC, 4)
#define AI_IOC_HW_ADAPT _IOW(AI_IOC_MAGIC, 5, struct hw_config)

// Structure for hardware configuration parameters
struct hw_config {
    unsigned int buffer_size;
    unsigned int threshold;
    // Add more parameters as needed
};

// Device structure
struct ai_device {
    struct cdev cdev;
    struct class *class;
    struct device *device;
    dev_t dev_number;
    struct mutex mutex_lock;         // Mutex for synchronization

    // Buffer management
    char *buffer;
    unsigned int buffer_size;
    unsigned int threshold;

    // Predictive maintenance
    unsigned int usage_count;
    unsigned int error_count;

    // Security enhancement
    unsigned int anomaly_score;

    // Power management state
    bool low_power_mode;

    // Simulated sensor data
    unsigned int sensor_data;
};

static struct ai_device ai_dev;

// Function prototypes
static int dev_open(struct inode *, struct file *);
static int dev_release(struct inode *, struct file *);
static ssize_t dev_read(struct file *, char __user *, size_t, loff_t *);
static ssize_t dev_write(struct file *, const char __user *, size_t, loff_t *);
static long dev_ioctl(struct file *, unsigned int, unsigned long);

// Helper functions for AI algorithms
static void perform_predictive_maintenance(void);
static void enhance_security(void);
static void manage_power(void);
static void optimize_performance(void);
static void adapt_hardware(struct hw_config *config);

// File operations structure
static struct file_operations fops =
{
    .owner = THIS_MODULE,
    .open = dev_open,
    .read = dev_read,
    .write = dev_write,
    .unlocked_ioctl = dev_ioctl,
    .release = dev_release,
};

// Initialization function
static int __init ai_driver_init(void){
    int ret;
    dev_t dev_no;

    printk(KERN_INFO "AI_DRIVER: Initializing the AI kernel driver\n");

    // Allocate a major number dynamically
    ret = alloc_chrdev_region(&dev_no, 0, 1, DEVICE_NAME);
    if (ret < 0){
        printk(KERN_ALERT "AI_DRIVER: Failed to allocate a major number\n");
        return ret;
    }
    ai_dev.dev_number = dev_no;
    printk(KERN_INFO "AI_DRIVER: registered correctly with major number %d\n", MAJOR(dev_no));

    // Initialize cdev
    cdev_init(&ai_dev.cdev, &fops);
    ai_dev.cdev.owner = THIS_MODULE;

    // Add cdev to the system
    ret = cdev_add(&ai_dev.cdev, ai_dev.dev_number, 1);
    if (ret < 0){
        unregister_chrdev_region(ai_dev.dev_number, 1);
        printk(KERN_ALERT "AI_DRIVER: Failed to add cdev\n");
        return ret;
    }

    // Create device class
    ai_dev.class = class_create(THIS_MODULE, CLASS_NAME);
    if (IS_ERR(ai_dev.class)){
        cdev_del(&ai_dev.cdev);
        unregister_chrdev_region(ai_dev.dev_number, 1);
        printk(KERN_ALERT "AI_DRIVER: Failed to create device class\n");
        return PTR_ERR(ai_dev.class);
    }
    printk(KERN_INFO "AI_DRIVER: device class registered correctly\n");

    // Create the device
    ai_dev.device = device_create(ai_dev.class, NULL, ai_dev.dev_number, NULL, DEVICE_NAME);
    if (IS_ERR(ai_dev.device)){
        class_destroy(ai_dev.class);
        cdev_del(&ai_dev.cdev);
        unregister_chrdev_region(ai_dev.dev_number, 1);
        printk(KERN_ALERT "AI_DRIVER: Failed to create the device\n");
        return PTR_ERR(ai_dev.device);
    }
    printk(KERN_INFO "AI_DRIVER: device created correctly\n");

    // Initialize mutex
    mutex_init(&ai_dev.mutex_lock);

    // Initialize buffer
    ai_dev.buffer_size = 1024; // Default buffer size
    ai_dev.buffer = kmalloc(ai_dev.buffer_size, GFP_KERNEL);
    if (!ai_dev.buffer){
        printk(KERN_ALERT "AI_DRIVER: Failed to allocate memory for buffer\n");
        device_destroy(ai_dev.class, ai_dev.dev_number);
        class_unregister(ai_dev.class);
        class_destroy(ai_dev.class);
        cdev_del(&ai_dev.cdev);
        unregister_chrdev_region(ai_dev.dev_number, 1);
        return -ENOMEM;
    }
    memset(ai_dev.buffer, 0, ai_dev.buffer_size);

    // Initialize usage count and error count
    ai_dev.usage_count = 0;
    ai_dev.error_count = 0;

    // Initialize anomaly score
    ai_dev.anomaly_score = 0;

    // Initialize power state
    ai_dev.low_power_mode = false;

    // Initialize sensor data
    ai_dev.sensor_data = 0;

    // Set default threshold
    ai_dev.threshold = 5000;

    printk(KERN_INFO "AI_DRIVER: Initialization complete\n");
    return 0;
}

// Cleanup function
static void __exit ai_driver_exit(void){
    // Free buffer
    kfree(ai_dev.buffer);

    // Destroy device and class
    device_destroy(ai_dev.class, ai_dev.dev_number);
    class_unregister(ai_dev.class);
    class_destroy(ai_dev.class);

    // Delete cdev and unregister major number
    cdev_del(&ai_dev.cdev);
    unregister_chrdev_region(ai_dev.dev_number, 1);

    // Destroy mutex
    mutex_destroy(&ai_dev.mutex_lock);

    printk(KERN_INFO "AI_DRIVER: Goodbye from the AI kernel driver!\n");
}

// Open function
static int dev_open(struct inode *inodep, struct file *filep){
    if(!mutex_trylock(&ai_dev.mutex_lock)){
        printk(KERN_ALERT "AI_DRIVER: Device in use by another process");
        return -EBUSY;
    }
    printk(KERN_INFO "AI_DRIVER: Device has been opened\n");
    return 0;
}

// Read function
static ssize_t dev_read(struct file *filep, char __user *buffer, size_t len, loff_t *offset){
    ssize_t bytes_read;

    if (*offset >= ai_dev.buffer_size){
        mutex_unlock(&ai_dev.mutex_lock);
        return 0;
    }

    if (len > ai_dev.buffer_size - *offset){
        len = ai_dev.buffer_size - *offset;
    }

    bytes_read = copy_to_user(buffer, ai_dev.buffer + *offset, len);
    if (bytes_read){
        mutex_unlock(&ai_dev.mutex_lock);
        return -EFAULT;
    }

    *offset += len;
    printk(KERN_INFO "AI_DRIVER: Read %zu bytes from buffer\n", len);
    mutex_unlock(&ai_dev.mutex_lock);
    return len;
}

// Write function
static ssize_t dev_write(struct file *filep, const char __user *buffer, size_t len, loff_t *offset){
    ssize_t bytes_written;

    if (len > ai_dev.buffer_size - *offset){
        len = ai_dev.buffer_size - *offset;
    }

    bytes_written = copy_from_user(ai_dev.buffer + *offset, buffer, len);
    if (bytes_written){
        mutex_unlock(&ai_dev.mutex_lock);
        return -EFAULT;
    }

    *offset += len;
    printk(KERN_INFO "AI_DRIVER: Wrote %zu bytes to buffer\n", len);

    // Update usage count for predictive maintenance
    ai_dev.usage_count += len;

    // Simulate error count
    if (len > 1000) { // Arbitrary condition for errors
        ai_dev.error_count++;
    }

    // Simulate sensor data update
    get_random_bytes(&ai_dev.sensor_data, sizeof(ai_dev.sensor_data));
    ai_dev.sensor_data %= 100; // Simulate sensor data between 0-99

    mutex_unlock(&ai_dev.mutex_lock);
    return len;
}

// IOCTL function
static long dev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg){
    long ret = 0;

    // Validate magic number
    if(_IOC_TYPE(cmd) != AI_IOC_MAGIC){
        printk(KERN_WARNING "AI_DRIVER: Invalid IOCTL magic number\n");
        return -ENOTTY;
    }

    mutex_lock(&ai_dev.mutex_lock);

    switch(cmd){
        case AI_IOC_PERF_OPT:
            printk(KERN_INFO "AI_DRIVER: Performing performance optimization\n");
            optimize_performance();
            break;
        case AI_IOC_PRED_MAINT:
            printk(KERN_INFO "AI_DRIVER: Performing predictive maintenance\n");
            perform_predictive_maintenance();
            break;
        case AI_IOC_SEC_ENHANCE:
            printk(KERN_INFO "AI_DRIVER: Enhancing security\n");
            enhance_security();
            break;
        case AI_IOC_PWR_MGMT:
            printk(KERN_INFO "AI_DRIVER: Managing power consumption\n");
            manage_power();
            break;
        case AI_IOC_HW_ADAPT:
        {
            struct hw_config config;
            if (copy_from_user(&config, (struct hw_config __user *)arg, sizeof(struct hw_config))){
                printk(KERN_WARNING "AI_DRIVER: Failed to copy hardware config from user\n");
                ret = -EFAULT;
                break;
            }
            printk(KERN_INFO "AI_DRIVER: Adapting hardware configurations\n");
            adapt_hardware(&config);
            break;
        }
        default:
            printk(KERN_WARNING "AI_DRIVER: Unknown IOCTL command %u\n", cmd);
            ret = -EINVAL;
    }

    mutex_unlock(&ai_dev.mutex_lock);
    return ret;
}

// Release function
static int dev_release(struct inode *inodep, struct file *filep){
    mutex_unlock(&ai_dev.mutex_lock);
    printk(KERN_INFO "AI_DRIVER: Device successfully closed\n");
    return 0;
}

// Helper function implementations

static void perform_predictive_maintenance(void){
    // Simple predictive maintenance using linear regression (simulated)
    unsigned int predicted_usage = ai_dev.usage_count + (ai_dev.usage_count / 10); // Predicting 10% increase
    printk(KERN_INFO "AI_DRIVER: Predicted future usage: %u\n", predicted_usage);

    if (predicted_usage > ai_dev.threshold){
        printk(KERN_WARNING "AI_DRIVER: Maintenance required soon. Predicted usage exceeds threshold.\n");
        // Take preemptive actions or notify user space
    } else {
        printk(KERN_INFO "AI_DRIVER: System operating within normal parameters.\n");
    }
}

static void enhance_security(void){
    // Simple anomaly detection using threshold (simulated)
    ai_dev.anomaly_score = ai_dev.error_count * ai_dev.sensor_data;

    printk(KERN_INFO "AI_DRIVER: Calculated anomaly score: %u\n", ai_dev.anomaly_score);

    if (ai_dev.anomaly_score > 5000){ // Arbitrary threshold
        printk(KERN_WARNING "AI_DRIVER: Anomaly detected! Potential security threat.\n");
        // Take security measures or alert system
    } else {
        printk(KERN_INFO "AI_DRIVER: No anomalies detected.\n");
    }
}

static void manage_power(void){
    // Simple power management based on usage count
    if (ai_dev.usage_count < (ai_dev.threshold / 2) && !ai_dev.low_power_mode){
        ai_dev.low_power_mode = true;
        printk(KERN_INFO "AI_DRIVER: Switching to low power mode.\n");
        // Implement low power mode operations
    } else if (ai_dev.usage_count >= (ai_dev.threshold / 2) && ai_dev.low_power_mode){
        ai_dev.low_power_mode = false;
        printk(KERN_INFO "AI_DRIVER: Exiting low power mode.\n");
        // Resume normal operations
    } else {
        printk(KERN_INFO "AI_DRIVER: Power mode unchanged.\n");
    }
}

static void optimize_performance(void){
    // Simple performance optimization by adjusting buffer size
    if (ai_dev.buffer_size < 2048){
        char *new_buffer = krealloc(ai_dev.buffer, 2048, GFP_KERNEL);
        if (!new_buffer){
            printk(KERN_ERR "AI_DRIVER: Failed to reallocate buffer\n");
            return;
        }
        ai_dev.buffer = new_buffer;
        ai_dev.buffer_size = 2048;
        printk(KERN_INFO "AI_DRIVER: Buffer size increased to %u bytes\n", ai_dev.buffer_size);
    } else {
        printk(KERN_INFO "AI_DRIVER: Buffer size already optimized\n");
    }
}

static void adapt_hardware(struct hw_config *config){
    // Adjust buffer size based on config
    if (config->buffer_size != ai_dev.buffer_size){
        char *new_buffer = krealloc(ai_dev.buffer, config->buffer_size, GFP_KERNEL);
        if (!new_buffer){
            printk(KERN_ERR "AI_DRIVER: Failed to reallocate buffer\n");
            return;
        }
        ai_dev.buffer = new_buffer;
        ai_dev.buffer_size = config->buffer_size;
        printk(KERN_INFO "AI_DRIVER: Buffer size updated to %u bytes\n", ai_dev.buffer_size);
    }
    ai_dev.threshold = config->threshold;
    printk(KERN_INFO "AI_DRIVER: Threshold updated to %u\n", ai_dev.threshold);
}

module_init(ai_driver_init);
module_exit(ai_driver_exit);
EOF

    echo "Created $C_FILE with AI Features implemented."

    # Create the Makefile with actual tabs
    cat << 'EOF' > "$MAKEFILE"
# Makefile
obj-m += ai_kernel_driver.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
EOF

    echo "Created $MAKEFILE"
    echo "Setup complete."
}

# Function to build the kernel module
build_module() {
    echo "Building the kernel module..."

    cd "$WORK_DIR" || { echo "Failed to enter directory $WORK_DIR"; exit 1; }

    make
    if [ $? -ne 0 ]; then
        echo "Build failed."
        exit 1
    fi

    echo "Build successful."
    cd - > /dev/null
}

# Function to install (load) the kernel module
install_module() {
    echo "Installing the kernel module..."

    # Check if the module is already loaded
    if lsmod | grep -q "^${DRIVER_NAME} "; then
        echo "Module ${DRIVER_NAME} is already loaded. Unloading it first..."
        sudo rmmod "${DRIVER_NAME}"
        if [ $? -ne 0 ]; then
            echo "Failed to unload the existing kernel module."
            exit 1
        fi
        echo "Existing kernel module unloaded."
    fi

    # Ensure the module is built
    if [ ! -f "${WORK_DIR}/${DRIVER_NAME}.ko" ]; then
        echo "Kernel module not found. Please build it first."
        exit 1
    fi

    # Load the module
    sudo insmod "${WORK_DIR}/${DRIVER_NAME}.ko"
    if [ $? -ne 0 ]; then
        echo "Failed to load the kernel module."
        exit 1
    fi

    echo "Kernel module loaded."

    # Get the assigned major number if not set
    if [ "$MAJOR_NUMBER" -eq 0 ]; then
        # Wait briefly to ensure dmesg has the latest logs
        sleep 1
        # Retrieve the major number from dmesg
        MAJOR_NUMBER=$(dmesg | grep "AI_DRIVER: registered correctly with major number" | tail -n1 | awk '{print $NF}')
        if [ -z "$MAJOR_NUMBER" ]; then
            echo "Failed to retrieve major number from dmesg."
            exit 1
        fi
        echo "Assigned Major Number: $MAJOR_NUMBER"
    fi

    # Create device node if it doesn't exist
    if [ ! -e "$DEVICE_NODE" ]; then
        sudo mknod "$DEVICE_NODE" c "$MAJOR_NUMBER" 0
        sudo chmod 666 "$DEVICE_NODE"
        echo "Device node $DEVICE_NODE created."
    else
        echo "Device node $DEVICE_NODE already exists."
    fi

    # Display dmesg logs
    dmesg | tail -n 20
}

# Function to remove (unload) the kernel module
remove_module() {
    echo "Removing the kernel module..."

    # Check if the module is loaded
    if ! lsmod | grep -q "^${DRIVER_NAME} "; then
        echo "Module ${DRIVER_NAME} is not loaded."
    else
        # Unload the module
        sudo rmmod "${DRIVER_NAME}"
        if [ $? -ne 0 ]; then
            echo "Failed to unload the kernel module."
            exit 1
        fi
        echo "Kernel module unloaded."
    fi

    # Remove device node
    if [ -e "$DEVICE_NODE" ]; then
        sudo rm "$DEVICE_NODE"
        echo "Device node $DEVICE_NODE removed."
    else
        echo "Device node $DEVICE_NODE does not exist."
    fi

    # Display dmesg logs
    dmesg | tail -n 20
}

# Function to clean build artifacts
clean_build() {
    echo "Cleaning build artifacts..."

    cd "$WORK_DIR" || { echo "Failed to enter directory $WORK_DIR"; exit 1; }
    make clean
    if [ $? -ne 0 ]; then
        echo "Clean failed."
        exit 1
    fi
    echo "Clean successful."
    cd - > /dev/null
}

# Function to perform all steps: setup, build, install
install_all() {
    check_dependencies
    setup_files
    build_module
    install_module
}

# Ensure the script is run with at least one argument
if [ $# -lt 1 ]; then
    usage
fi

# Parse the command
case "$1" in
    setup)
        check_dependencies
        setup_files
        ;;
    build)
        check_dependencies
        build_module
        ;;
    install)
        check_dependencies
        install_module
        ;;
    remove)
        remove_module
        ;;
    clean)
        clean_build
        ;;
    all)
        install_all
        ;;
    *)
        usage
        ;;
esac

exit 0
