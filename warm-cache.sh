#!/bin/bash
echo "🔥 Warming Docker cache for lightning-fast builds..."
echo "📥 This will download all base images used by TruboСhisty"

# Enable BuildKit
export DOCKER_BUILDKIT=1

# Pull base images in parallel
echo ""
echo "📦 Downloading base images in parallel..."
echo "   • Maven (for Spring Boot backend)"
echo "   • Amazon Corretto JDK (for Java runtime)"
echo "   • Dart SDK (for Flutter frontend)"
echo "   • Nginx (for web server)"
echo "   • PostgreSQL (for database)"

docker pull maven:latest &
docker pull amazoncorretto:21-alpine-jdk &
docker pull dart:stable &
docker pull nginx:alpine &
docker pull postgres:15-alpine &

echo ""
echo "⏳ Waiting for all downloads to complete..."
wait

echo ""
echo "✅ Cache warming complete! All base images downloaded."
echo ""
echo "🚀 Next steps:"
echo "   • Use ./dev.sh for development (with live logs)"
echo "   • Use ./build.sh for production builds"
echo "   • First build will now be much faster!" 