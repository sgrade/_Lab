# find

Search for files and directories.

## Basic Syntax
```bash
find [path] [conditions] [actions]
```

## By Name
```bash
find . -name "*.py"           # Case sensitive
find . -iname "*.py"          # Case insensitive
find . -name "test*"          # Starts with "test"
```

## By Type
```bash
find . -type f                # Files only
find . -type d                # Directories only
find . -type l                # Symlinks only
```

## By Size
```bash
find . -size +100M            # Larger than 100MB
find . -size -1k              # Smaller than 1KB
find . -size 50M              # Exactly 50MB
```

## By Time
```bash
find . -mtime -7              # Modified in last 7 days
find . -mtime +30             # Modified more than 30 days ago
find . -mmin -60              # Modified in last 60 minutes
find . -newer file.txt        # Newer than file.txt
```

## Exclude Directories
```bash
# Simple exclusion
find . -name "*.py" -not -path "./.venv/*"

# Prune (faster, stops descending)
find . -path ./.venv -prune -o -name "*.py" -print

# Multiple exclusions
find . \( -path ./.venv -o -path ./node_modules \) -prune -o -name "*.py" -print
```

## Actions
```bash
find . -name "*.log" -delete              # Delete files
find . -name "*.sh" -exec chmod +x {} \;  # Run on each
find . -name "*.py" -exec grep "TODO" {} +  # Run on all (faster)
find . -name "*.log" -print0 | xargs -0 rm  # Pipe to xargs
```

## Combine Conditions
```bash
# AND (implicit)
find . -name "*.py" -type f -size +1k

# OR
find . -name "*.py" -o -name "*.js"

# NOT
find . -not -name "*.pyc"
find . ! -name "*.pyc"          # Same thing
```

## Useful Examples
```bash
# Find empty files/dirs
find . -empty

# Find by permissions
find . -perm 777
find . -perm /u+x             # User executable

# Find by owner
find . -user root

# Limit depth
find . -maxdepth 2 -name "*.py"
```

