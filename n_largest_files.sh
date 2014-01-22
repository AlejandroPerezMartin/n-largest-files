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
    echo "n_largest_files: Missing arguments"
    echo "n_largest_files: Syntax: 'n_largest_files -[OPTIONS] [DIRECTORY] ... [DIRECTORY N]'"
    echo "n_largest_files: Run 'n_largest_files --help' for more options"
    exit 1
}

show_help() {
    printf "\nUsage: n_largest_files [OPTION] ... [DIRECTORY] ...

Displays the N largest files in the specified folder/s.

If no directories are specified, the current one (./) is examined
and 10 largest files are shown.

Mandatory arguments to long options are mandatory for short options too.

  -h, --help    display this help and exit
  -H, --human   print sizes in human readable format (e.g., 1K 234M 2G)
  -b            display results in Bytes (B)
  -k            display results in Kilobytes (KB)
  -m            display results in Megabytes (MB)
  -NUM          output the NUM largest files (should be greater than 0),
                if omitted, default value 10 is taken
  -s, --sort    display results from shortest to largest,
                if not specified, display from largest to shortest

Example of use:
    n_largest_files -[NUM, b, k, m, H, s] directory ... directory_n\n\n"
    exit 0
}

##### Options #####
while getopts ":bkms(sort):h(help)H(human)" option
do
    case $option in
        h)  show_help ;;
        H)  human=true ;;
        b)  outputFormat="b" ;;
        k)  outputFormat="k" ;;
        m)  outputFormat="m" ;;
        s)  outputSort="n" ;;
        *)  if [[ ( -n $OPTARG ) && ( $OPTARG -gt 0 ) ]]; then
                lines=$OPTARG
            elif [[ $OPTARG -lt 1 ]]; then
                echo "(ERROR): You must enter a value greater than 0."
                exit 1
            else
                echo "n_largest_files: invalid option '-$OPTARG'"
                echo "Try 'n_largest_files --help' for more information."
                return 1
            fi ;;
    esac

    [[ $human = true ]] && outputFormat="$outputFormat""h"

done

shift $(( OPTIND - 1 ))


# Error message
[[ $# -lt 1 ]] && error_msg


##### Files Search #####
if [[ $# -eq 0 ]]; then
    find . -type f -print0 | du -a"$outputFormat" --files0-from - | sort -nr | head -$lines | sort -"$outputSort"
else
    touch "$temporaryFile"
    if [[ -e "$temporaryFile" ]]; then
        for directory in "$@"; do
            if [[ -d "$directory" ]]; then
                # Stores the 10 largest files of each folder in a temporary file
                find "$directory" -type f -print0 | du -a"$outputFormat" --files0-from - | sort -nr | head -$lines >> /tmp/temporarylist
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
