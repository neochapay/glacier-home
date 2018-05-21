/****************************************************************************************
**
** Copyright (C) 2018 Sergey Chupligin <neochapay@gmail.com>
** All rights reserved.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the author nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

import QtQuick 2.6
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.systemsettings 1.0
import org.nemomobile.lipstick 0.1

import MeeGo.Connman 0.2

Item {
    id: extendedStatusBar
    width: desktop.width
    height: desktop.height
    z: 205
    anchors.top: parent.top

    signal brightnessSliderActivated(bool activated)
    property bool brightnessSliderTouched: false

    DisplaySettings{
        id: displaySettings
    }

    Row{
        id: clockStatusBar
        width: parent.width
        height: childrenRect.height

        visible: !brightnessSliderTouched

        anchors{
            top: parent.top
            topMargin: Theme.itemSpacingMedium
        }

        Text {
            id: timeDisplay

            width: parent.width

            font.pixelSize: Theme.fontSizeLarge
            font.weight: Font.Light
            lineHeight: 0.85
            color: Theme.textColor
            horizontalAlignment: Text.AlignHCenter

            text: Qt.formatDateTime(wallClock.time, "hh:mm")
        }
    }

    Rectangle{
        id: brightnessRow
        width: parent.width
        height: brightnessIcon.height + Theme.itemSpacingLarge*2

        anchors{
            top: clockStatusBar.bottom
            topMargin: Theme.itemSpacingMedium
        }

        color: "transparent"

        Image{
            id: brightnessIcon
            width: Theme.itemHeightMedium
            height: width
            source: "image://theme/sun-o"

            opacity: (displaySettings.autoBrightnessEnabled) ? 0.5 : 1

            anchors{
                top: parent.top
                topMargin: Theme.itemSpacingLarge
                left: parent.left
                leftMargin: Theme.itemSpacingLarge
            }

            MouseArea{
                anchors.fill: parent
                onPressAndHold: {
                    if(displaySettings.autoBrightnessEnabled) {
                        displaySettings.autoBrightnessEnabled = false
                    } else {
                        displaySettings.autoBrightnessEnabled = true
                    }
                    hideExtendedStatusBarTimer.restart()
                }
            }
        }

        Slider{
            id: brightnessSlider

            width: parent.width-brightnessIcon.width-Theme.itemSpacingLarge*3

            minimumValue: 0
            maximumValue: displaySettings.maximumBrightness
            value: displaySettings.brightness
            stepSize: 1

            anchors{
                left: brightnessIcon.right
                leftMargin: Theme.itemSpacingLarge
                verticalCenter: brightnessIcon.verticalCenter
            }

            enabled: !displaySettings.autoBrightnessEnabled

            onValueChanged: {
                displaySettings.brightness = value
                hideExtendedStatusBarTimer.restart()
            }

            onPressedChanged: {
                extendedStatusBar.brightnessSliderActivated(pressed)
                brightnessSliderTouched = pressed
                if(pressed) {
                    brightnessRow.color = Theme.backgroundColor
                } else {
                    brightnessRow.color = "transparent"
                }
            }
        }
    }


    Row{
        id: volumeRow
        width: parent.width

        anchors.top: brightnessRow.bottom

        visible: !brightnessSliderTouched

        spacing: Theme.itemSpacingLarge
        padding: Theme.itemSpacingLarge

        Image{
            id: volumeIcon
            width: Theme.itemHeightMedium
            height: width
            source: {
                if(volumeControl.volume === 0){
                    return "image://theme/volume-off"
                } else if (volumeControl.volume < 6) {
                    return "image://theme/volume-down"
                } else {
                    return "image://theme/volume-up"
                }
            }

            MouseArea{
                anchors.fill: parent
                onPressAndHold: {
                    if(volumeControl.volume !== 0)
                    {
                        volumeControl.volume = 0;
                    }
                    hideExtendedStatusBarTimer.restart()
                }
            }
        }

        Slider{
            id: volumeSlider

            width: parent.width-brightnessIcon.width-Theme.itemSpacingLarge*3

            minimumValue: 0
            maximumValue: volumeControl.maximumVolume
            value: volumeControl.volume
            stepSize: 1

            anchors.verticalCenter: volumeIcon.verticalCenter

            onValueChanged: {
                volumeControl.volume = value
                hideExtendedStatusBarTimer.restart()
            }
        }
    }

    Grid{
        id: fastActionRow
        width: parent.width-Theme.itemSpacingLarge*2

        anchors.top: volumeRow.bottom
        columns: 3

        visible: !brightnessSliderTouched

        anchors{
            left: parent.left
            leftMargin: Theme.itemSpacingLarge
        }

        ExtendedStatusBarButton{
            id: wifiButton

            icon: {
                if (wlan.connected) {
                    if (networkManager.defaultRoute.type !== "wifi")
                        return "image://theme/icon_wifi_0"
                    if (networkManager.defaultRoute.strength >= 59) {
                        return "image://theme/icon_wifi_focused4"
                    } else if (networkManager.defaultRoute.strength >= 55) {
                        return "image://theme/icon_wifi_focused3"
                    } else if (networkManager.defaultRoute.strength >= 50) {
                        return "image://theme/icon_wifi_focused2"
                    } else if (networkManager.defaultRoute.strength >= 40) {
                        return "image://theme/icon_wifi_focused1"
                    } else {
                        return "image://theme/icon_wifi_0"
                    }
                } else if (wifimodel.powered && !wlan.connected) {
                    return "image://theme/icon_wifi_touch"
                } else {
                    return "image://theme/wifi"
                }
            }

            label: qsTr("WiFi")

            activated: wifimodel.powered

            onClicked: {
                if(wifimodel.powered) {
                    wifimodel.powered = false;
                } else {
                    wifimodel.powered = true;
                }
            }
        }

        ExtendedStatusBarButton{
            id: bluetoothButton

            TechnologyModel {
                id: bluetoothModel
                name: "bluetooth"

                onTechnologiesChanged: {
                    bluetoothButton.activated = bluetoothModel.powered
                }

                onPoweredChanged: {
                    bluetoothButton.activated = bluetoothModel.powered
                }
            }

            activated: bluetoothModel.powered

            icon: "image://theme/bluetooth"
            label: qsTr("Bluetooth")

            onClicked: {
                if(bluetoothModel.powered){
                    bluetoothModel.powered = false
                } else {
                    bluetoothModel.powered = true
                }
            }
        }

        ExtendedStatusBarButton{
            id: airoplaneButton

            icon: "image://theme/plane"
            label: qsTr("Airoplane Mode")
        }

        ExtendedStatusBarButton{
            id: gpsButton

            TechnologyModel {
                id: gpsModel
                name: "gps"

                onTechnologiesChanged: {
                    gpsButton.activated = gpsModel.powered
                }

                onPoweredChanged: {
                    gpsButton.activated = gpsModel.powered
                }
            }

            activated: gpsModel.powered

            icon: "image://theme/map-marker"
            label: qsTr("Location")

            onClicked: {
                if(gpsButton.activated) {
                    gpsModel.powered = false;
                } else {
                    gpsModel.powered = true;
                }
            }
        }

        ExtendedStatusBarButton{
            id: screenshotButton

            activated: true

            icon: "image://theme/image"
            label: qsTr("Screenshot")
        }
    }
}
