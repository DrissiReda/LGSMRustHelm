#!/bin/bash

scripthome=$(eval echo $scripthome)
rustserver=$(eval echo $rustserver)
rcon=$(eval echo $rcon)
servermsg="Rolling update"
dstitle="Rolling update !"
dsmsg="Server will restart in an hour. Expect a downtime of around 10 minutes"

load_mods() {
	mods=$($rcon -t web -a $gamehost:$rconport -p $rconpassword  "oxide.plugins" | grep "Listing")

	if [ "$mods" == "" ]; then
		echo "mods not loaded, loading them"
		$rustserver mods-update
		$rcon -t web -a $gamehost:$rconport -p $rconpassword "restart 1 update"
	fi
}

$rustserver check-update | grep "Update available"
if [ $? == 0 ]; then
    echo "Rolling update found on $(date)"
else
    echo "No update available"
    exit 0
fi


$scripthome/webhook.sh "$dstitle" "$dsmsg"

# Alert before reboot
echo "Updating on ------------$(date)------------"
$rcon -t web -a $gamehost:$rconport -p $rconpassword "global.say $servermsg in 1 hour. Maintenance will take around 10 mins"
sleep 1800
$rcon -t web -a $gamehost:$rconport -p $rconpassword "global.say $servermsg in 30 mins. Maintenance will take around 10 mins"
sleep 900
$rcon -t web -a $gamehost:$rconport -p $rconpassword "global.say $servermsg in 15 mins. Maintenance will take around 10 mins"
sleep 600
$rcon -t web -a $gamehost:$rconport -p $rconpassword "global.say $servermsg in 5 mins. Maintenance will take around 10 mins"
sleep 300
$rcon -t web -a $gamehost:$rconport -p $rconpassword "global.say $servermsg now. Maintenance will take around 10-15 mins"

# Do update
$rustserver update-lgsm
$rustserver update
$rustserver mods-update

$rcon -t web -a $gamehost:$rconport -p $rconpassword "restart 1 update"
# check if mods are loaded
load_mods

