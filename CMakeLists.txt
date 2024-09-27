cmake_minimum_required(VERSION 3.16)

project(Gestionnaire_dressing VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appGestionnaire_dressing
    main.cpp
)

qt_add_qml_module(appGestionnaire_dressing
    URI Gestionnaire_dressing
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES
RESOURCES Data/Photos/Pas-dimage-disponible.jpg Theme/QUANTUM/Fonts/Roboto/LICENSE.txt Theme/QUANTUM/Fonts/Roboto/Roboto-Black.ttf Theme/QUANTUM/Fonts/Roboto/Roboto-BlackItalic.ttf Theme/QUANTUM/Fonts/Roboto/Roboto-Bold.ttf Theme/QUANTUM/Fonts/Roboto/Roboto-BoldItalic.ttf Theme/QUANTUM/Fonts/Roboto/Roboto-Italic.ttf Theme/QUANTUM/Fonts/Roboto/Roboto-Light.ttf Theme/QUANTUM/Fonts/Roboto/Roboto-LightItalic.ttf Theme/QUANTUM/Fonts/Roboto/Roboto-Medium.ttf Theme/QUANTUM/Fonts/Roboto/Roboto-MediumItalic.ttf Theme/QUANTUM/Fonts/Roboto/Roboto-Regular.ttf Theme/QUANTUM/Fonts/Roboto/Roboto-Thin.ttf Theme/QUANTUM/Fonts/Roboto/Roboto-ThinItalic.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-Bold.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-BoldItalic.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-ExtraLight.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-ExtraLightItalic.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-Italic.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-Light.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-LightItalic.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-Medium.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-MediumItalic.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-Regular.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-SemiBold.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-SemiBoldItalic.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-Thin.ttf Theme/QUANTUM/Fonts/Roboto-Mono/static/RobotoMono-ThinItalic.ttf Theme/QUANTUM/Fonts/Roboto-Mono/LICENSE.txt Theme/QUANTUM/Fonts/Roboto-Mono/README.txt Theme/QUANTUM/Fonts/Roboto-Mono/RobotoMono-Italic-VariableFont_wght.ttf Theme/QUANTUM/Fonts/Roboto-Mono/RobotoMono-VariableFont_wght.ttf Theme/QUANTUM/Images/Material_Icons.woff2 Theme/QUANTUM/Images/Material_Icons_Outlined.woff2 Theme/QUANTUM/Images/Material_Icons_Round.woff2 Theme/QUANTUM/Images/Material_Icons_Sharp.woff2 Theme/QUANTUM/Images/Material_Icons_Two_Tone.woff2 Theme/QUANTUM/qmldir
QML_FILES Data/filter.json Theme/QUANTUM/Controls/AppliQuantum.qml Theme/QUANTUM/Controls/Button.qml Theme/QUANTUM/Controls/Header.qml Theme/QUANTUM/Controls/Switch.qml Theme/QUANTUM/Controls/Tag.qml Theme/QUANTUM/Colors.qml Theme/QUANTUM/Fonts.qml Database.js DemoDetail.qml DemoTile.qml Filters.qml JSONLoader.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appGestionnaire_dressing PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appGestionnaire_dressing
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appGestionnaire_dressing
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appGestionnaire_dressing
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
