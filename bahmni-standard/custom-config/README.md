# Bahmni Logo Customization Guide

This directory contains custom configuration files to replace Bahmni default logos with your clinic's branding.

## Quick Setup

1. **Add your logo files** to the appropriate directories:
   - `images/clinic-logo.png` - Main clinic logo (recommended: 200x60 pixels)
   - `images/clinic-logo-small.png` - Small version for mobile/compact views (100x30 pixels)
   - `images/clinic-favicon.ico` - Favicon for browser tabs

2. **Update the docker-compose.yml** to mount this custom configuration

3. **Restart Bahmni** to apply changes

## Logo Placement

Your custom logos will replace Bahmni logos in:
- Login page header
- Main navigation bar
- Reports header
- Print documents
- Email templates
- Browser favicon

## File Format Requirements

- **Format**: PNG, SVG, or JPG (PNG recommended for transparent backgrounds)
- **Main Logo Size**: 200x60 pixels (maintains aspect ratio across the interface)
- **Small Logo Size**: 100x30 pixels (for mobile and compact views)
- **File Size**: Keep under 100KB for optimal loading

## Supported Customizations

- Hospital/Clinic Name
- Logo Images
- Color Themes (via CSS overrides)
- Login Page Text
- Footer Information
