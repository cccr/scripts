# Scripts Repository

This repository contains a collection of useful scripts for various tasks. Each script is designed to perform a specific function and can be easily executed from the command line.
## Available Scripts

- **`set_creation_date_from_exif.sh`**: A script that extracts the `CreateDate` EXIF tag from video files (supports `.m4v` and `.M4V` formats) and sets the file's creation date accordingly. It can process individual files or all files in the current directory.

# `set_creation_date_from_exif.sh`

## Usage

### Set Creation Date from EXIF

**The `set_creation_date_from_exif.sh` script was created after I realized that movies downloaded from iCloud have incorrect creation dates, making it difficult to import them into tools like Lightroom.**


To use the `set_creation_date_from_exif.sh` script, follow these instructions:

1. **Clone the Repository**:
   ```bash
   git clone git@github.com:cccr/scripts.git
   cd scripts

2. **Make the Script Executable**:
   ```bash
   chmod +x set_creation_date_from_exif.sh

3. **Run the Script**:
   - To process all .m4v and .mov files in the current directory:

    ```bash
    ./set_creation_date_from_exif.sh .
    ```
   
    - To process a specific file:

	```bash
	./set_creation_date_from_exif.sh <filename>.m4v
    ```
4.	**Verify Metadata**:
After running the script, you can verify the metadata with the following command:
   ```bash
   exiftool -a -G1 -s -n -fileOrder5 FileName -api QuickTimeUTC=1 -FileCreateDate -FileModifyDate -CreateDate -GPSCoordinates -DateTimeOriginal -CreationDate . 
   ```

### List of Acceptable Extensions

The script is designed to handle video files with the following extensions:
```
# List of acceptable extensions (case insensitive)
ACCEPTABLE_EXTENSIONS=("m4v" "mov")
```
This means the script will accept both lowercase and uppercase variations of these extensions, allowing for flexibility when processing files.

## Requirements

ExifTool: This script requires ExifTool to extract EXIF metadata. You can install it via Homebrew:

```bash
brew install exiftool
```

## Contributing
    
Contributions are welcome! If you have any scripts or improvements, feel free to submit a pull request.

## License
    
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.