/*
 * Copyright (C) 2026  renzard politakis
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * notes is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

MainView {
    id: root
    applicationName: "trollculator"
    width: units.gu(45)
    height: units.gu(75)
    backgroundColor: "#2f2f2f"

    property string display: "0"
    property double firstNum: 0
    property string op: ""
    property bool isNewNumber: true

    function handlePress(btn) {
        if (!isNaN(btn)) {
            if (display === "0" || isNewNumber) {
                display = btn
                isNewNumber = false
            } else {
                display += btn
            }
        } else if (btn === "C") {
            display = "0"
            firstNum = 0
            op = ""
            isNewNumber = true
        } else if (["+", "-", "*", "/"].indexOf(btn) !== -1) {
            firstNum = parseFloat(display)
            op = btn
            isNewNumber = true
        } else if (btn === "=") {
            if (op !== "") {
                var a = firstNum
                var b = parseFloat(display)

                // Troll κανόνας: 1 + 1 = Hello World
                if (op === "+" && a === 1 && b === 1) {
                    display = "Hello World"
                } 
                // Ειδικός κανόνας: 6 + 7 = 67
                else if (op === "+" && a === 6 && b === 7) {
                    display = "67"
                } else {
                    var correct = 0
                    if (op === "+") correct = a + b
                    else if (op === "-") correct = a - b
                    else if (op === "*") correct = a * b
                    else if (op === "/") correct = b !== 0 ? a / b : 0

                    // Πάντα λάθος αποτέλεσμα με τυχαία απόκλιση (±1 έως ±5)
                    var trollOffset = Math.floor(Math.random() * 5) + 1
                    if (Math.random() > 0.5) trollOffset = -trollOffset

                    display = (correct + trollOffset).toString()
                }

                op = ""
                isNewNumber = true
            }
        }
    }

    Page {
        anchors.fill: parent
        header: null

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: units.gu(2)
            anchors.rightMargin: units.gu(2)
            anchors.bottomMargin: units.gu(2)
            anchors.topMargin: units.gu(6)
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
                    font.pixelSize: units.gu(5)
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
    }
}