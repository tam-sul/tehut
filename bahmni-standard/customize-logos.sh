#!/bin/bash

# Bahmni Logo Customization Setup Script
# This script helps you replace Bahmni logos with your clinic's branding

set -e

echo "🏥 Bahmni Logo Customization Setup"
echo "=================================="

# Check if custom-config directory exists
if [ ! -d "custom-config" ]; then
    echo "❌ Error: custom-config directory not found!"
    echo "Please make sure you're running this script from the bahmni-standard directory."
    exit 1
fi

echo "✅ Custom configuration directory found"

# Function to check if a file exists and get its dimensions
check_image() {
    local file_path=$1
    local recommended_size=$2
    
    if [ -f "$file_path" ]; then
        echo "✅ Found: $file_path"
        # Try to get image dimensions using file command
        if command -v identify >/dev/null 2>&1; then
            dimensions=$(identify -format "%wx%h" "$file_path" 2>/dev/null || echo "unknown")
            echo "   📏 Dimensions: $dimensions (recommended: $recommended_size)"
        fi
        return 0
    else
        echo "❌ Missing: $file_path (recommended: $recommended_size)"
        return 1
    fi
}

echo ""
echo "🔍 Checking for logo files..."
echo "-----------------------------"

# Check for required logo files
main_logo_exists=false
small_logo_exists=false

if check_image "custom-config/images/clinic-logo.png" "200x60px"; then
    main_logo_exists=true
fi

if check_image "custom-config/images/clinic-logo-small.png" "100x30px"; then
    small_logo_exists=true
fi

check_image "custom-config/images/clinic-favicon.ico" "32x32px"

echo ""
echo "📝 Configuration Status:"
echo "------------------------"

if [ -f "custom-config/bahmni_config/custom-branding.css" ]; then
    echo "✅ Custom CSS file found"
else
    echo "❌ Custom CSS file missing"
fi

if [ -f "custom-config/openmrs/apps.json" ]; then
    echo "✅ OpenMRS configuration found"
else
    echo "❌ OpenMRS configuration missing"
fi

if [ -f "docker-compose.override.yml" ]; then
    echo "✅ Docker compose override found"
else
    echo "❌ Docker compose override missing"
fi

echo ""
echo "🚀 Next Steps:"
echo "-------------"

if [ "$main_logo_exists" = false ] || [ "$small_logo_exists" = false ]; then
    echo "1. Add your logo files to custom-config/images/:"
    echo "   • clinic-logo.png (main logo, ~200x60px)"
    echo "   • clinic-logo-small.png (small logo, ~100x30px)"
    echo "   • clinic-favicon.ico (favicon, 32x32px)"
    echo ""
fi

echo "2. Edit custom-config/bahmni_config/custom-branding.css:"
echo "   • Update 'Your Clinic Name' with your actual clinic name"
echo "   • Modify colors to match your branding"
echo ""

echo "3. Update custom-config/openmrs/apps.json:"
echo "   • Change 'Your Clinic Name' to your clinic's name"
echo ""

echo "4. Apply the customizations:"
echo "   docker-compose down"
echo "   docker-compose up -d"
echo ""

echo "5. Access your customized Bahmni at:"
echo "   http://localhost (or your configured domain)"
echo ""

echo "📋 Troubleshooting:"
echo "------------------"
echo "• If logos don't appear, check file permissions: chmod 644 custom-config/images/*"
echo "• If changes don't apply, try: docker-compose down && docker system prune && docker-compose up -d"
echo "• For browser cache issues, do a hard refresh: Ctrl+F5 (Windows/Linux) or Cmd+Shift+R (Mac)"
echo ""

echo "✨ Customization setup complete! Follow the steps above to apply your branding."
