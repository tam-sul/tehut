# Registration User OPD Workflow Testing Guide

## Prerequisites
- Bahmni system running at http://localhost
- Login as: `registration` / `password`

## Test 1: Dashboard Module Access
### Expected Results:
- ✅ Registration module visible
- ✅ Appointments module visible (NEW!)
- ✅ Document Upload visible
- ❌ Clinical module NOT visible
- ❌ Reports module NOT visible
- ❌ Admin module NOT visible

## Test 2: Patient Registration
### Steps:
1. Click "Registration" module
2. Search for existing patient (test search functionality)
3. Click "Register New Patient"
4. Fill mandatory fields:
   - Given Name: Test
   - Family Name: Patient
   - Gender: Male/Female
   - Age: 25
5. Click "Save"

### Expected Results:
- ✅ Patient should be created successfully
- ✅ Patient ID should be generated
- ✅ Should see patient summary

## Test 3: Appointment Scheduling (NEW FUNCTIONALITY)
### Steps:
1. From Registration module, select the patient you created
2. Look for "Start OPD Visit" or "Schedule Appointment" button
3. OR go to Appointments module directly
4. Create new appointment:
   - Patient: Select your test patient
   - Provider: Select dr_neha or any doctor
   - Date: Today's date
   - Time: Any available slot
   - Service Type: OPD/Consultation
5. Save appointment

### Expected Results:
- ✅ Appointment should be created
- ✅ Should see appointment in schedule
- ✅ Status should be "Scheduled"

## Test 4: Visit Creation
### Steps:
1. After creating appointment, look for "Start Visit" option
2. Click "Start Visit" for the patient
3. Visit should be created with:
   - Visit Type: OPD
   - Visit Status: Active
   - Start Date/Time: Current

### Expected Results:
- ✅ Visit should be created successfully
- ✅ Patient should appear in "Active Visits"
- ✅ Visit should be ready for doctor consultation

## Test 5: Access Restrictions (Security Test)
### Steps:
1. Try to access: http://localhost/openmrs/admin/
2. Try to access: http://localhost/bahmni/clinical/ (if visible)
3. In patient record, try to view detailed clinical data

### Expected Results:
- ❌ OpenMRS Admin should be blocked (login redirect or access denied)
- ❌ Should not see sensitive clinical information
- ❌ Should not be able to modify system settings

## Test 6: Complete OPD Workflow
### Registration User Part:
1. Register patient ✅
2. Create appointment ✅
3. Start visit ✅
4. Patient ready for doctor ✅

### Doctor User Part (Switch to dr_neha):
1. Logout from registration
2. Login as: dr_neha / doctor123
3. Go to Clinical module
4. Should see the patient in queue/active visits
5. Conduct consultation

## Troubleshooting

### If Appointments Module Not Visible:
- Logout and login again
- Check if user has `app:appointments` privilege
- Clear browser cache

### If Cannot Create Appointments:
- Check if `Manage Appointments` privilege exists
- Verify `app:appointments:manageAppointmentsTab` privilege

### If Visit Creation Fails:
- Check `Add Visits` privilege
- Verify location is properly configured

## Success Criteria
✅ Registration user can complete entire front desk workflow
✅ Can hand off patients to doctors seamlessly
✅ Cannot access sensitive clinical/admin functions
✅ Perfect balance of privileges for OPD operations
