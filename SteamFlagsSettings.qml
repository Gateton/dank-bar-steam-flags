import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "steamFlagsPlugin"

    StyledText {
        width: parent.width
        text: "Steam Launch Flags"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: "Toggle which categories show in the popout. Click the widget to open the reference."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    ToggleSetting {
        settingKey: "showGeneral"
        label: "General Launch Flags"
        description: "Skip launchers, disable intros, force windowed/fullscreen, refresh rate, VR/joystick"
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "showPerformance"
        label: "Performance & Overlay Tools"
        description: "MangoHud, GameScope, Feral GameMode"
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "showProton"
        label: "Proton & Compatibility"
        description: "WineD3D, Esync/Fsync, NVAPI for DLSS and Reflex"
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "showAdvanced"
        label: "Advanced / DXVK"
        description: "DXVK HUD, async shaders, frame cap, FSR via Wine"
        defaultValue: true
    }

    StyledText {
        width: parent.width
        text: "💡 Click any flag card to copy the launch option to clipboard."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }
}
