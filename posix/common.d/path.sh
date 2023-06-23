#-----------------------------------------------------------------------------
#  path.cfg v.20230623.1
#  Custom modifications to PATH
#  Sourced by shells other than bash so must be strictly POSIX-compliant.
#  Use echo | grep -q instead of bash =~
#  Use POSIX set -- arg1 arg2 ... instead of bash array (arg1 arg2 ...)
#    https://www.baeldung.com/linux/posix-shell-array
#-----------------------------------------------------------------------------

set -- "$HOME/.local/bin" "$HOME/bin"
for dir in "$@" ; do
  [ -d "$dir" ] || continue                             # dir not found
  echo $PATH | grep -Eq "(^|:)${dir}(:|$)" && continue  # already in PATH
  export PATH="${dir}${PATH+:$PATH}"
done


