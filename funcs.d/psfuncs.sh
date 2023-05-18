#-----------------------------------------------------------------------------
#  psfuncs v. 20230518.1
#  Defines fancy, colored PS1, PS2 ..., and related functions
#  Function synopsis:
#  - colp [off|false|no]: turns color prompt on/off
#  - simp [off|false|no]: converts to/from multiline prompt
#  - fanp [off|false|no]: turns on/off both color and detail in one command
#  - palette displays a palette of all 256 colors
#-----------------------------------------------------------------------------

# Turn color on/off
# colp off|false|no turns color off; anything else turns it on
function colp {
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


# Simplify prompt to single line
# simplep off|false|no restores full detail.
function simp {
  if (shopt -s nocasematch; [[ $1 =~ ^(off|false|no) ]]); then
    multiline_prompt=true
  else
    unset multiline_prompt
  fi
}

# Turn color and detail on/off together
function fanp {
  if (shopt -s nocasematch; [[ $1 =~ ^(off|false|no) ]]); then
    unset multiline_prompt && unset color_prompt
  else
    multiline_prompt=true && color_prompt=true
  fi
}


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

  # Color foreground values
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

  # Monochrome foreground values
  local dark='\[\e[38;5;243m\]'
  local grey='\[\e[38;5;247m\]'
  local silver='\[\e[38;5;251m\]'
  local white='\[\e[38;5;231m\]'

  local reset='\[\e[0m\]'

  # Colorize if color_prompt set to nonempty value
  if [[ -n $color_prompt ]]; then
    local c_err=$red
    local c_info=$pink
    local c_box=$earth
    local c_right=$c_box
    local c_user=$gold
    local c_host=$forest
    local c_cwd=$blue
    local c_shlvl=$orange
    local c_hist=$c_box
    local c_dollar=$c_cwd
  else
    local c_err=$white
    local c_info=$silver
    local c_box=$dark
    local c_right=$c_box
    local c_user=$silver
    local c_host=$grey
    local c_cwd=$dark
    local c_shlvl=$dark
    local c_hist=$dark
    local c_dollar=$dark
  fi

  # Fancify if multiline_prompt set to nonempty value
  if [[ -n $multiline_prompt ]]; then

    # First line: right-justified timestamp
    # \r = carriage return without line feed
    # ${...@P} = expand variable as if a prompt escape, here a strftime string
    local rt_prompt="\D{%H:%M %a %b %e}"
    printf -v PS1 "${c_right}%${COLUMNS}s\r" "${rt_prompt@P}"

    # First line: error flag, SSH warning, user, hostname and cwd
    PS1+="${c_left}┌─"
    PS1+="${xc:+${c_err}$xc! }"   # prev exit code, if !=0
    PS1+="${c_user}\u "            # user
    if [[ -n "$SSH_CLIENT" ]]; then
      # PS1+="${c_info}\u "
      PS1+="${c_host}(\h) "					# hostname
    else
      PS1+="${c_host}\h "
    fi
    PS1+="${c_cwd}\w"					# current directory
    PS1+="\n"

    # Second line: shell level and history number
    PS1+="${c_box}└─"
    # PS1+="${earth}\s \v"				# shell version
    (( SHLVL > 1 )) && PS1+="${c_shlvl}$SHLVL:"
    PS1+="${c_hist}\!"
    PS1+="${c_box} \$ "
    PS1+="${reset}"
    
  else    # simple (single-line) prompt
    if [[ -n "$SSH_CLIENT" ]]; then
      # PS1+="${c_info}\u "
      PS1="${c_info}(\u@\h) "					# hostname
    else
      PS1="${c_host}\h "
    fi
    PS1+="${c_cwd}\w ${c_dollar}\$ ${reset}"
    PS2="${c_cwd}... ${reset}"          # continuation
    PS3="${c_cwd}#? ${reset}"           # selection
    PS3="${c_cwd}+${LINENO}: "${reset}  # trace
  fi
}

