# Utiliser l'image JSReport basée sur Debian (apt-get disponible)
FROM jsreport/jsreport:4.7.0-debian

USER root

# Installer Google Chrome avec toutes les dépendances
RUN apt-get update && apt-get install -y \
    wget \
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
    libxss1 \
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
ENV PUPPETEER_CACHE_DIR=/app/.puppeteer-cache

# Créer le cache Puppeteer accessible
RUN mkdir -p /app/.puppeteer-cache && chown -R jsreport:jsreport /app/.puppeteer-cache

# Copier la configuration JSReport
COPY jsreport.config.json /app/jsreport.config.json

USER jsreport

# Exposer le port
EXPOSE 5488
