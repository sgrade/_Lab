# systemd

[Source](https://man7.org/linux/man-pages/man1/systemd.1.html)

systemd is a system and service manager for Linux. When run as first process on boot (as PID 1), it acts as init system that brings up and maintains userspace services. Separate instances are started for logged-in users to start their
services.

On boot systemd activates the target unit default.target whose job is to activate on-boot services and other on-boot units by pulling them in via dependencies.

systemd provides a dependency system between various entities
called "units" of 11 different types. Units encapsulate various
objects that are relevant for system boot-up and maintenance. The
majority of units are configured in unit configuration files.
