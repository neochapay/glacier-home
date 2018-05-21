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

Item{
    id: extendedStatusBarButton
    width: parent.width/3
    height: width+Theme.itemSpacingLarge

    clip: true

    signal clicked()
    signal pressAndHold()

    property alias icon: buttonIcon.source
    property alias label: buttonText.text

    property bool activated: false

    Image{
        id: buttonIcon
        anchors{
            top: parent.top
            topMargin: Theme.itemSpacingSmall
            horizontalCenter: parent.horizontalCenter
        }

        width: parent.width*0.8
        height: width

        fillMode: Image.PreserveAspectFit

        opacity: activated ? 1 : 0.3

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }
    }

    Text {
        id: buttonText
        color: Theme.textColor

        font.pixelSize: Theme.fontSizeTiny

        anchors{
            top: buttonIcon.bottom
            topMargin: Theme.itemSpacingSmall
            horizontalCenter: parent.horizontalCenter
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            hideExtendedStatusBarTimer.restart()
            extendedStatusBarButton.clicked()
        }

        onPressAndHold: {
            hideExtendedStatusBarTimer.restart()
            extendedStatusBarButton.pressAndHold()
        }
    }
}
