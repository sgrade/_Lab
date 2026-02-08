# htop

Interactive process viewer

## Basic Usage

```bash
htop                   # Launch interactive monitor
htop -u username      # Show specific user's processes
htop -p PID           # Monitor specific process
```

**Key shortcuts:**
- `F4` - Filter processes (type to search)
- `F5` - Tree view (process hierarchy)
- `F6` - Sort by column
- `F9` - Kill process
- `F10` - Quit

## Practical Troubleshooting Scenarios

**Finding resource hogs:**
- Press `F6`, select CPU% or MEM%
- Color bars show: green (normal), red (kernel), blue (low priority)
- Red swap bar = system swapping (bad)

**Process hierarchy investigation:**
- Press `F5` for tree view
- See parent-child relationships
- Find which service spawned problematic processes

**Zombie process cleanup:**
- Look for `Z` status in process list
- Use tree view to find parent process
- Kill parent (zombies can't be killed directly)

**Memory pressure:**
- Check memory bar colors: green (used), yellow (cache), blue (buffers)
- Sort by MEM%, look for growing RES values
- Swap usage (red bar) indicates memory exhaustion

