import QtQuick
import Quickshell
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    layerNamespacePlugin: "steam-flags"

    // ── Plugin settings ──
    property bool showGeneral: pluginData.showGeneral !== false
    property bool showPerformance: pluginData.showPerformance !== false
    property bool showProton: pluginData.showProton !== false
    property bool showAdvanced: pluginData.showAdvanced !== false

    // ── Section definitions ──
    function buildSections() {
        var sections = []
        if (root.showGeneral) sections.push({
            id: "general",
            title: "General Launch Flags",
            icon: "tune",
            color: Theme.primary,
            flags: [
                { name: "Skip Launcher", flag: "%command% --launcher-skip", desc: "Skips EA App, 2K, and other redundant launchers." },
                { name: "Disable Intros", flag: "%command% -novideo", desc: "Skips startup logos and intro cinematics. Also works as -novid." },
                { name: "Borderless Window", flag: "%command% -windowed -noborder", desc: "Borderless window mode. Smooth alt-tabbing on Linux." },
                { name: "Force Fullscreen", flag: "%command% -fullscreen", desc: "Exclusive fullscreen when the game doesn't detect correctly." },
                { name: "Lock Refresh Rate", flag: "%command% -refresh 144", desc: "Forces a specific refresh rate. Change the number (144, 120, 60)." },
                { name: "Disable VR Detection", flag: "%command% -nohmd", desc: "Prevents games from scanning for VR headsets. Fixes crashes." },
                { name: "Disable Joystick", flag: "%command% -nojoy", desc: "Disables joystick input. Fixes keyboard conflicts in some games." }
            ]
        })
        if (root.showPerformance) sections.push({
            id: "performance",
            title: "Performance & Overlay",
            icon: "speed",
            color: "#43a047",
            flags: [
                { name: "MangoHud", flag: "mangohud %command%", desc: "Performance overlay showing FPS, GPU/CPU usage, temps, and RAM." },
                { name: "GameScope", flag: "gamescope -W 1920 -H 1080 -f -e -- %command%", desc: "Micro-compositor. Apply FSR, force resolution, fix HDR." },
                { name: "Feral GameMode", flag: "gamemoderun %command%", desc: "OS-level performance: CPU governor, I/O priority, GPU tweaks." }
            ]
        })
        if (root.showProton) sections.push({
            id: "proton",
            title: "Proton & Compatibility",
            icon: "science",
            color: "#1e88e5",
            flags: [
                { name: "Force OpenGL (WineD3D)", flag: "PROTON_USE_WINED3D=1 %command%", desc: "Proton via OpenGL instead of Vulkan. Fallback for CreateDXGIFactory." },
                { name: "Disable Esync", flag: "PROTON_NO_ESYNC=1 %command%", desc: "Disables eventfd sync. Fixes crashes on older kernels." },
                { name: "Disable Fsync", flag: "PROTON_NO_FSYNC=1 %command%", desc: "Disables futex sync. Alternative fix for startup freezes." },
                { name: "Enable NVAPI", flag: "PROTON_ENABLE_NVAPI=1 %command%", desc: "Enables DLSS, Reflex, and ray tracing in Proton." }
            ]
        })
        if (root.showAdvanced) sections.push({
            id: "advanced",
            title: "Advanced / DXVK",
            icon: "memory",
            color: "#8e24aa",
            flags: [
                { name: "DXVK HUD", flag: "DXVK_HUD=fps,devinfo %command%", desc: "Overlays DXVK stats: FPS, driver, GPU, shader compiler activity." },
                { name: "DXVK Async Shaders", flag: "DXVK_ASYNC=1 %command%", desc: "Async shader compilation. Reduces stuttering on first run." },
                { name: "DXVK Frame Cap", flag: "DXVK_FRAME_RATE=60 %command%", desc: "Caps FPS without vsync input lag. Use any target number." },
                { name: "FSR via Wine", flag: "WINE_FULLSCREEN_FSR=1 %command%", desc: "FidelityFX Super Resolution on any game. Lower in-game res first." }
            ]
        })
        return sections
    }

    // ── Helpers ──
    function copyFlag(flagText) {
        Quickshell.execDetached(["dms", "cl", "copy", flagText])
        ToastService.showInfo("Copied: " + flagText)
    }

    // ── Bar pill (horizontal) ──
    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS

            DankIcon {
                name: "sports_esports"
                color: Theme.primary
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: "Flags"
                color: Theme.primary
                font.pixelSize: Theme.fontSizeMedium
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // ── Bar pill (vertical) ──
    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            DankIcon {
                name: "sports_esports"
                color: Theme.primary
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                text: "Flags"
                color: Theme.primary
                font.pixelSize: Theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // ── Popout ──
    popoutContent: Component {
        PopoutComponent {
            id: popoutColumn
            headerText: "Steam Launch Flags"
            detailsText: "Click any flag to copy it to your clipboard"
            showCloseButton: true

            property var sections: root.buildSections()

            Flickable {
                width: parent.width
                height: root.popoutHeight - popoutColumn.headerHeight - popoutColumn.detailsHeight - Theme.spacingXL
                clip: true
                contentHeight: contentColumn.implicitHeight
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: contentColumn
                    width: parent.width
                    spacing: Theme.spacingL

                    Repeater {
                        model: popoutColumn.sections

                        Column {
                            id: sectionColumn
                            width: parent.width
                            spacing: Theme.spacingM

                            readonly property string sectionColor: modelData.color

                            // ── Section header ──
                            Row {
                                spacing: Theme.spacingS

                                DankIcon {
                                    name: modelData.icon
                                    color: modelData.color
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                StyledText {
                                    text: modelData.title
                                    font.pixelSize: Theme.fontSizeXLarge
                                    font.weight: Font.Bold
                                    color: modelData.color
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            // ── Flag cards ──
                            Repeater {
                                model: modelData.flags

                                StyledRect {
                                    id: card
                                    width: parent.width
                                    height: Math.max(cardContent.implicitHeight + 18, 70)
                                    radius: Theme.cornerRadius
                                    color: card.justCopied
                                        ? Theme.primaryContainer
                                        : (cardMouseArea.containsMouse
                                            ? Theme.surfaceContainerHighest
                                            : Theme.surfaceContainerHigh)
                                    border.width: 0

                                    property bool justCopied: false

                                    Column {
                                        id: cardContent
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.left: parent.left
                                        anchors.leftMargin: 16
                                        anchors.right: parent.right
                                        anchors.rightMargin: 16
                                        spacing: 8

                                        Row {
                                            spacing: Theme.spacingS
                                            width: parent.width

                                            StyledText {
                                                text: card.justCopied ? "✓ Copied!" : modelData.name
                                                font.pixelSize: Theme.fontSizeLarge
                                                font.weight: Font.Bold
                                                color: card.justCopied ? Theme.primary : Theme.surfaceText
                                                elide: Text.ElideRight
                                                width: parent.width - copyIcon.width - parent.spacing
                                            }

                                            DankIcon {
                                                id: copyIcon
                                                name: card.justCopied ? "check_circle" : "content_copy"
                                                color: card.justCopied
                                                    ? Theme.primary
                                                    : (cardMouseArea.containsMouse ? sectionColumn.sectionColor : Theme.outline)
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }

                                        // Flag code box with category-colored border
                                        StyledRect {
                                            width: parent.width
                                            height: flagLabel.implicitHeight + 12
                                            radius: 6
                                            color: Theme.surfaceContainer
                                            border.width: 1
                                            border.color: sectionColumn.sectionColor

                                            StyledText {
                                                id: flagLabel
                                                anchors.verticalCenter: parent.verticalCenter
                                                anchors.left: parent.left
                                                anchors.leftMargin: 12
                                                anchors.right: parent.right
                                                anchors.rightMargin: 12
                                                text: modelData.flag
                                                font.pixelSize: Theme.fontSizeMedium
                                                color: sectionColumn.sectionColor
                                                wrapMode: Text.WrapAnywhere
                                            }
                                        }

                                        StyledText {
                                            width: parent.width
                                            text: modelData.desc
                                            font.pixelSize: Theme.fontSizeMedium
                                            color: Theme.surfaceVariantText
                                            wrapMode: Text.WordWrap
                                        }
                                    }

                                    Timer {
                                        id: copyTimer
                                        interval: 1500
                                        onTriggered: card.justCopied = false
                                    }

                                    MouseArea {
                                        id: cardMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor

                                        onClicked: {
                                            root.copyFlag(modelData.flag)
                                            card.justCopied = true
                                            copyTimer.restart()
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Bottom spacer
                    Item { width: 1; height: Theme.spacingL }
                }
            }
        }
    }

    popoutWidth: 580
    popoutHeight: 780
}
