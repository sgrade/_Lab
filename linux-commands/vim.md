# vim

Modal text editor — essential for server troubleshooting and config editing.

## Modes

| Mode | Enter with | Purpose |
|------|------------|---------|
| Normal | `Esc` | Navigation, commands |
| Insert | `i`, `a`, `o` | Typing text |
| Visual | `v`, `V`, `Ctrl+v` | Selection |
| Command | `:` | Ex commands |

## Navigation

```
h j k l          # Left, down, up, right
w / b            # Next/previous word
0 / $            # Start/end of line
gg / G           # Start/end of file
:42              # Go to line 42
Ctrl+d / Ctrl+u  # Page down/up
```

## Search

```
/pattern         # Search forward
?pattern         # Search backward
n / N            # Next/previous match
*                # Search word under cursor (forward)
#                # Search word under cursor (backward)
:noh             # Clear search highlighting
```

## Editing

```
i / a            # Insert before/after cursor
I / A            # Insert at start/end of line
o / O            # New line below/above
x                # Delete character
dd               # Delete line
yy               # Yank (copy) line
p / P            # Paste after/before
u                # Undo
Ctrl+r           # Redo
.                # Repeat last change
```

## Visual Mode (Select, Copy, Paste)

```
v                # Start character selection
V                # Start line selection
Ctrl+v           # Start block/column selection
```

Once in visual mode:
```
y                # Yank (copy) selection
d                # Delete (cut) selection
p                # Paste after cursor
P                # Paste before cursor
```

## Save and Quit

```
:w               # Save
:q               # Quit
:wq / :x         # Save and quit
:q!              # Quit without saving
:w !sudo tee %   # Save as root (forgot sudo)
```

## Search and Replace

```
:%s/old/new/g    # Replace all in file
:%s/old/new/gc   # Replace all with confirmation
:s/old/new/g     # Replace in current line
```

## Practical Troubleshooting

**Edit config files:**
```
:set number          # Show line numbers
:set paste           # Paste without auto-indent
:set nopaste         # Disable paste mode
```

**View large log files:**
```
vim +G file.log      # Open at end of file
:set nowrap          # Disable line wrapping
```

**Compare/diff:**
```
vim -d file1 file2   # Open in diff mode
```

**Quick fixes:**
```
:%s/\s\+$//g         # Remove trailing whitespace
:g/^$/d              # Delete empty lines
```
