echo "📋 Fetching Jenkins initial admin password..."
sudo cat /var/lib/jenkins/secrets/initialAdminPassword || echo "⚠️ Password not found"

echo ""
echo "🔎 Versions:"
git --version
java -version
jenkins --version || echo "⚠️ 'jenkins' CLI not found, but service should be running"
docker --version
microk8s version

echo ""
echo "✅ Setup Completed Successfully!"
