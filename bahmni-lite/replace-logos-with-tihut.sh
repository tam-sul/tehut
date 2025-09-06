#!/bin/bash

echo "🔄 REPLACING ALL BAHMNI LOGOS WITH TIHUT LOGOS"
echo "=============================================="

# Function to convert and copy TIHUT logo to different formats
prepare_tihut_logos() {
    local container=$1
    echo "🎨 Preparing TIHUT logos in different formats..."
    
    # Copy the main TIHUT logo to different names and formats
    docker exec $container sh -c "
        cd /usr/local/apache2/htdocs/bahmni_config/images/
        
        # Copy TIHUT logo to PNG format (convert using available tools)
        if command -v convert >/dev/null 2>&1; then
            convert tihut-logo.jpg tihut-logo.png 2>/dev/null || cp tihut-logo.jpg tihut-logo.png
        else
            cp tihut-logo.jpg tihut-logo.png
        fi
        
        # Create smaller version
        if command -v convert >/dev/null 2>&1; then
            convert tihut-logo.jpg -resize 200x100 tihut-logo-small.png 2>/dev/null || cp tihut-logo-small.jpg tihut-logo-small.png
        else
            cp tihut-logo-small.jpg tihut-logo-small.png
        fi
        
        # Create favicon if possible
        if command -v convert >/dev/null 2>&1; then
            convert tihut-logo.jpg -resize 32x32 favicon.ico 2>/dev/null || true
        fi
        
        echo '✅ TIHUT logos prepared'
    "
}

# Function to replace logos in container
replace_logos() {
    local container=$1
    echo "🔄 Replacing logos in $container..."
    
    # Replace all main Bahmni logo files
    docker exec $container sh -c "
        # Main bahmni-logo.png in root
        if [ -f /usr/local/apache2/htdocs/bahmni-logo.png ]; then
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.png /usr/local/apache2/htdocs/bahmni-logo.png
            echo '  ✅ Replaced /usr/local/apache2/htdocs/bahmni-logo.png'
        fi
        
        # Registration card layout logo
        if [ -f /usr/local/apache2/htdocs/bahmni_config/openmrs/apps/registration/registrationCardLayout/images/bahmniLogo.png ]; then
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.png /usr/local/apache2/htdocs/bahmni_config/openmrs/apps/registration/registrationCardLayout/images/bahmniLogo.png
            echo '  ✅ Replaced registration card logo'
        fi
        
        # Custom display control logo
        if [ -f /usr/local/apache2/htdocs/bahmni_config/openmrs/apps/customDisplayControl/images/bahmniLogo.png ]; then
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.png /usr/local/apache2/htdocs/bahmni_config/openmrs/apps/customDisplayControl/images/bahmniLogo.png
            echo '  ✅ Replaced custom display control logo'
        fi
        
        # Main Bahmni web interface logos
        if [ -f /usr/local/apache2/htdocs/bahmni/images/bahmniLogo.png ]; then
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.png /usr/local/apache2/htdocs/bahmni/images/bahmniLogo.png
            echo '  ✅ Replaced main Bahmni logo'
        fi
        
        if [ -f /usr/local/apache2/htdocs/bahmni/images/bahmniLogoFull.png ]; then
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.png /usr/local/apache2/htdocs/bahmni/images/bahmniLogoFull.png
            echo '  ✅ Replaced full Bahmni logo'
        fi
        
        # Find and replace any other bahmni logos
        find /usr/local/apache2/htdocs -name '*bahmni*' -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \\) | while read logo_file; do
            if [ -f \"\$logo_file\" ]; then
                cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.png \"\$logo_file\"
                echo \"  ✅ Replaced \$logo_file\"
            fi
        done
        
        # Replace any favicon files
        find /usr/local/apache2/htdocs -name 'favicon.ico' | while read favicon_file; do
            if [ -f /usr/local/apache2/htdocs/bahmni_config/images/favicon.ico ]; then
                cp /usr/local/apache2/htdocs/bahmni_config/images/favicon.ico \"\$favicon_file\"
                echo \"  ✅ Replaced favicon: \$favicon_file\"
            fi
        done
    "
}

# Function to update CSS files to reference TIHUT logos
update_css_logo_references() {
    local container=$1
    echo "🎨 Updating CSS logo references in $container..."
    
    docker exec $container sh -c "
        # Find CSS files that reference bahmni logos
        find /usr/local/apache2/htdocs -name '*.css' -type f | while read css_file; do
            if grep -q -i 'bahmni.*\\.(png\\|jpg\\|jpeg\\|svg)' \"\$css_file\" 2>/dev/null; then
                # Replace bahmni logo references with tihut logo
                sed -i 's|bahmniLogo\\.png|tihut-logo.png|g; s|bahmniLogoFull\\.png|tihut-logo.png|g; s|bahmni-logo\\.png|tihut-logo.png|g' \"\$css_file\"
                echo \"  ✅ Updated CSS: \$css_file\"
            fi
        done
        
        # Update any HTML files that reference logos directly
        find /usr/local/apache2/htdocs -name '*.html' -type f | while read html_file; do
            if grep -q -i 'bahmni.*\\.(png\\|jpg\\|jpeg\\|svg)' \"\$html_file\" 2>/dev/null; then
                sed -i 's|bahmniLogo\\.png|tihut-logo.png|g; s|bahmniLogoFull\\.png|tihut-logo.png|g; s|bahmni-logo\\.png|tihut-logo.png|g' \"\$html_file\"
                echo \"  ✅ Updated HTML: \$html_file\"
            fi
        done
        
        # Update JavaScript files that might reference logos
        find /usr/local/apache2/htdocs -name '*.js' -type f | while read js_file; do
            if grep -q -i 'bahmni.*\\.(png\\|jpg\\|jpeg\\|svg)' \"\$js_file\" 2>/dev/null; then
                sed -i 's|bahmniLogo\\.png|tihut-logo.png|g; s|bahmniLogoFull\\.png|tihut-logo.png|g; s|bahmni-logo\\.png|tihut-logo.png|g' \"\$js_file\"
                echo \"  ✅ Updated JS: \$js_file\"
            fi
        done
    "
}

# Check if containers are running
if ! docker ps | grep -q bahmni-lite-bahmni-web-1; then
    echo "❌ Error: bahmni-lite-bahmni-web-1 container is not running!"
    echo "Please start your Bahmni containers first with: docker-compose -f bahmni-lite/docker-compose.yml up -d"
    exit 1
fi

echo ""
echo "📦 PROCESSING BAHMNI WEB CONTAINER"
echo "=================================="

# Process bahmni-web container
prepare_tihut_logos "bahmni-lite-bahmni-web-1"
replace_logos "bahmni-lite-bahmni-web-1"
update_css_logo_references "bahmni-lite-bahmni-web-1"

echo ""
echo "📦 PROCESSING BAHMNI CONFIG CONTAINER"
echo "====================================="

# Process bahmni-config container if it exists
if docker ps | grep -q bahmni-lite-bahmni-config-1; then
    docker exec bahmni-lite-bahmni-config-1 sh -c "
        # Replace any logos in config files
        find /usr/local/bahmni_config -name '*bahmni*' -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \\) | while read logo_file; do
            if [ -f /usr/local/bahmni_config/images/tihut-logo.jpg ]; then
                cp /usr/local/bahmni_config/images/tihut-logo.jpg \"\$logo_file\"
                echo \"  ✅ Replaced config logo: \$logo_file\"
            fi
        done
    "
    echo "✅ Processed bahmni-config container"
else
    echo "⚠️  bahmni-config container not running, skipping"
fi

echo ""
echo "🔄 CLEARING BROWSER CACHE ITEMS"
echo "==============================="

# Clear any cached logo files
docker exec bahmni-lite-bahmni-web-1 sh -c "
    # Remove any cached files that might contain old logos
    rm -rf /tmp/*bahmni* 2>/dev/null || true
    rm -rf /var/cache/*bahmni* 2>/dev/null || true
    
    echo '✅ Cleared cached files'
"

echo ""
echo "✅ LOGO REPLACEMENT COMPLETE!"
echo "============================="
echo ""
echo "📋 SUMMARY OF CHANGES:"
echo "• All bahmniLogo.png files replaced with TIHUT logo"
echo "• All bahmniLogoFull.png files replaced with TIHUT logo"  
echo "• Root bahmni-logo.png replaced with TIHUT logo"
echo "• Registration card logos replaced"
echo "• Custom display control logos replaced"
echo "• CSS/HTML/JS references updated to point to TIHUT logos"
echo "• Favicon updated (if available)"
echo ""
echo "🔄 NEXT STEPS:"
echo "1. Clear your browser cache completely (Ctrl+F5 or Cmd+Shift+R)"
echo "2. Go to: https://localhost/bahmni/home/"
echo "3. You should now see TIHUT logos throughout the interface"
echo ""
echo "💡 If logos don't update immediately:"
echo "• Hard refresh browser: Ctrl+F5 (Windows/Linux) or Cmd+Shift+R (Mac)"
echo "• Clear browser data/cache completely"
echo "• Try incognito/private browsing mode"
echo ""
echo "🎉 Your Bahmni system now displays TIHUT branding!"
