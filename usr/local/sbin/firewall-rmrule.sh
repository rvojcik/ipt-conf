#!/bin/bash
#
# ipt-conf project
#
# Script for removing rules from active configuration
#
# Robert Vojcik ( vojcik@gmail.com )

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
