# Utiliser l'image officielle JSReport
FROM jsreport/jsreport:4.7.0

# Créer un dossier temporaire accessible par l'utilisateur jsreport
RUN mkdir -p /app/tmp && chown -R jsreport:jsreport /app/tmp

# Copier la configuration JSReport
COPY jsreport.config.json /app/jsreport.config.json

# Exposer le port par défaut de JSReport
EXPOSE 5488
