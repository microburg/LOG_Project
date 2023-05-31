# !/ bin / bash


# This function asks the user in which fomrat does he want
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
        for i in "${!ip_arr[@]}"; do
            for j in "${!method_arr[@]}"; do 
                for z in "${!date_arr[@]}"; do
                    for y in "${!url_arr[@]}"; do
                        echo "$j,$i,$z,$y"
                    done
                done
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
        for z in "${!date_arr[@]}"; do 
            echo "DATE:$z"
        done
        for y in "${!url_arr[@]}"; do 
            echo "URL:$y"
        done

    fi

    if [ "$format" == "JSON" ]; then
        echo "{"
        for i in "${!ip_arr[@]}"; do
            echo "\"IP\": \"$i\","
        done
        for j in "${!method_arr[@]}"; do 
            echo "\"METHOD\": \"$j\","
        done
        for z in "${!date_arr[@]}"; do 
            echo "\"DATE\": \"$z\","
        done
        for y in "${!url_arr[@]}"; do 
            echo "\"URL\": \"$y\","
        done
        echo "}"

    fi
}

# Function to display usage information
usage () {
    echo " Usage : $0 [ options ] [ log_file ...] "
    echo " Options : "
    echo " -f , --format Define custom log format "
    echo " -t , --threshold Set a threshold for displaying results "
    echo " -o , --output Specify output format ( text , csv , json ) "
    echo " -h , --help Display this help message "
}


#This function Asks the user to innter a number which shows the output based on that number
threshold() {

    read -p "Enter threshold value: " threshold
    # Process log file and filter results based on threshold

        #SHow the IP
        num=0
        count=${#ip_arr[@]}
        for i in "${!ip_arr[@]}"; do
            if  ((num < threshold)); then
                echo "$i"
                (( num++ ))
            fi
        done

        #show the HTTP method
        num1=0
        count=${#method_arr[@]}
        for i in "${!method_arr[@]}"; do
            if  ((num1 < threshold)); then
                echo "$i"
                (( num1++ ))
            fi
        done

        #show the urls
        num2=0
        count=${#url_arr[@]}
        for i in "${!url_arr[@]}"; do
            if  ((num2 < threshold)); then
                echo "$i"
                (( num2++ ))
            fi
        done

        #show the date
        num3=0
        count=${#date_arr[@]}
        for i in "${!date_arr[@]}"; do
            if  ((num3 < threshold)); then
                echo "$i"
                (( num3++ ))
            fi
        done
}
    




log_file="$2"

# Filtering options
ip_filter="^59\." 
method_filter="POST" 
date_filter="11/May/2021"


#Decalring the arrays
declare -A ip_arr
declare -A url_arr
declare -A method_arr
declare -A date_arr


echo "Reading file: $log_file"


# Big for loop to see if the intered paramter is file or a directory
for logs in $log_file; do
    if [ -d "$logs" ]; then
        # Log file is a directory, process all files in directory
        for file in "$logs"/*; do
            # Skip directories and non-log files
            if [ -f "$file" ] && [[ "$file" == *.log ]]; then

                tail -f $log_file | while read line; do

                    # Apply filters
                    if ! [[ $line =~ $ip_filter ]]; then
                    	continue
                    fi

                    if ! [[ $line =~ $method_filter ]]; then
                    	continue
                    fi

                    if ! [[ $line =~ $date_filter ]]; then
                    	continue
                    fi

                    # Extract fields
                    ip=$(echo $line | awk '{print $1}')
                    method=$(echo $line | awk '{print $6}')
                    url=$(echo $line | awk '{print $13}')
                    date=$(echo $line | awk '{print $4,$5,$6,$7}')
                    

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

                    if [[ ${url_arr[$url]+_} ]]; then
                        url_arr[$url]=$((url_arr[$url]+1))
                    else
                        url_arr[$url]=1
                    fi

                    if [[ ${date_arr[$date]+_} ]]; then
                        date_arr[$date]=$((date_arr[$date]+1))
                    else
                        date_arr[$date]=1
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

                    if ! [[ $line =~ $date_filter ]]; then
                    	continue
                    fi


                    # Extract fields
                    ip=$(echo $line | awk '{print $1}')
                    method=$(echo $line | awk '{print $8}')
                    url=$(echo $line | awk '{print $11}')
                    date=$(echo $line | awk '{print $4,$5,$6,$7}')
                    

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

                    if [[ ${url_arr[$url]+_} ]]; then
                        url_arr[$url]=$((url_arr[$url]+1))
                    else
                        url_arr[$url]=1
                    fi

                    if [[ ${date_arr[$date]+_} ]]; then
                        date_arr[$date]=$((date_arr[$date]+1))
                    else
                        date_arr[$date]=1
                    fi

        done < $log_file
    fi
done



# This part shows the static of the given log files
echo "IP:"
for i in "${!ip_arr[@]}"; do
	echo "$i: ${ip_arr[$i]}"
done

echo "METHODS:"
for i in "${!method_arr[@]}"; do
	echo "$i: ${method_arr[$i]}"
done

echo "URL:"
for i in "${!url_arr[@]}"; do
	echo "$i: ${url_arr[$i]}"
done

echo "Dates:"
for i in "${!date_arr[@]}"; do
	echo "$i: ${date_arr[$i]}"
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

        -o | --output)
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