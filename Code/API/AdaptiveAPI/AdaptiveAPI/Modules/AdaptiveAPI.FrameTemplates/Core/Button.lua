local addonName, addon = ...
local NS = AdaptiveAPI.FrameTemplates
local CallbackRegistry = addon.CallbackRegistry

--------------------------------
-- VARIABLES
--------------------------------

do -- MAIN

end

do -- CONSTANTS

end

--------------------------------
-- TEMPLATES
--------------------------------

do
	-- Creates a Blizzard button.
	---@param parent any
	---@param sizeX number
	---@param sizeY number
	---@param frameStrata string
	---@param name? string
	function NS:CreateButton(parent, sizeX, sizeY, frameStrata, name)
		local Button = CreateFrame("Button", name or nil, parent, "UIPanelButtonTemplate")
		Button:SetSize(sizeX, sizeY)
		Button:SetFrameStrata(frameStrata)

		--------------------------------

		return Button
	end

	-- Creates a stylised button.
	--
	-- Data Table
	----
	-- theme, defaultTexture, highlightTexture, edgeSize, scale,
	-- playAnimation, customColor, customHighlightColor, customActiveColor,
	-- customTextColor, customTextHighlightColor, customFont, customFontSize,
	-- disableHighlight, disableMouseHighlight, disableMouseDown, disableMouseUp
	---@param parent any
	---@param sizeX number
	---@param sizeY number
	---@param frameStrata string
	---@param data table
	---@param name? string
	function NS:CreateCustomButton(parent, sizeX, sizeY, frameStrata, data, name)
		local Button = AdaptiveAPI.FrameTemplates:CreateButton(parent, sizeX, sizeY, frameStrata, name)
		NS.Styles:Button(Button, data)

		--------------------------------

		return Button
	end
end

--------------------------------
-- STYLES
--------------------------------

do
	do -- LEGACY
		-- Data Table
		----
		-- animation, mouseOverAnimation, modifier, textModifier, textureToApply, forceTextureButton, buttonType
		---@param frame any
		---@param data table
		function NS.Styles:ButtonLegacy(frame, data)
			local animation, mouseOverAnimation, modifier, textModifier, textureToApply, forceTextureButton, buttonType =
				data.animation, data.mouseOverAnimation, data.modifier, data.textModifier, data.textureToApply, data.forceTextureButton, data.buttonType

			--------------------------------

			if not frame then
				return
			end

			if not modifier then
				modifier = AdaptiveAPI.Presets.UIModifier + .1
			end

			if not textModifier then
				textModifier = AdaptiveAPI.Presets.UITextModifier
			end

			local function StyleButton(button, name, texture)
				if AdaptiveAPI:FindString(frame:GetDebugName(), name) == true then
					if not button.createdFrameTexture then
						button.createdFrameTexture = true

						if button.SetNormalTexture then button:SetNormalTexture(texture) end
						if button.SetHighlightTexture then
							frame:SetHighlightTexture(texture)
							frame:GetHighlightTexture():SetVertexColor(0, 0, 0)
						end
						if button.SetPushedTexture then button:SetPushedTexture(texture) end
						if button.SetDisabledTexture then button:SetDisabledTexture(texture) end
					end

					if frame.GetNormalTexture then
						frame:GetNormalTexture():SetVertexColor(1, 1, 1)
					end

					if frame.GetHightlightTexture then
						frame:GetHighlightTexture():SetVertexColor(.75, .75, .75)
					end

					if frame.GetPushedTexture then
						frame:GetPushedTexture():SetVertexColor(.5, .5, .5)
					end

					if frame.GetDisabledTexture then
						frame:GetDisabledTexture():SetVertexColor(.05, .05, .05)
					end

					for f1 = 1, frame:GetNumRegions() do
						local _frameIndex1 = select(f1, frame:GetRegions())

						if AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "Left") == true then
							_frameIndex1:Hide()
						end

						if AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "Right") == true then
							_frameIndex1:Hide()
						end

						if AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "Top") == true then
							_frameIndex1:Hide()
						end

						if AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "Bottom") == true then
							_frameIndex1:Hide()
						end

						if AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "Border") == true and not AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "BorderFrame") then
							_frameIndex1:Hide()
						end

						if AdaptiveAPI:FindString(_frameIndex1:GetDebugName(), "icon") == true then
							_frameIndex1:Hide()
						end
					end
				end
			end

			if not frame.Middle and not forceTextureButton then
				if not textureToApply then
					StyleButton(frame, "Close", "Interface/AddOns/AdaptiveUI/Art/Skins/UIElements/button_close")
					StyleButton(frame, "Minimize", "Interface/AddOns/AdaptiveUI/Art/Skins/UIElements/button_minimize")
					StyleButton(frame, "Maximize", "Interface/AddOns/AdaptiveUI/Art/Skins/UIElements/button_maximize")
					StyleButton(frame, "Dropdown", "Interface/AddOns/AdaptiveUI/Art/Skins/UIElements/button_dropdown")
				else
					if textureToApply == "Close" then
						StyleButton(frame, "", "Interface/AddOns/AdaptiveUI/Art/Skins/UIElements/button_close")
					end
					if textureToApply == "Minimize" then
						StyleButton(frame, "", "Interface/AddOns/AdaptiveUI/Art/Skins/UIElements/button_minimize")
					end
					if textureToApply == "Maximize" then
						StyleButton(frame, "", "Interface/AddOns/AdaptiveUI/Art/Skins/UIElements/button_maximize")
					end
					if textureToApply == "Dropdown" then
						StyleButton(frame, "", "Interface/AddOns/AdaptiveUI/Art/Skins/UIElements/button_dropdown")
					end
				end

				if not frame.hookedAnimation then
					frame.hookedAnimation = true

					frame:HookScript("OnEnter", function()
						AdaptiveAPI.Animation:Fade(frame, .125, .5, 1)
					end)

					frame:HookScript("OnLeave", function()
						AdaptiveAPI.Animation:Fade(frame, .125, 1, .5)
					end)

					frame:SetAlpha(.5)
				end
			else
				if not frame.createdFrameTexture then
					frame.createdFrameTexture = true

					if not buttonType or (buttonType == 0) then
						frame.backdrop = AdaptiveAPI.FrameTemplates:CreateBackdrop(frame, "HIGH", { r = .325, g = .325, b = .325, a = 1 }, { r = .5, g = .5, b = .5, a = 1 })
						frame.backdrop:SetSize(frame:GetWidth(), frame:GetHeight())
						frame.backdrop:SetPoint("CENTER", frame)
						frame.backdrop:SetFrameStrata(frame:GetFrameStrata())
						frame.backdrop:SetFrameLevel(frame:GetFrameLevel())

						frame.backdrop:SetScript("OnUpdate", function()
							frame.backdrop:SetSize(frame:GetWidth(), frame:GetHeight())
						end)

						hooksecurefunc(frame, "SetWidth", function()
							frame.backdrop:SetWidth(frame:GetWidth())
						end)

						hooksecurefunc(frame, "SetHeight", function()
							frame.backdrop:SetHeight(frame:GetHeight())
						end)

						frame:HookScript("OnEnter", function()
							if frame.IsEnabled and frame:IsEnabled() then
								frame.backdrop:SetBackdropColor(.5, .5, .5)
							end
						end)

						frame:HookScript("OnLeave", function()
							if frame.IsEnabled and frame:IsEnabled() then
								frame.backdrop:SetBackdropColor(.325, .325, .325)
							end
						end)

						frame:HookScript("OnMouseDown", function()
							if frame.IsEnabled and frame:IsEnabled() then
								frame.backdrop:SetBackdropColor(.75, .75, .75)
							end
						end)

						frame:HookScript("OnMouseUp", function()
							if frame.IsEnabled and frame:IsEnabled() then
								frame.backdrop:SetBackdropColor(.325, .325, .325)
							end
						end)

						frame:HookScript("OnUpdate", function()
							if (frame.IsEnabled and frame:IsEnabled()) == false then
								frame:SetAlpha(.5)
							else
								frame:SetAlpha(1)
							end
						end)

						if frame.SetHighlightTexture then
							frame:GetHighlightTexture():SetVertexColor(1, 1, 1, 0)
						end
					elseif buttonType == 1 then
						if frame.SetNormalTexture then
							frame:SetNormalTexture(AdaptiveAPI.Presets.BASIC_SQUARE)
						end
						if frame.SetHighlightTexture then
							frame:SetHighlightTexture(AdaptiveAPI.Presets.BASIC_SQUARE)
							frame:GetHighlightTexture():SetVertexColor(0, 0, 0)
						end
						if frame.SetPushedTexture then
							frame:SetPushedTexture(AdaptiveAPI.Presets.BASIC_SQUARE)
						end
						if frame.SetDisabledTexture then
							frame:SetDisabledTexture(AdaptiveAPI.Presets.BASIC_SQUARE)
						end
					end

					if frame.Left then
						frame.Left:Hide()
					end

					if frame.Middle then
						frame.Middle:Hide()
					end

					if frame.Right then
						frame.Right:Hide()
					end

					if frame.Center then
						frame.Center:Hide()
					end
				end

				local normal = .125
				local highlight = .25
				local pushed = .375
				local disabled = .05

				if buttonType == 1 then
					if frame.GetNormalTexture then
						frame:GetNormalTexture():SetVertexColor(normal, normal, normal)
					end

					if frame.GetHightlightTexture then
						frame:GetHighlightTexture():SetVertexColor(highlight, highlight, highlight)
					end

					if frame.GetPushedTexture then
						frame:GetPushedTexture():SetVertexColor(pushed, pushed, pushed)
					end

					if frame.GetDisabledTexture then
						frame:GetDisabledTexture():SetVertexColor(disabled, disabled, disabled)
					end

					if not frame.hookedAnimation then
						frame.hookedAnimation = true

						frame:HookScript("OnEnter", function()
							if frame.GetNormalTexture then
								frame:GetNormalTexture():SetVertexColor(highlight, highlight, highlight)
							end
						end)

						frame:HookScript("OnLeave", function()
							if frame.GetNormalTexture then
								frame:GetNormalTexture():SetVertexColor(normal, normal, normal)
							end
						end)
					end
				end
			end

			AdaptiveAPI:SetTextColorScaleAll(frame, textModifier, textModifier, textModifier)
		end

		-- Add button animation.
		function NS.Styles:ButtonAnimationLegacy(frame, mouseOverAnimation)
			if not frame then
				return
			end

			if frame.hasAnimation then
				return
			end

			frame.hasAnimation = true

			AdaptiveAPI:AnchorToCenter(frame, true)

			local mouseOverSize = 1
			local mouseDownSize = 1

			-- SQUARE BUTTONS
			if frame:GetHeight() / frame:GetWidth() >= 1 and frame:GetWidth() <= 30 and frame:GetHeight() <= 30 then
				mouseOverSize = 1
				mouseDownSize = 1
			end

			-- MOUSE OVER ANIMATION
			if mouseOverAnimation == false then
				mouseOverSize = frame:GetScale()
			end

			frame:HookScript("OnEnter", function(self)
				frame.mouseOver = true
				-- AdaptiveAPI.Animation:AnimateIn(self, .125, 1, mouseOverSize, 0, false)
			end)

			frame:HookScript("OnMouseDown", function(self)
				frame.mouseDown = true
				-- AdaptiveAPI.Animation:AnimateIn(self, .125, mouseOverSize, mouseDownSize, 0, false)
			end)

			local function MouseUpAnimation()
				if frame.mouseOver == true then
					-- AdaptiveAPI.Animation:AnimateIn(frame, .125, mouseDownSize, mouseOverSize, 0, false)
				end
			end

			frame:HookScript("OnMouseUp", function(self)
				frame.mouseDown = false
				MouseUpAnimation()
			end)

			frame:HookScript("OnLeave", function(self)
				frame.mouseOver = false
				-- AdaptiveAPI.Animation:AnimateIn(self, .125, mouseOverSize, 1, 0, false)
			end)
		end
	end

	do -- BUTTON
		-- Styles a button.
		--
		-- Data Table
		----
		-- theme, defaultTexture, highlightTexture, edgeSize, scale,
		-- playAnimation, customColor, customHighlightColor, customActiveColor,
		-- customTextColor, customTextHighlightColor, customFont, customFontSize,
		-- disableHighlight, disableMouseHighlight, disableMouseDown, disableMouseUp
		---@param frame any
		---@param data table
		function NS.Styles:Button(frame, data)
			local theme, defaultTexture, highlightTexture, edgeSize, scale, playAnimation, customColor, customHighlightColor, customActiveColor, customTextColor, customTextHighlightColor, customFont, customFontSize, disableHighlight, disableMouseHighlight, disableMouseDown, disableMouseUp =
				data.theme, data.defaultTexture, data.highlightTexture, data.edgeSize, data.scale, data.playAnimation, data.customColor, data.customHighlightColor, data.customActiveColor, data.customTextColor, data.customTextHighlightColor, data.customFont, data.customFontSize, data.disableHighlight, data.disableMouseHighlight, data.disableMouseDown, data.disableMouseUp

			--------------------------------

			if not frame or frame.stylised then
				return
			end
			frame.stylised = true

			--------------------------------

			frame.IsActive = false
			frame.IsHighlight = false

			frame._defaultTexture = nil
			frame._highlightTexture = nil
			frame._textColor = nil
			frame._textHighlightColor = nil
			frame._color = nil
			frame._highlightColor = nil
			frame._activeColor = nil
			frame._font = AdaptiveAPI.Fonts.Content_Light or GameFontNormal:GetFont()
			frame._fontSize = 12.5

			frame.customDefaultTexture = defaultTexture
			frame.customHighlightTexture = highlightTexture
			frame.customColor = customColor
			frame.customHighlightColor = customHighlightColor
			frame.customTextColor = customTextColor
			frame.customTextHighlightColor = customTextHighlightColor
			frame.customActiveColor = customActiveColor
			frame.customFont = customFont
			frame.customFontSize = customFontSize

			frame.EnterCallbacks = {}
			frame.LeaveCallbacks = {}
			frame.MouseDownCallbacks = {}
			frame.MouseUpCallbacks = {}

			--------------------------------

			do -- THEME
				local function UpdateTheme()
					if (theme and theme == 2) or (not theme and AdaptiveAPI.IsDarkTheme) then
						frame._defaultTexture = AdaptiveAPI.Presets.NINESLICE_INSCRIBED_BORDER
						frame._highlightTexture = AdaptiveAPI.Presets.NINESLICE_INSCRIBED
						frame._textColor = { r = 1, g = 1, b = 1, a = 1 }
						frame._textHighlightColor = { r = 1, g = 1, b = 1, a = 1 }
						frame._color = { r = .5, g = .5, b = .5, a = .5 }
						frame._highlightColor = { r = .5, g = .5, b = .5, a = .5 }
						frame._activeColor = { r = .5, g = .5, b = .5, a = .5 }
					elseif (theme and theme == 1) or (not theme and not AdaptiveAPI.IsDarkTheme) then
						frame._defaultTexture = AdaptiveAPI.Presets.NINESLICE_INSCRIBED_BORDER
						frame._highlightTexture = AdaptiveAPI.Presets.NINESLICE_INSCRIBED
						frame._textColor = { r = .1, g = .1, b = .1, a = 1 }
						frame._textHighlightColor = { r = 1, g = 1, b = 1, a = 1 }
						frame._color = { r = 0, g = 0, b = 0, a = .5 }
						frame._highlightColor = { r = 0, g = 0, b = 0, a = .5 }
						frame._activeColor = { r = 0, g = 0, b = 0, a = .5 }
					end

					--------------------------------

					frame._defaultTexture = frame.customDefaultTexture or frame._defaultTexture
					frame._highlightTexture = frame.customHighlightTexture or frame._highlightTexture
					frame._textColor = frame.customTextColor or frame._textColor
					frame._textHighlightColor = frame.customTextHIghlightColor or frame._textHighlightColor
					frame._color = frame.customColor or frame._color
					frame._highlightColor = frame.customHighlightColor or frame._highlightColor
					frame._activeColor = frame.customActiveColor or frame._activeColor
					frame._font = frame.customFont or frame._font
					frame._fontSize = frame.customFontSize or frame._fontSize
				end

				AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(UpdateTheme, 4)
			end

			do -- TEXT
				frame.text = frame.Text
				if _G[frame:GetDebugName() .. "Text"] then
					frame.text = _G[frame:GetDebugName() .. "Text"]
				end

				--------------------------------

				frame.text:SetFont(frame._font, frame._fontSize, "")
				frame.text:SetTextColor(frame._textColor.r, frame._textColor.g, frame._textColor.b, frame._textColor.a or 1)
				frame.text:SetShadowOffset(0, 0)
			end

			do -- BACKGROUND
				frame.backdrop, frame.backdropTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(frame, "LOW", nil, edgeSize or 25, scale or .5)
				frame.backdrop:SetAllPoints(frame, true)
				frame.backdrop:SetFrameStrata(frame:GetFrameStrata())
				frame.backdrop:SetFrameLevel(frame:GetFrameLevel())

				--------------------------------

				AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
					frame.backdropTexture:SetTexture(frame._defaultTexture)
				end, 5)

				--------------------------------

				if playAnimation or playAnimation == nil then
					frame.backdropTexture:SetVertexColor(frame._color.r, frame._color.g, frame._color.b, frame._highlightColor.a or .75)
				else
					frame.backdropTexture:SetVertexColor(frame._color.r, frame._color.g, frame._color.b, frame._highlightColor.a or .75)
				end

				--------------------------------

				hooksecurefunc(frame, "SetWidth", function()
					frame.backdrop:SetWidth(frame:GetWidth())
				end)

				hooksecurefunc(frame, "SetHeight", function()
					frame.backdrop:SetHeight(frame:GetHeight())
				end)

				hooksecurefunc(frame, "SetSize", function()
					frame.backdrop:SetSize(frame:GetWidth(), frame:GetHeight())
				end)
			end

			--------------------------------

			do -- CLICK EVENTS
				local disableHighlight = disableHighlight or false

				frame.Enter = function()
					if frame.IsEnabled and frame:IsEnabled() and not disableHighlight then
						frame.IsHighlight = true

						--------------------------------

						if frame._highlightColor.a and frame._highlightColor.a < .5 then
							frame.text:SetTextColor(frame._textColor.r, frame._textColor.g, frame._textColor.b, frame._textColor.a or 1)
						else
							frame.text:SetTextColor(frame._textHighlightColor.r, frame._textHighlightColor.g, frame._textHighlightColor.b, frame._textHighlightColor.a or 1)
						end

						--------------------------------

						frame.backdropTexture:SetTexture(frame._highlightTexture)
						frame.backdropTexture:SetVertexColor(frame._highlightColor.r, frame._highlightColor.g, frame._highlightColor.b, frame._highlightColor.a or .5)

						--------------------------------

						if playAnimation or playAnimation == nil then
							AdaptiveAPI.Animation:PreciseMove(frame.text, 1, frame, "CENTER", 0, 0, 0, 2.5)
							AdaptiveAPI.Animation:PreciseMove(frame.backdrop, 1, frame, "CENTER", 0, 0, 0, 2.5)
						end

						--------------------------------

						local EnterCallbacks = frame.EnterCallbacks

						for callback = 1, #EnterCallbacks do
							EnterCallbacks[callback]()
						end
					end

					--------------------------------

					frame.UpdateActive()
				end

				frame.Leave = function()
					frame.IsHighlight = false

					--------------------------------

					frame.text:SetTextColor(frame._textColor.r, frame._textColor.g, frame._textColor.b, frame._textColor.a or 1)

					--------------------------------

					frame.backdropTexture:SetTexture(frame._defaultTexture)
					frame.backdropTexture:SetVertexColor(frame._color.r, frame._color.g, frame._color.b, frame._highlightColor.a or .75)

					--------------------------------

					if frame.IsEnabled and frame:IsEnabled() and not disableHighlight then
						if playAnimation or playAnimation == nil then
							AdaptiveAPI.Animation:PreciseMove(frame.text, 1, frame, "CENTER", 0, 2.5, 0, 0)
							AdaptiveAPI.Animation:PreciseMove(frame.backdrop, 1, frame, "CENTER", 0, 2.5, 0, 0)
						end

						--------------------------------

						local LeaveCallbacks = frame.LeaveCallbacks

						for callback = 1, #LeaveCallbacks do
							LeaveCallbacks[callback]()
						end
					end

					--------------------------------

					frame.UpdateActive()
				end

				frame.MouseDown = function()
					if frame.IsEnabled and frame:IsEnabled() and not disableMouseDown then
						if playAnimation or playAnimation == nil then
							frame.backdropTexture:SetVertexColor(frame._color.r, frame._color.g, frame._color.b, .25)
						else
							frame.backdropTexture:SetVertexColor(frame._color.r, frame._color.g, frame._color.b, .25)
						end

						--------------------------------

						local MouseDownCallbacks = frame.MouseDownCallbacks

						for callback = 1, #MouseDownCallbacks do
							MouseDownCallbacks[callback]()
						end
					end
				end

				frame.MouseUp = function()
					if frame.IsEnabled and frame:IsEnabled() and not disableMouseUp then
						if playAnimation or playAnimation == nil then
							frame.backdropTexture:SetVertexColor(frame._color.r, frame._color.g, frame._color.b, .5)
						else
							frame.backdropTexture:SetVertexColor(frame._color.r, frame._color.g, frame._color.b, .5)
						end

						--------------------------------

						local MouseUpCallbacks = frame.MouseUpCallbacks

						for callback = 1, #MouseUpCallbacks do
							MouseUpCallbacks[callback]()
						end
					end
				end

				frame:HookScript("OnEnter", function()
					if disableMouseHighlight then return end

					frame.Enter()
				end)

				frame:HookScript("OnLeave", function()
					if disableMouseHighlight then return end

					frame.Leave()
				end)

				frame:HookScript("OnMouseDown", function()
					frame.MouseDown()
				end)

				frame:HookScript("OnMouseUp", function()
					frame.MouseUp()
				end)
			end

			do -- STATE UPDATES
				frame.SetActive = function(value)
					frame.IsActive = value

					--------------------------------

					addon.Libraries.AceTimer:ScheduleTimer(function()
						frame.UpdateActive()
					end, 0)
				end

				frame.UpdateEnabled = function()
					if frame.IsEnabled and not frame:IsEnabled() then
						frame:SetAlpha(.5)
					else
						frame:SetAlpha(1)
					end
				end

				frame.UpdateActive = function()
					if frame.IsActive then
						if frame._highlightColor.a and frame._highlightColor.a < .5 then
							if (theme and theme == 2) or (not theme and AdaptiveAPI.IsDarkTheme) then
								frame.text:SetTextColor(frame._textHighlightColor.r, frame._textHighlightColor.g, frame._textHighlightColor.b, frame._textHighlightColor.a or 1)
							else
								frame.text:SetTextColor(frame._textColor.r, frame._textColor.g, frame._textColor.b, frame._textColor.a or 1)
							end
						else
							frame.text:SetTextColor(frame._textHighlightColor.r, frame._textHighlightColor.g, frame._textHighlightColor.b, frame._textHighlightColor.a or 1)
						end

						frame.backdropTexture:SetTexture(frame._highlightTexture)
						frame.backdropTexture:SetVertexColor(frame._activeColor.r, frame._activeColor.g, frame._activeColor.b, frame._activeColor.a or .5)
					else
						if not frame.IsHighlight then
							frame.text:SetTextColor(frame._textColor.r, frame._textColor.g, frame._textColor.b, frame._textColor.a or 1)
							frame.backdropTexture:SetTexture(frame._defaultTexture)
							frame.backdropTexture:SetVertexColor(frame._color.r, frame._color.g, frame._color.b, frame._color.a or .75)
						end
					end
				end

				--------------------------------

				frame.UpdateEnabled()
				frame.UpdateActive()

				--------------------------------

				AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(frame.UpdateActive, 10)

				--------------------------------

				hooksecurefunc(frame, "SetEnabled", frame.UpdateEnabled)
			end

			--------------------------------

			do -- BLIZZARD
				if frame.Left then
					frame.Left:Hide()
				end

				if frame.Middle then
					frame.Middle:Hide()
				end

				if frame.Right then
					frame.Right:Hide()
				end

				if frame.Center then
					frame.Center:Hide()
				end

				if frame.SetHighlightTexture then
					frame:GetHighlightTexture():SetVertexColor(1, 1, 1, 0)
				end
			end

			--------------------------------

			local Events = CreateFrame("Frame", "$parent.Events", frame)
			Events:RegisterEvent("GAME_PAD_ACTIVE_CHANGED")
			Events:SetScript("OnEvent", function(self, event, ...)
				if event == "GAME_PAD_ACTIVE_CHANGED" then
					frame.Leave()
				end
			end)
		end

		-- Update a stylised button theme.
		-- Data Table
		----
		-- customDefaultTexture, customHighlightTexture, customColor, customHighlightColor, customActiveColor, customTextColor, customTextHighlightColor
		---@param frame any
		---@param data table
		function NS.Styles:UpdateButton(frame, data)
			local customDefaultTexture, customHighlightTexture, customColor, customHighlightColor, customActiveColor, customTextColor, customTextHighlightColor =
				data.customDefaultTexture, data.customHighlightTexture, data.customColor, data.customHighlightColor, data.customActiveColor, data.customTextColor, data.customTextHighlightColor

			--------------------------------

			if customDefaultTexture then frame.customDefaultTexture = customDefaultTexture end
			if customHighlightTexture then frame.customHighlightTexture = customHighlightTexture end
			if customColor then frame.customColor = customColor end
			if customHighlightColor then frame.customHighlightColor = customHighlightColor end
			if customActiveColor then frame.customActiveColor = customActiveColor end
			if customTextColor then frame.customTextColor = customTextColor end
			if customTextHighlightColor then frame.customTextHighlightColor = customTextHighlightColor end
		end
	end
end
