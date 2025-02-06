local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------
-- VARIABLES
--------------------------------

addon.Theme = {}
local NS = addon.Theme

do -- MAIN
	NS.Theme = nil
	NS.IsDarkTheme = nil
	NS.IsDarkTheme_Dialog = nil
	NS.IsRusticTheme_Dialog = nil
end

do -- CONSTANTS
	NS.RGB_RECOMMENDED = {}

	NS.RGB_WHITE = { r = 1, g = 1, b = 1 }
	NS.RGB_BLACK = { r = .1, g = .1, b = .1 }

	NS.RGB_CHAT_MSG_SAY = { r = 1, g = .87, b = .67 }
	NS.RGB_CHAT_MSG_EMOTE = { r = .93, g = .52, b = .31 }
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

					NS.Quest.Highlight_Secondary_LightTheme = { r = color.r, g = color.g, b = color.b, a = .25 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("585858")

					--------------------------------

					NS.Quest.Highlight_Secondary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .25 }
				end
			end

			do -- HIGHLIGHT TERTIARY
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("3F3F3F")

					--------------------------------

					NS.Quest.Highlight_Tertiary_LightTheme = { r = color.r, g = color.g, b = color.b, a = .25 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("3F3F3F")

					--------------------------------

					NS.Quest.Highlight_Tertiary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = .25 }
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

			do -- GRADIENT
				do -- QUALITY
					do -- POOR
						local colorStart = AdaptiveAPI:GetRGBFromHexColor("9D9D9D")
						local colorEnd = AdaptiveAPI:GetRGBFromHexColor("8C8C8C")

						--------------------------------

						NS.Quest.Gradient_Quality_Poor_Start = { r = colorStart.r, g = colorStart.g, b = colorStart.b, a = 1 }
						NS.Quest.Gradient_Quality_Poor_End = { r = colorEnd.r, g = colorEnd.g, b = colorEnd.b, a = 1 }
					end

					do -- COMMON
						local colorStart = AdaptiveAPI:GetRGBFromHexColor("B8B8B8")
						local colorEnd = AdaptiveAPI:GetRGBFromHexColor("A0A0A0")

						--------------------------------

						NS.Quest.Gradient_Quality_Common_Start = { r = colorStart.r, g = colorStart.g, b = colorStart.b, a = 1 }
						NS.Quest.Gradient_Quality_Common_End = { r = colorEnd.r, g = colorEnd.g, b = colorEnd.b, a = 1 }
					end

					do -- UNCOMMON
						local colorStart = AdaptiveAPI:GetRGBFromHexColor("1EFF00")
						local colorEnd = AdaptiveAPI:GetRGBFromHexColor("669C5F")

						--------------------------------

						NS.Quest.Gradient_Quality_Uncommon_Start = { r = colorStart.r, g = colorStart.g, b = colorStart.b, a = 1 }
						NS.Quest.Gradient_Quality_Uncommon_End = { r = colorEnd.r, g = colorEnd.g, b = colorEnd.b, a = 1 }
					end

					do -- RARE
						local colorStart = AdaptiveAPI:GetRGBFromHexColor("0070DD")
						local colorEnd = AdaptiveAPI:GetRGBFromHexColor("005FBC")

						--------------------------------

						NS.Quest.Gradient_Quality_Rare_Start = { r = colorStart.r, g = colorStart.g, b = colorStart.b, a = 1 }
						NS.Quest.Gradient_Quality_Rare_End = { r = colorEnd.r, g = colorEnd.g, b = colorEnd.b, a = 1 }
					end

					do -- EPIC
						local colorStart = AdaptiveAPI:GetRGBFromHexColor("A335EE")
						local colorEnd = AdaptiveAPI:GetRGBFromHexColor("900EE9")

						--------------------------------

						NS.Quest.Gradient_Quality_Epic_Start = { r = colorStart.r, g = colorStart.g, b = colorStart.b, a = 1 }
						NS.Quest.Gradient_Quality_Epic_End = { r = colorEnd.r, g = colorEnd.g, b = colorEnd.b, a = 1 }
					end

					do -- LEGENDARY
						local colorStart = AdaptiveAPI:GetRGBFromHexColor("FF8000")
						local colorEnd = AdaptiveAPI:GetRGBFromHexColor("FF962C")

						--------------------------------

						NS.Quest.Gradient_Quality_Legendary_Start = { r = colorStart.r, g = colorStart.g, b = colorStart.b, a = 1 }
						NS.Quest.Gradient_Quality_Legendary_End = { r = colorEnd.r, g = colorEnd.g, b = colorEnd.b, a = 1 }
					end

					do -- ARTIFACT
						local colorStart = AdaptiveAPI:GetRGBFromHexColor("E6CC80")
						local colorEnd = AdaptiveAPI:GetRGBFromHexColor("C7B16E")

						--------------------------------

						NS.Quest.Gradient_Quality_Artifact_Start = { r = colorStart.r, g = colorStart.g, b = colorStart.b, a = 1 }
						NS.Quest.Gradient_Quality_Artifact_End = { r = colorEnd.r, g = colorEnd.g, b = colorEnd.b, a = 1 }
					end

					do -- HEIRLOOM
						local colorStart = AdaptiveAPI:GetRGBFromHexColor("00CCFF")
						local colorEnd = AdaptiveAPI:GetRGBFromHexColor("3FAAC5")

						--------------------------------

						NS.Quest.Gradient_Quality_Heirloom_Start = { r = colorStart.r, g = colorStart.g, b = colorStart.b, a = 1 }
						NS.Quest.Gradient_Quality_Heirloom_End = { r = colorEnd.r, g = colorEnd.g, b = colorEnd.b, a = 1 }
					end

					do -- WOW TOKEN
						local colorStart = AdaptiveAPI:GetRGBFromHexColor("00CCFF")
						local colorEnd = AdaptiveAPI:GetRGBFromHexColor("3FAAC5")

						--------------------------------

						NS.Quest.Gradient_Quality_WoWToken_Start = { r = colorStart.r, g = colorStart.g, b = colorStart.b, a = 1 }
						NS.Quest.Gradient_Quality_WoWToken_End = { r = colorEnd.r, g = colorEnd.g, b = colorEnd.b, a = 1 }
					end
				end
			end

			do -- TEXT
				do -- QUALITY
					do -- POOR
						local color = AdaptiveAPI:GetRGBFromHexColor("B5B5B5")

						--------------------------------

						NS.Quest.Text_Quality_Poor = { r = color.r, g = color.g, b = color.b, a = 1 }
					end

					do -- COMMON
						local color = AdaptiveAPI:GetRGBFromHexColor("FFFFFF")

						--------------------------------

						NS.Quest.Text_Quality_Common = { r = color.r, g = color.g, b = color.b, a = 1 }
					end

					do -- UNCOMMON
						local color = AdaptiveAPI:GetRGBFromHexColor("16BE00")

						--------------------------------

						NS.Quest.Text_Quality_Uncommon = { r = color.r, g = color.g, b = color.b, a = 1 }
					end

					do -- RARE
						local color = AdaptiveAPI:GetRGBFromHexColor("3099FF")

						--------------------------------

						NS.Quest.Text_Quality_Rare = { r = color.r, g = color.g, b = color.b, a = 1 }
					end

					do -- EPIC
						local color = AdaptiveAPI:GetRGBFromHexColor("C671FF")

						--------------------------------

						NS.Quest.Text_Quality_Epic = { r = color.r, g = color.g, b = color.b, a = 1 }
					end

					do -- LEGENDARY
						local color = AdaptiveAPI:GetRGBFromHexColor("FFB060")

						--------------------------------

						NS.Quest.Text_Quality_Legendary = { r = color.r, g = color.g, b = color.b, a = 1 }
					end

					do -- ARTIFACT
						local color = AdaptiveAPI:GetRGBFromHexColor("FFDE7E")

						--------------------------------

						NS.Quest.Text_Quality_Artifact = { r = color.r, g = color.g, b = color.b, a = 1 }
					end

					do -- HEIRLOOM
						local color = AdaptiveAPI:GetRGBFromHexColor("80D2E6")

						--------------------------------

						NS.Quest.Text_Quality_Heirloom = { r = color.r, g = color.g, b = color.b, a = 1 }
					end

					do -- WOW TOKEN
						local color = AdaptiveAPI:GetRGBFromHexColor("80D2E6")

						--------------------------------

						NS.Quest.Text_Quality_WoWToken = { r = color.r, g = color.g, b = color.b, a = 1 }
					end
				end
			end
		end
	end)
end

do -- SETTINGS
	NS.Settings = {}

	--------------------------------

	do -- TOOLTIP TEXT
		do -- NOTE
			NS.Settings.Tooltip_Text_Note = "|cff55565C"
			NS.Settings.Tooltip_Text_Note_Highlight = "|cff4F5A87"
		end

		do -- WARNING
			NS.Settings.Tooltip_Text_Warning = "|cff7F411E"
			NS.Settings.Tooltip_Text_Warning_Highlight = "|cffBF6038"
		end
	end

	--------------------------------

	C_Timer.After(0, function()
		do -- HEADER
			do -- BACKGROUND
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("402014")

					--------------------------------

					NS.Settings.Header_Background_LightTheme = { r = color.r, g = color.g, b = color.b, a = .175 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("272523")

					--------------------------------

					NS.Settings.Header_Background_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end
			end

			do -- DIVIDER
				do -- LIGHT
					local color = AdaptiveAPI:GetRGBFromHexColor("674932")

					--------------------------------

					NS.Settings.Header_Divider_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end

				do -- DARK
					local color = AdaptiveAPI:GetRGBFromHexColor("FFFFFF")

					--------------------------------

					NS.Settings.Header_Divider_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
				end
			end

			do -- CLOSE BUTTON
				do -- DEFAULT
					do -- LIGHT
						local color = AdaptiveAPI:GetRGBFromHexColor("674932")

						--------------------------------

						NS.Settings.Header_CloseButton_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
					end

					do -- DARK
						local color = AdaptiveAPI:GetRGBFromHexColor("505050")

						--------------------------------

						NS.Settings.Header_CloseButton_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
					end
				end

				do -- HIGHLIGHT
					do -- LIGHT
						local color = AdaptiveAPI:GetRGBFromHexColor("90694B")

						--------------------------------

						NS.Settings.Header_CloseButton_Highlight_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
					end

					do -- DARK
						local color = AdaptiveAPI:GetRGBFromHexColor("353535")

						--------------------------------

						NS.Settings.Header_CloseButton_Highlight_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
					end
				end
			end

			do -- CLOSE BUTTON (IMAGE)
				do -- DEFAULT
					do -- LIGHT
						local color = AdaptiveAPI:GetRGBFromHexColor("B18861")

						--------------------------------

						NS.Settings.Header_CloseButton_Image_LightTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
					end

					do -- DARK
						local color = AdaptiveAPI:GetRGBFromHexColor("AAAAAA")

						--------------------------------

						NS.Settings.Header_CloseButton_Image_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
					end
				end
			end
		end

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
					local color = AdaptiveAPI:GetRGBFromHexColor("272523")

					--------------------------------

					NS.Settings.Secondary_DarkTheme = { r = color.r, g = color.g, b = color.b, a = 1 }
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
		function NS:UpdateAll()
			NS:UpdateThemeReferences()
			NS:UpdateTextColorReferences()
		end

		function NS:UpdateSchedule()
			do -- DYNAMIC MAIN THEME
				if NS.IsDynamicTheme then
					local _, isNewTheme = NS:GetDynamicMainTheme()

					--------------------------------

					if isNewTheme then
						CallbackRegistry:Trigger("THEME_UPDATE")
					end
				end
			end
		end

		function NS:GetDynamicMainTheme()
			local result
			local isNewTheme = false

			local time = C_DateAndTime.GetCurrentCalendarTime()
			local hour = time.hour

			-- Sunrise is at 5:30 AM and sunset at 9:00 PM.
			local dayTime = addon.Database.DB_GLOBAL.profile.INT_TIME_DAY
			local nightTime = addon.Database.DB_GLOBAL.profile.INT_TIME_NIGHT

			--------------------------------

			local currentTheme = NS.Theme
			local isDay = (hour >= dayTime and hour < nightTime)
			local isNight = (hour >= nightTime or hour < dayTime)

			if isDay then
				result = 1
			elseif isNight then
				result = 2
			end

			if currentTheme ~= result then
				isNewTheme = true
			end

			--------------------------------

			return result, isNewTheme
		end

		function NS:UpdateThemeReferences()
			-- 1 -> DAY
			-- 2 -> NIGHT
			-- 3 -> DYNAMIC

			local rawTheme = addon.Database.DB_GLOBAL.profile.INT_MAIN_THEME
			local theme = rawTheme == 3 and select(1, NS:GetDynamicMainTheme()) or rawTheme
			local theme_dialog = addon.Database.DB_GLOBAL.profile.INT_DIALOG_THEME

			--------------------------------

			NS.Theme = theme
			NS.IsDarkTheme = (theme == 2)
			NS.IsDynamicTheme = (rawTheme == 3)
			NS.IsDarkTheme_Dialog = (theme_dialog == 1 and theme == 2) or (theme_dialog == 3)
			NS.IsRusticTheme_Dialog = (theme_dialog == 4)
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
		NS:UpdateAll()

		--------------------------------

		CallbackRegistry:Add("THEME_UPDATE", function()
			NS:UpdateAll()
		end, -2)

		--------------------------------

		addon.Libraries.AceTimer:ScheduleRepeatingTimer(NS.UpdateSchedule, 5)
	end
end
