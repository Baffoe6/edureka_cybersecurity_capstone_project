#!/bin/bash
# Main Execution Script for Cybersecurity Capstone Project
# This script orchestrates the entire penetration testing process

echo "=========================================="
echo "Cybersecurity Capstone Project - Main Script"
echo "=========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "scripts/setup.sh" ]; then
    echo "Error: Please run this script from the project root directory"
    exit 1
fi

# Function to display menu
display_menu() {
    echo "Select an option:"
    echo "1. Setup Environment"
    echo "2. Run Reconnaissance"
    echo "3. Run Vulnerability Assessment"
    echo "4. Run Ethical Exploitation"
    echo "5. Generate Documentation"
    echo "6. Run Complete Assessment (All Steps)"
    echo "7. View Project Information"
    echo "8. Exit"
    echo ""
}

# Function to run setup
run_setup() {
    echo "Running environment setup..."
    cd scripts
    chmod +x *.sh
    ./setup.sh
    cd ..
    echo "Setup completed!"
}

# Function to run reconnaissance
run_reconnaissance() {
    echo "Running reconnaissance..."
    cd scripts
    ./reconnaissance.sh
    cd ..
    echo "Reconnaissance completed!"
}

# Function to run vulnerability assessment
run_vulnerability_assessment() {
    echo "Running vulnerability assessment..."
    cd scripts
    ./vulnerability_assessment.sh
    cd ..
    echo "Vulnerability assessment completed!"
}

# Function to run exploitation
run_exploitation() {
    echo "Running ethical exploitation..."
    cd scripts
    ./exploitation.sh
    cd ..
    echo "Exploitation completed!"
}

# Function to generate documentation
run_documentation() {
    echo "Generating documentation..."
    cd scripts
    ./documentation.sh
    cd ..
    echo "Documentation completed!"
}

# Function to run complete assessment
run_complete_assessment() {
    echo "Running complete penetration testing assessment..."
    echo "This will run all phases in sequence."
    echo ""
    
    run_setup
    echo ""
    run_reconnaissance
    echo ""
    run_vulnerability_assessment
    echo ""
    run_exploitation
    echo ""
    run_documentation
    echo ""
    
    echo "Complete assessment finished!"
    echo "Check the reports/ directory for all generated reports."
}

# Function to display project information
display_project_info() {
    echo "Project Information:"
    echo "==================="
    echo ""
    echo "Project Name: Cybersecurity Capstone Project"
    echo "Description: Ethical Hacking of E-commerce Website"
    echo "Target: E-commerce website (configure in target_info.txt)"
    echo ""
    echo "Project Structure:"
    echo "- scripts/: Penetration testing scripts"
    echo "- reports/: Generated reports and documentation"
    echo "- logs/: Log files from testing sessions"
    echo "- wordlists/: Wordlists for brute force attacks"
    echo ""
    echo "Files:"
    echo "- README.md: Project overview and instructions"
    echo "- target_info.txt: Target configuration (create this)"
    echo "- wordlist.txt: Provided wordlist for testing"
    echo "- filelist.txt: Provided file list for testing"
    echo "- js_6rk_wd58kli.ova: Target virtual machine"
    echo ""
    echo "Scripts:"
    echo "- setup.sh: Environment setup and tool verification"
    echo "- reconnaissance.sh: Initial reconnaissance phase"
    echo "- vulnerability_assessment.sh: Vulnerability scanning"
    echo "- exploitation.sh: Ethical exploitation of vulnerabilities"
    echo "- documentation.sh: Report generation and documentation"
    echo ""
}

# Main menu loop
while true; do
    display_menu
    read -p "Enter your choice (1-8): " choice
    
    case $choice in
        1)
            run_setup
            ;;
        2)
            run_reconnaissance
            ;;
        3)
            run_vulnerability_assessment
            ;;
        4)
            run_exploitation
            ;;
        5)
            run_documentation
            ;;
        6)
            run_complete_assessment
            ;;
        7)
            display_project_info
            ;;
        8)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose 1-8."
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    echo ""
done
