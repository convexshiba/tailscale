#!/usr/bin/env bash

/render/tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
PID=$!

until /render/tailscale up --authkey="${TAILSCALE_AUTHKEY}" --advertise-exit-node --hostname="${TAILSCALE_MACHINE_NAME}"; do
  sleep 0.1
done
export ALL_PROXY=socks5://localhost:1055/
tailscale_ip=$(/render/tailscale ip)
echo "Tailscale is up at IP ${tailscale_ip}"

wait ${PID}
