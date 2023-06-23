#-----------------------------------------------------------------------------
#  _env.sh v. 20230623.1
#  Environment variables for POSIX shells, sourced before other files
#  Sourced by .profile or .bash_profile
#-----------------------------------------------------------------------------

# OS identification - used in platform-specific configuration
if uname -o | grep -Eiq "darwin" ; then
    # https://stackoverflow.com/questions/65259300/detect-apple-silicon-from-command-line
    if sysctl -n machdep.cpu.brand_string | grep -Eiq "intel" ; then
        export OS="macos-intel"
    else
        export OS="macos-apple"
    fi
elif uname -o | grep -Eiq "linux" ; then
    export OS="linux"
fi

# Editors
export EDITOR=`which "nvim"`
export VISUAL="$EDITOR"
export SYSTEMD_EDITOR="$EDITOR"

# XDG variables
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CACHE_HOME="$HOME"/.cache

