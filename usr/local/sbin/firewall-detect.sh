#!/bin/bash
#
# ipt-conf project
#
# Script for detection listening ports of running applications
#
# Jan Guttek ( tekian@tekian.eu )

if (( $# < 1 )); then
	echo -e "Usage: $0 [search..]"
	exit 2
fi

function netstat_filter {
	netstat -tulpn 2> /dev/null | awk '/'$1'/ {
		PROTOCOL=$1

		split($7,ARRAY,"/")
		PROCESS=ARRAY[2]

		split($4,ARRAY,":")
		INTERFACE=ARRAY[1]
		PORT=ARRAY[2]

		print PROCESS" \t"INTERFACE" \t"PROTOCOL" \t\t"PORT
	}'
}

echo -e "PROCESS \tINTERFACE \tPROTOCOL \tPORT"
while [[ "$1" != "" ]]; do
	netstat_filter $1; shift
done
