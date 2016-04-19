#/bin/bash
set -o errexit
set -o pipefail

# install dependency
which brew 1>/dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
brew list qt 1>/dev/null || brew install qt
brew list poppler 1>/dev/null || brew install poppler --with-qt
# check poppler installed with required option
(brew info poppler | grep -- 'Built from source' | grep -- '--with-qt' 1>/dev/null) \
|| (echo 'you should install poppler with option! try this: brew uninstall poppler && brew install poppler --with-qt'; exit 1)

# Dirs must be writeable because macdeployqt modifies copied files
chmod -R u+w /usr/local/Cellar/qt/
chmod -R u+w /usr/local/Cellar/poppler/

lrelease diffpdf.pro
qmake -spec macx-g++
make

# Here's how to make a .dmg:

# Fix references, remove unneeded Frameworks and build DMG
macdeployqt diffpdf.app/
cd diffpdf.app/Contents/Frameworks/
echo -- 'this cmd could be useful for old versions of qt:' \
rm -r QtDeclarative.framework/ QtNetwork.framework/ \
QtScript.framework/ QtSql.framework/ QtSvg.framework/ \
QtXmlPatterns.framework/
cd ../../..
ver="$(head -n 1 CHANGES)"
rm -f "diffpdf-$ver.dmg"
hdiutil create "diffpdf-$ver.dmg" -srcfolder diffpdf.app/
