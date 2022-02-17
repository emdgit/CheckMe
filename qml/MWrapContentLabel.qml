import QtQuick 2.0
import QtQuick.Controls 2.0

/// Label to be a contentItem with a WordWrap
/// Tested on RadioButton & CheckBox
Label {
    text: parent.text
    font: parent.font
    horizontalAlignment: Label.AlignLeft
    verticalAlignment: Label.AlignVCenter
    wrapMode: Label.Wrap
    leftPadding: parent.indicator.width +
                 parent.spacing
}
