# !/ bin / bash
# Function to display usage information

output_format() {

    filename=$(basename -- "$log_file")
    extension="${filename##*.}"

    echo "ENTER CSV, TXT, JSON" 
    read format
    # Check file extension
    if [ "$extension" == "csv" ]; then
        echo "File is a CSV"
    elif [ "$extension" == "log" ]; then
        echo "File is a TXT"
    elif [ "$extension" == "json" ]; then
        echo "File is a JSON"
    else
        echo "File is not a CSV, TXT, or JSON"
    exit 1
    fi

    if [ "$format" == "CSV" ]; then
        for i in "${ip_arr[@]}"; do
            for j in "${!method_arr[@]}"; do 
                echo "$j,$i"
            done
        done

    fi

    if [ "$format" == "TXT" ]; then
        for i in "${!ip_arr[@]}"; do
            echo "IP ADDRESS: $i"
        done
        for j in "${!method_arr[@]}"; do 
            echo "METHOD:$j"
        done

    fi

    if [ "$format" == "JSON" ]; then
        for i in "${!ip_arr[@]}"; do
            echo "{"
            echo "\"remote_host\": \"$i\","
        done
        for j in "${!method_arr[@]}"; do 
            echo "\"remote_host\": \"$j\","
            echo "}"
        done

    fi
}

usage () {
    echo " Usage : $0 [ options ] [ log_file ...] "
    echo " Options : "
    echo " -f , -- format Define custom log format "
    echo " -t , -- threshold Set a threshold for displaying results "
    echo " -o , -- output Specify output format ( text , csv , json ) "
    echo " -h , -- help Display this help message "
}



threshold() {

    read -p "Enter threshold value: " threshold
    # Process log file and filter results based on threshold

        count=${#ip_arr[@]}
        for ip in "${ip_arr[@]}"; do
        if [ "$count" -ge "$threshold" ]; then
            echo "$ip"
        fi
        done
}
    




log_file="$2"

# Filtering options
ip_filter="^59\." # Only process lines with IP addresses starting with "10."
method_filter="POST" # Only process lines with a "POST" HTTP method

declare -A ip_arr
declare -A url_arr
declare -A method_arr
declare -A date_arr
declare -A system_arr

echo "Reading file: $log_file"

for logs in $log_file; do
    if [ -d "$logs" ]; then
        # Log file is a directory, process all files in directory
        for file in "$logs"/*; do
            # Skip directories and non-log files
            if [ -f "$file" ] && [[ "$file" == *.log ]]; then

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
                    method=$(echo $line | awk '{print $6}')
                    

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



                done < $file
            fi
        done
    else
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
    fi
done




echo "IP:"
for i in "${!ip_arr[@]}"; do
	echo "$i: ${ip_arr[$i]}"
done

echo "METHODS:"
for i in "${!method_arr[@]}"; do
	echo "$i: ${method_arr[$i]}"
done


# Parse command - line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f | --format )
        custom_format="$2"
        shift
        ;;

        -t | --threshold )
        threshold
        shift
        ;;

        -o )
        output_format
        shift
        ;;

        -h | --help )
        usage
        exit 0
        ;;

        *)
        log_files+="$1"
        ;;
    esac
    shift
done

# # Check if log files are provided
# if [[ -z "${log_files[*]}" ]]; then
#     echo " Error : No log files provided . "
#     usage
#     exit 1
# fi