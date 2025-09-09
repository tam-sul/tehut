# Custom Bahmni Web with TEHUT Branding
FROM bahmni/bahmni-web:1.0.0

# Copy TEHUT logos to replace Bahmni logos
COPY images/tehut-logo.jpg /usr/local/apache2/htdocs/bahmni-logo.png
COPY images/tehut-logo.jpg /usr/local/apache2/htdocs/bahmni_config/openmrs/apps/registration/registrationCardLayout/images/bahmniLogo.png
COPY images/tehut-logo.jpg /usr/local/apache2/htdocs/bahmni_config/openmrs/apps/customDisplayControl/images/bahmniLogo.png
COPY images/tehut-logo.jpg /usr/local/apache2/htdocs/bahmni/images/bahmniLogo.png
COPY images/tehut-logo.jpg /usr/local/apache2/htdocs/bahmni/images/bahmniLogoFull.png

# Copy favicon
COPY images/tehut-logo-small.jpg /usr/local/apache2/htdocs/favicon.ico
COPY images/tehut-logo-small.jpg /usr/local/apache2/htdocs/bahmni/favicon.ico

# Ensure proper permissions
RUN chown -R www-data:www-data /usr/local/apache2/htdocs/