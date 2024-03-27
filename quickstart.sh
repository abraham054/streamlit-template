#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
source utils.sh
assert_outside_container

# Assert not root
if (( EUID == 0 )); then
  color_print $red "Please run this script without sudo."
  exit 1
fi

assert_fs_supports_exec_permission

# Install docker and docker-compose
./docker-install.sh

# Build and start the containers
title_print 'Building containers...'


docker-compose build --no-cache && docker-compose down

# # Now that the image is built, set virtual_env in .env:
# env_file='.env'
# # VIRTUAL_ENV must be unset for poetry to generate the path itself
# virtual_env=$(echo "docker-compose run --rm -T django env --unset=VIRTUAL_ENV poetry env info --path" | newgrp docker)
# sed -i "s|{{virtual_env}}|$virtual_env|g" $env_file

# # Set vscode to use python in poetry env
# mkdir -p .vscode
# if [[ ! -f .vscode/settings.json ]]; then
#   echo \
# "{
#   \"python.defaultInterpreterPath\": \"$virtual_env/bin/python\",
# }" > .vscode/settings.json
# fi

# Finally create and start the containers:
docker-compose up --detach

# Done
color_print $green 'Completed!'

if [ -f quickstart-messages.log ]; then
  color_print $yellow "$(cat quickstart-messages.log)"
  rm quickstart-messages.log
fi

color_print $green 'After rebooting if required,
- Open this folder in VSCode
- Click "Install" when prompted to install the recommended extensions for this repository
- Then click "Reopen in Container" when prompted (or press F1 and choose "Reopen in Container")'

# Then in a VSCode terminal run "npm start",
# and in another terminal, run "djs" and access the site at http://localhost:8000'
