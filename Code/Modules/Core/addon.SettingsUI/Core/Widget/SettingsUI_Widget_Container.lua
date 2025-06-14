---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

--------------------------------

-- Creates a container. Child Frames: Icon (if applicable), Container
function NS.Widgets:CreateContainer(parent, subcategory, background, height, tooltipText, tooltipTextDynamic, tooltipImage, tooltipImageSize, hidden, locked, opacity)
	local INDENTATION = height or NS.Variables:RATIO(5)
	local PADDING = math.ceil(NS.Variables:RATIO(7))

	local offsetX = 0
	local offsetX_Indentation = 0

	--------------------------------

	local Frame = CreateFrame("Frame")
	Frame:SetParent(parent)
	Frame:SetSize(parent:GetWidth(), height or NS.Variables:RATIO(5))
	Frame:SetPoint("TOP", parent)
	Frame:SetAlpha(opacity or 1)

	--------------------------------

	Frame.TEXTURE_Subcategory = nil
	Frame.TEXTURE_Background = nil
	Frame.COLOR_Background = nil

	--------------------------------

	do -- THEME
		local function UpdateTheme()
			if addon.Theme.IsDarkTheme then
				Frame.TEXTURE_Subcategory = addon.Variables.PATH_ART .. "Settings/subcategory-dark.png"
				Frame.TEXTURE_Background = addon.API.Presets.NINESLICE_INSCRIBED
				Frame.COLOR_Background = addon.Theme.Settings.Tertiary_DarkTheme
			else
				Frame.TEXTURE_Subcategory = addon.Variables.PATH_ART .. "Settings/subcategory.png"
				Frame.TEXTURE_Background = addon.API.Presets.NINESLICE_INSCRIBED
				Frame.COLOR_Background = addon.Theme.Settings.Tertiary_LightTheme
			end
		end

		UpdateTheme()
		addon.API.Main:RegisterThemeUpdate(UpdateTheme, 0)
	end

	do -- TOOLTIP
		function Frame:OnEnter(skipAnimation)
			if background then
				if not InteractionSettingsFrame.PreventMouse or addon.Input.Variables.IsControllerEnabled then
					Frame.Background:SetAlpha(1)
				end
			end

			if tooltipText then
				if Frame:IsVisible() and addon.API.Main:IsElementInScrollFrame(InteractionSettingsFrame.Content.ScrollFrame, Frame) then
					if not InteractionSettingsFrame.PreventMouse or addon.Input.Variables.IsControllerEnabled then
						local text = tooltipText
						if tooltipTextDynamic and tooltipTextDynamic() then
							text = tooltipTextDynamic()
						end

						--------------------------------

						NS.Script:ShowTooltip(Frame, text, tooltipImage, tooltipImageSize, skipAnimation)
					end
				end
			end

			if Frame.Button then
				Frame.Button:OnEnter()
			end
		end

		function Frame:OnLeave(skipAnimation, keepTooltip)
			if background then
				if skipAnimation then
					Frame.Background:SetAlpha(0)
				else
					Frame.Background:SetAlpha(0)
				end
			end

			if tooltipText then
				if Frame:IsVisible() then
					if not keepTooltip then
						NS.Script:HideTooltip()
					end
				end
			end

			if Frame.Button then
				Frame.Button:OnLeave()
			end
		end

		if background or tooltipText then
			Frame.hoverFrame = addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave })
		end
	end

	do -- ELEMENTS
		do -- ICON
			if subcategory and subcategory >= 1 then
				-- INDENTATION
				offsetX_Indentation = (INDENTATION) * (subcategory - 1)

				-- FRAME
				for x = 1, subcategory do
					Frame["Icon" .. x], Frame["IconTexture" .. x] = addon.API.FrameTemplates:CreateTexture(Frame, Frame:GetFrameStrata(), Frame.TEXTURE_Subcategory)
					Frame["Icon" .. x]:SetSize(height or 45, height or 52.5)
					Frame["Icon" .. x]:SetPoint("LEFT", Frame, 7.5 + (INDENTATION) * (x - 1), 0)

					-- THEME
					addon.API.Main:RegisterThemeUpdate(function()
						Frame["IconTexture" .. x]:SetTexture(Frame.TEXTURE_Subcategory)
					end, 5)
				end

				-- OFFSET
				offsetX = Frame["Icon1"]:GetWidth() + 5 + offsetX_Indentation
			end
		end

		do -- CONTAINER
			Frame.Container = CreateFrame("Frame")
			Frame.Container:SetParent(Frame)
			Frame.Container:SetSize(Frame:GetWidth() - offsetX - PADDING, Frame:GetHeight() - PADDING)
			Frame.Container:SetPoint("CENTER", Frame, offsetX / 2, 0)
		end

		do -- BACKGROUND
			if background then
				Frame.Background, Frame.BackgroundTexture = addon.API.FrameTemplates:CreateNineSlice(Frame.Container, Frame:GetFrameStrata(), Frame.TEXTURE_Background, 50, 1)
				Frame.Background:SetSize(Frame:GetWidth(), Frame:GetHeight())
				Frame.Background:SetPoint("CENTER", Frame)
				Frame.Background:SetFrameLevel(0)
				Frame.Background:SetAlpha(0)

				-- THEME
				addon.API.Main:RegisterThemeUpdate(function()
					Frame.BackgroundTexture:SetVertexColor(Frame.COLOR_Background.r, Frame.COLOR_Background.g, Frame.COLOR_Background.b, Frame.COLOR_Background.a)
				end, 5)
			end
		end

		do -- TEXT
			local Padding = 10

			Frame.Text = addon.API.FrameTemplates:CreateText(Frame.Container, addon.Theme.RGB_RECOMMENDED, 15, "LEFT", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT)
			Frame.Text:SetSize(Frame.Container:GetWidth() - 150 - Padding, Frame.Container:GetHeight())
			Frame.Text:SetPoint("LEFT", Frame.Container, Padding / 2, 0)
			Frame.Text:SetAlpha(.75)

			if subcategory and subcategory >= 1 then
				Frame.Text:SetAlpha(.75)
			end
		end
	end

	do -- STATE
		local function UpdateState(PreventRepeat)
			if hidden then
				if not InteractionSettingsFrame:IsVisible() then
					return
				end

				--------------------------------

				local SavedHidden = Frame.hidden
				local Hidden = hidden()

				if Hidden then
					Frame.hidden = true

					--------------------------------

					Frame:SetAlpha(0)
					Frame:Hide()
				else
					Frame.hidden = false

					--------------------------------

					Frame:SetAlpha(0)
					Frame:Show()
				end

				--------------------------------

				InteractionSettingsFrame.Content.ScrollFrame.Update(PreventRepeat)
				addon.Libraries.AceTimer:ScheduleTimer(function()
					InteractionSettingsFrame.Content.ScrollFrame.Update(PreventRepeat)
				end, .25)
			end

			if locked then
				if not InteractionSettingsFrame:IsVisible() then
					return
				end

				--------------------------------

				local locked = locked()

				if locked then
					Frame.Container:SetAlpha(.25)
					Frame:EnableMouse(false)

					--------------------------------

					if Frame.KeybindButton then
						Frame.KeybindButton:EnableMouse(false)
					end
				else
					Frame.Container:SetAlpha(1)
					Frame:EnableMouse(true)

					--------------------------------

					if Frame.KeybindButton then
						Frame.KeybindButton:EnableMouse(true)
					end
				end
			end
		end

		CallbackRegistry:Add("START_SETTING", function() UpdateState(true) end, 0)
		CallbackRegistry:Add("SETTING_CHANGED", function()
			if InteractionSettingsFrame:GetAlpha() > .5 then
				UpdateState()
			end
		end, 0)
		CallbackRegistry:Add("SETTING_TAB_CHANGED", function() UpdateState() end, 0)
		CallbackRegistry:Add("START_INTERACTION", function() UpdateState() end, 2)
		CallbackRegistry:Add("STOP_INTERACTION", function() UpdateState() end, 2)
	end

	--------------------------------

	Frame.hidden = false

	--------------------------------

	return Frame
end
