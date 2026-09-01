# 20-20-20 Reminder

A macOS eye-break reminder: every 20 minutes it asks you to look at something
20 feet away for 20 seconds. It uses `terminal-notifier` and can be controlled
from the command line or a [SwiftBar](https://github.com/swiftbar/SwiftBar)
menu-bar item.

## Requirements

```sh
brew install terminal-notifier
```

SwiftBar is optional; install it for menu-bar controls:

```sh
brew install swiftbar
```

## Run now

```sh
chmod +x eye-break-reminder.sh 20-20-20 swiftbar/20-20-20.1m.sh
./eye-break-reminder.sh
```

## Pause and resume

The control command keeps its state at `~/.config/20-20-20/state` (or under
`$XDG_CONFIG_HOME`). The reminder reads that state immediately before sending
either notification.

```sh
./20-20-20 status
./20-20-20 pause 30m
./20-20-20 pause 2h
./20-20-20 pause workday
./20-20-20 resume
```

`pause workday` pauses until the next Monday-Friday at 09:00 local time. Set
`REMINDER_WORKDAY_START`, for example `REMINDER_WORKDAY_START=08:30`, to use a
different workday start.

## SwiftBar

In SwiftBar, choose **Open Plugin Folder**, then symlink this repository's
plugin into that folder:

```sh
ln -s "$(pwd)/swiftbar/20-20-20.1m.sh" \
  "$HOME/Library/Application Support/SwiftBar/Plugins/20-20-20.1m.sh"
```

The plugin updates each minute and offers status, pause durations, pause until
the next workday, and immediate resume. The symlink may point at this checkout;
the plugin resolves it and finds the control command automatically. If you copy
the plugin rather than symlinking it, set `REMINDERCTL` to the absolute path of
`20-20-20` in SwiftBar's plugin environment.

## Start at login with launchd

Register it with one command:

```sh
./scripts/launchd.sh register
```

That installs the generated plist under `~/Library/LaunchAgents`, starts the
reminder now, and starts it automatically at future logins. `KeepAlive` also
restarts it if it exits unexpectedly.

The agent runs `eye-break-reminder.sh` directly (rather than through `bash`),
which gives macOS a more meaningful process name in Background Activity.

```sh
./scripts/launchd.sh status
./scripts/launchd.sh unregister
```
