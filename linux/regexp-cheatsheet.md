# Regex Quick Reference

## Metacharacters
| Char | Meaning |
|------|---------|
| `.` | Any single character |
| `^` | Start of line |
| `$` | End of line |
| `\b` | Word boundary |
| `\d` | Digit [0-9] |
| `\w` | Word char [a-zA-Z0-9_] |
| `\s` | Whitespace |
| `\D \W \S` | Negated versions |

## Quantifiers
| Syntax | Meaning |
|--------|---------|
| `*` | 0 or more |
| `+` | 1 or more |
| `?` | 0 or 1 |
| `{n}` | Exactly n |
| `{n,}` | n or more |
| `{n,m}` | Between n and m |
| `*?` `+?` | Non-greedy |

## Groups & Alternation
| Syntax | Meaning |
|--------|---------|
| `(...)` | Capture group |
| `(?:...)` | Non-capture group |
| `\1 \2` | Backreference |
| `a\|b` | a OR b |
| `[abc]` | Character class |
| `[^abc]` | Negated class |
| `[a-z]` | Range |

## Common Patterns
```
Email:    \w+@\w+\.\w+
IP:       \d{1,3}(\.\d{1,3}){3}
URL:      https?://\S+
Number:   -?\d+\.?\d*
```

## Linux Commands
```bash
grep -E 'pattern' file      # Extended regex
grep -P 'pattern' file      # Perl regex (\d works)
sed 's/old/new/g' file      # Substitute
sed -E 's/(group)/\1/' file # With groups
awk '/pattern/ {print $1}'  # Match & print
```

## Python
```python
import re
re.search(r'pattern', text)      # First match
re.findall(r'pattern', text)     # All matches
re.sub(r'old', 'new', text)      # Replace
re.split(r'delim', text)         # Split
m.group(0)                       # Full match
m.group(1)                       # First group
```

## Flags
| Python | grep | Meaning |
|--------|------|---------|
| `re.I` | `-i` | Case insensitive |
| `re.M` | — | Multiline ^$ |
| `re.S` | — | Dot matches \n |

## Gotchas
- **`\d \w \s` only work with `grep -P`** — use `[0-9]` `[a-zA-Z_]` with `-E`
- **grep basic**: escape `+ ? { } ( ) |` → use `-E`
- **Python**: use raw strings `r'...'`
- **sed**: escape `/` in pattern or use different delimiter `s|old|new|`
