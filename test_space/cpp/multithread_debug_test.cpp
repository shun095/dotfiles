//main.c
#include <iostream>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

static unsigned int m_count = 0, t1_count = 0, t2_count = 0;

void *thread1(void *args)
{
    while (1) {
        t1_count++;
        std::cout << "t1_count" << t1_count << std::endl;
        sleep(3);
    }
    return NULL;
}

void *thread2(void *args)
{
    while (1) {
        t2_count++;
        std::cout << "t2_count" << t2_count << std::endl;
        sleep(2);
    }
    return NULL;
}

int main(void)
{
    int i;
    pthread_t t1, t2;
    pthread_create(&t1, NULL, thread1, (void *)NULL);
    pthread_create(&t2, NULL, thread2, (void *)NULL);
    while (1) {
        m_count++;
        std::cout << "m_count" << m_count << std::endl;
        sleep(1);
    }
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    printf("exit\n");
    return 0;
}
