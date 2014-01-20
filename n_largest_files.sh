#!/bin/ksh

####################################################
# Written By: Alejandro Perez Martin
# Purpose: Find N largest files in the given folders
# Dec 21, 2013
####################################################


##### Variables #####
lines=10
help=false
human=false
outputFormat="b"
outputSort="nr"
temporaryFile="/tmp/temporarylist"


##### Functions #####
error_msg() {
    echo "buscagordos: Missing arguments"
    echo "buscagordos: Syntax: 'buscagordos -[OPTIONS] [DIRECTORY] ... [DIRECTORY N]'"
    echo "buscagordos: Run 'buscagordos --help' for more options"
    exit 1
}

show_help() {
    printf "\nUsage: buscagordos [OPTION] ... [DIRECTORY] ...

Displays the N largest files in the specified folder/s.

If no directories are specified, the current one (./) is examined
and 10 largest files are shown.

Mandatory arguments to long options are mandatory for short options too.

  -h, --help    display this help and exit
  -H, --human   print sizes in human readable format (e.g., 1K 234M 2G)
  -b            display results in Bytes (B)
  -k            display results in Kilobytes (KB)
  -m            display results in Megabytes (MB)
  -n NUM        output the NUM largest files, if omitted,
                default value 10 is taken
  -s, --sort    display results from shortest to largest,
                if not specified, display from largest to shortest

Example of use:
    buscagordos -[n number, b, k, m, s] directory ... directory_n\n\n"
    exit 0
}


##### Options #####
while getopts ":n:bkms(sort):h(help)H(human)" option
do
    case $option in
        n)  lines=$OPTARG ;;
        :)  echo "buscagordos: Option -$OPTARG needs an argument" ;;
        h)  show_help ;;
        H)  human=true ;;
        b)  outputFormat="b" ;;
        k)  outputFormat="k" ;;
        m)  outputFormat="m" ;;
        s)  outputSort="n" ;;
        *)  echo "buscagordos: invalid option '-$OPTARG'"
            echo "Try 'buscagordos --help' for more information."
            return 1 ;;
    esac

    [[ $human = true ]] && outputFormat="$outputFormat""h"

done

shift $(( OPTIND - 1 ))


##### Search #####
if [[ $# -eq 0 ]]; then
    du -a"$outputFormat" | sort -"$outputSort"
else
    touch "$temporaryFile"
    if [[ -e "$temporaryFile" ]]; then
        for directory in "$@"; do
            if [[ -d "$directory" ]]; then
                du -a"$outputFormat" "$directory" | sort -"$outputSort" | head -$lines >> "$temporaryFile"
            else
                echo "Directory '$directory' not exists."
            fi
        done
        sort -"$outputSort" "$temporaryFile" | head -$lines
        rm -f "$temporaryFile" && exit 0
    else
        echo "(ERROR): Could not create temporary file."
        exit 1
    fi
fi

# https://developer.blackberry.com/native/documentation/core/com.qnx.doc.neutrino.user_guide/topic/scripts_ksh_arguments.html
# http://linux-training.be/files/books/html/fun/ch21s05.html
