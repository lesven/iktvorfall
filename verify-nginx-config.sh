#!/bin/bash
# Nginx Configuration Validator
# This script validates the Nginx configuration and helps identify errors

# Default values
CONFIG_FILE="./nginx.conf"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -f|--file)
      CONFIG_FILE="$2"
      shift
      shift
      ;;
    *)
      # Unknown option
      shift
      ;;
  esac
done

# Function to print colored text
print_colored() {
    COLOR=$2
    if [ -z "$COLOR" ]; then
        COLOR=$NC
    fi
    echo -e "${COLOR}$1${NC}"
}

# Header
print_colored "=== Nginx Configuration Validator ===" "$CYAN"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_colored "Docker is not running! Please start Docker and try again." "$RED"
    exit 1
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    print_colored "Configuration file not found: $CONFIG_FILE" "$RED"
    exit 1
fi

# Create a temporary directory with the configuration
TEMP_DIR=$(mktemp -d)
TEMP_CONF="$TEMP_DIR/default.conf"

# Copy the configuration file to the temporary directory
cp "$CONFIG_FILE" "$TEMP_CONF"

print_colored "Validating Nginx configuration..." "$YELLOW"

# Run a temporary Nginx container to validate the configuration
RESULT=$(docker run --rm -v "$TEMP_DIR:/etc/nginx/conf.d" nginx:alpine nginx -t 2>&1)
EXIT_CODE=$?

# Display the result
if [ $EXIT_CODE -eq 0 ]; then
    print_colored "✓ Configuration is valid!" "$GREEN"
    print_colored "$RESULT" "$GRAY"
else
    print_colored "✗ Configuration has errors!" "$RED"
    
    # Try to parse the error message in more detail
    ERROR_MESSAGE="$RESULT"
    
    # Extract the line number if available
    LINE_NUM=$(echo "$ERROR_MESSAGE" | grep -oP "in\s+/etc/nginx/conf\.d/default\.conf:\K\d+")
    
    if [ ! -z "$LINE_NUM" ]; then
        print_colored "Error on line $LINE_NUM of the configuration file:" "$YELLOW"
        
        # Display the problematic line and its context
        START_LINE=$((LINE_NUM - 3))
        if [ $START_LINE -lt 1 ]; then
            START_LINE=1
        fi
        
        END_LINE=$((LINE_NUM + 3))
        LINE_COUNT=$(wc -l < "$CONFIG_FILE")
        if [ $END_LINE -gt $LINE_COUNT ]; then
            END_LINE=$LINE_COUNT
        fi
        
        CURRENT_LINE=1
        while IFS= read -r line; do
            if [ $CURRENT_LINE -ge $START_LINE ] && [ $CURRENT_LINE -le $END_LINE ]; then
                if [ $CURRENT_LINE -eq $LINE_NUM ]; then
                    print_colored "Line $CURRENT_LINE: $line" "$RED"
                else
                    print_colored "Line $CURRENT_LINE: $line" "$GRAY"
                fi
            fi
            CURRENT_LINE=$((CURRENT_LINE + 1))
            if [ $CURRENT_LINE -gt $END_LINE ]; then
                break
            fi
        done < "$CONFIG_FILE"
    fi
    
    print_colored "\nError details:" "$YELLOW"
    print_colored "$ERROR_MESSAGE" "$GRAY"
fi

# Clean up temporary directory
rm -rf "$TEMP_DIR"

print_colored "\nDone!" "$CYAN"
