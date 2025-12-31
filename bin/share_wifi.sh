#!/bin/bash

# Variables
HOTSPOT_NAME="MySharedWiFi"
HOTSPOT_PASS="MyPassword123"
HOTSPOT_IF="wlo1ap"
INTERNET_IF="wlo1"

# Create virtual interface
sudo ip link add link $INTERNET_IF name $HOTSPOT_IF type macvlan
sudo ip addr add 192.168.50.1/24 dev $HOTSPOT_IF
sudo ip link set $HOTSPOT_IF up

# Configure hostapd on the fly
sudo bash -c "cat > /tmp/hostapd.conf <<EOL
interface=$HOTSPOT_IF
driver=nl80211
ssid=$HOTSPOT_NAME
hw_mode=g
channel=6
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$HOTSPOT_PASS
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
EOL"

# Start hostapd
sudo hostapd /tmp/hostapd.conf -B

# Configure dnsmasq DHCP
sudo bash -c "cat > /tmp/dnsmasq.conf <<EOL
interface=$HOTSPOT_IF
dhcp-range=192.168.50.10,192.168.50.100,12h
EOL"

sudo dnsmasq -C /tmp/dnsmasq.conf

# Enable NAT
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o $INTERNET_IF -j MASQUERADE
sudo iptables -A FORWARD -i $INTERNET_IF -o $HOTSPOT_IF -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $HOTSPOT_IF -o $INTERNET_IF -j ACCEPT

echo "Hotspot $HOTSPOT_NAME is running! Connect with password: $HOTSPOT_PASS"

