# grep

Print lines that match patterns

## Basic Usage

```bash
grep pattern file             # Search in file
grep -r pattern dir/          # Recursive search
grep -i pattern file          # Case insensitive
grep -v pattern file          # Invert match (exclude)
grep -n pattern file          # Show line numbers
grep -c pattern file          # Count matches
grep -w pattern file          # Match whole word only
grep -A 5 pattern file        # 5 lines after match
grep -B 5 pattern file        # 5 lines before match
grep -C 5 pattern file        # 5 lines before and after
grep -H pattern *.log         # Show filenames
```

## Practical Troubleshooting

**Find errors in logs:**
```bash
grep -i error /var/log/syslog                    # Find errors
grep -E 'error|fail|critical' /var/log/app.log   # Multiple patterns
grep -v INFO app.log | grep -E 'ERROR|WARN'      # Exclude INFO, find issues
```

**Track application issues:**
```bash
grep -C 10 "Exception" app.log                   # Context around exception
grep -n "OutOfMemory" *.log                      # Find with line numbers
tail -f app.log | grep --line-buffered ERROR     # Real-time error monitoring
```

**Find configuration values:**
```bash
grep -r "port" /etc/nginx/                       # Find port configs
grep -v "^#" config.conf | grep -v "^$"          # Exclude comments and blanks
```

**Count occurrences:**
```bash
grep -c "ERROR" app.log                          # Count errors
grep "ERROR" app.log | wc -l                     # Alternative count
grep -o "timeout" app.log | wc -l                # Count specific word
```

**Multiple log files analysis:**
```bash
grep -h "ERROR" *.log | sort | uniq -c           # Unique errors with count
grep -l "OutOfMemory" *.log                      # Which files contain pattern
```

## Regular Expressions

### Basic Patterns

```bash
# Anchors
grep "^Error" file.log        # Lines starting with "Error"
grep "failed$" file.log       # Lines ending with "failed"

# Character classes
grep "[0-9]" file.log         # Lines with digits
grep "[A-Z]" file.log         # Lines with uppercase letters
grep "[^0-9]" file.log        # Lines without digits
```

### Quantifiers

```bash
# Basic regex (default)
grep "error\+" file.log       # One or more "r" in error
grep "errors\?" file.log      # "error" or "errors"

# Extended regex (-E)
grep -E "error+" file.log     # One or more "r"
grep -E "errors*" file.log    # Zero or more "s"
grep -E "errors?" file.log    # Zero or one "s"
grep -E "[0-9]{3}" file.log   # Exactly 3 digits
grep -E "[0-9]{2,4}" file.log # 2 to 4 digits
```

### Multiple Patterns

```bash
# OR operator
grep -E "error|fail|critical" file.log

# AND (lines with both patterns)
grep "error" file.log | grep "database"

# NOT (exclude pattern)
grep -v "debug" file.log
```

## Practical Examples

```bash
# Find IPv4 addresses
grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" file.log

# Find email addresses
grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" file.log

# Find HTTP 4xx/5xx errors
grep -E "\" [45][0-9]{2} " access.log

# Find timestamps (HH:MM:SS)
grep -E "[0-9]{2}:[0-9]{2}:[0-9]{2}" file.log

# Empty or whitespace-only lines
grep "^[[:space:]]*$" file.txt

# Lines NOT starting with # or empty
grep -v "^#" file.txt | grep -v "^$"
```
