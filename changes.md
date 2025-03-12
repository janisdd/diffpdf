
```bash
brew install poppler-qt5

brew info poppler-qt5
# poppler-qt5: stable 25.03.0 (bottled), HEAD [keg-only]
# PDF rendering library (based on the xpdf-3.0 code base)
# https://poppler.freedesktop.org/
# Installed
# /opt/homebrew/Cellar/poppler-qt5/25.03.0 (456 files, 30.9MB)

brew install qt@5

brew info qt@5
# qt@5: stable 5.15.16 (bottled) [keg-only]
# Cross-platform application and UI framework
# https://www.qt.io/
# Installed
# /opt/homebrew/Cellar/qt@5/5.15.16 (10,849 files, 341.6MB)
```

-------------

fixed build_osx.sh via ai (cloude sonnet 3.7 in cursor):

```
When i run "qmake -spec macx-g++" i get the error "Project ERROR: failed to parse default search paths from compiler output"
```



I'll help you troubleshoot the qmake error you're encountering. This error typically occurs when qmake can't properly detect the compiler settings on macOS.
Let's first check what version of Qt and compiler you have installed to better understand the issue.
    ~/u/p/diffpdf►qmake --version
    QMake version 3.1
    Using Qt version 5.15.2 in /opt/homebrew/anaconda3/lib
    ~/u/p/diffpdf► 

I see that you're using Qt 5.15.2 from your Anaconda installation. This could be part of the issue, as the build script is likely expecting to use the Qt version installed via Homebrew.
Let's check if you have the Homebrew Qt installation as well:
    ~/u/p/diffpdf►brew list --versions qt qt@5
    qt 6.8.2
    qt@5 5.15.16
    ~/u/p/diffpdf►

Now let's check the compiler you have installed:
    ~/u/p/diffpdf►g++ --version                                                 (base) 0.598s (master|💩?) 18:44
    Apple clang version 16.0.0 (clang-1600.0.26.6)
    Target: arm64-apple-darwin24.3.0
    Thread model: posix
    InstalledDir: /Library/Developer/CommandLineTools/usr/bin
    ~/u/p/diffpdf►    

I see the issue now. You have multiple Qt installations (one from Anaconda and one from Homebrew), and qmake is picking up the Anaconda version, but your build script is expecting to use the Homebrew version.
Let's modify the build script to explicitly use the Homebrew Qt installation. Here's how we'll fix it:

    [build_osx.sh]

Now let's try running the build script with the updated changes:

    chmod +x build_osx.sh && ./build_osx.sh
    Error: No such keg: /opt/homebrew/Cellar/poppler
    Warning: poppler-qt5 25.03.0 is already installed and up-to-date.
    To reinstall 25.03.0, run:
    brew reinstall poppler-qt5
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_cz.qm'...
        Generated 180 translation(s) (179 finished and 1 unfinished)
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_fr.qm'...
        Generated 166 translation(s) (166 finished and 0 unfinished)
        Ignored 14 untranslated source text(s)
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_de.qm'...
        Generated 180 translation(s) (179 finished and 1 unfinished)
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_es.qm'...
        Generated 0 translation(s) (0 finished and 0 unfinished)
        Ignored 180 untranslated source text(s)
    Project WARNING: Qt has only been tested with version 13 of the platform SDK, you're using 15.
    Project WARNING: This is an unsupported configuration. You may experience build issues, and by using
    Project WARNING: the 15.2 SDK you are opting in to new features that Qt has not been prepared for.
    Project WARNING: Please downgrade the SDK you use to build your app to version 13, or configure
    Project WARNING: with CONFIG+=sdk_no_version_check when running qmake to silence this warning.
    /Library/Developer/CommandLineTools/usr/bin/g++ -c -pipe -O2 -std=gnu++11  -arch arm64 -isysroot /Library/De
    veloper/CommandLineTools/SDKs/MacOSX.sdk -mmacosx-version-min=10.13 -Wall -Wextra -fPIC -DQT_NO_DEBUG -DQT_G
    UI_LIB -DQT_CORE_LIB -I. -I/usr/local/include/poppler/cpp -I/usr/local/include/poppler/qt4 -I/opt/homebrew/C
    ellar/qt@5/5.15.16/lib/QtGui.framework/Headers -I/opt/homebrew/Cellar/qt@5/5.15.16/lib/QtCore.framework/Head
    ers -I. -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/OpenGL.framework/Hea
    ders -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/AGL.framework/Headers -
    I/opt/homebrew/Cellar/qt@5/5.15.16/mkspecs/macx-g++ -F/opt/homebrew/Cellar/qt@5/5.15.16/lib -o mainwindow.o
    mainwindow.cpp
    In file included from mainwindow.cpp:12:
    ./aboutform.hpp:15:10: fatal error: 'QDialog' file not found
    15 | #include <QDialog>
        |          ^~~~~~~~~
    1 error generated.
    make: *** [mainwindow.o] Error 1

We're making progress, but now we're encountering a new issue. The compiler can't find the Qt header files. This is likely because the include paths are not correctly set up. Let's check the paths to the Qt headers:
    ls -la /opt/homebrew/Cellar/qt@5/5.15.16/include
    drwxr-xr-x@  7 janis  admin   224 Nov 13 07:22 QtThemeSupport/
    lrwxr-xr-x@  1 janis  admin    35 Nov 13 07:22 QtUiPlugin@ -> ../lib/QtUiPlugin.framework/Headers
    drwxr-xr-x@  9 janis  admin   288 Nov 13 07:22 QtUiTools/
    lrwxr-xr-x@  1 janis  admin    42 Nov 13 07:22 QtVirtualKeyboard@ -> ../lib/QtVirtualKeyboard.framework/Head
    ers
    lrwxr-xr-x@  1 janis  admin    37 Nov 13 07:22 QtWebChannel@ -> ../lib/QtWebChannel.framework/Headers
    lrwxr-xr-x@  1 janis  admin    36 Nov 13 07:22 QtWebEngine@ -> ../lib/QtWebEngine.framework/Headers
    lrwxr-xr-x@  1 janis  admin    40 Nov 13 07:22 QtWebEngineCore@ -> ../lib/QtWebEngineCore.framework/Headers
    lrwxr-xr-x@  1 janis  admin    43 Nov 13 07:22 QtWebEngineWidgets@ -> ../lib/QtWebEngineWidgets.framework/He
    aders
    lrwxr-xr-x@  1 janis  admin    37 Nov 13 07:22 QtWebSockets@ -> ../lib/QtWebSockets.framework/Headers
    lrwxr-xr-x@  1 janis  admin    34 Nov 13 07:22 QtWebView@ -> ../lib/QtWebView.framework/Headers
    lrwxr-xr-x@  1 janis  admin    34 Nov 13 07:22 QtWidgets@ -> ../lib/QtWidgets.framework/Headers
    lrwxr-xr-x@  1 janis  admin    30 Nov 13 07:22 QtXml@ -> ../lib/QtXml.framework/Headers
    lrwxr-xr-x@  1 janis  admin    38 Nov 13 07:22 QtXmlPatterns@ -> ../lib/QtXmlPatterns.framework/Headers

Now let's check the poppler-qt5 installation:
    ~/u/p/diffpdf►ls -la /opt/homebrew/Cellar/poppler-qt5/ 
    total 0
    drwxr-xr-x@   3 janis  admin    96 Mar 12 18:29 ./
    drwxrwxr-x  196 janis  admin  6272 Mar 12 18:29 ../
    drwxr-xr-x@  14 janis  admin   448 Mar 12 18:29 25.03.0/

Let's check the include directories for poppler-qt5:
    ~/u/p/diffpdf►ls -la /opt/homebrew/Cellar/poppler-qt5/25.03.0/include
    total 0
    drwxr-xr-x@  3 janis  admin    96 Mar  3 23:59 ./
    drwxr-xr-x@ 14 janis  admin   448 Mar 12 18:29 ../
    drwxr-xr-x@ 76 janis  admin  2432 Mar  3 23:59 poppler/

Let's check the poppler/qt5 directory:
    ~/u/p/diffpdf►ls -la /opt/homebrew/Cellar/poppler-qt5/25.03.0/include/poppler/qt5  (base) (master|💩?) 18:45
    total 376
    drwxr-xr-x@ 11 janis  admin    352 Mar  3 23:59 ./
    drwxr-xr-x@ 76 janis  admin   2432 Mar  3 23:59 ../
    -rw-r--r--@  1 janis  admin  42001 Mar  3 23:59 poppler-annotation.h
    -rw-r--r--@  1 janis  admin   1197 Mar  3 23:59 poppler-export.h
    -rw-r--r--@  1 janis  admin  27475 Mar  3 23:59 poppler-form.h
    -rw-r--r--@  1 janis  admin  20210 Mar  3 23:59 poppler-link.h
    -rw-r--r--@  1 janis  admin   2548 Mar  3 23:59 poppler-media.h
    -rw-r--r--@  1 janis  admin   2758 Mar  3 23:59 poppler-optcontent.h
    -rw-r--r--@  1 janis  admin   4535 Mar  3 23:59 poppler-page-transition.h
    -rw-r--r--@  1 janis  admin  72980 Mar  3 23:59 poppler-qt5.h
    -rw-r--r--@  1 janis  admin   1871 Mar  3 23:59 poppler-version.h

Now I understand the issue. The build script is looking for poppler headers in /usr/local/include/poppler/qt4 and /usr/local/include/poppler/cpp, but on your system, they are in /opt/homebrew/Cellar/poppler-qt5/25.03.0/include/poppler/qt5 and /opt/homebrew/Cellar/poppler-qt5/25.03.0/include/poppler/cpp.
Let's modify the build script to use the correct paths:

    [build_osx.sh]

Now let's try running the updated build script:
    chmod +x build_osx.sh && ./build_osx.sh
    Project WARNING: with CONFIG+=sdk_no_version_check when running qmake to silence this warning.
    /Library/Developer/CommandLineTools/usr/bin/clang++ -c -pipe -stdlib=libc++ -O2 -std=gnu++11  -arch arm64 -i
    sysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -mmacosx-version-min=10.13 -Wall -Wextra -fPIC -
    DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/opt/homebrew/opt/poppler-qt5/include/poppler/cpp -I/opt/homeb
    rew/opt/poppler-qt5/include/poppler/qt5 -I/opt/homebrew/opt/qt@5/include -I/opt/homebrew/Cellar/qt@5/5.15.16
    /lib/QtGui.framework/Headers -I/opt/homebrew/Cellar/qt@5/5.15.16/lib/QtCore.framework/Headers -I. -I/Library
    /Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/OpenGL.framework/Headers -I/Library/De
    veloper/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/AGL.framework/Headers -I/opt/homebrew/Cel
    lar/qt@5/5.15.16/mkspecs/macx-clang -F/opt/homebrew/Cellar/qt@5/5.15.16/lib -o mainwindow.o mainwindow.cpp
    In file included from mainwindow.cpp:12:
    ./aboutform.hpp:15:10: fatal error: 'QDialog' file not found
    15 | #include <QDialog>
        |          ^~~~~~~~~
    1 error generated.
    make: *** [mainwindow.o] Error 1


We're still having an issue with finding the Qt headers. Let's check the content of the aboutform.hpp file to understand what includes it needs:
Let's check the diffpdf.pro file to understand the project configuration:
Now I understand the issue better. The problem is that the Qt headers are not being found correctly. Let's modify our build script to explicitly include the Qt Widgets module, which contains QDialog:

    [build_osx.sh]

Let's try running the updated build script:

    chmod +x build_osx.sh && ./build_osx.sh

    sysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -mmacosx-version-min=10.13 -Wall -Wextra -fPIC -
    DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/opt/homebrew/opt/poppler-qt5/include/poppler/cpp -I/opt/homeb
    rew/opt/poppler-qt5/include/poppler/qt5 -I/opt/homebrew/opt/qt@5/include -I/opt/homebrew/opt/qt@5/include/Qt
    Widgets -I/opt/homebrew/opt/qt@5/include/QtGui -I/opt/homebrew/opt/qt@5/include/QtCore -I/opt/homebrew/Cella
    r/qt@5/5.15.16/lib/QtGui.framework/Headers -I/opt/homebrew/Cellar/qt@5/5.15.16/lib/QtCore.framework/Headers
    -I. -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/OpenGL.framework/Headers
    -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/AGL.framework/Headers -I/op
    t/homebrew/Cellar/qt@5/5.15.16/mkspecs/macx-clang -F/opt/homebrew/Cellar/qt@5/5.15.16/lib -o mainwindow.o ma
    inwindow.cpp
    In file included from mainwindow.cpp:13:
    ./generic.hpp:15:10: fatal error: 'poppler-qt4.h' file not found
    15 | #include <poppler-qt4.h>
        |          ^~~~~~~~~~~~~~~
    1 error generated.
    make: *** [mainwindow.o] Error 1

Now we're making progress! The Qt headers are being found, but we have a new issue. The code is looking for poppler-qt4.h, but we're using poppler-qt5. Let's check the generic.hpp file:
We need to modify the generic.hpp file to use poppler-qt5.h instead of poppler-qt4.h:
Now let's try running the build script again:

    ./build_osx.sh
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from mainwindow.cpp:18:
    ./mainwindow.hpp:22:10: fatal error: 'poppler-qt4.h' file not found
    22 | #include <poppler-qt4.h>
        |          ^~~~~~~~~~~~~~~
    4 warnings and 1 error generated.
    make: *** [mainwindow.o] Error 1


We need to update the mainwindow.hpp file as well to use poppler-qt5.h:
Let's update the mainwindow.hpp file:
Let's continue with the build and see if we can make progress:

    ./build_osx.sh
    Error: No such keg: /opt/homebrew/Cellar/poppler
    Warning: poppler-qt5 25.03.0 is already installed and up-to-date.
    To reinstall 25.03.0, run:
    brew reinstall poppler-qt5
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_cz.qm'...
        Generated 180 translation(s) (179 finished and 1 unfinished)
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_fr.qm'...
        Generated 166 translation(s) (166 finished and 0 unfinished)
        Ignored 14 untranslated source text(s)
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_de.qm'...
        Generated 180 translation(s) (179 finished and 1 unfinished)
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_es.qm'...
        Generated 0 translation(s) (0 finished and 0 unfinished)
        Ignored 180 untranslated source text(s)
    /Library/Developer/CommandLineTools/usr/bin/clang++ -c -pipe -stdlib=libc++ -O2 -std=gnu++11  -arch arm64 -i
    sysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -mmacosx-version-min=10.13 -Wall -Wextra -fPIC -
    DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/opt/homebrew/opt/poppler-qt5/include/poppler/cpp -I/opt/homeb
    rew/opt/poppler-qt5/include/poppler/qt5 -I/opt/homebrew/opt/qt@5/include -I/opt/homebrew/opt/qt@5/include/Qt
    Widgets -I/opt/homebrew/opt/qt@5/include/QtGui -I/opt/homebrew/opt/qt@5/include/QtCore -I/opt/homebrew/Cella
    r/qt@5/5.15.16/lib/QtGui.framework/Headers -I/opt/homebrew/Cellar/qt@5/5.15.16/lib/QtCore.framework/Headers
    -I. -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/OpenGL.framework/Headers
    -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/AGL.framework/Headers -I/op
    t/homebrew/Cellar/qt@5/5.15.16/mkspecs/macx-clang -F/opt/homebrew/Cellar/qt@5/5.15.16/lib -o mainwindow.o ma
    inwindow.cpp
    In file included from mainwindow.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:639:5: warning: 'QLinkedList<QPointF>
    ' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    639 |     QLinkedList<QPointF> linePoints() const;
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from mainwindow.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:640:30: warning: 'QLinkedList<QPointF
    >' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    640 |     void setLinePoints(const QLinkedList<QPointF> &points);
        |                              ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from mainwindow.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:854:11: warning: 'QLinkedList<QPointF
    >' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    854 |     QList<QLinkedList<QPointF>> inkPaths() const;
        |           ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from mainwindow.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:855:34: warning: 'QLinkedList<QPointF
    >' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    855 |     void setInkPaths(const QList<QLinkedList<QPointF>> &paths);
        |                                  ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:39:10: fatal error: 'QPrinter' file not found
    39 | #include <QPrinter>
        |          ^~~~~~~~~~
    4 warnings and 1 error generated.
    make: *** [mainwindow.o] Error 1

We're making progress! Now we need to add the QtPrintSupport module to our build script:
    [build_osx.sh]

Let's try running the build script again:

    ./build_osx.sh
    Error: No such keg: /opt/homebrew/Cellar/poppler
    Warning: poppler-qt5 25.03.0 is already installed and up-to-date.
    To reinstall 25.03.0, run:
    brew reinstall poppler-qt5
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_cz.qm'...
        Generated 180 translation(s) (179 finished and 1 unfinished)
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_fr.qm'...
        Generated 166 translation(s) (166 finished and 0 unfinished)
        Ignored 14 untranslated source text(s)
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_de.qm'...
        Generated 180 translation(s) (179 finished and 1 unfinished)
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_es.qm'...
        Generated 0 translation(s) (0 finished and 0 unfinished)
        Ignored 180 untranslated source text(s)
    /Library/Developer/CommandLineTools/usr/bin/clang++ -c -pipe -stdlib=libc++ -O2 -std=gnu++11  -arch arm64 -i
    sysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -mmacosx-version-min=10.13 -Wall -Wextra -fPIC -
    DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/opt/homebrew/opt/poppler-qt5/include/poppler/cpp -I/opt/homeb
    rew/opt/poppler-qt5/include/poppler/qt5 -I/opt/homebrew/opt/qt@5/include -I/opt/homebrew/opt/qt@5/include/Qt
    Widgets -I/opt/homebrew/opt/qt@5/include/QtGui -I/opt/homebrew/opt/qt@5/include/QtCore -I/opt/homebrew/opt/q
    t@5/include/QtPrintSupport -I/opt/homebrew/Cellar/qt@5/5.15.16/lib/QtGui.framework/Headers -I/opt/homebrew/C
    ellar/qt@5/5.15.16/lib/QtCore.framework/Headers -I. -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/Sy
    stem/Library/Frameworks/OpenGL.framework/Headers -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/Syste
    m/Library/Frameworks/AGL.framework/Headers -I/opt/homebrew/Cellar/qt@5/5.15.16/mkspecs/macx-clang -F/opt/hom
    ebrew/Cellar/qt@5/5.15.16/lib -o mainwindow.o mainwindow.cpp
    In file included from mainwindow.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:639:5: warning: 'QLinkedList<QPointF>
    ' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    639 |     QLinkedList<QPointF> linePoints() const;
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from mainwindow.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:640:30: warning: 'QLinkedList<QPointF
    >' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    640 |     void setLinePoints(const QLinkedList<QPointF> &points);
        |                              ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from mainwindow.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:854:11: warning: 'QLinkedList<QPointF
    >' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    854 |     QList<QLinkedList<QPointF>> inkPaths() const;
        |           ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from mainwindow.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:855:34: warning: 'QLinkedList<QPointF
    >' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    855 |     void setInkPaths(const QList<QLinkedList<QPointF>> &paths);
        |                                  ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:1391:10: warning: 'start' is deprecated: Use QElapsedTimer instead [-Wdeprecated-declarations
    ]
    1391 |     time.start();
        |          ^
    /opt/homebrew/opt/qt@5/include/QtCore/qdatetime.h:235:5: note: 'start' has been explicitly marked deprecated
    here
    235 |     QT_DEPRECATED_X("Use QElapsedTimer instead") void start();
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:1394:32: warning: 'elapsed' is deprecated: Use QElapsedTimer instead [-Wdeprecated-declaratio
    ns]
    1394 |     compareUpdateUi(pair, time.elapsed());
        |                                ^
    /opt/homebrew/opt/qt@5/include/QtCore/qdatetime.h:237:5: note: 'elapsed' has been explicitly marked deprecat
    ed here
    237 |     QT_DEPRECATED_X("Use QElapsedTimer instead") int elapsed() const;
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:1688:13: warning: 'setOrientation' is deprecated: Use setPageOrientation() instead. [-Wdeprec
    ated-declarations]
    1688 |     printer.setOrientation(savePages == SaveBothPages
        |             ^
    /opt/homebrew/opt/qt@5/include/QtPrintSupport/qprinter.h:171:5: note: 'setOrientation' has been explicitly m
    arked deprecated here
    171 |     QT_DEPRECATED_VERSION_X_5_15("Use setPageOrientation() instead.")
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:1741:61: warning: implicit conversion from 'double' to 'int' changes value from 2.5 to 2 [-Wl
    iteral-conversion]
    1741 |         painter->drawRect(rightRect.adjusted(2.5, 2.5, 2.5, 2.5));
        |                                     ~~~~~~~~                ^~~
    mainwindow.cpp:1741:56: warning: implicit conversion from 'double' to 'int' changes value from 2.5 to 2 [-Wl
    iteral-conversion]
    1741 |         painter->drawRect(rightRect.adjusted(2.5, 2.5, 2.5, 2.5));
        |                                     ~~~~~~~~           ^~~
    mainwindow.cpp:1741:51: warning: implicit conversion from 'double' to 'int' changes value from 2.5 to 2 [-Wl
    iteral-conversion]
    1741 |         painter->drawRect(rightRect.adjusted(2.5, 2.5, 2.5, 2.5));
        |                                     ~~~~~~~~      ^~~
    mainwindow.cpp:1741:46: warning: implicit conversion from 'double' to 'int' changes value from 2.5 to 2 [-Wl
    iteral-conversion]
    1741 |         painter->drawRect(rightRect.adjusted(2.5, 2.5, 2.5, 2.5));
        |                                     ~~~~~~~~ ^~~
    mainwindow.cpp:1749:56: warning: implicit conversion from 'double' to 'int' changes value from 2.5 to 2 [-Wl
    iteral-conversion]
    1749 |     painter->drawRect(leftRect.adjusted(2.5, 2.5, 2.5, 2.5));
        |                                ~~~~~~~~                ^~~
    mainwindow.cpp:1749:51: warning: implicit conversion from 'double' to 'int' changes value from 2.5 to 2 [-Wl
    iteral-conversion]
    1749 |     painter->drawRect(leftRect.adjusted(2.5, 2.5, 2.5, 2.5));
        |                                ~~~~~~~~           ^~~
    mainwindow.cpp:1749:46: warning: implicit conversion from 'double' to 'int' changes value from 2.5 to 2 [-Wl
    iteral-conversion]
    1749 |     painter->drawRect(leftRect.adjusted(2.5, 2.5, 2.5, 2.5));
        |                                ~~~~~~~~      ^~~
    mainwindow.cpp:1749:41: warning: implicit conversion from 'double' to 'int' changes value from 2.5 to 2 [-Wl
    iteral-conversion]
    1749 |     painter->drawRect(leftRect.adjusted(2.5, 2.5, 2.5, 2.5));
        |                                ~~~~~~~~ ^~~
    mainwindow.cpp:1805:27: warning: 'pixmap' is deprecated: Use the other overload which returns QPixmap by-val
    ue [-Wdeprecated-declarations]
    1805 |     if (!label || !label->pixmap() || label->pixmap()->isNull())
        |                           ^
    /opt/homebrew/opt/qt@5/include/QtWidgets/qlabel.h:77:5: note: 'pixmap' has been explicitly marked deprecated
    here
    77 |     QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QPixmap by-value")
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:392:53: note: expanded from macro 'QT_DEPRECATED_VERSION_X'
    392 | #define QT_DEPRECATED_VERSION_X(major, minor, text) QT_DEPRECATED_VERSION_X_##major##_##minor(text)
        |                                                     ^
    <scratch space>:4:1: note: expanded from here
        4 | QT_DEPRECATED_VERSION_X_5_15
        | ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:1805:46: warning: 'pixmap' is deprecated: Use the other overload which returns QPixmap by-val
    ue [-Wdeprecated-declarations]
    1805 |     if (!label || !label->pixmap() || label->pixmap()->isNull())
        |                                              ^
    /opt/homebrew/opt/qt@5/include/QtWidgets/qlabel.h:77:5: note: 'pixmap' has been explicitly marked deprecated
    here
    77 |     QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QPixmap by-value")
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:392:53: note: expanded from macro 'QT_DEPRECATED_VERSION_X'
    392 | #define QT_DEPRECATED_VERSION_X(major, minor, text) QT_DEPRECATED_VERSION_X_##major##_##minor(text)
        |                                                     ^
    <scratch space>:4:1: note: expanded from here
        4 | QT_DEPRECATED_VERSION_X_5_15
        | ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:1818:29: warning: 'pixmap' is deprecated: Use the other overload which returns QPixmap by-val
    ue [-Wdeprecated-declarations]
    1818 |     QPixmap pixmap = label->pixmap()->copy();
        |                             ^
    /opt/homebrew/opt/qt@5/include/QtWidgets/qlabel.h:77:5: note: 'pixmap' has been explicitly marked deprecated
    here
    77 |     QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QPixmap by-value")
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:392:53: note: expanded from macro 'QT_DEPRECATED_VERSION_X'
    392 | #define QT_DEPRECATED_VERSION_X(major, minor, text) QT_DEPRECATED_VERSION_X_##major##_##minor(text)
        |                                                     ^
    <scratch space>:4:1: note: expanded from here
        4 | QT_DEPRECATED_VERSION_X_5_15
        | ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:1847:27: warning: 'pixmap' is deprecated: Use the other overload which returns QPixmap by-val
    ue [-Wdeprecated-declarations]
    1847 |     if (!label || !label->pixmap() || label->pixmap()->isNull())
        |                           ^
    /opt/homebrew/opt/qt@5/include/QtWidgets/qlabel.h:77:5: note: 'pixmap' has been explicitly marked deprecated
    here
    77 |     QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QPixmap by-value")
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:392:53: note: expanded from macro 'QT_DEPRECATED_VERSION_X'
    392 | #define QT_DEPRECATED_VERSION_X(major, minor, text) QT_DEPRECATED_VERSION_X_##major##_##minor(text)
        |                                                     ^
    <scratch space>:4:1: note: expanded from here
        4 | QT_DEPRECATED_VERSION_X_5_15
        | ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:1847:46: warning: 'pixmap' is deprecated: Use the other overload which returns QPixmap by-val
    ue [-Wdeprecated-declarations]
    1847 |     if (!label || !label->pixmap() || label->pixmap()->isNull())
        |                                              ^
    /opt/homebrew/opt/qt@5/include/QtWidgets/qlabel.h:77:5: note: 'pixmap' has been explicitly marked deprecated
    here
    77 |     QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QPixmap by-value")
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:392:53: note: expanded from macro 'QT_DEPRECATED_VERSION_X'
    392 | #define QT_DEPRECATED_VERSION_X(major, minor, text) QT_DEPRECATED_VERSION_X_##major##_##minor(text)
        |                                                     ^
    <scratch space>:4:1: note: expanded from here
        4 | QT_DEPRECATED_VERSION_X_5_15
        | ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:1851:29: warning: 'pixmap' is deprecated: Use the other overload which returns QPixmap by-val
    ue [-Wdeprecated-declarations]
    1851 |     QPixmap pixmap = label->pixmap()->copy();
        |                             ^
    /opt/homebrew/opt/qt@5/include/QtWidgets/qlabel.h:77:5: note: 'pixmap' has been explicitly marked deprecated
    here
    77 |     QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QPixmap by-value")
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:392:53: note: expanded from macro 'QT_DEPRECATED_VERSION_X'
    392 | #define QT_DEPRECATED_VERSION_X(major, minor, text) QT_DEPRECATED_VERSION_X_##major##_##minor(text)
        |                                                     ^
    <scratch space>:4:1: note: expanded from here
        4 | QT_DEPRECATED_VERSION_X_5_15
        | ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:1883:55: warning: 'pixmap' is deprecated: Use the other overload which returns QPixmap by-val
    ue [-Wdeprecated-declarations]
    1883 |     if (!marginsGroupBox->isChecked() || !page1Label->pixmap() ||
        |                                                       ^
    /opt/homebrew/opt/qt@5/include/QtWidgets/qlabel.h:77:5: note: 'pixmap' has been explicitly marked deprecated
    here
    77 |     QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QPixmap by-value")
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:392:53: note: expanded from macro 'QT_DEPRECATED_VERSION_X'
    392 | #define QT_DEPRECATED_VERSION_X(major, minor, text) QT_DEPRECATED_VERSION_X_##major##_##minor(text)
        |                                                     ^
    <scratch space>:4:1: note: expanded from here
        4 | QT_DEPRECATED_VERSION_X_5_15
        | ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:1884:21: warning: 'pixmap' is deprecated: Use the other overload which returns QPixmap by-val
    ue [-Wdeprecated-declarations]
    1884 |         page1Label->pixmap()->isNull())
        |                     ^
    /opt/homebrew/opt/qt@5/include/QtWidgets/qlabel.h:77:5: note: 'pixmap' has been explicitly marked deprecated
    here
    77 |     QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QPixmap by-value")
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:392:53: note: expanded from macro 'QT_DEPRECATED_VERSION_X'
    392 | #define QT_DEPRECATED_VERSION_X(major, minor, text) QT_DEPRECATED_VERSION_X_##major##_##minor(text)
        |                                                     ^
    <scratch space>:4:1: note: expanded from here
        4 | QT_DEPRECATED_VERSION_X_5_15
        | ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    mainwindow.cpp:1888:37: warning: 'pixmap' is deprecated: Use the other overload which returns QPixmap by-val
    ue [-Wdeprecated-declarations]
    1888 |     const QSize &size = page1Label->pixmap()->size();
        |                                     ^
    /opt/homebrew/opt/qt@5/include/QtWidgets/qlabel.h:77:5: note: 'pixmap' has been explicitly marked deprecated
    here
    77 |     QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QPixmap by-value")
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:392:53: note: expanded from macro 'QT_DEPRECATED_VERSION_X'
    392 | #define QT_DEPRECATED_VERSION_X(major, minor, text) QT_DEPRECATED_VERSION_X_##major##_##minor(text)
        |                                                     ^
    <scratch space>:4:1: note: expanded from here
        4 | QT_DEPRECATED_VERSION_X_5_15
        | ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    24 warnings generated.
    /Library/Developer/CommandLineTools/usr/bin/clang++ -c -pipe -stdlib=libc++ -O2 -std=gnu++11  -arch arm64 -i
    sysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -mmacosx-version-min=10.13 -Wall -Wextra -fPIC -
    DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/opt/homebrew/opt/poppler-qt5/include/poppler/cpp -I/opt/homeb
    rew/opt/poppler-qt5/include/poppler/qt5 -I/opt/homebrew/opt/qt@5/include -I/opt/homebrew/opt/qt@5/include/Qt
    Widgets -I/opt/homebrew/opt/qt@5/include/QtGui -I/opt/homebrew/opt/qt@5/include/QtCore -I/opt/homebrew/opt/q
    t@5/include/QtPrintSupport -I/opt/homebrew/Cellar/qt@5/5.15.16/lib/QtGui.framework/Headers -I/opt/homebrew/C
    ellar/qt@5/5.15.16/lib/QtCore.framework/Headers -I. -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/Sy
    stem/Library/Frameworks/OpenGL.framework/Headers -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/Syste
    m/Library/Frameworks/AGL.framework/Headers -I/opt/homebrew/Cellar/qt@5/5.15.16/mkspecs/macx-clang -F/opt/hom
    ebrew/Cellar/qt@5/5.15.16/lib -o textitem.o textitem.cpp
    In file included from textitem.cpp:13:
    In file included from ./textitem.hpp:15:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:639:5: warning: 'QLinkedList<QPointF>
    ' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    639 |     QLinkedList<QPointF> linePoints() const;
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from textitem.cpp:13:
    In file included from ./textitem.hpp:15:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:640:30: warning: 'QLinkedList<QPointF
    >' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    640 |     void setLinePoints(const QLinkedList<QPointF> &points);
        |                              ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from textitem.cpp:13:
    In file included from ./textitem.hpp:15:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:854:11: warning: 'QLinkedList<QPointF
    >' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    854 |     QList<QLinkedList<QPointF>> inkPaths() const;
        |           ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from textitem.cpp:13:
    In file included from ./textitem.hpp:15:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:855:34: warning: 'QLinkedList<QPointF
    >' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    855 |     void setInkPaths(const QList<QLinkedList<QPointF>> &paths);
        |                                  ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    textitem.cpp:133:24: warning: 'insertMulti' is deprecated: Use QMultiMap for maps storing multiple values wi
    th the same key. [-Wdeprecated-declarations]
    133 |         zonesForColumn.insertMulti(Key(Column, y, rect.x()), zone);
        |                        ^
    /opt/homebrew/opt/qt@5/include/QtCore/qmap.h:592:5: note: 'insertMulti' has been explicitly marked deprecate
    d here
    592 |     QT_DEPRECATED_VERSION_X_5_15("Use QMultiMap for maps storing multiple values with the same key."
    ) iterator insertMulti(const Key &key, const T &value);
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    5 warnings generated.
    /Library/Developer/CommandLineTools/usr/bin/clang++ -c -pipe -stdlib=libc++ -O2 -std=gnu++11  -arch arm64 -i
    sysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -mmacosx-version-min=10.13 -Wall -Wextra -fPIC -
    DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/opt/homebrew/opt/poppler-qt5/include/poppler/cpp -I/opt/homeb
    rew/opt/poppler-qt5/include/poppler/qt5 -I/opt/homebrew/opt/qt@5/include -I/opt/homebrew/opt/qt@5/include/Qt
    Widgets -I/opt/homebrew/opt/qt@5/include/QtGui -I/opt/homebrew/opt/qt@5/include/QtCore -I/opt/homebrew/opt/q
    t@5/include/QtPrintSupport -I/opt/homebrew/Cellar/qt@5/5.15.16/lib/QtGui.framework/Headers -I/opt/homebrew/C
    ellar/qt@5/5.15.16/lib/QtCore.framework/Headers -I. -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/Sy
    stem/Library/Frameworks/OpenGL.framework/Headers -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/Syste
    m/Library/Frameworks/AGL.framework/Headers -I/opt/homebrew/Cellar/qt@5/5.15.16/mkspecs/macx-clang -F/opt/hom
    ebrew/Cellar/qt@5/5.15.16/lib -o aboutform.o aboutform.cpp
    /Library/Developer/CommandLineTools/usr/bin/clang++ -c -pipe -stdlib=libc++ -O2 -std=gnu++11  -arch arm64 -i
    sysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -mmacosx-version-min=10.13 -Wall -Wextra -fPIC -
    DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/opt/homebrew/opt/poppler-qt5/include/poppler/cpp -I/opt/homeb
    rew/opt/poppler-qt5/include/poppler/qt5 -I/opt/homebrew/opt/qt@5/include -I/opt/homebrew/opt/qt@5/include/Qt
    Widgets -I/opt/homebrew/opt/qt@5/include/QtGui -I/opt/homebrew/opt/qt@5/include/QtCore -I/opt/homebrew/opt/q
    t@5/include/QtPrintSupport -I/opt/homebrew/Cellar/qt@5/5.15.16/lib/QtGui.framework/Headers -I/opt/homebrew/C
    ellar/qt@5/5.15.16/lib/QtCore.framework/Headers -I. -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/Sy
    stem/Library/Frameworks/OpenGL.framework/Headers -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/Syste
    m/Library/Frameworks/AGL.framework/Headers -I/opt/homebrew/Cellar/qt@5/5.15.16/mkspecs/macx-clang -F/opt/hom
    ebrew/Cellar/qt@5/5.15.16/lib -o optionsform.o optionsform.cpp
    In file included from optionsform.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:639:5: warning: 'QLinkedList<QPointF>
    ' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    639 |     QLinkedList<QPointF> linePoints() const;
        |     ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from optionsform.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:640:30: warning: 'QLinkedList<QPointF
    >' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    640 |     void setLinePoints(const QLinkedList<QPointF> &points);
        |                              ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from optionsform.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:854:11: warning: 'QLinkedList<QPointF
    >' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    854 |     QList<QLinkedList<QPointF>> inkPaths() const;
        |           ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    In file included from optionsform.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:855:34: warning: 'QLinkedList<QPointF
    >' is deprecated: Use std::list instead [-Wdeprecated-declarations]
    855 |     void setInkPaths(const QList<QLinkedList<QPointF>> &paths);
        |                                  ^
    /opt/homebrew/opt/qt@5/include/QtCore/qlinkedlist.h:92:7: note: 'QLinkedList<QPointF>' has been explicitly m
    arked deprecated here
    92 | class QT_DEPRECATED_VERSION_X_5_15("Use std::list instead") QLinkedList
        |       ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:376:45: note: expanded from macro 'QT_DEPRECATED_VERSION_X_5
    _15'
    376 | # define QT_DEPRECATED_VERSION_X_5_15(text) QT_DEPRECATED_X(text)
        |                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qglobal.h:294:33: note: expanded from macro 'QT_DEPRECATED_X'
    294 | #  define QT_DEPRECATED_X(text) Q_DECL_DEPRECATED_X(text)
        |                                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qcompilerdetection.h:689:55: note: expanded from macro 'Q_DECL_DEPRECA
    TED_X'
    689 | #    define Q_DECL_DEPRECATED_X(text) __attribute__ ((__deprecated__(text)))
        |                                                       ^
    optionsform.cpp:79:61: error: calling a private constructor of class 'QVariant'
    79 |                                                 pair.first, pair.second);
        |                                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:514:5: note: declared private here
    514 |     QVariant(Qt::BrushStyle) = delete;
        |     ^
    optionsform.cpp:79:61: error: attempt to use a deleted function
    79 |                                                 pair.first, pair.second);
        |                                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:514:5: note: 'QVariant' has been explicitly marked deleted 
    here
    514 |     QVariant(Qt::BrushStyle) = delete;
        |     ^
    optionsform.cpp:81:17: error: calling a private constructor of class 'QVariant'
    81 |                 brush.style()));
        |                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:514:5: note: declared private here
    514 |     QVariant(Qt::BrushStyle) = delete;
        |     ^
    optionsform.cpp:81:17: error: attempt to use a deleted function
    81 |                 brush.style()));
        |                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:514:5: note: 'QVariant' has been explicitly marked deleted 
    here
    514 |     QVariant(Qt::BrushStyle) = delete;
        |     ^
    optionsform.cpp:93:47: error: calling a private constructor of class 'QVariant'
    93 |                                   pair.first, pair.second);
        |                                               ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:515:5: note: declared private here
    515 |     QVariant(Qt::PenStyle) = delete;
        |     ^
    optionsform.cpp:93:47: error: attempt to use a deleted function
    93 |                                   pair.first, pair.second);
        |                                               ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:515:5: note: 'QVariant' has been explicitly marked deleted 
    here
    515 |     QVariant(Qt::PenStyle) = delete;
        |     ^
    optionsform.cpp:95:17: error: calling a private constructor of class 'QVariant'
    95 |                 pen.style()));
        |                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:515:5: note: declared private here
    515 |     QVariant(Qt::PenStyle) = delete;
        |     ^
    optionsform.cpp:95:17: error: attempt to use a deleted function
    95 |                 pen.style()));
        |                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:515:5: note: 'QVariant' has been explicitly marked deleted 
    here
    515 |     QVariant(Qt::PenStyle) = delete;
        |     ^
    4 warnings and 8 errors generated.
    make: *** [optionsform.o] Error 1

We're making progress, but now we're encountering some compatibility issues with Qt 5.15. The code is using some deprecated features that have been removed in the newer Qt version. Let's update our build script to use a compatibility flag:

    [build_osx.sh]

Let's try running the build script again:
    ./build_osx.sh
    Error: No such keg: /opt/homebrew/Cellar/poppler
    Warning: poppler-qt5 25.03.0 is already installed and up-to-date.
    To reinstall 25.03.0, run:
    brew reinstall poppler-qt5
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_cz.qm'...
        Generated 180 translation(s) (179 finished and 1 unfinished)
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_fr.qm'...
        Generated 166 translation(s) (166 finished and 0 unfinished)
        Ignored 14 untranslated source text(s)
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_de.qm'...
        Generated 180 translation(s) (179 finished and 1 unfinished)
    Warning: ignoring <defaultcodec> element
    Updating '/Users/janis/uni/projects/diffpdf/diffpdf_es.qm'...
        Generated 0 translation(s) (0 finished and 0 unfinished)
        Ignored 180 untranslated source text(s)
    /Library/Developer/CommandLineTools/usr/bin/clang++ -c -pipe -stdlib=libc++ -O2 -std=gnu++11  -arch arm64 -i
    sysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -mmacosx-version-min=10.13 -Wall -Wextra -fPIC -
    DQT_DISABLE_DEPRECATED_BEFORE=0x050F00 -DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/opt/homebrew/opt/popp
    ler-qt5/include/poppler/cpp -I/opt/homebrew/opt/poppler-qt5/include/poppler/qt5 -I/opt/homebrew/opt/qt@5/inc
    lude -I/opt/homebrew/opt/qt@5/include/QtWidgets -I/opt/homebrew/opt/qt@5/include/QtGui -I/opt/homebrew/opt/q
    t@5/include/QtCore -I/opt/homebrew/opt/qt@5/include/QtPrintSupport -I/opt/homebrew/Cellar/qt@5/5.15.16/lib/Q
    tGui.framework/Headers -I/opt/homebrew/Cellar/qt@5/5.15.16/lib/QtCore.framework/Headers -I. -I/Library/Devel
    oper/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/OpenGL.framework/Headers -I/Library/Develope
    r/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/AGL.framework/Headers -I/opt/homebrew/Cellar/qt
    @5/5.15.16/mkspecs/macx-clang -F/opt/homebrew/Cellar/qt@5/5.15.16/lib -o optionsform.o optionsform.cpp
    In file included from optionsform.cpp:13:
    In file included from ./generic.hpp:15:
    In file included from /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-qt5.h:55:
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:639:5: error: no template named 'QLin
    kedList'
    639 |     QLinkedList<QPointF> linePoints() const;
        |     ^
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:640:30: error: no template named 'QLi
    nkedList'
    640 |     void setLinePoints(const QLinkedList<QPointF> &points);
        |                              ^
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:854:11: error: use of undeclared iden
    tifier 'QLinkedList'
    854 |     QList<QLinkedList<QPointF>> inkPaths() const;
        |           ^
    /opt/homebrew/opt/poppler-qt5/include/poppler/qt5/poppler-annotation.h:855:34: error: use of undeclared iden
    tifier 'QLinkedList'
    855 |     void setInkPaths(const QList<QLinkedList<QPointF>> &paths);
        |                                  ^
    optionsform.cpp:79:61: error: calling a private constructor of class 'QVariant'
    79 |                                                 pair.first, pair.second);
        |                                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:514:5: note: declared private here
    514 |     QVariant(Qt::BrushStyle) = delete;
        |     ^
    optionsform.cpp:79:61: error: attempt to use a deleted function
    79 |                                                 pair.first, pair.second);
        |                                                             ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:514:5: note: 'QVariant' has been explicitly marked deleted 
    here
    514 |     QVariant(Qt::BrushStyle) = delete;
        |     ^
    optionsform.cpp:81:17: error: calling a private constructor of class 'QVariant'
    81 |                 brush.style()));
        |                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:514:5: note: declared private here
    514 |     QVariant(Qt::BrushStyle) = delete;
        |     ^
    optionsform.cpp:81:17: error: attempt to use a deleted function
    81 |                 brush.style()));
        |                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:514:5: note: 'QVariant' has been explicitly marked deleted 
    here
    514 |     QVariant(Qt::BrushStyle) = delete;
        |     ^
    optionsform.cpp:93:47: error: calling a private constructor of class 'QVariant'
    93 |                                   pair.first, pair.second);
        |                                               ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:515:5: note: declared private here
    515 |     QVariant(Qt::PenStyle) = delete;
        |     ^
    optionsform.cpp:93:47: error: attempt to use a deleted function
    93 |                                   pair.first, pair.second);
        |                                               ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:515:5: note: 'QVariant' has been explicitly marked deleted 
    here
    515 |     QVariant(Qt::PenStyle) = delete;
        |     ^
    optionsform.cpp:95:17: error: calling a private constructor of class 'QVariant'
    95 |                 pen.style()));
        |                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:515:5: note: declared private here
    515 |     QVariant(Qt::PenStyle) = delete;
        |     ^
    optionsform.cpp:95:17: error: attempt to use a deleted function
    95 |                 pen.style()));
        |                 ^
    /opt/homebrew/opt/qt@5/include/QtCore/qvariant.h:515:5: note: 'QVariant' has been explicitly marked deleted 
    here
    515 |     QVariant(Qt::PenStyle) = delete;
        |     ^
    12 errors generated.
    make: *** [optionsform.o] Error 1


[tired of coying]

We need to adjust our approach. The issue is that we're trying to disable deprecated features, but that's causing more problems. Let's modify our build script to include the QLinkedList header and adjust the DEFINES:
Let's try running the build script again:
We're having issues with our QLinkedList wrapper. Let's try a different approach. Let's modify our build script to use a simpler approach:
Let's try running the build script again:
We still have issues with the QLinkedList wrapper. Let's try a different approach by removing the wrapper files:
Now let's update the build script to use a different approach:
Let's try running the build script again:
We're still having issues with the QLinkedList wrapper. Let's check if there are any remaining references to the wrapper files:
Let's clean up the project and try again:
Now let's fix the generic.hpp and mainwindow.hpp files:
Now let's update the build script:
Let's try running the build script again:
We're making progress! Now we're getting errors in optionsform.cpp related to QVariant constructors that have been deleted in Qt 5.15. Let's check the optionsform.cpp file:
We need to modify the optionsform.cpp file to work with Qt 5.15. Let's create a patch for it:
Let's try running the build script again:
We're making progress! Now we need to fix the main.cpp file. Let's check it:
Let's fix the main.cpp file:
Let's try running the build script again:
Now we need to fix the lineedit.cpp file. Let's check it:
Let's fix the lineedit.cpp file:
Let's try running the build script again:
Now we need to fix the label.cpp file. Let's check it:
Let's fix the label.cpp file:
Let's try running the build script again:
We're now getting linker errors. We need to update the build script to include the Qt modules in the LIBS section:
Let's try running the build script again:
We're making progress! The compilation is now successful, but we're having issues with the deployment part of the script. Let's examine the build script to understand what's happening with the deployment:
I see the issue. The build script is looking for diffpdf.app but our build is creating diffpdf_mac.app instead. Let's fix the build script:
Now let's run the build script again:
    ./build_osx.sh
    LineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/OpenGL.framework/Headers -I/Library/Developer/CommandLin
    eTools/SDKs/MacOSX.sdk/System/Library/Frameworks/AGL.framework/Headers -I/opt/homebrew/Cellar/qt@5/5.15.16/m
    kspecs/macx-clang -F/opt/homebrew/Cellar/qt@5/5.15.16/lib -o qrc_resources.o qrc_resources.cpp
    /Library/Developer/CommandLineTools/usr/bin/clang++ -stdlib=libc++ -headerpad_max_install_names  -arch arm64
    -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -mmacosx-version-min=10.13 -Wl,-rpath,@execut
    able_path/../Frameworks -o diffpdf_mac.app/Contents/MacOS/diffpdf_mac mainwindow.o textitem.o aboutform.o op
    tionsform.o helpform.o saveform.o generic.o sequence_matcher.o main.o lineedit.o label.o qrc_resources.o moc
    _mainwindow.o moc_aboutform.o moc_optionsform.o moc_helpform.o moc_saveform.o moc_lineedit.o moc_label.o   -
    F/opt/homebrew/Cellar/qt@5/5.15.16/lib -L/opt/homebrew/opt/poppler-qt5/lib -lpoppler-qt5 -lpoppler -F/opt/ho
    mebrew/opt/qt@5/lib -framework QtPrintSupport -framework QtWidgets -framework QtGui -framework AppKit -frame
    work Metal -framework QtCore -framework DiskArbitration -framework IOKit -framework OpenGL -framework AGL
    -- this cmd could be useful for old versions of qt: rm -r QtDeclarative.framework/ QtNetwork.framework/ QtSc
    ript.framework/ QtSql.framework/ QtXmlPatterns.framework/
    ...................................................................................
    created: /Users/janis/uni/projects/diffpdf/diffpdf-2.1.3.dmg

Great news! The build has completed successfully, and a DMG file has been created. Let's verify that the application works:
    open diffpdf_mac.app
    
Excellent! The application has launched without any errors. Let's summarize what we've done to fix the build issues:
Fixed QVariant constructor issues in optionsform.cpp:
Updated the code to use QVariant::fromValue() instead of direct QVariant construction, which was deprecated in Qt 5.15.
Removed deprecated QTextCodec::setCodecForTr in main.cpp:
Removed the deprecated call that was no longer available in Qt 5.15.
Added missing includes in lineedit.cpp and label.cpp:
Added #include <QMimeData> to fix incomplete type errors.
Updated the build script build_osx.sh:
Added proper Qt framework libraries to the LIBS section.
Updated the DEFINES section to use QT_NO_DEPRECATED_WARNINGS.
Fixed the deployment section to use the correct app name (diffpdf_mac.app instead of diffpdf.app).
Added error handling for the framework removal step.
The application now builds successfully and can be launched. The DMG file has also been created, which means you can distribute the application to other macOS users.
Is there anything else you'd like me to help with or explain about the fixes we've made?