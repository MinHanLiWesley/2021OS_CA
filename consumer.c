#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

// So we could use other sizes without editing the source.
#ifndef MAX_SEQUENCE
#define MAX_SEQUENCE 10
#endif

// Check that MAX_SEQUENCE is large enough!
#if MAX_SEQUENCE < 2
#error MAX_SEQUENCE must be at least 2
#endif

typedef struct
{
    long fib_sequence[MAX_SEQUENCE];
    int sequence_size;
} shared_data;

int main()
{
    int a, b, m, n, i;
    a = 0;
    b = 1;
    printf("Enter the number of a Fibonacci Sequence:\n");
    // Always check whether input conversion worked
    if (scanf("%d", &m) != 1)
    {
        printf("Invalid input, couldn't be converted.\n");
        return EXIT_FAILURE;
    }

    if (m <= 0)
    {
        printf("Please enter a positive integer\n");
        return EXIT_FAILURE; // exit if input is invalid
    }
    else if (m > MAX_SEQUENCE)
    {
        printf("Please enter an integer less than %d\n", MAX_SEQUENCE);
        return EXIT_FAILURE; // exit if input is invalid
    }

    /* the identifier for the shared memory segment */
    int segment_id;

    /* the size (in bytes) of the shared memory segment */
    size_t segment_size = sizeof(shared_data);

    /* allocate  a shared memory segment */
    segment_id = shmget(IPC_PRIVATE, segment_size, S_IRUSR | S_IWUSR);

    // Check result of shmget
    if (segment_id == -1)
    {
        perror("shmget failed");
        return EXIT_FAILURE;
    }

    /* attach the shared memory segment */
    shared_data *shptr = shmat(segment_id, NULL, 0);

    // Check whether attaching succeeded
    // if ((void *)shared_memory == (void *)-1)
    // {
    //     perror("shmat failed");
    //     goto destroy; // clean up
    // }
    printf("\nshared memory segment %d attached at address %p\n", segment_id, (void *)shptr);

    shptr->sequence_size = m;
    pid_t pid;
    pid = fork();
    if (pid == 0)
    {
        printf("Child is producing the Fibonacci Sequence...\n");
        shptr->fib_sequence[0] = a;
        shared_memory->fib_sequence[1] = b;
        for (i = 2; i < shared_memory->sequence_size; i++)
        {
            n = a + b;
            shared_memory->fib_sequence[i] = n;
            a = b;
            b = n;
        }
        printf("\nChild ends\n");
    }
    else
    {
        printf("Parent is waiting for child to complete...\n");
        wait(NULL);
        printf("Parent ends\n");
        for (i = 0; i < shared_memory->sequence_size; i++)
        {
            printf("%ld ", shared_memory->fib_sequence[i]);
        }
        printf("\n");
    }

    /* now detach the shared memory segment */
    if (shmdt(shared_memory) == -1)
    {
        fprintf(stderr, "Unable to detach\n");
    }

// destroy:
//     /* now remove the shared memory segment */
//     shmctl(segment_id, IPC_RMID, NULL);

    return 0;
}