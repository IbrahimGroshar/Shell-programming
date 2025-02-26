#!/usr/bin/env bash
#
# A template for creating command line scripts taking options, commands
# and arguments.
#
# Exit values:
#  0 on success
#  1 on failure
#

# Name of the script
SCRIPT=$( basename "$0" )

# Current version
VERSION="1.1.0"

#
# Message to display for usage and help.
#
function usage
{
    local txt=(
"Utility $SCRIPT for doing stuff."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Command:"
"  command1             Demo of command."
"  command2 [anything]  Demo of command using arguments."
"  calendar [events]    Print out current calendar with(out) events."
"  local-quote         Get a quote from the local fortune program."
"  online-quote       Get a daily quote from an online API."
""
"Options:"
"  --help, -h     Print help."
"  --version, -v  Print version."
    )

    printf "%s\n" "${txt[@]}"
}

#
# Message to display when bad usage.
#
function badUsage
{
    local message="$1"
    local txt=(
"For an overview of the command, execute:"
"$SCRIPT --help"
    )

    [[ -n $message ]] && printf "%s\n" "$message"

    printf "%s\n" "${txt[@]}"
}

#
# Message to display for version.
#
function version
{
    local txt=(
"$SCRIPT version $VERSION"
    )

    printf "%s\n" "${txt[@]}"
}

# Function for command1
function app-command1
{
    echo "This is output from command1."
}

# Function for command2
function app-command2
{
    echo "This is output from command2."
    echo "Command 2 takes additional arguments which currently are:"
    echo " Number of arguments = '$#'"
    echo " List of arguments = '$*'"
}

# Function for calendar
function app-calendar
{
    local events="$1"
    echo "This is output from command3, showing the current calendar."
    cal -3
    (( $? == 127 )) && echo "Error. You might need to install the ncal package using apt install."

    if [ "$events" = "events" ]; then
        echo
        calendar
        (( $? == 127 )) && echo "Error. You might need to install the calendar package using apt install."
    fi
}

# Function for local quotes
function app-local-quote
{
    if ! command -v fortune &> /dev/null; then
        echo "Error: 'fortune' command not found. Install it using: sudo apt install fortune"
        exit 1
    fi
    fortune | cowsay
}

# Function for online quotes
function app-online-quote
{
    if ! command -v curl &> /dev/null; then
        echo "Error: 'curl' command not found. Install it using: sudo apt install curl"
        exit 1
    fi
    
    response=$(curl -s "https://api.quotable.io/random")
    quote=$(echo "$response" | jq -r '.content')
    author=$(echo "$response" | jq -r '.author')
    
    if [ -z "$quote" ] || [ -z "$author" ]; then
        echo "Error: Could not retrieve quote."
        exit 1
    fi
    
    echo "\"$quote\" - $author"
}

# Process options
while (( $# ))
do
    case "$1" in
        --help | -h)
            usage
            exit 0
        ;;

        --version | -v)
            version
            exit 0
        ;;

        command1         \
        | command2       \
        | calendar       \
        | local-quote    \
        | online-quote)
            command=$1
            shift
            app-"$command" "$*"
            exit 0
        ;;

        *)
            badUsage "Option/command not recognized."
            exit 1
        ;;
    esac
done

badUsage
exit 1
