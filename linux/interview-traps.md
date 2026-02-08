# Linux SRE Interview Traps

## Memory

**Q: System shows only 500MB free memory. Is this a problem?**

Look at `available`, not `free`. Linux uses "free" memory for cache — that's good. Worry if `available` is low AND swap is being used.

---

**Q: Swap is 95% used. Is this a problem?**

Yes. High swap = memory pressure. System pushed data to slow disk. Even if `available` shows some memory, heavy swap usage = performance problem.

---

**Q: Process shows 8GB VSZ. Is it using 8GB RAM?**

No. VSZ = virtual (could use). RSS = actually in RAM. A process with 8GB VSZ might only use 500MB RSS.

---

## Disk

**Q: `df` shows 10GB free but users can't create files. Why?**

Inodes exhausted. Check `df -i`. Each file needs one inode — millions of tiny files can exhaust inodes before space runs out.

---

## Processes

**Q: How do you kill a zombie process?**

You can't — it's already dead. Kill its **parent** instead. Zombie = child finished, parent didn't call `wait()`.

```bash
ps -o ppid= -p <zombie_pid>   # Find parent
kill <parent_pid>
```

---

**Q: Process won't die with `kill -9`. What's happening?**

Likely D state (uninterruptible sleep) — waiting for I/O. Kernel won't deliver signals until I/O completes. Fix the I/O issue (NFS mount, disk) or reboot.

---

## Load Average

**Q: Load average is 4.0. Is the system overloaded?**

Depends on CPU count. Load 4.0 on 4 cores = 100% utilized. Load 4.0 on 16 cores = 25% utilized. Compare load to `nproc`.

---

## Signals

**Q: What's the difference between SIGTERM, SIGKILL, SIGHUP?**

| Signal | Behavior |
|--------|----------|
| SIGTERM (15) | Polite ask to terminate — process can catch and cleanup |
| SIGKILL (9) | Forced kill — cannot be caught, immediate termination |
| SIGHUP (1) | "Hangup" — often used to reload config |

Always try SIGTERM before SIGKILL.

---

## Network

**Q: Seeing thousands of TIME_WAIT connections. Is this a leak?**

No, TIME_WAIT is normal — lasts 2×MSL (~60s). High count = high traffic, not a bug.

**Why TIME_WAIT exists:** Prevents stray packets from old connection being received by new connection with same 4-tuple `(src_ip, src_port, dst_ip, dst_port)`.

**MSL** = Maximum Segment Lifetime (~30s) — max time a packet can exist in network. 2×MSL ensures old packets die before 4-tuple is reused.

**Problem only if:** Exhausting ephemeral ports (unlikely unless tens of thousands).

---

**Q: Getting "Address already in use" when restarting a service. How to fix?**

Common causes:
1. **Previous process still running** — find and kill it
2. **Socket in TIME_WAIT** — previous connection still lingering

```bash
ss -tulnp | grep :8080    # Find what's using the port
```

**Solutions:**

| Option | What it does |
|--------|--------------|
| `SO_REUSEADDR` | Allow bind during TIME_WAIT (most frameworks set this) |
| `SO_REUSEPORT` | Allow multiple processes to bind same port (load balancing) |

TIME_WAIT blocks because kernel protects the 4-tuple. `SO_REUSEADDR` says "I know, bind anyway."

---

## File Descriptors

**Q: "Too many open files" — how do you fix it?**

```bash
# Check current
lsof -p <pid> | wc -l
ulimit -n

# Temporary
ulimit -n 65535

# Permanent: /etc/security/limits.conf or systemd LimitNOFILE=
```

---

## Permissions

**Q: What does the sticky bit do?**

On directories: only owner can delete their files (even if others have write). Common on `/tmp`.

```bash
ls -ld /tmp
drwxrwxrwt   # 't' = sticky bit
```

---

**Q: What's setuid/setgid?**

Two separate bits (can use both):
- **setuid (4000):** Process runs as file's **owner**
- **setgid (2000):** Process runs as file's **group**

```bash
ls -l /usr/bin/passwd
-rwsr-xr-x 1 root root   # 's' in owner = setuid, runs as root

ls -l /usr/bin/wall  
-rwxr-sr-x 1 root tty    # 's' in group = setgid, runs with tty group
```

On directories, setgid makes new files inherit directory's group.

---

## umask

**Q: New files are created with wrong permissions. Why?**

Check `umask`. It masks OUT bits from default permissions (666 for files, 777 for dirs).

```bash
umask 022   # Files: 644, Dirs: 755
umask 077   # Files: 600, Dirs: 700
```

---

## Links

**Q: What breaks a soft link? A hard link?**

| Type | Breaks when... |
|------|----------------|
| Soft (symbolic) | Target file is deleted or moved |
| Hard | All hard links AND original are deleted (shares inode) |

Hard links can't cross filesystems. Soft links can.

---

## OOM Killer

**Q: How does the kernel decide which process to kill when out of memory?**

Scores each process by `oom_score` (memory usage, age, priority). Higher score = more likely to die. Check: `cat /proc/<pid>/oom_score`. Can adjust with `oom_score_adj`.

```bash
# Protect critical process from OOM
echo -1000 > /proc/<pid>/oom_score_adj
```

---

## Regex in grep

**Q: Why doesn't `grep '\d+'` match digits?**

`\d` only works with Perl regex (`-P`). Use `grep -E '[0-9]+'` or `grep -P '\d+'`.

---

## Permissions Troubleshooting

**Q: Service can't access a file and `chmod` is unavailable. How do you fix permissions?**

Alternatives to `chmod`:
```bash
setfacl -m u:serviceuser:rw /path/file   # ACLs
python3 -c "import os; os.chmod('/path', 0o644)"
install -m 644 file /tmp/file && mv /tmp/file file
```

---

## Shell Types

**Q: Why aren't my env vars available in cron jobs?**

Cron runs non-interactive, non-login shell — doesn't read `~/.bashrc` or `~/.bash_profile`. Set vars in crontab or source files explicitly.

| Shell type | Reads |
|------------|-------|
| Login (SSH, `su -`) | `/etc/profile`, `~/.bash_profile` |
| Non-login interactive (terminal in GUI) | `~/.bashrc` |
| Non-interactive (cron, scripts) | Nothing (or `$BASH_ENV`) |

---

## Systemd Services

**Q: What user does a service run as if there's no `User=` in the unit file?**

Root. No `User=` directive = runs as root (default).

```bash
grep "^User=" /lib/systemd/system/myapp.service
# No output = runs as root
```

---

**Q: What's the difference between `systemctl restart` and `reload`?**

| Command | What happens | Downtime? |
|---------|--------------|-----------|
| restart | Stop → Start (new PID) | Yes, brief |
| reload | Re-read config (same PID) | No |

Use `reload` for config changes, `restart` for code updates or stuck service.

---

## ss Command

**Q: Why is the Process column empty in `ss -tulnp`?**

Need root to see other users' processes. Use `sudo ss -tulnp`.

---

## ps TIME Column

**Q: Process started 5 days ago but TIME shows 00:02. Is it frozen?**

No. TIME = cumulative CPU time used, not wall clock. Process is mostly idle/sleeping — only used 2 seconds of actual CPU in 5 days.

