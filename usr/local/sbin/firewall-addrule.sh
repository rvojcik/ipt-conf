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
#  Robert Vojcik ( robert@vojcik.net )

. /etc/ipt.conf


function get_last_position {
	TMP1=$PWD
	cd $CONFDIR/rules.enabled/ || exit 1
	COUNTER=$((`ls -1 *.rule | tail -n1 | cut -d"-" -f 1` + 5))
	cd $TMP1
}

function enable_rules {
	cd $CONFDIR/rules.enabled
	echo "Actual rules"
	ls -1 *.rule

	for rule in $* ; do 
		DONE=0
		while [ $DONE -lt 1 ] ; do
			get_last_position
			# last position in COUNTER variable
			echo -n "Enter position number for $rule [$COUNTER] "
			read POSITION
			
			if [ "$POSITION" != "" ] ; then 
				COUNTER=$POSITION
			fi
			
			ln -s ../rules.available/$rule.rule ./$COUNTER-$rule.rule 2>/dev/null && DONE=2 
			
			if [ $COUNTER -gt 98 ] ; then 
				echo "ERROR - could not link file ($COUNTER-$rule.rule)"
				exit 1	
			elif [ $DONE -eq 2 ] ; then 
 				echo "$rule [OK]"
				if [ -e ../rules.available/$rule.conf ] ; then 
					if [ -e ./$rule.conf ] ; then 
						echo -n "Configuration for rule already exists. Would you like to overwrite ? [y/n] [y] "
						read ans
						if [ "$ans" == "n" ] ; then 
							exit 0
						fi
					fi
					. ../rules.available/$rule.conf
					for var in $VARIABLES ; do 
						TMP="${var}_DESC"
						echo -n "${!TMP} "
						read TMP
						echo "$var=\"$TMP\"" >> ./$rule.conf
					done

				fi
			fi
		done

	done


}


if [[ "$1" = "" ]] ; then 
	echo "Avaible rules are:"
	ls -1 $CONFDIR/rules.available/ | grep -e "rule$" | sed -e 's/\.rule$//'
	echo 
	echo "Enter rule/rules: "
	read rules
	enable_rules $rules
else
	enable_rules $*
fi

echo -n "Do you want restart firewall ? [y/n] [y] "
read ans

if [[ "$ans" = "n" ]] ; then 
	exit 0
else 
	$INITDIR/ipt-conf restart
fi
