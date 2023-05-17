#-----------------------------------------------------------------------------
#  bash_aliases v. 20230507.1
#  Alias definition file, sourced by bash_profile
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# ->  Aliases good on all platforms
#-----------------------------------------------------------------------------
alias ll='ls -lh'       # long, human-friendly numbers
alias la='ll -ah'       # include dotfiles
alias lr='ll -Rh'				# recursive

alias ..='cd ..'
alias c2='pushd'        # mnemonic: 'change to'
alias b2='popd'         # mnemonic: 'back to'
alias dv='dirs -v'			# print directory stack

alias hist='history'


#-----------------------------------------------------------------------------
# ->  Platform-specific behavior
#-----------------------------------------------------------------------------
# Mac-specific
if (shopt -s nocasematch; [[ $OS =~ macos ]]); then
  alias bash='/usr/local/bin/bash'		# homebrew bash
  alias bash5='bash'						      # same
  alias bash3='/bin/bash'				      # macOS bash (3.2)
  # alias R='/usr/local/bin/r'				# r is zsh built-in (same as fc)

# Linux-specific
elif (shopt -s nocasematch; [[ $OS =~ linux ]]); then
  :    # 'noop' placeholder
fi
