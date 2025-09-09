#!/bin/bash

echo "🔨 BUILDING CUSTOM TEHUT WEB IMAGE"
echo "================================="

cd custom-web

echo "📦 Building tehut/bahmni-web:1.0.0 with built-in TEHUT branding..."
docker build -t tehut/bahmni-web:1.0.0 .

if [ $? -eq 0 ]; then
    echo "✅ Custom TEHUT web image built successfully!"
    echo ""
    echo "🔄 To use the custom image, update your docker-compose.yml:"
    echo "   bahmni-web:"
    echo "     image: tehut/bahmni-web:1.0.0"
    echo ""
    echo "💡 After this change, your TEHUT branding will be permanent!"
else
    echo "❌ Failed to build custom image"
    exit 1
fi