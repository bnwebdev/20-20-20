#!/usr/bin/env bash
set -u

# Resolve a symlink so this works from SwiftBar's plugins folder.
source_path="${BASH_SOURCE[0]}"
while [ -h "$source_path" ]; do
  source_dir="$(cd -P "$(dirname "$source_path")" && pwd)"
  source_path="$(readlink "$source_path")"
  [[ "$source_path" != /* ]] && source_path="$source_dir/$source_path"
done
plugin_dir="$(cd -P "$(dirname "$source_path")" && pwd)"
reminderctl="${REMINDERCTL:-$plugin_dir/../20-20-20}"

if [ ! -x "$reminderctl" ]; then
  echo "20-20-20 | color=red"
  echo "---"
  echo "Control command unavailable: $reminderctl | color=red"
  exit 0
fi

status="$($reminderctl status)"
if [[ "$status" == Paused* ]]; then
  echo "20-20-20: Paused | color=orange"
  echo "---"
  echo "$status | color=orange"
else
  echo "20-20-20: On | color=green"
  echo "---"
  echo "Enabled ✓ | color=green"
fi

echo "---"
echo "Pause 30 min | bash='$reminderctl' param1=pause param2=30m terminal=false refresh=true"
echo "Pause 60 min | bash='$reminderctl' param1=pause param2=60m terminal=false refresh=true"
echo "Pause 90 min | bash='$reminderctl' param1=pause param2=90m terminal=false refresh=true"
echo "Pause 120 min | bash='$reminderctl' param1=pause param2=120m terminal=false refresh=true"
echo "Pause until next workday | bash='$reminderctl' param1=pause param2=workday terminal=false refresh=true"
echo "---"
echo "Resume now | bash='$reminderctl' param1=resume terminal=false refresh=true"
