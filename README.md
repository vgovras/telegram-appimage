# Telegram AppImage

Unofficial Telegram Desktop AppImage for Linux.

## Installation

1. Download the latest `Telegram-*.AppImage` from [Releases](https://github.com/vgovras/telegram-appimage/releases)
2. Make it executable:
   ```bash
   chmod +x Telegram-*.AppImage
   ```
3. Run it:
   ```bash
   ./Telegram-*.AppImage
   ```

## Building Locally

1. Install dependencies: `wget`, `curl`, `tar`
2. Download `linuxdeploy-x86_64.AppImage` and place it in the repository root
3. Run:
   ```bash
   ./build.sh
   ```

## Auto-Update

The AppImage includes update information pointing to GitHub Releases. Use AppImageUpdate or similar tools to check for updates.

## Validating AppStream Metadata

To validate the AppStream metadata file:

```bash
sudo apt-get install appstream
appstreamcli validate com.telegram.desktop.appdata.xml
```
