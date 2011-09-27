#!/bin/bash

. /etc/ipt.conf

echo "Starting edrive firewall"

if [ -e $CONFDIR/firewall.conf ] ; then 

. $CONFDIR/firewall.conf


for rule in `ls -1 $CONFDIR/rules.enabled/*.rule` ; do 
	echo -n "Adding $rule"
	. $rule && echo "[OK]" || echo "[ERROR]"
done


else
	echo "Conf file not found... exiting"
	exit 1
fi

echo "Done"
