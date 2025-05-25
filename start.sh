#!/bin/sh

CONFIG_PATH="/opt/mcpo/config.json"
DEFAULT_CONFIG_PATH="/defaults/config.json"

# Si le fichier n'existe pas, on copie la version par défaut
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Fichier de configuration non trouvé. Copie de config.json par défaut..."
    cp "$DEFAULT_CONFIG_PATH" "$CONFIG_PATH"
fi

echo "Lancement de mcpo avec : $CONFIG_PATH"

# Ajoute --api-key si MCPO_API_KEY est défini
if [ -n "$MCPO_API_KEY" ]; then
    echo "Clé API détectée, ajout de --api-key"
    exec mcpo --config "$CONFIG_PATH" --api-key "$MCPO_API_KEY"
else
    exec mcpo --config "$CONFIG_PATH"
fi
