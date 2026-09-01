#!/usr/bin/env bash

# Register or unregister this reminder for the current macOS user.
set -euo pipefail

readonly LABEL="com.nikitabereziuk.20-20-20"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly TEMPLATE="$PROJECT_DIR/launchd/$LABEL.plist"
readonly PLIST_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"
readonly DOMAIN="gui/$(id -u)"

usage() {
  cat <<EOF
Usage: $(basename "$0") <register|unregister|status>

  register    Install and start the reminder at login.
  unregister  Stop it and remove its LaunchAgent plist.
  status      Show launchd's current status for the reminder.
EOF
}

render_plist() {
  local project_escaped home_escaped
  project_escaped="$(printf '%s' "$PROJECT_DIR" | sed 's/[\\&|]/\\&/g')"
  home_escaped="$(printf '%s' "$HOME" | sed 's/[\\&|]/\\&/g')"
  sed -e "s|__PROJECT_PATH__|$project_escaped|g" \
      -e "s|__HOME__|$home_escaped|g" \
      "$TEMPLATE" >"$PLIST_PATH"
}

case "${1:-}" in
  register)
    [ -x "$PROJECT_DIR/eye-break-reminder.sh" ] || chmod +x "$PROJECT_DIR/eye-break-reminder.sh"
    [ -x "$PROJECT_DIR/20-20-20" ] || chmod +x "$PROJECT_DIR/20-20-20"
    mkdir -p "$HOME/Library/LaunchAgents"
    if [ -f "$PLIST_PATH" ]; then
      launchctl bootout "$DOMAIN" "$PLIST_PATH" 2>/dev/null || true
    fi
    render_plist
    launchctl bootstrap "$DOMAIN" "$PLIST_PATH"
    echo "Registered and started $LABEL."
    ;;
  unregister)
    if [ -f "$PLIST_PATH" ]; then
      launchctl bootout "$DOMAIN" "$PLIST_PATH" 2>/dev/null || true
      rm -f "$PLIST_PATH"
      echo "Unregistered $LABEL."
    else
      echo "$LABEL is not registered."
    fi
    ;;
  status)
    launchctl print "$DOMAIN/$LABEL"
    ;;
  -h|--help|help|"")
    usage
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac
