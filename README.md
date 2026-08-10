# 20-20-20 Reminder

A small macOS shell script that helps follow the 20-20-20 eye-break rule.

Every 20 minutes it:

1. Plays the `Glass` sound and asks you to look 20 feet away.
2. Waits 20 seconds.
3. Plays the `Ping` sound when the break ends.

## Requirements

Install `terminal-notifier`:

```sh
brew install terminal-notifier
```

## Run

```sh
./eye-break-reminder.sh
```

Press `Ctrl+C` to stop the reminder.

## TODO

- Add automatic startup from `.zshrc` with a single-instance lock to prevent
  multiple terminal sessions from starting duplicate reminders.
