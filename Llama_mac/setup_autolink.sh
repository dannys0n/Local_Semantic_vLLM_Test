#!/usr/bin/env bash
# @desc: run this before start script. DO NOT CONNECT TO ROUTER
# @category: linux
# ==========================================

# USAGE: sudo bash setup_autolink.sh
# PURPOSE: Temporarily enables a DHCP server on the ethernet port.
#          Reverts to normal automatically when you press Ctrl+C.

if [[ "$EUID" -ne 0 ]]; then
   echo "❌ Run as root (sudo)."
   exit 1
fi

# 1. Detect Interface
INTERFACE=$(ip -o link show | awk -F': ' '$2 !~ /^lo|^wl|^docker|^br/ {print $2}' | head -n 1)
if [ -z "$INTERFACE" ]; then
    echo "❌ No Ethernet interface found. Plug in the cable first!"
    exit 1
fi

# --- THE TRAP FUNCTION (The Safety Net) ---
# This runs automatically when the script exits (Ctrl+C, crash, or normal exit)
cleanup() {
    echo ""
    echo "====================================================="
    echo "   🛑 STOPPING & REVERTING..."
    echo "====================================================="

    # Check if the connection exists and delete it
    if nmcli connection show "LlamaLink" &> /dev/null; then
        echo ">>> Deleting 'LlamaLink' profile..."
        nmcli connection delete "LlamaLink"
    fi

    echo "✅ Reverted to normal. Ethernet is standard again."
}

# Register the trap to catch EXIT, SIGINT (Ctrl+C), and SIGTERM
trap cleanup EXIT SIGINT SIGTERM

echo ">>> Detecting Interface: $INTERFACE"

# 2. Check for conflicts
EXISTING=$(nmcli -t -f NAME,DEVICE connection show | grep "$INTERFACE" | cut -d: -f1)
if [ -n "$EXISTING" ]; then
    echo ">>> Note: Temporarily overriding '$EXISTING'"
fi

# 3. Create the Temporary Profile
echo ">>> Creating 'LlamaLink' (Shared DHCP Mode)..."
# We add autoconnect=yes so it triggers immediately
nmcli connection add type ethernet \
    ifname "$INTERFACE" \
    con-name "LlamaLink" \
    ipv4.method shared \
    ipv6.method ignore \
    connection.autoconnect yes > /dev/null

echo ">>> Activating..."
nmcli connection up "LlamaLink" > /dev/null

echo "====================================================="
echo "   ✅ LLAMA LINK ACTIVE (Session Mode)"
echo "====================================================="
echo "   Master IP: 10.42.0.1"
echo "   Worker IP: Automatic (DHCP)"
echo ""
echo "   ⚡  THIS CONNECTION IS TEMPORARY  ⚡"
echo "   Keep this terminal window OPEN."
echo "   Press [Ctrl+C] to stop the network and revert changes."
echo "====================================================="

# 4. The Loop (Keeps the script alive)
# We just wait forever until the user kills the script
while true; do
    sleep 1
done
