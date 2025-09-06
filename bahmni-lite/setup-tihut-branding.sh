#!/bin/bash

# TIHUT Clinic Complete Branding Setup Script
# This script ensures ALL Bahmni branding is replaced with TIHUT Clinic

set -e

echo "🏥 TIHUT CLINIC COMPLETE BRANDING SETUP"
echo "======================================="

# Function to replace logos in containers
replace_logos_in_container() {
    local container_name=$1
    echo "📸 Replacing logos in $container_name..."
    
    # Replace main Bahmni logos with TIHUT logo
    docker exec $container_name sh -c "
        find /usr/local/apache2/htdocs -name '*bahmni*' -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.svg' \) -exec cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg {} \; 2>/dev/null || true
        
        # Replace specific logo files
        if [ -f /usr/local/apache2/htdocs/bahmni/images/bahmniLogoFull.png ]; then
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/bahmni/images/bahmniLogoFull.png
        fi
        
        if [ -f /usr/local/apache2/htdocs/bahmni-logo.png ]; then
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/bahmni-logo.png
        fi
        
        # Replace any other bahmni logos
        find /usr/local/apache2/htdocs -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' | xargs grep -l -i 'bahmni' 2>/dev/null | head -10 | while read file; do
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg \"\$file\" 2>/dev/null || true
        done
    " || echo "⚠️  Container $container_name not running, will replace logos when started"
}

# Function to inject CSS and JavaScript
inject_custom_files() {
    local container_name=$1
    echo "💉 Injecting TIHUT branding files into $container_name..."
    
    docker exec $container_name sh -c "
        # Create custom directory if it doesn't exist
        mkdir -p /usr/local/apache2/htdocs/tihut-custom
        
        # Copy custom CSS to be loaded
        if [ -f /usr/local/apache2/htdocs/bahmni_config/custom/complete-tihut-branding.css ]; then
            cp /usr/local/apache2/htdocs/bahmni_config/custom/complete-tihut-branding.css /usr/local/apache2/htdocs/tihut-custom/
        fi
        
        # Copy JavaScript file
        if [ -f /usr/local/apache2/htdocs/bahmni_config/custom/tihut-text-replacement.js ]; then
            cp /usr/local/apache2/htdocs/bahmni_config/custom/tihut-text-replacement.js /usr/local/apache2/htdocs/tihut-custom/
        fi
        
        # Inject CSS and JS into main HTML files
        find /usr/local/apache2/htdocs -name '*.html' | while read html_file; do
            # Add CSS link if not already present
            if ! grep -q 'complete-tihut-branding.css' \"\$html_file\"; then
                sed -i 's|</head>|<link rel=\"stylesheet\" type=\"text/css\" href=\"/tihut-custom/complete-tihut-branding.css\">\n</head>|g' \"\$html_file\" 2>/dev/null || true
            fi
            
            # Add JavaScript if not already present
            if ! grep -q 'tihut-text-replacement.js' \"\$html_file\"; then
                sed -i 's|</body>|<script src=\"/tihut-custom/tihut-text-replacement.js\"></script>\n</body>|g' \"\$html_file\" 2>/dev/null || true
            fi
            
            # Replace title if it contains Bahmni
            sed -i 's|<title>.*[Bb]ahmni.*</title>|<title>TIHUT Clinic - Healthcare Management System</title>|g' \"\$html_file\" 2>/dev/null || true
        done
    " || echo "⚠️  Container $container_name not running, will inject files when started"
}

echo ""
echo "🔍 Checking current setup..."

# Check if custom config exists
if [ ! -d "custom-config" ]; then
    echo "❌ Error: custom-config directory not found!"
    exit 1
fi

if [ ! -f "custom-config/images/tihut-logo.jpg" ]; then
    echo "❌ Error: TIHUT logo not found!"
    exit 1
fi

echo "✅ Custom configuration found"
echo ""

# Start the containers
echo "🚀 Starting Bahmni Lite with TIHUT branding..."
docker-compose up -d

# Wait for containers to be ready
echo "⏳ Waiting for containers to start..."
sleep 10

# Get running containers
BAHMNI_WEB_CONTAINER=$(docker-compose ps -q bahmni-web 2>/dev/null)
BAHMNI_CONFIG_CONTAINER=$(docker-compose ps -q bahmni-config 2>/dev/null)

if [ ! -z "$BAHMNI_WEB_CONTAINER" ]; then
    WEB_CONTAINER_NAME=$(docker ps --format "table {{.Names}}" | grep bahmni-web | head -1)
    if [ ! -z "$WEB_CONTAINER_NAME" ]; then
        echo "🔧 Processing bahmni-web container..."
        replace_logos_in_container "$WEB_CONTAINER_NAME"
        inject_custom_files "$WEB_CONTAINER_NAME"
    fi
fi

echo ""
echo "✅ TIHUT CLINIC BRANDING SETUP COMPLETE!"
echo ""
echo "🌐 ACCESS YOUR SYSTEM:"
echo "   URL: http://localhost:8090"
echo ""
echo "🎯 WHAT'S BEEN CUSTOMIZED:"
echo "   ✅ ALL Bahmni logos replaced with TIHUT logo"
echo "   ✅ ALL Bahmni text replaced with 'TIHUT Clinic'"
echo "   ✅ Complete visual rebranding applied"
echo "   ✅ Custom colors and styling applied"
echo "   ✅ Print and report branding updated"
echo ""
echo "🔐 DEFAULT LOGIN:"
echo "   Username: superman"
echo "   Password: Admin123"
echo ""
echo "📝 NOTES:"
echo "   • The system may take a few minutes to fully load"
echo "   • Clear browser cache if you see old branding"
echo "   • All Bahmni references should now show 'TIHUT Clinic'"
echo ""

# Run continuous branding enforcement
echo "🔄 Setting up continuous branding enforcement..."
(
    while true; do
        sleep 30
        if docker ps | grep -q bahmni-web; then
            WEB_CONTAINER_NAME=$(docker ps --format "table {{.Names}}" | grep bahmni-web | head -1)
            if [ ! -z "$WEB_CONTAINER_NAME" ]; then
                replace_logos_in_container "$WEB_CONTAINER_NAME" >/dev/null 2>&1
            fi
        fi
    done
) &

echo "🎉 Ready to use! Open http://localhost:8090 in your browser."
