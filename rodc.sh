#!/bin/bash

LOG_FILE=/tmp/rodc.log

LOG() {
	echo "$(date): $@" >> $LOG_FILE
}

MISSING_REQ=0
for req in date xxd bc jq attr;do
	type $req >/dev/null 2>&1 || { LOG "ERROR: Missing dependency: $req"; MISSING_REQ=1; }
done
[ $MISSING_REQ -ne 0 ] && { LOG "ERROR: Aborting because of missing dependency"; exit 1; }


# get data lengh from the first 4 bytes 
read -n 1 -r LEN_CHR
LOG "LEN_CHR: $LEN_CHR"

LEN_HEX=$(echo -n "$LEN_CHR" | xxd -p -u)
LOG "LEN_HEX: $LEN_HEX"

BC_STR="obase=10; ibase=16; $LEN_HEX"
LOG "BC_STR: $BC_STR"

LEN_DEC=$(echo "$BC_STR" | bc)
LOG "LEN_DEC: $LEN_DEC"

# read DATA with LEN_DEC
read -n $LEN_DEC -r DATA
LOG "DATA: $DATA"

url=$(echo -n "$DATA" | jq -r '.url')
LOG "url: $url"
file=$(echo -n "$DATA" | jq -r '.file')
LOG "file: $file"

# set xattr on downloaded file
attr -s 'url' -V "$url" "$file"

echo ok
exit 0 
