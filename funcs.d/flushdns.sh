#-----------------------------------------------------------------------------
#  flushdns.sh v. 20230619.1
#  Clear local DNS cache (macOS or Linux)
#-----------------------------------------------------------------------------
function flushdns {

    local sudo=
    (( $EUID != 0 )) && sudo="sudo"

    # OS is defined in .profile
    if [[ "$OS" =~ ^macOS ]]; then
        # https://www.lifewire.com/flush-dns-cache-on-a-mac-5209298
        $sudo dscacheutil -flushcache
        $sudo killall -HUP mDNSResponder
    elif [[ "$OS" =~ ^Linux ]]; then
        echo https://www.howtogeek.com/844964/how-to-flush-dns-in-linux/
    fi
}
