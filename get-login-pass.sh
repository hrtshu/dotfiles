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

DIALOG_TITLE="${1-password}"

pass="$("$ZENITY" --password --title="$DIALOG_TITLE")" || exit 2
echo "$pass"
