#!/bin/bash
# Reconnaissance Script for Cybersecurity Capstone Project
# This script performs initial reconnaissance on the target e-commerce website

echo "=========================================="
echo "Reconnaissance Phase - E-commerce Website"
echo "=========================================="

# Check if target information is provided
if [ ! -f "../target_info.txt" ]; then
    echo "Error: target_info.txt not found!"
    echo "Please run setup.sh first and fill in target information."
    exit 1
fi

# Source target information
source ../target_info.txt

if [ -z "$TARGET_IP" ] && [ -z "$TARGET_DOMAIN" ]; then
    echo "Error: TARGET_IP or TARGET_DOMAIN must be set in target_info.txt"
    exit 1
fi

# Set target
if [ -n "$TARGET_DOMAIN" ]; then
    TARGET="$TARGET_DOMAIN"
else
    TARGET="$TARGET_IP"
fi

echo "Target: $TARGET"
echo "Starting reconnaissance at $(date)"
echo ""

# Create log file for this session
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="../logs/reconnaissance_${TIMESTAMP}.log"
REPORT_FILE="../reports/reconnaissance_report_${TIMESTAMP}.txt"

echo "Reconnaissance Report - $TARGET" > "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo "==========================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 1. Network Discovery
echo "1. Network Discovery"
echo "==================="
echo "1. Network Discovery" >> "$REPORT_FILE"
echo "===================" >> "$REPORT_FILE"

# Ping test
echo "Ping test..."
echo "Ping test:" >> "$REPORT_FILE"
ping -c 4 "$TARGET" >> "$REPORT_FILE" 2>&1
echo "" >> "$REPORT_FILE"

# 2. Port Scanning
echo "2. Port Scanning"
echo "================="
echo "2. Port Scanning" >> "$REPORT_FILE"
echo "=================" >> "$REPORT_FILE"

# Nmap scan
echo "Running nmap scan..."
echo "Nmap scan results:" >> "$REPORT_FILE"
nmap -sS -sV -O -p- "$TARGET" >> "$REPORT_FILE" 2>&1
echo "" >> "$REPORT_FILE"

# 3. Service Enumeration
echo "3. Service Enumeration"
echo "======================"
echo "3. Service Enumeration" >> "$REPORT_FILE"
echo "======================" >> "$REPORT_FILE"

# HTTP service enumeration
echo "HTTP service enumeration..."
echo "HTTP service enumeration:" >> "$REPORT_FILE"

# Check for HTTP
if nmap -p 80 "$TARGET" | grep -q "open"; then
    echo "HTTP (port 80) is open" >> "$REPORT_FILE"
    
    # Basic HTTP information
    echo "HTTP headers:" >> "$REPORT_FILE"
    curl -I "http://$TARGET" >> "$REPORT_FILE" 2>&1
    echo "" >> "$REPORT_FILE"
    
    # Check for common web technologies
    echo "Web technology detection:" >> "$REPORT_FILE"
    whatweb "http://$TARGET" >> "$REPORT_FILE" 2>&1
    echo "" >> "$REPORT_FILE"
fi

# Check for HTTPS
if nmap -p 443 "$TARGET" | grep -q "open"; then
    echo "HTTPS (port 443) is open" >> "$REPORT_FILE"
    
    # Basic HTTPS information
    echo "HTTPS headers:" >> "$REPORT_FILE"
    curl -I -k "https://$TARGET" >> "$REPORT_FILE" 2>&1
    echo "" >> "$REPORT_FILE"
    
    # SSL/TLS information
    echo "SSL/TLS information:" >> "$REPORT_FILE"
    openssl s_client -connect "$TARGET:443" -servername "$TARGET" < /dev/null 2>/dev/null | openssl x509 -noout -text >> "$REPORT_FILE" 2>&1
    echo "" >> "$REPORT_FILE"
fi

# 4. DNS Enumeration
echo "4. DNS Enumeration"
echo "=================="
echo "4. DNS Enumeration" >> "$REPORT_FILE"
echo "==================" >> "$REPORT_FILE"

if [ -n "$TARGET_DOMAIN" ]; then
    echo "DNS information for $TARGET_DOMAIN:" >> "$REPORT_FILE"
    
    # A records
    echo "A records:" >> "$REPORT_FILE"
    dig A "$TARGET_DOMAIN" >> "$REPORT_FILE" 2>&1
    echo "" >> "$REPORT_FILE"
    
    # MX records
    echo "MX records:" >> "$REPORT_FILE"
    dig MX "$TARGET_DOMAIN" >> "$REPORT_FILE" 2>&1
    echo "" >> "$REPORT_FILE"
    
    # NS records
    echo "NS records:" >> "$REPORT_FILE"
    dig NS "$TARGET_DOMAIN" >> "$REPORT_FILE" 2>&1
    echo "" >> "$REPORT_FILE"
    
    # TXT records
    echo "TXT records:" >> "$REPORT_FILE"
    dig TXT "$TARGET_DOMAIN" >> "$REPORT_FILE" 2>&1
    echo "" >> "$REPORT_FILE"
fi

# 5. Directory Enumeration
echo "5. Directory Enumeration"
echo "========================"
echo "5. Directory Enumeration" >> "$REPORT_FILE"
echo "========================" >> "$REPORT_FILE"

# Use provided wordlists
if [ -f "../wordlists/filelist.txt" ]; then
    echo "Directory enumeration using provided wordlist..."
    echo "Directory enumeration results:" >> "$REPORT_FILE"
    
    # Try both HTTP and HTTPS
    for protocol in http https; do
        if nmap -p 80,443 "$TARGET" | grep -q "$protocol.*open"; then
            echo "Scanning $protocol://$TARGET" >> "$REPORT_FILE"
            dirb "$protocol://$TARGET" "../wordlists/filelist.txt" >> "$REPORT_FILE" 2>&1
            echo "" >> "$REPORT_FILE"
        fi
    done
fi

# 6. Vulnerability Scanning
echo "6. Initial Vulnerability Scan"
echo "=============================="
echo "6. Initial Vulnerability Scan" >> "$REPORT_FILE"
echo "==============================" >> "$REPORT_FILE"

# Nikto scan
echo "Running Nikto vulnerability scan..."
echo "Nikto scan results:" >> "$REPORT_FILE"
nikto -h "$TARGET" >> "$REPORT_FILE" 2>&1
echo "" >> "$REPORT_FILE"

# 7. Summary
echo "7. Reconnaissance Summary"
echo "========================"
echo "7. Reconnaissance Summary" >> "$REPORT_FILE"
echo "========================" >> "$REPORT_FILE"

echo "Reconnaissance completed at $(date)" >> "$REPORT_FILE"
echo "Log file: $LOG_FILE" >> "$REPORT_FILE"
echo "Report file: $REPORT_FILE" >> "$REPORT_FILE"

echo ""
echo "Reconnaissance completed!"
echo "Report saved to: $REPORT_FILE"
echo "Log saved to: $LOG_FILE"
echo ""
echo "Next steps:"
echo "1. Review the reconnaissance report"
echo "2. Run vulnerability assessment: ./scripts/vulnerability_assessment.sh"
echo "3. Analyze findings for potential attack vectors"
echo ""
echo "=========================================="
