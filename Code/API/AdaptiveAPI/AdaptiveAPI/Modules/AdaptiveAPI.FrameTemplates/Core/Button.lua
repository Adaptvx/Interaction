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
	-- texturePadding, playAnimation,
	-- customColor, customHighlightColor, customActiveColor,
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
	do -- BUTTON
		-- Styles a button.
		--
		-- Data Table
		----
		-- theme, defaultTexture, highlightTexture, edgeSize, scale,
		-- texturePadding, playAnimation,
		-- customColor, customHighlightColor, customActiveColor,
		-- customTextColor, customTextHighlightColor, customFont, customFontSize,
		-- disableHighlight, disableMouseHighlight, disableMouseDown, disableMouseUp
		---@param frame any
		---@param data table
		function NS.Styles:Button(frame, data)
			if not frame or frame.StyledButton then
				return
			end
			frame.StyledButton = true

			--------------------------------

			local theme, defaultTexture, highlightTexture, edgeSize, scale, texturePadding, playAnimation, customColor, customHighlightColor, customActiveColor, customTextColor, customTextHighlightColor, customFont, customFontSize, disableHighlight, disableMouseHighlight, disableMouseDown, disableMouseUp =
				data.theme, data.defaultTexture, data.highlightTexture, data.edgeSize, data.scale, data.texturePadding, data.playAnimation, data.customColor, data.customHighlightColor, data.customActiveColor, data.customTextColor, data.customTextHighlightColor, data.customFont, data.customFontSize, data.disableHighlight, data.disableMouseHighlight, data.disableMouseDown, data.disableMouseUp

			--------------------------------

			frame.IsActive = false
			frame.IsHighlight = false

			frame._DefaultTexture = nil
			frame._HighlightTexture = nil
			frame._TextColor = nil
			frame._TextHighlightColor = nil
			frame._Color = nil
			frame._HighlightColor = nil
			frame._ActiveColor = nil
			frame._Font = AdaptiveAPI.Fonts.Content_Light or GameFontNormal:GetFont()
			frame._FontSize = 12.5

			frame._CustomDefaultTexture = defaultTexture
			frame._CustomHighlightTexture = highlightTexture
			frame._CustomColor = customColor
			frame._CustomHighlightColor = customHighlightColor
			frame._CustomTextColor = customTextColor
			frame._CustomTextHighlightColor = customTextHighlightColor
			frame._CustomActiveColor = customActiveColor
			frame._CustomFont = customFont
			frame._CustomFontSize = customFontSize

			frame.EnterCallbacks = {}
			frame.LeaveCallbacks = {}
			frame.MouseDownCallbacks = {}
			frame.MouseUpCallbacks = {}

			--------------------------------

			do -- THEME
				local function UpdateTheme()
					frame._Font = frame._CustomFont or frame._Font
					frame._FontSize = frame._CustomFontSize or frame._FontSize

					if (theme and theme == 2) or (not theme and AdaptiveAPI.IsDarkTheme) then
						frame._DefaultTexture = frame._CustomDefaultTexture or AdaptiveAPI.Presets.NINESLICE_INSCRIBED_BORDER
						frame._HighlightTexture = frame._CustomHighlightTexture or AdaptiveAPI.Presets.NINESLICE_INSCRIBED
						frame._TextColor = frame._CustomTextColor or { r = 1, g = 1, b = 1, a = 1 }
						frame._TextHighlightColor = frame._CustomTextHighlightColor or { r = 1, g = 1, b = 1, a = 1 }
						frame._Color = frame._CustomColor or { r = .5, g = .5, b = .5, a = .5 }
						frame._HighlightColor = frame._CustomHighlightColor or { r = .5, g = .5, b = .5, a = .5 }
						frame._ActiveColor = frame._CustomActiveColor or { r = .5, g = .5, b = .5, a = .5 }
					elseif (theme and theme == 1) or (not theme and not AdaptiveAPI.IsDarkTheme) then
						frame._DefaultTexture = frame._CustomDefaultTexture or AdaptiveAPI.Presets.NINESLICE_INSCRIBED_BORDER
						frame._HighlightTexture = frame._CustomHighlightTexture or AdaptiveAPI.Presets.NINESLICE_INSCRIBED
						frame._TextColor = frame._CustomTextColor or { r = .1, g = .1, b = .1, a = 1 }
						frame._TextHighlightColor = frame._CustomTextHighlightColor or { r = 1, g = 1, b = 1, a = 1 }
						frame._Color = frame._CustomColor or { r = 0, g = 0, b = 0, a = .5 }
						frame._HighlightColor = frame._CustomHighlightColor or { r = 0, g = 0, b = 0, a = .5 }
						frame._ActiveColor = frame._CustomActiveColor or { r = 0, g = 0, b = 0, a = .5 }
					end
				end

				AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(UpdateTheme, 4)
			end

			do -- ELEMENTS
				do -- TEXT
					frame.AdaptiveAPI_Text = frame.Text
					if _G[frame:GetDebugName() .. "Text"] then
						frame.AdaptiveAPI_Text = _G[frame:GetDebugName() .. "Text"]
					end

					--------------------------------

					frame.AdaptiveAPI_Text:SetFont(frame._Font, frame._FontSize, "")
					frame.AdaptiveAPI_Text:SetTextColor(frame._TextColor.r, frame._TextColor.g, frame._TextColor.b, frame._TextColor.a or 1)
					frame.AdaptiveAPI_Text:SetShadowOffset(0, 0)
				end

				do -- BACKGROUND
					local padding = texturePadding or 0

					--------------------------------

					frame.AdaptiveAPI_Background, frame.AdaptiveAPI_BackgroundTexture = AdaptiveAPI.FrameTemplates:CreateNineSlice(frame, "LOW", nil, edgeSize or 25, scale or .5)
					frame.AdaptiveAPI_Background:SetPoint("TOPLEFT", frame, -padding, padding)
					frame.AdaptiveAPI_Background:SetPoint("BOTTOMRIGHT", frame, padding, -padding)
					frame.AdaptiveAPI_Background:SetFrameStrata(frame:GetFrameStrata())
					frame.AdaptiveAPI_Background:SetFrameLevel(frame:GetFrameLevel())

					--------------------------------

					AdaptiveAPI:RegisterThemeUpdateWithNativeAPI(function()
						frame.AdaptiveAPI_BackgroundTexture:SetTexture(frame._DefaultTexture)
					end, 5)

					--------------------------------

					if playAnimation or playAnimation == nil then
						frame.AdaptiveAPI_BackgroundTexture:SetVertexColor(frame._Color.r, frame._Color.g, frame._Color.b, frame._HighlightColor.a or .75)
					else
						frame.AdaptiveAPI_BackgroundTexture:SetVertexColor(frame._Color.r, frame._Color.g, frame._Color.b, frame._HighlightColor.a or .75)
					end

					--------------------------------

					hooksecurefunc(frame, "SetWidth", function()
						frame.AdaptiveAPI_Background:SetWidth(frame:GetWidth())
					end)

					hooksecurefunc(frame, "SetHeight", function()
						frame.AdaptiveAPI_Background:SetHeight(frame:GetHeight())
					end)

					hooksecurefunc(frame, "SetSize", function()
						frame.AdaptiveAPI_Background:SetSize(frame:GetWidth(), frame:GetHeight())
					end)
				end
			end

			--------------------------------

			do -- CLICK EVENTS
				local disableHighlight = disableHighlight or false

				frame.Enter = function()
					if frame.IsEnabled and frame:IsEnabled() and not disableHighlight then
						frame.IsHighlight = true

						--------------------------------

						if frame._HighlightColor.a and frame._HighlightColor.a < .5 then
							frame.AdaptiveAPI_Text:SetTextColor(frame._TextColor.r, frame._TextColor.g, frame._TextColor.b, frame._TextColor.a or 1)
						else
							frame.AdaptiveAPI_Text:SetTextColor(frame._TextHighlightColor.r, frame._TextHighlightColor.g, frame._TextHighlightColor.b, frame._TextHighlightColor.a or 1)
						end

						--------------------------------

						frame.AdaptiveAPI_BackgroundTexture:SetTexture(frame._HighlightTexture)
						frame.AdaptiveAPI_BackgroundTexture:SetVertexColor(frame._HighlightColor.r, frame._HighlightColor.g, frame._HighlightColor.b, frame._HighlightColor.a or .5)

						--------------------------------

						if playAnimation or playAnimation == nil then
							AdaptiveAPI.Animation:PreciseMove(frame.AdaptiveAPI_Text, 1, frame, "CENTER", 0, 0, 0, 2.5)
							AdaptiveAPI.Animation:PreciseMove(frame.AdaptiveAPI_Background, 1, frame, "CENTER", 0, 0, 0, 2.5)
						end

						--------------------------------

						local enterCallbacks = frame.EnterCallbacks

						for callback = 1, #enterCallbacks do
							enterCallbacks[callback]()
						end
					end

					--------------------------------

					frame.UpdateActive()
				end

				frame.Leave = function()
					frame.IsHighlight = false

					--------------------------------

					frame.AdaptiveAPI_Text:SetTextColor(frame._TextColor.r, frame._TextColor.g, frame._TextColor.b, frame._TextColor.a or 1)

					--------------------------------

					frame.AdaptiveAPI_BackgroundTexture:SetTexture(frame._DefaultTexture)
					frame.AdaptiveAPI_BackgroundTexture:SetVertexColor(frame._Color.r, frame._Color.g, frame._Color.b, frame._HighlightColor.a or .75)

					--------------------------------

					if frame.IsEnabled and frame:IsEnabled() and not disableHighlight then
						if playAnimation or playAnimation == nil then
							AdaptiveAPI.Animation:PreciseMove(frame.AdaptiveAPI_Text, 1, frame, "CENTER", 0, 2.5, 0, 0)
							AdaptiveAPI.Animation:PreciseMove(frame.AdaptiveAPI_Background, 1, frame, "CENTER", 0, 2.5, 0, 0)
						end

						--------------------------------

						local leaveCallbacks = frame.LeaveCallbacks

						for callback = 1, #leaveCallbacks do
							leaveCallbacks[callback]()
						end
					end

					--------------------------------

					frame.UpdateActive()
				end

				frame.MouseDown = function()
					if frame.IsEnabled and frame:IsEnabled() and not disableMouseDown then
						if playAnimation or playAnimation == nil then
							frame.AdaptiveAPI_BackgroundTexture:SetVertexColor(frame._Color.r, frame._Color.g, frame._Color.b, .25)
						else
							frame.AdaptiveAPI_BackgroundTexture:SetVertexColor(frame._Color.r, frame._Color.g, frame._Color.b, .25)
						end

						--------------------------------

						local mouseDownCallbacks = frame.MouseDownCallbacks

						for callback = 1, #mouseDownCallbacks do
							mouseDownCallbacks[callback]()
						end
					end
				end

				frame.MouseUp = function()
					if frame.IsEnabled and frame:IsEnabled() and not disableMouseUp then
						if playAnimation or playAnimation == nil then
							frame.AdaptiveAPI_BackgroundTexture:SetVertexColor(frame._Color.r, frame._Color.g, frame._Color.b, .5)
						else
							frame.AdaptiveAPI_BackgroundTexture:SetVertexColor(frame._Color.r, frame._Color.g, frame._Color.b, .5)
						end

						--------------------------------

						local mouseUpCallbacks = frame.MouseUpCallbacks

						for callback = 1, #mouseUpCallbacks do
							mouseUpCallbacks[callback]()
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
						if frame._HighlightColor.a and frame._HighlightColor.a < .5 then
							if (theme and theme == 2) or (not theme and AdaptiveAPI.IsDarkTheme) then
								frame.AdaptiveAPI_Text:SetTextColor(frame._TextHighlightColor.r, frame._TextHighlightColor.g, frame._TextHighlightColor.b, frame._TextHighlightColor.a or 1)
							else
								frame.AdaptiveAPI_Text:SetTextColor(frame._TextColor.r, frame._TextColor.g, frame._TextColor.b, frame._TextColor.a or 1)
							end
						else
							frame.AdaptiveAPI_Text:SetTextColor(frame._TextHighlightColor.r, frame._TextHighlightColor.g, frame._TextHighlightColor.b, frame._TextHighlightColor.a or 1)
						end

						frame.AdaptiveAPI_BackgroundTexture:SetTexture(frame._HighlightTexture)
						frame.AdaptiveAPI_BackgroundTexture:SetVertexColor(frame._ActiveColor.r, frame._ActiveColor.g, frame._ActiveColor.b, frame._ActiveColor.a or .5)
					else
						if not frame.IsHighlight then
							frame.AdaptiveAPI_Text:SetTextColor(frame._TextColor.r, frame._TextColor.g, frame._TextColor.b, frame._TextColor.a or 1)
							frame.AdaptiveAPI_BackgroundTexture:SetTexture(frame._DefaultTexture)
							frame.AdaptiveAPI_BackgroundTexture:SetVertexColor(frame._Color.r, frame._Color.g, frame._Color.b, frame._Color.a or .75)
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

			do -- EVENTS
				local Events = CreateFrame("Frame", "$parent.Events", frame)
				Events:RegisterEvent("GAME_PAD_ACTIVE_CHANGED")
				Events:SetScript("OnEvent", function(self, event, ...)
					if event == "GAME_PAD_ACTIVE_CHANGED" then
						frame.Leave()
					end
				end)
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

			if customDefaultTexture then frame._CustomDefaultTexture = customDefaultTexture end
			if customHighlightTexture then frame._CustomHighlightTexture = customHighlightTexture end
			if customColor then frame._CustomColor = customColor end
			if customHighlightColor then frame._CustomHighlightColor = customHighlightColor end
			if customActiveColor then frame._CustomActiveColor = customActiveColor end
			if customTextColor then frame._CustomTextColor = customTextColor end
			if customTextHighlightColor then frame._CustomTextHighlightColor = customTextHighlightColor end
		end
	end
end
