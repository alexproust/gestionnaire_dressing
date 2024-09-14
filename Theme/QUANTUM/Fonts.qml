pragma Singleton
import QtQuick 2.15

Item {

    FontLoader { id: robotoBold; source: "Fonts/Roboto/Roboto-Bold.ttf" }
    FontLoader { id: robotoMedium; source: "Fonts/Roboto/Roboto-Medium.ttf" }
    FontLoader { id: robotoRegular; source: "Fonts/Roboto/Roboto-Regular.ttf" }
    FontLoader { id: robotoMonoRegular; source: "Fonts/Roboto-Mono/static/RobotoMono-Regular.ttf" }

    property font title1: Qt.font({
                                      family: robotoBold.name,
                                      pixelSize: 48,
                                      weight: Font.Bold
                                  })

    property font title2: Qt.font({
                                      family: robotoBold.name,
                                      pixelSize: 40,
                                      weight: Font.Bold
                                  })
    property font title3: Qt.font({
                                      family: robotoBold.name,
                                      pixelSize: 32,
                                      weight: Font.Bold
                                  })
    property font subtitle1: Qt.font({
                                         family: robotoMedium.name,
                                         pixelSize: 24,
                                         weight: Font.Medium
                                     })
    property font subtitle2: Qt.font({
                                         family: robotoMedium.name,
                                         pixelSize: 20,
                                         weight: Font.Medium
                                     })
    property font body1: Qt.font({
                                     family: robotoRegular.name,
                                     pixelSize: 16,
                                     weight: Font.Normal
                                 })
    property font body2: Qt.font({
                                     family: robotoRegular.name,
                                     pixelSize: 14,
                                     weight: Font.Normal
                                 })
    property font caption1: Qt.font({
                                        family: robotoRegular.name,
                                        pixelSize: 12,
                                        weight: Font.Normal
                                    })
    property font caption2: Qt.font({
                                        family: robotoRegular.name,
                                        pixelSize: 10,
                                        weight: Font.Normal
                                    })
    property font overline: Qt.font({
                                        family: robotoRegular.name,
                                        pixelSize: 16,
                                        weight: Font.Normal
                                    })
    property font code1: Qt.font({
                                     family: robotoMonoRegular.name,
                                     pixelSize: 16,
                                     weight: Font.Normal
                                 })
    property font code2: Qt.font({
                                     family: robotoMonoRegular.name,
                                     pixelSize: 14,
                                     weight: Font.Normal
                                 })
}
