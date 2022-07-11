# Inter-process communication

## [Unix domain sockets](https://en.wikipedia.org/wiki/Unix_domain_socket)

A Unix domain socket aka UDS or IPC socket (inter-process communication socket) is a data communications endpoint for exchanging data between processes executing on the same host operating system. It is also referred to by its address family AF_UNIX. Valid socket types in the UNIX domain are:

- SOCK_STREAM (compare to TCP) – for a stream-oriented socket
- SOCK_DGRAM (compare to UDP) – for a datagram-oriented socket that preserves message boundaries (as on most UNIX implementations, UNIX domain datagram sockets are always reliable and don't reorder datagrams)
- SOCK_SEQPACKET (compare to SCTP) – for a sequenced-packet socket that is connection-oriented, preserves message boundaries, and delivers messages in the order that they were sent
The Unix domain socket facility is a standard component of POSIX operating systems.

The API for Unix domain sockets is similar to that of an Internet socket, but rather than using an underlying network protocol, all communication occurs entirely within the operating system kernel.

## [Internet socket](https://en.wikipedia.org/wiki/Network_socket)

A network socket is a software structure within a network node of a computer network that serves as an endpoint for sending and receiving data across the network.

Because of the standardization of the TCP/IP protocols in the development of the Internet, the term network socket is often referred to as Internet socket. In this context, a socket is externally identified to other hosts by its socket address, which is the triad of transport protocol, IP address, and port number.

An application can communicate with a remote process by exchanging data with TCP/IP by knowing the combination of protocol type, IP address, and port number. This combination is often known as a socket address.

The remote process establishes a network socket in its own instance of the protocol stack, and uses the networking API to connect to the application, presenting its own socket address for use by the application.

## [Pipeline (Unix)](https://en.wikipedia.org/wiki/Pipeline_(Unix))

A pipeline is a mechanism for inter-process communication using message passing. A pipeline is a set of processes chained together by their standard streams, so that the output text of each process (stdout) is passed directly as input (stdin) to the next one.

## Message Queues

[https://tldp.org/LDP/tlk/ipc/ipc.html](https://tldp.org/LDP/tlk/ipc/ipc.html)

Message queues allow one or more processes to write messages, which will be read by one or more reading processes. Linux maintains a list of message queues, the msgque vector; each element of which points to a msqid_ds data structure that fully describes the message queue.

## Semaphores

[https://tldp.org/LDP/tlk/ipc/ipc.html](https://tldp.org/LDP/tlk/ipc/ipc.html)

In its simplest form a semaphore is a location in memory whose value can be tested and set by more than one process.

## Shared Memory

[https://tldp.org/LDP/tlk/ipc/ipc.html](https://tldp.org/LDP/tlk/ipc/ipc.html)

Shared memory allows one or more processes to communicate via memory that appears in all of their virtual address spaces.
