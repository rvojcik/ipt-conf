#!/bin/bash
#  IPT-CONF small configuration framework to handle configuration of linux iptables netfilter.
#  Copyright (C) 2011 Robert Vojcik
#  
#  This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#  
#  Contact
#  -------
#  Robert Vojcik ( vojcik@gmail.com )
#  Jan Guttek ( tekian@tekian.eu )

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
