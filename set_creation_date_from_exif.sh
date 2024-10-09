#!/bin/bash

# Check if file or directory was passed as argument
if [ $# -eq 0 ]; then
    echo "No file or directory provided. Usage: ./set_exif_date.sh <file.m4v or .>"
    exit 1
fi

TARGET=$1

# List of acceptable extensions (case insensitive)
ACCEPTABLE_EXTENSIONS=("m4v" "mov")

# Function to check if the file extension is acceptable
is_extension_acceptable() {
    local file="$1"
    # Convert the filename to lowercase
    local lower_file=$(echo "$file" | tr '[:upper:]' '[:lower:]')
    for ext in "${ACCEPTABLE_EXTENSIONS[@]}"; do
        if [[ "$lower_file" == *".$ext" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to process a single file
process_file() {
    local FILE=$1

    echo "Processing file: $FILE"

    # Get the EXIF CreateDate from the m4v file
    EXIF_DATE=$(exiftool -api QuickTimeUTC=1 -CreateDate "$FILE" | awk -F': ' '{print $2}')

    # Output the extracted EXIF date for debugging
    echo "Extracted EXIF CreateDate: $EXIF_DATE"

    # Check if EXIF CreateDate was found
    if [ -z "$EXIF_DATE" ]; then
        echo "No EXIF CreateDate found in $FILE"
        return 1
    fi

    # Extract date and time including seconds, ignoring the timezone
    DATE_PART=$(echo "$EXIF_DATE" | cut -d' ' -f1 | sed 's/://g')
    TIME_PART=$(echo "$EXIF_DATE" | cut -d' ' -f2 | cut -d'-' -f1 | sed 's/://g')

    # Output the parsed date and time parts for debugging
    echo "Parsed Date Part: $DATE_PART"
    echo "Parsed Time Part: $TIME_PART"

    # Combine date and time into a format compatible with touch (YYYYMMDDHHMM.SS)
    FORMATTED_DATE="${DATE_PART}${TIME_PART:0:4}.${TIME_PART:4:2}"

    # Output the formatted date for debugging
    echo "Formatted Date for touch: $FORMATTED_DATE"

    # Use touch to modify both creation and modification dates
    echo "Executing: touch -t \"$FORMATTED_DATE\" \"$FILE\""
    touch -t "$FORMATTED_DATE" "$FILE"

    # Output the result
    if [ $? -eq 0 ]; then
        echo "File creation date for $FILE has been successfully set to $EXIF_DATE"
    else
        echo "Failed to set the file creation date for $FILE."
    fi
}

# Check if the target is a directory or a single file
if [ "$TARGET" == "." ]; then
    # Iterate over all files in the current directory
    for FILE in *; do
        if is_extension_acceptable "$FILE"; then
            process_file "$FILE"
        fi
    done
else
    # Process a single file
    if [ -f "$TARGET" ]; then
        if is_extension_acceptable "$TARGET"; then
            process_file "$TARGET"
        else
            echo "The provided file does not have an acceptable extension."
            exit 1
        fi
    else
        echo "$TARGET is not a valid file."
        exit 1
    fi
fi