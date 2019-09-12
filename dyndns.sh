#!/bin/sh -e

#
# Adapted from https://gist.github.com/corny/7a07f5ac901844bd20c9
#

device=$1
subdomain=$2
password=$3
ipv6file=$HOME/.dnshome.addr6
ipv4file=$HOME/.dnshome.addr4

touch $ipv6file
touch $ipv4file

[ -e $ipv6file ] && oldv6=`cat $ipv6file`
[ -e $ipv4file ] && oldv4=`cat $ipv4file`

if [ -z "$subdomain" -o -z "$password" ]; then
  echo "Usage: [device (e.g. wlp5s0)] [dnshome.de subdomain] [dnshome password]"
  exit 1
fi

if [ -z "$netmask" ]; then
  netmask=128
fi

if [ -n "$device" ]; then
  device="dev $device"
fi

ipv6=$(ip -6 addr list scope global $device | grep -v " fd" | sed -n 's/.*inet6 \([0-9a-f:]\+\).*/\1/p' | head -n 1)

if [ -e /usr/bin/curl ]; then
  bin="curl -fsS"
elif [ -e /usr/bin/wget ]; then
  bin="wget -O-"
else
  echo "neither curl nor wget found"
  exit 1
fi

# ipv6 with netmask
current=$ipv6
ipv4=$(curl http://checkip.amazonaws.com)

# send ipv6es to dynv6

if [ -n "$current" ]; then
  if [ "$oldv6" != "$current" ]; then 
	echo "Updating v6 to $current"	
	echo "http://$subdomain:$password@dnshome.de/dyndns.php?ip6=$current"
	$bin "http://$subdomain:$password@dnshome.de/dyndns.php?ip6=$current"
	echo $current > $ipv6file
  fi
fi
if [ -n "$ipv4" ]; then
  if [ "$oldv4" = "$ipv4" ]; then 
  	echo "Updating v4 to $ipv4"
  	echo "http://$subdomain:$password@dnshome.de/dyndns.php?ip=$ipv4"
  	$bin "http://$subdomain:$password@dnshome.de/dyndns.php?ip=$ipv4"
	echo $ipv4 > $ipv4file
  fi
fi


#$bin "http://dynv6.com/api/update?hostname=$subdomain&ipv6=$current&token=$password"
#$bin "http://ipv4.dynv6.com/api/update?hostname=$subdomain&ipv4=auto&token=$password"

# save current ipv6

