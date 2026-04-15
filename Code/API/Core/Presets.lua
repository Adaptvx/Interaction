local addon = select(2, ...)
local artPath = addon.Variables.PATH_ART

addon.API.Presets = {
    UIModifier = .325,
    UITextModifier = 1,

    BASIC_SQUARE = artPath .. "Elements\\BasicShapes\\square.png",

    NINESLICE_STYLIZED_SCROLL = artPath .. "Elements\\Stylized\\stylized-scroll-nineslice-light.png",
    NINESLICE_STYLIZED_SCROLL_02 = artPath .. "Elements\\Stylized\\stylized-scroll-nineslice-dark.png",

    NINESLICE_INSCRIBED = artPath .. "Elements\\Inscribed\\inscribed-nineslice.png",
    NINESLICE_INSCRIBED_BORDER = artPath .. "Elements\\Inscribed\\inscribed-border-nineslice.png",
    NINESLICE_INSCRIBED_FILLED = artPath .. "Elements\\Inscribed\\inscribed-filled-nineslice.png",
    NINESLICE_INSCRIBED_FILLED_HIGHLIGHT = artPath .. "Elements\\Inscribed\\inscribed-filled-highlighted-nineslice.png",

    NINESLICE_RUSTIC_FILLED = artPath .. "Elements\\Rustic\\rustic-filled-nineslice.png",
    NINESLICE_RUSTIC_BORDER = artPath .. "Elements\\Rustic\\rustic-border-nineslice.png",

    NINESLICE_TOOLTIP = artPath .. "Elements\\Tooltip\\tooltip-nineslice-light.png",
    NINESLICE_TOOLTIP_02 = artPath .. "Elements\\Tooltip\\tooltip-nineslice-dark.png",
    NINESLICE_TOOLTIP_CUSTOM = artPath .. "Elements\\Tooltip\\tooltip-custom-nineslice-light.png",
    NINESLICE_TOOLTIP_CUSTOM_02 = artPath .. "Elements\\Tooltip\\tooltip-custom-nineslice-dark.png",

    NINESLICE_VIGNETTE_DARK = artPath .. "Elements\\Vignette\\vignette-nineslice-dark.png",
    NINESLICE_VIGNETTE_LIGHT = artPath .. "Elements\\Vignette\\vignette-nineslice-light.png",
}
