---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.API; addon.API = NS

--------------------------------
-- VARIABLES
--------------------------------

NS.Fonts = {}

do -- MAIN

end

do -- CONSTANTS
	NS.Fonts.LOCALE = GetLocale()
	NS.Fonts.PATH = addon.Variables.PATH_ART .. "Fonts/"
end

--------------------------------
-- FUNCTIONS (MAIN)
--------------------------------

function NS.Fonts:Load()
	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function NS.Fonts:GetFonts()
			if NS.Fonts.LOCALE == "enUS" then
				NS.Fonts.TITLE_LIGHT = NS.Fonts.PATH .. "Cinzel-Regular.ttf"
				NS.Fonts.TITLE_MEDIUM = NS.Fonts.PATH .. "Cinzel-Medium.ttf"
				NS.Fonts.TITLE_BOLD = NS.Fonts.PATH .. "Cinzel-Bold.ttf"
				NS.Fonts.TITLE_EXTRABOLD = NS.Fonts.PATH .. "Cinzel-ExtraBold.ttf"

				NS.Fonts.CONTENT_DEFAULT = GameFontNormal:GetFont()
				NS.Fonts.CONTENT_LIGHT = GameFontNormal:GetFont()
				NS.Fonts.CONTENT_BOLD = NS.Fonts.PATH .. "Cardo-Bold.ttf"
				NS.Fonts.CONTENT_ITALIC = NS.Fonts.PATH .. "Cardo-Italic.ttf"
			else
				NS.Fonts.TITLE_LIGHT = GameFontNormal:GetFont()
				NS.Fonts.TITLE_MEDIUM = GameFontNormal:GetFont()
				NS.Fonts.TITLE_BOLD = GameFontNormal:GetFont()
				NS.Fonts.TITLE_EXTRABOLD = GameFontNormal:GetFont()

				NS.Fonts.CONTENT_DEFAULT = GameFontNormal:GetFont()
				NS.Fonts.CONTENT_LIGHT = GameFontNormal:GetFont()
				NS.Fonts.CONTENT_BOLD = GameFontNormal:GetFont()
				NS.Fonts.CONTENT_ITALIC = GameFontNormal:GetFont()
			end
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		C_Timer.After(.1, NS.Fonts.GetFonts)
	end
end

NS.Fonts:Load()
