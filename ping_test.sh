#!/bin/bash
# Simple Ping Monitor for hosts
#
# Parse this file to retrieve Hosts
set -x
HOSTS=$(cat /home/pi/servers.txt)

## Check Hosts and compile a list of ones that may be unreachable
for myHost in $HOSTS;
do
ping -q -c 3 $myHost > /dev/null
if [ ! $? -eq 0 ]
then
echo "Host: $myHost is unresponsive (ping failed)" >> /home/pi/monitor/down_now
fi
done

## Email that list and remove the file for next check
# Set email VARS
SUBJECT="[ALERT] Host(s) Unresponsive!"
EMAILID="something@gmail.com"
EMAILFROM="somewhere_else@local.net"

#Send email and remove list
if [ -e /home/pi/monitor/down_now ];
then
echo "$(cat /home/pi/monitor/down_now)" | /usr/sbin/ssmtp -s "$SUBJECT $(date)" $EMAILID
rm -rf /home/pi/monitor/down_now
else
exit 0
fi

exit 0
