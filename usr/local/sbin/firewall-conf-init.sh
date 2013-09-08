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


echo "Firewall init configuration"
echo "---------------------------"

MAINCONF="/etc/ipt.conf"
CONFDIR="/etc/ipt-conf"
INITDIR="/etc/init.d"
BINDIR="/usr/local/sbin"
IPTABLES_PATH=$(which iptables)
IP6TABLES_PATH=$(which ip6tables)

echo -n "Enable IPv6 protocol ? [y/n] [n] "
read ans

if [[ "$ans" = "y" ]] ; then 
	IPV6="YES"
else
	IPV6="NO"
fi

if [ -e $MAINCONF ] ; then 
	echo -n "$MAINCONF already exist. Do you want to replace it ? [y/n] [n] "
	read ans
	if [ -z $ans ] ; then 
		ans="n"
	fi
else
	ans="y"
fi

if [[ "$ans" == "y" ]] ; then 
	echo -e "BINDIR=${BINDIR}\nCONFDIR=${CONFDIR}\nINITDIR=$INITDIR" > $MAINCONF
fi

if [ -e $CONFDIR/firewall.conf ] ; then 
	echo -n "$CONFDIR/firewall.conf already exist. Do you want to replace it ? [y/n] [n] "
	read ans
	if [ -z $ans ] ; then 
		ans="n"
	fi
else
	ans="y"
fi

if [[ "$ans" == "y" ]] ; then 

	echo "iptables=$IPTABLES_PATH
ip6tables=$IP6TABLES_PATH
DEFAULT_INPUT_POLICY=\"DROP\"
DEFAULT_FORWARD_POLICY=\"DROP\"
DEFAULT_OUTPUT_POLICY=\"ACCEPT\"
IPV6_ENABLE=$IPV6
DEFAULT_INPUT_POLICY_V6=\"DROP\"
DEFAULT_FORWARD_POLICY_V6=\"DROP\"
DEFAULT_OUTPUT_POLICY_V6=\"ACCEPT\"" > $CONFDIR/firewall.conf

fi

if [ ! -e $CONFDIR/rules.enabled  ] ; then

        mkdir $CONFDIR/rules.enabled
        echo "Setting default rules set"
        ln -s $CONFDIR/rules.available/default-policy.rule $CONFDIR/rules.enabled/00-default-policy.rule
        ln -s $CONFDIR/rules.available/deny-badpackets.rule $CONFDIR/rules.enabled/05-deny-badpackets.rule
        ln -s $CONFDIR/rules.available/deny-forwarding.rule $CONFDIR/rules.enabled/10-deny-forwarding.rule
        ln -s $CONFDIR/rules.available/antispoof.rule $CONFDIR/rules.enabled/11-antispoof.rule
        ln -s $CONFDIR/rules.available/allow-localhost.rule $CONFDIR/rules.enabled/20-allow-localhost.rule
        ln -s $CONFDIR/rules.available/allow-icmp.rule $CONFDIR/rules.enabled/35-allow-icmp.rule
        ln -s $CONFDIR/rules.available/allow-state.rule $CONFDIR/rules.enabled/50-allow-state.rule

fi

echo "
--------------------------------------------------------------
Firewall is not started for now, 
please check $CONFDIR/rules.enabled and if you are sure run 
$INITDIR/ipt-conf restart
--------------------------------------------------------------"
