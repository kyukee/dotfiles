import QtQuick 2.0
import QtGraphicalEffects 1.0
import SddmComponents 2.0

Item {
    id: frame
    property int sessionIndex: sessionModel.lastIndex
    property string userName: userModel.lastUser
    property bool isProcessing: glowAnimation.running
    property alias input: passwdInput

    Connections {
        target: sddm
        onLoginSucceeded: {
            glowAnimation.running = false
            Qt.quit()
        }
        onLoginFailed: {
            passwdInput.echoMode = TextInput.Normal
            passwdInput.text = textConstants.loginFailed
            passwdInput.focus = false
            passwdInput.color = "#e7b222"
            glowAnimation.running = false
        }
    }

    Item {
        id: loginItem
        anchors.centerIn: parent
        width: parent.width
        height: parent.height


        UserAvatar {
            id: userIconRec
            anchors {
                top: parent.top
                topMargin: parent.height / 4
                left: parent.left
                leftMargin: parent.width / 5
            }
            width: 300
            height: 300
            source: userFrame.currentIconPath
            onClicked: {
                root.state = "stateUser"
                userFrame.focus = true
            }

        }

        Glow {
            id: avatarGlow
            anchors.fill: userIconRec
            radius: 0
            samples: 17
            color: "#99ffffff"
            source: userIconRec

            SequentialAnimation on radius {
                id: glowAnimation
                running: false
                alwaysRunToEnd: true
                loops: Animation.Infinite
                PropertyAnimation { to: 20 ; duration: 1000}
                PropertyAnimation { to: 0 ; duration: 1000}
            }
        }

        Text {
            id: userNameText
            anchors {
                left: userIconRec.right
                top: userIconRec.top
                leftMargin: 50
                topMargin: 75
                horizontalCenter: parent.horizontalCenter
            }

            text: userName
            color: textColor
            font.pointSize: 52
        }

        Rectangle {
            id: passwdInputRec
            visible: ! isProcessing
            anchors {
                top: userNameText.bottom
                left: userNameText.left
                topMargin: 60
            }
            width: 700
            height: 40
            //radius: 3 //rounded corners
            color: "blue"

            gradient: Gradient {
                GradientStop { position: 0.93; color: "transparent" }
                GradientStop { position: 1.0; color: "white" }
            }

            TextInput {
                id: passwdInput
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 6 + 0
                clip: true
                focus: true
                color: textColor
                font.pointSize: 32
                selectByMouse: true
                selectionColor: "#a8d6ec"
                echoMode: TextInput.Password
                verticalAlignment: TextInput.AlignVCenter
                onFocusChanged: {
                    if (focus) {
                        color = textColor
                        echoMode = TextInput.Password
                        text = ""
                    }
                }
                onAccepted: {
                    glowAnimation.running = true
                    sddm.login(userNameText.text, passwdInput.text, sessionIndex)
                }
                KeyNavigation.backtab: {
                    if (sessionButton.visible) {
                        return sessionButton
                    }
                    else if (userButton.visible) {
                        return userButton
                    }
                    else {
                        return shutdownButton
                    }
                }
                KeyNavigation.tab: loginButton
                Timer {
                    interval: 200
                    running: true
                    onTriggered: passwdInput.forceActiveFocus()
                }
            }
        }
    }
}
