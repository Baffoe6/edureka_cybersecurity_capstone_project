# Dockerfile for Cybersecurity Capstone Project
# Multi-stage build for penetration testing environment

FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    unzip \
    python3 \
    python3-pip \
    nodejs \
    npm \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install penetration testing tools
RUN apt-get update && apt-get install -y \
    nmap \
    nikto \
    dirb \
    gobuster \
    hydra \
    john \
    sqlmap \
    whatweb \
    sslscan \
    && rm -rf /var/lib/apt/lists/*

# Install additional security tools via pip
RUN pip3 install \
    requests \
    beautifulsoup4 \
    python-nmap \
    scapy

# Install markdownlint for documentation
RUN npm install -g markdownlint-cli2

# Create project directory
WORKDIR /app

# Copy project files
COPY . /app/

# Set permissions for scripts
RUN chmod +x scripts/*.sh
RUN chmod +x run_assessment.sh

# Create directories for outputs
RUN mkdir -p logs reports wordlists

# Set up wordlists if they don't exist
RUN if [ ! -f wordlists/common_dirs.txt ]; then \
    echo "admin\nadministrator\nlogin\npanel\ndashboard" > wordlists/common_dirs.txt; \
    fi

RUN if [ ! -f wordlists/common_files.txt ]; then \
    echo "index.html\nindex.php\nlogin.php\nadmin.php" > wordlists/common_files.txt; \
    fi

# Expose ports (if needed for web services)
EXPOSE 8080 8443

# Set default command
CMD ["bash", "run_assessment.sh"]
