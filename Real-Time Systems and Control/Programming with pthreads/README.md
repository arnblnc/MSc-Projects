# Real-time Programming with pthreads

## Description
This repository contains a report and related files for an assignment on real-time programming using POSIX threads (pthreads). The project explores multi-threading, thread scheduling, priority adjustments, and mutual exclusion using mutexes. The tasks involve analysing and modifying two C programs: multithread.c and critical.c.

## Project Highlights
- Thread Scheduling & Behaviour Analysis: Running multithread.c to observe how threads execute, analysing scheduling mechanisms, and modifying thread priorities.
- Priority Adjustment: Altering threadA's priority mid-execution to observe its effect on thread scheduling.
- Real-time Sleep Functionality: Using nanosleep() to introduce a delay in threadA and evaluating its impact on execution order.
- Thread Synchronisation with Mutexes: Modifying critical.c to implement mutex locks, preventing race conditions in critical sections.
- Execution Order & Output Analysis: Reporting program outputs before and after modifications, explaining how scheduling policies impact execution.

## Files
assignment.pdf – The original assignment brief with task descriptions.
CW1.pdf – The completed report, detailing results, analysis, and explanations for each task.
multithread.c – A multi-threaded C program demonstrating thread scheduling and priority management.
critical.c – A program showcasing mutual exclusion using mutexes.
