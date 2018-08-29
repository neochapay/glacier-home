import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

Item {
    id: contolButton
    property string image: "image://theme/image"
    property string buttonColor: "#1f1f1f"
    property string textLabel: "Toggle"

    property bool enabled: false

    signal clicked();

    height: width

    Rectangle{
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width*0.8
        height: icon.height+line.height+label.height+Theme.itemSpacingExtraSmall*5

        color: "transparent"

        Image {
            id: icon
            anchors {
                top: parent.top
                topMargin: Theme.itemSpacingExtraSmall
                horizontalCenter: parent.horizontalCenter
            }

            width: parent.width*0.8
            height: width

            source: image

            fillMode: Image.PreserveAspectFit

            sourceSize.width: width
            sourceSize.height: height

            layer.effect: ShaderEffect {
                id: shaderItem
                property color color: contolButton.enabled  ?  Theme.accentColor : Theme.textColor

                fragmentShader: "
                        varying mediump vec2 qt_TexCoord0;
                        uniform highp float qt_Opacity;
                        uniform lowp sampler2D source;
                        uniform highp vec4 color;
                        void main() {
                            highp vec4 pixelColor = texture2D(source, qt_TexCoord0);
                            gl_FragColor = vec4(mix(pixelColor.rgb/max(pixelColor.a, 0.00390625), color.rgb/max(color.a, 0.00390625), color.a) * pixelColor.a, pixelColor.a) * qt_Opacity;
                        }
                    "
            }
            layer.enabled: true
            layer.samplerName: "source"

        }

        Rectangle{
            id: line
            width: parent.width*0.8
            height: Theme.itemSpacingExtraSmall/4

            color: Theme.accentColor

            anchors{
                top: icon.bottom
                topMargin: Theme.itemSpacingExtraSmall
                horizontalCenter: parent.horizontalCenter
            }
        }

        Text{
            id: label
            anchors{
                top: line.bottom
                topMargin: Theme.itemSpacingExtraSmall
            }

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 6
            text: textLabel
            color: Theme.textColor
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                contolButton.clicked()
            }
        }
    }
}
