FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

# Mise à jour système et installation de nodejs/npm
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        nodejs \
        npm \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Mise à jour de pip + installation de uv + mcpo
RUN pip install --upgrade pip && \
    pip install uv mcpo

# Verify mcpo installed correctly
RUN which mcpo

# Crée le dossier de config par défaut
RUN mkdir -p /defaults

# Copie le fichier par défaut et le script de démarrage
COPY defaults/config.json /defaults/config.json
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port (optional but common default)
EXPOSE 8000

# Lancer le script au démarrage
CMD ["/start.sh"]
