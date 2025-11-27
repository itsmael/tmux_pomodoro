# 🍅 Pomodoro for Tmux

A minimal Pomodoro timer that integrates with the **tmux status bar**.  
Start and stop focus sessions with simple shell commands. No external dependencies — just Bash + tmux (Zsh optional for aliases).

---

## Features

- Timer shown live in the tmux status bar (updates every second)
- Start sessions passing minutes (e.g. `pomostart 25`)
- Stop sessions with `pomostop`
- Small, editable Bash scripts under `~/bin/pomodoro/`
- Installer script to set everything up

---

## Repo layout
.
├── README.md
├── install-pomodoro.sh
├── uninstall-pomodoro.sh
└── bin/
└── pomodoro/
├── pomo
├── pomo-start
└── pomo-stop


---

## Installation

Clone this repo and run the installer:

```bash
git clone https://github.com/<you>/<repo>.git
cd <repo>
./install-pomodoro.sh
```

The installer will:

   1. copy scripts to ~/bin/pomodoro/

   2. set execute permissions

   3. append safe lines to ~/.tmux.conf (does not duplicate)

   4. add aliases to ~/.zshrc if present

   5. reload tmux config if tmux is running

### Manual install (if you prefer)

Copy bin/pomodoro/* to ~/bin/pomodoro/, make them executable, add this to your ~/.tmux.conf:


```bash
set -g status-interval 1
set -g status-right "#($HOME/bin/pomodoro/pomo) | %H:%M "
````


Add aliases (optional) to ~/.zshrc:

```bash 
alias pomostart="$HOME/bin/pomodoro/pomo-start"
alias pomostop="$HOME/bin/pomodoro/pomo-stop"
```

Reload tmux:

```bash
tmux source-file ~/.tmux.conf

```

## Usage:

### Start a 25-minute session:
pomostart 25

### Stop the session:
pomostop

### The tmux status bar will show something like:

🍅 24:37 | 14:02

## Uninstall

If installed via the provided script, run:
```bash
./uninstall-pomodoro.sh
```

This will remove ~/bin/pomodoro/, clean the lines added to ~/.tmux.conf and ~/.zshrc (backups saved as .bak).
