// ai_driver_test.c

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>
#include <math.h>
#include <sys/ioctl.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <sys/sysinfo.h>

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
};

// Number of I/O iterations
#define IO_ITERATIONS 10000

// Buffer size for read/write operations
#define BUFFER_SIZE 4096  // 4 KB

// Flag to enable or disable AI features
int ai_features_enabled = 0;

// Mutex for synchronizing access to the device
pthread_mutex_t device_mutex = PTHREAD_MUTEX_INITIALIZER;

// Dynamically get the number of CPU cores
int get_num_cpu_cores() {
    return sysconf(_SC_NPROCESSORS_ONLN);
}

// Dynamically adjust computation iterations based on system load
unsigned long get_computation_iterations() {
    struct sysinfo info;
    if (sysinfo(&info) == 0) {
        return 100000000 * info.loads[0] / 1000000;  // Adjust iterations based on load
    }
    return 100000000;  // Fallback to default
}

void* computation_thread(void* arg) {
    int thread_num = *((int*)arg);

    // Get the computation iterations dynamically
    unsigned long computation_iterations = get_computation_iterations();

    // Heavy computational task
    volatile double result = 0.0;
    for (long i = 0; i < computation_iterations; i++) {
        result += sin(i) * cos(i);
    }

    printf("Computation Thread %d completed computation. Result: %f\n", thread_num, result);
    pthread_exit(NULL);
}

void* io_thread(void* arg) {
    int thread_num = *((int*)arg);
    int fd = *((int*)arg + 1);  // Get the file descriptor from arguments

    char *write_buffer = malloc(BUFFER_SIZE);
    char *read_buffer = malloc(BUFFER_SIZE);
    if (!write_buffer || !read_buffer) {
        perror("Failed to allocate buffers");
        pthread_exit(NULL);
    }
    memset(write_buffer, 'A', BUFFER_SIZE);

    // Invoke AI features if enabled (only once per thread)
    pthread_mutex_lock(&device_mutex);
    if (ai_features_enabled) {
        // Performance Optimization
        if (ioctl(fd, AI_IOC_PERF_OPT) < 0) {
            perror("Failed to perform performance optimization");
        }

        // Predictive Maintenance
        if (ioctl(fd, AI_IOC_PRED_MAINT) < 0) {
            perror("Failed to perform predictive maintenance");
        }

        // Security Enhancements
        if (ioctl(fd, AI_IOC_SEC_ENHANCE) < 0) {
            perror("Failed to enhance security");
        }

        // Power Management
        if (ioctl(fd, AI_IOC_PWR_MGMT) < 0) {
            perror("Failed to manage power");
        }

        // Hardware Adaptation
        struct hw_config config;
        config.buffer_size = 8192;  // Increase buffer size
        config.threshold = 10000;   // Set a new threshold
        if (ioctl(fd, AI_IOC_HW_ADAPT, &config) < 0) {
            perror("Failed to adapt hardware configuration");
        }
    }
    pthread_mutex_unlock(&device_mutex);

    struct timespec start_time, end_time;
    double total_time = 0.0;

    // Perform I/O operations
    for (long i = 0; i < IO_ITERATIONS; i++) {
        clock_gettime(CLOCK_MONOTONIC, &start_time);

        pthread_mutex_lock(&device_mutex);

        // Write data
        ssize_t bytes_written = write(fd, write_buffer, BUFFER_SIZE);
        if (bytes_written < 0) {
            perror("Write failed");
            pthread_mutex_unlock(&device_mutex);
            break;
        }

        // Seek to beginning
        lseek(fd, 0, SEEK_SET);

        // Read data
        ssize_t bytes_read = read(fd, read_buffer, BUFFER_SIZE);
        if (bytes_read < 0) {
            perror("Read failed");
            pthread_mutex_unlock(&device_mutex);
            break;
        }

        pthread_mutex_unlock(&device_mutex);

        clock_gettime(CLOCK_MONOTONIC, &end_time);
        double elapsed_time = (end_time.tv_sec - start_time.tv_sec) +
                              (end_time.tv_nsec - start_time.tv_nsec) / 1e9;
        total_time += elapsed_time;
    }

    printf("I/O Thread %d completed I/O operations. Total time: %.6f seconds, Average time per operation: %.6f milliseconds\n",
           thread_num, total_time, (total_time / IO_ITERATIONS) * 1000);

    free(write_buffer);
    free(read_buffer);
    pthread_exit(NULL);
}

int main(int argc, char *argv[]) {
    // Check command-line arguments to enable or disable AI features
    if (argc > 1 && strcmp(argv[1], "--enable-ai") == 0) {
        ai_features_enabled = 1;
        printf("AI features are enabled.\n");
    } else {
        printf("AI features are disabled.\n");
    }

    int fd = open("/dev/ai_driver", O_RDWR);
    if (fd < 0) {
        perror("Failed to open /dev/ai_driver");
        return EXIT_FAILURE;
    }

    // Automatically determine number of threads based on CPU cores
    int num_threads = get_num_cpu_cores();
    printf("Number of threads: %d\n", num_threads);

    pthread_t threads[num_threads * 2];
    int thread_args[num_threads * 2][2];  // Each thread gets an array of two integers

    // Create computation threads
    for (int i = 0; i < num_threads; i++) {
        thread_args[i][0] = i;  // Thread number
        if (pthread_create(&threads[i], NULL, computation_thread, &thread_args[i][0]) != 0) {
            perror("Failed to create computation thread");
            close(fd);
            return EXIT_FAILURE;
        }
    }

    // Create I/O threads
    for (int i = 0; i < num_threads; i++) {
        thread_args[num_threads + i][0] = i;     // Thread number
        thread_args[num_threads + i][1] = fd;    // File descriptor
        if (pthread_create(&threads[num_threads + i], NULL, io_thread, thread_args[num_threads + i]) != 0) {
            perror("Failed to create I/O thread");
            close(fd);
            return EXIT_FAILURE;
        }
    }

    // Join threads
    for (int i = 0; i < num_threads * 2; i++) {
        pthread_join(threads[i], NULL);
    }

    close(fd);
    printf("All threads have completed.\n");
    return EXIT_SUCCESS;
}
