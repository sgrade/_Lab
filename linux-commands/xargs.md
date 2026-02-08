# xargs

Converts stdin into arguments for another command.

## Basic Syntax
```bash
command1 | xargs command2
```

## Examples

```bash
# Delete all .log files
find /var/log -name "*.log" | xargs rm

# Handle filenames with spaces (null-separated)
find /var/log -name "*.log" -print0 | xargs -0 rm

# Kill all python processes
pgrep python | xargs kill

# Grep in found files
find . -name "*.py" | xargs grep "import os"

# Run command for each item (replace {})
cat urls.txt | xargs -I {} curl -s {}

# Parallel execution (4 processes)
cat hosts.txt | xargs -P 4 -I {} ssh {} "uptime"

# Limit arguments per command
echo 1 2 3 4 5 | xargs -n 2 echo
# 1 2
# 3 4
# 5
```

## Key Flags

| Flag | Meaning |
|------|---------|
| `-I {}` | Replace `{}` with each input item |
| `-n N` | Max N arguments per command |
| `-P N` | Run N processes in parallel |
| `-0` | Null-separated input (use with `find -print0`) |
| `-t` | Print command before executing (debug) |
| `-p` | Prompt before executing each command |

## Common Patterns

```bash
# Process files safely (handles spaces, special chars)
find . -type f -print0 | xargs -0 -I {} command {}

# Batch operations with limited args
cat list.txt | xargs -n 100 some_command

# Parallel downloads
cat urls.txt | xargs -P 8 -I {} wget {}

# Check before deleting
find . -name "*.tmp" | xargs -p rm
```

## vs. find -exec

```bash
# These are equivalent:
find . -name "*.log" | xargs rm
find . -name "*.log" -exec rm {} +

# But xargs is more flexible for piping from any command
grep -l "error" *.log | xargs rm
```

