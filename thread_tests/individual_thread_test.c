#include <stdio.h>
#include <pthread.h>
#include <math.h>

void* thread_function(void* arg){
    int thread_num = *((int*)arg);
    printf("Thread %d started.\n", thread_num);

    volatile double result = 0.0;
    for(long i = 0; i < 100000000; i++){
        result += sin(i) * cos(i);
    }

    printf("Thread %d completed. Result: %f\n", thread_num, result);
    pthread_exit(NULL);
}

int main(){
    pthread_t thread;
    int thread_num = 1;

    if(pthread_create(&thread, NULL, thread_function, &thread_num) != 0){
        perror("Failed to create thread");
        return 1;
    }

    pthread_join(thread, NULL);

    return 0;
}
