diffpdf
=======

DiffPDF is used to compare two PDF files—textually or visually.

DiffPDF can compare two PDF files. It offers three comparison modes: Words, Characters, and Appearance.

By default the comparison is of the words on each pair of pages, but comparing character by character is also supported (e.g., for logographic languages). And there's also support for comparing the pages by appearance (for example, if a diagram is changed or if a paragraph is reformatted, or a font changed). It is also possible to compare particular pages or page ranges. For example, if there are two versions of a PDF file, one with pages 1-12 and the other with pages 1-13 because of an extra page having been added as page 4, they can be compared by specifying two page ranges, 1-12 for the first and 1-3, 5-13 for the second. This will make DiffPDF compare pages in the pairs (1, 1), (2, 2), (3, 3), (4, 5), (5, 6), and so on, to (12, 13). Version 1.5.0 added the ability to save a PDF file that shows the pages that differ with their differences highlighted. Version 2.0.0 added support for margin exclusion and improved dock window handling. Version 2.1.0 added support for drag and drop, bug fixes, and French and German translations.


fork from: http://www.qtrac.eu/diffpdf-foss.html

for the last windows 32 version prebuilt, visit http://soft.rubypdf.com/software/diffpdf

for build OS X version please use cmd: ./build_osx.sh

requirements: 
- brew install poppler-qt5
- brew install qt@5

if the build script throws errors that qt or poppler is not found, run
```
brew info qt@5
brew info poppler-qt5
```

and change the path for the `chmod`s in `./build_osx.sh` (and maybe also `HOMEBREW_QT5_PATH`, `POPPLER_PATH`)

my path is `/opt/homebrew/Cellar/qt@5`, found in

```
# brew info qt@5
==> qt@5: stable 5.15.16 (bottled) [keg-only]
Cross-platform application and UI framework
https://www.qt.io/
Installed
/opt/homebrew/Cellar/qt@5/5.15.16 (10,849 files, 341.6MB) <---- path /opt/homebrew/Cellar/qt@5
```
