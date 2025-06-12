#!/bin/bash

echo "🚀 Building TruboСhisty application..."
echo "📦 This includes: Backend (Spring Boot), Frontend (Flutter), Database (PostgreSQL)"

# Enable Docker BuildKit for cache mounts
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Build with parallel processing and cache mounts
echo "🔨 Building containers in parallel..."
if docker-compose build --parallel; then
    echo "✅ Build successful!"
    echo ""
    echo "🎯 Next steps:"
    echo "   • Run: docker-compose up -d (start in background)"
    echo "   • Run: docker-compose up (start with logs)"
    echo "   • Backend will be at: http://localhost:8080"
    echo "   • Frontend will be at: http://localhost:3000"
    echo "   • Database at: localhost:5432 (trubo_user/trubo_pass)"
else
    echo "❌ Build failed! Check the errors above."
    exit 1
fi 