#-----------------------------------------------------------------------------
#  bash_profile v. 20230507.1
#  Settings for interactive login bash shells
#  Does nothing but source .profile and .bashrc
#-----------------------------------------------------------------------------
# Ensure these files exist or are symlinks to appropriate files
profile="$HOME/.profile"
bashrc="$HOME/.bashrc"

# Source ~/.profile
if [[ -r "$profile" ]]; then
  if [[ -z "$LOOP_GUARD" ]]; then
    export LOOP_GUARD=1
    source "$profile" &>/dev/null
  fi
  unset LOOP_GUARD
fi

# Source ~/.bashrc
if [[ -r "$bashrc" ]]; then
  if [[ -z "$LOOP_GUARD" ]]; then
    export LOOP_GUARD=1
    source "$bashrc" &>/dev/null
  fi
  unset LOOP_GUARD
fi

