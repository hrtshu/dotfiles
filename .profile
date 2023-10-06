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
unset OS_RELEASE

[ "$(/usr/bin/uname -s)" = "Darwin" ] && export BASH_SILENCE_DEPRECATION_WARNING=1

# if [ -x /usr/bin/keychain ]; then
#     eval `/usr/bin/keychain --eval --agents ssh --noask`
# fi

SOURCE_FILES=(
    "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    "$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
    "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"
    "$HOME/.cargo/env"
    "$HOME/.profile_env"
)

for SOURCE_FILE in "${SOURCE_FILES[@]}"; do
    [ -f "$SOURCE_FILE" ] && source "$SOURCE_FILE"
done

PATHS=(
    "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/gnu-getopt/bin"
    "$HOMEBREW_PREFIX/opt/gnu-which/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/gnu-time/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/make/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/file-formula/bin"
    "$HOMEBREW_PREFIX/opt/unzip/bin"
    "$HOMEBREW_PREFIX/opt/ruby/bin"
    "$HOMEBREW_PREFIX/opt/whois/bin"
    "$HOMEBREW_PREFIX/opt/binutils/bin"
    "$HOMEBREW_PREFIX/opt/e2fsprogs/bin"
    "$HOMEBREW_PREFIX/opt/e2fsprogs/sbin"
    "$HOMEBREW_PREFIX/lib/ruby/gems/3.0.0/bin"
    "$HOMEBREW_PREFIX/opt/sqlite/bin"
    "$HOMEBREW_PREFIX/opt/openssl@3/bin"
    "$HOMEBREW_PREFIX/opt/curl/bin"
    "$HOMEBREW_PREFIX/opt/python@3/libexec/bin"
    "$HOMEBREW_PREFIX/opt/mysql@8.0/bin"
    "$HOME/Library/Python/3.9/bin"
    "$HOME/.nodebrew/current/bin"
    "$HOME/.cargo/bin"
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/"
    "$PATH"
    "/usr/local/bin"
)
for P in "${PATHS[@]}"; do
    [ "$P" == "$PATH" -o -d "$P" ] && NEW_PATH="$NEW_PATH:$P"
done
export PATH="$NEW_PATH"
unset PATHS NEW_PATH

command -v rbenv > /dev/null && eval "$(rbenv init -)"
command -v direnv > /dev/null && eval "$(direnv hook bash)"
