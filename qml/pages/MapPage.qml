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
        active: false
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

        // ToDo: define plugin to work with OSM

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

        // ToDo: enable gesture recognition

        // ToDo: bind zoomLevel property to slider value

        zoomLevel: slider.value


        // ToDo: add binding of the map center to the position coordinate

        // ToDo: create MouseArea to handle clicks and holds

    }

    // ToDo: add a slider to control zoom level

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
        valueText: "Current zoom: " + value
        valueLabelColor: palette.highlightDimmerColor
        stepSize: 0.5
        highlighted: false
    }

    // ToDo: add a component corresponding to MapQuickCircle

    // ToDo: add item at the current position

    IconButton {
        width: Theme.itemSizeSmall
        height: Theme.itemSizeSmall
        anchors {
//            bottom: parent.bottom
//            bottomMargin: Theme.paddingLarge
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
