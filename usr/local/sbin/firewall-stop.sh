#!/bin/bash

. /etc/ipt.conf

echo "Reset firewall"

if [ -e $CONFDIR/firewall.conf ] ; then 

. $CONFDIR/firewall.conf

## Set default policy
$iptables -P INPUT ACCEPT
$ip6tables -P INPUT ACCEPT

$iptables -P FORWARD ACCEPT
$ip6tables -P FORWARD ACCEPT

$iptables -P OUTPUT ACCEPT
$ip6tables -P OUTPUT ACCEPT
## Remove all rules
$iptables -F
$ip6tables -F

$iptables -t nat -F
$iptables -t raw -F
## Remove all chains
$iptables -X
$ip6tables -X
## Reset counters
$iptables -Z
$ip6tables -Z

else
	echo "Conf file not found... exiting"
	exit 1
fi

echo "Done"
