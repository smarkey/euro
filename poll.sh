#!/bin/sh
clear

cyan='\033[0;36m' && green='\033[0;32m' && red='\033[0;31m' && orange='\033[0;33m' && nocolour='\033[0m'
pass="${green}Tickets!${nocolour}" && sending="${green}Found for the first time - Sending email${nocolour}" && fail="${red}Gone :(${nocolour}" && active="${orange}Nothing available${nocolour}"

TEAMID="$1"
EMAILADDRESS="$2"
LOOPS="$3"
FREQUENCY="$4"
COUNT=0
FOUND=false

timestamp () {
	date +%F_%T
}

if [ "$TEAMID" == "-h" ]; then
	echo "./poll.sh [team_id] [email_address] [number_of_loops] [frequency_of_loops]"
	echo "\n2: Albania\n8: Austria\n13: Belgium\n56370: Croatia\n58837: Czech Republic\n39: England\n43: France\n47: Germany\n57: Hungary\n58: Iceland\n66: Italy\n63: Northern Ireland\n109: Poland\n110: Portugal\n64: Republic of Ireland\n113: Romania\n57451: Russia\n58836: Slovakia\n122: Spain\n127: Sweden\n128: Switzerland\n135: Turkey\n57166: Ukraine\n144: Wales\n"
	exit
fi

if [ -z $TEAMID ]; then
	TEAMID=64
fi

if [ -z $EMAILADDRESS ]; then
	EMAILADDRESS=test109908786576@mailinator.com
fi

if [ -z $LOOPS ]; then
	LOOPS=60
fi

if [ -z $FREQUENCY ]; then
	FREQUENCY=10
fi

echo "Looking for tickets for Team ID: $TEAMID\nUpto every: $FREQUENCY seconds (Randomised to reduce chance of detection)\nA maximum of: $LOOPS times\nEmailing: $EMAILADDRESS on success\n"

while [ $COUNT -lt $LOOPS ]; do
	RESPONSE=$(curl -s http://www.uefa.com/uefaeuro/ticketing/index.html#availability | grep "data-teams" | grep "$TEAMID" | grep -v "tickets-not-avail")

	if [ ${#RESPONSE} -gt 0 ]; then
		echo $(timestamp) $pass

		if [ "$FOUND" == "false" ]; then
			echo $(timestamp) $sending
			echo "Ireland Tickets @ http://www.uefa.com/uefaeuro/ticketing/index.html#availability" | mail -s "Ireland Tickets Available" $EMAILADDRESS
			FOUND=true
		fi
	else
		if [ "$FOUND" == "false" ]; then
			echo $(timestamp) $active
		else
			echo $(timestamp) $fail
			FOUND=false
		fi
	fi

	COUNT=$[$COUNT+1]
	sleep $[ 1 + $[ RANDOM % $FREQUENCY ]]
done