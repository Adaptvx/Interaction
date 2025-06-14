---@class addon
local addon = select(2, ...)

--------------------------------
-- VARIABLES
--------------------------------

addon.Libraries = {}

--------------------------------
-- LIBRARIES
--------------------------------

do
    addon.Libraries.AceTimer = LibStub("AceTimer-3.0")
	addon.Libraries.AdaptiveTimer = LibStub("AdaptiveTimer-1.0")
	addon.Libraries.LibSerialize = LibStub("LibSerialize")
	addon.Libraries.LibDeflate = LibStub("LibDeflate")
end

--------------------------------
-- FUNCTIONS (MAIN)
--------------------------------

do

end
