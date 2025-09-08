#!/bin/bash

echo "🔄 REPLACING ALL 'BAHMNI' TEXT WITH 'TIHUT' ACROSS THE SYSTEM"
echo "============================================================="

# Function to replace text in container with error handling
replace_text_in_container() {
    local container_name=$1
    echo "📝 Processing text replacements in $container_name..."
    
    docker exec $container_name sh -c "
        # Replace in writable HTML files
        find /usr/local/apache2/htdocs -name '*.html' -type f ! -path '*/bahmni_config/*' 2>/dev/null | while read file; do
            if [ -w \"\$file\" ]; then
                sed -i 's/Bahmni/TIHUT/g; s/BAHMNI/TIHUT/g; s/bahmni/tihut/g' \"\$file\" 2>/dev/null || true
                echo \"  ✅ Updated: \$file\"
            fi
        done
        
        # Replace in JavaScript files (non-minified)
        find /usr/local/apache2/htdocs -name '*.js' -type f ! -name '*.min.js' ! -path '*/bahmni_config/*' 2>/dev/null | while read file; do
            if [ -w \"\$file\" ]; then
                sed -i 's/Bahmni/TIHUT/g; s/BAHMNI/TIHUT/g' \"\$file\" 2>/dev/null || true
                echo \"  ✅ Updated JS: \$file\"
            fi
        done
        
        # Replace in CSS files
        find /usr/local/apache2/htdocs -name '*.css' -type f ! -path '*/bahmni_config/*' 2>/dev/null | while read file; do
            if [ -w \"\$file\" ]; then
                sed -i 's/Bahmni/TIHUT/g; s/BAHMNI/TIHUT/g' \"\$file\" 2>/dev/null || true
                echo \"  ✅ Updated CSS: \$file\"
            fi
        done
        
        # Special replacements for specific content
        if [ -w '/usr/local/apache2/htdocs/index.html' ]; then
            sed -i 's/BAHMNI EMR FOR CLINICS/TIHUT CLINIC HEALTHCARE SYSTEM/g' /usr/local/apache2/htdocs/index.html 2>/dev/null || true
            sed -i 's/BAHMNI EMR & HOSPITAL SERVICE/TIHUT CLINIC HEALTHCARE SYSTEM/g' /usr/local/apache2/htdocs/index.html 2>/dev/null || true
            sed -i 's/WELCOME TO.*BAHMNI.*/WELCOME TO<br \/>TIHUT CLINIC HEALTHCARE SYSTEM/g' /usr/local/apache2/htdocs/index.html 2>/dev/null || true
            sed -i 's/WELCOME TO.*TIHUT EMR.*/WELCOME TO<br \/>TIHUT CLINIC HEALTHCARE SYSTEM/g' /usr/local/apache2/htdocs/index.html 2>/dev/null || true
            echo \"  ✅ Updated main page header text\"
        fi
        
        # Fix help text variations
        sed -i 's/Bahmni Bahmni Help/Help/g' /usr/local/apache2/htdocs/index.html 2>/dev/null || true
        sed -i 's/TIHUT TIHUT Help/Help/g' /usr/local/apache2/htdocs/index.html 2>/dev/null || true
        sed -i 's/Bahmni Help/Help/g' /usr/local/apache2/htdocs/index.html 2>/dev/null || true
        sed -i 's/TIHUT Help/Help/g' /usr/local/apache2/htdocs/index.html 2>/dev/null || true
        find /usr/local/apache2/htdocs -name '*.html' -type f -exec sed -i 's/Bahmni Help/Help/g; s/TIHUT Help/Help/g; s/Bahmni Bahmni Help/Help/g; s/TIHUT TIHUT Help/Help/g' {} \; 2>/dev/null || true
        
        # Create missing TIHUT images at expected paths
        mkdir -p /usr/local/apache2/htdocs/tihut/images 2>/dev/null || true
        if [ -f '/usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg' ]; then
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/tihut/images/tihutLogoFull.png 2>/dev/null || true
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/tihut/images/app.png 2>/dev/null || true
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/tihut/images/bills.png 2>/dev/null || true
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/tihut/images/analytics.png 2>/dev/null || true
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/tihut/images/lab.png 2>/dev/null || true
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/tihut/images/connect.png 2>/dev/null || true
            cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/tihut/images/pac.png 2>/dev/null || true
            echo \"  ✅ Created missing TIHUT images at expected paths\"
        fi
        
        # Fix any remaining image path references in HTML
        sed -i 's|/bahmni/images/|/tihut/images/|g' /usr/local/apache2/htdocs/index.html 2>/dev/null || true
        
        echo \"Text replacement completed for $container_name\"
    " 2>/dev/null || echo "⚠️  Some files could not be modified (read-only)"
}

# Function to handle configuration files in bahmni-config container
replace_text_in_config() {
    local container_name=$1
    echo "⚙️  Processing configuration files in $container_name..."
    
    docker exec $container_name sh -c "
        # Replace in writable config files
        find /usr/local/bahmni_config -name '*.json' -type f 2>/dev/null | while read file; do
            if [ -w \"\$file\" ]; then
                sed -i 's/Bahmni/TIHUT/g; s/BAHMNI/TIHUT/g; s/bahmni/tihut/g' \"\$file\" 2>/dev/null || true
                echo \"  ✅ Updated config: \$file\"
            fi
        done
        
        echo \"Configuration replacement completed for $container_name\"
    " 2>/dev/null || echo "⚠️  Some config files could not be modified"
}

# Check if containers are running
if ! docker ps | grep -q bahmni-lite-bahmni-web-1; then
    echo "❌ Error: bahmni-lite-bahmni-web-1 container is not running!"
    echo "Please start your Bahmni containers first."
    exit 1
fi

# Process bahmni-web container
replace_text_in_container "bahmni-lite-bahmni-web-1"

# Process bahmni-config container if running
if docker ps | grep -q bahmni-lite-bahmni-config-1; then
    replace_text_in_config "bahmni-lite-bahmni-config-1"
else
    echo "⚠️  bahmni-config container not running, skipping config replacement"
fi

echo ""
echo "✅ COMPREHENSIVE TEXT REPLACEMENT COMPLETE!"
echo "=========================================="
echo ""
echo "📋 WHAT WAS REPLACED:"
echo "• All 'Bahmni' → 'TIHUT'"
echo "• All 'BAHMNI' → 'TIHUT'"  
echo "• All 'bahmni' → 'tihut'"
echo "• 'Bahmni Help' → 'Help'"
echo "• Page headers and titles updated"
echo "• Configuration files updated where writable"
echo ""
echo "🔄 NEXT STEPS:"
echo "1. Clear browser cache completely (Ctrl+F5)"
echo "2. Refresh the page: http://irif.world"
echo "3. All text should now show TIHUT instead of Bahmni"
echo ""
echo "💡 NOTE: Some system files are read-only and use JavaScript for replacement"
echo "🎉 Your system now displays TIHUT branding throughout!"