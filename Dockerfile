# Utiliser une image Node.js avec Chrome pré-installé
FROM ghcr.io/puppeteer/puppeteer:21.6.1

# Passer en root pour installer JSReport
USER root

# Installer JSReport globalement
RUN npm install -g jsreport-cli@4.7.0

# Créer l'utilisateur jsreport
RUN groupadd -r jsreport && useradd -r -g jsreport -s /bin/bash -d /app jsreport

# Créer les répertoires nécessaires
RUN mkdir -p /app/data /app/data/blobs /app/logs && \
    chown -R jsreport:jsreport /app

# Copier le fichier de configuration
COPY jsreport.config.json /app/jsreport.config.json
RUN chown jsreport:jsreport /app/jsreport.config.json

# Passer à l'utilisateur jsreport
USER jsreport

# Définir le répertoire de travail
WORKDIR /app

# Variables d'environnement
ENV NODE_ENV=production
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# Exposer le port
EXPOSE 5488

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:5488/api/ping || exit 1

# Commande de démarrage
CMD ["jsreport", "start", "--config=jsreport.config.json"]