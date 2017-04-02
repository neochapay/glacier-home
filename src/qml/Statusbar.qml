/****************************************************************************************
**
** Copyright (C) 2014 Aleksi Suomalainen <suomalainen.aleksi@gmail.com>
** Copyright (C) 2017 Sergey Chupligin <mail@neochapay.ru>
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
import QtQuick 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0
import org.freedesktop.contextkit 1.0
import MeeGo.Connman 0.2
import org.nemomobile.lipstick 0.1
import org.nemomobile.statusnotifier 1.0

import "statusbar"

Item {
    id: root
    z: 201
    height: Math.min(parent.width,parent.height)/10
    width: parent.width
    anchors.top: parent.top

    StatusNotifierModel {
        id: notifyModel
    }

    Rectangle{
        id: statusbar
        anchors.fill: parent
        color: "transparent"
        z: 200

        Rectangle {
            id: backStage
            color: "black"
            anchors.fill: parent
            opacity: 0.5
        }

        BatteryIndicator{
            id: batteryIndicator
            anchors{
                right: parent.right
                rightMargin: height/4
            }
        }

        CelluralIndicator{
            id: celluralSigualIndicator
            anchors{
                right: batteryIndicator.left
                rightMargin: height/4
            }
            panel: SimPanel {}
        }

        WifiIndicator{
            anchors{
                right: celluralSigualIndicator.left
                rightMargin: height/4
            }
        }


        Label {
            id: timeIndicator
            font.pixelSize: root.height*0.6
            text: Qt.formatDateTime(wallClock.time, "hh")+":"+Qt.formatDateTime(wallClock.time, "mm")

            anchors{
                left: parent.left
                leftMargin: height/4
                verticalCenter: parent.verticalCenter
            }
        }
    }

    ContextProperty {
        id: bluetoothEnabled
        key: "Bluetooth.Enabled"
    }

    ContextProperty {
        id: bluetoothConnected
        key: "Bluetooth.Connected"
    }


    TechnologyModel {
        id: wifimodel
        name: "wifi"
        onPoweredChanged: {
            if (powered)
                wifimodel.requestScan()
        }
    }

    Loader {
        id: panel_loader
        anchors.top: root.bottom
        height: 240
        width: parent.width
        visible: false
    }
}
