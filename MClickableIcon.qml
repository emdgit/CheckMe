import QtQuick 2.0
import QtQuick.Controls 2.4

/// Кнопка с цветной .svg картинкой.
/// Может показывать ToolTip при нажатии на неё. Для этого
/// нужно задать значение для свойства 'toolTipText'.
Item {

    id: mClickableIcon

    /// Icon's width and height.
    property alias side: mIcon.side

    /// Icon's source image. Supposed to be an '.svg'.
    property alias source: mIcon.source

    /// Sets color for svg icon. (string).
    property alias color: mIcon.color

    /// Text for ToolTip. (string).
    property alias toolTipText: mToolTip.text

    /// Delay for ToolTip. After this time it'll be shown. (int[ms]).
    property alias toolTipDelay: mToolTip.delay

    /// Timeout for ToolTip after which the tool tip is hidden. (int[ms]).
    property alias toolTipTimeout: mToolTip.timeout

    readonly property int defaultDelay: 100
    readonly property int defaultTimeout: 5000

    signal clicked()

    width: mIcon.side
    height: mIcon.side

    MIcon { id: mIcon }

    ToolTip {
        id: mToolTip
        delay: defaultDelay
        timeout: defaultTimeout
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            mClickableIcon.clicked();

            if (toolTipText !== "") {
                mToolTip.show(toolTipText);
            }
        }
    }
}
