#/bin/bash

set -e

## default
TIRUM_TORRENT_CONFIG_FOLDER="${PWD}/downloader/qbittorrent/config/"
TIRUM_TORRENT_DOWNLOAD_FOLDER="${PWD}/downloader/qbittorrent/downloads/"

TIRUM_RADARR_CONFIG_FOLDER="${PWD}/managers/radarr/config/"
TIRUM_RADARR_MOVIES_FOLDER="${PWD}/managers/radarr/movies/"

TIRUM_PROWLARR_CONFIG_FOLDER="${PWD}/managers/prowlarr/config/"

function createFolder {
    mkdir -p ${TIRUM_TORRENT_CONFIG_FOLDER} ${TIRUM_TORRENT_DOWNLOAD_FOLDER} \
${TIRUM_RADARR_CONFIG_FOLDER} ${TIRUM_RADARR_MOVIES_FOLDER} \
${TIRUM_PROWLARR_CONFIG_FOLDER}
}

## simlinks
TIRUM_LIBRARY_FOLDER="${PWD}/library/"
TIRUM_MOVIES_FOLDER="${TIRUM_LIBRARY_FOLDER}movies"

function createSimlinks {
    mkdir -p ${TIRUM_LIBRARY_FOLDER}

    ln -snf ${TIRUM_RADARR_MOVIES_FOLDER} ${TIRUM_MOVIES_FOLDER}
}

## create env

function createEnv {
    cat > .env <<EOF
TIRUM_TORRENT_CONFIG_FOLDER=${TIRUM_TORRENT_CONFIG_FOLDER}
TIRUM_TORRENT_DOWNLOAD_FOLDER=${TIRUM_TORRENT_DOWNLOAD_FOLDER}
TIRUM_RADARR_CONFIG_FOLDER=${TIRUM_RADARR_CONFIG_FOLDER}
TIRUM_RADARR_MOVIES_FOLDER=${TIRUM_RADARR_MOVIES_FOLDER}
TIRUM_PROWLARR_CONFIG_FOLDER=${TIRUM_PROWLARR_CONFIG_FOLDER}
TIRUM_LIBRARY_FOLDER=${TIRUM_LIBRARY_FOLDER}
TIRUM_MOVIES_FOLDER=${TIRUM_MOVIES_FOLDER}
EOF
}

## scripting functions
CACHE_FOLDER="${PWD}/.cache/"
UV_LINK="https://github.com/astral-sh/uv/releases/download/0.8.22/uv-aarch64-unknown-linux-gnu.tar.gz"
UV="${CACHE_FOLDER}uv"

function _ensureCache {
    mkdir -p ${CACHE_FOLDER}
}

function cleanCache {
    rm -rf ${CACHE_FOLDER}
}

function installUv {
    _ensureCache
    wget --directory-prefix=${CACHE_FOLDER} https://github.com/astral-sh/uv/releases/download/0.8.22/uv-aarch64-unknown-linux-gnu.tar.gz
}

function runner {
    createFolder
    createSimlinks
    createEnv
    # installUv
}

runner

## configure qbittorrent
# sleep 2
# PASSWORD=$(docker logs qbittorrent 2>&1 | grep "temporary password" | awk -F': ' '{print $2}')
# uv run --with requests ./scripts/qbittorrent.py "${PASSWORD}"

