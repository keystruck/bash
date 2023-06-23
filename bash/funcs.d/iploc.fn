#-----------------------------------------------------------------------------
#  iploc.sh v. 20230504.1
#  Defines iploc function (print current public IP address and location)
#-----------------------------------------------------------------------------
function iploc {

  # Is 'curl' in PATH?
	if ! hash curl &>/dev/null; then
    printf "${FUNCNAME[0]}: 'curl' required but not found in \$PATH." >/dev/stderr
		return 1
	fi

  # Allow 5 seconds to complete entire query
  local timeout=5

  # Is 'jq' in PATH? Needed to extract json data from ipinfo response.
  if hash jq &>/dev/null; then
    local data=$(curl -sL -m $timeout ipinfo.io)
    if [[ -n $data ]]; then
      local ip=$(jq -r '.ip'           <<< $data)
      local city=$(jq -r '.city'       <<< $data)
      local country=$(jq -r '.country' <<< $data)
      printf "%-20s%s, %s\n" $ip $city $country
      return 0
    fi
  # Fallback if jq not installed or $data empty
  elif (curl -sL http://ipecho.net/plain && echo); then
    return 0;
  fi

  # No luck reaching either server: exit with error message.
  die 2 "${FUNCNAME[0]}: unable to reach servers. Exiting."
}


# 'myip' is a pain to type, use iploc instead
function myip {
  printf "Function 'myip' is deprecated; call 'iploc' instead.\n"
}
