FROM jsreport/jsreport:4.7.0

# Copier la configuration JSReport
COPY jsreport.config.json /app/jsreport.config.json

# Exposer le port par défaut de JSReport
EXPOSE 5488
