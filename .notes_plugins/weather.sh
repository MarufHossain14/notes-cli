#!/usr/bin/env bash
# Weather plugin for Notes CLI

echo "🌤️  Current Weather:"
if command -v curl &>/dev/null; then
    # Try to get weather with timeout
    weather=$(timeout 5s curl -s 'wttr.in/?format=3' 2>/dev/null)
    if [[ $? -eq 0 && -n "$weather" ]]; then
        echo "$weather"
    else
        echo "  Unable to fetch weather data"
    fi
else
    echo "  curl not available for weather data"
fi
