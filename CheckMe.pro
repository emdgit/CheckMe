QT          += quick
QT          += quickcontrols2
QT          += svg

CONFIG      += c++17

INCLUDEPATH += $$PWD/src

HEADERS     +=               \
            src/appapi.h      \
            src/appapi_impl.h  \
            src/enums.h         \
            src/metric.h         \
            src/metricstorage.h   \
            src/servicefunctions.h \
            src/signalnotifier.h

SOURCES     +=                \
            src/appapi.cpp     \
            src/appapi_impl.cpp \
            src/enums.cpp        \
            src/main.cpp          \
            src/metric.cpp         \
            src/metricstorage.cpp   \
            src/servicefunctions.cpp \
            src/signalnotifier.cpp

RESOURCES   +=     \
            qml.qrc \
            img.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES   +=                                          \
            android/AndroidManifest.xml                  \
            android/build.gradle                          \
            android/gradle.properties                      \
            android/gradle/wrapper/gradle-wrapper.jar       \
            android/gradle/wrapper/gradle-wrapper.properties \
            android/gradlew                                   \
            android/gradlew.bat                                \
            android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
