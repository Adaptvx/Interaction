local addon = select(2, ...)
local artPath = addon.Variables.PATH_ART

addon.API.Presets = {
    UIModifier = .325,
    UITextModifier = 1,

    BOX = artPath .. "BasicShapes\\Box.png",

    TEXTURE_STYLIZED_SCROLL_LIGHT = artPath .. "Elements\\Stylized\\StylizedScroll-Light.png",
    TEXTURE_STYLIZED_SCROLL_DARK = artPath .. "Elements\\Stylized\\StylizedScroll-Dark.png",

    TEXTURE_INSCRIBED = artPath .. "Elements\\Inscribed\\Inscribed.png",
    TEXTURE_INSCRIBED_BORDER = artPath .. "Elements\\Inscribed\\InscribedBorder.png",
    TEXTURE_INSCRIBED_FILLED = artPath .. "Elements\\Inscribed\\InscribedFilled.png",
    TEXTURE_INSCRIBED_FILLED_HIGHLIGHT = artPath .. "Elements\\Inscribed\\InscribedFilledHighlighted.png",

    TEXTURE_RUSTIC_FILLED = artPath .. "Elements\\Rustic\\RusticFilled.png",
    TEXTURE_RUSTIC_BORDER = artPath .. "Elements\\Rustic\\RusticBorder.png",

    TEXTURE_TOOLTIP_LIGHT = artPath .. "Elements\\Tooltip\\Tooltip-Light.png",
    TEXTURE_TOOLTIP_DARK = artPath .. "Elements\\Tooltip\\Tooltip-Dark.png",
    TEXTURE_TOOLTIP_CUSTOM_LIGHT = artPath .. "Elements\\Tooltip\\TooltipCustom-Light.png",
    TEXTURE_TOOLTIP_CUSTOM_DARK = artPath .. "Elements\\Tooltip\\TooltipCustom-Dark.png",

    TEXTURE_VIGNETTE_DARK = artPath .. "Elements\\Vignette\\Vignette-Dark.png",
    TEXTURE_VIGNETTE_LIGHT = artPath .. "Elements\\Vignette\\Vignette-Light.png",
}
