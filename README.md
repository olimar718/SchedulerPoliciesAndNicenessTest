
# SchedulerPoliciesAndNicenessTest
## The goal
To test the impact of the scheduling policies we wrote a shell script to load a system completely with "stress", and then run a  process at the same time, with varying policies or niceness (with the sched_OTHER policy) to see how well it performs. For that we need the stress,  the time and the cpupower programs.
##  The time command
The time command is very simple to understand. It measures the time that a command / program took to execute.
It gives 3 results :
“real” : which is the time elapsed, in the real world, as measured by the system clock, between the moment the user started the program, and the moment the program finished, or was killed
“user” : which is the amount of time the process really spent on the cpu executing, in user space
“sys”: which is the amount of time the process really spent on the cpu executing in kernel space.
There are several versions of the time command, one can be downloaded as a separate package , one is built into bash. We used the one which is built into bash.

##  The CPU power program
The cpupower program is needed because the frequency of processors on moderns systems change over time. It’s not fixed [34]. With a lower frequency a deterministic program will take longer to execute (even if it doesn”t share the processor). This could impact our test as the frequency will go lower as the test goes on and the temperature of the processor rise.
The cpupower program is part of the linux kernel and allows administrator to fix the frequency of the processor of a given system.

##    The stress command

The stress command simply load the system. In that case we were using cpu load (spinning on sqrt()), but you can also load IO (spinning on sync()), virtual memory (spinning on malloc()/free()) and others. It is a very useful tool to see how your system will behave under heavy load. A stress-ng program also exists but it’s much more complex. The “normal” stress program seemed enough for this usage.
## The Test
The sum of user + sys the “time” command returns should not vary much if at all (only measures errors should occur) for a given deterministic program. Indeed, a given deterministic process always spend the same amount of time on the processor. The only thing that should vary is the “real” return, depending on how the scheduling was done for the process. Another thing to note is that the “sys” return is negligible or null for many programs as they do not need to perform system call or have privileged access.

The core idea of this test is to compare the “real” time of execution of a process against its “user” time. This can be done for any process, but most processes are interactive and do not have a determinist execution time, they wait for the user to close them (such as a web browser). For the sake of simplicity of decided to “develop” a simple C program that is deterministic, do not do any system call, or any privileged function. This way we only need to compare the “user” return against the “real” return.

If we get a real over user of 1 it means the process as been prioritised completely.
If we get a big real over user however it means that the process wasn’t prioritized at all, it had to wait a lot.

## Expected Results
Obviously the higher priority policies that are sched_RR and sched_FIFO give better results for the process. We also found that the niceness has a very big impact, just as claimed in the sched man page : “In the current implementation, each unit of difference in the nice values of two processes results in a factor of 1.25 in the degree to which the  scheduler  favors  the  higher  priority  process” .

## Real results coming soon
