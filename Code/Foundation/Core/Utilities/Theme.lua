local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.Theme = {}
local NS = addon.Theme

do -- MAIN
	NS.IsDarkTheme = nil
	NS.IsDarkTheme_Dialog = nil
	NS.IsStylisedTheme_Dialog = nil
end

do -- CONSTANTS
	NS.RGB_RECOMMENDED = {}
	NS.RGB_WHITE = { r = 1, g = 1, b = 1 }
	NS.RGB_BLACK = { r = .1, g = .1, b = .1 }
end

do -- QUEST
	NS.Quest = {}

	--------------------------------

	C_Timer.After(0, function()
		do -- COLOR
			do -- PRIMARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("726053")

					--------------------------------

					NS.Quest.Primary_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("5A5A5A")

					--------------------------------

					NS.Quest.Primary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .75 }
				end
			end

			do -- SECONDARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("45382F")

					--------------------------------

					NS.Quest.Secondary_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("414141")

					--------------------------------

					NS.Quest.Secondary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .75 }
				end
			end

			do -- TERTIARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("362D26")

					--------------------------------

					NS.Quest.Tertiary_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("262626")

					--------------------------------

					NS.Quest.Tertiary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .75 }
				end
			end

			do -- HIGHLIGHT PRIMARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("7F7F7F")

					--------------------------------

					NS.Quest.Highlight_Primary_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("7F7F7F")

					--------------------------------

					NS.Quest.Highlight_Primary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end
			end

			do -- HIGHLIGHT SECONDARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("585858")

					--------------------------------

					NS.Quest.Highlight_Secondary_LightTheme = { r = color.r, g = color.g, b = color.b, a = .75 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("585858")

					--------------------------------

					NS.Quest.Highlight_Secondary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .75 }
				end
			end

			do -- HIGHLIGHT TERTIARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("3F3F3F")

					--------------------------------

					NS.Quest.Highlight_Tertiary_LightTheme = { r = color.r, g = color.g, b = color.b, a = .5 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("3F3F3F")

					--------------------------------

					NS.Quest.Highlight_Tertiary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .5 }
				end
			end

			do -- INVALID PRIMARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("FF0000")

					--------------------------------

					NS.Quest.Invalid_Primary_LightTheme = { r = color.r, g = color.g, b = color.b, a = .5 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("FF0000")

					--------------------------------

					NS.Quest.Invalid_Primary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .5 }
				end
			end

			do -- INVALID SECONDARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("FF6969")

					--------------------------------

					NS.Quest.Invalid_Secondary_LightTheme = { r = color.r, g = color.g, b = color.b, a = .25 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("FF4545")

					--------------------------------

					NS.Quest.Invalid_Secondary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .25 }
				end
			end

			do -- INVALID TERTIARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("FFA2A2")

					--------------------------------

					NS.Quest.Invalid_Tertiary_LightTheme = { r = color.r, g = color.g, b = color.b, a = .25 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("FF6464")

					--------------------------------

					NS.Quest.Invalid_Tertiary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .25 }
				end
			end

			do -- INVALID TINT
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("FFA2A2")

					--------------------------------

					NS.Quest.Invalid_Tint_LightTheme = { r = color.r, g = color.g, b = color.b, a = .25 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("FF6363")

					--------------------------------

					NS.Quest.Invalid_Tint_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end
			end
		end
	end)
end

do -- SETTINGS
	NS.Settings = {}

	--------------------------------

	C_Timer.After(0, function()
		do -- ELEMENT
			do -- DEFAULT
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("674932")

					--------------------------------

					NS.Settings.Element_Default_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("FFFFFF")

					--------------------------------

					NS.Settings.Element_Default_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end
			end

			do -- HIGHLIGHT
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("A07754")

					--------------------------------

					NS.Settings.Element_Highlight_LightTheme = { r = color.r, g = color.g, b = color.b, a = .5 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("FFFFFF")

					--------------------------------

					NS.Settings.Element_Highlight_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .25 }
				end
			end

			do -- ACTIVE
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("402014")

					--------------------------------

					NS.Settings.Element_Active_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("FFFFFF")

					--------------------------------

					NS.Settings.Element_Active_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end
			end
		end

		do -- TEXT
			do -- DEFAULT
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("101010")

					--------------------------------

					NS.Settings.Text_Default_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("FFFFFF")

					--------------------------------

					NS.Settings.Text_Default_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end
			end

			do -- HIGHLIGHT
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("A07B54")

					--------------------------------

					NS.Settings.Text_Highlight_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("FFFFFF")

					--------------------------------

					NS.Settings.Text_Highlight_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end
			end
		end

		do -- COLOR
			do -- PRIMARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("A07B54")

					--------------------------------

					NS.Settings.Primary_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("505050")

					--------------------------------

					NS.Settings.Primary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end
			end

			do -- SECONDARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("402014")

					--------------------------------

					NS.Settings.Secondary_LightTheme = { r = color.r, g = color.g, b = color.b, a = .175 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("373737")

					--------------------------------

					NS.Settings.Secondary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .5 }
				end
			end

			do -- TERTIARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("916843")

					--------------------------------

					NS.Settings.Tertiary_LightTheme = { r = color.r, g = color.g, b = color.b, a = .175 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("FFFFFF")

					--------------------------------

					NS.Settings.Tertiary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .075 }
				end
			end
		end
	end)
end

--------------------------------
-- FUNCTIONS (MAIN)
--------------------------------

function NS:Load()
	--------------------------------
	-- FUNCTIONS (MAIN)
	--------------------------------

	do
		function NS:UpdateThemeReferences()
			local Theme = INTDB.profile.INT_MAIN_THEME
			local Theme_Dialog = INTDB.profile.INT_DIALOG_THEME

			--------------------------------

			NS.IsDarkTheme = (Theme == 2)
			NS.IsDarkTheme_Dialog = (Theme_Dialog == 1 and Theme == 2) or (Theme_Dialog == 3)
			NS.IsStylisedTheme_Dialog = (Theme_Dialog == 4)
		end

		function NS:UpdateTextColorReferences()
			if NS.IsDarkTheme then
				NS.RGB_RECOMMENDED = { r = .99, g = .99, b = .99 }
			else
				NS.RGB_RECOMMENDED = { r = .2, g = .2, b = .2 }
			end
		end
	end

	--------------------------------
	-- EVENTS
	--------------------------------

	do
		NS:UpdateThemeReferences()
		NS:UpdateTextColorReferences()

		--------------------------------

		CallbackRegistry:Add("THEME_UPDATE", function()
			NS:UpdateThemeReferences()
			NS:UpdateTextColorReferences()
		end, -2)

		--------------------------------

		-- local _ = CreateFrame("Frame", "UpdateFrame/Theme.lua", nil)
		-- _:SetScript("OnUpdate", function()
		-- 	NS:UpdateThemeReferences()
		-- end)
	end
end
