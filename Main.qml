import QtQuick 2.11
import QtQuick.Controls 2.0
import QtQuick.Window 2.11
import QtQuick.Layouts 1.3

Window {
    id: canvas
    width: screenGeometry.width
    height: screenGeometry.height
    visible: true

    Rectangle {
        id:body
        anchors.fill: parent
        function redraw() {
            canvas.visible = true
            body.update()
        }

        Timer{
            id: redraw_timer
            interval: 300
            repeat: false

            onTriggered: redraw()
        }
        Item {
            id:header
            height: 80
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            Text{
                text: "draft launcher"
                anchors.centerIn: parent

                font.family:"Noto Serif"
                font.pixelSize:30
                font.bold: true
            }
            Rectangle{
                anchors.left:parent.left
                anchors.right:parent.right
                anchors.bottom:parent.bottom
                anchors.margins: 10
                height: 5
                color: "black"
            }
        }
        Item {
            id:footer
            height:40

            anchors{
                bottom: parent.bottom
                left:parent.left
                right:parent.right
            }

            Rectangle{
                anchors.left:parent.left
                anchors.right:parent.right
                anchors.top:parent.top
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                height: 5
                color: "black"
            }

            Text{
                text: controller.getVersion()
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins:10

                font.family:"Noto Serif"
                font.pixelSize:15
                font.bold: true
            }
        }


        Item {

            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 15

            GridView {
                id:optionsArea
                anchors.fill:parent
                cellHeight: 140
                cellWidth: 300
                interactive: false
                model: controller.getOptions();
                delegate: Rectangle{
                    id:menu_item
                    height:optionsArea.cellHeight-10
                    width:optionsArea.cellWidth-10
                    border.color: "black"
                    border.width: 2
                    states: [
                    State {
                           name:"normal"
                           PropertyChanges {
                               target: menu_item
                               color: "white"
                           }
                        },
                    State {
                           name:"clicked"
                           PropertyChanges {
                               target: menu_item
                               color: "gray"
                           }
                        }]

                    Text{
                        id:header
                        font.pixelSize: 40
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.margins: 10
                        text:model.modelData.name
                    }

                    Text {
                        id:tdesc
                        anchors.top: header.bottom
                        anchors.bottom:parent.bottom
                        anchors.left:parent.left
                        anchors.right:parent.right
                        anchors.margins: 10
                        text:model.modelData.desc
                        font.family:"Noto Serif"
                        font.pixelSize:20
                        font.italic: true
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                    MouseArea {
                        anchors.fill: parent
                        onPressed: menu_item.state = "clicked"
                        onReleased: menu_item.state = "normal"
                        onClicked: {
                           optionsArea.currentIndex = index
                           canvas.visible = false
                            //Qt.connect()
                            //blocking call
                           model.modelData.execute()
                            //redraw_timer.start()
                           Qt.callLater(body.redraw)
                        }
                    }
                }
            }
        }
    }
}
