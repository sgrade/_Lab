# Shell

## Intro

Shell is a computer program which exposes an operating system's services to a human user or other programs [source](https://en.wikipedia.org/wiki/Shell_(computing)). It is named a shell because it is the outermost layer around the operating system.

Shells are actually use the kernel API in the same way as it is used by other applications. Shell alternatives - remote access apps.

Most shells are command-line and graphical.

## Bash

[Docs](https://www.gnu.org/software/bash/manual/bash.html)

A Unix shell is both a command interpreter and a programming language. As a command interpreter, the shell provides the user interface to the rich set of GNU utilities. The programming language features allow these utilities to be combined.

Shells may be used interactively or non-interactively. In interactive mode, they accept input typed from the keyboard. When executing non-interactively, shells execute commands read from a file.

A shell allows execution of GNU commands, both synchronously and asynchronously. The shell waits for synchronous commands to complete before accepting more input; asynchronous commands continue to execute in parallel with the shell while it reads and executes additional commands.

The redirection constructs permit fine-grained control of the input and output of those commands.

Moreover, the shell allows control over the contents of commands’ environments.

Shells also provide a small set of built-in commands (builtins) implementing functionality impossible or inconvenient to obtain via separate utilities. For example, cd, break, continue, and exec cannot be implemented outside of the shell because they directly manipulate the shell itself.

Like any high-level language, the shell provides variables, flow control constructs, quoting, and functions.

Shells offer features geared specifically for interactive use rather than to augment the programming language. These interactive features include job control, command line editing, command history and aliases.
