# En tu PC
cat > install/surfsense-install.sh << 'EOF'
#!/usr/bin/env bash
# Copyright (c) 2021-2026 community-scripts ORG
# Author: danielsm107
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/MODSetter/SurfSense

# shellcheck source=/dev/null
source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl ca-certificates gnupg
msg_ok "Installed Dependencies"

msg_info "Installing Docker CE"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" >/etc/apt/sources.list.d/docker.list
$STD apt-get update
$STD apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
systemctl enable -q --now docker
msg_ok "Installed Docker CE"

msg_info "Pulling SurfSense image (this may take a few minutes)"
$STD docker pull ghcr.io/modsetter/surfsense:latest
msg_ok "Pulled SurfSense image"

msg_info "Starting SurfSense"
$STD docker run -d --name surfsense --restart unless-stopped -p 3000:3000 -p 8000:8000 -v surfsense-data:/data ghcr.io/modsetter/surfsense:latest
echo "latest" >/opt/surfsense_version.txt
msg_ok "Started SurfSense"

motd_ssh
customize
EOF
