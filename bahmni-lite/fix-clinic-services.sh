#!/bin/bash

echo "🔧 FIXING CLINIC SERVICES ISSUES"
echo "================================="

# Wait for system to be ready
echo "⏳ Waiting for system to be fully ready..."
sleep 10

# Check and fix common issues
echo "🔍 Checking for common issues..."

# 1. Restart specific services that might cause issues
echo "🔄 Restarting key services..."
docker-compose restart bahmni-web openmrs

echo "⏳ Waiting for services to restart..."
sleep 20

# 2. Check database connectivity
echo "📊 Verifying database connectivity..."
docker exec bahmni-lite-openmrsdb-1 mysql -u openmrs-user -ppassword -D openmrs -e "SELECT COUNT(*) FROM users;" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Database connection: OK"
else
    echo "❌ Database connection: FAILED"
    exit 1
fi

# 3. Check if OpenMRS modules are loaded
echo "🔍 Checking OpenMRS module status..."
timeout 10 curl -s http://irif.world/openmrs/ > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ OpenMRS web access: OK"
else
    echo "❌ OpenMRS web access: FAILED"
fi

# 4. Test REST API
echo "🔍 Testing REST API..."
timeout 10 curl -s "http://irif.world/openmrs/ws/rest/v1/session" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ REST API: Responding"
else
    echo "❌ REST API: Not responding properly"
fi

# 5. Clear any cached data and restart web services
echo "🧹 Clearing cache and restarting web services..."
docker exec bahmni-lite-bahmni-web-1 rm -rf /tmp/* 2>/dev/null || true

echo ""
echo "✅ TROUBLESHOOTING COMPLETE!"
echo ""
echo "🌐 Now try accessing:"
echo "   • Main URL: http://irif.world"
echo "   • Alt URL:  http://irif.world:8090"
echo ""
echo "🔐 Login with:"
echo "   • Username: superman"
echo "   • Password: Admin123"
echo ""
echo "💡 If still having issues, try:"
echo "   • Use incognito/private browsing"
echo "   • Try username 'registration' instead of 'superman'"
echo "   • Access http://irif.world/openmrs directly"
echo ""
echo "📞 If problem persists, the issue might be:"
echo "   • Missing reference data in the database"
echo "   • Specific module configuration issue"
echo "   • Custom configuration conflict"
