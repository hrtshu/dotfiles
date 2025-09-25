# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export ORIG_PATH="${ORIG_PATH:-"$PATH"}"

##### export #####
export EDITOR=vim
export LESS="$LESS -R"
[ -d "$HOME/go" ] && export GOPATH="$HOME/go"
[[ "$OSTYPE" == "darwin"* ]] && export BASH_SILENCE_DEPRECATION_WARNING=1
export ASDF_GOLANG_MOD_VERSION_ENABLED=true

# homebrew
[ "$(/usr/bin/uname -m)" = "arm64" ] && BREW=/opt/homebrew/bin/brew # apple silicon
[ "$(/usr/bin/uname -m)" = "x86_64" ] && BREW=/usr/local/bin/brew # intel
if [ -x "$BREW" ]; then
    eval $($BREW shellenv)
    export ORIG_PATH_WITH_BREW="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$ORIG_PATH"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

SOURCE_FILES=(
    "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    "$HOMEBREW_REPOSITORY/Library/Homebrew/command-not-found/handler.sh"
    "$HOME/.cargo/env"
    "$HOME/.nvm/nvm.sh"
    "$HOME/.nvm/bash_completion"
    "$HOME/google-cloud-sdk/path.bash.inc" # updates PATH for the Google Cloud SDK.
    "$HOME/google-cloud-sdk/completion.bash.inc" # enables shell command completion for gcloud.
    "$HOME/.profile_env"
)

PATHS=(
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/.asdf/shims"
    "$HOME/.rd/bin"
    "$HOME/.orbstack/bin"
    "$HOME/.lmstudio/bin"
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
    # "$HOMEBREW_PREFIX/opt/ruby/bin" # asdfのrubyを優先する
    "$HOMEBREW_PREFIX/opt/whois/bin"
    "$HOMEBREW_PREFIX/opt/binutils/bin"
    "$HOMEBREW_PREFIX/opt/e2fsprogs/bin"
    "$HOMEBREW_PREFIX/opt/e2fsprogs/sbin"
    "$HOMEBREW_PREFIX/opt/sqlite/bin"
    "$HOMEBREW_PREFIX/opt/openssl@3/bin"
    "$HOMEBREW_PREFIX/opt/curl/bin"
    "$HOMEBREW_PREFIX/opt/python@3/libexec/bin"
    "$HOMEBREW_PREFIX/opt/mysql@8.0/bin"
    "$HOMEBREW_PREFIX/opt/lsof/bin"
    "$HOME/Library/Python/3.9/bin"
    "$HOME/.nodebrew/current/bin"
    "$HOME/.cargo/bin"
    "$GOPATH/bin"
    "/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home/bin"
)

##### source #####
for SOURCE_FILE in "${SOURCE_FILES[@]}"; do
    [ -f "$SOURCE_FILE" ] && source "$SOURCE_FILE"
done
unset SOURCE_FILES

##### eval #####
# [ -x /usr/bin/keychain ] && eval $(/usr/bin/keychain --eval --agents ssh --noask)
command -v rbenv > /dev/null && eval "$(rbenv init -)"
command -v direnv > /dev/null && eval "$(direnv hook bash)"

##### path #####
for P in "${PATHS[@]}"; do
    [ -d "$P" ] && NEW_PATH="$NEW_PATH:$P"
done
export NEW_PATH="${NEW_PATH#:}"
export PATH="$NEW_PATH:$PATH"
unset PATHS NEW_PATH

# remove duplicates
old_PATH="$PATH:"; PATH=
while [ -n "$old_PATH" ]; do
    x="${old_PATH%%:*}"      # the first remaining entry
    case "$PATH": in
        *:"$x":*) ;;         # already there
        *) PATH="$PATH:$x";; # not there yet
    esac
    old_PATH="${old_PATH#*:}"
done
export PATH="${PATH#:}"
unset old_PATH x

##### alias #####
# GNU系のコマンドが邪魔をしてasdf install ruby xxxx等が失敗することがあるためこれで回避
# asdfのrustcが使えるように $HOME/.asdf/shims/ を追加(rustcはyjitを有効にしたrubyのインストールで必要)
alias asdf='PATH="$HOME/.asdf/shims/:$ORIG_PATH_WITH_BREW" RUBY_CONFIGURE_OPTS=--enable-yjit asdf'
alias bundle='PATH="$HOME/.asdf/shims/:$ORIG_PATH_WITH_BREW" bundle'
