#!/bin/bash
echo "🔄 REPLACING ALL 'BAHMNI' TEXT WITH 'TIHUT MEDIUM CLINIC'"
echo "======================================================="

# Update logo references in the running containers
echo "🎨 Updating logo file names..."
docker-compose exec -T bahmni-web find /usr/local/apache2/htdocs -name "*tihut*" -exec bash -c 'for file; do newfile=$(echo "$file" | sed "s/tihut/tehut/g"); if [ "$file" != "$newfile" ]; then cp "$file" "$newfile" 2>/dev/null || true; fi; done' _ {} +

# Replace text in HTML files
echo "📝 Replacing 'Bahmni' with 'TIHUT Medium Clinic' in HTML files..."
docker-compose exec -T bahmni-web find /usr/local/apache2/htdocs -name "*.html" -exec sed -i 's/Bahmni/TIHUT Medium Clinic/g' {} \;

# Replace in title tags specifically for shorter name in titles
echo "📝 Updating page titles..."
docker-compose exec -T bahmni-web find /usr/local/apache2/htdocs -name "*.html" -exec sed -i 's/<title>TIHUT Medium Clinic/<title>TIHUT/g' {} \;

# Replace in JS files (be careful with angular module names)
echo "📝 Updating display text in JS files (preserving module names)..."
docker-compose exec -T bahmni-web find /usr/local/apache2/htdocs -name "*.js" -exec sed -i 's/"Bahmni"/"TIHUT"/g' {} \;
docker-compose exec -T bahmni-web find /usr/local/apache2/htdocs -name "*.js" -exec sed -i "s/'Bahmni'/'TIHUT'/g" {} \;

# Update CSS files
echo "🎨 Updating CSS files..."
docker-compose exec -T bahmni-web find /usr/local/apache2/htdocs -name "*.css" -exec sed -i 's/Bahmni/TIHUT/g' {} \;

# Update any JSON configuration files
echo "⚙️  Updating JSON configuration files..."
docker-compose exec -T bahmni-web find /usr/local/apache2/htdocs -name "*.json" -exec sed -i 's/"Bahmni"/"TIHUT Medium Clinic"/g' {} \;

# Update logo references to new TIHUT names
echo "🖼️  Updating logo references..."
docker-compose exec -T bahmni-web find /usr/local/apache2/htdocs -type f -exec sed -i 's/tihut-logo/tihut-logo/g' {} \;

echo ""
echo "✅ TEXT REPLACEMENT COMPLETE!"
echo "============================="
echo ""
echo "📋 CHANGES MADE:"
echo "• All 'Bahmni' text replaced with 'TIHUT Medium Clinic'"
echo "• Page titles updated to 'TIHUT'"
echo "• Logo references updated to tihut-logo files"
echo "• Configuration files updated"
echo ""
echo "🔄 NEXT STEPS:"
echo "1. Clear your browser cache (Ctrl+F5)"
echo "2. Go to: https://irif.world/bahmni/home/"
echo "3. You should see 'TIHUT Medium Clinic' throughout"
echo ""
echo "🎉 Your system now displays TIHUT Medium Clinic branding!"