#!/bin/bash

TEMP_FILE_PATH="./pdf-bulkcheck-temp-sdcishudcid756578372fhu76t76t65rftjhiuc.txt";

function print_usage() {
    echo "pdf-bulkcheck (bulk pdf corruption check)";
    echo "Usage: pdf-bulkcheck <base_dir> <log_file>";
    echo "    base_dir - where the pdf files are stored";
    echo "    log_file - where the corrupted pdf paths will be stored";
}

# $1 - file path
function check_pdf() {
    echo "Checking $1";
    pdftotext "$1" "$TEMP_FILE_PATH";
    return $?;
}

# $1 - directory path
# $2 - log file path
function bulk_check() {
    echo '============' >> "$2";
    for f in "$1"/*.pdf; do
        if ! check_pdf "$f"; then
	    echo "$f" >> "$2";
	fi;
    done;	
    echo '============' >> "$2";
}

if [ "$1" = "" ]; then
    echo 'Arg 1 is empty'; print_usage; exit 1;
fi;
if [ ! -d "$1" ]; then
    echo 'Arg 1 is not a directory'; print_usage; exit 1;
fi;
if [ "$2" = "" ]; then
    echo 'Arg 2 is empty'; print_usage; exit 1;
fi;
if [ -f "$2" ]; then
    read -p "Arg \$2: file $2 already exists. Shall we proceeed?" -n 1 -r;
    echo;
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting";
	exit 1;
    fi;
fi;

bulk_check "$1" "$2";

if [ -f "$TEMP_FILE_PATH" ]; then
    rm "$TEMP_FILE_PATH";
fi;

