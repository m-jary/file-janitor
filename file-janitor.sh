#!/usr/bin/env bash

echo "File Janitor, 2024"
echo -e "Powered by Bash\n"

summarise() {
number_of_tmp=$(find "$1" -maxdepth 1 -name "*.tmp" -type f | wc -l)
number_of_log=$(find "$1" -maxdepth 1 -name "*.log" -type f | wc -l)
number_of_py=$(find "$1" -maxdepth 1 -name "*.py" -type f | wc -l)

size_of_tmp=$(find "$1" -maxdepth 1 -name "*.tmp" -type f -exec du -bc {} \+ | tail -1 | cut -f 1)
size_of_log=$(find "$1" -maxdepth 1 -name "*.log" -type f -exec du -bc {} \+ | tail -1 | cut -f 1)
size_of_py=$(find "$1" -maxdepth 1 -name "*.py" -type f -exec du -bc {} \+ | tail -1 | cut -f 1)

[[ -z $size_of_tmp ]] && size_of_tmp=0
[[ -z $size_of_log ]] && size_of_log=0
[[ -z $size_of_py ]] && size_of_py=0

echo "$number_of_tmp tmp file(s), with total size of $size_of_tmp bytes"
echo "$number_of_log log file(s), with total size of $size_of_log bytes"
echo "$number_of_py py file(s), with total size of $size_of_py bytes"
}

clean() {
number_of_log=$(find "$1" -maxdepth 1 -name "*.log" -type f -mtime +3 | wc -l)
number_of_tmp=$(find "$1" -maxdepth 1 -name "*.tmp" -type f | wc -l)
number_of_py=$(find "$1" -maxdepth 1 -name "*.py" -type f | wc -l)

if [[ $number_of_py -ne 0 ]]; then
    mkdir "$1"/python_scripts
fi

find "$1" -maxdepth 1 -name "*.log" -type f -mtime +3 -exec rm {} \;
find "$1" -maxdepth 1 -name "*.tmp" -type f -exec rm {} \;
find "$1" -maxdepth 1 -name "*.py" -type f -exec mv {} "$1"/python_scripts \;

echo "Deleting old log files...  done! $number_of_log files have been deleted"
echo "Deleting temporary files...  done! $number_of_tmp files have been deleted"
echo "Moving python files...  done! $number_of_py files have been moved"
}

case "$1" in

    "help")
       cat file-janitor-help.txt;;
    "list")
        if [ -z "$2" ]; then
            echo -e "Listing files in the current directory\n"
            ls -A
        elif [ -d "$2" ]; then
            echo -e "Listing files in $2\n"
            ls -A "$2"
        elif [ -f "$2" ]; then
            echo "$2 is not a directory"
        else
            echo "$2 is not found"
        fi;;
    "report")
        if [ -z "$2" ]; then
            echo -e "The current directory contains:\n"
            summarise .
        elif [ -d "$2" ]; then
            echo -e "$2 contains:\n"
            summarise "$2"
        elif [ -f "$2" ]; then
            echo "$2 is not a directory"
        else
            echo "$2 is not found"
        fi;;
    "clean")
        if [ -z "$2" ]; then
            echo -e "Cleaning the current directory...\n"
            clean .
        elif [ -d "$2" ]; then
            echo -e "Cleaning $2...\n"
            clean "$2"
        elif [ -f "$2" ]; then
            echo "$2 is not a directory"
        else
            echo "$2 is not found"
        fi;;
    *)
        echo "Type file-janitor.sh help to see available options"
        
esac