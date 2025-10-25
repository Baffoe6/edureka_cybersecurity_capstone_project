#!/bin/bash
# Docker management script for Cybersecurity Capstone Project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_success "Docker and Docker Compose are installed"
}

# Function to build the Docker image
build_image() {
    print_status "Building Docker image for cybersecurity capstone project..."
    docker build -t cybersecurity-capstone:latest .
    print_success "Docker image built successfully"
}

# Function to start the services
start_services() {
    print_status "Starting cybersecurity capstone services..."
    docker-compose up -d
    print_success "Services started successfully"
    print_status "Report server available at: http://localhost:8080"
}

# Function to stop the services
stop_services() {
    print_status "Stopping cybersecurity capstone services..."
    docker-compose down
    print_success "Services stopped successfully"
}

# Function to run penetration testing
run_assessment() {
    print_status "Running penetration testing assessment..."
    docker-compose exec pentest-env bash run_assessment.sh
    print_success "Assessment completed"
}

# Function to view logs
view_logs() {
    print_status "Viewing service logs..."
    docker-compose logs -f
}

# Function to clean up
cleanup() {
    print_status "Cleaning up Docker resources..."
    docker-compose down -v
    docker system prune -f
    print_success "Cleanup completed"
}

# Function to show status
show_status() {
    print_status "Docker services status:"
    docker-compose ps
}

# Function to show help
show_help() {
    echo "Cybersecurity Capstone Project - Docker Management Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  build       Build the Docker image"
    echo "  start       Start all services"
    echo "  stop        Stop all services"
    echo "  restart     Restart all services"
    echo "  run         Run penetration testing assessment"
    echo "  logs        View service logs"
    echo "  status      Show service status"
    echo "  cleanup     Clean up Docker resources"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 build && $0 start"
    echo "  $0 run"
    echo "  $0 logs"
}

# Main script logic
case "${1:-help}" in
    build)
        check_docker
        build_image
        ;;
    start)
        check_docker
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        stop_services
        start_services
        ;;
    run)
        run_assessment
        ;;
    logs)
        view_logs
        ;;
    status)
        show_status
        ;;
    cleanup)
        cleanup
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
