#!/bin/bash

cat /etc/hosts | while read -r ip host rest; do
    [[ -z "$ip" || "$ip" == \#* ]] && continue

    dns_ip=""

    while read -r label val; do
        if [[ "$label" == "Address:" ]]; then
            dns_ip="$val"
        fi
    done < <(nslookup "$host" 2>/dev/null)

    if [[ -n "$dns_ip" && "$ip" != *"$dns_ip"* ]]; then
        echo "Bogus IP for $host in /etc/hosts!"
    fi
done
