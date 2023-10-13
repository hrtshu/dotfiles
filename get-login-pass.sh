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

DIALOG_TITLE="${1-password}"

[ -n "$NOTIFIER" ] && "$NOTIFIER" -title "Password Required" -message "Please enter your password." -sound default
pass="$("$ZENITY" --password --title="$DIALOG_TITLE")" || exit 2
echo "$pass"
