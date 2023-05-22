#-----------------------------------------------------------------------------
#  psfuncs v. 20230522.1
#  Defines fancy, colored PS1, PS2 ..., and related functions
#  Function synopsis:
#  - colp [off|false|no]: turns color prompt on/off
#  - simp [off|false|no]: converts to/from multiline prompt
#  - fanp [off|false|no]: turns on/off both color and detail in one command
#  - palette displays a palette of all 256 colors
#-----------------------------------------------------------------------------

# Turn color on/off
# colp off|false|no turns color off; anything else turns it on
function pcolor {
  case "$TERM" in
    xterm-color|*-256color) ;;
                         *) unset color_prompt    # color not supported
                            return 1;;
  esac

  # Subshell preserves current shell's nocasematch setting
  if (shopt -s nocasematch; [[ $1 =~ ^(off|false|no) ]]); then
    unset color_prompt
  else
    color_prompt=true
  fi
}

alias pcol='pcolor'
alias pmon='pcolor off'


# Simplify prompt to single line
# simplep off|false|no restores full detail.
function pmultiple {
  if (shopt -s nocasematch; [[ $1 =~ ^(off|false|no) ]]); then
    unset multiline_prompt
  else
    multiline_prompt=true
  fi
}

alias pmult='pmultiple'
alias psimp='pmultiple off'


# Turn color and detail on/off together
function pfancy {
  if (shopt -s nocasematch; [[ $1 =~ ^(off|false|no) ]]); then
    unset multiline_prompt && unset color_prompt
  else
    multiline_prompt=true && color_prompt=true
  fi
}

alias pfan='pfancy'
alias pplain='pfancy off'


# Display all 256 colors
function palette {
  for clr in {1..255}; do
    echo -en "\e[38;5;${clr}m${clr} "
  done
  echo -e "\e[0m"
}


function refresh_prompts {

	# Capture exit code of previous command before doing anything else
	# '##0' strips all leading zeros, leaving non-zero exit code or null string
	local xc=${?##0}

  # Clear all prompt variable coloring
  local reset='\[\e[0m\]'
  PS1="${reset}"
  PS2="${reset}"
  PS3="${reset}"
  PS4="${reset}"

  if [[ -n $color_prompt ]]; then
    # Color foreground values
    # If color_prompt not set these are empty
    local red='\[\e[38;5;196m\]'
    local yellow='\[\e[38;5;184m\]'
    local gold='\[\e[38;5;222m\]'
    local beige='\[\e[38;5;229m\]'
    local orange='\[\e[38;5;208m\]'
    local earth='\[\e[38;5;137m\]'
    local forest='\[\e[38;5;107m\]'
    local pale_green='\[\e[38;5;149m\]'
    local olive='\[\e[38;5;101m\]'
    local turquoise='\[\e[38;5;37m\]'
    local sky='\[\e[38;5;117m\]'
    local blue='\[\e[38;5;111m\]'
    local pink='\[\e[38;5;183m\]'
  fi

  # Monochrome foreground values - not dependent on color_prompt
  local dark='\[\e[38;5;243m\]'
  local grey='\[\e[38;5;247m\]'
  local silver='\[\e[38;5;251m\]'
  local white='\[\e[38;5;231m\]'

  # Fancify if multiline_prompt set to nonempty value
  if [[ -n $multiline_prompt ]]; then

    # First line: right-justified timestamp
    # \r = carriage return without line feed
    # ${...@P} = expand variable as if a prompt escape, here a strftime string
    local rt_prompt="\D{%H:%M %a %b %e}"
    printf -v PS1 "${earth}%${COLUMNS}s\r" "${rt_prompt@P}"

    # First line: error flag, SSH warning, user, hostname and cwd
    PS1+="${earth}┌─"
    PS1+="${xc:+${red}$xc! }"   # prev exit code, if !=0
    if [[ -n "$SSH_CLIENT" ]]; then
      # PS1+="${c_info}\u "
      PS1+="${pink}\h* "					# hostname
    else
      PS1+="${gold}\h "
    fi
    PS1+="${forest}\u "           # user
    PS1+="${blue}\w "    				# current directory
    PS1+="\n"

    # Second line: shell level and history number
    PS1+="${earth}└─"
    # PS1+="${earth}\s \v"				# shell version
    (( SHLVL > 1 )) && PS1+="${orange}$SHLVL:"
    PS1+="${earth}\! "
    PS1+="${earth}» "
    
    PS2="${earth}... "          # continuation
    PS3="${earth}#? "           # selection
    PS4="${earth}+${LINENO}: "  # trace

  # single-line prompt
  else
    local rt_prompt="\D{%H:%M}"
    printf -v PS1 "${earth}%${COLUMNS}s\r" "${rt_prompt@P}"
    PS1+="${xc:+${red}$xc! }"   # prev exit code, if !=0
    (( SHLVL > 1 )) && PS1+="${earth}[$SHLVL] "
    if [[ -n "$SSH_CLIENT" ]]; then
      PS1+="${pink}\h* "					# hostname
    else
      PS1+="${gold}\h "
    fi
    # [[ -n "$SSH_CLIENT" ]] && PS1+="${gold}\h* "
    PS1+="${forest}\u "
    PS1+="${blue}\w "
    PS1+="${blue}» "
    
    PS2="${blue}... "          # continuation
    PS3="${blue}#? "           # selection
    PS4="${blue}+${LINENO}: "  # trace
  fi

  # Reset for user input
  PS1+="${reset}"
  PS2+="${reset}"
  PS3+="${reset}"
  PS4+="${reset}"
}

