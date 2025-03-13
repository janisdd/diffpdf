#/bin/bash
set -o errexit
set -o pipefail

# brew install poppler-qt5
# brew install qt@5

# install dependency
which brew 1>/dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew list qt@5 1>/dev/null || brew install qt@5
brew list poppler 1>/dev/null || brew install poppler-qt5
# check poppler installed with required option
# (brew info poppler | grep -- 'Built from source' | grep -- '--with-qt' 1>/dev/null) \
# || (echo 'you should install poppler with option! try this: brew uninstall poppler && brew install poppler-qt5'; exit 1)

# Dirs must be writeable because macdeployqt modifies copied files
chmod -R u+w /opt/homebrew/Cellar/qt@5
chmod -R u+w /opt/homebrew/Cellar/poppler-qt5/

# Use Homebrew's Qt installation explicitly
HOMEBREW_QT5_PATH="/opt/homebrew/opt/qt@5"
POPPLER_PATH="/opt/homebrew/opt/poppler-qt5"
export PATH="$HOMEBREW_QT5_PATH/bin:$PATH"
export QMAKESPEC="macx-clang"

# Create a custom .pro file with correct paths
cat > diffpdf_mac.pro << EOF
include(diffpdf.pro)

# Override include paths for macOS
INCLUDEPATH -= /usr/local/include/poppler/cpp
INCLUDEPATH -= /usr/local/include/poppler/qt4
INCLUDEPATH += $POPPLER_PATH/include/poppler/cpp
INCLUDEPATH += $POPPLER_PATH/include/poppler/qt5

# Add Qt frameworks
INCLUDEPATH += $HOMEBREW_QT5_PATH/include
INCLUDEPATH += $HOMEBREW_QT5_PATH/include/QtWidgets
INCLUDEPATH += $HOMEBREW_QT5_PATH/include/QtGui
INCLUDEPATH += $HOMEBREW_QT5_PATH/include/QtCore
INCLUDEPATH += $HOMEBREW_QT5_PATH/include/QtPrintSupport

# Update libs
LIBS -= -lpoppler-qt4
LIBS += -L$POPPLER_PATH/lib -lpoppler-qt5 -lpoppler
LIBS += -F$HOMEBREW_QT5_PATH/lib -framework QtWidgets -framework QtGui -framework QtCore -framework QtPrintSupport

# Add CONFIG options
CONFIG += sdk_no_version_check
DEFINES += QT_NO_DEPRECATED_WARNINGS
EOF

$HOMEBREW_QT5_PATH/bin/lrelease diffpdf.pro
$HOMEBREW_QT5_PATH/bin/qmake -spec macx-clang CONFIG+=sdk_no_version_check diffpdf_mac.pro
make

# Here's how to make a .dmg:

# Fix references, remove unneeded Frameworks and build DMG
$HOMEBREW_QT5_PATH/bin/macdeployqt diffpdf_mac.app/

codesign --force --deep --sign - diffpdf_mac.app
codesign --verify --deep --verbose diffpdf_mac.app

cd diffpdf_mac.app/Contents/Frameworks/
echo -- 'this cmd could be useful for old versions of qt:' \
rm -r QtDeclarative.framework/ QtNetwork.framework/ \
QtScript.framework/ QtSql.framework/ QtXmlPatterns.framework/ 2>/dev/null || true
cd ../../..
ver="$(head -n 1 CHANGES)"
rm -f "diffpdf-$ver.dmg"
hdiutil create "diffpdf-$ver.dmg" -srcfolder diffpdf_mac.app/
