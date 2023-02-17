clear

# Checks that a directory was provided as an argument.
if [ $# -ne 1 ]; then
        echo "Using:  $0 <dir>"
        exit 1
fi

# Checks that the directory exists
if [ ! -d "$1" ]; then
        echo "Error: $1 is not a directory"
        exit 1
fi

# Get the base name of the directory
dir_basename=$(basename"$1")

# Generates the name of the backup file
backup_file="tmp/${dir_basename}_backup_$(date +%F_%H-%M-%S).tar.gz"

# Checks if the backup file exitsts

if [ -e "$backup_file" ]; then
        echo "Error: the backup file $backup_file already exists"
        exit 1

fi

# Creates the backup file
echo "Creating the backup file of $1..."
start_time=$(date +%s)
tar -czf "$backup_file" "$1"
end_time=$(date +%s)
echo "Backup complete.\nTime taken: $((end_time - start_time)) seconds."