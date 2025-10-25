# Docker Setup for Cybersecurity Capstone Project

## Overview
This project includes Docker support for containerized penetration testing environment, making it portable and easy to deploy across different systems.

## Docker Components

### 1. Main Dockerfile
- **Base Image:** Ubuntu 22.04
- **Tools Included:** Nmap, Nikto, SQLMap, Hydra, Dirb, Gobuster, WhatWeb, SSLScan
- **Languages:** Python 3, Node.js, Bash
- **Security Tools:** Complete penetration testing toolkit

### 2. Docker Compose Services
- **pentest-env:** Main penetration testing environment
- **report-server:** Nginx server for hosting reports
- **assessment-db:** PostgreSQL database for storing results
- **redis-cache:** Redis for caching scan results

## Quick Start with Docker

### Prerequisites
- Docker Engine 20.10+
- Docker Compose 2.0+
- Git

### 1. Clone and Build
```bash
git clone https://github.com/Baffoe6/edureka_cybersecurity_capstone_project.git
cd edureka_cybersecurity_capstone_project
```

### 2. Build Docker Image
```bash
# Using the management script
./docker-manage.sh build

# Or manually
docker build -t cybersecurity-capstone:latest .
```

### 3. Start Services
```bash
# Using the management script
./docker-manage.sh start

# Or manually
docker-compose up -d
```

### 4. Run Assessment
```bash
# Using the management script
./docker-manage.sh run

# Or manually
docker-compose exec pentest-env bash run_assessment.sh
```

## Docker Management Script

The `docker-manage.sh` script provides easy management of Docker services:

```bash
# Build the Docker image
./docker-manage.sh build

# Start all services
./docker-manage.sh start

# Run penetration testing
./docker-manage.sh run

# View logs
./docker-manage.sh logs

# Stop services
./docker-manage.sh stop

# Clean up resources
./docker-manage.sh cleanup
```

## Services and Ports

| Service | Port | Description |
|---------|------|-------------|
| Report Server | 8080 | Web interface for viewing reports |
| PostgreSQL | 5432 | Database for storing assessment results |
| Redis | 6379 | Cache for scan results |

## Volume Mounts

- `./reports` → `/app/reports` - Assessment reports
- `./logs` → `/app/logs` - Log files
- `./wordlists` → `/app/wordlists` - Wordlists for testing
- `./target_info.txt` → `/app/target_info.txt` - Target configuration

## Environment Variables

Configure the environment using `docker.env`:

```bash
# Target Configuration
TARGET_IP=192.168.1.100
TARGET_DOMAIN=ecommerce-test.local

# Database Configuration
POSTGRES_DB=pentest_results
POSTGRES_USER=pentest_user
POSTGRES_PASSWORD=pentest_pass
```

## Docker Commands Reference

### Basic Operations
```bash
# Build image
docker build -t cybersecurity-capstone .

# Run container
docker run -it --rm cybersecurity-capstone

# Run with volume mounts
docker run -it --rm -v $(pwd)/reports:/app/reports cybersecurity-capstone
```

### Docker Compose Operations
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild and restart
docker-compose up --build -d
```

### Database Operations
```bash
# Connect to database
docker-compose exec assessment-db psql -U pentest_user -d pentest_results

# Backup database
docker-compose exec assessment-db pg_dump -U pentest_user pentest_results > backup.sql

# Restore database
docker-compose exec -T assessment-db psql -U pentest_user -d pentest_results < backup.sql
```

## Security Considerations

### Container Security
- Non-root user execution
- Minimal base image
- Security headers enabled
- Network isolation

### Data Protection
- Volume mounts for persistent data
- Environment variable configuration
- Secure database credentials
- Encrypted connections

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   chmod +x docker-manage.sh
   ```

2. **Port Already in Use**
   ```bash
   # Change ports in docker-compose.yml
   # Or stop conflicting services
   ```

3. **Build Failures**
   ```bash
   # Clean Docker cache
   docker system prune -a
   # Rebuild
   docker-compose build --no-cache
   ```

4. **Database Connection Issues**
   ```bash
   # Check database status
   docker-compose exec assessment-db pg_isready
   ```

### Debugging

```bash
# View container logs
docker-compose logs pentest-env

# Execute shell in container
docker-compose exec pentest-env bash

# Check service status
docker-compose ps

# View resource usage
docker stats
```

## Performance Optimization

### Resource Limits
```yaml
# Add to docker-compose.yml
services:
  pentest-env:
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
```

### Multi-stage Builds
The Dockerfile uses multi-stage builds to optimize image size and build time.

## Integration with CI/CD

### GitHub Actions Integration
```yaml
- name: Build Docker image
  run: docker build -t cybersecurity-capstone .

- name: Run security tests
  run: docker run --rm cybersecurity-capstone bash run_assessment.sh
```

## Best Practices

1. **Use .dockerignore** to exclude unnecessary files
2. **Pin specific versions** for reproducible builds
3. **Use multi-stage builds** for smaller images
4. **Implement health checks** for services
5. **Use secrets management** for sensitive data
6. **Regular security updates** of base images

## Support

For Docker-related issues:
1. Check the troubleshooting section
2. Review Docker logs
3. Verify environment configuration
4. Check GitHub Issues for known problems
