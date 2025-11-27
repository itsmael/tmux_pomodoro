#!/usr/bin/env bash
# install-pomodoro.sh
# Usage: ./install-pomodoro.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POMO_DIR="$HOME/bin/pomodoro"
TMUX_CONF="$HOME/.tmux.conf"
ZSHRC="$HOME/.zshrc"

echo "📦 Installing Pomodoro to: $POMO_DIR"

# 1) create target dir
mkdir -p "$POMO_DIR"

# 2) copy files from repo (assumes this script is in repo root)
if [[ -d "$REPO_DIR/bin/pomodoro" ]]; then
  cp -a "$REPO_DIR/bin/pomodoro/." "$POMO_DIR/"
else
  echo "❗ Expected repo layout contains bin/pomodoro/ with scripts. Exiting."
  exit 1
fi

# 3) make executable
chmod +x "$POMO_DIR/"*

# 4) tmux config: status-interval and status-right
LINE='set -g status-right "#('"$POMO_DIR"'/pomo) | %H:%M "'
INTERVAL_LINE='set -g status-interval 1'

# ensure tmux.conf exists
touch "$TMUX_CONF"

# add interval if missing (safe append)
if ! grep -qF "set -g status-interval" "$TMUX_CONF"; then
  echo "$INTERVAL_LINE" >>"$TMUX_CONF"
  echo "✅ Added status-interval 1 to $TMUX_CONF"
else
  echo "ℹ️ status-interval already present in $TMUX_CONF"
fi

# add status-right line if not present
if ! grep -Fq "$POMO_DIR/pomo" "$TMUX_CONF"; then
  echo "$LINE" >>"$TMUX_CONF"
  echo "✅ Added pomo to status-right in $TMUX_CONF"
else
  echo "ℹ️ Pomo already referenced in $TMUX_CONF"
fi

# 5) add zsh aliases (if zshrc exists)
if [[ -f "$ZSHRC" ]]; then
  AL1="alias pomostart='$POMO_DIR/pomo-start'"
  AL2="alias pomostop='$POMO_DIR/pomo-stop'"

  if ! grep -Fq "$AL1" "$ZSHRC"; then
    echo "$AL1" >>"$ZSHRC"
    echo "✅ Added alias pomostart to $ZSHRC"
  else
    echo "ℹ️ alias pomostart already in $ZSHRC"
  fi

  if ! grep -Fq "$AL2" "$ZSHRC"; then
    echo "$AL2" >>"$ZSHRC"
    echo "✅ Added alias pomostop to $ZSHRC"
  else
    echo "ℹ️ alias pomostop already in $ZSHRC"
  fi
else
  echo "⚠️ .zshrc not found; skipping aliases"
fi

# 6) try to reload tmux if running
if command -v tmux >/dev/null 2>&1 && tmux info >/dev/null 2>&1; then
  tmux source-file "$TMUX_CONF"
  echo "🔄 Reloaded tmux config"
else
  echo "ℹ️ tmux not running or not available — open a new tmux session to see the timer"
fi

echo
echo "🎉 Installation complete!"
echo "Usage:"
echo "  pomostart 25   # start 25-minute session"
echo "  pomostop       # stop current session"
echo
