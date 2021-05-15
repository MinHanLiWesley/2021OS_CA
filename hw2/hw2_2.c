#include <math.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#define THREAD_MAX 2
int Arr[] = {7, 12, 19, 3, 18, 4, 2, 6, 15, 8};
int size = sizeof(Arr) / sizeof(int);
int part = 0;
void merge_sort(int start, int end);
void merge_array(int start, int mid, int end);
void *thread_merge(void *param);
void print_arr();
int main(int argc, char *argv[])
{
    pthread_t tid[THREAD_MAX];
    pthread_attr_t attr[THREAD_MAX];
    printf("size:%d\n", sizeof(Arr) / sizeof(int));
    printf("unsorted:\n");
    print_arr();
    /* get the default attributes */
    for (int i = 0; i < THREAD_MAX; i++)
    {
        pthread_attr_init(&attr[i]);
        /* create the thread */
        pthread_create(&tid[i], &attr[i],thread_merge, (void *)NULL);
    }

    /* now wait for the thread to exit */
    for (size_t i = 0; i < THREAD_MAX; i++)
    {
        pthread_join(tid[i], NULL);
    }
    merge_array(0, (size - 1) / 2, size - 1);

    printf("sorted:\n");
    print_arr();

    return 0;
}
void print_arr()
{
    int size = sizeof(Arr) / sizeof(int);
    for (size_t i = 0; i < size; i++)
    {
        printf("%d,", Arr[i]);
    }
    printf("\n");
}

void merge_array(int start, int mid, int end)
{
    // create a temp array
    int temp[end - start + 1];

    // crawlers for both intervals and for temp
    int i = start, j = mid + 1, k = 0;

    // traverse both arrays and in each iteration add smaller of both elements in temp
    while (i <= mid && j <= end)
    {
        if (Arr[i] <= Arr[j])
        {
            temp[k] = Arr[i];
            k += 1;
            i += 1;
        }
        else
        {
            temp[k] = Arr[j];
            k += 1;
            j += 1;
        }
    }

    // add elements left in the first interval
    while (i <= mid)
    {
        temp[k] = Arr[i];
        k += 1;
        i += 1;
    }

    // add elements left in the second interval
    while (j <= end)
    {
        temp[k] = Arr[j];
        k += 1;
        j += 1;
    }

    // copy temp to original interval
    for (i = start; i <= end; i += 1)
    {
        Arr[i] = temp[i - start];
    }
}
void merge_sort(int start, int end)
{

    if (start < end)
    {
        int mid = (start + end) / 2;
        merge_sort(start, mid);
        merge_sort(mid+1, end);
        merge_array(start, mid, end);
    }
    
}
// thread function for multi-threading
void *thread_merge(void *param)
{
    int thread_part = part++;
    int start = thread_part * (size / THREAD_MAX);
    int end = (thread_part + 1) * (size / THREAD_MAX)-1;
    if (start < end)
    {
        int mid = (start + end) / 2;
        merge_sort(start, mid);
        merge_sort(mid+1, end);
        merge_array(start, mid, end);
    }
    pthread_exit(0);
}
