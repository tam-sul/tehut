#!/bin/bash

echo "🔄 REBRANDING BAHMNI TO TIHUT"
echo "============================="

# Function to replace text in files within containers
replace_in_container() {
    local container=$1
    local path=$2
    local find_text=$3
    local replace_text=$4
    local description=$5
    
    echo "🔍 $description..."
    docker exec $container find $path -type f \( -name "*.html" -o -name "*.js" -o -name "*.json" -o -name "*.css" \) -exec grep -l "$find_text" {} \; 2>/dev/null | while read file; do
        echo "  📝 Updating: $file"
        docker exec $container sed -i "s/$find_text/$replace_text/g" "$file" 2>/dev/null || echo "    ⚠️  Could not update $file (read-only)"
    done
}

# Replace in main web container
echo ""
echo "📦 UPDATING BAHMNI WEB CONTAINER"
echo "================================"

replace_in_container "bahmni-lite-bahmni-web-1" "/usr/local/apache2/htdocs" "BAHMNI EMR" "TIHUT EMR" "Replacing BAHMNI EMR with TIHUT EMR"
replace_in_container "bahmni-lite-bahmni-web-1" "/usr/local/apache2/htdocs" "BAHMNI" "TIHUT" "Replacing remaining BAHMNI with TIHUT"
replace_in_container "bahmni-lite-bahmni-web-1" "/usr/local/apache2/htdocs" "Bahmni Help" "Tihut Help" "Replacing Bahmni Help with Tihut Help"
replace_in_container "bahmni-lite-bahmni-web-1" "/usr/local/apache2/htdocs" "Bahmni" "Tihut" "Replacing Bahmni with Tihut"

# Replace in configuration container
echo ""
echo "📦 UPDATING BAHMNI CONFIG CONTAINER"
echo "===================================="

replace_in_container "bahmni-lite-bahmni-config-1" "/usr/local/bahmni_config" "BAHMNI EMR" "TIHUT EMR" "Replacing BAHMNI EMR in config"
replace_in_container "bahmni-lite-bahmni-config-1" "/usr/local/bahmni_config" "BAHMNI" "TIHUT" "Replacing BAHMNI in config"
replace_in_container "bahmni-lite-bahmni-config-1" "/usr/local/bahmni_config" "Bahmni" "Tihut" "Replacing Bahmni in config"

# Update specific configuration files
echo ""
echo "📝 UPDATING SPECIFIC CONFIG FILES"
echo "=================================="

# Update whiteLabel.json
echo "  📝 Updating whiteLabel.json..."
docker exec bahmni-lite-bahmni-config-1 sed -i 's/BAHMNI EMR FOR CLINICS/TIHUT EMR FOR CLINICS/g' /usr/local/bahmni_config/openmrs/apps/home/whiteLabel.json
docker exec bahmni-lite-bahmni-config-1 sed -i 's|bahmni.atlassian.net/wiki/display/BAH/Bahmni+Home|tihut.clinic/help|g' /usr/local/bahmni_config/openmrs/apps/home/whiteLabel.json

# Update OpenMRS container (if needed)
echo ""
echo "📦 UPDATING OPENMRS CONTAINER"
echo "=============================="

# Update any OpenMRS files that might have branding
docker exec bahmni-lite-openmrs-1 find /openmrs -name "*.properties" -exec grep -l "Bahmni\|BAHMNI" {} \; 2>/dev/null | while read file; do
    echo "  📝 Updating OpenMRS file: $file"
    docker exec bahmni-lite-openmrs-1 sed -i 's/BAHMNI/TIHUT/g; s/Bahmni/Tihut/g' "$file" 2>/dev/null || echo "    ⚠️  Could not update $file"
done

# Update database entries
echo ""
echo "🗄️  UPDATING DATABASE ENTRIES"
echo "=============================="

echo "  📝 Updating global properties..."
docker exec bahmni-lite-openmrs-1 mysql -h openmrsdb -u openmrs-user -ppassword openmrs -e "
UPDATE global_property 
SET property_value = REPLACE(property_value, 'Bahmni', 'Tihut')
WHERE property_value LIKE '%Bahmni%';

UPDATE global_property 
SET property_value = REPLACE(property_value, 'BAHMNI', 'TIHUT')
WHERE property_value LIKE '%BAHMNI%';

SELECT 'Database branding updated' as result;
" 2>/dev/null || echo "  ⚠️  Could not update database"

echo ""
echo "✅ REBRANDING COMPLETE!"
echo "======================"
echo ""
echo "📋 SUMMARY OF CHANGES:"
echo "- BAHMNI EMR → TIHUT EMR"
echo "- Bahmni Help → Tihut Help" 
echo "- All instances of BAHMNI → TIHUT"
echo "- All instances of Bahmni → Tihut"
echo "- Updated configuration files"
echo "- Updated database entries"
echo ""
echo "🔄 NEXT STEPS:"
echo "1. Clear browser cache completely"
echo "2. Go to: http://localhost/"
echo "3. You should now see 'TIHUT EMR' instead of 'BAHMNI EMR'"
echo "4. Check login page and help links"
echo ""
echo "💡 If some changes don't appear immediately:"
echo "- Restart containers: docker-compose restart"
echo "- Hard refresh browser: Ctrl+F5 or Cmd+Shift+R"
