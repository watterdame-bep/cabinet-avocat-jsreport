#!/bin/bash

echo "=== TEST IMPORT JSREPORT ==="
echo "Fichiers dans /app:"
ls -la /app/

echo "Vérification export.jsrexport:"
if [ -f "/app/export.jsrexport" ]; then
    echo "✅ export.jsrexport trouvé"
    ls -la /app/export.jsrexport
else
    echo "❌ export.jsrexport NON trouvé"
fi

echo "Démarrage JSReport..."
jsreport start &
JSREPORT_PID=$!

echo "Attente 20 secondes..."
sleep 20

echo "Test ping JSReport..."
curl -f http://localhost:5488/api/ping
PING_RESULT=$?

if [ $PING_RESULT -eq 0 ]; then
    echo "✅ JSReport répond"
    
    if [ -f "/app/export.jsrexport" ]; then
        echo "Import des templates..."
        curl -X POST \
             -H "Content-Type: application/octet-stream" \
             --data-binary @/app/export.jsrexport \
             http://localhost:5488/api/import
        echo "Import terminé"
    fi
else
    echo "❌ JSReport ne répond pas"
fi

echo "JSReport prêt"
wait $JSREPORT_PID