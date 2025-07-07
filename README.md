# Production OSRM Routing Service

This repository contains a production-ready Docker setup for the OSRM (Open Source Routing Machine) routing service.

## 🚀 Quick Start

### Option 1: Using Docker Compose (Recommended)
```bash
docker-compose up -d
```

### Option 2: Manual Docker Build and Run
```bash
# Build the image
docker build -t osrm-routing-service .

# Run the container
docker run -d \
  --name osrm-routing-prod \
  --restart unless-stopped \
  -p 5000:5000 \
  osrm-routing-service
```

## 🔧 Production Features

- **Security**: Runs as non-root user
- **Health Checks**: Built-in health monitoring
- **Resource Limits**: CPU and memory constraints
- **Logging**: Structured logging with rotation
- **Auto-restart**: Automatic restart on failure
- **Optimized**: Minimal image size with only necessary files

## 📊 API Endpoints

Once running, the service provides the following endpoints:

- **Health Check**: `GET http://localhost:5000/health`
- **Route Calculation**: `GET http://localhost:5000/route/v1/driving/{coordinates}`
- **Nearest Point**: `GET http://localhost:5000/nearest/v1/driving/{coordinates}`
- **Table Service**: `GET http://localhost:5000/table/v1/driving/{coordinates}`

### Example Usage
```bash
# Get route between two points (longitude,latitude format)
curl "http://localhost:5000/route/v1/driving/-43.2096,-22.9035;-43.1729,-22.9068?overview=full&geometries=geojson"

# Find nearest road
curl "http://localhost:5000/nearest/v1/driving/-43.2096,-22.9035"

# Health check
curl "http://localhost:5000/health"
```

## 🛠️ Management Commands

```bash
# View logs
docker logs osrm-routing-prod

# Stop service
docker stop osrm-routing-prod

# Start service
docker start osrm-routing-prod

# Restart service
docker restart osrm-routing-prod

# Remove container
docker rm osrm-routing-prod

# Remove image
docker rmi osrm-routing-service
```

## 📈 Monitoring

The service includes health checks that run every 30 seconds. You can monitor the service status with:

```bash
# Check container health
docker ps

# View detailed health status
docker inspect osrm-routing-prod | grep -A 5 '"Health"'
```

## 🔧 Configuration

### Environment Variables
- `NODE_ENV`: Set to "production"

### Resource Limits (docker-compose.yml)
- CPU: 2.0 cores (limit), 1.0 core (reservation)
- Memory: 4GB (limit), 2GB (reservation)

### Ports
- Default: 5000 (can be changed in docker-compose.yml)

## 🐛 Troubleshooting

### Service not starting
```bash
# Check container logs
docker logs osrm-routing-prod

# Check if files are properly copied
docker exec osrm-routing-prod ls -la /data/
```

### Health check failing
```bash
# Test health endpoint directly
curl -f http://localhost:5000/health

# Check if service is binding to correct interface
docker exec osrm-routing-prod netstat -tlnp
```

### Performance issues
```bash
# Monitor resource usage
docker stats osrm-routing-prod

# Check system resources
htop
```

## 📋 Data Files

The service uses the following preprocessed OSRM data files:
- `sudeste-latest.osrm*` - All OSRM graph and routing data

## 🔄 Updates

To update the service with new data:

1. Stop the current service
2. Replace the OSRM data files
3. Rebuild and restart the service

```bash
docker-compose down
# Replace data files
docker-compose up -d --build
```

## 🏗️ Architecture

```
┌─────────────────────┐
│   Load Balancer     │
│   (nginx/traefik)   │
└──────────┬──────────┘
           │
┌──────────▼──────────┐
│  OSRM Routing       │
│  Service (Docker)   │
│  Port: 5000         │
└──────────┬──────────┘
           │
┌──────────▼──────────┐
│  OSRM Data Files    │
│  (Volume Mount)     │
└─────────────────────┘
```

## 🔐 Security Considerations

- Service runs as non-root user
- Only necessary ports are exposed
- Resource limits prevent resource exhaustion
- Health checks ensure service availability
- Minimal attack surface with optimized image


# (DEV) Pre processing OSM data for OSRM (Open Source Routing Machine)

### Build the OSRM data files

```sh
sudo ./build.sh
```

# Run the server

```sh
docker compose up
```
