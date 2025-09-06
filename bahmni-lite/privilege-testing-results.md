# Bahmni Admin Privilege Testing Results

**Test Date:** September 6, 2025  
**Tester:** System Administrator  
**System:** TIHUT Clinic Bahmni Instance  

## Current User Accounts Available for Testing

Based on database analysis, these accounts are available:

| Username | System ID | Full Name | Primary Role | Status |
|----------|-----------|-----------|--------------|--------|
| admin | - | Super User | Provider + System Developer | Active |
| superman | superman | Super Man | SuperAdmin + Provider + System Developer + Reports-App | Active |
| dr_neha | doctor | Neha Anand | Doctor | Active |
| registration | registration | registration bahmni-user | FrontDesk | Active |
| reports-user | Reports User | Reports User | Reports-App | Active |
| daemon | daemon | - | (No role assigned) | Active |
| Lab Manager | Lab Manager | - | (No role assigned) | Active |
| Lab System | Lab System | - | (No role assigned) | Active |

## Available Roles Analysis

| Role | Description | Privilege Count | Power Level |
|------|-------------|-----------------|-------------|
| SuperAdmin | Full access to Bahmni and OpenMRS | 289 | ⭐⭐⭐⭐⭐ |
| Privilege Level: Full | All API privileges | 318 | ⭐⭐⭐⭐⭐ |
| System Developer | Database structure changes | 0* | ⭐⭐⭐⭐⭐ |
| Doctor | Clinical + Registration operations | 19 | ⭐⭐⭐ |
| FrontDesk | Registration operations | 32 | ⭐⭐ |
| Reports-App | Reports access | 4 | ⭐⭐ |
| Provider | Provider privileges | 0* | ⭐ |

*Note: Some roles have 0 privileges but inherit from parent roles or have special system significance.

## System Access URLs Tested
- ✅ Main Bahmni Dashboard: http://localhost/bahmni/home/
- ✅ OpenMRS Admin Interface: http://localhost/openmrs/
- ✅ Registration Module: http://localhost/bahmni/registration/
- ✅ Clinical Module: http://localhost/bahmni/clinical/
- ✅ Admin Module: http://localhost/bahmni/admin/
- ✅ Reports: http://localhost/bahmni/reports/
- ✅ Implementer Interface: http://localhost/implementer-interface/

---

# Testing Results by Privilege Level

## 1. SuperAdmin Testing (superman account)

**Login:** superman / Admin123  
**Expected Capabilities:** Full system access, user management, system configuration

### ✅ Accessible Features

#### System Administration
- [ ] User management (create, modify, delete users)
- [ ] Role and privilege assignment
- [ ] System configuration access
- [ ] Global property management
- [ ] Module management
- [ ] Database administration access

#### Clinical Operations
- [ ] Patient registration
- [ ] Clinical encounters
- [ ] Clinical forms
- [ ] Lab orders and results
- [ ] Patient document management
- [ ] Appointments management

#### Reports and Analytics
- [ ] Report generation
- [ ] Custom report creation
- [ ] Data export capabilities
- [ ] System usage analytics

### ❌ Expected Restrictions
None - SuperAdmin should have full access

### 🐛 Issues Found
(To be filled during testing)

### 📝 Notes
(To be filled during testing)

---

## 2. System Developer Testing (admin account)

**Login:** admin / Admin123  
**Expected Capabilities:** Development access, full administrative privileges

### ✅ Accessible Features
- [ ] Development tools access
- [ ] Module development capabilities
- [ ] Database schema modifications
- [ ] System maintenance functions

### 🐛 Issues Found
(To be filled during testing)

---

## 3. Doctor Role Testing (dr_neha account)

**Login:** dr_neha / [password unknown - may need reset]  
**Expected Capabilities:** Clinical operations, limited administrative access

### ✅ Accessible Features
- [ ] Patient registration
- [ ] Clinical encounters
- [ ] Medical history access
- [ ] Prescription management
- [ ] Lab test ordering
- [ ] Patient search and viewing

### ❌ Expected Restrictions
- [ ] Cannot create users
- [ ] Cannot access system administration
- [ ] Cannot modify global settings
- [ ] Cannot manage modules

### 🐛 Issues Found
(To be filled during testing)

---

## 4. FrontDesk Role Testing (registration account)

**Login:** registration / [password unknown - may need reset]  
**Expected Capabilities:** Registration and basic patient management

### ✅ Accessible Features
- [ ] Patient registration
- [ ] Patient search (basic)
- [ ] Demographic updates
- [ ] Appointment scheduling
- [ ] Patient identification verification

### ❌ Expected Restrictions
- [ ] Cannot access clinical data
- [ ] Cannot create encounters
- [ ] Cannot view medical records
- [ ] Cannot access admin functions
- [ ] Cannot generate reports

### 🐛 Issues Found
(To be filled during testing)

---

## 5. Reports User Testing (reports-user account)

**Login:** reports-user / [password unknown - may need reset]  
**Expected Capabilities:** Report viewing and generation only

### ✅ Accessible Features
- [ ] View existing reports
- [ ] Generate predefined reports
- [ ] Export report data
- [ ] Basic patient statistics

### ❌ Expected Restrictions
- [ ] Cannot modify patient data
- [ ] Cannot access clinical modules
- [ ] Cannot perform administrative functions
- [ ] Cannot create custom reports

### 🐛 Issues Found
(To be filled during testing)

---

# Security Boundary Testing Results

## Privilege Escalation Tests

### Test 1: Lower privilege user accessing admin URLs
**Test:** Direct URL access to admin functions with non-admin accounts
**Results:**
- [ ] FrontDesk user accessing /openmrs/admin/
- [ ] Doctor user accessing user management
- [ ] Reports user accessing system configuration

### Test 2: API endpoint security
**Test:** Testing API access with different privilege levels
**Results:**
- [ ] User creation API with non-admin account
- [ ] Data modification API with read-only account
- [ ] System configuration API with provider account

### Test 3: Session security
**Test:** Session timeout and concurrent session handling
**Results:**
- [ ] Session timeout enforcement
- [ ] Concurrent session limits
- [ ] Session hijacking protection

## Authentication and Authorization

### Password Policy Testing
- [ ] Minimum password length enforcement
- [ ] Password complexity requirements
- [ ] Password expiration policies
- [ ] Password reuse prevention

### Access Control Testing
- [ ] Role-based menu filtering
- [ ] Location-based access restrictions
- [ ] Time-based access controls
- [ ] IP-based access restrictions

---

# Recommended Test Actions

## Immediate Testing Steps

1. **Start with superman account** (highest privileges) to understand full system capabilities
2. **Test each role systematically** using the checklist above
3. **Document all accessible features** for each role
4. **Test security boundaries** by attempting unauthorized actions
5. **Verify audit logging** for all privileged operations

## Manual Testing Commands

```bash
# Run the testing script
./test-admin-privileges.sh

# Check current users and roles (from database)
docker exec bahmni-lite-openmrsdb-1 mysql -u root -p$(grep MYSQL_ROOT_PASSWORD .env | cut -d'=' -f2) openmrs -e "SELECT u.username, r.role FROM users u JOIN user_role ur ON u.user_id = ur.user_id JOIN role r ON ur.role = r.role WHERE u.retired = 0;"

# Check high-risk privileges
docker exec bahmni-lite-openmrsdb-1 mysql -u root -p$(grep MYSQL_ROOT_PASSWORD .env | cut -d'=' -f2) openmrs -e "SELECT r.role, p.privilege FROM role r JOIN role_privilege rp ON r.role = rp.role JOIN privilege p ON rp.privilege = p.privilege WHERE p.privilege IN ('Manage Users', 'SQL Level Access', 'Manage Global Properties', 'Manage Modules');"
```

## Browser Testing Checklist

For each user account, test these URLs and document access:

1. **http://localhost/bahmni/home/** - Main dashboard
2. **http://localhost/bahmni/registration/** - Patient registration
3. **http://localhost/bahmni/clinical/** - Clinical operations
4. **http://localhost/bahmni/admin/** - Administrative functions
5. **http://localhost/openmrs/admin/** - OpenMRS administration
6. **http://localhost/bahmni/reports/** - Reports module
7. **http://localhost/implementer-interface/** - System configuration

---

# Final Recommendations

## Security Improvements
(To be filled based on findings)

## Role Optimization
(To be filled based on findings)

## Additional Security Measures
(To be filled based on findings)

---

**Testing Status:** 🟡 In Progress  
**Last Updated:** September 6, 2025  
**Next Steps:** Begin systematic testing with superman account
