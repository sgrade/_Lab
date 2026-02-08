# awk

Pattern scanning and text processing language

## Basic Usage

```bash
awk '{print}' file.txt              # Print all lines
awk '{print $1}' file.txt           # Print first field
awk '{print $1, $3}' file.txt       # Print fields 1 and 3
awk '{print $NF}' file.txt          # Print last field
awk '{print NR, $0}' file.txt       # Print line number and line
awk -F: '{print $1}' /etc/passwd    # Custom field separator
```

## Pattern Matching

### Basic Patterns

```bash
# Print lines matching pattern
awk '/error/' file.log

# Print lines NOT matching pattern
awk '!/error/' file.log

# Case insensitive match
awk 'tolower($0) ~ /error/' file.log

# Match specific field
awk '$3 ~ /error/' file.log         # 3rd field contains "error"
awk '$1 == "root"' /etc/passwd      # Exact match

# Field does NOT match
awk '$2 !~ /^#/' file.txt           # Field 2 doesn't start with #
```

### Field Matching with Regex

```bash
# Field 1 is only digits
awk '$1 ~ /^[0-9]+$/' file.txt

# IP address in first field
awk '$1 ~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/' access.log

# Email in any field
awk '$0 ~ /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/' file.txt

# Lines starting with digit
awk '/^[0-9]/' file.txt
```

## Field Operations

```bash
# Print specific fields
awk '{print $1, $3}' file.txt

# Print with custom separator
awk '{print $1 ":" $3}' file.txt

# Print all fields except first
awk '{$1=""; print}' file.txt

# Swap fields
awk '{print $2, $1}' file.txt

# Print field count
awk '{print NF}' file.txt

# Print lines with more than 5 fields
awk 'NF > 5' file.txt
```

## Built-in Variables

```bash
NR          # Current line number (all files)
NF          # Number of fields in current line
FNR         # Line number in current file
FS          # Field separator (default: whitespace)
OFS         # Output field separator (default: space)
RS          # Record separator (default: newline)
ORS         # Output record separator (default: newline)
$0          # Entire line
$1, $2      # First, second field
$NF         # Last field
$(NF-1)     # Second to last field
```

### Using Variables

```bash
# Print line numbers
awk '{print NR, $0}' file.txt

# Print only lines 10-20
awk 'NR>=10 && NR<=20' file.txt

# Skip first line (header)
awk 'NR > 1' file.txt

# Change field separator
awk -F: '{print $1}' /etc/passwd
awk 'BEGIN {FS=":"} {print $1}' /etc/passwd

# Change output separator
awk 'BEGIN {OFS=","} {print $1, $2}' file.txt
```

## Conditions and Logic

```bash
# Numeric comparison
awk '$3 > 100' file.txt             # Field 3 > 100
awk '$2 >= 50 && $2 <= 100' file.txt

# String comparison
awk '$1 == "error"' file.txt
awk '$2 != "debug"' file.txt

# Multiple conditions (AND)
awk '$1 == "error" && $3 > 100' file.txt

# Multiple conditions (OR)
awk '$1 == "error" || $1 == "warning"' file.txt

# Pattern match AND numeric condition
awk '$2 ~ /^[0-9]+$/ && $2 > 100' file.txt
```

## BEGIN and END Blocks

```bash
# Execute before processing
awk 'BEGIN {print "Starting..."} {print} END {print "Done"}' file.txt

# Set variables
awk 'BEGIN {FS=":"; OFS=","} {print $1, $3}' /etc/passwd

# Count lines
awk 'END {print NR}' file.txt

# Sum field 3
awk '{sum += $3} END {print sum}' file.txt

# Calculate average
awk '{sum += $2; count++} END {print sum/count}' file.txt

# Print header
awk 'BEGIN {print "Name\tAge"} {print $1, $2}' file.txt
```

## Substitution

```bash
# Replace in specific field
awk '{gsub(/old/, "new", $3); print}' file.txt

# Replace in entire line
awk '{gsub(/old/, "new"); print}' file.txt

# Replace only first occurrence
awk '{sub(/old/, "new"); print}' file.txt

# Replace with capture groups (gensub - GNU awk)
awk '{print gensub(/([0-9]+)/, "[\\1]", "g")}' file.txt

# Case insensitive substitution
awk '{gsub(/error/, "ERROR", IGNORECASE=1); print}' file.txt
```

## Practical Examples

### Log Analysis

```bash
# Show IPs with 404 errors
awk '$9 == 404 {print $1}' access.log | sort | uniq -c

# Extract URLs from logs
awk 'match($0, /"[A-Z]+ ([^ ]+)/, arr) {print arr[1]}' access.log

# Count requests per IP
awk '{print $1}' access.log | sort | uniq -c | sort -nr

# Calculate average response time (field 10)
awk '$10 ~ /^[0-9]+$/ {sum+=$10; count++} END {print sum/count}' access.log

# Show slow requests (> 1000ms)
awk '$10 > 1000 {print $1, $7, $10}' access.log

# Requests per hour
awk '{split($4, a, ":"); print a[2]}' access.log | sort | uniq -c
```

### System Administration

```bash
# Show users with UID > 1000
awk -F: '$3 > 1000 {print $1}' /etc/passwd

# Show users with bash shell
awk -F: '$7 == "/bin/bash" {print $1}' /etc/passwd

# Sum disk usage
df -h | awk 'NR>1 {gsub(/%/, "", $5); sum+=$5} END {print sum "%"}'

# Memory usage by process
ps aux | awk '{sum+=$4} END {print sum "%"}'

# Network connections per state
netstat -an | awk '/tcp/ {print $6}' | sort | uniq -c

# Top 10 memory consuming processes
ps aux | awk 'NR>1 {print $4, $11}' | sort -rn | head -10
```

### CSV/Data Processing

```bash
# Print only lines with valid email (field 2)
awk -F, '$2 ~ /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/ {print $1, $2}' users.csv

# Sum column 3 where column 1 = 2024
awk -F, '$1 == 2024 {sum += $3} END {print sum}' data.csv

# Convert CSV to TSV
awk -F, '{print $1"\t"$2"\t"$3}' file.csv

# Add header to CSV
awk 'BEGIN {print "Name,Age,City"} {print}' data.csv

# Remove duplicates based on field 1
awk -F, '!seen[$1]++' data.csv
```

### Text Processing

```bash
# Find lines where timestamp is 10:00-11:00
awk '$0 ~ /1[0-1]:[0-9]{2}:[0-9]{2}/' file.log

# Extract JSON field values (simple)
awk -F'"' '/"name":/ {print $4}' data.json

# Print paragraph (records separated by blank lines)
awk 'BEGIN {RS=""} /pattern/' file.txt

# Merge lines (join with comma)
awk '{printf "%s%s", sep, $0; sep=","} END {print ""}' file.txt

# Print every other line
awk 'NR % 2 == 1' file.txt

# Count word frequency
awk '{for(i=1;i<=NF;i++) count[$i]++} END {for(w in count) print w, count[w]}' file.txt
```

## Advanced Examples

```bash
# Calculate column statistics
awk '{sum+=$1; sumsq+=$1*$1} END {print "avg:", sum/NR, "stddev:", sqrt(sumsq/NR - (sum/NR)^2)}' data.txt

# Print lines between patterns
awk '/START/,/END/' file.txt

# Group by field and sum
awk '{sum[$1]+=$2} END {for(i in sum) print i, sum[i]}' file.txt

# Print duplicate lines
awk 'seen[$0]++' file.txt

# Remove duplicate lines (keep first)
awk '!seen[$0]++' file.txt

# Print longest line
awk 'length > max {max=length; line=$0} END {print line}' file.txt

# Transpose rows to columns
awk '{for(i=1;i<=NF;i++) a[i]=a[i]" "$i} END {for(i=1;i<=NF;i++) print a[i]}' file.txt
```

## Combining with Other Commands

```bash
# Process output from other commands
ps aux | awk '$3 > 50 {print $2, $11}'

# Use in pipeline
cat file.txt | awk '/error/' | sort | uniq -c

# With find
find . -name "*.log" -exec awk '/error/' {} +

# With grep
grep "error" file.log | awk '{print $1, $NF}'
```
