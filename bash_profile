#-----------------------------------------------------------------------------
#  bash_profile v. 20230602.1
#  Settings for interactive login bash shells
#  Does nothing but source .bashrc
#-----------------------------------------------------------------------------
bashrc="$HOME/.bashrc"
if [[ -r "$bashrc" ]]; then
  if [[ -z "$LOOP_GUARD" ]]; then
    export LOOP_GUARD=1
    source "$bashrc" &>/dev/null
  fi
  unset LOOP_GUARD
fi

