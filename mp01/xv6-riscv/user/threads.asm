
user/_threads:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_create>:
static struct thread* current_thread = NULL;
static int id = 1;
static jmp_buf env_st;
//static jmp_buf env_tmp;

struct thread *thread_create(void (*f)(void *), void *arg){
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  10:	892e                	mv	s2,a1
    struct thread *t = (struct thread*) malloc(sizeof(struct thread));
  12:	0a800513          	li	a0,168
  16:	00001097          	auipc	ra,0x1
  1a:	8aa080e7          	jalr	-1878(ra) # 8c0 <malloc>
  1e:	84aa                	mv	s1,a0
    //unsigned long stack_p = 0;
    unsigned long new_stack_p;
    unsigned long new_stack;
    new_stack = (unsigned long) malloc(sizeof(unsigned long)*0x100);
  20:	6505                	lui	a0,0x1
  22:	80050513          	addi	a0,a0,-2048 # 800 <fprintf+0x2c>
  26:	00001097          	auipc	ra,0x1
  2a:	89a080e7          	jalr	-1894(ra) # 8c0 <malloc>
    new_stack_p = new_stack +0x100*8-0x2*8;
    t->fp = f;
  2e:	0134b023          	sd	s3,0(s1)
    t->arg = arg;
  32:	0124b423          	sd	s2,8(s1)
    t->ID  = id;
  36:	00001717          	auipc	a4,0x1
  3a:	a0670713          	addi	a4,a4,-1530 # a3c <id>
  3e:	431c                	lw	a5,0(a4)
  40:	08f4a823          	sw	a5,144(s1)
    t->buf_set = 0;
  44:	0804aa23          	sw	zero,148(s1)
    t->stack = (void*) new_stack;
  48:	e888                	sd	a0,16(s1)
    new_stack_p = new_stack +0x100*8-0x2*8;
  4a:	7f050513          	addi	a0,a0,2032
    t->stack_p = (void*) new_stack_p;
  4e:	ec88                	sd	a0,24(s1)
    id++;
  50:	2785                	addiw	a5,a5,1
  52:	c31c                	sw	a5,0(a4)
    return t;
}
  54:	8526                	mv	a0,s1
  56:	70a2                	ld	ra,40(sp)
  58:	7402                	ld	s0,32(sp)
  5a:	64e2                	ld	s1,24(sp)
  5c:	6942                	ld	s2,16(sp)
  5e:	69a2                	ld	s3,8(sp)
  60:	6145                	addi	sp,sp,48
  62:	8082                	ret

0000000000000064 <thread_add_runqueue>:
void thread_add_runqueue(struct thread *t){
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
    if(current_thread == NULL){
  6a:	00001797          	auipc	a5,0x1
  6e:	9d67b783          	ld	a5,-1578(a5) # a40 <current_thread>
  72:	cb91                	beqz	a5,86 <thread_add_runqueue+0x22>
        // When there is only 1 thread and it calls yield, 
        // the 'next' pointer will be used to pick next thread to execute('schedule')
        current_thread->next = t; 
    }
    else{
        current_thread->previous->next = t;
  74:	6fd8                	ld	a4,152(a5)
  76:	f348                	sd	a0,160(a4)
        t->previous = current_thread->previous;
  78:	6fd8                	ld	a4,152(a5)
  7a:	ed58                	sd	a4,152(a0)
        current_thread->previous = t;
  7c:	efc8                	sd	a0,152(a5)
        t->next = current_thread;
  7e:	f15c                	sd	a5,160(a0)
    }
}
  80:	6422                	ld	s0,8(sp)
  82:	0141                	addi	sp,sp,16
  84:	8082                	ret
        current_thread = t;
  86:	00001797          	auipc	a5,0x1
  8a:	9aa7bd23          	sd	a0,-1606(a5) # a40 <current_thread>
        current_thread->previous = t;
  8e:	ed48                	sd	a0,152(a0)
        current_thread->next = t; 
  90:	f148                	sd	a0,160(a0)
  92:	b7fd                	j	80 <thread_add_runqueue+0x1c>

0000000000000094 <schedule>:
    else {
        // Load current thread's context
        longjmp(current_thread->env, 1);        
    }
}
void schedule(void){
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
    current_thread = current_thread->next;
  9a:	00001797          	auipc	a5,0x1
  9e:	9a678793          	addi	a5,a5,-1626 # a40 <current_thread>
  a2:	6398                	ld	a4,0(a5)
  a4:	7358                	ld	a4,160(a4)
  a6:	e398                	sd	a4,0(a5)
}
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <thread_exit>:
void thread_exit(void){
  ae:	1101                	addi	sp,sp,-32
  b0:	ec06                	sd	ra,24(sp)
  b2:	e822                	sd	s0,16(sp)
  b4:	e426                	sd	s1,8(sp)
  b6:	e04a                	sd	s2,0(sp)
  b8:	1000                	addi	s0,sp,32
    if(current_thread->next != current_thread){
  ba:	00001797          	auipc	a5,0x1
  be:	9867b783          	ld	a5,-1658(a5) # a40 <current_thread>
  c2:	73d8                	ld	a4,160(a5)
  c4:	04e78363          	beq	a5,a4,10a <thread_exit+0x5c>
        // free its stack
        free(current_thread->stack);
  c8:	6b88                	ld	a0,16(a5)
  ca:	00000097          	auipc	ra,0x0
  ce:	76e080e7          	jalr	1902(ra) # 838 <free>

        // remove thread from CLL
        current_thread->next->previous = current_thread->previous;
  d2:	00001497          	auipc	s1,0x1
  d6:	96e48493          	addi	s1,s1,-1682 # a40 <current_thread>
  da:	6088                	ld	a0,0(s1)
  dc:	7158                	ld	a4,160(a0)
  de:	6d5c                	ld	a5,152(a0)
  e0:	ef5c                	sd	a5,152(a4)
        current_thread->previous->next = current_thread->next;
  e2:	0a053903          	ld	s2,160(a0)
  e6:	0b27b023          	sd	s2,160(a5)

        // free current thread
        struct thread *next_thread = current_thread->next;
        free(current_thread);
  ea:	00000097          	auipc	ra,0x0
  ee:	74e080e7          	jalr	1870(ra) # 838 <free>
        current_thread = next_thread;
  f2:	0124b023          	sd	s2,0(s1)

        // Call 'dispatch' to execute new thread
        dispatch();
  f6:	00000097          	auipc	ra,0x0
  fa:	048080e7          	jalr	72(ra) # 13e <dispatch>
        current_thread = NULL;

        // jump back th thread_start_threading
        longjmp(env_st, 1);
    }
}
  fe:	60e2                	ld	ra,24(sp)
 100:	6442                	ld	s0,16(sp)
 102:	64a2                	ld	s1,8(sp)
 104:	6902                	ld	s2,0(sp)
 106:	6105                	addi	sp,sp,32
 108:	8082                	ret
        free(current_thread->stack);
 10a:	6b88                	ld	a0,16(a5)
 10c:	00000097          	auipc	ra,0x0
 110:	72c080e7          	jalr	1836(ra) # 838 <free>
        free(current_thread);
 114:	00001497          	auipc	s1,0x1
 118:	92c48493          	addi	s1,s1,-1748 # a40 <current_thread>
 11c:	6088                	ld	a0,0(s1)
 11e:	00000097          	auipc	ra,0x0
 122:	71a080e7          	jalr	1818(ra) # 838 <free>
        current_thread = NULL;
 126:	0004b023          	sd	zero,0(s1)
        longjmp(env_st, 1);
 12a:	4585                	li	a1,1
 12c:	00001517          	auipc	a0,0x1
 130:	92450513          	addi	a0,a0,-1756 # a50 <env_st>
 134:	00001097          	auipc	ra,0x1
 138:	8a8080e7          	jalr	-1880(ra) # 9dc <longjmp>
}
 13c:	b7c9                	j	fe <thread_exit+0x50>

000000000000013e <dispatch>:
void dispatch(void){
 13e:	1141                	addi	sp,sp,-16
 140:	e406                	sd	ra,8(sp)
 142:	e022                	sd	s0,0(sp)
 144:	0800                	addi	s0,sp,16
    if(current_thread->buf_set == 0) {
 146:	00001517          	auipc	a0,0x1
 14a:	8fa53503          	ld	a0,-1798(a0) # a40 <current_thread>
 14e:	09452783          	lw	a5,148(a0)
 152:	e7b9                	bnez	a5,1a0 <dispatch+0x62>
        if(setjmp(current_thread->env)) {
 154:	02050513          	addi	a0,a0,32
 158:	00001097          	auipc	ra,0x1
 15c:	84c080e7          	jalr	-1972(ra) # 9a4 <setjmp>
 160:	cd01                	beqz	a0,178 <dispatch+0x3a>
            current_thread->fp(current_thread->arg);
 162:	00001797          	auipc	a5,0x1
 166:	8de7b783          	ld	a5,-1826(a5) # a40 <current_thread>
 16a:	6398                	ld	a4,0(a5)
 16c:	6788                	ld	a0,8(a5)
 16e:	9702                	jalr	a4
            thread_exit();
 170:	00000097          	auipc	ra,0x0
 174:	f3e080e7          	jalr	-194(ra) # ae <thread_exit>
        current_thread->env->sp = (unsigned long)current_thread->stack_p;
 178:	00001517          	auipc	a0,0x1
 17c:	8c853503          	ld	a0,-1848(a0) # a40 <current_thread>
 180:	6d1c                	ld	a5,24(a0)
 182:	e55c                	sd	a5,136(a0)
        current_thread->buf_set = 1;
 184:	4785                	li	a5,1
 186:	08f52a23          	sw	a5,148(a0)
        longjmp(current_thread->env, 1);
 18a:	4585                	li	a1,1
 18c:	02050513          	addi	a0,a0,32
 190:	00001097          	auipc	ra,0x1
 194:	84c080e7          	jalr	-1972(ra) # 9dc <longjmp>
}
 198:	60a2                	ld	ra,8(sp)
 19a:	6402                	ld	s0,0(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret
        longjmp(current_thread->env, 1);        
 1a0:	4585                	li	a1,1
 1a2:	02050513          	addi	a0,a0,32
 1a6:	00001097          	auipc	ra,0x1
 1aa:	836080e7          	jalr	-1994(ra) # 9dc <longjmp>
}
 1ae:	b7ed                	j	198 <dispatch+0x5a>

00000000000001b0 <thread_yield>:
void thread_yield(void){
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e406                	sd	ra,8(sp)
 1b4:	e022                	sd	s0,0(sp)
 1b6:	0800                	addi	s0,sp,16
    if(setjmp(current_thread->env)) {
 1b8:	00001517          	auipc	a0,0x1
 1bc:	88853503          	ld	a0,-1912(a0) # a40 <current_thread>
 1c0:	02050513          	addi	a0,a0,32
 1c4:	00000097          	auipc	ra,0x0
 1c8:	7e0080e7          	jalr	2016(ra) # 9a4 <setjmp>
 1cc:	c509                	beqz	a0,1d6 <thread_yield+0x26>
}
 1ce:	60a2                	ld	ra,8(sp)
 1d0:	6402                	ld	s0,0(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
    schedule();
 1d6:	00000097          	auipc	ra,0x0
 1da:	ebe080e7          	jalr	-322(ra) # 94 <schedule>
    dispatch();
 1de:	00000097          	auipc	ra,0x0
 1e2:	f60080e7          	jalr	-160(ra) # 13e <dispatch>
 1e6:	b7e5                	j	1ce <thread_yield+0x1e>

00000000000001e8 <thread_start_threading>:
void thread_start_threading(void){   
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e406                	sd	ra,8(sp)
 1ec:	e022                	sd	s0,0(sp)
 1ee:	0800                	addi	s0,sp,16
    // return 0 means direct invocation
    // return 1 means last thread exist(return from a call to longjmp in thread_exit)
    if(setjmp(env_st)) 
 1f0:	00001517          	auipc	a0,0x1
 1f4:	86050513          	addi	a0,a0,-1952 # a50 <env_st>
 1f8:	00000097          	auipc	ra,0x0
 1fc:	7ac080e7          	jalr	1964(ra) # 9a4 <setjmp>
 200:	c509                	beqz	a0,20a <thread_start_threading+0x22>
        return;
    schedule();
    dispatch();
}
 202:	60a2                	ld	ra,8(sp)
 204:	6402                	ld	s0,0(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret
    schedule();
 20a:	00000097          	auipc	ra,0x0
 20e:	e8a080e7          	jalr	-374(ra) # 94 <schedule>
    dispatch();
 212:	00000097          	auipc	ra,0x0
 216:	f2c080e7          	jalr	-212(ra) # 13e <dispatch>
 21a:	b7e5                	j	202 <thread_start_threading+0x1a>

000000000000021c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 222:	87aa                	mv	a5,a0
 224:	0585                	addi	a1,a1,1
 226:	0785                	addi	a5,a5,1
 228:	fff5c703          	lbu	a4,-1(a1)
 22c:	fee78fa3          	sb	a4,-1(a5)
 230:	fb75                	bnez	a4,224 <strcpy+0x8>
    ;
  return os;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret

0000000000000238 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 23e:	00054783          	lbu	a5,0(a0)
 242:	cb91                	beqz	a5,256 <strcmp+0x1e>
 244:	0005c703          	lbu	a4,0(a1)
 248:	00f71763          	bne	a4,a5,256 <strcmp+0x1e>
    p++, q++;
 24c:	0505                	addi	a0,a0,1
 24e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 250:	00054783          	lbu	a5,0(a0)
 254:	fbe5                	bnez	a5,244 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 256:	0005c503          	lbu	a0,0(a1)
}
 25a:	40a7853b          	subw	a0,a5,a0
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret

0000000000000264 <strlen>:

uint
strlen(const char *s)
{
 264:	1141                	addi	sp,sp,-16
 266:	e422                	sd	s0,8(sp)
 268:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 26a:	00054783          	lbu	a5,0(a0)
 26e:	cf91                	beqz	a5,28a <strlen+0x26>
 270:	0505                	addi	a0,a0,1
 272:	87aa                	mv	a5,a0
 274:	4685                	li	a3,1
 276:	9e89                	subw	a3,a3,a0
 278:	00f6853b          	addw	a0,a3,a5
 27c:	0785                	addi	a5,a5,1
 27e:	fff7c703          	lbu	a4,-1(a5)
 282:	fb7d                	bnez	a4,278 <strlen+0x14>
    ;
  return n;
}
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret
  for(n = 0; s[n]; n++)
 28a:	4501                	li	a0,0
 28c:	bfe5                	j	284 <strlen+0x20>

000000000000028e <memset>:

void*
memset(void *dst, int c, uint n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 294:	ca19                	beqz	a2,2aa <memset+0x1c>
 296:	87aa                	mv	a5,a0
 298:	1602                	slli	a2,a2,0x20
 29a:	9201                	srli	a2,a2,0x20
 29c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2a4:	0785                	addi	a5,a5,1
 2a6:	fee79de3          	bne	a5,a4,2a0 <memset+0x12>
  }
  return dst;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret

00000000000002b0 <strchr>:

char*
strchr(const char *s, char c)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e422                	sd	s0,8(sp)
 2b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2b6:	00054783          	lbu	a5,0(a0)
 2ba:	cb99                	beqz	a5,2d0 <strchr+0x20>
    if(*s == c)
 2bc:	00f58763          	beq	a1,a5,2ca <strchr+0x1a>
  for(; *s; s++)
 2c0:	0505                	addi	a0,a0,1
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	fbfd                	bnez	a5,2bc <strchr+0xc>
      return (char*)s;
  return 0;
 2c8:	4501                	li	a0,0
}
 2ca:	6422                	ld	s0,8(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret
  return 0;
 2d0:	4501                	li	a0,0
 2d2:	bfe5                	j	2ca <strchr+0x1a>

00000000000002d4 <gets>:

char*
gets(char *buf, int max)
{
 2d4:	711d                	addi	sp,sp,-96
 2d6:	ec86                	sd	ra,88(sp)
 2d8:	e8a2                	sd	s0,80(sp)
 2da:	e4a6                	sd	s1,72(sp)
 2dc:	e0ca                	sd	s2,64(sp)
 2de:	fc4e                	sd	s3,56(sp)
 2e0:	f852                	sd	s4,48(sp)
 2e2:	f456                	sd	s5,40(sp)
 2e4:	f05a                	sd	s6,32(sp)
 2e6:	ec5e                	sd	s7,24(sp)
 2e8:	1080                	addi	s0,sp,96
 2ea:	8baa                	mv	s7,a0
 2ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ee:	892a                	mv	s2,a0
 2f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2f2:	4aa9                	li	s5,10
 2f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2f6:	89a6                	mv	s3,s1
 2f8:	2485                	addiw	s1,s1,1
 2fa:	0344d863          	bge	s1,s4,32a <gets+0x56>
    cc = read(0, &c, 1);
 2fe:	4605                	li	a2,1
 300:	faf40593          	addi	a1,s0,-81
 304:	4501                	li	a0,0
 306:	00000097          	auipc	ra,0x0
 30a:	19c080e7          	jalr	412(ra) # 4a2 <read>
    if(cc < 1)
 30e:	00a05e63          	blez	a0,32a <gets+0x56>
    buf[i++] = c;
 312:	faf44783          	lbu	a5,-81(s0)
 316:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 31a:	01578763          	beq	a5,s5,328 <gets+0x54>
 31e:	0905                	addi	s2,s2,1
 320:	fd679be3          	bne	a5,s6,2f6 <gets+0x22>
  for(i=0; i+1 < max; ){
 324:	89a6                	mv	s3,s1
 326:	a011                	j	32a <gets+0x56>
 328:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 32a:	99de                	add	s3,s3,s7
 32c:	00098023          	sb	zero,0(s3)
  return buf;
}
 330:	855e                	mv	a0,s7
 332:	60e6                	ld	ra,88(sp)
 334:	6446                	ld	s0,80(sp)
 336:	64a6                	ld	s1,72(sp)
 338:	6906                	ld	s2,64(sp)
 33a:	79e2                	ld	s3,56(sp)
 33c:	7a42                	ld	s4,48(sp)
 33e:	7aa2                	ld	s5,40(sp)
 340:	7b02                	ld	s6,32(sp)
 342:	6be2                	ld	s7,24(sp)
 344:	6125                	addi	sp,sp,96
 346:	8082                	ret

0000000000000348 <stat>:

int
stat(const char *n, struct stat *st)
{
 348:	1101                	addi	sp,sp,-32
 34a:	ec06                	sd	ra,24(sp)
 34c:	e822                	sd	s0,16(sp)
 34e:	e426                	sd	s1,8(sp)
 350:	e04a                	sd	s2,0(sp)
 352:	1000                	addi	s0,sp,32
 354:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 356:	4581                	li	a1,0
 358:	00000097          	auipc	ra,0x0
 35c:	172080e7          	jalr	370(ra) # 4ca <open>
  if(fd < 0)
 360:	02054563          	bltz	a0,38a <stat+0x42>
 364:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 366:	85ca                	mv	a1,s2
 368:	00000097          	auipc	ra,0x0
 36c:	17a080e7          	jalr	378(ra) # 4e2 <fstat>
 370:	892a                	mv	s2,a0
  close(fd);
 372:	8526                	mv	a0,s1
 374:	00000097          	auipc	ra,0x0
 378:	13e080e7          	jalr	318(ra) # 4b2 <close>
  return r;
}
 37c:	854a                	mv	a0,s2
 37e:	60e2                	ld	ra,24(sp)
 380:	6442                	ld	s0,16(sp)
 382:	64a2                	ld	s1,8(sp)
 384:	6902                	ld	s2,0(sp)
 386:	6105                	addi	sp,sp,32
 388:	8082                	ret
    return -1;
 38a:	597d                	li	s2,-1
 38c:	bfc5                	j	37c <stat+0x34>

000000000000038e <atoi>:

int
atoi(const char *s)
{
 38e:	1141                	addi	sp,sp,-16
 390:	e422                	sd	s0,8(sp)
 392:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 394:	00054603          	lbu	a2,0(a0)
 398:	fd06079b          	addiw	a5,a2,-48
 39c:	0ff7f793          	andi	a5,a5,255
 3a0:	4725                	li	a4,9
 3a2:	02f76963          	bltu	a4,a5,3d4 <atoi+0x46>
 3a6:	86aa                	mv	a3,a0
  n = 0;
 3a8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3aa:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3ac:	0685                	addi	a3,a3,1
 3ae:	0025179b          	slliw	a5,a0,0x2
 3b2:	9fa9                	addw	a5,a5,a0
 3b4:	0017979b          	slliw	a5,a5,0x1
 3b8:	9fb1                	addw	a5,a5,a2
 3ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3be:	0006c603          	lbu	a2,0(a3)
 3c2:	fd06071b          	addiw	a4,a2,-48
 3c6:	0ff77713          	andi	a4,a4,255
 3ca:	fee5f1e3          	bgeu	a1,a4,3ac <atoi+0x1e>
  return n;
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret
  n = 0;
 3d4:	4501                	li	a0,0
 3d6:	bfe5                	j	3ce <atoi+0x40>

00000000000003d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e422                	sd	s0,8(sp)
 3dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3de:	02b57463          	bgeu	a0,a1,406 <memmove+0x2e>
    while(n-- > 0)
 3e2:	00c05f63          	blez	a2,400 <memmove+0x28>
 3e6:	1602                	slli	a2,a2,0x20
 3e8:	9201                	srli	a2,a2,0x20
 3ea:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ee:	872a                	mv	a4,a0
      *dst++ = *src++;
 3f0:	0585                	addi	a1,a1,1
 3f2:	0705                	addi	a4,a4,1
 3f4:	fff5c683          	lbu	a3,-1(a1)
 3f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3fc:	fee79ae3          	bne	a5,a4,3f0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 400:	6422                	ld	s0,8(sp)
 402:	0141                	addi	sp,sp,16
 404:	8082                	ret
    dst += n;
 406:	00c50733          	add	a4,a0,a2
    src += n;
 40a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 40c:	fec05ae3          	blez	a2,400 <memmove+0x28>
 410:	fff6079b          	addiw	a5,a2,-1
 414:	1782                	slli	a5,a5,0x20
 416:	9381                	srli	a5,a5,0x20
 418:	fff7c793          	not	a5,a5
 41c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 41e:	15fd                	addi	a1,a1,-1
 420:	177d                	addi	a4,a4,-1
 422:	0005c683          	lbu	a3,0(a1)
 426:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 42a:	fee79ae3          	bne	a5,a4,41e <memmove+0x46>
 42e:	bfc9                	j	400 <memmove+0x28>

0000000000000430 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 430:	1141                	addi	sp,sp,-16
 432:	e422                	sd	s0,8(sp)
 434:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 436:	ca05                	beqz	a2,466 <memcmp+0x36>
 438:	fff6069b          	addiw	a3,a2,-1
 43c:	1682                	slli	a3,a3,0x20
 43e:	9281                	srli	a3,a3,0x20
 440:	0685                	addi	a3,a3,1
 442:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 444:	00054783          	lbu	a5,0(a0)
 448:	0005c703          	lbu	a4,0(a1)
 44c:	00e79863          	bne	a5,a4,45c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 450:	0505                	addi	a0,a0,1
    p2++;
 452:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 454:	fed518e3          	bne	a0,a3,444 <memcmp+0x14>
  }
  return 0;
 458:	4501                	li	a0,0
 45a:	a019                	j	460 <memcmp+0x30>
      return *p1 - *p2;
 45c:	40e7853b          	subw	a0,a5,a4
}
 460:	6422                	ld	s0,8(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret
  return 0;
 466:	4501                	li	a0,0
 468:	bfe5                	j	460 <memcmp+0x30>

000000000000046a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e406                	sd	ra,8(sp)
 46e:	e022                	sd	s0,0(sp)
 470:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 472:	00000097          	auipc	ra,0x0
 476:	f66080e7          	jalr	-154(ra) # 3d8 <memmove>
}
 47a:	60a2                	ld	ra,8(sp)
 47c:	6402                	ld	s0,0(sp)
 47e:	0141                	addi	sp,sp,16
 480:	8082                	ret

0000000000000482 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 482:	4885                	li	a7,1
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <exit>:
.global exit
exit:
 li a7, SYS_exit
 48a:	4889                	li	a7,2
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <wait>:
.global wait
wait:
 li a7, SYS_wait
 492:	488d                	li	a7,3
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 49a:	4891                	li	a7,4
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <read>:
.global read
read:
 li a7, SYS_read
 4a2:	4895                	li	a7,5
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <write>:
.global write
write:
 li a7, SYS_write
 4aa:	48c1                	li	a7,16
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <close>:
.global close
close:
 li a7, SYS_close
 4b2:	48d5                	li	a7,21
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ba:	4899                	li	a7,6
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c2:	489d                	li	a7,7
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <open>:
.global open
open:
 li a7, SYS_open
 4ca:	48bd                	li	a7,15
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d2:	48c5                	li	a7,17
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4da:	48c9                	li	a7,18
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e2:	48a1                	li	a7,8
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <link>:
.global link
link:
 li a7, SYS_link
 4ea:	48cd                	li	a7,19
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f2:	48d1                	li	a7,20
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4fa:	48a5                	li	a7,9
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <dup>:
.global dup
dup:
 li a7, SYS_dup
 502:	48a9                	li	a7,10
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 50a:	48ad                	li	a7,11
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 512:	48b1                	li	a7,12
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 51a:	48b5                	li	a7,13
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 522:	48b9                	li	a7,14
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 52a:	1101                	addi	sp,sp,-32
 52c:	ec06                	sd	ra,24(sp)
 52e:	e822                	sd	s0,16(sp)
 530:	1000                	addi	s0,sp,32
 532:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 536:	4605                	li	a2,1
 538:	fef40593          	addi	a1,s0,-17
 53c:	00000097          	auipc	ra,0x0
 540:	f6e080e7          	jalr	-146(ra) # 4aa <write>
}
 544:	60e2                	ld	ra,24(sp)
 546:	6442                	ld	s0,16(sp)
 548:	6105                	addi	sp,sp,32
 54a:	8082                	ret

000000000000054c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 54c:	7139                	addi	sp,sp,-64
 54e:	fc06                	sd	ra,56(sp)
 550:	f822                	sd	s0,48(sp)
 552:	f426                	sd	s1,40(sp)
 554:	f04a                	sd	s2,32(sp)
 556:	ec4e                	sd	s3,24(sp)
 558:	0080                	addi	s0,sp,64
 55a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 55c:	c299                	beqz	a3,562 <printint+0x16>
 55e:	0805c863          	bltz	a1,5ee <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 562:	2581                	sext.w	a1,a1
  neg = 0;
 564:	4881                	li	a7,0
 566:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 56a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 56c:	2601                	sext.w	a2,a2
 56e:	00000517          	auipc	a0,0x0
 572:	4ba50513          	addi	a0,a0,1210 # a28 <digits>
 576:	883a                	mv	a6,a4
 578:	2705                	addiw	a4,a4,1
 57a:	02c5f7bb          	remuw	a5,a1,a2
 57e:	1782                	slli	a5,a5,0x20
 580:	9381                	srli	a5,a5,0x20
 582:	97aa                	add	a5,a5,a0
 584:	0007c783          	lbu	a5,0(a5)
 588:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 58c:	0005879b          	sext.w	a5,a1
 590:	02c5d5bb          	divuw	a1,a1,a2
 594:	0685                	addi	a3,a3,1
 596:	fec7f0e3          	bgeu	a5,a2,576 <printint+0x2a>
  if(neg)
 59a:	00088b63          	beqz	a7,5b0 <printint+0x64>
    buf[i++] = '-';
 59e:	fd040793          	addi	a5,s0,-48
 5a2:	973e                	add	a4,a4,a5
 5a4:	02d00793          	li	a5,45
 5a8:	fef70823          	sb	a5,-16(a4)
 5ac:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5b0:	02e05863          	blez	a4,5e0 <printint+0x94>
 5b4:	fc040793          	addi	a5,s0,-64
 5b8:	00e78933          	add	s2,a5,a4
 5bc:	fff78993          	addi	s3,a5,-1
 5c0:	99ba                	add	s3,s3,a4
 5c2:	377d                	addiw	a4,a4,-1
 5c4:	1702                	slli	a4,a4,0x20
 5c6:	9301                	srli	a4,a4,0x20
 5c8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5cc:	fff94583          	lbu	a1,-1(s2)
 5d0:	8526                	mv	a0,s1
 5d2:	00000097          	auipc	ra,0x0
 5d6:	f58080e7          	jalr	-168(ra) # 52a <putc>
  while(--i >= 0)
 5da:	197d                	addi	s2,s2,-1
 5dc:	ff3918e3          	bne	s2,s3,5cc <printint+0x80>
}
 5e0:	70e2                	ld	ra,56(sp)
 5e2:	7442                	ld	s0,48(sp)
 5e4:	74a2                	ld	s1,40(sp)
 5e6:	7902                	ld	s2,32(sp)
 5e8:	69e2                	ld	s3,24(sp)
 5ea:	6121                	addi	sp,sp,64
 5ec:	8082                	ret
    x = -xx;
 5ee:	40b005bb          	negw	a1,a1
    neg = 1;
 5f2:	4885                	li	a7,1
    x = -xx;
 5f4:	bf8d                	j	566 <printint+0x1a>

00000000000005f6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5f6:	7119                	addi	sp,sp,-128
 5f8:	fc86                	sd	ra,120(sp)
 5fa:	f8a2                	sd	s0,112(sp)
 5fc:	f4a6                	sd	s1,104(sp)
 5fe:	f0ca                	sd	s2,96(sp)
 600:	ecce                	sd	s3,88(sp)
 602:	e8d2                	sd	s4,80(sp)
 604:	e4d6                	sd	s5,72(sp)
 606:	e0da                	sd	s6,64(sp)
 608:	fc5e                	sd	s7,56(sp)
 60a:	f862                	sd	s8,48(sp)
 60c:	f466                	sd	s9,40(sp)
 60e:	f06a                	sd	s10,32(sp)
 610:	ec6e                	sd	s11,24(sp)
 612:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 614:	0005c903          	lbu	s2,0(a1)
 618:	18090f63          	beqz	s2,7b6 <vprintf+0x1c0>
 61c:	8aaa                	mv	s5,a0
 61e:	8b32                	mv	s6,a2
 620:	00158493          	addi	s1,a1,1
  state = 0;
 624:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 626:	02500a13          	li	s4,37
      if(c == 'd'){
 62a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 62e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 632:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 636:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63a:	00000b97          	auipc	s7,0x0
 63e:	3eeb8b93          	addi	s7,s7,1006 # a28 <digits>
 642:	a839                	j	660 <vprintf+0x6a>
        putc(fd, c);
 644:	85ca                	mv	a1,s2
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	ee2080e7          	jalr	-286(ra) # 52a <putc>
 650:	a019                	j	656 <vprintf+0x60>
    } else if(state == '%'){
 652:	01498f63          	beq	s3,s4,670 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 656:	0485                	addi	s1,s1,1
 658:	fff4c903          	lbu	s2,-1(s1)
 65c:	14090d63          	beqz	s2,7b6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 660:	0009079b          	sext.w	a5,s2
    if(state == 0){
 664:	fe0997e3          	bnez	s3,652 <vprintf+0x5c>
      if(c == '%'){
 668:	fd479ee3          	bne	a5,s4,644 <vprintf+0x4e>
        state = '%';
 66c:	89be                	mv	s3,a5
 66e:	b7e5                	j	656 <vprintf+0x60>
      if(c == 'd'){
 670:	05878063          	beq	a5,s8,6b0 <vprintf+0xba>
      } else if(c == 'l') {
 674:	05978c63          	beq	a5,s9,6cc <vprintf+0xd6>
      } else if(c == 'x') {
 678:	07a78863          	beq	a5,s10,6e8 <vprintf+0xf2>
      } else if(c == 'p') {
 67c:	09b78463          	beq	a5,s11,704 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 680:	07300713          	li	a4,115
 684:	0ce78663          	beq	a5,a4,750 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 688:	06300713          	li	a4,99
 68c:	0ee78e63          	beq	a5,a4,788 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 690:	11478863          	beq	a5,s4,7a0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 694:	85d2                	mv	a1,s4
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	e92080e7          	jalr	-366(ra) # 52a <putc>
        putc(fd, c);
 6a0:	85ca                	mv	a1,s2
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	e86080e7          	jalr	-378(ra) # 52a <putc>
      }
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	b765                	j	656 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6b0:	008b0913          	addi	s2,s6,8
 6b4:	4685                	li	a3,1
 6b6:	4629                	li	a2,10
 6b8:	000b2583          	lw	a1,0(s6)
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	e8e080e7          	jalr	-370(ra) # 54c <printint>
 6c6:	8b4a                	mv	s6,s2
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b771                	j	656 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6cc:	008b0913          	addi	s2,s6,8
 6d0:	4681                	li	a3,0
 6d2:	4629                	li	a2,10
 6d4:	000b2583          	lw	a1,0(s6)
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	e72080e7          	jalr	-398(ra) # 54c <printint>
 6e2:	8b4a                	mv	s6,s2
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bf85                	j	656 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6e8:	008b0913          	addi	s2,s6,8
 6ec:	4681                	li	a3,0
 6ee:	4641                	li	a2,16
 6f0:	000b2583          	lw	a1,0(s6)
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e56080e7          	jalr	-426(ra) # 54c <printint>
 6fe:	8b4a                	mv	s6,s2
      state = 0;
 700:	4981                	li	s3,0
 702:	bf91                	j	656 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 704:	008b0793          	addi	a5,s6,8
 708:	f8f43423          	sd	a5,-120(s0)
 70c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 710:	03000593          	li	a1,48
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	e14080e7          	jalr	-492(ra) # 52a <putc>
  putc(fd, 'x');
 71e:	85ea                	mv	a1,s10
 720:	8556                	mv	a0,s5
 722:	00000097          	auipc	ra,0x0
 726:	e08080e7          	jalr	-504(ra) # 52a <putc>
 72a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 72c:	03c9d793          	srli	a5,s3,0x3c
 730:	97de                	add	a5,a5,s7
 732:	0007c583          	lbu	a1,0(a5)
 736:	8556                	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	df2080e7          	jalr	-526(ra) # 52a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 740:	0992                	slli	s3,s3,0x4
 742:	397d                	addiw	s2,s2,-1
 744:	fe0914e3          	bnez	s2,72c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 748:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b721                	j	656 <vprintf+0x60>
        s = va_arg(ap, char*);
 750:	008b0993          	addi	s3,s6,8
 754:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 758:	02090163          	beqz	s2,77a <vprintf+0x184>
        while(*s != 0){
 75c:	00094583          	lbu	a1,0(s2)
 760:	c9a1                	beqz	a1,7b0 <vprintf+0x1ba>
          putc(fd, *s);
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	dc6080e7          	jalr	-570(ra) # 52a <putc>
          s++;
 76c:	0905                	addi	s2,s2,1
        while(*s != 0){
 76e:	00094583          	lbu	a1,0(s2)
 772:	f9e5                	bnez	a1,762 <vprintf+0x16c>
        s = va_arg(ap, char*);
 774:	8b4e                	mv	s6,s3
      state = 0;
 776:	4981                	li	s3,0
 778:	bdf9                	j	656 <vprintf+0x60>
          s = "(null)";
 77a:	00000917          	auipc	s2,0x0
 77e:	2a690913          	addi	s2,s2,678 # a20 <longjmp_1+0xa>
        while(*s != 0){
 782:	02800593          	li	a1,40
 786:	bff1                	j	762 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 788:	008b0913          	addi	s2,s6,8
 78c:	000b4583          	lbu	a1,0(s6)
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	d98080e7          	jalr	-616(ra) # 52a <putc>
 79a:	8b4a                	mv	s6,s2
      state = 0;
 79c:	4981                	li	s3,0
 79e:	bd65                	j	656 <vprintf+0x60>
        putc(fd, c);
 7a0:	85d2                	mv	a1,s4
 7a2:	8556                	mv	a0,s5
 7a4:	00000097          	auipc	ra,0x0
 7a8:	d86080e7          	jalr	-634(ra) # 52a <putc>
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	b565                	j	656 <vprintf+0x60>
        s = va_arg(ap, char*);
 7b0:	8b4e                	mv	s6,s3
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	b54d                	j	656 <vprintf+0x60>
    }
  }
}
 7b6:	70e6                	ld	ra,120(sp)
 7b8:	7446                	ld	s0,112(sp)
 7ba:	74a6                	ld	s1,104(sp)
 7bc:	7906                	ld	s2,96(sp)
 7be:	69e6                	ld	s3,88(sp)
 7c0:	6a46                	ld	s4,80(sp)
 7c2:	6aa6                	ld	s5,72(sp)
 7c4:	6b06                	ld	s6,64(sp)
 7c6:	7be2                	ld	s7,56(sp)
 7c8:	7c42                	ld	s8,48(sp)
 7ca:	7ca2                	ld	s9,40(sp)
 7cc:	7d02                	ld	s10,32(sp)
 7ce:	6de2                	ld	s11,24(sp)
 7d0:	6109                	addi	sp,sp,128
 7d2:	8082                	ret

00000000000007d4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d4:	715d                	addi	sp,sp,-80
 7d6:	ec06                	sd	ra,24(sp)
 7d8:	e822                	sd	s0,16(sp)
 7da:	1000                	addi	s0,sp,32
 7dc:	e010                	sd	a2,0(s0)
 7de:	e414                	sd	a3,8(s0)
 7e0:	e818                	sd	a4,16(s0)
 7e2:	ec1c                	sd	a5,24(s0)
 7e4:	03043023          	sd	a6,32(s0)
 7e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f0:	8622                	mv	a2,s0
 7f2:	00000097          	auipc	ra,0x0
 7f6:	e04080e7          	jalr	-508(ra) # 5f6 <vprintf>
}
 7fa:	60e2                	ld	ra,24(sp)
 7fc:	6442                	ld	s0,16(sp)
 7fe:	6161                	addi	sp,sp,80
 800:	8082                	ret

0000000000000802 <printf>:

void
printf(const char *fmt, ...)
{
 802:	711d                	addi	sp,sp,-96
 804:	ec06                	sd	ra,24(sp)
 806:	e822                	sd	s0,16(sp)
 808:	1000                	addi	s0,sp,32
 80a:	e40c                	sd	a1,8(s0)
 80c:	e810                	sd	a2,16(s0)
 80e:	ec14                	sd	a3,24(s0)
 810:	f018                	sd	a4,32(s0)
 812:	f41c                	sd	a5,40(s0)
 814:	03043823          	sd	a6,48(s0)
 818:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 81c:	00840613          	addi	a2,s0,8
 820:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 824:	85aa                	mv	a1,a0
 826:	4505                	li	a0,1
 828:	00000097          	auipc	ra,0x0
 82c:	dce080e7          	jalr	-562(ra) # 5f6 <vprintf>
}
 830:	60e2                	ld	ra,24(sp)
 832:	6442                	ld	s0,16(sp)
 834:	6125                	addi	sp,sp,96
 836:	8082                	ret

0000000000000838 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 838:	1141                	addi	sp,sp,-16
 83a:	e422                	sd	s0,8(sp)
 83c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 842:	00000797          	auipc	a5,0x0
 846:	2067b783          	ld	a5,518(a5) # a48 <freep>
 84a:	a805                	j	87a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 84c:	4618                	lw	a4,8(a2)
 84e:	9db9                	addw	a1,a1,a4
 850:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 854:	6398                	ld	a4,0(a5)
 856:	6318                	ld	a4,0(a4)
 858:	fee53823          	sd	a4,-16(a0)
 85c:	a091                	j	8a0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 85e:	ff852703          	lw	a4,-8(a0)
 862:	9e39                	addw	a2,a2,a4
 864:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 866:	ff053703          	ld	a4,-16(a0)
 86a:	e398                	sd	a4,0(a5)
 86c:	a099                	j	8b2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86e:	6398                	ld	a4,0(a5)
 870:	00e7e463          	bltu	a5,a4,878 <free+0x40>
 874:	00e6ea63          	bltu	a3,a4,888 <free+0x50>
{
 878:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87a:	fed7fae3          	bgeu	a5,a3,86e <free+0x36>
 87e:	6398                	ld	a4,0(a5)
 880:	00e6e463          	bltu	a3,a4,888 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 884:	fee7eae3          	bltu	a5,a4,878 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 888:	ff852583          	lw	a1,-8(a0)
 88c:	6390                	ld	a2,0(a5)
 88e:	02059713          	slli	a4,a1,0x20
 892:	9301                	srli	a4,a4,0x20
 894:	0712                	slli	a4,a4,0x4
 896:	9736                	add	a4,a4,a3
 898:	fae60ae3          	beq	a2,a4,84c <free+0x14>
    bp->s.ptr = p->s.ptr;
 89c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8a0:	4790                	lw	a2,8(a5)
 8a2:	02061713          	slli	a4,a2,0x20
 8a6:	9301                	srli	a4,a4,0x20
 8a8:	0712                	slli	a4,a4,0x4
 8aa:	973e                	add	a4,a4,a5
 8ac:	fae689e3          	beq	a3,a4,85e <free+0x26>
  } else
    p->s.ptr = bp;
 8b0:	e394                	sd	a3,0(a5)
  freep = p;
 8b2:	00000717          	auipc	a4,0x0
 8b6:	18f73b23          	sd	a5,406(a4) # a48 <freep>
}
 8ba:	6422                	ld	s0,8(sp)
 8bc:	0141                	addi	sp,sp,16
 8be:	8082                	ret

00000000000008c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c0:	7139                	addi	sp,sp,-64
 8c2:	fc06                	sd	ra,56(sp)
 8c4:	f822                	sd	s0,48(sp)
 8c6:	f426                	sd	s1,40(sp)
 8c8:	f04a                	sd	s2,32(sp)
 8ca:	ec4e                	sd	s3,24(sp)
 8cc:	e852                	sd	s4,16(sp)
 8ce:	e456                	sd	s5,8(sp)
 8d0:	e05a                	sd	s6,0(sp)
 8d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d4:	02051493          	slli	s1,a0,0x20
 8d8:	9081                	srli	s1,s1,0x20
 8da:	04bd                	addi	s1,s1,15
 8dc:	8091                	srli	s1,s1,0x4
 8de:	0014899b          	addiw	s3,s1,1
 8e2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8e4:	00000517          	auipc	a0,0x0
 8e8:	16453503          	ld	a0,356(a0) # a48 <freep>
 8ec:	c515                	beqz	a0,918 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f0:	4798                	lw	a4,8(a5)
 8f2:	02977f63          	bgeu	a4,s1,930 <malloc+0x70>
 8f6:	8a4e                	mv	s4,s3
 8f8:	0009871b          	sext.w	a4,s3
 8fc:	6685                	lui	a3,0x1
 8fe:	00d77363          	bgeu	a4,a3,904 <malloc+0x44>
 902:	6a05                	lui	s4,0x1
 904:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 908:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 90c:	00000917          	auipc	s2,0x0
 910:	13c90913          	addi	s2,s2,316 # a48 <freep>
  if(p == (char*)-1)
 914:	5afd                	li	s5,-1
 916:	a88d                	j	988 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 918:	00000797          	auipc	a5,0x0
 91c:	1a878793          	addi	a5,a5,424 # ac0 <base>
 920:	00000717          	auipc	a4,0x0
 924:	12f73423          	sd	a5,296(a4) # a48 <freep>
 928:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 92e:	b7e1                	j	8f6 <malloc+0x36>
      if(p->s.size == nunits)
 930:	02e48b63          	beq	s1,a4,966 <malloc+0xa6>
        p->s.size -= nunits;
 934:	4137073b          	subw	a4,a4,s3
 938:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93a:	1702                	slli	a4,a4,0x20
 93c:	9301                	srli	a4,a4,0x20
 93e:	0712                	slli	a4,a4,0x4
 940:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 942:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 946:	00000717          	auipc	a4,0x0
 94a:	10a73123          	sd	a0,258(a4) # a48 <freep>
      return (void*)(p + 1);
 94e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 952:	70e2                	ld	ra,56(sp)
 954:	7442                	ld	s0,48(sp)
 956:	74a2                	ld	s1,40(sp)
 958:	7902                	ld	s2,32(sp)
 95a:	69e2                	ld	s3,24(sp)
 95c:	6a42                	ld	s4,16(sp)
 95e:	6aa2                	ld	s5,8(sp)
 960:	6b02                	ld	s6,0(sp)
 962:	6121                	addi	sp,sp,64
 964:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 966:	6398                	ld	a4,0(a5)
 968:	e118                	sd	a4,0(a0)
 96a:	bff1                	j	946 <malloc+0x86>
  hp->s.size = nu;
 96c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 970:	0541                	addi	a0,a0,16
 972:	00000097          	auipc	ra,0x0
 976:	ec6080e7          	jalr	-314(ra) # 838 <free>
  return freep;
 97a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 97e:	d971                	beqz	a0,952 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 980:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 982:	4798                	lw	a4,8(a5)
 984:	fa9776e3          	bgeu	a4,s1,930 <malloc+0x70>
    if(p == freep)
 988:	00093703          	ld	a4,0(s2)
 98c:	853e                	mv	a0,a5
 98e:	fef719e3          	bne	a4,a5,980 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 992:	8552                	mv	a0,s4
 994:	00000097          	auipc	ra,0x0
 998:	b7e080e7          	jalr	-1154(ra) # 512 <sbrk>
  if(p == (char*)-1)
 99c:	fd5518e3          	bne	a0,s5,96c <malloc+0xac>
        return 0;
 9a0:	4501                	li	a0,0
 9a2:	bf45                	j	952 <malloc+0x92>

00000000000009a4 <setjmp>:
 9a4:	e100                	sd	s0,0(a0)
 9a6:	e504                	sd	s1,8(a0)
 9a8:	01253823          	sd	s2,16(a0)
 9ac:	01353c23          	sd	s3,24(a0)
 9b0:	03453023          	sd	s4,32(a0)
 9b4:	03553423          	sd	s5,40(a0)
 9b8:	03653823          	sd	s6,48(a0)
 9bc:	03753c23          	sd	s7,56(a0)
 9c0:	05853023          	sd	s8,64(a0)
 9c4:	05953423          	sd	s9,72(a0)
 9c8:	05a53823          	sd	s10,80(a0)
 9cc:	05b53c23          	sd	s11,88(a0)
 9d0:	06153023          	sd	ra,96(a0)
 9d4:	06253423          	sd	sp,104(a0)
 9d8:	4501                	li	a0,0
 9da:	8082                	ret

00000000000009dc <longjmp>:
 9dc:	6100                	ld	s0,0(a0)
 9de:	6504                	ld	s1,8(a0)
 9e0:	01053903          	ld	s2,16(a0)
 9e4:	01853983          	ld	s3,24(a0)
 9e8:	02053a03          	ld	s4,32(a0)
 9ec:	02853a83          	ld	s5,40(a0)
 9f0:	03053b03          	ld	s6,48(a0)
 9f4:	03853b83          	ld	s7,56(a0)
 9f8:	04053c03          	ld	s8,64(a0)
 9fc:	04853c83          	ld	s9,72(a0)
 a00:	05053d03          	ld	s10,80(a0)
 a04:	05853d83          	ld	s11,88(a0)
 a08:	06053083          	ld	ra,96(a0)
 a0c:	06853103          	ld	sp,104(a0)
 a10:	c199                	beqz	a1,a16 <longjmp_1>
 a12:	852e                	mv	a0,a1
 a14:	8082                	ret

0000000000000a16 <longjmp_1>:
 a16:	4505                	li	a0,1
 a18:	8082                	ret
