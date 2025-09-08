# TEHUT Medium Clinic - Hospital Management System

A customized healthcare management system based on Bahmni, specifically configured for **TEHUT Medium Clinic** with complete branding and multi-clinic support.

## 🏥 System Overview

This system provides a comprehensive Electronic Medical Records (EMR) and Hospital Information Management System (HMIS) with:
- Patient Registration & Management
- Clinical Consultation & Documentation  
- Laboratory Management
- Reports & Analytics
- Billing & Invoicing (Crater)
- Multi-location Support
- Complete TEHUT branding

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose installed
- At least 4GB RAM available
- Ports 80, 443, 8080, 8090, 444 available

### Starting the System

1. **Clone the repository:**
```bash
git clone https://github.com/tam-sul/tehut.git
cd tehut/bahmni-lite
```

2. **Start all services:**
```bash
./run-bahmni.sh
```
Select option **1) START Bahmni services**

3. **Apply TEHUT branding:**
```bash
./replace-logos-simple.sh
```

4. **Access the system:**
- **Main URL:** `https://localhost/bahmni/home/`
- **Accept SSL certificate warning once** (click Advanced → Proceed)

## 🔐 Default Login Credentials

- **Username:** `superman`
- **Password:** `Admin123`

## 🌐 System URLs

After starting, access these URLs:

| Service | URL | Purpose |
|---------|-----|---------|
| **Main Dashboard** | `https://localhost/bahmni/home/` | TEHUT EMR Login |
| **Registration** | `https://localhost/bahmni/registration/` | Patient Registration |
| **Clinical** | `https://localhost/bahmni/clinical/` | Clinical Consultations |
| **Reports** | `https://localhost/bahmni/reports/` | Analytics & Reports |
| **Admin Panel** | `https://localhost/openmrs/admin/` | System Administration |
| **Billing** | `https://localhost:444/` | Crater Billing System |

## ⚙️ System Configuration

### Adding Clinics/Locations
1. Go to: `https://localhost/openmrs/admin/`
2. Navigate to: **Administration → Locations → Manage Locations**
3. Add your clinics through the web interface

### Environment Configuration
- **Production:** Edit `.env` file (default)
- **Development:** Use `.env.dev` with latest images
- **Timezone:** Set to `TZ=EAT` (East Africa Time)

### Organization Settings
The system is pre-configured with:
- **Organization:** TEHUT Medium Clinic
- **Logos:** Custom TEHUT branding
- **Domain:** Ready for `irif.world` deployment

## 🎨 Branding Features

✅ **Complete TEHUT Branding:**
- Custom TEHUT logos throughout interface
- "TEHUT EMR LOGIN" on login page  
- "TEHUT Medium Clinic" organization name
- Custom color scheme and styling

✅ **Professional Interface:**
- Clean, medical-grade UI
- Mobile-responsive design
- Consistent branding across all modules

## 📋 Available Scripts

| Script | Purpose |
|--------|---------|
| `./run-bahmni.sh` | Start/stop/manage services |
| `./replace-logos-simple.sh` | Apply TEHUT logo branding |
| `./replace-bahmni-with-tehut.sh` | Comprehensive text replacement |

## 🛠️ Management Commands

```bash
# View system status
docker-compose ps

# View logs
docker-compose logs -f

# Stop all services  
docker-compose down

# Update to latest images
docker-compose pull
```

## 🌍 Production Deployment

For deployment on VPS with `irif.world` domain:

1. **Update domain in `.env`:**
```bash
# Change localhost references to irif.world
sed -i 's/localhost/irif.world/g' .env
```

2. **Get SSL certificate** (Let's Encrypt recommended)

3. **Deploy and start services**

## 📞 Support & Configuration

### Clinic Configuration
- **Location Management:** Through OpenMRS Admin interface  
- **User Management:** Role-based access control
- **Visit Types:** Configurable (OPD, IPD, Emergency)
- **Encounter Types:** Customizable clinical workflows

### Technical Support
- **System Logs:** Check `docker-compose logs`
- **Database:** MySQL with automated backups
- **Performance:** Optimized for medium-scale clinics
- **Security:** Role-based access control

## 🏗️ Architecture

- **Frontend:** Angular-based Bahmni web interface
- **Backend:** OpenMRS medical records system  
- **Database:** MySQL for data persistence
- **Proxy:** Apache reverse proxy with SSL
- **Billing:** Crater invoicing system
- **Containerization:** Docker Compose orchestration

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**🏥 TEHUT Medium Clinic - Providing Quality Healthcare Management Solutions**