#!/bin/sh
#
# SCRIPT: wav2mp3.sh
# AUTHOR: Janos Gyerik <janos.gyerik@gmail.com>
# DATE:   2006-08-26
# REV:    1.0.T (Valid are A, B, D, T and P)
#               (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: Not platform dependent
#
# PURPOSE: Convert wav files specified on the command line to mp3 using
#          an available converter. 
#          Currently supported converters:
#          * bladeenc
#          * lame
#
# REV LIST:
#        DATE:	DATE_of_REVISION
#        BY:	AUTHOR_of_MODIFICATION   
#        MODIFICATION: Describe what was modified, new features, etc-
#
#
# set -n   # Uncomment to check your syntax, without execution.
#          # NOTE: Do not forget to put the comment back in or
#          #       the shell script will not execute!
# set -x   # Uncomment to debug this shell script (Korn shell only)
#          

usage() {
    test $# = 0 || echo $@
    echo "Usage: $0 [OPTION]... [ARG]..."
    echo "Convert wav files specified on the command line to mp3."
    echo
    echo "  -c, --converter CONVERTER   Use converter, default = autodetect"
    echo "  -r, --bitrate BITRATE       Set bitrate, default = $bitrate"
    echo
    echo "  -h, --help                  Print this help"
    echo
    exit 1
}

neg=0
args=
#arg=
#flag=off
#param=
converter=
bitrate=192
while [ $# != 0 ]; do
    case $1 in
    -h|--help) usage ;;
#    !) neg=1; shift; continue ;;
#    -f|--flag) test $neg = 1 && flag=off || flag=on ;;
#    -p|--param) shift; param=$1 ;;
    -c|--converter) shift; converter=$1 ;;
    -r|--br|--bitrate) shift; bitrate=$1 ;;
#    --) shift; while [ $# != 0 ]; do args="$args \"$1\""; shift; done; break ;;
    -?*) usage "Unknown option: $1" ;;
    *) args="$args \"$1\"" ;;  # script that takes multiple arguments
#    *) test "$arg" && usage || arg=$1 ;;  # strict with excess arguments
#    *) arg=$1 ;;  # forgiving with excess arguments
    esac
    shift
    neg=0
done

eval "set -- $args"

if ! test "$converter"; then
    try="bladeenc lame"
    for i in $try; do
	type $i 2>/dev/null >/dev/null && converter=$i && break
    done

    if ! test "$converter"; then
	echo "Couldn't find any of the converters:"
	for i in $try; do
	    echo "    $i"
	done
	echo "Exit."
	exit 1
    fi
fi

case `basename "$converter"` in
    bladeenc) 
	bitrate_op="-br $bitrate" 
	;;
    lame) 
	bitrate_op="-b $bitrate" 
	;;
    *)
	bitrate_op=$bitrate
	;;
esac

echo Using converter: $converter

for i in "$@"; do
    n=$(echo $i | sed -e "s/\.wav$/.mp3/")
    echo $converter $bitrate_op "$i" "$n"
    $converter $bitrate_op "$i" "$n"
done

# eof