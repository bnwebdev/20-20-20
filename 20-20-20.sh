#!/usr/bin/env bash

set -u

readonly INTERVAL_SECONDS=$((20 * 60))
readonly BREAK_SECONDS=20

send_notification() {
  local title="$1"
  local message="$2"
  local sound="$3"

  if command -v terminal-notifier >/dev/null 2>&1; then
    terminal-notifier -title "$title" -message "$message" -sound "$sound"
  fi
}

if ! command -v terminal-notifier >/dev/null 2>&1; then
  echo "Error: terminal-notifier is required. Install it with: brew install terminal-notifier" >&2
  exit 1
fi

echo "20-20-20 reminder started. Press Ctrl+C to stop."

while true; do
  sleep "$INTERVAL_SECONDS"
  send_notification \
    "20-20-20 break" \
    "Look at something 20 feet away for 20 seconds." \
    "Glass"

  sleep "$BREAK_SECONDS"
  send_notification \
    "20-20-20 break complete" \
    "The 20-second break period has ended." \
    "Ping"
done
