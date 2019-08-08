#!/usr/bin/env bash
sudo reflector \
    --verbose \
    --latest 40 \
    --number 10 \
    --sort rate \
    --protocol https \
    --country "United States" \
    --save /etc/pacman.d/mirrorlist
