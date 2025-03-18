#!/bin/bash

curl -s "https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" > aviation.json
jq -r '.[].receiptTime' aviation.json | head -n 6

temperatures=$(jq -r '.[].temp // empty' aviation.json)

sum=0
count=0
for temp in $temperatures; do
	sum=$(echo "$sum + $temp" | bc)
	count=$((count + 1))
done

if [ "$count" -gt 0 ]; then
	averagetemp=$(echo "scale=1; $sum / $count" | bc)
else
	averagetemp="N/A"
fi

echo "Average Temperature: $averagetemp"

cloudynum=$(jq '[.[].clouds[].cover | select(. != "CLR")] | length' aviation.json)
reports=$(jq 'length' aviation.json)
mostlycloudy=$([ "$cloudynum" -gt "$((reports / 2))" ] && echo "true" || echo "false")
echo "Mostly Cloudy: $mostlycloudy"

