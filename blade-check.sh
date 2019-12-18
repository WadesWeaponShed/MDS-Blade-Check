#!/bin/bash
source /opt/CPshrd-R80/tmp/.CPprofile.sh
printf "\nGathering CMA Info\n"
for CMA_NAME in $($MDSVERUTIL AllCMAs);
do
  $MDSVERUTIL CMAIp  -n $CMA_NAME >> CMA-IP.txt
done

printf "\nGetting Gateway Blades. May take some time.\n"
for I in $(cat CMA-IP.txt)
do
  mgmt_cli -d $I -r true show gateways-and-servers details-level full limit 500 --format json |jq --compact-output --raw-output '.objects[] | select(.type == "CpmiHostCkp"|not) | "gateway name:" + "\(.name) \(."network-security-blades")"' >> $CMA_NAME-gateway-blades.txt
done

rm CMA-IP.txt
printf "\nYour Inventory is located in "CMA_NAME"-gateway-blades.txt\n"
