# Small Clinic Access Levels - Real World Implementation

## Typical 20-50 Bed Clinic Staff Structure

### 1. **Clinic Manager/IT Admin** (1 person)
- **OpenMRS Role**: `SuperAdmin` + `System Developer`
- **Username Example**: `admin` or `superman`
- **Can Access**:
  - ALL OpenMRS Administration functions
  - User management (create/modify/delete users)
  - System configuration
  - Module management
  - Database backups
- **Bahmni URLs**: 
  - http://localhost/openmrs/admin/ ✅
  - All Bahmni modules ✅

### 2. **Head Nurse/Clinical Supervisor** (1-2 people)
- **OpenMRS Role**: `Provider` + `Clinical-App` + Limited Admin
- **Can Access**:
  - Full clinical operations
  - Clinical report generation
  - Staff scheduling
  - Clinical workflow configuration
- **Cannot Access**: User creation, system settings
- **Bahmni URLs**:
  - http://localhost/bahmni/clinical/ ✅
  - http://localhost/bahmni/reports/ ✅
  - http://localhost/openmrs/admin/ ❌

### 3. **Doctors** (2-5 people)
- **OpenMRS Role**: `Provider` + `Doctor`
- **Can Access**:
  - Patient encounters
  - Medical records
  - Prescriptions
  - Lab orders
  - Patient documents
- **Cannot Access**: Admin functions, user management
- **Example User**: `dr_neha` (password: `doctor123`)

### 4. **Nurses** (3-8 people)  
- **OpenMRS Role**: `Provider` + `Clinical-App` (limited)
- **Can Access**:
  - Patient vital signs
  - Basic clinical documentation
  - Medication administration
- **Cannot Access**: Final diagnosis, system admin

### 5. **Front Desk/Registration** (2-3 people)
- **OpenMRS Role**: `FrontDesk` + `Registration-App`
- **Can Access**:
  - Patient registration
  - Appointment scheduling
  - Basic patient search
  - Demographic updates
- **Cannot Access**: Clinical data, medical records
- **Example User**: `registration` (password: `password`)

### 6. **Lab Technician** (1-2 people)
- **OpenMRS Role**: `Lab` + `OrderFulfillment-App`
- **Can Access**:
  - Lab orders
  - Test results entry
  - Lab reports
- **Cannot Access**: Clinical notes, prescriptions

### 7. **Pharmacist** (1-2 people)
- **OpenMRS Role**: `Provider` + Pharmacy privileges
- **Can Access**:
  - Medication orders
  - Drug dispensing
  - Inventory management
- **Cannot Access**: Lab results, clinical notes

### 8. **Data Entry/Reports Clerk** (1 person)
- **OpenMRS Role**: `Reports-App`
- **Can Access**:
  - Generate statistical reports
  - Data export
  - Analytics dashboards
- **Cannot Access**: Individual patient records, admin functions
- **Example User**: `reports-user`

## Access Testing Matrix

| Role | Registration | Clinical | Reports | Admin | User Mgmt |
|------|-------------|----------|---------|-------|-----------|
| Clinic Manager | ✅ | ✅ | ✅ | ✅ | ✅ |
| Head Nurse | ✅ | ✅ | ✅ | ⚠️ | ❌ |
| Doctor | ✅ | ✅ | ⚠️ | ❌ | ❌ |
| Nurse | ✅ | ⚠️ | ❌ | ❌ | ❌ |
| Front Desk | ✅ | ❌ | ❌ | ❌ | ❌ |
| Lab Tech | ⚠️ | ⚠️ | ⚠️ | ❌ | ❌ |
| Pharmacist | ⚠️ | ⚠️ | ⚠️ | ❌ | ❌ |
| Reports Clerk | ❌ | ❌ | ✅ | ❌ | ❌ |

Legend: ✅ Full Access | ⚠️ Limited Access | ❌ No Access

## Critical Security Principle

**Only 1-2 people should have SuperAdmin access** - typically:
1. Clinic Manager/Owner
2. IT Support person (if separate)

Everyone else gets **role-based limited access** to prevent:
- Accidental system changes
- Data breaches
- Compliance violations
