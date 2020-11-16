#!/bin/bash

#check if user wants help
if [ "$1" == "--help" ]; then
echo -e "\n------------------------DOCUMENTATION------------------------\n"
echo -e "   Usage ./findipaddrs.sh DIRECTORY [-u IP_ADDR | -p IP_ADDR] \n\n"
echo -e "Required:\n"
echo -e "   DIRECTORY: The starting directory. This directory will be traversed recursively.\n"
echo -e "Options:\n"
echo -e "   None/Default: Print the number of times any IP Address in occurs in any file in the directories below\n"
echo -e "   -u: Find the number of times a passed ip address occurs in each file in the directory\n"
echo -e "   -p: Find the number of times a passed ip address occurs in each file in the directory\n"
echo -e "   IP_ADDR: IPv4 address in dot-decimal notation\n"
echo -e "\n"
exit 1
fi

#check for the correct # of params are passed through
if [ "$#" -lt 1 ]; then
    echo -e "Usage ./findipaddrs.sh DIRECTORY [-u IP_ADDR | -p IP_ADDR]"
    exit 2
#this statement checks if an option is selected but no IP Addr is passed
elif [ "$2" ] && [ -z "$3" ]; then
    #if ip addr passed in but no option then let the user know
    echo -e "Option selected but no IP Address passed.\n Please provide an IP Address to search for. For help type ./findipaddrs.sh --help"
    exit 3
fi

perfile ()
{
#grab just the unique files names and then for each file in the list, get the # of ip addrs per file
uniqfiles=$(grep --binary-files=text -or "$2" $1 | awk 'BEGIN { FS=":" } { print $1 }' | sort | uniq)
if [ -z "$uniqfiles" ]; then
    echo -e "IP Address $2 not found in any file(s)"
else
    for i in $uniqfiles; do
        #grab just the filename from each result and how many times it occurs in each file
        res=$(grep --binary-files=text -or "$2" $i | wc -l)
        file=$(echo "$i" | awk 'BEGIN { FS=":" } { print $1 }')
        #uncomment to print only the filename rather than full path
        #file=${file##*/}
        echo -e "IP Address $2 occurs $res time(s) in $file"
    done
fi  
}

unique () 
{
res=$(grep --binary-files=text -or "$2" $1 | wc -l)
if [ "$res" == 0 ]; then
    echo "IP Address $2 not found in any file(s)"
else
    echo "IP Address $2 occurs $res time(s) in file(s): "
fi
grep --binary-files=text -or "$2" $1 | awk 'BEGIN { FS=":" } { print $1 }' | sort | uniq
}

default_behaviour ()
{
#Alternative regex grep -E -or "[1-2]?[0-9]{1,2}\.[1-2]?[0-9]{1,2}\.[1-2]?[0-9]{1,2}\.[1-2]?[0-9]{1,2}"
list=$(grep --binary-files=text -E -or "[1-2]{,1}[0-9]{1,2}\.[1-2]{,1}[0-9]{1,2}\.[1-2]{,1}[0-9]{1,2}\.[1-2]{,1}[0-9]{1,2}" $1)
res=$(echo "$list" | wc -l)
#sort the ip's and then get just the unique ones. The uniq only removes adjacent lines that are the same
formatlist=$(echo "$list" | awk 'BEGIN { FS=":" } { print $2 }' | sort |  uniq)
echo -e "Instances of IP addresses found: $res \nHere's the list of unique IP addresses found:"
for i in $formatlist; do
    unique $1 $i
done
}

case "$2" in
    -u)
       # pass in the ip addr so we can use inside the function. Params $1....$N are not available within func
       unique $1 $3
       ;;
    -p)
       perfile $1 $3
       ;;
    *)
       #default case, only directory specified
       default_behaviour $1
       ;;
esac 