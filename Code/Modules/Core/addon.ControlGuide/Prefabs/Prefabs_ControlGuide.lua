---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.ControlGuide; addon.ControlGuide = NS

--------------------------------

NS.Prefabs = {}

--------------------------------
-- PREFABS
--------------------------------

function NS.Prefabs:Load()
	do -- ELEMENT
		PrefabRegistry:Add("ControlGuide.Element", function(parent, frameStrata, frameLevel, name)
			local Frame = CreateFrame("Frame", name, parent)
			Frame:SetHeight(35)
			Frame:SetFrameStrata(frameStrata)
			Frame:SetFrameLevel(frameLevel)

			--------------------------------

			local PADDING_FRAME_WIDTH = 62.5

			do -- ELEMENTS
				Frame.Content = CreateFrame("Frame", "$parent.Content", Frame)
				Frame.Content:SetPoint("LEFT", Frame)
				Frame.Content:SetFrameStrata(frameStrata)
				Frame.Content:SetFrameLevel(frameLevel + 1)
				addon.API.FrameUtil:SetDynamicSize(Frame.Content, Frame, 0, 0)

				local Content = Frame.Content

				--------------------------------

				do -- CONTENT
					do -- TEXT
						Content.Text = addon.API.FrameTemplates:CreateText(Content, addon.Theme.RGB_WHITE, 12.5, "LEFT", "MIDDLE", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
						Content.Text:SetPoint("CENTER", Content)
						Content.Text:SetAlpha(.75)
						addon.API.FrameUtil:SetDynamicTextSize(Content.Text, Content, 10000, 10000)
						addon.API.FrameUtil:SetDynamicSize(Content.Text, Content, nil, 0)
					end

					do -- LAYOUT
						addon.API.Main:SetButtonToPlatform(Content, Content.Text, "")
						addon.API.FrameUtil:SetDynamicSize(Frame, Content.Text, -PADDING_FRAME_WIDTH, nil)
					end
				end
			end

			do -- ANIMATIONS
				do -- SHOW
					function Frame:ShowWithAnimation_StopEvent()
						return not Frame:IsVisible()
					end

					function Frame:ShowWithAnimation(skipAnimation)
						Frame:Show()

						--------------------------------

						if skipAnimation then
							Frame.Content:SetAlpha(1)
							Frame.Content:SetPoint("CENTER", Frame, 0, 0)
						else
							addon.API.Animation:Fade(Frame.Content, .25, 0, 1, nil, Frame.ShowWithAnimation_StopEvent)
							addon.API.Animation:Move(Frame.Content, .5, "LEFT", -12.5, 0, "y", addon.API.Animation.EaseExpo, Frame.ShowWithAnimation_StopEvent)
						end
					end
				end
			end

			do -- LOGIC
				do -- FUNCTIONS
					do -- SET
						function Frame:SetInfo(text, keybindVariable)
							Frame.Content.Text:SetText(text)

							--------------------------------

							addon.API.Main:SetButtonToPlatform(Frame.Content, Frame.Content.Text, keybindVariable)
						end
					end

					do -- GET
						function Frame:GetText()
							return Frame.Content.Text:GetText()
						end
					end
				end

				do -- EVENTS

				end
			end

			do -- SETUP

			end

			--------------------------------

			return Frame
		end)
	end
end
