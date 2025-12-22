#!/bin/bash
# Script de démarrage JSReport avec import automatique des templates

echo "🚀 Démarrage JSReport avec import des templates..."

# Démarrer JSReport en arrière-plan
jsreport start &
JSREPORT_PID=$!

# Attendre que JSReport soit prêt
echo "⏳ Attente du démarrage de JSReport..."
sleep 15

# Vérifier si JSReport est prêt (avec retry)
for i in {1..10}; do
    if curl -f http://localhost:5488/api/ping > /dev/null 2>&1; then
        echo "✅ JSReport est prêt !"
        break
    else
        echo "⏳ Tentative $i/10 - JSReport pas encore prêt..."
        sleep 5
    fi
done

# Importer les templates si le fichier .jsrexport existe
if [ -f "/app/export.jsrexport" ]; then
    echo "📦 Import des templates depuis export.jsrexport..."
    
    # Utiliser l'API d'import JSReport avec le format .jsrexport
    IMPORT_RESULT=$(curl -s -X POST \
         -H "Content-Type: application/octet-stream" \
         --data-binary @/app/export.jsrexport \
         http://localhost:5488/api/import)
    
    if [ $? -eq 0 ]; then
        echo "✅ Templates importés avec succès depuis export.jsrexport"
        echo "📋 Résultat: $IMPORT_RESULT"
    else
        echo "❌ Erreur lors de l'import des templates"
    fi
else
    echo "⚠️ Fichier export.jsrexport non trouvé - JSReport démarrera sans templates"
    echo "💡 Vous devrez importer manuellement via l'interface web"
fi

echo "🎯 JSReport prêt à recevoir les requêtes sur le port 5488"

# Garder JSReport en vie
wait $JSREPORT_PID