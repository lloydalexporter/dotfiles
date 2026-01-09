#!/usr/bin/env bash
set -euo pipefail

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'Missing dependency: %s\n' "$1" >&2
    exit 1
  fi
}

need_cmd python3

WORK_VPN_USER="lloyd.porter"

has_fzf() {
  command -v fzf >/dev/null 2>&1
}

choose_one() {
  # Args: prompt, options...
  local prompt="$1"
  shift

  if has_fzf; then
    printf '%s\n' "$@" | fzf --prompt="${prompt}> " --height=40% --reverse
    return
  fi

  printf '%s\n' "$prompt" >&2
  local PS3="Select> "
  select opt in "$@"; do
    if [[ -n "${opt:-}" ]]; then
      printf '%s\n' "$opt"
      return
    fi
    printf 'Invalid selection.\n' >&2
  done
}

totp() {
  # Computes TOTP from a Base32 secret (SHA1 / 6 digits / 30s).
  # Prints 6-digit code to stdout.
  python3 - <<'PY'
import base64, hmac, hashlib, struct, time, os, sys

secret = os.environ.get("WORK_VPN_TOTP_SECRET", "").strip().replace(" ", "")
if not secret:
  print("WORK_VPN_TOTP_SECRET is not set", file=sys.stderr)
  sys.exit(2)

try:
  key = base64.b32decode(secret.upper(), casefold=True)
except Exception as e:
  print(f"Invalid Base32 WORK_VPN_TOTP_SECRET: {e}", file=sys.stderr)
  sys.exit(2)

period = 30
digits = 6
counter = int(time.time()) // period
msg = struct.pack(">Q", counter)
digest = hmac.new(key, msg, hashlib.sha1).digest()
offset = digest[-1] & 0x0F
code_int = (struct.unpack(">I", digest[offset:offset+4])[0] & 0x7FFFFFFF) % (10 ** digits)
print(f"{code_int:0{digits}d}")
PY
}

work_connect() {
  : "${WORK_VPN_CONFIG:?WORK_VPN_CONFIG is not set}"
  : "${WORK_VPN_BASE_PASSWORD:?WORK_VPN_BASE_PASSWORD is not set}"
  : "${WORK_VPN_TOTP_SECRET:?WORK_VPN_TOTP_SECRET is not set}"

  local code password tmp_auth
  code="$(totp)"
  password="${WORK_VPN_BASE_PASSWORD}${code}"

  tmp_auth="$(mktemp)"
  chmod 600 "$tmp_auth"
  trap 'rm -f "$tmp_auth"' RETURN

  printf '%s\n%s\n' "$WORK_VPN_USER" "$password" >"$tmp_auth"

  printf 'Starting Work VPN...\nConfig: %s\nUser: %s\n' "$WORK_VPN_CONFIG" "$WORK_VPN_USER"
  printf 'TOTP: %s (appended)\n' "$code"
  printf '\n'

  sudo openvpn --config "$WORK_VPN_CONFIG" --auth-user-pass "$tmp_auth"
}

pia_connect() {
  : "${PIA_DIR:?PIA_DIR is not set}"
  local glob selected
  glob="${PIA_GLOB:-*.ovpn}"

  mapfile -t pia_files < <(
    find "$PIA_DIR" -maxdepth 1 -type f -name "$glob" -print 2>/dev/null | sort
  )

  if (( ${#pia_files[@]} == 0 )); then
    printf 'No matching PIA configs found in %s (glob: %s)\n' "$PIA_DIR" "$glob" >&2
    exit 1
  fi

  selected="$(choose_one "PIA config" "${pia_files[@]}")"

  [[ -n "$selected" ]] || exit 0

  if [[ -n "${PIA_AUTH_FILE:-}" ]]; then
    printf 'Starting PIA OpenVPN...\nConfig: %s\nAuth file: %s\n\n' "$selected" "$PIA_AUTH_FILE"
    sudo openvpn --config "$selected" --auth-user-pass "$PIA_AUTH_FILE"
  else
    printf 'Starting PIA OpenVPN...\nConfig: %s\n\n' "$selected"
    sudo openvpn --config "$selected"
  fi
}

netbird_up() {
  need_cmd netbird
  printf 'netbird up\n\n'
  netbird up
}

netbird_down() {
  need_cmd netbird
  printf 'netbird down\n\n'
  netbird down
}

main() {
  local choice
  choice="$(choose_one "VPN" \
    "Work VPN" \
    "PIA VPN (choose .ovpn)" \
    "NetBird up" \
    "NetBird down" \
  )"

  case "$choice" in
    "Work VPN") work_connect ;;
    "PIA VPN (choose .ovpn)") pia_connect ;;
    "NetBird up") netbird_up ;;
    "NetBird down") netbird_down ;;
    *) exit 0 ;;
  esac
}

main "$@"


