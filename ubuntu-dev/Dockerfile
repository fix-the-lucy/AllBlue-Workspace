FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# --- Base desktop + VNC stack (so it's visible in Guacamole) ---
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    tightvncserver \
    dbus-x11 \
    sudo curl wget git unzip nano \
    net-tools \
    && apt-get clean

# --- Programming languages / toolchains ---
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv \
    default-jdk \
    gcc g++ make cmake gdb \
    && apt-get clean

# --- VS Code (desktop version, in addition to code-server) ---
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/vscode.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list \
    && apt-get update && apt-get install -y code || true \
    && apt-get clean

# --- VNC setup ---
RUN mkdir -p /root/.vnc
COPY xstartup /root/.vnc/xstartup
RUN chmod +x /root/.vnc/xstartup

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /root/workspace
EXPOSE 5901

ENTRYPOINT ["/entrypoint.sh"]
