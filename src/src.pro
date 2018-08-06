
# Main project file for Glacier home

TEMPLATE = app
TARGET = lipstick
VERSION = 0.1

INSTALLS = target
target.path = /usr/bin

styles.path = /usr/share/lipstick-glacier-home-qt5
styles.files = nemovars.conf

images.path = /usr/share/lipstick-glacier-home-qt5/qml/images
images.files = qml/images/*.png \
               qml/images/*.jpg \
               qml/images/*.svg

theme.path = /usr/share/lipstick-glacier-home-qt5/qml/theme
theme.files = qml/theme/*.png

qml.path = /usr/share/lipstick-glacier-home-qt5/qml
qml.files = qml/MainScreen.qml \
    qml/compositor.qml \
    qml/LauncherItemDelegate.qml \
    qml/Lockscreen.qml \
    qml/LockscreenClock.qml \
    qml/AppSwitcher.qml \
    qml/AppLauncher.qml \
    qml/ToolBarLayoutExample.qml \
    qml/SwitcherItem.qml \
    qml/CloseButton.qml \
    qml/NotificationPreview.qml \
    qml/FeedsPage.qml \
    qml/Statusbar.qml \
    qml/StatusbarItem.qml \
    qml/WifiPanel.qml \
    qml/SimPanel.qml \
    qml/NumButton.qml \
    qml/USBModeSelector.qml \
    qml/Pager.qml \
    qml/VolumeControl.qml \
    qml/BatteryPanel.qml \
    qml/CommonPanel.qml \
    qml/ShutdownScreen.qml \
    qml/GlacierRotation.qml \
    qml/DeviceLockUI.qml \
    qml/LauncherItemWrapper.qml \
    qml/LauncherItemFolder.qml \
    qml/ScreenShotter.qml

qmlcompositor.path = /usr/share/lipstick-glacier-home-qt5/qml/compositor
qmlcompositor.files = qml/compositor/WindowWrapperMystic.qml \
    qml/compositor/WindowWrapperBase.qml \
    qml/compositor/WindowWrapperAlpha.qml \
    qml/compositor/ScreenGestureArea.qml

scripts.path = /usr/share/lipstick-glacier-home-qt5/qml/scripts
scripts.files =  qml/scripts/desktop.js \
                qml/scripts/rotation.js

system.path = /usr/share/lipstick-glacier-home-qt5/qml/system
system.files = qml/ShutdownScreen.qml

volumecontrol.path = /usr/share/lipstick-glacier-home-qt5/qml/volumecontrol
volumecontrol.files = qml/VolumeControl.qml

connectivity.path = /usr/share/lipstick-glacier-home-qt5/qml/connectivity
connectivity.files = qml/connectivity/USBModeSelector.qml \
                     qml/connectivity/ConnectionSelector.qml

notifications.path = /usr/share/lipstick-glacier-home-qt5/qml/notifications
notifications.files = qml/notifications/NotificationItem.qml\
                      qml/notifications/NotificationPreview.qml

statusbar.path = /usr/share/lipstick-glacier-home-qt5/qml/statusbar
statusbar.files = qml/statusbar/BatteryPanel.qml\
                qml/statusbar/BatteryIndicator.qml \
                qml/statusbar/CommonPanel.qml\
                qml/statusbar/SimPanel.qml\
                qml/statusbar/WifiPanel.qml\
                qml/statusbar/StatusbarItem.qml\
                qml/statusbar/NumButton.qml \
                qml/statusbar/MediaController.qml \
                qml/statusbar/ExtendedStatusBar.qml \
                qml/statusbar/ExtendedStatusBarButton.qml

applauncher.path = /usr/share/lipstick-glacier-home-qt5/qml/applauncher
applauncher.files = qml/applauncher/SearchListView.qml \
                qml/applauncher/Deleter.qml

settingswallpaperplugin.files = settings-plugins/wallpaper/wallpaper.qml \
                       settings-plugins/wallpaper/selectImage.qml \
                       settings-plugins/wallpaper/wallpaper.svg

settingswallpaperplugin.path = /usr/share/glacier-settings/qml/plugins/wallpaper

settingsnotificationsplugin.files = settings-plugins/notifications/notifications.qml \
                       settings-plugins/notifications/notifications.svg

settingsnotificationsplugin.path = /usr/share/glacier-settings/qml/plugins/notifications

settingspluginconfig.files = settings-plugins/wallpaper/wallpaper.json \
                             settings-plugins/notifications/notifications.json

settingspluginconfig.path = /usr/share/glacier-settings/plugins

INSTALLS += styles \
            images \
            theme \
            qml \
            qmlcompositor\
            scripts\
            system\
            volumecontrol\
            connectivity\
            notifications\
            statusbar\
            settingswallpaperplugin\
            settingsnotificationsplugin\
            settingspluginconfig \
            applauncher

CONFIG += qt link_pkgconfig
QT += quick compositor
DEFINES += QT_COMPOSITOR_QUICK
HEADERS += \
    glacierwindowmodel.h
QT += dbus
LIBS += -lnemodevicelock
MOC_DIR = .moc

SOURCES += \
    main.cpp \
    glacierwindowmodel.cpp
PKGCONFIG += lipstick-qt5 \
    nemodevicelock

OTHER_FILES += qml/*.qml \
    qml/compositor/*.qml \
    qml/scripts/desktop.js \
    nemovars.conf \
    qml/connectivity/*.qml

TRANSLATIONS += i18n/glacer-home.ts

DISTFILES += \
    i18n/glacer-home.ts \
    qml/*/*.qml \
    settings-plugins/*/*.qml \
    settings-plugins/*/*.json \
    settings-plugins/*/*.svg
