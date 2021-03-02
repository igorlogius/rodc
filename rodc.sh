#!/bin/bash

logger "blub00"
TMP=$(mktemp)
LOG=/tmp/rodc.log
date >> $LOG 
#cat /dev/stdin > $TMP

read -n 1 -r LEN_CHAR

logger "$LEN_CHAR"

# todo: DAS geht bestimmt auch einfacher !!!!!!!!!!!!!!!!!
LEN=$(echo "ibase=16; $(echo -n 'u' | xxd -p)" | bc)
#logger "$LEN"

read -n $LEN -r DATA
#logger "$DATA"

#cat $TMP >> $LOG

url=$(echo -n "$DATA" | jq -r '.url')
file=$(echo -n "$DATA" | jq -r '.file')

#logger "$url"
#logger "$file"

#
attr -s 'url' -V "$url" "$file"

echo ok
exit 0 
