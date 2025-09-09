#!/bin/bash

echo "🔨 BUILDING CUSTOM TIHUT WEB IMAGE"
echo "================================="

cd custom-web

echo "📦 Building tihut/bahmni-web:1.0.0 with built-in TIHUT branding..."
docker build -t tihut/bahmni-web:1.0.0 .

if [ $? -eq 0 ]; then
    echo "✅ Custom TIHUT web image built successfully!"
    echo ""
    echo "🔄 To use the custom image, update your docker-compose.yml:"
    echo "   bahmni-web:"
    echo "     image: tihut/bahmni-web:1.0.0"
    echo ""
    echo "💡 After this change, your TIHUT branding will be permanent!"
else
    echo "❌ Failed to build custom image"
    exit 1
fi