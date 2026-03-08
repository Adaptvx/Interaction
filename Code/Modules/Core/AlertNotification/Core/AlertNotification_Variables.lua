local addon = select(2, ...)
local NS = addon.AlertNotification; addon.AlertNotification = NS

NS.Variables = {}
NS.Variables.RATIO_REFERENCE = 625
function NS.Variables:RATIO(level)
    return NS.Variables.RATIO_REFERENCE / addon.Variables:RAW_RATIO(level)
end

NS.Variables.PATH = addon.Variables.PATH_ART .. "AlertNotification\\"
NS.Variables.FRAME_STRATA = "FULLSCREEN_DIALOG"
NS.Variables.FRAME_LEVEL = 99
NS.Variables.FRAME_LEVEL_MAX = 999
NS.Variables.PADDING = NS.Variables:RATIO(8)
