/* TIHUT CLINIC TEXT REPLACEMENT SCRIPT */
/* This script replaces ALL Bahmni text references with TIHUT Clinic */

(function() {
    'use strict';
    
    // Text replacement mappings
    const textReplacements = {
        'Bahmni': 'TIHUT Clinic',
        'bahmni': 'TIHUT Clinic',
        'BAHMNI': 'TIHUT Clinic',
        'Bahmni EMR': 'TIHUT Clinic Healthcare System',
        'Bahmni ERP': 'TIHUT Clinic Management System',
        'Bahmni Lab': 'TIHUT Clinic Laboratory System',
        'Bahmni Hospital System': 'TIHUT Clinic Healthcare Management System',
        'Welcome to Bahmni': 'Welcome to TIHUT Clinic',
        'Powered by Bahmni': 'Powered by TIHUT Clinic Healthcare System'
    };

    // Function to replace text in all text nodes
    function replaceTextInNode(node) {
        if (node.nodeType === Node.TEXT_NODE) {
            let text = node.textContent;
            let modified = false;
            
            for (const [oldText, newText] of Object.entries(textReplacements)) {
                const regex = new RegExp(oldText, 'gi');
                if (regex.test(text)) {
                    text = text.replace(regex, newText);
                    modified = true;
                }
            }
            
            if (modified) {
                node.textContent = text;
            }
        } else {
            // Recursively process child nodes
            for (let i = 0; i < node.childNodes.length; i++) {
                replaceTextInNode(node.childNodes[i]);
            }
        }
    }

    // Function to replace text in attributes
    function replaceTextInAttributes(element) {
        // Replace in common attributes
        const attributes = ['title', 'alt', 'placeholder', 'aria-label', 'data-original-title'];
        
        attributes.forEach(attr => {
            if (element.hasAttribute(attr)) {
                let value = element.getAttribute(attr);
                let modified = false;
                
                for (const [oldText, newText] of Object.entries(textReplacements)) {
                    const regex = new RegExp(oldText, 'gi');
                    if (regex.test(value)) {
                        value = value.replace(regex, newText);
                        modified = true;
                    }
                }
                
                if (modified) {
                    element.setAttribute(attr, value);
                }
            }
        });
    }

    // Function to replace images with Bahmni in the src
    function replaceImages() {
        const images = document.querySelectorAll('img');
        images.forEach(img => {
            if (img.src && (img.src.toLowerCase().includes('bahmni') || img.alt && img.alt.toLowerCase().includes('bahmni'))) {
                img.src = '/bahmni_config/images/tihut-logo.jpg';
                img.alt = 'TIHUT Clinic';
                img.title = 'TIHUT Clinic Healthcare Management System';
                img.style.maxHeight = '60px';
                img.style.width = 'auto';
            }
        });
    }

    // Function to update page title
    function updatePageTitle() {
        if (document.title.toLowerCase().includes('bahmni')) {
            document.title = document.title.replace(/bahmni/gi, 'TIHUT Clinic');
        }
        
        // If title is just "Bahmni", replace it completely
        if (document.title.toLowerCase() === 'bahmni') {
            document.title = 'TIHUT Clinic - Healthcare Management System';
        }
    }

    // Function to process all elements
    function processAllElements() {
        // Replace text content
        replaceTextInNode(document.body);
        
        // Replace attributes
        const allElements = document.querySelectorAll('*');
        allElements.forEach(element => {
            replaceTextInAttributes(element);
        });
        
        // Replace images
        replaceImages();
        
        // Update page title
        updatePageTitle();
        
        // Update favicon if it contains bahmni
        const favicon = document.querySelector('link[rel="icon"], link[rel="shortcut icon"]');
        if (favicon && favicon.href && favicon.href.toLowerCase().includes('bahmni')) {
            favicon.href = '/bahmni_config/images/tihut-logo.jpg';
        }
    }

    // Run immediately when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', processAllElements);
    } else {
        processAllElements();
    }

    // Create a MutationObserver to handle dynamically added content
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList') {
                mutation.addedNodes.forEach(function(node) {
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        // Process the new element and its children
                        replaceTextInNode(node);
                        replaceTextInAttributes(node);
                        
                        // Process child elements
                        const childElements = node.querySelectorAll('*');
                        childElements.forEach(element => {
                            replaceTextInAttributes(element);
                        });
                        
                        // Check for new images
                        if (node.tagName === 'IMG' || node.querySelectorAll('img').length > 0) {
                            setTimeout(replaceImages, 100); // Small delay to ensure images are loaded
                        }
                    }
                });
            }
            
            // Handle attribute changes
            if (mutation.type === 'attributes' && mutation.attributeName) {
                const element = mutation.target;
                const attr = mutation.attributeName;
                
                if (['title', 'alt', 'placeholder', 'aria-label'].includes(attr)) {
                    replaceTextInAttributes(element);
                }
            }
        });
    });

    // Start observing
    observer.observe(document.body, {
        childList: true,
        subtree: true,
        attributes: true,
        attributeFilter: ['title', 'alt', 'placeholder', 'aria-label', 'data-original-title']
    });

    // Re-run the process periodically to catch any missed content
    setInterval(processAllElements, 2000);

    // Handle hash changes and navigation
    window.addEventListener('hashchange', function() {
        setTimeout(processAllElements, 500);
    });

    // Handle popstate events
    window.addEventListener('popstate', function() {
        setTimeout(processAllElements, 500);
    });

    // Console log for debugging
    console.log('TIHUT Clinic branding script loaded - all Bahmni references will be replaced with TIHUT Clinic');

})();
