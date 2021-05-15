#include "kernel/types.h"
#include "user/setjmp.h"
#include "user/threads.h"
#include "user/user.h"
#define NULL 0


static struct thread* current_thread = NULL;
static int id = 1;
static jmp_buf env_st;
//static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
    //unsigned long stack_p = 0;
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
    t->arg = arg;
    t->ID  = id;
    t->buf_set = 0;
    t->stack = (void*) new_stack;
    t->stack_p = (void*) new_stack_p;
    id++;
    return t;
}
void thread_add_runqueue(struct thread *t){
    if(current_thread == NULL){
        current_thread = t;
        // When the second thread is added to LL
        // the 'previous' pointer will be used to make LL circular
        current_thread->previous = t;
        // When there is only 1 thread and it calls yield, 
        // the 'next' pointer will be used to pick next thread to execute('schedule')
        current_thread->next = t; 
    }
    else{
        current_thread->previous->next = t;
        t->previous = current_thread->previous;
        current_thread->previous = t;
        t->next = current_thread;
    }
}
void thread_yield(void){
    // Save current thread's context
    if(setjmp(current_thread->env)) {
        // if return from longjmp, directly return to resume thread execution
        return;
    }
    // Call 'schedule' to determine which thread to run
    schedule();
    // Call 'dispatch' to execute new thread
    dispatch();
}
void dispatch(void){
    // if thread doesn't executed before
    if(current_thread->buf_set == 0) {
        // initialize jump_buf of current thread
        if(setjmp(current_thread->env)) {
            // return from a longjmp means that process's sp is set
            // now we can execute current thread
            current_thread->fp(current_thread->arg);
            // In case the thread's funcion just returns, the thread needs to be 
            // removed from the runqueue and the next one has to be dispatched.
            thread_exit();
        }
        // set sp in jmp_buf, it will be used in longjmp to setup process's sp(in CPU register) later
        current_thread->env->sp = (unsigned long)current_thread->stack_p;
        current_thread->buf_set = 1;
        // use jmp_buf to setup process's sp(in CPU register)
        longjmp(current_thread->env, 1);
    }
    // if thread has executed
    else {
        // Load current thread's context
        longjmp(current_thread->env, 1);        
    }
}
void schedule(void){
    current_thread = current_thread->next;
}
void thread_exit(void){
    if(current_thread->next != current_thread){
        // free its stack
        free(current_thread->stack);

        // remove thread from CLL
        current_thread->next->previous = current_thread->previous;
        current_thread->previous->next = current_thread->next;

        // free current thread
        struct thread *next_thread = current_thread->next;
        free(current_thread);
        current_thread = next_thread;

        // Call 'dispatch' to execute new thread
        dispatch();
    }
    else{
        // No more thread to execute
        // free its stack
        free(current_thread->stack);

        // free current thread
        free(current_thread);
        current_thread = NULL;

        // jump back th thread_start_threading
        longjmp(env_st, 1);
    }
}
void thread_start_threading(void){   
    // return 0 means direct invocation
    // return 1 means last thread exist(return from a call to longjmp in thread_exit)
    if(setjmp(env_st)) 
        return;
    schedule();
    dispatch();
}
