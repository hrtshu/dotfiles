#!/bin/sh

# ref:
# https://github.com/Homebrew/homebrew-autoupdate/issues/40#issuecomment-1590072074
# https://netlog.jpn.org/r271-635/2018/11/linuxdialog_zenity_yad.html

if [ -x /opt/homebrew/bin/zenity ]; then
    ZENITY=/opt/homebrew/bin/zenity
elif [ -x /usr/local/bin/zenity ]; then
    ZENITY=/usr/local/bin/zenity
elif [ -x /usr/bin/zenity ]; then
    ZENITY=/usr/bin/zenity
else
    exit 1
fi

if [ -x /opt/homebrew/bin/terminal-notifier ]; then
    NOTIFIER=/opt/homebrew/bin/terminal-notifier
elif [ -x /usr/local/bin/terminal-notifier ]; then
    NOTIFIER=/usr/local/bin/terminal-notifier
elif [ -x /usr/bin/terminal-notifier ]; then
    NOTIFIER=/usr/bin/terminal-notifier
fi

NOTIFICATION_GROUP_ID="$(uuidgen || echo get-login-pass)"

DIALOG_TITLE="${1-password}"

[ -n "$NOTIFIER" ] && "$NOTIFIER" -group "$NOTIFICATION_GROUP_ID" -title "Password Required" -message "Please enter your password." -sound default

EXIT_CODE=0
if pass="$("$ZENITY" --password --title="$DIALOG_TITLE")"; then
    echo "$pass"
else
    EXIT_CODE=2
fi

[ -n "$NOTIFIER" ] && "$NOTIFIER" -remove "$NOTIFICATION_GROUP_ID" >/dev/null 2>&1
exit $EXIT_CODE
