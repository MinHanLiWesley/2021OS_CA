#define _SVID_SOURCE 1
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define MAX_SEQUENCE 10
// #define _DEBUG
typedef struct
{
   long fib_sequence[MAX_SEQUENCE];
   int sequence_size;
} shared_data;

long Fibo(int n)
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

   int shm_fd; // shared memory file descriptor
   size_t segment_size = sizeof(shared_data);
   const char *name = "shared_memory";
   //attach
   shm_fd = shm_open(name, O_CREAT | O_RDWR, 0666);
   if (shm_fd == -1)
   {
      perror("open");
      return 1;
   }
   if (ftruncate(shm_fd, segment_size) == -1)
   {
      perror("truncate");
      return 1;
   }

   // pointer to shared memory object
   shared_data *shptr = mmap(0, segment_size, PROT_WRITE, MAP_SHARED, shm_fd, 0);

   shptr->sequence_size = argc - 1;
   if (shptr->sequence_size > MAX_SEQUENCE)
   {
      shm_unlink(name);
      printf("Wrong length!\n");
      return 0;
   }
#ifdef _DEBUG
   printf("\nAllocating shared memory succcessfully! Now forking...\n");
#endif
   pid_t pid;
   pid = fork();
   int count = 0;
   if (pid == 0)
   {
#ifdef _DEBUG
      printf("Child %d executing...\n", getpid());
#endif
      for (int i = 1; i < argc; ++i)
      {
         if (atoi(argv[i]) >= 0)
         {

            // printf("%d: %d\n", i, atoi(argv[i]));
            long a = Fibo(atoi(argv[i]));
            shptr->fib_sequence[count] = a;
            count++;
         }
      }
      shptr->sequence_size = count;
      exit(0);
#ifdef _DEBUG
      printf("Child %d exiting...\n", getpid());
#endif

      // printf("pid=%d,ppid=%d: %d\n", getpid(), getppid(), Fibo(i));
   }
   else
   {
#ifdef _DEBUG
      printf("Parent %d waiting...\n", getpid());
#endif
      wait(NULL);
#ifdef _DEBUG
      printf("After waiting, now print the series...\n", getpid());
#endif
      for (size_t i = 0; i < shptr->sequence_size; i++)
      {
         printf("%ld\n", shptr->fib_sequence[i]);
      }
   }

   if (shm_unlink(name) == -1)
   {
      fprintf(stderr, "Unable to detach\n");
   }

   return 0;
}
