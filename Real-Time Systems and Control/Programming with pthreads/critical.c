/*
 * critical.c
 *
 * Demonstrate use of mutual exclusion using mutexes
 *
 * Upper case output indicates critical output
 * lower case output indicates non-critical output
 *
 * compile with
 gcc critical.c -o critical -lrt -lpthread
 *
 */
#define _GNU_SOURCE
#define _REENTRANT      /* macro to ensure system calls are reentrant */
#include <pthread.h>    /* header file for pthreads */
#include <unistd.h>     /* header file for POSIX conformance */
#include <time.h>       /* header file for POSIX time management */
#include <sched.h>      /* header file for POSIX scheduling */
#include <stdio.h>      /* header file for standard input/outputlibrary */

pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER; /*define mutex */

void *threadA(void *);   /* predefine threadA routine */
void *threadB(void *);   /* predefine threadB routine */

pthread_t threadA_id,threadB_id,main_id; /* thread identifiers */
pthread_attr_t attrA,attrB;        /* thread attribute structures */
struct sched_param param;          /* scheduling structure for thread attributes */

int policy=SCHED_FIFO;
int priority_min,priority_max;     /* for range of priority levels */

/* main routine */
int main()
{
  int status;                        /* check that system calls return ok */

  /* Set processor affinity */ 
  cpu_set_t mask; CPU_ZERO(&mask); CPU_SET(0,&mask); /* use only 1 CPU core */
  unsigned int len = sizeof(mask);
  status = sched_setaffinity(0, len, &mask);
  if (status < 0) perror("sched_setaffinity");
  status = sched_getaffinity(0, len, &mask);
  if (status < 0) perror("sched_getaffinity");

  /* Find priority limits */

  priority_max = sched_get_priority_max(policy);
  priority_min = sched_get_priority_min(policy);
  
  /* Set priority and policy of main thread */

  main_id = pthread_self();
  param.sched_priority=priority_min;
  status = pthread_setschedparam(main_id, policy, &param);
  if (status != 0) perror("pthread_setschedparam"); /* error check */

  /* Create threadA */
  
  param.sched_priority = priority_min;
  pthread_attr_init(&attrA);
  status = pthread_attr_setschedpolicy(&attrA,policy);
  if (status != 0) perror("pthread_attr_setschedpolicy"); /* error check */
  status = pthread_attr_setschedparam(&attrA,&param);
  if (status != 0) perror("pthread_attr_setschedparam"); /* error check */
  status = pthread_create(&threadA_id, &attrA, threadA, NULL);
  if (status != 0) perror("pthread_create"); /* error check */
  status = pthread_setschedparam(threadA_id,policy,&param);
  if (status != 0) perror("pthread_setschedparam");

  /* Create threadB */
  
  param.sched_priority = priority_min;
  pthread_attr_init(&attrB);
  status = pthread_attr_setschedpolicy(&attrB,policy);
  if (status != 0) perror("pthread_attr_setschedpolicy"); /* error check */
  status = pthread_attr_setschedparam(&attrB,&param);
  if (status != 0) perror("pthread_attr_setschedparam"); /* error check */
  status = pthread_create(&threadB_id, &attrB, threadB, NULL);
  if (status != 0) perror("pthread_create"); /* error check */
  status = pthread_setschedparam(threadB_id,policy,&param);
  if (status != 0) perror("pthread_setschedparam");

  /* Join threads - force main to wait for the thread to terminate */  
  status = pthread_join(threadA_id, NULL);
  if (status != 0) perror("pthread_join(threadA_id, NULL)"); /* error check */
  status = pthread_join(threadB_id, NULL);
  if (status != 0) perror("pthread_join(threadB_id, NULL)"); /* error check */
  
  status = pthread_mutex_destroy(&mtx); /* delete mutex */
  if (status != 0) perror("pthread_mutex_destroy"); /* error check */
  
  printf("\n");
  return(0);
  
}  /* end of main */

void *threadA(void *arg)
{
  int j;
  int status;                        /* check that system calls return ok */
  
  
  for(j=1;j<=5;j++){
	printf("a");                     /* non -critical */
  }
  
  /* lock to enter critical region */
  status = pthread_mutex_lock(&mtx);
	if (status != 0) perror("pthread_mutex_lock"); /* error check */
  
  for(j=1;j<=5;j++){
	printf("A");                    /* critical */
  }
  
  /* increment priority of threadB above threadA */
  
  param.sched_priority++; 
  status = pthread_setschedparam(threadB_id,policy,&param);
  if (status != 0) perror("pthread_setschedparam"); /* error check */
  
  for(j=1;j<=5;j++){
	printf("A");                     /* critical */
  }
  
  /* unlock critical region */
  status = pthread_mutex_unlock(&mtx); 
	if (status != 0) perror("pthread_mutex_unlock"); /* error check */
  
  for(j=1;j<=5;j++){
	printf("a");                     /* non -critical */
  }
  
  return (NULL);
}

void *threadB(void *arg)
{
  int j;
  int status;                        /* check that system calls return ok */
  
  for(j=1;j<=5;j++){
	printf("b");                     /* non -critical */
  }
  
  /* lock to enter critical region */
  status = pthread_mutex_lock(&mtx);  
	if (status != 0) perror("pthread_mutex_lock"); /* error check */
  
  
  for(j=1;j<=5;j++){
	printf("B");                     /* critical */
  }
  
  /* increment priority of threadA to above threadB*/
  
  param.sched_priority++; 
  status = pthread_setschedparam(threadA_id,policy,&param);
  if (status != 0) perror("pthread_setschedparam"); /* error check */
  
  for(j=1;j<=5;j++){
	printf("B");                    /* critical */
  }

  /* unlock critical region */
  status = pthread_mutex_unlock(&mtx);  
	if (status != 0) perror("pthread_mutex_unlock"); /* error check */
  
  for(j=1;j<=5;j++){
	printf("b");                     /* non -critical */
  }
  
  return (NULL);
}
