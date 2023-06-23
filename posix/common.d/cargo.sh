#-----------------------------------------------------------------------------
#  cargo.cfg v.20230623.1
#  Rust/cargo configuration
#  Sourced by shells other than bash so must be strictly POSIX-compliant.
#  Use echo | grep -q instead of bash =~
#  Use POSIX set -- arg1 arg2 ... instead of bash array (arg1 arg2 ...)
#    https://www.baeldung.com/linux/posix-shell-array
#-----------------------------------------------------------------------------

# ->  Prepend Rust binary directory to PATH
set -- "$HOME/.cargo/bin"
for dir in "$@" ; do
    [ -d "$dir" ] || continue                             # not a dir
    echo $PATH | grep -Eq "(^|:)${dir}(:|$)" && continue  # already in PATH
    export PATH="${dir}${PATH+:$PATH}"
done

