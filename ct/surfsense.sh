#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts ORG

# Author: danielsm107

# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE

# Source: https://github.com/MODSetter/SurfSense



# shellcheck source=/dev/null

source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)

INSTALL_SCRIPT="https://raw.githubusercontent.com/danielsm107/ProxmoxVED/feat/surfsense/install/surfsense-install.sh"

APP="SurfSense"

var_tags="${var_tags:-ai;docker;llm}"

var_cpu="${var_cpu:-2}"

var_ram="${var_ram:-2048}"

var_disk="${var_disk:-10}"

var_os="${var_os:-debian}"

var_version="${var_version:-12}"

var_unprivileged="${var_unprivileged:-1}"



header_info "$APP"

variables

color

catch_errors



function update_script() {

  header_info

  check_container_storage

  check_container_resources



  if [[ ! -f /opt/surfsense_version.txt ]]; then

    msg_error "No ${APP} Installation Found!"

    exit

  fi



  msg_info "Updating ${APP}"

  $STD docker pull ghcr.io/modsetter/surfsense:latest

  $STD docker stop surfsense

  $STD docker rm surfsense
  # shellcheck disable=SC2215
  $STD docker run -d --name surfsense --restart unless-stopped -p 3000:3000 -p 8000:8000 -v surfsense-data:/data ghcr.io/modsetter/surfsense:latest
  echo "latest" >/opt/surfsense_version.txt

  msg_ok "Updated ${APP}"



  msg_ok "Updated successfully!"

  exit

}



start

build_container

description



msg_ok "Completed successfully!\n"

echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"

echo -e "${INFO}${YW} Access SurfSense at the following URL:${CL}"

echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:3000${CL}"

echo -e "${INFO}${YW} API documentation available at:${CL}"

echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:8000/docs${CL}"

