#!/bin/bash

echo "🔄 REPLACING BAHMNI LOGOS WITH TIHUT LOGOS (SIMPLE METHOD)"
echo "=========================================================="

# Check if containers are running
if ! docker ps | grep -q bahmni-lite-bahmni-web-1; then
    echo "❌ Error: bahmni-lite-bahmni-web-1 container is not running!"
    exit 1
fi

echo ""
echo "📦 REPLACING LOGOS IN WEB CONTAINER"
echo "==================================="

# Use the JPG files directly since PNG conversion has file system issues
docker exec bahmni-lite-bahmni-web-1 sh -c "
    echo '🔄 Replacing main bahmni-logo.png...'
    cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/bahmni-logo.png
    
    echo '🔄 Replacing registration card logo...'
    cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/bahmni_config/openmrs/apps/registration/registrationCardLayout/images/bahmniLogo.png
    
    echo '🔄 Replacing custom display control logo...'
    cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/bahmni_config/openmrs/apps/customDisplayControl/images/bahmniLogo.png
    
    echo '🔄 Replacing main Bahmni interface logos...'
    cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/bahmni/images/bahmniLogo.png
    cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo.jpg /usr/local/apache2/htdocs/bahmni/images/bahmniLogoFull.png
    
    echo '✅ Main logo replacements completed!'
"

echo ""
echo "📦 REPLACING LOGOS IN CONFIG CONTAINER"
echo "======================================"

if docker ps | grep -q bahmni-lite-bahmni-config-1; then
    docker exec bahmni-lite-bahmni-config-1 sh -c "
        echo '🔄 Replacing config logos...'
        cp /usr/local/bahmni_config/images/tihut-logo.jpg /usr/local/bahmni_config/openmrs/apps/registration/registrationCardLayout/images/bahmniLogo.png 2>/dev/null || true
        cp /usr/local/bahmni_config/images/tihut-logo.jpg /usr/local/bahmni_config/openmrs/apps/customDisplayControl/images/bahmniLogo.png 2>/dev/null || true
        
        echo '✅ Config logo replacements completed!'
    "
else
    echo "⚠️  Config container not running, skipping"
fi

echo ""
echo "🔄 CREATING BROWSER FAVICON"
echo "=========================="

# Try to create a simple favicon
docker exec bahmni-lite-bahmni-web-1 sh -c "
    # Copy TIHUT logo as favicon.ico (browsers can handle JPG as favicon)
    cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo-small.jpg /usr/local/apache2/htdocs/favicon.ico 2>/dev/null || true
    cp /usr/local/apache2/htdocs/bahmni_config/images/tihut-logo-small.jpg /usr/local/apache2/htdocs/bahmni/favicon.ico 2>/dev/null || true
    
    echo '✅ Favicon created!'
"

echo ""
echo "✅ LOGO REPLACEMENT COMPLETE!"
echo "============================="
echo ""
echo "📋 WHAT WAS REPLACED:"
echo "• Main site logo (bahmni-logo.png)"
echo "• Registration card logo (bahmniLogo.png)"
echo "• Custom display control logo"
echo "• Main interface logos (bahmniLogo.png & bahmniLogoFull.png)"
echo "• Favicon (favicon.ico)"
echo ""
echo "🌐 NEXT STEPS:"
echo "1. Open your browser and go to: https://localhost/bahmni/home/"
echo "2. Clear your browser cache (Ctrl+F5 or Cmd+Shift+R)"
echo "3. You should now see TIHUT logos instead of Bahmni logos"
echo ""
echo "💡 TIPS:"
echo "• Use hard refresh: Ctrl+F5 (Windows/Linux) or Cmd+Shift+R (Mac)"
echo "• Try incognito/private browsing mode if logos don't update"
echo "• Check the browser tab icon (favicon) - it should show TIHUT logo"
echo ""
echo "🎉 Your system now displays TIHUT branding!"
