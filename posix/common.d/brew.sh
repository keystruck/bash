#-----------------------------------------------------------------------------
#  brew.cfg v. 20230623.1
#  Homebrew/linuxbrew configuration
#  Sourced by shells other than bash so must be strictly POSIX-compliant.
#  Use echo | grep -q instead of bash =~
#  Use POSIX set -- arg1 arg2 ... instead of bash array (arg1 arg2 ...)
#    https://www.baeldung.com/linux/posix-shell-array
#-----------------------------------------------------------------------------

# Define prefix and pathnames
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


# PATH variables
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

