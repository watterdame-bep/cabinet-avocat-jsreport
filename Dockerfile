FROM jsreport/jsreport:4.7.0

USER root

# Installer Google Chrome et curl
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libnss3 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    --no-install-recommends

# Ajouter la clé GPG de Google et installer Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Variables d'environnement pour Puppeteer
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable
ENV PUPPETEER_ARGS="--no-sandbox --disable-setuid-sandbox"

# Créer le dossier de données
RUN mkdir -p /app/data

# Copier les fichiers de configuration
COPY jsreport.config.json /app/jsreport.config.json
COPY start-jsreport.sh /app/start-jsreport.sh

# Copier les templates JSReport (format .jsrexport)
COPY export.jsrexpor[t] /app/ 2>/dev/null || echo "export.jsrexport non trouvé - JSReport démarrera sans templates"

# Rendre le script exécutable
RUN chmod +x /app/start-jsreport.sh

USER jsreport

# Exposer le port
EXPOSE 5488

# Utiliser le script de démarrage personnalisé
CMD ["/app/start-jsreport.sh"]