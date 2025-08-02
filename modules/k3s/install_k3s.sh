
#!/bin/bash

set -e

ROLE=$1
VERSION=$2

if [ -z "$ROLE" ] || [ -z "$VERSION" ]; then
  echo "[ERROR] Usage: $0 <server> <version>"
  exit 1
fi

echo "[INFO] Installing K3s as $ROLE with version $VERSION"
echo "[DEBUG] Running as $(whoami) on $(hostname)"

if [ "$ROLE" == "server" ]; then
  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$VERSION" \
    INSTALL_K3S_EXEC="--disable=traefik --disable=local-storage" sh -
else
  echo "[ERROR] This script supports only server role for now."
  exit 1
fi

echo "[INFO] K3s installation complete (traefik and local-storage disabled)."
