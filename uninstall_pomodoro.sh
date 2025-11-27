#!/usr/bin/env bash
# uninstall-pomodoro.sh
set -euo pipefail

POMO_DIR="$HOME/bin/pomodoro"
TMUX_CONF="$HOME/.tmux.conf"
ZSHRC="$HOME/.zshrc"

echo "🗑️ Uninstalling Pomodoro from $POMO_DIR"

# remove files
if [[ -d "$POMO_DIR" ]]; then
  rm -rf "$POMO_DIR"
  echo "✅ Removed $POMO_DIR"
else
  echo "ℹ️ $POMO_DIR not present"
fi

# remove lines referencing pomo in tmux.conf
if [[ -f "$TMUX_CONF" ]]; then
  # remove the exact status-right line referencing our script
  sed -i.bak "\|$HOME/bin/pomodoro/pomo|d" "$TMUX_CONF" || true
  # remove status-interval line only if it was set to 1 and no other references? we keep it conservative:
  sed -i.bak '/set -g status-interval 1/d' "$TMUX_CONF" || true
  echo "✅ Cleaned tmux config (backup saved as ${TMUX_CONF}.bak)"
else
  echo "ℹ️ No tmux config found"
fi

# remove aliases in zshrc
if [[ -f "$ZSHRC" ]]; then
  sed -i.bak "/alias pomostart=/d" "$ZSHRC" || true
  sed -i.bak "/alias pomostop=/d" "$ZSHRC" || true
  echo "✅ Removed aliases from $ZSHRC (backup saved as ${ZSHRC}.bak)"
fi

# reload tmux if running
if command -v tmux >/dev/null 2>&1 && tmux info >/dev/null 2>&1; then
  tmux source-file "$TMUX_CONF" || true
  echo "🔄 Reloaded tmux config"
fi

echo "🧹 Uninstall complete."
