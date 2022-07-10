# Signals

[Source](https://www.gnu.org/software/libc/manual/html_node/Signal-Handling.html)

## Intro

A signal is a software interrupt delivered to a process. The operating system uses signals to report exceptional situations to an executing program.

One process can send a signal to another process; this allows a parent process to abort a child, or two related processes to communicate and synchronize.

## Details

The events that generate signals fall into three major categories: errors, external events, and explicit requests.

Signals may be generated synchronously or asynchronously.

When a signal is generated, it becomes pending. Normally it remains pending for just a short period of time and then is delivered to the process that was signaled. However, if that kind of signal is currently blocked, it may remain pending indefinitely—until signals of that kind are unblocked. Once unblocked, it will be delivered immediately.

When the signal is delivered, whether right away or after a long delay, the specified action for that signal is taken. For certain signals, such as **SIGKILL** and **SIGSTOP**, the action is fixed, but for most signals, the program has a choice: ignore the signal, specify a handler function, or accept the default action for that kind of signal.

While the handler is running, that particular signal is normally blocked.

If a signal arrives which the program has neither handled nor ignored, its default action takes place.

For most kinds of signals, the default action is to terminate the process. For certain kinds of signals that represent “harmless” events, the default action is to do nothing.

When a signal terminates a process, its parent process can determine the cause of termination by examining the termination status code reported by the wait or waitpid functions.

The signals that normally represent program errors have a special property: when one of these signals terminates the process, it also writes a core dump file which records the state of the process at the time of termination.

## Standard signals

[Source](https://www.gnu.org/software/libc/manual/html_node/Standard-Signals.html)

Each signal name is a macro which stands for a positive integer—the signal number for that kind of signal. Your programs should never make assumptions about the numeric code for a particular kind of signal, but rather refer to them always by the names defined here. This is because the number for a given kind of signal can vary from system to system, but the meanings of the names are standardized and fairly uniform.

## Reasons why Kill may not work

[Source](https://linuxhint.com/resolve-why-kill-may-not-work-in-linux-how-to-resolve-it/)

The default signal sent with the KILL command is **SIGTERM**. SIGTERM essentially notifies the process that it should clean itself up and be terminated. This is the “nice” way of terminating or killing a process.

If you notice that the process you had commanded to end is still running after using the SIGTERM signal, you can use the **SIGKILL** signal to terminate the process completely. The SIGKILL signal enables the system to take matters into its own hands. So, if you meet such a sticky situation, you can always come out of it using the SIGKILL or -9 signal.
