#!/usr/bin/env bash
# Network plugin for Notes CLI

echo "🌐 Network Status:"

# Check internet connectivity
if command -v ping &>/dev/null; then
    if ping -c 1 8.8.8.8 &>/dev/null; then
        echo "  Internet: ✅ Connected"
        
        # Get public IP if available
        if command -v curl &>/dev/null; then
            public_ip=$(timeout 3s curl -s ifconfig.me 2>/dev/null)
            if [[ -n "$public_ip" ]]; then
                echo "  Public IP: $public_ip"
            fi
        fi
    else
        echo "  Internet: ❌ Disconnected"
    fi
fi

# Show local IP
if command -v ip &>/dev/null; then
    local_ip=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $7; exit}')
    if [[ -n "$local_ip" ]]; then
        echo "  Local IP: $local_ip"
    fi
elif command -v ifconfig &>/dev/null; then
    local_ip=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
    if [[ -n "$local_ip" ]]; then
        echo "  Local IP: $local_ip"
    fi
fi
