import QtQuick 2.0
import MeeGo.Connman 0.2

StatusbarItem {

    NetworkTechnology {
        id: wlan
    }

    NetworkManager {
        id: networkManager
        function updateTechnologies() {
            if (available && technologiesEnabled) {
                wlan.path = networkManager.technologyPathForType("wifi")
            }
        }
        onAvailableChanged: updateTechnologies()
        onTechnologiesEnabledChanged: updateTechnologies()
        onTechnologiesChanged: updateTechnologies()

    }

    iconSize: root.height/2
    source: {
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
                return "image://theme/icon_wifi_normal4"
            }
        } else {
            return "image://theme/icon_wifi_0"
        }
    }
    panel: WifiPanel {}
}
