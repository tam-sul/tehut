# Custom Bahmni Web with TIHUT Branding
FROM bahmni/bahmni-web:1.0.0

# Copy TIHUT logos to replace Bahmni logos
COPY images/tihut-logo.jpg /usr/local/apache2/htdocs/bahmni-logo.png
COPY images/tihut-logo.jpg /usr/local/apache2/htdocs/bahmni_config/openmrs/apps/registration/registrationCardLayout/images/bahmniLogo.png
COPY images/tihut-logo.jpg /usr/local/apache2/htdocs/bahmni_config/openmrs/apps/customDisplayControl/images/bahmniLogo.png
COPY images/tihut-logo.jpg /usr/local/apache2/htdocs/bahmni/images/bahmniLogo.png
COPY images/tihut-logo.jpg /usr/local/apache2/htdocs/bahmni/images/bahmniLogoFull.png

# Copy favicon
COPY images/tihut-logo-small.jpg /usr/local/apache2/htdocs/favicon.ico
COPY images/tihut-logo-small.jpg /usr/local/apache2/htdocs/bahmni/favicon.ico

# Ensure proper permissions
RUN chown -R www-data:www-data /usr/local/apache2/htdocs/