#!/bin/bash

echo "🚀 Fast incremental build with Maven cache..."

# Enable Docker BuildKit for cache mounts
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Build with parallel processing and cache mounts
docker-compose build --parallel

echo "✅ Done! Maven dependencies cached for next build!"
echo "🎯 Run: docker-compose up" 