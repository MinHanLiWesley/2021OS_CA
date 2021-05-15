#include <math.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
int total;
int circle;
void *InorOut(void *param);
int main(int argc, char *argv[])
{
    pthread_t tid;
    pthread_attr_t attr;
    if (argc != 2)
    {
        fprintf(stderr, "usage: hw2.out <integer value>\n");
        return -1;
    }
    if (atoi(argv[1]) < 0)
    {
        fprintf(stderr, "Argument %d must be non-negative\n", atoi(argv[1]));
        return -1;
    }
    /* get the default attributes */
    pthread_attr_init(&attr);
    /* create the thread */
    pthread_create(&tid, &attr, InorOut, argv[1]);
    /* now wait for the thread to exit */
    pthread_join(tid, NULL);
    total = atoi(argv[1]);
    printf("total points = %d\n", total);
    printf("in circle = %d\n", circle);
    printf("pi = %.4f\n", (float)(circle) * 4 / total);

    return 0;
}

void *InorOut(void *param)
{
    int total = atoi(param);
    int count = 0;
    while (count < total)
    {
        float x = ((float)rand() / (float)(RAND_MAX)) * 2 - 1;
        float y = ((float)rand() / (float)(RAND_MAX)) * 2 - 1;
        // check if points are in circle or not
        float dis = pow(x, 2) + pow(y, 2);
        if (dis <= 1)
        {
            circle += 1;
        }
        count++;
    }

    pthread_exit(0);
}