#!/bin/bash
set -e

echo "=================================================="
echo "  AllBlue - Starting your homelab..."
echo "=================================================="

# Step 1: Check .env exists
if [ ! -f .env ]; then
    echo "[!] .env file not found. Copying from .env.example..."
    cp .env.example .env
    echo "[!] IMPORTANT: Edit .env and set real passwords before continuing."
    echo "    Run: nano .env"
    exit 1
fi

# Step 2: Start the stack WITHOUT wiping existing containers
# This is the key part for persistence: if containers already exist
# (from a previous run), we just START them again - anything you
# installed inside (nmap, packages, files) stays exactly as it was.
# We only BUILD + CREATE containers the very first time.

if [ "$(docker ps -aq -f name=allblue-ubuntu)" ]; then
    echo "[*] Existing AllBlue containers found - resuming them (your installed tools/data are preserved)..."
    docker compose start
else
    echo "[*] First run detected - building images and creating containers..."
    docker compose up -d --build
fi

echo "[*] Waiting for services to warm up (30s)..."
sleep 30

# Step 3: Open a public Cloudflare Quick Tunnel to localhost
echo "=================================================="
echo "  Generating your public link..."
echo "  (This link works from ANY device - phone, tablet,"
echo "   laptop, Termux browser - anywhere with internet)"
echo "=================================================="
echo ""
echo "  Keep this terminal open. Closing it will close the link."
echo ""

docker run --rm -it --network allblue_allblue-net cloudflare/cloudflared:latest \
    tunnel --url http://nginx:80
