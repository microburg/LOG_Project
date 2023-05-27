#!/bin/bash

# Function to display INFO
usage() {
	echo "Usage: $0 [options] [log_file ...]"
	echo "Options"
	echo "  -f, --format	Define custom log format"
	echo "  -t, --threshold Set a threshold for displaying results"
	echo "  -o, --output	Specify output formate (text, scv, json)"
	echo "  -h, -- help 	Dispaly this help message"
}


# Parse command-line arguments
while [[ "$#" -gt 0 ]];
do
	case $1 in
		-f|--format)
			custom_format="$2"
			shift
			;;
		-t|--threshold)
			threshold="$2"
			shift
			;;
		-o|--output)
			output_format="$2"
			shift
			;;
		-h|--help)
			usage
			exit 0
			;;
		*)
			log_files+=("$1")
			;;
	esac
	shift
done

# Check inf log files ate provided
if [[ -z "${log_files[*]}" ]];then
	echo "Error: No log files provided."
	usage
	exit 1
fi


# Add your log analysis logic here
declare -A ip_arr
declare -A url_arr
declare -A method_arr
declare -A date_arr
declare -A system_arr

# Reading files
log_files="random_apache_log.log"

#Loop over log files
for files in $log_files;do
	echo "Reading file : $files"

	while read line; do
	# save every column of info in an array
		ip=$(echo $line | awk '{print $1}')
		http=$(echo $line | awk '{print $13}')
		method=$(echo $line | awk '{print $8,$9,$10}')
		date=$(echo $line | awk '{print $4,$5,$6,$7}')
		os=$(echo $line | awk '{print $14,$15,$16,$17,$18,$19}')
	
		# Update the arrays
		if [[ ${ip_arr[$ip]+_} ]]; then
			ip_arr[$ip]=$((ip_arr[$ip]+1))
		else
			ip_arr[$ip]=1
		fi
	
		if [[ ${url_arr[$http]+_} ]]; then
			url_arr[$http]=$((url_arr[$http]+1))
		else
			url_arr[$http]=1
		fi

		if [[ ${method_arr[$method]+_} ]]; then
			method_arr[$method]=$((method_arr[$method]+1))
		else
			method_arr[$method]=1
		fi

		if [[ ${date_arr[$date]+_} ]]; then
			date_arr[$date]=$((date_arr[$date]+1))
		else
			date_arr[$date]=1
		fi

		# if [[ ${system_arr[$os]+_} ]]; then
		# 	system_arr[$os]=$((systme_arr[$os]+1))
		# else
		# 	system_arr[$os]=1
		# fi

	done < $log_files

	# Check by printing

	echo "IP:"
	for i in "${!ip_arr[@]}"; do
		echo "$i"
	done

	echo "URL:"
	for i in "${!url_arr[@]}"; do
		echo "$i"
	done

	echo "METHOD:"
	for i in "${!method_arr[@]}"; do
		echo "$i"
	done

	echo "Dates:"
	for i in "${!date_arr[@]}"; do
		echo "$i"
	done

	# echo "OPERATING SYSTEM:"
	# for i in "${!system_arr[@]}"; do
	# 	echo "$i"
	# done
done



