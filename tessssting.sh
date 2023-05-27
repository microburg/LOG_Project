#!/bin/bash

log_file="random_apache_log.log"

# Filtering options
ip_filter="^59\." # Only process lines with IP addresses starting with "10."
method_filter="POST" # Only process lines with a "POST" HTTP method

declare -A ip_arr
declare -A url_arr
declare -A method_arr
declare -A date_arr
declare -A system_arr

echo "Reading file: $log_file"

while read line; do

	# Apply filters
	if ! [[ $line =~ $ip_filter ]]; then
		continue
	fi

	if ! [[ $line =~ $method_filter ]]; then
		continue
	fi

	# Extract fields
	ip=$(echo $line | awk '{print $1}')
	method=$(echo $line | awk '{print $8}')
	

    # Aggregate data
    if [[ ${ip_arr[$ip]+_} ]]; then
      ip_arr[$ip]=$((ip_arr[$ip]+1))
    else
      ip_arr[$ip]=1
    fi
    

    if [[ ${method_arr[$method]+_} ]]; then
      method_arr[$method]=$((method_arr[$method]+1))
    else
      method_arr[$method]=1
    fi



done < $log_file

echo "IP:"
for i in "${!ip_arr[@]}"; do
	echo "$i: ${ip_arr[$i]}"
done

echo "HTTPS:"
for i in "${!method_arr[@]}"; do
	echo "$i: ${method_arr[$i]}"
done