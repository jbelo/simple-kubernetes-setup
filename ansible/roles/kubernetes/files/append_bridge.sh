cat >> /etc/network/interfaces << EOF

# setup kubernetes bridge
auto cbr0
iface cbr0 inet static
      address $1
      netmask 255.255.255.0
      bridge_ports eth1
EOF
