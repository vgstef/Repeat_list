/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.0
import MuseScore 1.0


MuseScore {
    version: "2.0"
    description: qsTr("This plugin lists all measure following the repeat list/symbols.")
    menuPath: "Plugins.Repeat list"
    pluginType: "dialog"
    id:window

    width:  350; height: 400;

    onRun: {
        if (typeof curScore === 'undefined')
          Qt.quit();
        }

    ListModel {
       id: repeatListModel
       //ListElement{ no: "0"; measure: "3" ; symbol: "" }
    }

    function getFormatedTime(time) {
            var hours = Math.floor(time / 1000 / 60 / 60)
            var minutes = Math.floor((time-hours*1000*60*60) / 1000 / 60)
            var seconds = Math.floor(((time-hours*1000*60*60) - minutes*1000*60) / 1000)

            return "" + (hours < 10 ? "0" + hours : hours) + ":" + (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds)
        }

    function updateList() {
        repeatListModel.clear()
        var cursor = curScore.newCursor(true);
        cursor.rewind(0);

        var i=1
        while (!cursor.eos){
            repeatListModel.append({ no: ""+i, measure: ""+(cursor.measure.no+1), utick: ""+cursor.tick, time: ""+ getFormatedTime(cursor.time), symbol: "" })
            i++
            if (!cursor.nextMeasure())
                break;
            }

        // Should highlight the row following the cursor tick of the score
        }

    // Show all measure numbers
    TableView {
        id:repeatList
        anchors.top: window.top
        anchors.left: window.left
        anchors.right: window.right
        anchors.bottom: updateListButton.top
        width:parent.width
        height:parent.height

        model: repeatListModel
        //columnCount:2
        alternatingRowColors: true
        TableViewColumn{ role: "no"  ; title: "Order" ; width: 50 }
        TableViewColumn{ role: "measure"  ; title: "Measure #" ; width: 70 }
        TableViewColumn{ role: "utick"  ; title: "utick" ; width: 70 }
        TableViewColumn{ role: "time"  ; title: "Time" ; width: 70 }
        TableViewColumn{ role: "symbol"  ; title: "Repeat sign" ; width: 100 }

        Component.onCompleted:{
            updateList();
        }

        onDoubleClicked: {
            // Should move the score cursor to the selected measure
            console.log("Double clicked ")
            }
        }

    Button {
        id : updateListButton
        text: qsTr("Update")
        anchors.bottom: window.bottom
        anchors.left: window.left
        anchors.topMargin: 10
        anchors.bottomMargin: 2
        anchors.leftMargin: 10
        onClicked: {
            updateList();
            }
        }

    Button {
        id : closePlugin
        text: qsTr("Close")
        anchors.bottom: window.bottom
        anchors.right: window.right
        anchors.topMargin: 10
        anchors.bottomMargin: 2
        anchors.leftMargin: 10
        onClicked: {
            Qt.quit();
            }
        }
}
