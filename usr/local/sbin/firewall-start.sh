#!/bin/bash
#
# ipt-conf project
#
# Starting firewall script
#
# Robert Vojcik ( vojcik@gmail.com )

. /etc/ipt.conf

echo "Starting firewall"

if [ -e $CONFDIR/firewall.conf ] ; then 

. $CONFDIR/firewall.conf


for rule in $CONFDIR/rules.enabled/*.rule ; do 
	echo -n "Adding $rule"
	. $rule && echo "[OK]" || echo "[ERROR]"
done


else
	echo "Conf file not found... exiting"
	exit 1
fi

echo "Done"
