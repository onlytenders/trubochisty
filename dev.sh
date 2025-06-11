#!/bin/bash
echo "🔥 Super fast dev build..."

# Enable BuildKit
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Only rebuild what changed
docker-compose build --parallel --pull

# Start with auto-restart
docker-compose up --force-recreate

echo "🎯 Dev environment ready!" 