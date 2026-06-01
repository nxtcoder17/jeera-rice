#! /usr/bin/env bash

hotspot_name="SkyNet"
hotspot_password="lkjhg1234"

ifname=$(nmcli device status | awk '$2 == "wifi"{print $1}')

log() {
  echo "[#] $*"
}

log_error() {
  echo "[# ERROR] $*"
}

# Ensure interface exists
if [ -z "$ifname" ]; then
  log_error "No Wi-Fi interface found."
  exit 1
fi

echo "Using interface: $ifname"

log "enabling IPv4 forwarding"
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'

log "stopping dnsmasq"
sudo systemctl stop dnsmasq

# Delete old hotspot if it exists
log "Cleaning Old Hotspots (if existing)"
nmcli connection down Hotspot 2>/dev/null || true
nmcli connection delete Hotspot 2>/dev/null || true

# Create hotspot
log "Creating Hotspot"
nmcli dev wifi hotspot \
  ifname "$ifname" \
  ssid "$hotspot_name" \
  password "$hotspot_password" \
  band bg

# Ensure IPv4 sharing is enabled
nmcli connection modify Hotspot ipv4.method shared
nmcli connection up Hotspot

log "Hotspot '$hotspot_name' started successfully."

nmcli dev wifi show-password
