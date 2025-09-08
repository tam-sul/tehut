# Run the bahmni script in the parent folder
../run-bahmni.sh "$1"

# TIHUT branding disabled for troubleshooting - can be re-enabled later
# Auto-apply TIHUT branding after startup if containers are starting
# if [[ "$1" != "stop" && "$1" != "logs" && "$1" != "status" ]]; then
#     echo ""
#     echo "🏥 Auto-applying TIHUT branding..."
#     sleep 15  # Wait for containers to be ready
#     
#     # Check if containers are running before applying branding
#     if docker ps | grep -q bahmni-lite-bahmni-web-1; then
#         ./replace-logos-with-tihut.sh > /dev/null 2>&1 || true
#         ./replace-all-bahmni-text.sh > /dev/null 2>&1 || true
#         
#         echo "✅ TIHUT branding and text replacement applied automatically!"
#         echo "🌐 Access your system at: http://irif.world"
#         echo "🔐 Login: superman / Admin123"
#         echo "📝 All 'Bahmni' text has been replaced with 'TIHUT'"
#     else
#         echo "⚠️  Containers not ready, branding will apply on next restart"
#     fi
# fi

