#!/bin/bash

# Path to the mpv IPC socket
SOCKET="/tmp/mpvsocket"

# Function to check if mpv is actually listening
is_mpv_running() {
    # Try sending a ping command to the socket
    echo '{ "command": ["get_property", "filename"] }' | socat - "$SOCKET" 2>/dev/null 
    return $?  # 0 = running, 1 = not running
}

# Loop through all arguments (supports multiple files)
for FILE in "$@"; do
    EXT="${FILE##*.}"  # Get the file extension

    if  is_mpv_running; then
        if [[ "$EXT" == "srt" || "$EXT" == "ass" ]]; then
            # Load subtitle file into the running mpv
            echo "{ \"command\": [\"sub-add\", \"$FILE\"] }" | socat - "$SOCKET"
        else
            # Load video file and replace the current playback
            echo "{ \"command\": [\"loadfile\", \"$FILE\", \"replace\"] }" | socat - "$SOCKET"
        fi
    else
      [ -S "$SOCKET" ] && rm "$SOCKET"
      
        # No mpv instance is running
        if [[ "$EXT" == "srt" || "$EXT" == "ass" ]]; then
            echo "No mpv instance is running. Cannot load subtitle alone."
            exit 1
        else
            # Start mpv with IPC enabled
            mpv --input-ipc-server="$SOCKET" "$FILE"
        fi
    fi
done
