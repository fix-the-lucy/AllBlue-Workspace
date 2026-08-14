FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# --- Base desktop + VNC stack ---
RUN apt-get update && apt-get install -y \
    kali-desktop-xfce \
    tightvncserver \
    dbus-x11 \
    sudo curl wget git nano \
    net-tools \
    && apt-get clean

# --- Core security tools ---
# NOTE: kali-linux-headless / kali-linux-default pulls a LOT of tools and is large.
# Start with a focused set, expand as needed for your hackathon scope.
RUN apt-get update && apt-get install -y \
    nmap \
    metasploit-framework \
    burpsuite \
    wireshark \
    sqlmap \
    hydra \
    john \
    nikto \
    gobuster \
    netcat-traditional \
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
