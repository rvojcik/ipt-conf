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

. /etc/ipt.conf


function disable_rules {
	for rule in $* ; do 
			if rm $CONFDIR/rules.enabled/$rule 2>/dev/null ; then
 				echo "$rule [REMOVED]"
			else
				echo "$rule [ERROR]"
			fi
	done
}


if [ "$1" = "" ] ; then 
	echo "Enabled rules are:"
	ls -1 $CONFDIR/rules.enabled/ | grep -e "\.rule$"
	echo 
	echo -n "Enter rule/rules you want to remove: "
	read rules
	disable_rules $rules
else
	disable_rules $*
fi

echo -n "Do you want restart firewall ? [y/n] [y] "
read ans

if [[ "$ans" = "n" ]] ; then 
	exit 0
else 
	$INITDIR/ipt-conf restart
fi
