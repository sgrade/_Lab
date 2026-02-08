# sed

Stream editor for filtering and transforming text

## Basic Usage

```bash
sed 's/old/new/' file.txt        # Replace first occurrence per line
sed 's/old/new/g' file.txt       # Replace all occurrences (global)
sed -i 's/old/new/g' file.txt    # Edit file in-place
sed -n '/pattern/p' file.txt     # Print only matching lines
```

## Substitution

### Basic Substitution

```bash
# Replace first occurrence per line
sed 's/old/new/' file.txt

# Replace all occurrences (global)
sed 's/old/new/g' file.txt

# Replace only on lines containing pattern
sed '/error/s/old/new/g' file.txt

# Case insensitive substitution
sed 's/error/ERROR/gi' file.txt

# Use different delimiter (useful for paths)
sed 's|/old/path|/new/path|g' file.txt
```

### Capture Groups and Backreferences

```bash
# Swap two words
echo "John Doe" | sed 's/\([A-Za-z]*\) \([A-Za-z]*\)/\2, \1/'
# Output: Doe, John

# Extract domain from email
echo "user@example.com" | sed 's/.*@\(.*\)/\1/'
# Output: example.com

# Add parentheses around numbers
sed 's/\([0-9]\+\)/(\1)/g' file.txt

# Reformat dates: YYYY-MM-DD to DD/MM/YYYY
sed 's/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)/\3\/\2\/\1/' dates.txt
```

## Line Operations

### Delete Lines

```bash
# Delete lines matching pattern
sed '/^#/d' file.txt            # Delete comments
sed '/^$/d' file.txt            # Delete empty lines
sed '1d' file.txt               # Delete first line
sed '$d' file.txt               # Delete last line
sed '1,3d' file.txt             # Delete lines 1-3

# Delete lines between patterns
sed '/START/,/END/d' file.txt
```

### Print Lines

```bash
# Print only matching lines (like grep)
sed -n '/error/p' file.txt

# Print specific lines
sed -n '5p' file.txt            # Print line 5
sed -n '10,20p' file.txt        # Print lines 10-20
sed -n '$p' file.txt            # Print last line
```

### Insert and Append

```bash
# Insert before pattern
sed '/error/i\--- ERROR FOUND ---' file.txt

# Append after pattern
sed '/error/a\--- END ERROR ---' file.txt

# Insert at specific line
sed '3i\New line here' file.txt

# Append to end of file
sed '$a\Footer text' file.txt
```

## Character Classes and Ranges

```bash
# Remove all digits
sed 's/[0-9]//g' file.txt

# Remove all non-alphanumeric
sed 's/[^a-zA-Z0-9]//g' file.txt

# Replace multiple spaces with single space
sed 's/  */ /g' file.txt
sed 's/[[:space:]]\+/ /g' file.txt

# Remove leading whitespace
sed 's/^[[:space:]]*//' file.txt

# Remove trailing whitespace
sed 's/[[:space:]]*$//' file.txt

# Remove both leading and trailing whitespace
sed 's/^[[:space:]]*//; s/[[:space:]]*$//' file.txt
```

## Practical Examples

```bash
# Mask credit card numbers (show last 4 digits)
sed 's/[0-9]\{4\}-[0-9]\{4\}-[0-9]\{4\}-\([0-9]\{4\}\)/****-****-****-\1/' file.txt

# Extract IP from log line
sed -n 's/.*\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/p' access.log

# Remove HTML tags
sed 's/<[^>]*>//g' file.html

# Add quotes around CSV fields
sed 's/\([^,]*\)/"\1"/g' file.csv

# Comment out lines matching pattern
sed '/pattern/s/^/#/' file.txt

# Uncomment lines
sed 's/^#//' file.txt

# Add line numbers
sed = file.txt | sed 'N;s/\n/\t/'

# Double-space a file
sed 'G' file.txt

# Remove blank lines
sed '/^$/d' file.txt

# Extract email addresses
sed -n 's/.*\([a-zA-Z0-9._%+-]\+@[a-zA-Z0-9.-]\+\.[a-zA-Z]\{2,\}\).*/\1/p' file.txt
```

## Multiple Commands

```bash
# Multiple substitutions (semicolon)
sed 's/foo/bar/g; s/old/new/g' file.txt

# Multiple substitutions (-e flag)
sed -e 's/foo/bar/g' -e 's/old/new/g' file.txt

# Read from script file
sed -f script.sed file.txt
```

## Practical Troubleshooting

```bash
# Clean log file: remove timestamps and debug messages
sed 's/^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} //; /DEBUG/d' app.log

# Extract URLs from HTML
sed -n 's/.*href="\([^"]*\)".*/\1/p' page.html

# Convert Windows line endings to Unix
sed 's/\r$//' file.txt

# Remove C-style comments
sed 's|/\*.*\*/||g' code.c

# Extract field from config file
sed -n 's/^ServerName //p' /etc/nginx/nginx.conf
```

## Advanced: Address Ranges

```bash
# Apply command to range
sed '10,20s/old/new/g' file.txt       # Lines 10-20
sed '10,$s/old/new/g' file.txt        # Line 10 to end
sed '/START/,/END/s/old/new/g' file.txt  # Between patterns

# Every nth line
sed -n '1~2p' file.txt                # Print odd lines
sed -n '2~2p' file.txt                # Print even lines
```
