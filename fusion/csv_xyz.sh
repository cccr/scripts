#!/bin/bash

# Define the output file name
output_file="user_data.csv"

# Check if file already exists; if so, delete it to start fresh
if [ -f "$output_file" ]; then
    rm "$output_file"
fi

# Create the CSV file with headers
echo "x,y,z" > "$output_file"

# Prompt user for input until they decide to stop
while true; do
    # Ask for three space-separated values
    read -p "Enter three values separated by space (or type 'stop' to finish): " input

    # Check if user wants to stop
    if [[ "$input" == "stop" ]]; then
        break
    fi

    # Split the input into an array
    values=($input)

    # Validate that exactly three values were provided
    if [ "${#values[@]}" -ne 3 ]; then
        echo "Please enter exactly three values."
        continue
    fi

    # Append the values to the CSV file, comma-separated
    echo "${values[0]},${values[1]},${values[2]}" >> "$output_file"
    echo "Added: ${values[0]}, ${values[1]}, ${values[2]}"
done

echo "Data saved to $output_file"