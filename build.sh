set -e

[ ! -f linuxdeploy-x86_64.AppImage ] && wget -q https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage -O linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage

rm -rf AppDir Telegram

wget -c "https://telegram.org/dl/desktop/linux" --trust-server-names
tar xf tsetup.*.tar.xz

VERSION=$(ls tsetup.*.tar.xz | sed 's|tsetup.||;s|.tar.xz||')
echo "$VERSION" > VERSION

wget -q https://github.com/balbeko/telegram-desktop-bin-aur/raw/master/telegram-desktop-bin.png -O telegram.png 2>/dev/null || \
wget -q https://raw.githubusercontent.com/telegramdesktop/tdesktop/dev/Telegram/Resources/art/icon256.png -O telegram.png

mkdir -p AppDir/usr/bin
cp Telegram/Telegram AppDir/usr/bin/telegram-desktop

mkdir -p AppDir/usr/share/metainfo
cp com.telegram.desktop.appdata.xml AppDir/usr/share/metainfo/

REPO="${GITHUB_REPOSITORY:-vgovras/telegram-appimage}"
ZSYNC_NAME="Telegram-${VERSION}-x86_64.AppImage.zsync"
UPDATE_URL="zsync|https://github.com/${REPO}/releases/download/v${VERSION}/${ZSYNC_NAME}"

export LDAI_UPDATE_INFORMATION="$UPDATE_URL"
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
