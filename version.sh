#!/bin/bash
curl -I "https://telegram.org/dl/desktop/linux" 2>&1 | grep -i "location:" | sed 's|.*tsetup\.||;s|\.tar\.xz.*||'

