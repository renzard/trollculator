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
import QtFeedback 5.0

MainView {
    id: root
    applicationName: "trollculator"
    width: units.gu(45)
    height: units.gu(75)
    
    backgroundColor: darkMode ? "#000000" : "#f2f2f7"

    property string display: "0"
    property bool resetOnNextInput: false

    property bool soundEnabled: true
    property bool vibeEnabled: true
    property bool darkMode: true
    property bool trollModeEnabled: true  // Νέα ιδιότητα για το Troll Mode
    property int uiStyle: 1  // 1 = iOS, 2 = Ubuntu Classic, 3 = Original First, 4 = Firsht UI

    HapticsEffect {
        id: buttonVibe
        intensity: 1.0  
        duration: 30    
    }

    MediaPlayer {
        id: clickSound
        source: "freesound_community-pick-92276.mp3" 
    }

    function handlePress(btn) {
        if (btn === "" || btn === " ") return;

        if (vibeEnabled) {
            buttonVibe.start();
        }
        
        if (soundEnabled) {
            clickSound.stop(); 
            clickSound.play();
        }

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

                if (trollModeEnabled) {
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
                } else {
                    var calcResult = 0
                    if (currentOp === "+") calcResult = a + b
                    else if (currentOp === "-") calcResult = a - b
                    else if (currentOp === "*") calcResult = a * b
                    else if (currentOp === "/") calcResult = b !== 0 ? a / b : 0

                    result = calcResult.toString()
                }

                display = result
                resetOnNextInput = true
            }
        }
    }

    Page {
        anchors.fill: parent
        
        header: Item {} 

        // --- CUSTOM SETTINGS BUTTON (Πάνω Αριστερά) ---
        Rectangle {
            id: customSettingsBtn
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: units.gu(2)
            anchors.leftMargin: units.gu(2)
            width: units.gu(5)
            height: width
            radius: width / 2
            color: settingsMouseArea.pressed ? (darkMode ? "#666666" : "#cccccc") : (darkMode ? "#333333" : "#e5e5ea")
            z: 10 

            Text {
                anchors.centerIn: parent
                text: "⚙"
                color: darkMode ? "white" : "black"
                font.pixelSize: units.gu(3)
            }

            MouseArea {
                id: settingsMouseArea
                anchors.fill: parent
                onClicked: {
                    if (vibeEnabled) buttonVibe.start()
                    if (soundEnabled) { clickSound.stop(); clickSound.play(); }
                    settingsOverlay.visible = true
                }
            }
        }

        // --- CUSTOM LOGIN BUTTON (Πάνω Δεξιά) ---
        Rectangle {
            id: customLoginBtn
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: units.gu(2)
            anchors.rightMargin: units.gu(2)
            width: units.gu(5)
            height: width
            radius: width / 2
            color: loginMouseArea.pressed ? (darkMode ? "#666666" : "#cccccc") : (darkMode ? "#333333" : "#e5e5ea")
            z: 10 

            Icon {
                anchors.centerIn: parent
                name: "contact"
                color: darkMode ? "white" : "black"
                width: units.gu(2.5)
                height: units.gu(2.5)
            }

            MouseArea {
                id: loginMouseArea
                anchors.fill: parent
                onClicked: {
                    if (vibeEnabled) buttonVibe.start()
                    if (soundEnabled) { clickSound.stop(); clickSound.play(); }
                    loginOverlay.visible = true
                }
            }
        }

        // ==========================================
        // UI 1: iOS STYLE LAYOUT
        // ==========================================
        ColumnLayout {
            anchors.top: customLoginBtn.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: units.gu(2)
            spacing: units.gu(1.5)
            visible: root.uiStyle === 1

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Label {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: units.gu(1)
                    anchors.bottomMargin: units.gu(1)
                    text: root.display
                    color: darkMode ? "#ffffff" : "#000000"
                    font.pixelSize: units.gu(7)
                    fontSizeMode: Text.Fit
                    maximumLineCount: 1
                    width: parent.width - units.gu(2)
                    horizontalAlignment: Text.AlignRight
                }
            }

            GridLayout {
                columns: 4
                Layout.fillWidth: true
                columnSpacing: units.gu(1.2)
                rowSpacing: units.gu(1.2)

                // Row 1
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btnC1.pressed ? "#d9d9d9" : (darkMode ? "#a5a5a5" : "#e5e5ea")
                    Text { anchors.centerIn: parent; text: "C"; color: "black"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: btnC1; anchors.fill: parent; onClicked: root.handlePress("C") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btnSign1.pressed ? "#d9d9d9" : (darkMode ? "#a5a5a5" : "#e5e5ea")
                    Text { anchors.centerIn: parent; text: "+/-"; color: "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: btnSign1; anchors.fill: parent }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btnPercent1.pressed ? "#d9d9d9" : (darkMode ? "#a5a5a5" : "#e5e5ea")
                    Text { anchors.centerIn: parent; text: "%"; color: "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: btnPercent1; anchors.fill: parent }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btnDiv1.pressed ? "#cc7f08" : "#ff9f0a"
                    Text { anchors.centerIn: parent; text: "÷"; color: "white"; font.pixelSize: units.gu(4) }
                    MouseArea { id: btnDiv1; anchors.fill: parent; onClicked: root.handlePress("/") }
                }

                // Row 2
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btn7_1.pressed ? (darkMode ? "#666666" : "#d1d1d6") : (darkMode ? "#333333" : "#ffffff")
                    Text { anchors.centerIn: parent; text: "7"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: btn7_1; anchors.fill: parent; onClicked: root.handlePress("7") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btn8_1.pressed ? (darkMode ? "#666666" : "#d1d1d6") : (darkMode ? "#333333" : "#ffffff")
                    Text { anchors.centerIn: parent; text: "8"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: btn8_1; anchors.fill: parent; onClicked: root.handlePress("8") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btn9_1.pressed ? (darkMode ? "#666666" : "#d1d1d6") : (darkMode ? "#333333" : "#ffffff")
                    Text { anchors.centerIn: parent; text: "9"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: btn9_1; anchors.fill: parent; onClicked: root.handlePress("9") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btnMul1.pressed ? "#cc7f08" : "#ff9f0a"
                    Text { anchors.centerIn: parent; text: "×"; color: "white"; font.pixelSize: units.gu(4) }
                    MouseArea { id: btnMul1; anchors.fill: parent; onClicked: root.handlePress("*") }
                }

                // Row 3
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btn4_1.pressed ? (darkMode ? "#666666" : "#d1d1d6") : (darkMode ? "#333333" : "#ffffff")
                    Text { anchors.centerIn: parent; text: "4"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: btn4_1; anchors.fill: parent; onClicked: root.handlePress("4") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btn5_1.pressed ? (darkMode ? "#666666" : "#d1d1d6") : (darkMode ? "#333333" : "#ffffff")
                    Text { anchors.centerIn: parent; text: "5"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: btn5_1; anchors.fill: parent; onClicked: root.handlePress("5") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btn6_1.pressed ? (darkMode ? "#666666" : "#d1d1d6") : (darkMode ? "#333333" : "#ffffff")
                    Text { anchors.centerIn: parent; text: "6"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: btn6_1; anchors.fill: parent; onClicked: root.handlePress("6") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btnSub1.pressed ? "#cc7f08" : "#ff9f0a"
                    Text { anchors.centerIn: parent; text: "-"; color: "white"; font.pixelSize: units.gu(4) }
                    MouseArea { id: btnSub1; anchors.fill: parent; onClicked: root.handlePress("-") }
                }

                // Row 4
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btn1_1.pressed ? (darkMode ? "#666666" : "#d1d1d6") : (darkMode ? "#333333" : "#ffffff")
                    Text { anchors.centerIn: parent; text: "1"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: btn1_1; anchors.fill: parent; onClicked: root.handlePress("1") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btn2_1.pressed ? (darkMode ? "#666666" : "#d1d1d6") : (darkMode ? "#333333" : "#ffffff")
                    Text { anchors.centerIn: parent; text: "2"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: btn2_1; anchors.fill: parent; onClicked: root.handlePress("2") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btn3_1.pressed ? (darkMode ? "#666666" : "#d1d1d6") : (darkMode ? "#333333" : "#ffffff")
                    Text { anchors.centerIn: parent; text: "3"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: btn3_1; anchors.fill: parent; onClicked: root.handlePress("3") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: width; radius: width / 2
                    color: btnAdd1.pressed ? "#cc7f08" : "#ff9f0a"
                    Text { anchors.centerIn: parent; text: "+"; color: "white"; font.pixelSize: units.gu(4) }
                    MouseArea { id: btnAdd1; anchors.fill: parent; onClicked: root.handlePress("+") }
                }

                // Row 5
                Rectangle {
                    Layout.fillWidth: true; Layout.columnSpan: 2; Layout.preferredHeight: units.gu(7.5); radius: height / 2
                    color: btn0_1.pressed ? (darkMode ? "#666666" : "#d1d1d6") : (darkMode ? "#333333" : "#ffffff")
                    Text {
                        anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; anchors.leftMargin: units.gu(3)
                        text: "0"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3.5)
                    }
                    MouseArea { id: btn0_1; anchors.fill: parent; onClicked: root.handlePress("0") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.columnSpan: 2; Layout.preferredHeight: units.gu(7.5); radius: height / 2
                    color: btnEq1.pressed ? "#cc7f08" : "#ff9f0a"
                    Text { anchors.centerIn: parent; text: "="; color: "white"; font.pixelSize: units.gu(4) }
                    MouseArea { id: btnEq1; anchors.fill: parent; onClicked: root.handlePress("=") }
                }
            }
        }

        // ==========================================
        // UI 2: CLASSIC UBUNTU TOUCH STYLE LAYOUT
        // ==========================================
        ColumnLayout {
            anchors.top: customLoginBtn.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: units.gu(1)
            spacing: units.gu(1)
            visible: root.uiStyle === 2

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(12)
                color: darkMode ? "#111111" : "#e0e0e0"
                radius: units.gu(1)

                Label {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: units.gu(2)
                    anchors.bottomMargin: units.gu(2)
                    text: root.display
                    color: darkMode ? "#E95420" : "#77216F"
                    font.pixelSize: units.gu(6)
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
                columnSpacing: units.gu(0.5)
                rowSpacing: units.gu(0.5)

                // Row 1
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ubC.pressed ? "#555" : "#333"
                    Text { anchors.centerIn: parent; text: "C"; color: "white"; font.pixelSize: units.gu(3) }
                    MouseArea { id: ubC; anchors.fill: parent; onClicked: root.handlePress("C") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ubSign.pressed ? "#555" : "#333"
                    Text { anchors.centerIn: parent; text: "+/-"; color: "white"; font.pixelSize: units.gu(2.5) }
                    MouseArea { id: ubSign; anchors.fill: parent }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ubPercent.pressed ? "#555" : "#333"
                    Text { anchors.centerIn: parent; text: "%"; color: "white"; font.pixelSize: units.gu(3) }
                    MouseArea { id: ubPercent; anchors.fill: parent }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ubDiv.pressed ? "#c43d00" : "#E95420"
                    Text { anchors.centerIn: parent; text: "÷"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: ubDiv; anchors.fill: parent; onClicked: root.handlePress("/") }
                }

                // Row 2
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ub7.pressed ? "#444" : "#222"
                    Text { anchors.centerIn: parent; text: "7"; color: "white"; font.pixelSize: units.gu(3) }
                    MouseArea { id: ub7; anchors.fill: parent; onClicked: root.handlePress("7") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ub8.pressed ? "#444" : "#222"
                    Text { anchors.centerIn: parent; text: "8"; color: "white"; font.pixelSize: units.gu(3) }
                    MouseArea { id: ub8; anchors.fill: parent; onClicked: root.handlePress("8") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ub9.pressed ? "#444" : "#222"
                    Text { anchors.centerIn: parent; text: "9"; color: "white"; font.pixelSize: units.gu(3) }
                    MouseArea { id: ub9; anchors.fill: parent; onClicked: root.handlePress("9") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ubMul.pressed ? "#c43d00" : "#E95420"
                    Text { anchors.centerIn: parent; text: "×"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: ubMul; anchors.fill: parent; onClicked: root.handlePress("*") }
                }

                // Row 3
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ub4.pressed ? "#444" : "#222"
                    Text { anchors.centerIn: parent; text: "4"; color: "white"; font.pixelSize: units.gu(3) }
                    MouseArea { id: ub4; anchors.fill: parent; onClicked: root.handlePress("4") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ub5.pressed ? "#444" : "#222"
                    Text { anchors.centerIn: parent; text: "5"; color: "white"; font.pixelSize: units.gu(3) }
                    MouseArea { id: ub5; anchors.fill: parent; onClicked: root.handlePress("5") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ub6.pressed ? "#444" : "#222"
                    Text { anchors.centerIn: parent; text: "6"; color: "white"; font.pixelSize: units.gu(3) }
                    MouseArea { id: ub6; anchors.fill: parent; onClicked: root.handlePress("6") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ubSub.pressed ? "#c43d00" : "#E95420"
                    Text { anchors.centerIn: parent; text: "-"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: ubSub; anchors.fill: parent; onClicked: root.handlePress("-") }
                }

                // Row 4
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ub1.pressed ? "#444" : "#222"
                    Text { anchors.centerIn: parent; text: "1"; color: "white"; font.pixelSize: units.gu(3) }
                    MouseArea { id: ub1; anchors.fill: parent; onClicked: root.handlePress("1") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ub2.pressed ? "#444" : "#222"
                    Text { anchors.centerIn: parent; text: "2"; color: "white"; font.pixelSize: units.gu(3) }
                    MouseArea { id: ub2; anchors.fill: parent; onClicked: root.handlePress("2") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ub3.pressed ? "#444" : "#222"
                    Text { anchors.centerIn: parent; text: "3"; color: "white"; font.pixelSize: units.gu(3) }
                    MouseArea { id: ub3; anchors.fill: parent; onClicked: root.handlePress("3") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    color: ubAdd.pressed ? "#c43d00" : "#E95420"
                    Text { anchors.centerIn: parent; text: "+"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: ubAdd; anchors.fill: parent; onClicked: root.handlePress("+") }
                }

                // Row 5
                Rectangle {
                    Layout.fillWidth: true; Layout.columnSpan: 2; Layout.fillHeight: true
                    color: ub0.pressed ? "#444" : "#222"
                    Text { anchors.centerIn: parent; text: "0"; color: "white"; font.pixelSize: units.gu(3) }
                    MouseArea { id: ub0; anchors.fill: parent; onClicked: root.handlePress("0") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.columnSpan: 2; Layout.fillHeight: true
                    color: ubEq.pressed ? "#5f1958" : "#77216F"
                    Text { anchors.centerIn: parent; text: "="; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: ubEq; anchors.fill: parent; onClicked: root.handlePress("=") }
                }
            }
        }

        // ==========================================
        // UI 3: THE ORIGINAL FIRST STYLE LAYOUT
        // ==========================================
        ColumnLayout {
            anchors.top: customLoginBtn.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: units.gu(2)
            spacing: units.gu(1.5)
            visible: root.uiStyle === 3

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(10)

                Label {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: units.gu(1)
                    anchors.bottomMargin: units.gu(1)
                    text: root.display
                    color: darkMode ? "#ffffff" : "#000000"
                    font.pixelSize: units.gu(5)
                    fontSizeMode: Text.Fit
                    maximumLineCount: 1
                    width: parent.width - units.gu(2)
                    horizontalAlignment: Text.AlignRight
                }
            }

            GridLayout {
                columns: 4
                Layout.fillWidth: true
                Layout.fillHeight: true
                columnSpacing: units.gu(1)
                rowSpacing: units.gu(1)

                // Row 1
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: origC.pressed ? "#d9d9d9" : (darkMode ? "#444" : "#ddd")
                    Text { anchors.centerIn: parent; text: "C"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: origC; anchors.fill: parent; onClicked: root.handlePress("C") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: origSign.pressed ? "#d9d9d9" : (darkMode ? "#444" : "#ddd")
                    Text { anchors.centerIn: parent; text: "+/-"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(2.5) }
                    MouseArea { id: origSign; anchors.fill: parent }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: origPercent.pressed ? "#d9d9d9" : (darkMode ? "#444" : "#ddd")
                    Text { anchors.centerIn: parent; text: "%"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: origPercent; anchors.fill: parent }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: origDiv.pressed ? "#005a9e" : "#0078d4"
                    Text { anchors.centerIn: parent; text: "÷"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: origDiv; anchors.fill: parent; onClicked: root.handlePress("/") }
                }

                // Row 2
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: orig7.pressed ? (darkMode ? "#555" : "#ccc") : (darkMode ? "#2b2b2b" : "#f9f9f9")
                    Text { anchors.centerIn: parent; text: "7"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: orig7; anchors.fill: parent; onClicked: root.handlePress("7") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: orig8.pressed ? (darkMode ? "#555" : "#ccc") : (darkMode ? "#2b2b2b" : "#f9f9f9")
                    Text { anchors.centerIn: parent; text: "8"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: orig8; anchors.fill: parent; onClicked: root.handlePress("8") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: orig9.pressed ? (darkMode ? "#555" : "#ccc") : (darkMode ? "#2b2b2b" : "#f9f9f9")
                    Text { anchors.centerIn: parent; text: "9"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: orig9; anchors.fill: parent; onClicked: root.handlePress("9") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: origMul.pressed ? "#005a9e" : "#0078d4"
                    Text { anchors.centerIn: parent; text: "×"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: origMul; anchors.fill: parent; onClicked: root.handlePress("*") }
                }

                // Row 3
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: orig4.pressed ? (darkMode ? "#555" : "#ccc") : (darkMode ? "#2b2b2b" : "#f9f9f9")
                    Text { anchors.centerIn: parent; text: "4"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: orig4; anchors.fill: parent; onClicked: root.handlePress("4") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: orig5.pressed ? (darkMode ? "#555" : "#ccc") : (darkMode ? "#2b2b2b" : "#f9f9f9")
                    Text { anchors.centerIn: parent; text: "5"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: orig5; anchors.fill: parent; onClicked: root.handlePress("5") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: orig6.pressed ? (darkMode ? "#555" : "#ccc") : (darkMode ? "#2b2b2b" : "#f9f9f9")
                    Text { anchors.centerIn: parent; text: "6"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: orig6; anchors.fill: parent; onClicked: root.handlePress("6") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: origSub.pressed ? "#005a9e" : "#0078d4"
                    Text { anchors.centerIn: parent; text: "-"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: origSub; anchors.fill: parent; onClicked: root.handlePress("-") }
                }

                // Row 4
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: orig1.pressed ? (darkMode ? "#555" : "#ccc") : (darkMode ? "#2b2b2b" : "#f9f9f9")
                    Text { anchors.centerIn: parent; text: "1"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: orig1; anchors.fill: parent; onClicked: root.handlePress("1") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: orig2.pressed ? (darkMode ? "#555" : "#ccc") : (darkMode ? "#2b2b2b" : "#f9f9f9")
                    Text { anchors.centerIn: parent; text: "2"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: orig2; anchors.fill: parent; onClicked: root.handlePress("2") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: orig3.pressed ? (darkMode ? "#555" : "#ccc") : (darkMode ? "#2b2b2b" : "#f9f9f9")
                    Text { anchors.centerIn: parent; text: "3"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: orig3; anchors.fill: parent; onClicked: root.handlePress("3") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: origAdd.pressed ? "#005a9e" : "#0078d4"
                    Text { anchors.centerIn: parent; text: "+"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: origAdd; anchors.fill: parent; onClicked: root.handlePress("+") }
                }

                // Row 5
                Rectangle {
                    Layout.fillWidth: true; Layout.columnSpan: 2; Layout.fillHeight: true; radius: units.gu(1)
                    color: orig0.pressed ? (darkMode ? "#555" : "#ccc") : (darkMode ? "#2b2b2b" : "#f9f9f9")
                    Text { anchors.centerIn: parent; text: "0"; color: darkMode ? "white" : "black"; font.pixelSize: units.gu(3) }
                    MouseArea { id: orig0; anchors.fill: parent; onClicked: root.handlePress("0") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.columnSpan: 2; Layout.fillHeight: true; radius: units.gu(1)
                    color: origEq.pressed ? "#005a9e" : "#0078d4"
                    Text { anchors.centerIn: parent; text: "="; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: origEq; anchors.fill: parent; onClicked: root.handlePress("=") }
                }
            }
        }

        // ==========================================
        // UI 4: FIRSHT UI LAYOUT (EXACT MATCH)
        // ==========================================
        ColumnLayout {
            anchors.top: customLoginBtn.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: units.gu(1.5)
            spacing: units.gu(1)
            visible: root.uiStyle === 4

            // Display Box matching the screenshot style
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: units.gu(12)
                color: "#1c1c1e"
                radius: units.gu(1)

                Label {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: units.gu(2)
                    text: root.display
                    color: "#ffffff"
                    font.pixelSize: units.gu(5.5)
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
                columnSpacing: units.gu(1)
                rowSpacing: units.gu(1)

                // Row 1
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shot7.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "7"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shot7; anchors.fill: parent; onClicked: root.handlePress("7") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shot8.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "8"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shot8; anchors.fill: parent; onClicked: root.handlePress("8") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shot9.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "9"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shot9; anchors.fill: parent; onClicked: root.handlePress("9") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shotDiv.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "/"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shotDiv; anchors.fill: parent; onClicked: root.handlePress("/") }
                }

                // Row 2
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shot4.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "4"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shot4; anchors.fill: parent; onClicked: root.handlePress("4") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shot5.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "5"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shot5; anchors.fill: parent; onClicked: root.handlePress("5") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shot6.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "6"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shot6; anchors.fill: parent; onClicked: root.handlePress("6") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shotMul.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "*"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shotMul; anchors.fill: parent; onClicked: root.handlePress("*") }
                }

                // Row 3
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shot1.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "1"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shot1; anchors.fill: parent; onClicked: root.handlePress("1") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shot2.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "2"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shot2; anchors.fill: parent; onClicked: root.handlePress("2") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shot3.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "3"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shot3; anchors.fill: parent; onClicked: root.handlePress("3") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shotSub.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "-"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shotSub; anchors.fill: parent; onClicked: root.handlePress("-") }
                }

                // Row 4
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shotC.pressed ? "#cc5500" : "#ff6600"
                    Text { anchors.centerIn: parent; text: "C"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shotC; anchors.fill: parent; onClicked: root.handlePress("C") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shot0.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "0"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shot0; anchors.fill: parent; onClicked: root.handlePress("0") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shotEq.pressed ? "#cc5500" : "#ff6600"
                    Text { anchors.centerIn: parent; text: "="; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shotEq; anchors.fill: parent; onClicked: root.handlePress("=") }
                }
                Rectangle {
                    Layout.fillWidth: true; Layout.fillHeight: true; radius: units.gu(1)
                    color: shotAdd.pressed ? "#555555" : "#3a3a3c"
                    Text { anchors.centerIn: parent; text: "+"; color: "white"; font.pixelSize: units.gu(3.5) }
                    MouseArea { id: shotAdd; anchors.fill: parent; onClicked: root.handlePress("+") }
                }
            }
        }

        // --- ΟΘΟΝΗ ΡΥΘΜΙΣΕΩΝ (SETTINGS OVERLAY) ---
        Rectangle {
            id: settingsOverlay
            anchors.fill: parent
            color: darkMode ? "#111111" : "#ffffff"
            visible: false
            z: 98

            Column {
                anchors.centerIn: parent
                spacing: units.gu(2.5)
                width: parent.width - units.gu(6)

                Label {
                    text: "Settings"
                    color: darkMode ? "white" : "black"
                    font.pixelSize: units.gu(3.5)
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    text: root.uiStyle === 1 ? "UI Style: iOS Style" : (root.uiStyle === 2 ? "UI Style: Ubuntu Classic" : (root.uiStyle === 3 ? "UI Style: Original Style" : "UI Style: Firsht UI"))
                    color: LomiriColors.purple
                    width: parent.width
                    onClicked: {
                        root.uiStyle = (root.uiStyle % 4) + 1
                        if (vibeEnabled) buttonVibe.start()
                        if (soundEnabled) { clickSound.stop(); clickSound.play(); }
                    }
                }

                Button {
                    text: root.trollModeEnabled ? "Troll Mode: ON" : "Troll Mode: OFF"
                    color: root.trollModeEnabled ? LomiriColors.red : LomiriColors.green
                    width: parent.width
                    onClicked: {
                        root.trollModeEnabled = !root.trollModeEnabled
                        if (vibeEnabled) buttonVibe.start()
                        if (soundEnabled) { clickSound.stop(); clickSound.play(); }
                    }
                }

                Button {
                    text: root.soundEnabled ? "Sound: ON" : "Sound: OFF"
                    color: root.soundEnabled ? LomiriColors.orange : LomiriColors.slate
                    width: parent.width
                    onClicked: {
                        root.soundEnabled = !root.soundEnabled
                        if (vibeEnabled) buttonVibe.start()
                    }
                }

                Button {
                    text: root.vibeEnabled ? "Vibration: ON" : "Vibration: OFF"
                    color: root.vibeEnabled ? LomiriColors.orange : LomiriColors.slate
                    width: parent.width
                    onClicked: {
                        root.vibeEnabled = !root.vibeEnabled
                        if (vibeEnabled) buttonVibe.start()
                    }
                }

                Button {
                    text: root.darkMode ? "Theme: Dark Mode" : "Theme: Light Mode"
                    color: LomiriColors.blue
                    width: parent.width
                    onClicked: {
                        root.darkMode = !root.darkMode
                        if (vibeEnabled) buttonVibe.start()
                        if (soundEnabled) { clickSound.stop(); clickSound.play(); }
                    }
                }

                Button {
                    text: "Hack My App"
                    color: LomiriColors.red
                    width: parent.width
                    onClicked: {
                        if (vibeEnabled) buttonVibe.start()
                        if (soundEnabled) { clickSound.stop(); clickSound.play(); }
                        settingsOverlay.visible = false
                        hackerOverlay.visible = true
                        hackerMusic.play()
                    }
                }

                Button {
                    text: "Back"
                    color: LomiriColors.slate
                    width: parent.width
                    onClicked: {
                        if (vibeEnabled) buttonVibe.start()
                        if (soundEnabled) { clickSound.stop(); clickSound.play(); }
                        settingsOverlay.visible = false
                    }
                }
            }
        }

        // --- ΟΘΟΝΗ ΕΙΣΑΓΩΓΗΣ USERNAME & PASSWORD ---
        Rectangle {
            id: loginOverlay
            anchors.fill: parent
            color: darkMode ? "#222222" : "#f0f0f5"
            visible: false
            z: 99

            Column {
                anchors.centerIn: parent
                spacing: units.gu(2.5)
                width: parent.width - units.gu(6)

                Label {
                    text: "Account Login"
                    color: darkMode ? "white" : "black"
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

        // --- Η ΟΘΟΝΗ ΤΟΥ HACKER (HACK MY APP) ---
        Rectangle {
            id: hackerOverlay
            anchors.fill: parent
            color: "black"
            visible: false
            z: 120

            MediaPlayer {
                id: hackerMusic
                source: "DUN DUN DUNNNNN!! _ (SOUND EFFECT)DOWNLOAD.mp3"
            }

            Column {
                anchors.centerIn: parent
                spacing: units.gu(2.5)
                width: parent.width - units.gu(4)

                Image {
                    id: hackerImage
                    source: "7fhly5-2602662083.png"
                    width: units.gu(28)
                    height: units.gu(28)
                    fillMode: Image.PreserveAspectFit
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    text: "why to try hack my app 🤨"
                    color: "white"
                    font.pixelSize: units.gu(2.8)
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    width: parent.width
                }

                Button {
                    text: "Back"
                    color: LomiriColors.orange
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        hackerOverlay.visible = false
                        hackerMusic.stop()
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
                interval: 7000
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
                interval: 7000
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
                width: parent.width - units.gu(4)

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
                    width: parent.width
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