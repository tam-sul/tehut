#!/bin/bash

echo "🔐 Bahmni User Access Testing Tool"
echo "================================="
echo ""

# Test URLs for different access levels
BAHMNI_HOME="http://localhost/bahmni/home/"
BAHMNI_CLINICAL="http://localhost/bahmni/clinical/"
BAHMNI_REGISTRATION="http://localhost/bahmni/registration/"
BAHMNI_REPORTS="http://localhost/bahmni/reports/"
BAHMNI_ADMIN="http://localhost/bahmni/admin/"
OPENMRS_ADMIN="http://localhost/openmrs/admin/"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to test URL accessibility
test_url_access() {
    local url=$1
    local expected_status=$2
    local description=$3
    
    echo -n "Testing $description: "
    
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null)
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✅ Pass (HTTP $response)${NC}"
        return 0
    else
        echo -e "${RED}❌ Fail (HTTP $response, expected $expected_status)${NC}"
        return 1
    fi
}

echo -e "${BLUE}📋 User Testing Instructions:${NC}"
echo "============================="
echo ""

echo "1. SuperAdmin Test (superman):"
echo "   - Username: superman"
echo "   - Password: Admin123"
echo "   - Login at: $BAHMNI_HOME"
echo "   - Expected: Access to ALL modules"
echo ""

echo "2. Doctor Test (dr_neha):"
echo "   - Username: dr_neha" 
echo "   - Password: doctor123"
echo "   - Expected: Clinical + Registration access"
echo "   - Restricted: Admin functions"
echo ""

echo "3. Registration Test (registration):"
echo "   - Username: registration"
echo "   - Password: password"
echo "   - Expected: Registration access only"
echo "   - Restricted: Clinical, Reports, Admin"
echo ""

echo "4. Reports Test (reports-user):"
echo "   - Username: reports-user"
echo "   - Password: password (try this first)"
echo "   - Expected: Reports access only"
echo "   - Restricted: Clinical, Admin"
echo ""

echo -e "${YELLOW}🔍 Basic System Health Check:${NC}"
echo "============================="

test_url_access "$BAHMNI_HOME" "200" "Bahmni Home Page"
test_url_access "$OPENMRS_ADMIN" "302" "OpenMRS Login Redirect"

echo ""
echo -e "${BLUE}📱 Manual Testing Steps:${NC}"
echo "========================"
echo ""
echo "For each user above:"
echo "1. Open: $BAHMNI_HOME"
echo "2. Login with credentials"
echo "3. Note which modules appear on dashboard"
echo "4. Try accessing restricted URLs:"
echo "   - $OPENMRS_ADMIN (SuperAdmin only)"
echo "   - $BAHMNI_CLINICAL (Doctors + SuperAdmin)"
echo "   - $BAHMNI_REPORTS (Reports users + SuperAdmin)"
echo ""
echo "5. Document any access denied messages"
echo "6. Test core functionality within allowed modules"
echo ""

echo -e "${BLUE}🎯 What to Look For:${NC}"
echo "===================="
echo ""
echo "✅ SuperAdmin (superman):"
echo "   - All modules visible on dashboard"
echo "   - Can access OpenMRS Administration"
echo "   - Can manage users, roles, system settings"
echo ""
echo "✅ Doctor (dr_neha):"
echo "   - Clinical module visible"
echo "   - Can create patient encounters"
echo "   - Cannot access Admin functions"
echo ""
echo "✅ Registration (registration):"
echo "   - Registration module only"
echo "   - Can register/search patients"
echo "   - Cannot access clinical data"
echo ""
echo "✅ Reports (reports-user):"
echo "   - Reports module only"
echo "   - Can generate reports"
echo "   - Cannot access patient details"
echo ""

echo -e "${GREEN}🚀 Ready to test! Open your browser and start with superman user.${NC}"
