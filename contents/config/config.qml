/**
 * @file
 * @author Petr Bravenec <petr.bravenec@hobrasoft.cz>
 */
import QtQuick 2.2
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: Qt.resolvedUrl('../icons/stopwatch.svg').replace('file://', '')
        source: 'config/ConfigGeneral.qml'
    }
}
