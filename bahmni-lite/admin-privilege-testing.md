# Bahmni Admin Privilege Testing Guide

## Overview
This guide will help you systematically test different levels of admin privileges in your Bahmni system to understand security boundaries and role-based access controls.

## System Access URLs
- Main Bahmni Dashboard: http://localhost/bahmni/home/
- OpenMRS Admin Interface: http://localhost/openmrs/
- Registration Module: http://localhost/bahmni/registration/
- Clinical Module: http://localhost/bahmni/clinical/
- Admin Module: http://localhost/bahmni/admin/
- Reports: http://localhost/bahmni/reports/
- Implementer Interface: http://localhost/implementer-interface/

## Default User Accounts to Test

### 1. Super Admin (admin/Admin123)
- **Username:** admin
- **Default Password:** Admin123
- **Expected Privileges:** Full system access

### 2. Superman (superman/Admin123)
- **Username:** superman  
- **Default Password:** Admin123
- **Expected Privileges:** Administrative privileges

## Test User Creation Plan

You'll need to create the following test accounts with different privilege levels:

### A. System Administrator
- **Role:** System Administrator
- **Capabilities to Test:**
  - User and role management
  - System configuration
  - Module management
  - Global property management
  - Database access
  - System maintenance

### B. Clinical Provider
- **Role:** Provider
- **Capabilities to Test:**
  - Patient registration
  - Clinical encounters
  - Order entry
  - Clinical forms
  - Patient search and viewing

### C. Data Manager
- **Role:** Data Manager
- **Capabilities to Test:**
  - Report generation
  - Data export/import
  - Patient data editing
  - Registration management
  - Basic admin functions

### D. Receptionist/Registration Clerk
- **Role:** Registration Clerk
- **Capabilities to Test:**
  - Patient registration only
  - Patient search (limited)
  - Appointment scheduling
  - Basic patient demographics

### E. Read-Only User
- **Role:** Privilege Level: Read Only
- **Capabilities to Test:**
  - View patients (no editing)
  - View reports (no generation)
  - View clinical data (no entry)

### F. Lab Technician
- **Role:** Lab Technician
- **Capabilities to Test:**
  - Lab order viewing
  - Lab result entry
  - Lab report generation
  - Patient lookup for lab purposes

## Testing Checklist

### Phase 1: System Administrator Testing

#### User Management
- [ ] Create new users
- [ ] Assign roles and privileges
- [ ] Modify existing user accounts
- [ ] Disable/enable user accounts
- [ ] Reset passwords
- [ ] View user activity logs

#### System Configuration
- [ ] Access Administration module
- [ ] Modify global properties
- [ ] Configure encounter types
- [ ] Set up person attributes
- [ ] Configure visit types
- [ ] Manage concepts and concept sets

#### Module Management
- [ ] View installed modules
- [ ] Start/stop modules
- [ ] Upload new modules
- [ ] Configure module settings
- [ ] View module logs

#### Database Access
- [ ] Access SQL console (if available)
- [ ] Run database queries
- [ ] View system tables
- [ ] Export database content

### Phase 2: Clinical Provider Testing

#### Patient Care
- [ ] Register new patients
- [ ] Search and view existing patients
- [ ] Create clinical encounters
- [ ] Fill clinical forms
- [ ] Order medications
- [ ] Order lab tests
- [ ] View patient history
- [ ] Print patient reports

#### Clinical Documentation
- [ ] Access clinical templates
- [ ] Create clinical notes
- [ ] Upload patient documents
- [ ] View/download patient documents
- [ ] Access patient charts

### Phase 3: Data Manager Testing

#### Reports and Analytics
- [ ] Generate predefined reports
- [ ] Create custom reports
- [ ] Export report data
- [ ] Schedule recurring reports
- [ ] Access patient statistics
- [ ] View system usage reports

#### Data Management
- [ ] Bulk patient data import
- [ ] Patient data export
- [ ] Data validation tools
- [ ] Merge duplicate patients
- [ ] Data backup access

### Phase 4: Limited Role Testing

#### Registration Clerk
- [ ] Patient registration only
- [ ] Basic patient search
- [ ] Appointment scheduling
- [ ] Cannot access clinical data
- [ ] Cannot access admin functions

#### Read-Only User
- [ ] View patients (no editing)
- [ ] View basic reports
- [ ] Cannot create/modify data
- [ ] Cannot access admin functions
- [ ] Cannot generate new reports

#### Lab Technician
- [ ] View lab orders
- [ ] Enter lab results
- [ ] Print lab reports
- [ ] Limited patient data access
- [ ] Cannot access non-lab functions

### Phase 5: Security Boundary Testing

#### Privilege Escalation Attempts
- [ ] Try to access admin functions with provider account
- [ ] Try to modify user privileges with non-admin account
- [ ] Attempt to access restricted URLs directly
- [ ] Test session timeout and re-authentication
- [ ] Try to access database with limited privileges

#### Data Access Control
- [ ] Verify users can only see appropriate patients
- [ ] Test location-based access restrictions
- [ ] Verify role-based menu filtering
- [ ] Test API access with different privileges
- [ ] Verify audit trail logging

## Testing Commands and Scripts

### Check Current User Sessions
```bash
docker exec bahmni-lite-openmrs-1 mysql -u root -p${MYSQL_ROOT_PASSWORD} openmrs -e "SELECT * FROM user_session WHERE date_changed > DATE_SUB(NOW(), INTERVAL 1 DAY);"
```

### View User Roles
```bash
docker exec bahmni-lite-openmrs-1 mysql -u root -p${MYSQL_ROOT_PASSWORD} openmrs -e "SELECT u.username, r.role, ur.user_id FROM users u JOIN user_role ur ON u.user_id = ur.user_id JOIN role r ON ur.role = r.role;"
```

### Check User Privileges
```bash
docker exec bahmni-lite-openmrs-1 mysql -u root -p${MYSQL_ROOT_PASSWORD} openmrs -e "SELECT u.username, p.privilege, rp.role FROM users u JOIN user_role ur ON u.user_id = ur.user_id JOIN role_privilege rp ON ur.role = rp.role JOIN privilege p ON rp.privilege = p.privilege ORDER BY u.username, p.privilege;"
```

## Expected Results Matrix

| Feature/Function | System Admin | Provider | Data Manager | Registration | Read-Only | Lab Tech |
|-----------------|--------------|-----------|--------------|--------------|-----------|----------|
| User Management | ✅ Full | ❌ None | ❌ None | ❌ None | ❌ None | ❌ None |
| Patient Registration | ✅ Full | ✅ Full | ✅ Full | ✅ Full | ❌ None | 🔸 View |
| Clinical Encounters | ✅ Full | ✅ Full | 🔸 Limited | ❌ None | 🔸 View | ❌ None |
| Lab Orders/Results | ✅ Full | ✅ Full | 🔸 Limited | ❌ None | 🔸 View | ✅ Full |
| Reports Generation | ✅ Full | 🔸 Limited | ✅ Full | ❌ None | 🔸 View | 🔸 Limited |
| System Configuration | ✅ Full | ❌ None | ❌ None | ❌ None | ❌ None | ❌ None |
| Database Access | ✅ Full | ❌ None | ❌ None | ❌ None | ❌ None | ❌ None |

Legend:
- ✅ Full Access
- 🔸 Limited Access
- ❌ No Access

## Security Best Practices to Verify

1. **Password Policy Enforcement**
   - Minimum password length
   - Password complexity requirements
   - Password expiration
   - Password history

2. **Session Management**
   - Session timeout configuration
   - Concurrent session limits
   - Secure session storage

3. **Audit Logging**
   - User login/logout events
   - Administrative actions
   - Data modification tracking
   - Failed access attempts

4. **Access Control**
   - Role-based access control (RBAC)
   - Location-based restrictions
   - Time-based access controls
   - API access restrictions

## Testing Documentation Template

For each privilege level tested, document:

```
### [Role Name] Testing Results

**Test Date:** 
**Tester:** 
**User Account:** 

#### Accessible Features:
- [ ] Feature 1
- [ ] Feature 2
- ...

#### Restricted Features:
- [ ] Feature A (Expected)
- [ ] Feature B (Expected)
- ...

#### Security Issues Found:
- Issue 1: Description
- Issue 2: Description

#### Recommendations:
- Recommendation 1
- Recommendation 2
```

## Next Steps

1. Start with the Super Admin account to familiarize yourself with full capabilities
2. Create test accounts for each privilege level
3. Systematically test each role using the checklist
4. Document findings in the results matrix
5. Report any security issues found
6. Create final privilege comparison report

## Useful Database Queries

### List All Users and Their Roles
```sql
SELECT 
    u.username,
    u.system_id,
    p.given_name,
    p.family_name,
    r.role,
    r.description
FROM users u
JOIN person_name p ON u.person_id = p.person_id
JOIN user_role ur ON u.user_id = ur.user_id
JOIN role r ON ur.role = r.role
WHERE u.retired = 0
ORDER BY u.username;
```

### List All Privileges by Role
```sql
SELECT 
    r.role,
    r.description as role_description,
    pr.privilege,
    p.description as privilege_description
FROM role r
JOIN role_privilege rp ON r.role = rp.role
JOIN privilege pr ON rp.privilege = pr.privilege
JOIN privilege p ON pr.privilege = p.privilege
ORDER BY r.role, pr.privilege;
```

### View Recent User Activity
```sql
SELECT 
    u.username,
    ua.activity,
    ua.activity_date_time,
    ua.session_id
FROM user_activity ua
JOIN users u ON ua.user_id = u.user_id
WHERE ua.activity_date_time > DATE_SUB(NOW(), INTERVAL 1 DAY)
ORDER BY ua.activity_date_time DESC;
```
