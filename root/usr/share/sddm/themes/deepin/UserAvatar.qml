import QtQuick 2.2

Canvas {
    id: avatar
    property string source: ""
    property color m_strokeStyle: "#ffffff"

    signal clicked()


    Rectangle {
        width: 300
        height: 300
        color: "transparent"

        anchors {
            left: parent.left
            leftMargin: 0
        }

        //this Rectangle is needed to keep the source image's fillMode
        Rectangle {
            id: imageSource

            anchors.fill: parent
            Image {
                anchors.fill: parent
                sourceSize.width: width
                sourceSize.height: height
                source: "/usr/share/sddm/faces/kyukee.face.icon"
                //source: icon

                fillMode: Image.PreserveAspectCrop
            }
            visible: false

            layer.enabled: true
        }

        Rectangle {
            id: maskLayer
            anchors.fill: parent
            radius: parent.width / 2

            color: "red"
            border.color: "black"

            layer.enabled: true
            layer.samplerName: "maskSource"
            layer.effect: ShaderEffect {

                property var colorSource: imageSource
                fragmentShader: "
                    uniform lowp sampler2D colorSource;
                    uniform lowp sampler2D maskSource;
                    uniform lowp float qt_Opacity;
                    varying highp vec2 qt_TexCoord0;
                    void main() {
                        gl_FragColor =
                            texture2D(colorSource, qt_TexCoord0)
                            * texture2D(maskSource, qt_TexCoord0).a
                            * qt_Opacity;
                    }
                "
            }

        }

        // draw border line
        Rectangle {
            anchors.fill: parent

            radius: parent.width / 2

            border.color: "white"
            border.width: 4

            color: "transparent"
        }
    }




    onSourceChanged: delayPaintTimer.running = true
    onPaint: {
        var ctx = getContext("2d");
        ctx.beginPath()
        ctx.ellipse(0, 0, width, height)
        ctx.clip()
        //ctx.drawImage(source, 0, 0, width, height)
        //ctx.strokeStyle = avatar.m_strokeStyle
        //ctx.lineWidth = 6
        //ctx.stroke()
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            m_strokeStyle = "#77ffffff"
            avatar.requestPaint()
        }
        onExited: {
            m_strokeStyle = "#ffffffff"
            avatar.requestPaint()
        }
        onClicked: avatar.clicked()
    }

    // Fixme: paint() not affect event if source is not empty in initialization
    Timer {
        id: delayPaintTimer
        repeat: false
        interval: 150
        onTriggered: avatar.requestPaint()
        running: true
    }
}
