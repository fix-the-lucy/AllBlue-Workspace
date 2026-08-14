# Running AllBlue

This guide takes you from zero to a publicly accessible AllBlue lab using Cloudflare Tunnel
(no port forwarding, no router config, works even behind CGNAT/mobile hotspots).

---

## 1. Prerequisites

Install on your host machine (Pi / mini-PC / VPS / old laptop running Linux):

```bash
# Docker + Compose (Debian/Ubuntu example)
curl -fsSL https://get.docker.com | sh
sudo apt-get install -y docker-compose-plugin
```

Clone the repo:

```bash
git clone https://github.com/<your-username>/allblue.git
cd allblue
cp .env.example .env
nano .env   # fill in real passwords (see below)
```

---

## 2. Set your secrets in `.env`

Open `.env` and replace every `changeme_...` value with a strong password.
Leave `CLOUDFLARE_TUNNEL_TOKEN` for now — you'll get that in Step 4.

---

## 3. First boot (without the tunnel, to test locally)

```bash
docker compose up -d --build
```

This builds the Ubuntu and Kali images (takes a while the first time — Kali especially, since it installs Metasploit/Burp/etc.) and starts everything else.

**Initialize the Guacamole database** (one-time, only needed the first time you ever start the stack):

```bash
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > ./guac-init/initdb.sql
docker compose restart guac-db guacamole
```

Check everything is up:

```bash
docker compose ps
```

Visit `http://<your-server-local-ip>/` in a browser on the same network — you should see the AllBlue landing message.
Go to `/desktop/` for Guacamole (default login `guacadmin` / `guacadmin` — **change this immediately** under Settings > Users) and `/vscode/` for the code editor.

In Guacamole, add two connections (Settings > Connections > New Connection):
- **Ubuntu-Dev**: Protocol VNC, Hostname `ubuntu-dev`, Port `5901`, Password = your `UBUNTU_VNC_PASSWORD`
- **Kali-Lab**: Protocol VNC, Hostname `kali-lab`, Port `5901`, Password = your `KALI_VNC_PASSWORD`

---

## 4. Expose it publicly with Cloudflare Tunnel

This is the key step for "works everywhere" — anyone can reach your lab from any device over HTTPS, without you opening a single port on your router.

**a) Create a free Cloudflare account** (if you don't have one) at cloudflare.com — you don't even need to own a domain; Cloudflare can give you one, or you can use a free subdomain via Cloudflare's Quick Tunnel for testing.

**b) Create the tunnel:**
1. Go to the Cloudflare Zero Trust dashboard → **Networks → Tunnels**
2. Click **Create a tunnel** → choose **Cloudflared**
3. Name it `allblue`
4. Cloudflare shows you a token (long string) — copy it
5. Paste it into your `.env` file as `CLOUDFLARE_TUNNEL_TOKEN`

**c) Set the public hostname (in the same tunnel setup screen):**
- Subdomain: `allblue` (or whatever you like)
- Domain: pick from your Cloudflare-managed domains (or the free one Cloudflare offers)
- Service type: `HTTP`
- URL: `nginx:80` (this is the internal Docker service name — Cloudflare routes traffic straight to the Nginx container)

**d) Start the tunnel container:**

```bash
docker compose up -d cloudflared
```

That's it — your lab is now live at `https://allblue.yourdomain.com`, reachable from any laptop, phone, or tablet browser anywhere in the world, with Cloudflare handling HTTPS automatically.

---

## 5. Quick test without setting up a domain (fastest option)

If you just want a public link *right now* for a hackathon demo without configuring DNS, use a **Quick Tunnel** instead — no Cloudflare account needed:

```bash
docker run --rm -it --network allblue_allblue-net cloudflare/cloudflared:latest \
  tunnel --url http://nginx:80
```

This prints a random `https://xxxx.trycloudflare.com` URL in the terminal — share that link for your demo. It's temporary and resets each time you run it, but it's the fastest way to show judges a live public link.

---

## 6. Stopping / restarting

```bash
docker compose down        # stop everything
docker compose up -d       # start again (no rebuild needed)
docker compose logs -f     # watch logs for debugging
```

---

## Security checklist before you share the link publicly

- [ ] Changed the default Guacamole admin password
- [ ] Changed every password in `.env` from the placeholder
- [ ] `.env` is in `.gitignore` and never committed
- [ ] Considered adding Cloudflare Access (free) in front of the tunnel to require login before anyone reaches the lab — strongly recommended since this exposes Metasploit/Kali to the internet
