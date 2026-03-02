#!/bin/bash
set -e

# Default to UID/GID 1000 if not provided
USER_ID=${PUID:-1000}
GROUP_ID=${PGID:-1000}
USER_NAME="user_${USER_ID}"
GROUP_NAME="group_${GROUP_ID}"

echo "Matching container user to host UID: $USER_ID, GID: $GROUP_ID"

# 1. Create or identify the group
if ! getent group "$GROUP_ID" >/dev/null; then
    groupadd -g "$GROUP_ID" "$GROUP_NAME"
fi

# 2. Create or identify the user
if ! getent passwd "$USER_ID" >/dev/null; then
    useradd -u "$USER_ID" -g "$GROUP_ID" -m -s /bin/bash "$USER_NAME"
    ACTUAL_USER="$USER_NAME"
else
    ACTUAL_USER=$(getent passwd "$USER_ID" | cut -d: -f1)
fi

# 3. Fix permissions for the mapped path (optional - comment out if volume is large)
TARGET_DIR="/app/UltraSinger/src/output"
if [ -d "$TARGET_DIR" ]; then
    chown -R "$USER_ID:$GROUP_ID" "$TARGET_DIR"
    chown -R "$USER_ID:$GROUP_ID" /home/appuser/.cache
fi

whisper_x_upgrade_marker=/home/appuser/.whisperx-startup-upgrade-complete
if [ ! -f $whisper_x_upgrade_marker ]; then
    # upgrade checkpoint file on first startup
    echo "Upgrading WhisperX checkpoint file on initial startup"
    if ls /dev/nvidia* >/dev/null 2>&1; then
        echo "NVIDIA GPU detected"
        gosu "$ACTUAL_USER" python3 -m pytorch_lightning.utilities.upgrade_checkpoint \
            ../.venv/lib/python3.10/site-packages/whisperx/assets/pytorch_model.bin
    else
        echo "No NVIDIA GPU detected, mapping to CPU"
        gosu "$ACTUAL_USER" python3 -m pytorch_lightning.utilities.upgrade_checkpoint \
            ../.venv/lib/python3.10/site-packages/whisperx/assets/pytorch_model.bin \
            --map-to-cpu
    fi
    touch $whisper_x_upgrade_marker
else
    echo "WhisperX checkpoint upgrade already done, skipping"
fi

if [ "$#" -eq 0 ]; then
    gosu "$ACTUAL_USER" python3 /app/UltraSinger/src/UltraSinger.py "$@" || true
    echo "No arguments given, keeping container alive"
    exec sleep infinity
elif [ "$1" = "shell" ]; then
    echo "Spawning shell as $ACTUAL_USER"
    exec gosu "$ACTUAL_USER" /bin/bash
elif [ "$1" = "root" ]; then
    echo "Spawning root shell"
    exec /bin/bash
else
    echo "Running UltraSinger with args '$*'"
    exec gosu "$ACTUAL_USER" python3 /app/UltraSinger/src/UltraSinger.py --musescore_path /usr/bin/musescore "$@"
fi
