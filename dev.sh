#!/bin/bash
echo "🔥 Starting TruboСhisty development environment..."

# Enable BuildKit
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Stop any running containers first
echo "🛑 Stopping existing containers..."
docker-compose down

# Only rebuild what changed
echo "🔨 Building changed containers..."
if docker-compose build --parallel --pull; then
    echo "✅ Build complete!"
else
    echo "❌ Build failed!"
    exit 1
fi

# Start with auto-restart and recreate containers
echo "🚀 Starting development environment..."
echo "📊 Logs will stream below. Press Ctrl+C to stop."
echo ""
echo "🌐 Services will be available at:"
echo "   • Frontend: http://localhost:3000"
echo "   • Backend API: http://localhost:8080"
echo "   • Database: localhost:5432"
echo ""

docker-compose up --force-recreate 