QT          += quick
QT          += quickcontrols2
QT          += svg

CONFIG      += c++17

HEADERS     += \
            AppAPI.h \
            AppAPI_impl.h \
            Enums.h \
            MetricStorage.h \
            SignalNotifier.h \
            metric.h \
            servicefunctions.h

SOURCES     += \
            AppAPI.cpp \
            AppAPI_impl.cpp \
            Enums.cpp \
            MetricStorage.cpp \
            SignalNotifier.cpp \
            main.cpp \
            metric.cpp \
            servicefunctions.cpp

RESOURCES   += \
            qml.qrc \
            img.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
#QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
