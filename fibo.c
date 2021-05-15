#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

// #define _DEBUG
int Fibo(int n)
{
    if (n < 0)
        return 20;
    else if (n <= 1)
        return 1;
    else
        return Fibo(n - 1) + Fibo(n - 2);
}

int main(int argc, char *argv[])
{
    int pid = fork();

    if (pid == 0)
    {
#ifdef _DEBUG
        printf("Child %d executing..\n",getpid());
#endif
        for (size_t i = 1; i < argc; ++i)

        {
            if (atoi(argv[i]) >= 0)
            {
                printf("%d\n", Fibo(atoi(argv[i])));
            }
        }
#ifdef _DEBUG
        printf("Finish generation! Child %d exiting..\n",getpid());
#endif
        exit(0);
    }
    else
    {
#ifdef _DEBUG
        printf("parent pid=%d waiting..\n", getpid());
#endif
        wait(NULL);
    }
#ifdef _DEBUG
    printf("After waiting!\n");
#endif

    return 0;
}