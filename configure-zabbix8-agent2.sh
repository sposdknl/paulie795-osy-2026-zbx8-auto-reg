#!/bin/bash
set -euo pipefail

config=/etc/zabbix/zabbix_agent2.conf
name_file=/var/lib/zabbix/spos-hostname

install -d -m 0755 /var/lib/zabbix
if [ ! -s "$name_file" ]; then
  id=$(tr -d '-' < /proc/sys/kernel/random/uuid | cut -c1-12)
  printf 'spos-debian-podzimek_pavel-%s\n' "$id" > "$name_file"
  chmod 0644 "$name_file"
fi
hostname=$(cat "$name_file")
if ! printf '%s\n' "$hostname" | grep -Eq '^spos-debian-podzimek_pavel-[[:xdigit:]]{12}$'; then
  echo "Neplatny ulozeny nazev hosta: $hostname" >&2
  exit 1
fi

if [ ! -f "${config}.orig" ]; then
  cp -p "$config" "${config}.orig"
fi

sed -i -E '/^[[:space:]#]*(Hostname|Server|ServerActive|HostMetadata)=/d' "$config"
cat >> "$config" <<EOF2

Hostname=$hostname
Server=enceladus.pfsense.cz
ServerActive=enceladus.pfsense.cz
HostMetadata=SPOS
EOF2

systemctl enable zabbix-agent2
systemctl restart zabbix-agent2
systemctl is-active zabbix-agent2
printf 'Zabbix agent 2 bezi jako %s\n' "$hostname"
