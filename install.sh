#/bin/bash

set -e

## default
TIRUM_TORRENT_CONFIG_FOLDER="${PWD}/downloader/qbittorrent/config/"
TIRUM_TORRENT_DOWNLOAD_FOLDER="${PWD}/downloader/qbittorrent/downloads/"

TIRUM_RADARR_CONFIG_FOLDER="${PWD}/managers/radarr/config/"
TIRUM_RADARR_MOVIES_FOLDER="${PWD}/managers/radarr/movies/"

TIRUM_PROWLARR_CONFIG_FOLDER="${PWD}/managers/prowlarr/config/"

mkdir -p ${TIRUM_TORRENT_CONFIG_FOLDER} ${TIRUM_TORRENT_DOWNLOAD_FOLDER} \
${TIRUM_RADARR_CONFIG_FOLDER} ${TIRUM_RADARR_MOVIES_FOLDER} \
${TIRUM_PROWLARR_CONFIG_FOLDER}

## simlinks
TIRUM_LIBRARY_FOLDER="${PWD}/library/"
TIRUM_MOVIES_FOLDER="${TIRUM_LIBRARY_FOLDER}movies"

mkdir -p ${TIRUM_LIBRARY_FOLDER}

ln -snf ${TIRUM_RADARR_MOVIES_FOLDER} ${TIRUM_MOVIES_FOLDER}

## create env
cat > .env <<EOF
TIRUM_TORRENT_CONFIG_FOLDER=${TIRUM_TORRENT_CONFIG_FOLDER}
TIRUM_TORRENT_DOWNLOAD_FOLDER=${TIRUM_TORRENT_DOWNLOAD_FOLDER}
TIRUM_RADARR_CONFIG_FOLDER=${TIRUM_RADARR_CONFIG_FOLDER}
TIRUM_RADARR_MOVIES_FOLDER=${TIRUM_RADARR_MOVIES_FOLDER}
TIRUM_PROWLARR_CONFIG_FOLDER=${TIRUM_PROWLARR_CONFIG_FOLDER}
TIRUM_LIBRARY_FOLDER=${TIRUM_LIBRARY_FOLDER}
TIRUM_MOVIES_FOLDER=${TIRUM_MOVIES_FOLDER}
EOF

docker compose up --build -d

## scripting functions
function installUv {
    
}

## configure qbittorrent
sleep 2
PASSWORD=$(docker logs qbittorrent 2>&1 | grep "temporary password" | awk -F': ' '{print $2}')
uv run --with requests ./scripts/qbittorrent.py "${PASSWORD}"
