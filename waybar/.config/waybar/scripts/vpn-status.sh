#!/usr/bin/env bash
set -euo pipefail

# Waybar custom module JSON output: {"text":"…","class":"…","tooltip":"…"}
# - class: down | openvpn | netbird
# - text: icon (Nerd Font / Font Awesome)

umask 077

down_icon=""    # unlocked
up_icon=""      # locked

class="down"
text="$down_icon"
tooltip=$'No VPN\nClick to connect'

nb_status=""
if command -v netbird >/dev/null 2>&1; then
  nb_status="$(netbird status 2>/dev/null || true)"
  if printf '%s' "$nb_status" | grep -qiE 'status:[[:space:]]*connected|[[:space:]]connected([[:space:]]|$)'; then
    class="netbird"
    text="$up_icon"
    tooltip=$'NetBird\n'"$nb_status"
  fi
fi

if [[ "$class" == "down" ]]; then
  tun_ifaces="$(
    ip -o link show 2>/dev/null \
      | awk -F': ' '{print $2}' \
      | grep -E '^(tun|tap)[0-9]+' \
      || true
  )"

  if [[ -n "${tun_ifaces}" ]] || pgrep -x openvpn >/dev/null 2>&1; then
    class="openvpn"
    text="$up_icon"

    if [[ -n "${tun_ifaces}" ]]; then
      ip_info="$(
        while IFS= read -r ifname; do
          [[ -n "$ifname" ]] || continue
          ip -brief addr show dev "$ifname" 2>/dev/null || true
        done <<<"$tun_ifaces"
      )"
      if [[ -n "${ip_info}" ]]; then
        tooltip=$'OpenVPN\n'"$ip_info"
      else
        tooltip=$'OpenVPN\nTunnel interface present'
      fi
    else
      tooltip=$'OpenVPN\nopenvpn process running'
    fi
  fi
fi

export TEXT="$text"
export CLASS="$class"
export TOOLTIP="$tooltip"

python3 - <<'PY'
import json, os
print(json.dumps({
  "text": os.environ.get("TEXT", ""),
  "class": os.environ.get("CLASS", "down"),
  "tooltip": os.environ.get("TOOLTIP", ""),
}))
PY


