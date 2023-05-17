#-----------------------------------------------------------------------------
#  psfuncs v. 20230506.1
#  Defines fancy, colored PS1, PS2 ..., and related functions
#  Function synopsis:
#  - colorp [off|false|no]: turns color prompt on/off
#  - simplep [off|false|no]: converts to/from multiline prompt
#  - fancyp [off|false|no]: turns on/off both color and detail in one command
#-----------------------------------------------------------------------------

# Turn color on/off
# colorp off|false|no turns color off; anything else turns it on
function colorp {
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
function simplep {
  if (shopt -s nocasematch; [[ $1 =~ ^(off|false|no) ]]); then
    multiline_prompt=true
  else
    unset multiline_prompt
  fi
}

# Turn color and detail on/off together
function fancyp {
  if (shopt -s nocasematch; [[ $1 =~ ^(off|false|no) ]]); then
    unset multiline_prompt && unset color_prompt
  else
    multiline_prompt=true && color_prompt=true
  fi
}


function refresh_prompts {

	# Capture exit code of previous command before doing anything else
	# '##0' strips all leading zeros, leaving non-zero exit code or null string
	local xc=${?##0}

  # Colorize if color_prompt set to nonempty value
  if [[ -n $color_prompt ]]; then
    # Foreground color escape sequences
    local red='\[\e[38;5;196m\]'
    local yellow='\[\e[38;5;184m\]'
    local gold='\[\e[38;5;222m\]'
    local beige='\[\e[38;5;229m\]'
    local orange='\[\e[38;5;130m\]'
    local earth='\[\e[38;5;137m\]'
    local forest='\[\e[38;5;107m\]'
    local pale_green='\[\e[38;5;149m\]'
    local olive='\[\e[38;5;101m\]'
    local turquoise='\[\e[38;5;37m\]'
    local sky='\[\e[38;5;117m\]'
    local blue='\[\e[38;5;111m\]'
    local pink='\[\e[38;5;183m\]'
    local reset='\[\e[0m\]'
  fi

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
    [[ -n "$SSH_CLIENT" ]] && PS1+="${orange}(SSH) "
    PS1+="${gold}\u"            # user
    PS1+="${forest} \h"					# hostname
    PS1+="${blue} $PWD"					# current directory (full path)
    PS1+="\n"

    # Second line: shell level and history number
    PS1+="${earth}└─"
    # PS1+="${earth}\s \v"				# shell version
    (( SHLVL > 1 )) && PS1+="${earth}$SHLVL/"
    PS1+="${earth}\!"
    PS1+="${earth}: "
    PS1+="${reset}"
    
  else
    # Single-line prompt
    PS1="${earth}\u${forest}@\h${blue}:\w ${earth}\$ ${reset}"
    PS2="${earth}... ${reset}"          # continuation
    PS3="${earth}#? ${reset}"           # selection
    PS3="${earth}+${LINENO}: "${reset}  # trace
  fi
}

