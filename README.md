# Trubochisty Development Setup

Quick setup guide for the team to get the full-stack app running with Docker.

## Stack
- **Backend**: Spring Boot (Java 21) with Amazon Corretto
- **Frontend**: Flutter Web with nginx
- **Database**: None currently

## Prerequisites
- Docker
- Docker Compose

## Getting Started

### First Time Setup
```bash
# Warm up Docker cache (downloads base images)
./warm-cache.sh

# Build everything
./build.sh

# Run the app
docker-compose up
```

### Daily Development
```bash
# Quick build and run
./dev.sh

# Or just rebuild when needed
./build.sh
docker-compose up
```

## Available Scripts

### `./warm-cache.sh`
- Downloads all base Docker images in parallel
- Run this first time or when Docker cache gets cleared
- Makes subsequent builds much faster

### `./build.sh` 
- Builds both frontend and backend with optimized caching
- Uses BuildKit for fast incremental builds
- Maven dependencies are cached between builds

### `./dev.sh`
- Development mode: builds and starts everything
- Auto-recreates containers for fresh state
- Good for when you want to start clean

## Access Points
- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:8080
- **Health Check**: http://localhost:8080/actuator/health

## Build Optimization
- Maven dependencies cached with BuildKit cache mounts
- Only rebuilds when pom.xml or pubspec.yaml change
- Code changes trigger fast rebuilds (~30-60 seconds)

## Common Issues

**Build taking forever?**
- Run `./warm-cache.sh` first
- First build downloads images, subsequent builds are fast

**Port already in use?**
- Kill existing containers: `docker-compose down`
- Check what's using the port: `lsof -ti:8080` then `kill -9 <pid>`

**Maven downloading dependencies again?**
- BuildKit cache mounts should prevent this
- Make sure `DOCKER_BUILDKIT=1` is set (scripts do this automatically)

## Development Tips
- Change code → run `./build.sh` → `docker-compose up`
- For frontend changes, only frontend container rebuilds
- For backend changes, only backend container rebuilds
- Dependencies only redownload when pom.xml/pubspec.yaml change
