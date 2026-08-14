# AllBlue 🔵

**A self-hosted, browser-accessible penetration testing lab — access a full Kali Linux + dev environment from any device (laptop, phone, tablet) with nothing to install locally.**

![Platform](https://img.shields.io/badge/platform-Docker-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-in--development-yellow)

---

## ⚠️ Responsible Use

This project is intended for **educational purposes and authorized security testing only**.
Do not use these tools against systems you don't own or don't have explicit written permission to test.
The maintainers are not responsible for any misuse of this software. By using AllBlue, you agree to use it ethically and legally.

---

## What is AllBlue?

AllBlue packages a full security research environment (Kali Linux, Metasploit, nmap, Burp Suite, etc.) and a full coding environment (VS Code, Python, Java, C/C++) into one Docker Compose stack. You deploy it once on a server, mini-PC, or Raspberry Pi — and then access it from **any browser, on any device**, with no native installation required on the client side.

```
[Your Server / Pi / VPS]
   ├── Kali Linux container (tools pre-installed)
   ├── code-server (VS Code in browser)
   └── Guacamole (remote desktop gateway)
            │
            ▼
   [Any browser: Windows / macOS / Linux / Android / iOS]
```

## Features

- 🖥️ Full Kali Linux desktop, accessible from a browser tab
- 💻 VS Code (code-server) with Python, Java, C, C++ preconfigured
- 📱 Works on phones and tablets — no app install needed
- 🔒 HTTPS + authentication out of the box
- 🐳 One-command deployment via Docker Compose
- 🔧 Easily extensible — add your own tools/images

## Quick Start

```bash
git clone https://github.com/fix-the-lucy/AllBlue-Workspace.git
cd allblue
cp .env.example .env   # edit with your own secrets
docker-compose up -d
```

Then open `Cloudflared Link >` in any browser.

## Requirements

- Docker & Docker Compose
- A host machine (Raspberry Pi 4/5, mini-PC, old laptop, or a cloud VPS)
- (Optional) A domain name for HTTPS via Let's Encrypt

## Architecture

| Component | Purpose |
|---|---|
| `kali` | Kali Linux container with Metasploit, nmap, Burp Suite, etc. |
| `code-server` | Browser-based VS Code with dev toolchains |
| `guacamole` + `guacd` | Clientless remote desktop gateway (RDP/VNC/SSH → browser) |
| `nginx` | Reverse proxy, routes traffic, handles HTTPS |
| `mysql` | Guacamole's connection/auth database |

## Roadmap

- [ ] Core Docker Compose stack (Kali + code-server)
- [ ] Guacamole integration for remote desktop access
- [ ] HTTPS + auth hardening
- [ ] Mobile-optimized landing dashboard
- [ ] One-click deploy scripts (Pi / VPS)
- [ ] CTF challenge templates

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a PR.

## License

This project is licensed under the [MIT License](LICENSE).
