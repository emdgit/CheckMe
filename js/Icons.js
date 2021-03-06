var boolType = 0, intType = 1, timeType = 2;

/// Вернуть иконку, соответствующую типу данных.
function dataTypeIcon(dataType) {
    switch (dataType) {
    case intType:
        return numbersSvg();
    case boolType:
        return tickSvg();
    case timeType:
        return clockSvg();
    default:
        console.log("Icons.js::dataTypeIcon() invalid dataType: ",
                    dataType);
        return "";
    }
}

/// Иконка с меню в виде трех горизонтальных линий.
function linedMenuSvg() {
    return "qrc:/icons/icons/lined_menu.svg";
}

/// Кот Саймона показывает на миску.
function saimonCatPng() {
    return "qrc:/icons/icons/cat_1.png";
}

/// Иконка с галочкой.
function tickSvg() {
    return "qrc:/icons/icons/tick.svg";
}

/// Иконка с циферблатом.
function clockSvg() {
    return "qrc:/icons/icons/time.svg";
}

/// Иконка с цифрами.
function numbersSvg() {
    return "qrc:/icons/icons/number.svg";
}

/// Иконка с карандашом.
function editSvg() {
    return "qrc:/icons/icons/edit.svg";
}

/// Иконка с корзиной.
function trashSvg() {
    return "qrc:/icons/icons/trash.svg";
}

/// Иконка с вопросом.
function questionSvg() {
    return "qrc:/icons/icons/question.svg";
}

/// Иконка кнопки выхода.
function exitSvg() {
    return "qrc:/icons/icons/exit.svg";
}

/// Иконка стрелки влево.
function leftArrowSvg() {
    return "qrc:/icons/icons/left_arrow.svg";
}

/// Иконка стрелки вправо.
function rightArrowSvg() {
    return "qrc:/icons/icons/right_arrow.svg";
}

/// Иконка с двумя галочками как в WhatsApp.
function doubleTickSvg() {
    return "qrc:/icons/icons/double_tick.svg";
}
