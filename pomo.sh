#!/usr/bin/env bash
# pomo - prints remaining time as "🍅 MM:SS" or "🍅 DONE"
STATE_FILE="$HOME/bin/pomodoro/.pomo_state"

if [[ ! -f "$STATE_FILE" ]]; then
  # nothing to show
  echo ""
  exit 0
fi

read start mins <"$STATE_FILE" || {
  echo ""
  exit 0
}

now=$(date +%s)
elapsed=$((now - start))
total=$((mins * 60))
remain=$((total - elapsed))

if ((remain <= 0)); then
  # timer finished; remove state and show DONE once
  rm -f "$STATE_FILE"
  echo "🍅 DONE"
  exit 0
fi

min=$((remain / 60))
sec=$((remain % 60))

printf "🍅 %02d:%02d" "$min" "$sec"
