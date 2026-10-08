import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.active-window"


  readonly property var toplevel: ToplevelManager.activeToplevel
  readonly property string title: toplevel ? (toplevel.title || toplevel.appId || "") : ""
  readonly property int maxLabelWidth: Number(setting("maxWidth", 280))
  readonly property bool showControls: setting("showControls", true)

  visible: title !== "" && !vertical
  implicitWidth: visible ? Math.min(maxLabelWidth, labelText.implicitWidth) + Style.spacing.controlPaddingX * 2 + (showControls ? Style.space(26) : 0) : 0
  implicitHeight: barSize

  Behavior on implicitWidth {
    NumberAnimation { duration: Style.duration(180); easing.type: Easing.OutCubic }
  }

  Row {
    anchors.fill: parent
    anchors.leftMargin: Style.space(8)
    anchors.rightMargin: Style.space(4)
    spacing: Style.space(4)

    Item {
      width: Math.min(maxLabelWidth, labelText.implicitWidth)
      height: parent.height
      clip: true

      Text {
        id: labelText
        textFormat: Text.PlainText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        width: parent.width
        text: root.title
        color: root.bar ? root.bar.barForeground : Color.foreground
        font.family: root.bar ? root.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.body
        elide: Text.ElideRight
        opacity: 0.85
      }

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: function(mouse) {
          if (!root.toplevel) return
          if (mouse.button === Qt.MiddleButton || mouse.button === Qt.RightButton) {
            root.toplevel.close()
          } else {
            root.toplevel.activate()
          }
        }
        onEntered: if (root.bar) root.bar.showTooltip(root, root.title + " (Super + Q para fechar)")
        onExited: if (root.bar) root.bar.hideTooltip(root)
      }
    }

    WidgetButton {
      id: closeBtn
      visible: root.showControls && root.toplevel !== null
      anchors.verticalCenter: parent.verticalCenter
      bar: root.bar
      text: "✕"
      fontSize: Style.font.small
      horizontalMargin: 4
      verticalPadding: 2
      fixedWidth: Style.space(18)
      fixedHeight: Style.space(18)
      tooltipText: "Fechar janela (Super + Q)"
      onPressed: function() {
        if (root.toplevel) root.toplevel.close()
      }
    }
  }
}
