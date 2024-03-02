#!/bin/bash
sleep 2

cd /home/container

# Update Rust Server
./steam/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update 258550 +quit

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

if [ -f OXIDE_FLAG ] || [ "${OXIDE}" = 1 ]; then
    echo "Updating OxideMod..."
    curl -sSL "https://github.com/OxideMod/Oxide/releases/download/latest/Oxide-Rust.zip" > oxide.zip
    unzip -o -q oxide.zip
    rm oxide.zip
    echo "Done updating OxideMod!"
fi

# Fix for Rust not starting
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:$(pwd):/home/container/RustDedicated_Data/Plugins/x86_64"

# Run the Server
node /wrapper.js "${MODIFIED_STARTUP}"
