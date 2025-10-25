#!/bin/bash
# Environment Setup Script for Cybersecurity Capstone Project
# This script sets up the penetration testing environment

echo "=========================================="
echo "Cybersecurity Capstone Project Setup"
echo "=========================================="

# Create necessary directories
echo "Creating project directories..."
mkdir -p {scripts,reports,logs,wordlists,tools}

# Check for required tools
echo "Checking for required penetration testing tools..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# List of required tools
tools=("nmap" "nikto" "dirb" "gobuster" "hydra" "john" "sqlmap" "wget" "curl")

echo "Checking tool availability:"
for tool in "${tools[@]}"; do
    if command_exists "$tool"; then
        echo "✓ $tool is installed"
    else
        echo "✗ $tool is NOT installed"
        echo "  Please install $tool before proceeding"
    fi
done

# Create wordlists directory and copy provided wordlists
echo "Setting up wordlists..."
if [ -f "../wordlist.txt" ]; then
    cp ../wordlist.txt wordlists/
    echo "✓ Copied wordlist.txt to wordlists/"
fi

if [ -f "../filelist.txt" ]; then
    cp ../filelist.txt wordlists/
    echo "✓ Copied filelist.txt to wordlists/"
fi

# Create additional wordlists for comprehensive testing
echo "Creating additional wordlists..."

# Common directories wordlist
cat > wordlists/common_dirs.txt << EOF
admin
administrator
login
panel
dashboard
control
manage
management
config
configuration
settings
backup
backups
test
testing
dev
development
staging
prod
production
www
public
private
secure
security
auth
authentication
session
sessions
profile
profiles
account
accounts
api
v1
v2
user
users
customer
customers
product
products
order
orders
cart
checkout
payment
payments
EOF

# Common files wordlist
cat > wordlists/common_files.txt << EOF
index.html
index.php
index.asp
index.jsp
index.py
index.cgi
login.html
login.php
admin.html
admin.php
config.php
config.ini
config.xml
robots.txt
sitemap.xml
crossdomain.xml
favicon.ico
phpinfo.php
info.php
test.php
backup.sql
database.sql
db.sql
dump.sql
EOF

echo "✓ Created additional wordlists"

# Create target information file
echo "Creating target information template..."
cat > target_info.txt << EOF
# Target Information
# Fill in the details of your target e-commerce website

TARGET_IP=
TARGET_DOMAIN=
TARGET_PORT=80,443
TARGET_OS=
TARGET_SERVICES=

# Notes
# Add any specific information about the target here
EOF

echo "✓ Created target_info.txt template"

# Create log file for this session
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="logs/setup_${TIMESTAMP}.log"

echo "Setup completed at $(date)" > "$LOG_FILE"
echo "Setup completed successfully!"
echo "Log file created: $LOG_FILE"
echo ""
echo "Next steps:"
echo "1. Fill in target information in target_info.txt"
echo "2. Import the OVA file (js_6rk_wd58kli.ova) into your virtualization software"
echo "3. Start the target machine and note its IP address"
echo "4. Run the reconnaissance script: ./scripts/reconnaissance.sh"
echo ""
echo "=========================================="
