#-----------------------------------------------------------------------------
#  .profile v. 20230510.1
#  General config file for interactive POSIX shells
#  Sourced by shells other than bash so must be strictly POSIX-compliant.
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# ->  POSIX shell options
#-----------------------------------------------------------------------------
set		-o noclobber    # prevent accidental file clobbering
set		-o pipefail     # return zero only if all pipeline elements succeed


#-----------------------------------------------------------------------------
# ->  Misc settings
#-----------------------------------------------------------------------------
umask 022

# Disable terminal software flow control
# https://en.wikipedia.org/wiki/Software_flow_control
stty -ixon


#-----------------------------------------------------------------------------
# ->  Environment variables
#-----------------------------------------------------------------------------
export EDITOR=`which "nvim"`
export VISUAL="$EDITOR"
export SYSTEMD_EDITOR="$EDITOR"

# Save os name for use in conditionals
if uname -o | grep -Eiq "darwin" ; then
  # https://stackoverflow.com/questions/65259300/detect-apple-silicon-from-command-line
  if sysctl -n machdep.cpu.brand_string | grep -Eiq "intel" ; then
    export OS="macOS/Intel"
  else
    export OS="macOS/Apple"
  fi
elif uname -o | grep -Eiq "linux" ; then
  export OS="Linux"
fi


#-----------------------------------------------------------------------------
# ->  XDG variables
#     https://www.baeldung.com/linux/posix-shell-array
#----------------------------------------------------------------------------
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CACHE_HOME="$HOME"/.cache


#-----------------------------------------------------------------------------
# ->  Prepend personal directories to PATH
#     Note POSIX array syntax - set positional parameters
#     https://www.baeldung.com/linux/posix-shell-array
#-----------------------------------------------------------------------------
set -- "$HOME/.local/bin" "$HOME/bin"
for dir in "$@" ; do
  [ -d "$dir" ] || continue                             # not a dir
  echo $PATH | grep -Eq "(^|:)${dir}(:|$)" && continue  # already in PATH
  export PATH="${dir}${PATH+:$PATH}"
done


#-----------------------------------------------------------------------------
# ->  Homebrew/Linuxbrew
#-----------------------------------------------------------------------------
# Use POSIX echo | grep -q instead of bash =~
if echo "$OS" | grep -Eiq '^macos' ; then
  if echo "$OS" | grep -Eiq 'intel$' ; then
    export HOMEBREW_PREFIX="/usr/local"
  else
    export HOMEBREW_PREFIX="/opt/homebrew"
  fi
elif echo "$OS" | grep -Eiq "linux" ; then
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"

set -- "${HOMEBREW_PREFIX}/sbin" "${HOMEBREW_PREFIX}/bin"
for dir in "$@" ; do
  [ -d "$dir" ] || continue                             # not a dir
  echo $PATH | grep -Eq "(^|:)${dir}(:|$)" && continue  # already in PATH
  export PATH="${dir}${PATH+:$PATH}"
done

echo $MANPATH | grep -Eq "(^|:)${HOMEBREW_PREFIX}/share/man(:|$)"   \
  || export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}"
echo $INFOPATH | grep -Eq "(^|:)${HOMEBREW_PREFIX}/share/info(:|$)" \
  || export INFOPATH="$HOMEBREW_PREFIX/share/info${INFOPATH:-}"

