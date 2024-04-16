---
apt:
  sources:
    tailscale.list:
      source: "https://pkgs.tailscale.com/stable/ubuntu jammy main"
      keyid: 2596A99EAAB33821893C0A79458CA832957F5868
packages:
  - tailscale
runcmd:
  - "echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf"
  - "echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf"
  - "sysctl -p /etc/sysctl.conf"
  - "tailscale up -authkey ${tailscale_auth_key}"
  - "tailscale set --ssh
