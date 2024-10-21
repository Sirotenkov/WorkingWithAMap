import QtQuick 2.6
import Sailfish.Silica 1.0

import QtPositioning 5.3
import QtLocation 5.0
import "../assets"

Page {
    PositionSource {
        id: positionSource
        updateInterval: 100
        nmeaSource: Qt.resolvedUrl("../../nmea/path.nmea")
        active: false // true
    }

    Component.onCompleted: {
        map.center = QtPositioning.coordinate(55.751244, 37.618423)
        map.addMapItem(positionIcon)
    }

    Binding {
        target: map
        property: "center"
        value: positionSource.position.coordinate
        when: positionSource.position.coordinate.isValid && positionSource.active
    }

    Map {
        id: map
        anchors.fill: parent

        plugin: Plugin {
            id: mapPlugin
            objectName: "mapPlugin"
            name: "webtiles"
            allowExperimental: false

            PluginParameter {name: "webtiles.scheme"; value: "https"}
            PluginParameter {name: "webtiles.host"; value: "tile.openstreetmap.org"}
            PluginParameter {name: "webtiles.path"; value: "/${z}/${x}/${y}.png"}
        }

        MapQuickItem {
            id: positionIcon
            coordinate: positionSource.position.coordinate
            sourceItem: Image {
                width: Theme.itemSizeExtraSmall
                height: Theme.itemSizeExtraSmall
                source: Qt.resolvedUrl("../icons/pin.svg")
                sourceSize.width: width
                sourceSize.height: height
            }
            anchorPoint.x: width * 0.5
            anchorPoint.y: height
            visible: positionSource.active
        }

        zoomLevel: slider.value
    }

    Slider {
        id: slider
        width: parent.width / 2.0
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: Theme.paddingLarge
        }
        animateValue: true
        enabled: true
        handleVisible: true
        label: qsTr("zoom")
        color: palette.highlightDimmerColor
        maximumValue: 20.0
        minimumValue: 2.0
        value: 15.0
        valueText: qsTr("Current zoom") + ": " + value.toFixed(2)
        valueLabelColor: palette.highlightDimmerColor
        stepSize: 0.05 // 0.5
        highlighted: false
    }

    IconButton {
        width: Theme.itemSizeSmall
        height: Theme.itemSizeSmall
        anchors {
            verticalCenter: slider.verticalCenter
            right: parent.right
            rightMargin: Theme.paddingLarge
        }
        icon.source: Qt.resolvedUrl("../icons/satellite.svg")
        icon.sourceSize.width: width
        icon.sourceSize.height: height
        icon.color: positionSource.active ? "red" : "black"
        onClicked: positionSource.active = !positionSource.active
    }
}
