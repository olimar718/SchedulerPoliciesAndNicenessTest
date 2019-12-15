
# SchedulerPoliciesAndNicenessTest

##  General approach
Even if this script is Linux exclusive the approach taken can be generalized to other operating system. The idea is simply to load the system completely, because that's when the scheduling algorithm and policies will make a difference. You then run any deterministic program at the same and see how much more time it takes.

## Required Software and usage
This shell script requires that you have : *linux-cpupower*, *stress*, *bc* and *bash* installed on your system. It only works on *Linux* because it uses Linux only software.
If you want to reproduce this testing. You will need to configure the script according to your need. Most importantly the *frequency* and *NormalFrequency*.

## The goal
To test the impact of the scheduling policies we wrote a shell script to load a system completely with *stress*, and then run a  process at the same time, with varying policies or niceness (with the sched_OTHER policy) to see how well it performs. For that we need the *stress*,  the *time* and the *cpupower* programs.

## The Test
The sum of "user" + "sys" the *time* command returns should not vary much if at all (only measures errors should occur) for a given deterministic program. Indeed, a given deterministic process always spend the same amount of time on the processor. The only thing that should vary is the “real” return, depending on how the scheduling was done for the process. Another thing to note is that the “sys” return is negligible or null for many programs as they do not need to perform system call or have privileged access.

The core idea of this test is to compare the “real” time of execution of a process against its “user” time. This can be done for any process, but most processes are interactive and do not have a deterministic execution time, they wait for the user to close them (such as a web browser). For the sake of simplicity of decided to “develop” a simple C program that is deterministic, do not do any system call, or any privileged function. This way we only need to compare the “user” return against the “real” return.

If we get a real over user of 1 it means the process as been prioritized completely.
If we get a big real over user however it means that the process was not prioritized at all, it had to wait a lot.

## Expected Results
Obviously the higher priority policies that are *sched_RR* and *sched_FIFO* give better results for the process. We also found that the niceness has a very big impact, just as claimed in the sched man page : “In the current implementation, each unit of difference in the nice values of two processes results in a factor of 1.25 in the degree to which the  scheduler  favors  the  higher  priority  process” .

## Results
Look at the pdf files under results
