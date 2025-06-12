#!/bin/bash
echo "🚀 Starting TruboСhisty application..."

# Check if containers are built
if ! docker images | grep -q "trubochisty"; then
    echo "📦 No built containers found. Building first..."
    ./build.sh
    if [ $? -ne 0 ]; then
        echo "❌ Build failed. Cannot start application."
        exit 1
    fi
fi

echo "🏃 Starting all services..."
docker-compose up -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 5

echo ""
echo "✅ TruboСhisty is now running!"
echo ""
echo "🌐 Access your application:"
echo "   • Frontend: http://localhost:3000"
echo "   • Backend API: http://localhost:8080"
echo "   • Database: localhost:5432 (trubo_user/trubo_pass)"
echo ""
echo "📊 To view logs: docker-compose logs -f"
echo "🛑 To stop: docker-compose down" 