/*
 * Copyright (C) 2026  renzard politakis
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * notes is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.9

MainView {
    id: root
    applicationName: "trollculator"
    width: units.gu(45)
    height: units.gu(75)
    backgroundColor: "#2f2f2f"

    property string display: "0"
    property bool resetOnNextInput: false

    function handlePress(btn) {
        if (resetOnNextInput && !isNaN(btn)) {
            display = "0"
            resetOnNextInput = false
        }

        if (!isNaN(btn)) {
            if (display === "0") {
                display = btn
            } else {
                display += btn
            }
        } else if (["+", "-", "*", "/"].indexOf(btn) !== -1) {
            if (resetOnNextInput) resetOnNextInput = false
            display += " " + btn + " "
        } else if (btn === "C") {
            display = "0"
            resetOnNextInput = false
        } else if (btn === "=") {
            var parts = display.split(" ")
            if (parts.length >= 3) {
                var a = parseFloat(parts[0])
                var currentOp = parts[1]
                var b = parseFloat(parts[2])
                var result = ""

                if (currentOp === "+" && a === 1 && b === 1) {
                    result = "Hello World"
                } else if (currentOp === "+" && a === 6 && b === 7) {
                    result = "67"
                } else if (currentOp === "*" && a === 2 && b === 2) {
                    result = "4"
                    planktonOverlay.visible = true
                    planktonMusic.play()
                    planktonTimer.restart()
                } else if (currentOp === "/" && a === 5 && b === 5) {
                    result = "1"
                    funnyOverlay.visible = true
                    funnyMusic.play()
                    funnyTimer.restart()
                } else {
                    var correct = 0
                    if (currentOp === "+") correct = a + b
                    else if (currentOp === "-") correct = a - b
                    else if (currentOp === "*") correct = a * b
                    else if (currentOp === "/") correct = b !== 0 ? a / b : 0

                    var trollOffset = Math.floor(Math.random() * 5) + 1
                    if (Math.random() > 0.5) trollOffset = -trollOffset

                    result = (correct + trollOffset).toString()
                }

                display = result
                resetOnNextInput = true
            }
        }
    }

    Page {
        anchors.fill: parent
        
        header: PageHeader {
            id: pageHeader
            title: "Calculator"
            trailingActionBar.actions: [
                Action {
                    iconName: "contact"
                    text: "Login"
                    onTriggered: {
                        loginOverlay.visible = true
                    }
                }
            ]
        }

        ColumnLayout {
            anchors.top: pageHeader.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: units.gu(2)
            spacing: units.gu(1)

            Rectangle {
                Layout.fillWidth: true
                height: units.gu(10)
                color: "#111111"
                radius: units.gu(1)

                Label {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: units.gu(2)
                    text: root.display
                    color: "white"
                    font.pixelSize: units.gu(4)
                    fontSizeMode: Text.Fit
                    maximumLineCount: 1
                    width: parent.width - units.gu(4)
                    horizontalAlignment: Text.AlignRight
                }
            }

            GridLayout {
                columns: 4
                Layout.fillWidth: true
                Layout.fillHeight: true

                Repeater {
                    model: ["7", "8", "9", "/",
                            "4", "5", "6", "*",
                            "1", "2", "3", "-",
                            "C", "0", "=", "+"]

                    Button {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        text: modelData
                        color: (modelData === "=" || modelData === "C") ? LomiriColors.orange : LomiriColors.slate
                        onClicked: root.handlePress(modelData)
                    }
                }
            }
        }

        // --- ΟΘΟΝΗ ΕΙΣΑΓΩΓΗΣ USERNAME & PASSWORD ---
        Rectangle {
            id: loginOverlay
            anchors.fill: parent
            color: "#222222"
            visible: false
            z: 99

            Column {
                anchors.centerIn: parent
                spacing: units.gu(2.5)
                width: parent.width - units.gu(6)

                Label {
                    text: "Account Login"
                    color: "white"
                    font.pixelSize: units.gu(3)
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TextField {
                    id: userField
                    placeholderText: "Username"
                    width: parent.width
                }

                TextField {
                    id: passField
                    placeholderText: "Password"
                    echoMode: TextInput.Password
                    width: parent.width
                }

                Button {
                    text: "Sign In"
                    color: LomiriColors.orange
                    width: parent.width
                    onClicked: {
                        loginOverlay.visible = false
                        jokeOverlay.visible = true
                        jokeMusic.play()
                    }
                }

                Button {
                    text: "Cancel"
                    color: LomiriColors.slate
                    width: parent.width
                    onClicked: {
                        loginOverlay.visible = false
                    }
                }
            }
        }

        // --- Η ΟΘΟΝΗ ΤΟΥ PLANKTON (2 * 2) ---
        Rectangle {
            id: planktonOverlay
            anchors.fill: parent
            color: "black"
            visible: false
            z: 110

            MediaPlayer {
                id: planktonMusic
                source: "Plankton Aughhhhh - Funny MEME Sound Effect.mp3"
            }

            Timer {
                id: planktonTimer
                interval: 7000 // 7 δευτερόλεπτα
                running: false
                repeat: false
                onTriggered: {
                    planktonMusic.stop()
                    planktonOverlay.visible = false
                }
            }

            Column {
                anchors.centerIn: parent
                spacing: units.gu(3)

                Image {
                    source: "13ab78cf52f96093563fbdfe21b72e47-3437736866.jpg"
                    width: units.gu(35)
                    height: units.gu(35)
                    fillMode: Image.PreserveAspectFit
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // --- Η ΟΘΟΝΗ ΤΟΥ ΝΕΟΥ MEME (5 / 5) ---
        Rectangle {
            id: funnyOverlay
            anchors.fill: parent
            color: "black"
            visible: false
            z: 115

            MediaPlayer {
                id: funnyMusic
                source: "Funny sound that will make you laugh.mp3"
            }

            Timer {
                id: funnyTimer
                interval: 7000 // 7 δευτερόλεπτα
                running: false
                repeat: false
                onTriggered: {
                    funnyMusic.stop()
                    funnyOverlay.visible = false
                }
            }

            Column {
                anchors.centerIn: parent
                spacing: units.gu(3)

                Image {
                    source: "bc39d92888c7edcb3d948ea9cf4b1961-2174070125.jpg"
                    width: units.gu(35)
                    height: units.gu(35)
                    fillMode: Image.PreserveAspectFit
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // --- Η ΟΘΟΝΗ ΤΟΥ TROLL (ΓΑΤΑ + ΜΟΥΣΙΚΗ) ---
        Rectangle {
            id: jokeOverlay
            anchors.fill: parent
            color: "black"
            visible: false
            z: 100

            MediaPlayer {
                id: jokeMusic
                source: "Wii music.mp3"
            }

            Column {
                anchors.centerIn: parent
                spacing: units.gu(3)

                Image {
                    source: "cover3-1217099268.jpg"
                    width: units.gu(30)
                    height: units.gu(30)
                    fillMode: Image.PreserveAspectFit
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    text: "Why would you want to login to a calculator?"
                    color: "white"
                    font.pixelSize: units.gu(3)
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    width: jokeOverlay.width - units.gu(4)
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    text: "Back"
                    color: LomiriColors.orange
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        jokeOverlay.visible = false
                        jokeMusic.stop()
                    }
                }
            }
        }
    }
}