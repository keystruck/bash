#-----------------------------------------------------------------------------
#  bash_profile v. 20230618.1
#  Settings for interactive login bash shells
#  Does nothing but source .profile and .bashrc
#-----------------------------------------------------------------------------
profile="$HOME/.profile"
bashrc="$HOME/.bashrc"

if [[ -r "$profile" ]]; then
  if [[ -z "$LOOP_GUARD" ]]; then
    export LOOP_GUARD=1
    source "$profile" &>/dev/null
  fi
  unset LOOP_GUARD
fi

if [[ -r "$bashrc" ]]; then
  if [[ -z "$LOOP_GUARD" ]]; then
    export LOOP_GUARD=1
    source "$bashrc" &>/dev/null
  fi
  unset LOOP_GUARD
fi

