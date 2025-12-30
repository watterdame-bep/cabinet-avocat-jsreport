# Utiliser l'image JSReport avec Chrome déjà inclus
FROM jsreport/jsreport:chrome-puppeteer

# Copier la configuration JSReport
COPY jsreport.config.json /app/jsreport.config.json

# Créer le cache Puppeteer accessible (déjà utile pour jsreport)
RUN mkdir -p /app/.puppeteer-cache && chown -R jsreport:jsreport /app/.puppeteer-cache

# Définir l'utilisateur jsreport
USER jsreport

# Exposer le port par défaut de JSReport
EXPOSE 5488
