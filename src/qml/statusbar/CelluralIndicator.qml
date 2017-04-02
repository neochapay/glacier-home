import QtQuick 2.0
import QtQuick.Controls.Nemo 1.0
import org.nemomobile.lipstick 0.1
import org.freedesktop.contextkit 1.0

StatusbarItem {

    ContextProperty {
        id: cellularSignalBars
        key: "Cellular.SignalBars"
    }

    ContextProperty {
        id: cellularRegistrationStatus
        key: "Cellular.RegistrationStatus"
    }

    ContextProperty {
        id: cellularNetworkName
        key: "Cellular.NetworkName"
    }

    ContextProperty {
        id: cellularDataTechnology
        key: "Cellular.DataTechnology"
    }

    iconSize: root.height/2
    source: (cellularSignalBars.value) ? "/usr/share/lipstick-glacier-home-qt5/qml/images/signal_"+cellularSignalBars.value+".svg" : "/usr/share/lipstick-glacier-home-qt5/qml/images/signal_0.svg"

    Label {
        id: celluralDataLabel

        visible: cellularDataTechnology.value
        font.pixelSize: parent.height/4

        anchors{
            top: parent.top
            topMargin: parent.height/10
            right: parent.horizontalCenter
        }

        text: {
            var techToG = {gprs: "2", egprs: "2.5", umts: "3", hspa: "3.5", lte: "4", unknown: "0"}
            return techToG[cellularDataTechnology.value ? cellularDataTechnology.value : "unknown"] + "G"
        }
    }

    MouseArea{
        anchors.fill: parent
        onPressAndHold: {
            var screenShotPath = "/home/nemo/Pictures/Screenshots/"
            var file = "glacier-screenshot-"+Qt.formatDateTime(new Date, "yyMMdd_hhmmss")+".png"
            Lipstick.takeScreenshot(screenShotPath + file);
            console.log("Screenshot created")
        }
    }
}
