-- Create different admin level users for testing

-- 1. Clinical Admin - manages clinical operations
INSERT INTO person (gender, birthdate, birthdate_estimated, dead, date_created, creator, uuid) 
VALUES ('M', '1980-01-01', 0, 0, NOW(), 1, UUID());

SET @clinical_admin_person_id = LAST_INSERT_ID();

INSERT INTO person_name (preferred, person_id, given_name, family_name, date_created, creator, uuid)
VALUES (1, @clinical_admin_person_id, 'Clinical', 'Admin', NOW(), 1, UUID());

INSERT INTO users (system_id, username, password, salt, secret_question, secret_answer, creator, date_created, person_id, retired, uuid)
VALUES ('clinical_admin', 'clinical_admin', 
        SHA2(CONCAT('admin123', '1c9d7e94aeeb7a2459ef45ed200b2944582e0e7088d75f9b57a3644861ea766c20a269b3fe2eadaff1bc445ecfbd9bd3c0c550dfd813de48d39423cd3d1a8b10'), 512),
        '1c9d7e94aeeb7a2459ef45ed200b2944582e0e7088d75f9b57a3644861ea766c20a269b3fe2eadaff1bc445ecfbd9bd3c0c550dfd813de48d39423cd3d1a8b10',
        NULL, NULL, 1, NOW(), @clinical_admin_person_id, 0, UUID());

SET @clinical_admin_user_id = LAST_INSERT_ID();

-- Assign roles to Clinical Admin
INSERT INTO user_role (user_id, role) VALUES 
(@clinical_admin_user_id, 'Clinical-App'),
(@clinical_admin_user_id, 'Registration-App'),
(@clinical_admin_user_id, 'PatientDocuments-App');

-- 2. Registration Admin - manages patient registration
INSERT INTO person (gender, birthdate, birthdate_estimated, dead, date_created, creator, uuid) 
VALUES ('F', '1985-01-01', 0, 0, NOW(), 1, UUID());

SET @reg_admin_person_id = LAST_INSERT_ID();

INSERT INTO person_name (preferred, person_id, given_name, family_name, date_created, creator, uuid)
VALUES (1, @reg_admin_person_id, 'Registration', 'Admin', NOW(), 1, UUID());

INSERT INTO users (system_id, username, password, salt, secret_question, secret_answer, creator, date_created, person_id, retired, uuid)
VALUES ('reg_admin', 'reg_admin', 
        SHA2(CONCAT('admin123', '1c9d7e94aeeb7a2459ef45ed200b2944582e0e7088d75f9b57a3644861ea766c20a269b3fe2eadaff1bc445ecfbd9bd3c0c550dfd813de48d39423cd3d1a8b10'), 512),
        '1c9d7e94aeeb7a2459ef45ed200b2944582e0e7088d75f9b57a3644861ea766c20a269b3fe2eadaff1bc445ecfbd9bd3c0c550dfd813de48d39423cd3d1a8b10',
        NULL, NULL, 1, NOW(), @reg_admin_person_id, 0, UUID());

SET @reg_admin_user_id = LAST_INSERT_ID();

-- Assign roles to Registration Admin
INSERT INTO user_role (user_id, role) VALUES 
(@reg_admin_user_id, 'Registration-App');

-- 3. Reports Admin - manages reports only
INSERT INTO person (gender, birthdate, birthdate_estimated, dead, date_created, creator, uuid) 
VALUES ('M', '1975-01-01', 0, 0, NOW(), 1, UUID());

SET @reports_admin_person_id = LAST_INSERT_ID();

INSERT INTO person_name (preferred, person_id, given_name, family_name, date_created, creator, uuid)
VALUES (1, @reports_admin_person_id, 'Reports', 'Admin', NOW(), 1, UUID());

INSERT INTO users (system_id, username, password, salt, secret_question, secret_answer, creator, date_created, person_id, retired, uuid)
VALUES ('reports_admin', 'reports_admin', 
        SHA2(CONCAT('admin123', '1c9d7e94aeeb7a2459ef45ed200b2944582e0e7088d75f9b57a3644861ea766c20a269b3fe2eadaff1bc445ecfbd9bd3c0c550dfd813de48d39423cd3d1a8b10'), 512),
        '1c9d7e94aeeb7a2459ef45ed200b2944582e0e7088d75f9b57a3644861ea766c20a269b3fe2eadaff1bc445ecfbd9bd3c0c550dfd813de48d39423cd3d1a8b10',
        NULL, NULL, 1, NOW(), @reports_admin_person_id, 0, UUID());

SET @reports_admin_user_id = LAST_INSERT_ID();

-- Assign roles to Reports Admin
INSERT INTO user_role (user_id, role) VALUES 
(@reports_admin_user_id, 'Reports-App');
