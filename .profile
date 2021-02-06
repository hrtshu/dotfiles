# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export EDITOR=vim
export LESS="$LESS -R"

OS_RELEASE=/proc/sys/kernel/osrelease
if [ -r "$OS_RELEASE" ] && grep -q "Microsoft" "$OS_RELEASE"; then
    export DISPLAY=localhost:0.0
    export DOCKER_HOST='tcp://localhost:2375'
    export BROWSER='/mnt/c/Program Files/Mozilla Firefox/firefox.exe'
fi

# if [ -x /usr/bin/keychain ]; then
#     eval `/usr/bin/keychain --eval --agents ssh --noask`
# fi

if [ -x /opt/homebrew/bin/brew ]; then
    # for M1 mac
    eval $(/opt/homebrew/bin/brew shellenv)
elif [ -x /usr/local/bin/brew ]; then
    # for Intel mac
    eval $(/usr/local/bin/brew shellenv)
fi

[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
