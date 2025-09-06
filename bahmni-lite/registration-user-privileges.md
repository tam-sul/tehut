# Registration User (FrontDesk) - Enhanced OPD Workflow Privileges

## User Details
- **Username**: `registration`
- **Password**: `password`
- **Role**: `FrontDesk`
- **Total Privileges**: 43

## ✅ What Registration Staff CAN NOW DO:

### Patient Management
- Register new patients (`Add Patients`)
- Edit patient demographics (`Edit Patients`)
- View patient information (`View Patients`)
- Manage patient identifiers (`Add/Edit Patient Identifiers`)

### OPD Visit Workflow
- **Create OPD visits** (`Add Visits`)
- **Schedule appointments** (`Manage Appointments`)
- **Manage appointment scheduling** (`app:appointments:manageAppointmentsTab`)
- **Reset appointment status** (`Reset Appointment Status`)
- **Close patient visits** (`app:common:closeVisit`)
- **Invite providers to appointments** (`Appointments: Invite Providers`)

### Patient Programs & Queuing
- **Add patients to programs** (`Add Patient Programs`)
- **Edit patient programs** (`Edit Patient Programs`)
- **Queue patients for doctors** (via visit/program management)

### Basic Clinical Workflow
- **Create encounters for visits** (`Add Encounters`)
- **Add basic observations** (`Add Observations`)
- **Edit encounters** (`Edit Encounters`)

### Administrative Functions
- **Access appointments module** (`app:appointments`)
- **Access registration module** (`app:registration`)
- **Access patient documents** (`app:patient-documents`)
- **Upload documents** (`app:document-upload`)
- **Send SMS notifications** (`Send SMS`)

## ❌ What Registration Staff CANNOT DO:

### Clinical Restrictions
- Cannot access detailed medical records
- Cannot view sensitive clinical observations
- Cannot prescribe medications
- Cannot access lab results (detailed)
- Cannot make medical diagnoses

### Administrative Restrictions
- Cannot create users (`Manage Users` - not granted)
- Cannot access OpenMRS Administration
- Cannot modify system settings
- Cannot manage roles and privileges

## 🔄 Typical OPD Workflow Process:

### Registration Staff Process:
1. **Patient arrives** → Register or search for patient
2. **Create OPD visit** → Use "Add Visits" privilege
3. **Schedule appointment** → Use appointments module
4. **Queue for doctor** → Assign to appropriate provider
5. **Create encounter** → Basic encounter creation for visit
6. **Send to clinical queue** → Doctor takes over from here

### Handoff to Doctor:
- Doctor logs in with clinical privileges
- Sees patient in queue from registration
- Conducts consultation with full clinical access
- Registration staff can see appointment status but not clinical details

## 🧪 Testing Instructions:

### Test OPD Workflow:
1. Login as `registration` / `password`
2. Go to Registration module
3. Register a test patient
4. Create an appointment/visit for the patient
5. Schedule with a provider (doctor)
6. Verify patient appears in clinical queue

### Test Restrictions:
1. Try accessing http://localhost/openmrs/admin/ (should be blocked)
2. Try accessing detailed clinical data (should be limited)
3. Verify cannot create users or modify system settings

## 📝 Security Notes:
- Registration staff can create basic encounters but cannot access sensitive clinical data
- They can manage appointments but cannot see detailed consultation notes
- Perfect balance between workflow efficiency and data security
