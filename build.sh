set -e

[ ! -f linuxdeploy-x86_64.AppImage ] && wget -q https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage -O linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage

rm -rf AppDir Telegram

# Download Telegram Desktop
wget -c "https://telegram.org/dl/desktop/linux" --trust-server-names
tar xf tsetup.*.tar.xz

# Extract version from tarball filename
VERSION=$(ls tsetup.*.tar.xz | sed 's|tsetup.||;s|.tar.xz||')
echo "$VERSION" > VERSION

# Download icon
wget -c https://github.com/balbeko/telegram-desktop-bin-aur/raw/master/telegram-desktop-bin.png -O telegram.png || \
  wget -c https://raw.githubusercontent.com/telegramdesktop/tdesktop/dev/Telegram/Resources/art/icon256.png -O telegram.png

# Prepare AppDir
mkdir -p AppDir/usr/bin
cp Telegram/Telegram AppDir/usr/bin/telegram-desktop

mkdir -p AppDir/usr/share/metainfo
cp com.telegram.desktop.appdata.xml AppDir/usr/share/metainfo/

export LDAI_UPDATE_INFORMATION="gh-releases-zsync|vgovras|telegram-appimage|latest|Telegram-*.AppImage.zsync"
NO_STRIP=1 LINUXDEPLOY_OUTPUT_VERSION=$VERSION ./linuxdeploy-x86_64.AppImage \
  --appdir AppDir \
  --executable AppDir/usr/bin/telegram-desktop \
  --desktop-file telegram.desktop \
  --icon-file telegram.png \
  --output appimage

appimage=$(find . -name "*.AppImage" ! -name "linuxdeploy-*.AppImage" | head -1)
if command -v zsyncmake >/dev/null 2>&1; then
  zsyncmake "$appimage"
fi
