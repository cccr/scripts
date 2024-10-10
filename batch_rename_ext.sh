#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <from_extension> <to_extension>"
  exit 1
fi

# Store arguments in variables
from_ext="$1"
to_ext="$2"

# Enable case-insensitive globbing
shopt -s nocaseglob

# Loop through all files with the "from" extension in the current directory
renamed=false
for file in *."$from_ext"; do
  # Check if any files with the "from" extension are found
  if [ -e "$file" ]; then
    # Rename the file by replacing the "from" extension with the "to" extension
    new_file="${file%.$from_ext}.$to_ext"
    mv "$file" "$new_file"
    echo "Renamed: $file -> $new_file"
    renamed=true
  fi
done

# Disable case-insensitive globbing
shopt -u nocaseglob

# Print a message if no files were renamed
if [ "$renamed" = false ]; then
  echo "No files found with .$from_ext extension."
else
  echo "Renaming complete!"
fi