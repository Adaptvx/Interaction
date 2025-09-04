---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.Readable; addon.Readable = NS

--------------------------------

NS.ItemUI.Elements = {}

--------------------------------

function NS.ItemUI.Elements:Load()
	--------------------------------
	-- CREATE ELEMENTS
	--------------------------------

	do
		do -- ELEMENTS
			InteractionReadableUIFrame.ReadableUIFrame = CreateFrame("Frame", "$parent.ReadableUIFrame", NS.Variables.Frame)
			InteractionReadableUIFrame.ReadableUIFrame:SetSize(NS.Variables.Frame:GetWidth(), NS.Variables.Frame:GetHeight())
			InteractionReadableUIFrame.ReadableUIFrame:SetPoint("CENTER", NS.Variables.Frame)
			InteractionReadableUIFrame.ReadableUIFrame:SetFrameStrata("FULLSCREEN")
			InteractionReadableUIFrame.ReadableUIFrame:SetFrameLevel(3)

			--------------------------------

			NS.Variables.ReadableUIFrame = InteractionReadableUIFrame.ReadableUIFrame
			local ReadableUIFrame = InteractionReadableUIFrame.ReadableUIFrame

			--------------------------------

			local TEXT_SIZE_ITEM = addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE * 1
			local TEXT_SIZE_BOOK = addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE * .75

			do -- TOOLTIP FRAME
				ReadableUIFrame.TooltipFrame = CreateFrame("Frame", "$parent.TooltipFrame", ReadableUIFrame)
				ReadableUIFrame.TooltipFrame:SetPoint("TOPLEFT", ReadableUIFrame, 100, -100)
				ReadableUIFrame.TooltipFrame:SetPoint("BOTTOMRIGHT", ReadableUIFrame, -100, 100)
				ReadableUIFrame.TooltipFrame:SetFrameStrata("FULLSCREEN")
				ReadableUIFrame.TooltipFrame:SetFrameLevel(5)
			end

			do -- TITLE
				ReadableUIFrame.Title = CreateFrame("Frame", "$parent.Title", ReadableUIFrame)
				ReadableUIFrame.Title:SetSize(500, 50)
				ReadableUIFrame.Title:SetPoint("TOP", ReadableUIFrame, 0, -NS.Variables.SCREEN_HEIGHT * .125)
				ReadableUIFrame.Title:SetFrameStrata("FULLSCREEN")
				ReadableUIFrame.Title:SetFrameLevel(1)
				ReadableUIFrame.Title:SetAlpha(.5)

				--------------------------------

				do -- TEXT
					ReadableUIFrame.Title.Text = addon.API.FrameTemplates:CreateText(ReadableUIFrame.Title, addon.Theme.RGB_WHITE, 22.5, "CENTER", "TOP", addon.API.Fonts.TITLE_BOLD, "$parent.Text")
					ReadableUIFrame.Title.Text:SetSize(ReadableUIFrame.Title:GetWidth(), 25)
					ReadableUIFrame.Title.Text:SetPoint("TOP", ReadableUIFrame.Title, 0, 0)
				end

				do -- DIVIDER
					ReadableUIFrame.Title.Divider, ReadableUIFrame.Title.DividerTexture = addon.API.FrameTemplates:CreateTexture(ReadableUIFrame.Title, "FULLSCREEN_DIALOG", NS.Variables.READABLE_UI_PATH .. "Elements/divider.png", "$parent.Divider")
					ReadableUIFrame.Title.Divider:SetSize(375, 1.5)
					ReadableUIFrame.Title.Divider:SetPoint("TOP", ReadableUIFrame.Title, 0, -(37.5 - ReadableUIFrame.Title.Divider:GetHeight()))
					ReadableUIFrame.Title.Divider:SetFrameStrata("FULLSCREEN")
					ReadableUIFrame.Title.Divider:SetFrameLevel(1)
				end

				do -- CURRENT PAGE TEXT
					ReadableUIFrame.Title.CurrentPageText = addon.API.FrameTemplates:CreateText(ReadableUIFrame.Title, addon.Theme.RGB_WHITE, 15, "CENTER", "MIDDLE", addon.API.Fonts.TITLE_MEDIUM, "$parent.CurrentPageText")
					ReadableUIFrame.Title.CurrentPageText:SetSize(ReadableUIFrame.Title:GetWidth(), 25)
					ReadableUIFrame.Title.CurrentPageText:SetPoint("TOP", ReadableUIFrame.Title, 0, -25)
				end
			end

			do -- NAVIGATION
				ReadableUIFrame.NavigationFrame = CreateFrame("Frame", "$parent.NavigationFrame", ReadableUIFrame)
				ReadableUIFrame.NavigationFrame:SetSize(ReadableUIFrame:GetWidth() / 2, 35)
				ReadableUIFrame.NavigationFrame:SetPoint("BOTTOM", ReadableUIFrame, 0, NS.Variables.SCREEN_HEIGHT * .15)
				ReadableUIFrame.NavigationFrame:SetAlpha(1)
				ReadableUIFrame.NavigationFrame:SetFrameStrata("FULLSCREEN")
				ReadableUIFrame.NavigationFrame:SetFrameLevel(50)

				--------------------------------

				do -- BUTTONS
					local function CreateButton(width, height, offset, defaultTexture, highlightTexture, triggerCallback)
						local Frame = CreateFrame("Frame", nil, ReadableUIFrame.NavigationFrame)
						Frame:SetSize(width, height)

						--------------------------------

						do -- ELEMENTS
							Frame.Image, Frame.ImageTexture = addon.API.FrameTemplates:CreateTexture(Frame, "FULLSCREEN", defaultTexture, "$parent.Image")
							Frame.Image:SetSize(Frame:GetSize())
							Frame.Image:SetPoint("CENTER", Frame)
						end

						do -- ANIMATIONS
							do -- ON ENTER
								function Frame:Animation_OnEnter_StopEvent()
									return not Frame.isMouseOver
								end

								function Frame:Animation_OnEnter(skipAnimation)
									Frame.ImageTexture:SetTexture(highlightTexture)

									addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), .75)
									addon.API.Animation:Move(Frame.Image, .25, "CENTER", 0, offset, "x", addon.API.Animation.EaseExpo, Frame.Animation_OnEnter_StopEvent)
								end
							end

							do -- ON LEAVE
								function Frame:Animation_OnLeave_StopEvent()
									return Frame.isMouseOver
								end

								function Frame:Animation_OnLeave(skipAnimation)
									Frame.ImageTexture:SetTexture(defaultTexture)

									addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), 1)
									addon.API.Animation:Move(Frame.Image, .25, "CENTER", offset, 0, "x", addon.API.Animation.EaseExpo, Frame.Animation_OnLeave_StopEvent)
								end
							end

							do -- ON MOUSE DOWN
								function Frame:Animation_OnMouseDown_StopEvent()
									return not Frame.isMouseDown
								end

								function Frame:Animation_OnMouseDown(skipAnimation)
									Frame.ImageTexture:SetTexture(highlightTexture)

									addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), .5, nil, Frame.Animation_OnMouseDown_StopEvent)
								end
							end

							do -- ON MOUSE UP
								function Frame:Animation_OnMouseUp_StopEvent()
									return Frame.isMouseDown
								end

								function Frame:Animation_OnMouseUp(skipAnimation)
									Frame.ImageTexture:SetTexture(highlightTexture)

									addon.API.Animation:Fade(Frame, .125, Frame:GetAlpha(), .75, nil, Frame.Animation_OnMouseUp_StopEvent)
								end
							end
						end

						do -- LOGIC
							Frame.isMouseOver = false
							Frame.isMouseDown = false

							Frame.enterCallbacks = {}
							Frame.leaveCallbacks = {}
							Frame.mouseDownCallbacks = {}
							Frame.mouseUpCallbacks = {}
							Frame.clickCallbacks = {}

							--------------------------------

							do -- FUNCTIONS

							end

							do -- EVENTS
								local function Logic_OnEnter()

								end

								local function Logic_OnLeave()

								end

								local function Logic_OnMouseDown()

								end

								local function Logic_OnMouseUp()
									triggerCallback()
								end

								function Frame:OnEnter(skipAnimation)
									Frame.isMouseOver = true

									--------------------------------

									Frame:Animation_OnEnter(skipAnimation)
									Logic_OnEnter()

									--------------------------------

									do -- ON ENTER
										if #Frame.enterCallbacks >= 1 then
											local enterCallbacks = Frame.enterCallbacks

											for callback = 1, #enterCallbacks do
												enterCallbacks[callback](skipAnimation)
											end
										end
									end
								end

								function Frame:OnLeave(skipAnimation)
									Frame.isMouseOver = false

									--------------------------------

									Frame:Animation_OnLeave(skipAnimation)
									Logic_OnLeave()

									--------------------------------

									do -- ON LEAVE
										if #Frame.leaveCallbacks >= 1 then
											local leaveCallbacks = Frame.leaveCallbacks

											for callback = 1, #leaveCallbacks do
												leaveCallbacks[callback](skipAnimation)
											end
										end
									end
								end

								function Frame:OnMouseDown(button, skipAnimation)
									Frame.isMouseDown = true

									--------------------------------

									Frame:Animation_OnMouseDown(skipAnimation)
									Logic_OnMouseDown()

									--------------------------------

									do -- ON MOUSE DOWN
										if #Frame.mouseDownCallbacks >= 1 then
											local mouseDownCallbacks = Frame.mouseDownCallbacks

											for callback = 1, #mouseDownCallbacks do
												mouseDownCallbacks[callback](skipAnimation)
											end
										end
									end
								end

								function Frame:OnMouseUp(button, skipAnimation)
									Frame.isMouseDown = false

									--------------------------------

									Frame:Animation_OnMouseUp(skipAnimation)
									Logic_OnMouseUp()

									--------------------------------

									do -- ON MOUSE UP
										if #Frame.mouseUpCallbacks >= 1 then
											local mouseUpCallbacks = Frame.mouseUpCallbacks

											for callback = 1, #mouseUpCallbacks do
												mouseUpCallbacks[callback](skipAnimation)
											end
										end
									end

									do -- ON CLICK
										if #Frame.clickCallbacks >= 1 then
											local clickCallbacks = Frame.clickCallbacks

											for callback = 1, #clickCallbacks do
												clickCallbacks[callback](skipAnimation)
											end
										end
									end
								end

								addon.API.FrameTemplates:CreateMouseResponder(Frame, { enterCallback = Frame.OnEnter, leaveCallback = Frame.OnLeave, mouseDownCallback = Frame.OnMouseDown, mouseUpCallback = Frame.OnMouseUp })
							end
						end

						do -- SETUP
							Frame:OnLeave(true)
						end

						--------------------------------

						return Frame
					end

					--------------------------------

					do -- PREVIOUS PAGE
						ReadableUIFrame.NavigationFrame.PreviousPage = CreateButton(150 * .14, 150, -1, NS.Variables.READABLE_UI_PATH .. "Elements/button-back.png", NS.Variables.READABLE_UI_PATH .. "Elements/button-back.png", function() InteractionReadableUIFrame:Back() end)
						ReadableUIFrame.NavigationFrame.PreviousPage:SetPoint("LEFT", ReadableUIFrame, 55, 0)
					end

					do -- NEXT PAGE
						ReadableUIFrame.NavigationFrame.NextPage = CreateButton(150 * .14, 150, 1, NS.Variables.READABLE_UI_PATH .. "Elements/button-next.png", NS.Variables.READABLE_UI_PATH .. "Elements/button-next.png", function() InteractionReadableUIFrame.Next() end)
						ReadableUIFrame.NavigationFrame.NextPage:SetPoint("RIGHT", ReadableUIFrame, -55, 0)
					end
				end
			end

			do -- ITEM UI
				ReadableUIFrame.ItemParent = CreateFrame("Frame", "$parent.ItemParent", ReadableUIFrame)
				ReadableUIFrame.ItemParent:SetSize(NS.Variables.SCREEN_HEIGHT * .35, NS.Variables.SCREEN_HEIGHT * .45)
				ReadableUIFrame.ItemParent:SetPoint("CENTER", ReadableUIFrame, 0, NS.Variables.SCREEN_HEIGHT * .025)
				ReadableUIFrame.ItemParent:SetFrameStrata("FULLSCREEN")
				ReadableUIFrame.ItemParent:SetFrameLevel(6)

				ReadableUIFrame.ItemFrame = CreateFrame("Frame", "$parent.ItemFrame", ReadableUIFrame.ItemParent)
				ReadableUIFrame.ItemFrame:SetSize(ReadableUIFrame.ItemParent:GetWidth(), ReadableUIFrame.ItemParent:GetHeight())
				ReadableUIFrame.ItemFrame:SetPoint("CENTER", ReadableUIFrame.ItemParent)
				ReadableUIFrame.ItemFrame:SetFrameStrata("FULLSCREEN")
				ReadableUIFrame.ItemFrame:SetFrameLevel(6)

				--------------------------------

				addon.API.Animation:AddParallax(ReadableUIFrame.ItemFrame, ReadableUIFrame.ItemParent, function() return not InteractionReadableUIFrame.cooldown and not InteractionReadableUIFrame.pageUpdateTransition and InteractionReadableUIFrame:GetAlpha() >= .99 end, nil, addon.Input.Variables.IsController)

				CallbackRegistry:Add("READABLE_ITEMUI_UPDATE", function()
					local Weight = 1

					if NS.ItemUI.Variables.Type == "Parchment" or NS.ItemUI.Variables.Type == "ParchmentLarge" or NS.ItemUI.Variables.Type == "Valentine" or NS.ItemUI.Variables.Type == nil then
						Weight = .5
					end

					if NS.ItemUI.Variables.Type == "Stone" or NS.ItemUI.Variables.Type == "Bronze" or NS.ItemUI.Variables.Type == "Silver" or NS.ItemUI.Variables.Type == "Marble" or NS.ItemUI.Variables.Type == "Progenitor" then
						Weight = 5
					end

					ReadableUIFrame.ItemFrame.API_Animation_Parallax_Weight = Weight
				end)

				--------------------------------

				do -- BACKGROUND
					ReadableUIFrame.ItemFrame.Background, ReadableUIFrame.ItemFrame.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(ReadableUIFrame.ItemFrame, "FULLSCREEN", nil, "$parent.Background")
					ReadableUIFrame.ItemFrame.Background:SetSize(ReadableUIFrame.ItemFrame:GetHeight() + 275, ReadableUIFrame.ItemFrame:GetHeight() + 225)
					ReadableUIFrame.ItemFrame.Background:SetPoint("CENTER", ReadableUIFrame.ItemFrame)
					ReadableUIFrame.ItemFrame.Background:SetFrameStrata("FULLSCREEN")
					ReadableUIFrame.ItemFrame.Background:SetFrameLevel(4)
				end

				do -- TEXT
					ReadableUIFrame.ItemFrame.ScrollFrame, ReadableUIFrame.ItemFrame.ScrollChild = addon.API.FrameTemplates:CreateScrollFrame(ReadableUIFrame.ItemFrame, { direction = "vertical", smoothScrollingRatio = 5 }, "$parent.ScrollFrame", "$parent.ScrollChildFrame")
					ReadableUIFrame.ItemFrame.ScrollFrame:SetSize(ReadableUIFrame.ItemFrame:GetWidth(), ReadableUIFrame.ItemFrame:GetHeight())
					ReadableUIFrame.ItemFrame.ScrollFrame:SetPoint("CENTER", ReadableUIFrame.ItemFrame)
					ReadableUIFrame.ItemFrame.ScrollFrame:SetFrameStrata("FULLSCREEN")
					ReadableUIFrame.ItemFrame.ScrollFrame:SetFrameLevel(7)
					ReadableUIFrame.ItemFrame.ScrollFrame.ScrollBar:Hide()

					--------------------------------

					function ReadableUIFrame.ItemFrame.ScrollFrame:UpdateScrollIndicator()
						local VerticalScroll = ReadableUIFrame.ItemFrame.ScrollFrame:GetVerticalScroll()
						local ScrollRange = ReadableUIFrame.ItemFrame.ScrollFrame:GetVerticalScrollRange()

						if VerticalScroll < ScrollRange then
							ReadableUIFrame.ItemFrame.ScrollFrame.Gradient:Show()
						else
							ReadableUIFrame.ItemFrame.ScrollFrame.Gradient:Hide()
						end
					end

					ReadableUIFrame.ItemFrame.ScrollFrame.MouseWheel = function()
						ReadableUIFrame.ItemFrame.ScrollFrame:UpdateScrollIndicator()
					end
					ReadableUIFrame.ItemFrame.ScrollFrame:HookScript("OnMouseWheel", function()
						ReadableUIFrame.ItemFrame.ScrollFrame.MouseWheel()
					end)

					--------------------------------

					do -- TEXT
						do -- MEASUREMENT
							ReadableUIFrame.ItemFrame.ScrollFrame.MeasurementText = addon.API.FrameTemplates:CreateText(ReadableUIFrame.ItemFrame.ScrollFrame, addon.Theme.RGB_BLACK, TEXT_SIZE_ITEM, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.MeasurementText", true)
							ReadableUIFrame.ItemFrame.ScrollFrame.MeasurementText:SetWidth(ReadableUIFrame.ItemFrame.ScrollFrame:GetWidth())
							ReadableUIFrame.ItemFrame.ScrollFrame.MeasurementText:SetAlpha(0)
						end

						do -- TEXT
							ReadableUIFrame.ItemFrame.ScrollFrame.Text = addon.API.FrameTemplates:CreateText(ReadableUIFrame.ItemFrame.ScrollChild, addon.Theme.RGB_BLACK, addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text")
							ReadableUIFrame.ItemFrame.ScrollFrame.Text:SetSize(ReadableUIFrame.ItemFrame.ScrollChild:GetWidth(), 5000)
							ReadableUIFrame.ItemFrame.ScrollFrame.Text:SetPoint("TOP", ReadableUIFrame.ItemFrame.ScrollChild)
						end

						--------------------------------

						hooksecurefunc(ReadableUIFrame.ItemFrame.ScrollFrame.Text, "SetText", function()
							addon.Libraries.AceTimer:ScheduleTimer(function()
								local StringHeight

								--------------------------------

								ReadableUIFrame.ItemFrame.ScrollFrame:SetVerticalScroll(0)

								--------------------------------

								ReadableUIFrame.ItemFrame.ScrollFrame.MeasurementText:SetText(ReadableUIFrame.ItemFrame.ScrollFrame.Text:GetText())
								StringHeight = ReadableUIFrame.ItemFrame.ScrollFrame.MeasurementText:GetStringHeight()

								--------------------------------

								ReadableUIFrame.ItemFrame.ScrollChild:SetHeight(StringHeight + 50)
								ReadableUIFrame.ItemFrame.ScrollFrame.Text:SetHeight(StringHeight + 50)

								--------------------------------

								addon.Libraries.AceTimer:ScheduleTimer(function()
									ReadableUIFrame.ItemFrame.ScrollFrame:UpdateScrollIndicator()
								end, .25)
							end, .1)
						end)
					end

					do -- GRADIENT
						ReadableUIFrame.ItemFrame.ScrollFrame.Gradient, ReadableUIFrame.ItemFrame.ScrollFrame.GradientTexture = addon.API.FrameTemplates:CreateTexture(ReadableUIFrame.ItemFrame.ScrollFrame, "FULLSCREEN", nil, "$parent.Gradient")
						ReadableUIFrame.ItemFrame.ScrollFrame.Gradient:SetSize(ReadableUIFrame.ItemFrame.ScrollFrame:GetWidth(), 50)
						ReadableUIFrame.ItemFrame.ScrollFrame.Gradient:SetPoint("BOTTOM", ReadableUIFrame.ItemFrame.ScrollFrame, 0, -1)
						ReadableUIFrame.ItemFrame.ScrollFrame.Gradient:SetFrameStrata("FULLSCREEN")
						ReadableUIFrame.ItemFrame.ScrollFrame.Gradient:SetFrameLevel(49)
					end
				end
			end

			do -- BOOK UI
				ReadableUIFrame.BookParent = CreateFrame("Frame", "$parent.BookParent", ReadableUIFrame)
				ReadableUIFrame.BookParent:SetSize(NS.Variables.SCREEN_HEIGHT * .28, NS.Variables.SCREEN_HEIGHT * .375)
				ReadableUIFrame.BookParent:SetPoint("CENTER", ReadableUIFrame, 0, 0)
				ReadableUIFrame.BookParent:SetFrameStrata("FULLSCREEN")
				ReadableUIFrame.BookParent:SetFrameLevel(4)

				ReadableUIFrame.BookFrame = CreateFrame("Frame", "$parent.BookFrame", ReadableUIFrame)
				ReadableUIFrame.BookFrame:SetSize(ReadableUIFrame.BookParent:GetWidth(), ReadableUIFrame.BookParent:GetHeight())
				ReadableUIFrame.BookFrame:SetPoint("CENTER", ReadableUIFrame.BookParent)
				ReadableUIFrame.BookFrame:SetFrameStrata("FULLSCREEN")
				ReadableUIFrame.BookFrame:SetFrameLevel(4)

				--------------------------------

				do -- FRONT PAGE
					ReadableUIFrame.BookFrame.FrontPageParent = CreateFrame("Frame", "$parent.FrontPageParent", ReadableUIFrame.BookFrame)
					ReadableUIFrame.BookFrame.FrontPageParent:SetSize(ReadableUIFrame.BookFrame:GetHeight(), ReadableUIFrame.BookFrame:GetHeight())
					ReadableUIFrame.BookFrame.FrontPageParent:SetPoint("CENTER", ReadableUIFrame.BookFrame, 0, 0)
					ReadableUIFrame.BookFrame.FrontPageParent:SetFrameStrata("FULLSCREEN")
					ReadableUIFrame.BookFrame.FrontPageParent:SetFrameLevel(4)

					ReadableUIFrame.BookFrame.FrontPage = CreateFrame("Frame", "$parent.FrontPage", ReadableUIFrame.BookFrame.FrontPageParent)
					ReadableUIFrame.BookFrame.FrontPage:SetSize(ReadableUIFrame.BookFrame.FrontPageParent:GetHeight(), ReadableUIFrame.BookFrame.FrontPageParent:GetHeight())
					ReadableUIFrame.BookFrame.FrontPage:SetPoint("CENTER", ReadableUIFrame.BookFrame.FrontPageParent, 0, 0)
					ReadableUIFrame.BookFrame.FrontPage:SetFrameStrata("FULLSCREEN")
					ReadableUIFrame.BookFrame.FrontPage:SetFrameLevel(4)

					--------------------------------

					addon.API.Animation:AddParallax(ReadableUIFrame.BookFrame.FrontPage, ReadableUIFrame.BookFrame.FrontPageParent, function() return not InteractionReadableUIFrame.cooldown and not InteractionReadableUIFrame.pageUpdateTransition and InteractionReadableUIFrame:GetAlpha() >= .99 end, nil, addon.Input.Variables.IsController)

					CallbackRegistry:Add("READABLE_ITEMUI_UPDATE", function()
						local Weight = 5

						if NS.ItemUI.Variables.Type == "Parchment" or NS.ItemUI.Variables.Type == "Valentine" or NS.ItemUI.Variables.Type == nil then
							Weight = 5
						elseif NS.ItemUI.Variables.Type == "ParchmentLarge" then
							Weight = 10
						end

						ReadableUIFrame.BookFrame.FrontPage.API_Animation_Parallax_Weight = Weight
					end)

					--------------------------------

					do -- BACKGROUND
						ReadableUIFrame.BookFrame.FrontPage.Background, ReadableUIFrame.BookFrame.FrontPage.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(ReadableUIFrame.BookFrame.FrontPage, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Book/book-cover.png", "$parent.Background")
						ReadableUIFrame.BookFrame.FrontPage.Background:SetSize(ReadableUIFrame.BookFrame.FrontPage:GetHeight(), ReadableUIFrame.BookFrame.FrontPage:GetHeight())
						ReadableUIFrame.BookFrame.FrontPage.Background:SetScale(2)
						ReadableUIFrame.BookFrame.FrontPage.Background:SetPoint("CENTER", ReadableUIFrame.BookFrame.FrontPage)
						ReadableUIFrame.BookFrame.FrontPage.Background:SetFrameStrata("FULLSCREEN")
						ReadableUIFrame.BookFrame.FrontPage.Background:SetFrameLevel(3)
					end

					do -- TEXT
						ReadableUIFrame.BookFrame.FrontPage.Text = CreateFrame("Frame", "$parent.Text", ReadableUIFrame.BookFrame.FrontPage)
						ReadableUIFrame.BookFrame.FrontPage.Text:SetFrameStrata("FULLSCREEN")
						ReadableUIFrame.BookFrame.FrontPage.Text:SetFrameLevel(4)

						--------------------------------

						do -- TITLE
							ReadableUIFrame.BookFrame.FrontPage.Text.Title = addon.API.FrameTemplates:CreateText(ReadableUIFrame.BookFrame.FrontPage.Text, addon.Theme.RGB_WHITE, 25, "CENTER", "MIDDLE", addon.API.Fonts.TITLE_BOLD, "$parent.Text")
							ReadableUIFrame.BookFrame.FrontPage.Text.Title:SetSize(ReadableUIFrame.BookFrame.FrontPage:GetWidth() * .7, 150)
							ReadableUIFrame.BookFrame.FrontPage.Text.Title:SetPoint("TOP", ReadableUIFrame.BookFrame.FrontPage, -NS.Variables.SCREEN_HEIGHT * .05)
						end
					end
				end

				do -- CONTENT
					ReadableUIFrame.BookFrame.ContentParent = CreateFrame("Frame", "$parent.ContentParent", ReadableUIFrame.BookFrame)
					ReadableUIFrame.BookFrame.ContentParent:SetSize(ReadableUIFrame.BookFrame:GetHeight() * 1.5, ReadableUIFrame.BookFrame:GetHeight())
					ReadableUIFrame.BookFrame.ContentParent:SetPoint("CENTER", ReadableUIFrame.BookFrame, 0, 0)
					ReadableUIFrame.BookFrame.ContentParent:SetFrameStrata("FULLSCREEN")
					ReadableUIFrame.BookFrame.ContentParent:SetFrameLevel(4)

					ReadableUIFrame.BookFrame.Content = CreateFrame("Frame", "$parent.Content", ReadableUIFrame.BookFrame.ContentParent)
					ReadableUIFrame.BookFrame.Content:SetSize(ReadableUIFrame.BookFrame.ContentParent:GetWidth(), ReadableUIFrame.BookFrame.ContentParent:GetHeight())
					ReadableUIFrame.BookFrame.Content:SetPoint("CENTER", ReadableUIFrame.BookFrame.ContentParent, 0, 0)
					ReadableUIFrame.BookFrame.Content:SetFrameStrata("FULLSCREEN")
					ReadableUIFrame.BookFrame.Content:SetFrameLevel(4)

					--------------------------------

					addon.API.Animation:AddParallax(ReadableUIFrame.BookFrame.Content, ReadableUIFrame.BookFrame.ContentParent, function() return not InteractionReadableUIFrame.cooldown and not InteractionReadableUIFrame.pageUpdateTransition and InteractionReadableUIFrame:GetAlpha() >= .99 end, nil, addon.Input.Variables.IsController)

					CallbackRegistry:Add("READABLE_ITEMUI_UPDATE", function()
						local Weight = 3.5

						if NS.ItemUI.Variables.Type == "Parchment" or NS.ItemUI.Variables.Type == "Valentine" or NS.ItemUI.Variables.Type == nil then
							Weight = 3.5
						elseif NS.ItemUI.Variables.Type == "ParchmentLarge" then
							Weight = 8
						end

						ReadableUIFrame.BookFrame.Content.API_Animation_Parallax_Weight = Weight
					end)

					--------------------------------

					do -- BACKGROUND
						do -- BACKGROUND
							ReadableUIFrame.BookFrame.Content.Background, ReadableUIFrame.BookFrame.Content.BackgroundTexture = addon.API.FrameTemplates:CreateTexture(ReadableUIFrame.BookFrame.Content, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Book/book.png", "$parent.Background")
							ReadableUIFrame.BookFrame.Content.Background:SetSize(ReadableUIFrame.BookFrame.Content:GetHeight(), ReadableUIFrame.BookFrame.Content:GetHeight())
							ReadableUIFrame.BookFrame.Content.Background:SetScale(1.925)
							ReadableUIFrame.BookFrame.Content.Background:SetPoint("CENTER", ReadableUIFrame.BookFrame.Content)
							ReadableUIFrame.BookFrame.Content.Background:SetFrameStrata("FULLSCREEN")
							ReadableUIFrame.BookFrame.Content.Background:SetFrameLevel(4)
						end

						do -- SPRITESHEET
							ReadableUIFrame.BookFrame.Content.Background.Spritesheet = CreateFrame("Frame", "$parent.Spritesheet", ReadableUIFrame.BookFrame.Content.Background)
							ReadableUIFrame.BookFrame.Content.Background.Spritesheet:SetSize(ReadableUIFrame.BookFrame.Content.Background:GetWidth(), ReadableUIFrame.BookFrame.Content.Background:GetHeight())
							ReadableUIFrame.BookFrame.Content.Background.Spritesheet:SetPoint("CENTER", ReadableUIFrame.BookFrame.Content.Background, 0, 0)
							ReadableUIFrame.BookFrame.Content.Background.Spritesheet:SetFrameStrata("FULLSCREEN")
							ReadableUIFrame.BookFrame.Content.Background.Spritesheet:SetFrameLevel(50)

							--------------------------------

							do -- TEXTURE
								ReadableUIFrame.BookFrame.Content.Background.Spritesheet.Texture = addon.API.Animation:CreateSpriteSheet(ReadableUIFrame.BookFrame.Content.Background.Spritesheet, NS.Variables.READABLE_UI_PATH .. "Book/Flipbook/flipbook.png", 3, 9, .01, false)
								ReadableUIFrame.BookFrame.Content.Background.Spritesheet.Texture:SetSize(ReadableUIFrame.BookFrame.Content.Background.Spritesheet:GetWidth(), ReadableUIFrame.BookFrame.Content.Background.Spritesheet:GetHeight())
								ReadableUIFrame.BookFrame.Content.Background.Spritesheet.Texture:SetPoint("CENTER", ReadableUIFrame.BookFrame.Content.Background.Spritesheet, 0, 0)
								ReadableUIFrame.BookFrame.Content.Background.Spritesheet.Texture:SetFrameStrata("FULLSCREEN")
								ReadableUIFrame.BookFrame.Content.Background.Spritesheet.Texture:SetFrameLevel(50)
								ReadableUIFrame.BookFrame.Content.Background.Spritesheet.Texture:SetAlpha(0)
							end
						end
					end

					do -- TEXT
						ReadableUIFrame.BookFrame.Content.Left, ReadableUIFrame.BookFrame.Content.LeftScrollChild = addon.API.FrameTemplates:CreateScrollFrame(ReadableUIFrame.BookFrame.Content, { direction = "vertical", smoothScrollingRatio = 5 }, "$parent.Left", "$parent.LeftScrollChild")
						ReadableUIFrame.BookFrame.Content.Left:SetSize(ReadableUIFrame.BookFrame.Content:GetWidth() / 2 - ReadableUIFrame.BookFrame.Content:GetWidth() * .075, ReadableUIFrame.BookFrame.Content:GetHeight() * .9125)
						ReadableUIFrame.BookFrame.Content.Left:SetPoint("LEFT", ReadableUIFrame.BookFrame.Content, 0, ReadableUIFrame.BookFrame.Content:GetHeight() * .0375)
						ReadableUIFrame.BookFrame.Content.Left:SetFrameStrata("FULLSCREEN")
						ReadableUIFrame.BookFrame.Content.Left:SetFrameLevel(7)
						ReadableUIFrame.BookFrame.Content.Left.ScrollBar:Hide()

						ReadableUIFrame.BookFrame.Content.Right, ReadableUIFrame.BookFrame.Content.RightScrollChild = addon.API.FrameTemplates:CreateScrollFrame(ReadableUIFrame.BookFrame.Content, { direction = "vertical", smoothScrollingRatio = 5 }, "$parent.Right", "$parent.RightScrollChild")
						ReadableUIFrame.BookFrame.Content.Right:SetSize(ReadableUIFrame.BookFrame.Content:GetWidth() / 2 - ReadableUIFrame.BookFrame.Content:GetWidth() * .075, ReadableUIFrame.BookFrame.Content:GetHeight() * .9125)
						ReadableUIFrame.BookFrame.Content.Right:SetPoint("RIGHT", ReadableUIFrame.BookFrame.Content, 0, ReadableUIFrame.BookFrame.Content:GetHeight() * .0325)
						ReadableUIFrame.BookFrame.Content.Right:SetFrameStrata("FULLSCREEN")
						ReadableUIFrame.BookFrame.Content.Right:SetFrameLevel(7)
						ReadableUIFrame.BookFrame.Content.Right.ScrollBar:Hide()

						--------------------------------

						do -- LEFT
							function ReadableUIFrame.BookFrame.Content.Left:UpdateScrollIndicator()
								if NS.ItemUI.Variables.Type == "ParchmentLarge" then
									ReadableUIFrame.BookFrame.Content.Left.GradientTexture:SetTexture(NS.Variables.READABLE_UI_PATH .. "Book/book-large-content-gradient.png")
								else
									ReadableUIFrame.BookFrame.Content.Left.GradientTexture:SetTexture(NS.Variables.READABLE_UI_PATH .. "Book/book-content-gradient.png")
								end

								local VerticalScroll = ReadableUIFrame.BookFrame.Content.Left:GetVerticalScroll()
								local ScrollRange = ReadableUIFrame.BookFrame.Content.Left:GetVerticalScrollRange()

								if VerticalScroll < ScrollRange then
									ReadableUIFrame.BookFrame.Content.Left.Gradient:Show()
								else
									ReadableUIFrame.BookFrame.Content.Left.Gradient:Hide()
								end
							end

							table.insert(ReadableUIFrame.BookFrame.Content.Left.onSmoothScrollStartCallbacks, ReadableUIFrame.BookFrame.Content.Left.UpdateScrollIndicator)
							table.insert(ReadableUIFrame.BookFrame.Content.Left.onSmoothScrollDestinationCallbacks, ReadableUIFrame.BookFrame.Content.Left.UpdateScrollIndicator)

							--------------------------------

							do -- GRADIENT
								ReadableUIFrame.BookFrame.Content.Left.Gradient, ReadableUIFrame.BookFrame.Content.Left.GradientTexture = addon.API.FrameTemplates:CreateTexture(ReadableUIFrame.BookFrame.Content.Left, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Book/book-large-content-gradient.png", "$parent.Gradient")
								ReadableUIFrame.BookFrame.Content.Left.Gradient:SetSize(ReadableUIFrame.BookFrame.Content.Left:GetWidth(), 50)
								ReadableUIFrame.BookFrame.Content.Left.Gradient:SetPoint("BOTTOM", ReadableUIFrame.BookFrame.Content.Left, 0, -1)
								ReadableUIFrame.BookFrame.Content.Left.Gradient:SetFrameStrata("FULLSCREEN")
								ReadableUIFrame.BookFrame.Content.Left.Gradient:SetFrameLevel(49)
							end

							do -- TEXT
								do -- MEASUREMENT
									ReadableUIFrame.BookFrame.Content.Left.MeasurementText = addon.API.FrameTemplates:CreateText(ReadableUIFrame.BookFrame.Content.Left, addon.Theme.RGB_BLACK, TEXT_SIZE_BOOK, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.MeasurementText", true)
									ReadableUIFrame.BookFrame.Content.Left.MeasurementText:SetWidth(ReadableUIFrame.BookFrame.Content.Left:GetWidth())
									ReadableUIFrame.BookFrame.Content.Left.MeasurementText:SetAlpha(0)
								end

								do -- TEXT
									ReadableUIFrame.BookFrame.Content.Left.Text = addon.API.FrameTemplates:CreateText(ReadableUIFrame.BookFrame.Content.LeftScrollChild, addon.Theme.RGB_BLACK, TEXT_SIZE_BOOK, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text", true)
									ReadableUIFrame.BookFrame.Content.Left.Text:SetSize(ReadableUIFrame.BookFrame.Content.LeftScrollChild:GetWidth(), ReadableUIFrame.BookFrame.Content.LeftScrollChild:GetHeight())
									ReadableUIFrame.BookFrame.Content.Left.Text:SetPoint("TOP", ReadableUIFrame.BookFrame.Content.LeftScrollChild)

									--------------------------------

									hooksecurefunc(ReadableUIFrame.BookFrame.Content.Left.Text, "SetText", function()
										addon.Libraries.AceTimer:ScheduleTimer(function()
											local StringHeight

											--------------------------------

											ReadableUIFrame.BookFrame.Content.Left:SetVerticalScroll(0)

											--------------------------------

											if NS.ItemUI.Variables.Type ~= "ParchmentLarge" then
												ReadableUIFrame.BookFrame.Content.Left.MeasurementText:SetText(ReadableUIFrame.BookFrame.Content.Left.Text:GetText())
												StringHeight = ReadableUIFrame.BookFrame.Content.Left.MeasurementText:GetStringHeight()
											else
												StringHeight = ReadableUIFrame.BookFrame.Content.Left.Text:GetStringHeight()
											end

											--------------------------------

											ReadableUIFrame.BookFrame.Content.LeftScrollChild:SetHeight(StringHeight + 50)
											ReadableUIFrame.BookFrame.Content.Left.Text:SetHeight(StringHeight + 50)

											--------------------------------

											addon.Libraries.AceTimer:ScheduleTimer(function()
												ReadableUIFrame.BookFrame.Content.Left:UpdateScrollIndicator()
											end, .25)
										end, .1)
									end)
								end
							end

							do -- FOOTER
								ReadableUIFrame.BookFrame.Content.Left.Footer = addon.API.FrameTemplates:CreateText(ReadableUIFrame.BookFrame.Content.Left, addon.Theme.RGB_BLACK, 10, "LEFT", "BOTTOM", addon.API.Fonts.CONTENT_LIGHT, "$parent.Footer")
								ReadableUIFrame.BookFrame.Content.Left.Footer:SetSize(100, 100)
								ReadableUIFrame.BookFrame.Content.Left.Footer:SetPoint("BOTTOMLEFT", ReadableUIFrame.BookFrame.Content.Left, 0, -17.5)
								ReadableUIFrame.BookFrame.Content.Left.Footer:SetIgnoreParentScale(true)
							end
						end

						do -- RIGHT
							function ReadableUIFrame.BookFrame.Content.Right:UpdateScrollIndicator()
								if NS.ItemUI.Variables.Type == "ParchmentLarge" then
									ReadableUIFrame.BookFrame.Content.Right.GradientTexture:SetTexture(NS.Variables.READABLE_UI_PATH .. "Book/book-large-content-gradient.png")
								else
									ReadableUIFrame.BookFrame.Content.Right.GradientTexture:SetTexture(NS.Variables.READABLE_UI_PATH .. "Book/book-content-gradient.png")
								end

								local VerticalScroll = ReadableUIFrame.BookFrame.Content.Right:GetVerticalScroll()
								local ScrollRange = ReadableUIFrame.BookFrame.Content.Right:GetVerticalScrollRange()

								if VerticalScroll < ScrollRange then
									ReadableUIFrame.BookFrame.Content.Right.Gradient:Show()
								else
									ReadableUIFrame.BookFrame.Content.Right.Gradient:Hide()
								end
							end

							table.insert(ReadableUIFrame.BookFrame.Content.Right.onSmoothScrollStartCallbacks, ReadableUIFrame.BookFrame.Content.Right.UpdateScrollIndicator)
							table.insert(ReadableUIFrame.BookFrame.Content.Right.onSmoothScrollDestinationCallbacks, ReadableUIFrame.BookFrame.Content.Right.UpdateScrollIndicator)

							--------------------------------

							do -- GRADIENT
								ReadableUIFrame.BookFrame.Content.Right.Gradient, ReadableUIFrame.BookFrame.Content.Right.GradientTexture = addon.API.FrameTemplates:CreateTexture(ReadableUIFrame.BookFrame.Content.Right, "FULLSCREEN", NS.Variables.READABLE_UI_PATH .. "Book/book-large-content-gradient.png", "$parent.Gradient")
								ReadableUIFrame.BookFrame.Content.Right.Gradient:SetSize(ReadableUIFrame.BookFrame.Content.Right:GetWidth(), 50)
								ReadableUIFrame.BookFrame.Content.Right.Gradient:SetPoint("BOTTOM", ReadableUIFrame.BookFrame.Content.Right, 0, -1)
								ReadableUIFrame.BookFrame.Content.Right.Gradient:SetFrameStrata("FULLSCREEN")
								ReadableUIFrame.BookFrame.Content.Right.Gradient:SetFrameLevel(49)
							end

							do -- TEXT
								do -- MEASUREMENT
									ReadableUIFrame.BookFrame.Content.Right.MeasurementText = addon.API.FrameTemplates:CreateText(ReadableUIFrame.BookFrame.Content.Right, addon.Theme.RGB_BLACK, TEXT_SIZE_BOOK, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.MeasurementText", true)
									ReadableUIFrame.BookFrame.Content.Right.MeasurementText:SetWidth(ReadableUIFrame.BookFrame.Content.Right:GetWidth())
									ReadableUIFrame.BookFrame.Content.Right.MeasurementText:SetAlpha(0)
								end

								do -- TEXT
									ReadableUIFrame.BookFrame.Content.Right.Text = addon.API.FrameTemplates:CreateText(ReadableUIFrame.BookFrame.Content.RightScrollChild, addon.Theme.RGB_BLACK, TEXT_SIZE_BOOK, "LEFT", "TOP", addon.API.Fonts.CONTENT_LIGHT, "$parent.Text", true)
									ReadableUIFrame.BookFrame.Content.Right.Text:SetSize(ReadableUIFrame.BookFrame.Content.Right:GetWidth(), ReadableUIFrame.BookFrame.Content.Right:GetHeight())
									ReadableUIFrame.BookFrame.Content.Right.Text:SetPoint("TOP", ReadableUIFrame.BookFrame.Content.RightScrollChild)

									--------------------------------

									hooksecurefunc(ReadableUIFrame.BookFrame.Content.Right.Text, "SetText", function()
										addon.Libraries.AceTimer:ScheduleTimer(function()
											local StringHeight

											--------------------------------

											ReadableUIFrame.BookFrame.Content.Right:SetVerticalScroll(0)

											--------------------------------

											if NS.ItemUI.Variables.Type ~= "ParchmentLarge" then
												ReadableUIFrame.BookFrame.Content.Right.MeasurementText:SetText(ReadableUIFrame.BookFrame.Content.Right.Text:GetText())
												StringHeight = ReadableUIFrame.BookFrame.Content.Right.MeasurementText:GetStringHeight()
											else
												StringHeight = ReadableUIFrame.BookFrame.Content.Right.Text:GetStringHeight()
											end

											--------------------------------

											ReadableUIFrame.BookFrame.Content.RightScrollChild:SetHeight(StringHeight + 5)
											ReadableUIFrame.BookFrame.Content.Right.Text:SetHeight(StringHeight + 5)

											--------------------------------

											addon.Libraries.AceTimer:ScheduleTimer(function()
												ReadableUIFrame.BookFrame.Content.Right:UpdateScrollIndicator()
											end, .25)
										end, .1)
									end)
								end
							end

							do -- FOOTER
								ReadableUIFrame.BookFrame.Content.Right.Footer = addon.API.FrameTemplates:CreateText(ReadableUIFrame.BookFrame.Content.Right, addon.Theme.RGB_BLACK, 10, "RIGHT", "BOTTOM", addon.API.Fonts.CONTENT_LIGHT, "$parent.Footer")
								ReadableUIFrame.BookFrame.Content.Right.Footer:SetSize(100, 100)
								ReadableUIFrame.BookFrame.Content.Right.Footer:SetPoint("BOTTOMRIGHT", ReadableUIFrame.BookFrame.Content.Right, 0, -17.5)
								ReadableUIFrame.BookFrame.Content.Right.Footer:SetIgnoreParentScale(true)
							end
						end
					end
				end
			end
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	InteractionReadableUIFrame:Hide()
	InteractionReadableUIFrame.ReadableUIFrame.ItemFrame:Hide()
	InteractionReadableUIFrame.ReadableUIFrame.BookFrame:Hide()
end
