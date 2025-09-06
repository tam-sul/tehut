# Complete Bahmni Logo Customization Guide

This guide will help you replace all Bahmni logos and branding with your clinic's identity.

## 🎯 What This Customization Achieves

- **Replaces Bahmni logos** in all interfaces (login, navigation, reports)
- **Hides Bahmni branding text** throughout the application  
- **Adds your clinic's logo** to all user-facing areas
- **Customizes colors** to match your clinic's brand
- **Updates print documents** with your logo
- **Changes browser favicon** to your clinic's icon

## 📁 File Structure Created

```
bahmni-docker/bahmni-standard/
├── custom-config/
│   ├── README.md
│   ├── images/                          # Your logo files go here
│   │   ├── clinic-logo.png              # Main logo (200x60px recommended)
│   │   ├── clinic-logo-small.png        # Small logo (100x30px recommended)  
│   │   └── clinic-favicon.ico           # Browser favicon (32x32px)
│   ├── bahmni_config/
│   │   └── custom-branding.css          # CSS overrides for styling
│   └── openmrs/
│       └── apps.json                    # App configuration overrides
├── docker-compose.override.yml          # Docker volume mounts for customization
├── customize-logos.sh                   # Setup validation script
└── BRANDING_GUIDE.md                   # This guide
```

## 🚀 Quick Start (5 Steps)

### Step 1: Add Your Logo Files
Copy your logo files to the `custom-config/images/` directory:

```bash
# Copy your logos (replace with your actual file paths)
cp /path/to/your/main-logo.png custom-config/images/clinic-logo.png
cp /path/to/your/small-logo.png custom-config/images/clinic-logo-small.png  
cp /path/to/your/favicon.ico custom-config/images/clinic-favicon.ico
```

**Logo Requirements:**
- **Format:** PNG with transparent background (recommended), JPG, or SVG
- **Main Logo:** ~200×60 pixels (maintains aspect ratio across screens)
- **Small Logo:** ~100×30 pixels (for mobile/compact views)
- **Favicon:** 32×32 pixels ICO format

### Step 2: Update Clinic Information
Edit the configuration files with your clinic's details:

**A. Update CSS file (`custom-config/bahmni_config/custom-branding.css`):**
- Change `"Your Clinic Name"` to your actual clinic name
- Modify color variables to match your brand colors

**B. Update OpenMRS config (`custom-config/openmrs/apps.json`):**
- Change `"title": "Your Clinic Name"` to your clinic name
- Update `"logoAltText"` description

### Step 3: Validate Setup
Run the setup script to check everything is configured correctly:

```bash
./customize-logos.sh
```

This will verify all files are in place and provide status information.

### Step 4: Apply Changes
Stop and restart Bahmni to apply your customizations:

```bash
# Stop Bahmni
docker-compose down

# Start with custom configuration
docker-compose up -d
```

### Step 5: Verify Changes
- Open your browser and navigate to Bahmni (usually `http://localhost`)
- Check the login page for your logo
- Log in and verify navigation bar shows your branding
- Test different pages to ensure consistent branding

## 🎨 Advanced Customization

### Custom Colors
Edit `custom-config/bahmni_config/custom-branding.css` and modify these CSS variables:

```css
:root {
    --primary-color: #337ab7;    /* Your primary brand color */
    --secondary-color: #5bc0de;  /* Your secondary brand color */
}
```

### Custom Clinic Name Display
Update the clinic name in multiple places:

```css
.clinic-name::after {
    content: "Your Actual Clinic Name" !important;
    font-weight: bold;
    color: var(--primary-color);
}
```

### Footer Customization
Change the footer text:

```css
.app-footer::after {
    content: "Powered by [Your Clinic Name]" !important;
    color: #666;
    font-size: 12px;
}
```

## 🔧 Troubleshooting

### Logos Not Appearing
1. **Check file permissions:**
   ```bash
   chmod 644 custom-config/images/*
   ```

2. **Verify file paths and names are exact:**
   - `clinic-logo.png` (not `clinic_logo.png` or `Clinic-Logo.PNG`)
   - Files must be in `custom-config/images/` directory

3. **Clear browser cache:**
   - Hard refresh: `Ctrl+F5` (Windows/Linux) or `Cmd+Shift+R` (Mac)
   - Or open in incognito/private browsing mode

### Configuration Not Loading
1. **Restart containers completely:**
   ```bash
   docker-compose down
   docker system prune -f
   docker-compose up -d
   ```

2. **Check Docker logs:**
   ```bash
   docker-compose logs bahmni-web
   docker-compose logs openmrs
   ```

3. **Verify volume mounts:**
   ```bash
   docker-compose config
   ```

### CSS Changes Not Applied
1. **Check CSS syntax:** Ensure no syntax errors in `custom-branding.css`
2. **Force CSS reload:** Add `?v=1` to your URL (e.g., `http://localhost/?v=1`)
3. **Inspect element:** Use browser dev tools to check if CSS is loading

## 📋 Logo Specifications

### Main Logo (`clinic-logo.png`)
- **Usage:** Header navigation, login page, reports
- **Size:** 200×60 pixels (or maintain 3.3:1 aspect ratio)
- **Format:** PNG with transparent background preferred
- **File size:** Under 50KB for optimal loading

### Small Logo (`clinic-logo-small.png`) 
- **Usage:** Mobile views, compact layouts, print headers
- **Size:** 100×30 pixels (or maintain same aspect ratio as main logo)
- **Format:** PNG with transparent background preferred  
- **File size:** Under 25KB

### Favicon (`clinic-favicon.ico`)
- **Usage:** Browser tab icon, bookmarks
- **Size:** 32×32 pixels (ICO format contains multiple sizes)
- **Format:** ICO file (can be converted from PNG)
- **File size:** Under 10KB

## 🔄 Updating Logos Later

To update your logos after initial setup:

1. Replace files in `custom-config/images/` with new versions
2. Keep the same filenames (`clinic-logo.png`, etc.)  
3. Restart containers: `docker-compose restart bahmni-web openmrs`
4. Clear browser cache

## 🌐 Multi-Language Support

If your clinic supports multiple languages, you may need additional logo variations:
- Create language-specific logos: `clinic-logo-en.png`, `clinic-logo-es.png`
- Update CSS to use appropriate logos based on language settings
- Consult Bahmni documentation for internationalization setup

## 📞 Support

If you encounter issues:

1. **Run the validation script:** `./customize-logos.sh`
2. **Check the troubleshooting section above**
3. **Review Docker logs:** `docker-compose logs`
4. **Consult Bahmni documentation:** [https://bahmni.atlassian.net/wiki/spaces/BAH/overview](https://bahmni.atlassian.net/wiki/spaces/BAH/overview)

---

**✨ Congratulations!** Your Bahmni installation should now display your clinic's branding throughout the interface, providing a professional, customized experience for your users.
