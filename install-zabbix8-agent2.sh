#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

installed=$(dpkg-query -W -f='${Version}' zabbix-agent2 2>/dev/null || true)
case "$installed" in
  *:8.*|8.*)
    echo "zabbix-agent2 $installed je jiz nainstalovan, preskakuji instalaci."
    ;;
  *)
    if [ -n "$installed" ]; then
      systemctl stop zabbix-agent2 || true
      apt-get purge -y zabbix-agent2 zabbix-release || true
    fi

    cd /tmp
    for u in \
      https://repo.zabbix.com/zabbix/8.0/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_8.0+debian13_all.deb \
      https://repo.zabbix.com/zabbix/8.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_8.0+debian13_all.deb ; do
      wget -qO zabbix-release.deb "$u" && break
    done
    dpkg -i zabbix-release.deb
    rm -f zabbix-release.deb
    apt-get update
    apt-get install -y zabbix-agent2
    ;;
esac

version=$(dpkg-query -W -f='${Version}' zabbix-agent2)
case "$version" in
  *:8.*|8.*) ;;
  *) echo "Neocekavana verze zabbix-agent2: $version" >&2; exit 1 ;;
esac

zabbix_agent2 -V | sed -n 1p
