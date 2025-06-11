#!/bin/bash
echo "🔥 Warming Docker cache for super fast builds..."

# Enable BuildKit
export DOCKER_BUILDKIT=1

# Pull base images in parallel
echo "📥 Pulling base images..."
docker pull maven:latest &
docker pull amazoncorretto:21-alpine-jdk &
docker pull dart:stable &
docker pull nginx:alpine &
wait

echo "✅ Cache warmed! Now builds will be lightning fast!"
echo "💡 Use ./dev.sh for development or ./build.sh for regular builds" 