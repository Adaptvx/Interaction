local addonName, addon = ...
local PrefabRegistry = addon.PrefabRegistry
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.API

--------------------------------
-- VARIABLES
--------------------------------

NS.Fonts = {}

do -- MAIN

end

do -- CONSTANTS
	NS.Fonts.LOCALE = GetLocale()
	NS.Fonts.PATH = addon.Variables.PATH .. "Art/Fonts/"
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
				NS.Fonts.Title_Light = NS.Fonts.PATH .. "Cinzel-Regular.ttf"
				NS.Fonts.Title_Medium = NS.Fonts.PATH .. "Cinzel-Medium.ttf"
				NS.Fonts.Title_Bold = NS.Fonts.PATH .. "Cinzel-Bold.ttf"
				NS.Fonts.Title_ExtraBold = NS.Fonts.PATH .. "Cinzel-ExtraBold.ttf"

				NS.Fonts.Content_Light = NS.Fonts.PATH .. "Frizqt__.ttf"
				NS.Fonts.Content_Bold = NS.Fonts.PATH .. "Cardo-Bold.ttf"
				NS.Fonts.Content_Italic = NS.Fonts.PATH .. "Cardo-Italic.ttf"
			else
				NS.Fonts.Title_Light = GameFontNormal:GetFont()
				NS.Fonts.Title_Medium = GameFontNormal:GetFont()
				NS.Fonts.Title_Bold = GameFontNormal:GetFont()
				NS.Fonts.Title_ExtraBold = GameFontNormal:GetFont()

				NS.Fonts.Content_Light = GameFontNormal:GetFont()
				NS.Fonts.Content_Bold = GameFontNormal:GetFont()
				NS.Fonts.Content_Italic = GameFontNormal:GetFont()
			end
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do
		NS.Fonts:GetFonts()
	end
end

NS.Fonts:Load()
