#-----------------------------------------------------------------------------
#  settings.sh v. 20230623.1
#  General config settings for interactive POSIX shells
#  Sourced by shells other than bash so must be strictly POSIX-compliant.
#-----------------------------------------------------------------------------

# POSIX shell options
set		-o noclobber    # prevent accidental file clobbering
set		-o pipefail     # return zero only if all pipeline elements succeed

# Disable terminal software flow control
# https://en.wikipedia.org/wiki/Software_flow_control
stty -ixon

