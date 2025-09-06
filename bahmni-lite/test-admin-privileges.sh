#!/bin/bash

# Bahmni Admin Privilege Testing Script
# This script helps automate some of the privilege testing process

set -e

echo "🏥 Bahmni Admin Privilege Testing Tool"
echo "===================================="

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
OPENMRS_CONTAINER="bahmni-lite-openmrs-1"
DATABASE_NAME="openmrs"

# Function to check if container is running
check_container() {
    if ! docker ps --format "table {{.Names}}" | grep -q "$OPENMRS_CONTAINER"; then
        echo -e "${RED}❌ Error: OpenMRS container is not running${NC}"
        echo "Please start your Bahmni system first with: docker-compose up -d"
        exit 1
    fi
    echo -e "${GREEN}✅ OpenMRS container is running${NC}"
}

# Function to test database connection
test_db_connection() {
    echo -e "${BLUE}🔍 Testing database connection...${NC}"
    # First try with root credentials
    if docker exec "$OPENMRS_CONTAINER" mysql -h openmrsdb -u root --password="$MYSQL_ROOT_PASSWORD" -e "SELECT 1;" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Database connection successful (root)${NC}"
        DB_USER="root"
        DB_PASS="$MYSQL_ROOT_PASSWORD"
        return 0
    # If root fails, try with OpenMRS user credentials
    elif docker exec "$OPENMRS_CONTAINER" mysql -h openmrsdb -u openmrs-user -ppassword -e "SELECT 1;" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Database connection successful (openmrs-user)${NC}"
        echo -e "${YELLOW}⚠️  Note: Root password may be incorrect, using openmrs-user credentials${NC}"
        DB_USER="openmrs-user"
        DB_PASS="password"
        export DB_USER DB_PASS
        return 0
    else
        echo -e "${RED}❌ Database connection failed${NC}"
        echo "Please check your database credentials"
        return 1
    fi
}

# Function to get environment variables
get_env_vars() {
    if [[ -f .env ]]; then
        source .env
    fi
    
    if [[ -z "$MYSQL_ROOT_PASSWORD" ]]; then
        echo -e "${YELLOW}⚠️  MYSQL_ROOT_PASSWORD not found in environment${NC}"
        echo "Trying to extract from .env file..."
        
        if [[ -f .env ]]; then
            MYSQL_ROOT_PASSWORD=$(grep MYSQL_ROOT_PASSWORD .env | cut -d '=' -f2)
        fi
        
        if [[ -z "$MYSQL_ROOT_PASSWORD" ]]; then
            echo -e "${RED}❌ Could not find MYSQL_ROOT_PASSWORD${NC}"
            echo "Please set it manually or check your .env file"
            exit 1
        fi
    fi
    export MYSQL_ROOT_PASSWORD
}

# Function to list existing users and roles
list_users_and_roles() {
    echo -e "${BLUE}👥 Current Users and Roles${NC}"
    echo "=========================="
    
    docker exec "$OPENMRS_CONTAINER" mysql -h openmrsdb -u "$DB_USER" --password="$DB_PASS" "$DATABASE_NAME" -e "
    SELECT 
        u.username,
        u.system_id,
        CONCAT(pn.given_name, ' ', pn.family_name) as full_name,
        r.role,
        u.date_created,
        IF(u.retired = 0, 'Active', 'Retired') as status
    FROM users u
    LEFT JOIN person_name pn ON u.person_id = pn.person_id AND pn.voided = 0
    LEFT JOIN user_role ur ON u.user_id = ur.user_id
    LEFT JOIN role r ON ur.role = r.role
    WHERE u.retired = 0
    ORDER BY u.username, r.role;" 2>/dev/null || {
        echo -e "${RED}❌ Failed to retrieve user information${NC}"
        return 1
    }
}

# Function to list available roles and their privileges
list_roles_and_privileges() {
    echo -e "${BLUE}🔐 Available Roles and Key Privileges${NC}"
    echo "====================================="
    
    docker exec "$OPENMRS_CONTAINER" mysql -h openmrsdb -u "$DB_USER" --password="$DB_PASS" "$DATABASE_NAME" -e "
    SELECT DISTINCT
        r.role,
        r.description,
        COUNT(rp.privilege) as privilege_count
    FROM role r
    LEFT JOIN role_privilege rp ON r.role = rp.role
    GROUP BY r.role, r.description
    ORDER BY r.role;" 2>/dev/null || {
        echo -e "${RED}❌ Failed to retrieve role information${NC}"
        return 1
    }
}

# Function to create test user
create_test_user() {
    local username=$1
    local password=$2
    local role=$3
    local given_name=$4
    local family_name=$5
    
    echo -e "${BLUE}👤 Creating test user: $username with role: $role${NC}"
    
    # This is a simplified approach - in practice, you'd use the OpenMRS web interface
    echo "To create user '$username' with role '$role':"
    echo "1. Go to http://localhost/openmrs/"
    echo "2. Login as admin"
    echo "3. Go to Administration → Manage Users"
    echo "4. Click 'Add User'"
    echo "5. Fill in the details:"
    echo "   - Username: $username"
    echo "   - Password: $password"
    echo "   - Given Name: $given_name"
    echo "   - Family Name: $family_name"
    echo "   - Role: $role"
    echo ""
}

# Function to test web endpoints accessibility
test_web_endpoints() {
    local username=$1
    local password=$2
    
    echo -e "${BLUE}🌐 Testing web endpoint accessibility for user: $username${NC}"
    echo "======================================================="
    
    local endpoints=(
        "http://localhost/bahmni/home/#/dashboard"
        "http://localhost/bahmni/registration/#/"
        "http://localhost/bahmni/clinical/#/"
        "http://localhost/bahmni/admin/#/"
        "http://localhost/openmrs/admin/"
        "http://localhost/bahmni/reports/#/"
    )
    
    for endpoint in "${endpoints[@]}"; do
        echo -e "${YELLOW}Testing: $endpoint${NC}"
        
        # Test if endpoint is accessible (basic check)
        response=$(curl -s -o /dev/null -w "%{http_code}" "$endpoint" || echo "000")
        
        case $response in
            200|302)
                echo -e "${GREEN}✅ Accessible${NC}"
                ;;
            401|403)
                echo -e "${RED}❌ Access Denied${NC}"
                ;;
            000)
                echo -e "${RED}❌ Connection Failed${NC}"
                ;;
            *)
                echo -e "${YELLOW}⚠️  Status: $response${NC}"
                ;;
        esac
    done
}

# Function to generate privilege testing checklist
generate_testing_checklist() {
    local role=$1
    
    echo -e "${BLUE}📋 Generating testing checklist for role: $role${NC}"
    
    case $role in
        "System Administrator"|"admin")
            cat << EOF
## System Administrator Testing Checklist

### User Management
- [ ] Create new users
- [ ] Modify user roles
- [ ] Disable/enable users
- [ ] Reset passwords
- [ ] View user activity

### System Configuration  
- [ ] Access Administration menu
- [ ] Modify global properties
- [ ] Configure system settings
- [ ] Manage modules
- [ ] Database access

### Complete System Access
- [ ] All modules accessible
- [ ] All administrative functions
- [ ] System maintenance tasks
EOF
            ;;
        "Provider"|"Clinician")
            cat << EOF
## Provider/Clinician Testing Checklist

### Patient Care
- [ ] Register new patients
- [ ] Search existing patients
- [ ] Create encounters
- [ ] Fill clinical forms
- [ ] Order medications
- [ ] Order lab tests

### Clinical Documentation
- [ ] Clinical notes
- [ ] Patient documents
- [ ] Patient charts
- [ ] Medical history

### Restrictions (should NOT be able to)
- [ ] Create users
- [ ] Access admin functions  
- [ ] Modify system settings
- [ ] Database access
EOF
            ;;
        "Registration Clerk")
            cat << EOF
## Registration Clerk Testing Checklist

### Registration Functions
- [ ] Patient registration
- [ ] Basic patient search
- [ ] Demographic updates
- [ ] Appointment scheduling

### Restrictions (should NOT be able to)
- [ ] Access clinical data
- [ ] Create encounters
- [ ] View medical records
- [ ] Admin functions
- [ ] Generate reports
EOF
            ;;
        *)
            echo "Generate custom checklist for role: $role"
            ;;
    esac
}

# Function to run SQL queries for testing
run_privilege_queries() {
    echo -e "${BLUE}🔍 Running privilege analysis queries${NC}"
    echo "===================================="
    
    echo -e "${YELLOW}Users with Administrative Privileges:${NC}"
    docker exec "$OPENMRS_CONTAINER" mysql -h openmrsdb -u "$DB_USER" --password="$DB_PASS" "$DATABASE_NAME" -e "
    SELECT DISTINCT u.username, r.role
    FROM users u
    JOIN user_role ur ON u.user_id = ur.user_id  
    JOIN role r ON ur.role = r.role
    WHERE r.role IN ('System Administrator', 'Provider', 'Anonymous', 'Authenticated')
    AND u.retired = 0
    ORDER BY r.role, u.username;" 2>/dev/null
    
    echo ""
    echo -e "${YELLOW}High-Risk Privileges Assignment:${NC}"
    docker exec "$OPENMRS_CONTAINER" mysql -h openmrsdb -u "$DB_USER" --password="$DB_PASS" "$DATABASE_NAME" -e "
    SELECT r.role, p.privilege
    FROM role r
    JOIN role_privilege rp ON r.role = rp.role
    JOIN privilege p ON rp.privilege = p.privilege  
    WHERE p.privilege IN (
        'Manage Users',
        'SQL Level Access', 
        'Manage Global Properties',
        'Manage Modules',
        'View Administration Functions'
    )
    ORDER BY r.role, p.privilege;" 2>/dev/null
}

# Main menu function
show_menu() {
    echo ""
    echo -e "${BLUE}📋 Select Testing Action:${NC}"
    echo "1. List existing users and roles"
    echo "2. List available roles and privileges"
    echo "3. Create test user (manual instructions)"
    echo "4. Test web endpoint accessibility"
    echo "5. Generate role-specific testing checklist"
    echo "6. Run privilege analysis queries"
    echo "7. Open Bahmni in browser"
    echo "8. View testing guide"
    echo "9. Exit"
    echo ""
    echo -n "Enter your choice (1-9): "
}

# Main script execution
main() {
    check_container
    get_env_vars
    
    if ! test_db_connection; then
        echo -e "${RED}❌ Cannot proceed without database access${NC}"
        exit 1
    fi
    
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1)
                echo ""
                list_users_and_roles
                ;;
            2)
                echo ""
                list_roles_and_privileges
                ;;
            3)
                echo ""
                echo -n "Enter username: "
                read -r username
                echo -n "Enter password: "
                read -rs password
                echo ""
                echo -n "Enter role: "
                read -r role  
                echo -n "Enter given name: "
                read -r given_name
                echo -n "Enter family name: "
                read -r family_name
                create_test_user "$username" "$password" "$role" "$given_name" "$family_name"
                ;;
            4)
                echo ""
                echo -n "Enter username to test: "
                read -r test_username
                echo -n "Enter password: "
                read -rs test_password
                echo ""
                test_web_endpoints "$test_username" "$test_password"
                ;;
            5)
                echo ""
                echo -n "Enter role name: "
                read -r role_name
                generate_testing_checklist "$role_name"
                ;;
            6)
                echo ""
                run_privilege_queries
                ;;
            7)
                echo -e "${BLUE}🌐 Opening Bahmni in browser...${NC}"
                if command -v open &> /dev/null; then
                    open http://localhost/bahmni/home/
                elif command -v xdg-open &> /dev/null; then
                    xdg-open http://localhost/bahmni/home/
                else
                    echo "Please open http://localhost/bahmni/home/ in your browser"
                fi
                ;;
            8)
                echo -e "${BLUE}📖 Opening testing guide...${NC}"
                if [[ -f "admin-privilege-testing.md" ]]; then
                    if command -v open &> /dev/null; then
                        open admin-privilege-testing.md
                    else
                        echo "Please open admin-privilege-testing.md to view the complete guide"
                    fi
                else
                    echo "Testing guide not found. Please ensure admin-privilege-testing.md exists."
                fi
                ;;
            9)
                echo -e "${GREEN}👋 Happy testing!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid choice. Please enter 1-9.${NC}"
                ;;
        esac
        
        echo ""
        echo -n "Press Enter to continue..."
        read -r
        clear
    done
}

# Script entry point
clear
main
