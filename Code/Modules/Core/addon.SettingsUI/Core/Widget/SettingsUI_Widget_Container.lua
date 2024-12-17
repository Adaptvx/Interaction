local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

-- Creates a container. Child Frames: Icon (if applicable), Container
function NS.Widgets:CreateContainer(parent, subcategory, background, height, tooltipText, tooltipImage, tooltipImageSize, hidden, locked)
	local OffsetX = 0
	local IndentationOffsetX = 0

	local IndentationOffset = height or NS.Variables:RATIO(5)
	local Padding = math.ceil(NS.Variables:RATIO(7))

	--------------------------------

	local Frame = CreateFrame("Frame")
	Frame:SetParent(parent)
	Frame:SetSize(parent:GetWidth(), height or NS.Variables:RATIO(5))
	Frame:SetPoint("TOP", parent)

	--------------------------------

	Frame.Var_Parent = parent
	Frame.Var_Subcategory = subcategory
	Frame.Var_Background = background
	Frame.Var_Height = height
	Frame.Var_TooltipText = tooltipText
	Frame.Var_TooltipImage = tooltipImage
	Frame.Var_TooltipImageSize = tooltipImageSize
	Frame.Var_Hidden = hidden
	Frame.Var_Locked = locked

	--------------------------------

	Frame.TEXTURE_Subcategory = nil
	Frame.TEXTURE_Background = nil
	Frame.COLOR_Background = nil

	local function UpdateTheme()
		if addon.Theme.IsDarkTheme then
			Frame.TEXTURE_Subcategory = addon.Variables.PATH .. "Art/Settings/subcategory-dark-mode.png"
			Frame.TEXTURE_Background = AdaptiveAPI.Presets.NINESLICE_INSCRIBED
			Frame.COLOR_Background = addon.Theme.Settings.Tertiary_DarkTheme
		else
			Frame.TEXTURE_Subcategory = addon.Variables.PATH .. "Art/Settings/subcategory.png"
			Frame.TEXTURE_Background = AdaptiveAPI.Presets.NINESLICE_INSCRIBED
			Frame.COLOR_Background = addon.Theme.Settings.Tertiary_LightTheme
		end
	end

	UpdateTheme()
	addon.API:RegisterThemeUpdate(UpdateTheme, 0)

	--------------------------------

	Frame.Enter = function(skipAnimation)
		if background then
			if not InteractionSettingsFrame.PreventMouse then
				if skipAnimation then
					Frame.background:SetAlpha(1)
				else
					Frame.background:SetAlpha(1)
				end
			end
		end

		if tooltipText then
			if Frame:IsVisible() and addon.API:IsElementInScrollFrame(InteractionSettingsFrame.Content.ScrollFrame, Frame) then
				if not InteractionSettingsFrame.PreventMouse then
					NS.Script:ShowTooltip(Frame, tooltipText, tooltipImage, tooltipImageSize, skipAnimation)
				end
			end
		end

		if Frame.button then
			Frame.button.Enter()
		end
	end

	Frame.Leave = function(skipAnimation, keepTooltip)
		if background then
			if skipAnimation then
				Frame.background:SetAlpha(0)
			else
				Frame.background:SetAlpha(0)
			end
		end

		if tooltipText then
			if Frame:IsVisible() then
				if not keepTooltip then
					NS.Script:HideTooltip()
				end
			end
		end

		if Frame.button then
			Frame.button.Leave()
		end
	end

	if background or tooltipText then
		Frame.hoverFrame = AdaptiveAPI.FrameTemplates:CreateMouseResponder(Frame,
			function()
				Frame.Enter()
			end,
			function()
				Frame.Leave()
			end
			, nil, nil, true
		)
	end

	--------------------------------

	local function Icon()
		if subcategory and subcategory >= 1 then
			-- INDENTATION
			IndentationOffsetX = (IndentationOffset) * (subcategory - 1)

			-- FRAME
			for x = 1, subcategory do
				Frame["Icon" .. x], Frame["IconTexture" .. x] = AdaptiveAPI.FrameTemplates:CreateTexture(Frame, Frame:GetFrameStrata(), Frame.TEXTURE_Subcategory)
				Frame["Icon" .. x]:SetSize(height or 45, height or 45)
				Frame["Icon" .. x]:SetPoint("LEFT", Frame, 7.5 + (IndentationOffset) * (x - 1), 0)

				-- THEME
				addon.API:RegisterThemeUpdate(function()
					Frame["IconTexture" .. x]:SetTexture(Frame.TEXTURE_Subcategory)
				end, 5)
			end

			-- OFFSET
			OffsetX = Frame["Icon1"]:GetWidth() + 5 + IndentationOffsetX
		end
	end

	local function Container()
		Frame.container = CreateFrame("Frame")
		Frame.container:SetParent(Frame)
		Frame.container:SetSize(Frame:GetWidth() - OffsetX - Padding, Frame:GetHeight() - Padding)
		Frame.container:SetPoint("CENTER", Frame, OffsetX / 2, 0)
	end

	local function Background()
		if background then
			Frame.background, Frame.backgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(Frame.container, Frame:GetFrameStrata(), Frame.TEXTURE_Background, 50, 1)
			Frame.background:SetSize(Frame:GetWidth(), Frame:GetHeight())
			Frame.background:SetPoint("CENTER", Frame)
			Frame.background:SetFrameLevel(0)
			Frame.background:SetAlpha(0)

			-- THEME
			addon.API:RegisterThemeUpdate(function()
				Frame.backgroundTexture:SetVertexColor(Frame.COLOR_Background.r, Frame.COLOR_Background.g, Frame.COLOR_Background.b, Frame.COLOR_Background.a)
			end, 5)
		end
	end

	local function Label()
		Frame.label = AdaptiveAPI.FrameTemplates:CreateText(Frame.container, addon.Theme.RGB_RECOMMENDED, 15, "LEFT", "MIDDLE", AdaptiveAPI.Fonts.Content_Light)
		Frame.label:SetSize(Frame.container:GetWidth() - 10, Frame.container:GetHeight() - 10)
		Frame.label:SetPoint("CENTER", Frame.container, 0, 0)
		Frame.label:SetAlpha(.75)

		if subcategory and subcategory >= 1 then
			Frame.label:SetAlpha(.75)
		end
	end

	--------------------------------

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
				Frame.container:SetAlpha(.25)
				Frame:EnableMouse(false)
			else
				Frame.container:SetAlpha(1)
				Frame:EnableMouse(true)
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

	--------------------------------

	Icon()
	Container()
	Background()
	Label()

	--------------------------------

	Frame.hidden = false

	--------------------------------

	return Frame
end
