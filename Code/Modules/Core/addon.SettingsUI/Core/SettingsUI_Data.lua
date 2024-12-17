local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales
local NS = addon.SettingsUI

--------------------------------

NS.Data = {}

--------------------------------

function NS.Data:Load()
	--------------------------------
	-- FUNCTIONS (CONTENT)
	--------------------------------

	do -- TABS
		InteractionSettingsFrame.Sidebar.Legend.CreateOptions = function()
			local Widgets = {}

			--------------------------------

			local function Header()
				local Title = NS.Widgets:CreateTitle(InteractionSettingsFrame.Sidebar.LegendScrollChildFrame, addon.Variables.PATH .. "Art/icon.png", 20)
				table.insert(Widgets, Title)
				Title.label:SetText("Interaction")
			end

			local function Options()
				local function CreateOption(name, index)
					local frame = NS.Widgets:CreateTabButton(InteractionSettingsFrame.Sidebar.LegendScrollChildFrame,
						function(button)
							NS.Script:SelectTab(button, index)
						end
					)
					table.insert(Widgets, frame)
					frame.button:SetText(name)
					frame.button.SavedText = name

					return frame
				end

				CreateOption(L["Tab - Appearance"], 1)
				CreateOption(L["Tab - Effects"], 2)
				CreateOption(L["Tab - Playback"], 3)
				CreateOption(L["Tab - Controls"], 4)
				CreateOption(L["Tab - Gameplay"], 5)
				CreateOption(L["Tab - More"], 6)

				InteractionSettingsFrame.Tab_Appearance = InteractionSettingsFrame.Content.ScrollFrame.CreateTab(1)
				InteractionSettingsFrame.Tab_Effects = InteractionSettingsFrame.Content.ScrollFrame.CreateTab(2)
				InteractionSettingsFrame.Tab_Playback = InteractionSettingsFrame.Content.ScrollFrame.CreateTab(3)
				InteractionSettingsFrame.Tab_Controls = InteractionSettingsFrame.Content.ScrollFrame.CreateTab(4)
				InteractionSettingsFrame.Tab_Gameplay = InteractionSettingsFrame.Content.ScrollFrame.CreateTab(5)
				InteractionSettingsFrame.Tab_More = InteractionSettingsFrame.Content.ScrollFrame.CreateTab(6)
			end

			--------------------------------

			-- Header()
			Options()

			--------------------------------

			InteractionSettingsFrame.Sidebar.Legend.widgetPool = Widgets
		end

		--------------------------------

		InteractionSettingsFrame.Sidebar.Legend.CreateOptions()
	end

	do -- CONTENT
		do -- <- Before you get started
			-- Button = {
			--     name = "Default",
			--     tooltipImage = "",
			--     tooltipText = "Placeholder",
			--     tooltipImageType = "Small",
			--     type = "Button",
			--     order = 1,
			--     hidden = function() return false end,
			--     locked = function() return false end,
			--     subcategory = 0,
			--     category = Default,
			--	   setCriteria = function() return true end,
			--     set = function() print("Click") end,
			-- }

			-- Title = {
			--     name = "Default",
			--     type = "Title",
			--     order = 1,
			--     hidden = function() return false end,
			--     locked = function() return false end,
			--     category = Default,
			-- }

			-- Checkbox = {
			--     name = "Default",
			--     tooltipImage = "",
			--     tooltipText = "Placeholder",
			--     tooltipImageType = "Small",
			--     type = "Checkbox",
			--     order = 1,
			--     hidden = function() return false end,
			--     locked = function() return false end,
			--     subcategory = 0,
			--     category = Default,
			--     get = function() return variable end,
			--     setCriteria = function() return true end,
			--     set = function(_, val)
			--         variable = val
			--     end,
			-- }

			-- Range = {
			--     name = "Default",
			--     tooltipImage = "",
			--     tooltipText = "Placeholder",
			--     tooltipImageType = "Small",
			--     type = "Range",
			--     min = 0,
			--     max = 1,
			--     step = .5,
			--     order = 1,
			--     hidden = function() return false end,
			--     locked = function() return false end,
			--     subcategory = 0,
			--     category = Default,
			--     valueText = nil,
			--     grid = false,
			--     get = function() return variable end,
			--     setCriteria = function() return true end,
			--     set = function(_, val) variable = val; end
			-- }

			-- Dropdown = {
			--     name = "Default",
			--     tooltipImage = "",
			--     tooltipText = "Placeholder",
			--     tooltipImageType = "Small",
			--     type = "Dropdown",
			--     values = {
			--         [1] = {
			--             name = "Value1"
			--         },
			--         [2] = {
			--             name = "Value2"
			--         }
			--     },
			--     order = 1,
			--     hidden = function() return false end,
			--     locked = function() return false end,
			--     subcategory = 0,
			--     category = Default,
			--     get = function() return variable end,
			--     setCriteria = function() return true end,
			--     set = function(_, val) variable = val end,
			--     open = function() print("List Opened") end,
			--     close = function() print("List Closed") end,
			--     autoCloseList = true
			-- }
		end

		local Appearance = InteractionSettingsFrame.Tab_Appearance
		local Effects = InteractionSettingsFrame.Tab_Effects
		local Playback = InteractionSettingsFrame.Tab_Playback
		local Controls = InteractionSettingsFrame.Tab_Controls
		local Gameplay = InteractionSettingsFrame.Tab_Gameplay
		local More = InteractionSettingsFrame.Tab_More

		local CategoryNames = {
			"Appearance",
			"Effects",
			"Playback",
			"Controls",
			"Gameplay",
			"More"
		}

		local CategoryTabs = {
			Appearance,
			Effects,
			Playback,
			Controls,
			Gameplay,
			More
		}

		--------------------------------

		local Elements_Appearance = {
			name = L["Tab - Appearance"],
			type = "Group",
			order = 1,
			category = Appearance,
			args = {
				Title_Theme = {
					name = L["Title - Theme"],
					type = "Title",
					order = 2,
					hidden = function() return false end,
					category = Appearance,
				},
				Range_MainTheme = {
					name = L["Range - Main Theme"],
					tooltipImage = NS.Variables.TOOLTIP_PATH .. "Theme.png",
					tooltipText = L["Range - Main Theme - Tooltip"],
					tooltipImageType = "Large",
					type = "Range",
					min = 1,
					max = 2,
					step = 1,
					order = 3,
					hidden = function() return false end,
					subcategory = 0,
					category = Appearance,
					valueText = function(val)
						if val == 1 then
							return "DAY"
						elseif val == 2 then
							return "NIGHT"
						end
					end,
					get = function() return INTDB.profile.INT_MAIN_THEME end,
					setCriteria = function(_, val)
						if not InteractionFrame.ThemeTransition then
							return true
						else
							return false
						end
					end,
					set = function(_, val)
						if val ~= INTDB.profile.INT_MAIN_THEME then
							-- CallbackRegistry:Trigger("THEME_UPDATE_ANIMATION")

							-- addon.Libraries.AceTimer:ScheduleTimer(function()
							-- 	CallbackRegistry:Trigger("THEME_UPDATE")
							-- end, 0)

							addon.Libraries.AceTimer:ScheduleTimer(function()
								CallbackRegistry:Trigger("THEME_UPDATE")
							end, .125)
						end

						INTDB.profile.INT_MAIN_THEME = val
					end
				},
				Range_DialogTheme = {
					name = L["Range - Dialog Theme"],
					tooltipImage = NS.Variables.TOOLTIP_PATH .. "Theme-Dialog.png",
					tooltipText = L["Range - Dialog Theme - Tooltip"],
					tooltipImageType = "Large",
					type = "Range",
					min = 1,
					max = 4,
					step = 1,
					order = 4,
					hidden = function() return false end,
					subcategory = 0,
					category = Appearance,
					valueText = function(val)
						if val == 1 then
							return "AUTO"
						elseif val == 2 then
							return "DAY"
						elseif val == 3 then
							return "NIGHT"
						elseif val == 4 then
							return "RUSTIC"
						end
					end,
					grid = true,
					get = function() return INTDB.profile.INT_DIALOG_THEME end,
					setCriteria = function(_, val)
						if not addon.Interaction.Gossip.Variables.ThemeUpdateTransition then
							return true
						else
							return false
						end
					end,
					set = function(_, val)
						if val ~= INTDB.profile.INT_DIALOG_THEME then
							-- CallbackRegistry:Trigger("THEME_UPDATE_DIALOG_ANIMATION")

							-- addon.Libraries.AceTimer:ScheduleTimer(function()
							-- 	CallbackRegistry:Trigger("THEME_UPDATE")
							-- end, .25)

							addon.Libraries.AceTimer:ScheduleTimer(function()
								CallbackRegistry:Trigger("THEME_UPDATE")
							end, 0)
						end

						INTDB.profile.INT_DIALOG_THEME = val
					end
				},
				Title_Appearance = {
					name = L["Title - Appearance"],
					type = "Title",
					order = 5,
					hidden = function() return false end,
					category = Appearance,
				},
				Range_Orientation = {
					name = L["Range - Orientation"],
					tooltipImage = NS.Variables.TOOLTIP_PATH .. "UIDirection.png",
					tooltipText = L["Range - Orientation - Tooltip"],
					tooltipImageType = "Large",
					type = "Range",
					min = 1,
					max = 2,
					step = 1,
					order = 6,
					hidden = function() return false end,
					subcategory = 0,
					category = Appearance,
					valueText = function(val)
						if val == 1 then
							return "LEFT"
						elseif val == 2 then
							return "RIGHT"
						end
					end,
					get = function() return INTDB.profile.INT_UIDIRECTION end,
					set = function(_, val)
						INTDB.profile.INT_UIDIRECTION = val

						CallbackRegistry:Trigger("SETTINGS_UIDIRECTION_CHANGED")
					end
				},
				Title_Text = {
					name = L["Title - Text"],
					type = "Title",
					order = 7,
					hidden = function() return false end,
					category = Appearance,
				},
				Range_ContentSize = {
					name = L["Range - Content Size"],
					tooltipImage = "",
					tooltipText = L["Range - Content Size - Tooltip"],
					tooltipImageType = "Small",
					type = "Range",
					min = 10,
					max = 25,
					step = .5,
					order = 8,
					hidden = function() return false end,
					subcategory = 0,
					category = Appearance,
					valueText = function(val)
						return string.format("%.1f", val) .. " PT"
					end,
					get = function() return INTDB.profile.INT_CONTENT_SIZE end,
					set = function(_, val)
						INTDB.profile.INT_CONTENT_SIZE = val

						CallbackRegistry:Trigger("SETTINGS_CONTENT_SIZE_CHANGED")
					end
				},
				Title_Dialog = {
					name = L["Title - Dialog"],
					type = "Title",
					order = 9,
					hidden = function() return false end,
					category = Appearance,
				},
				Checkbox_Dialog_Title_ProgressBar = {
					name = L["Checkbox - Dialog / Title / Progress Bar"],
					tooltipImage = NS.Variables.TOOLTIP_PATH .. "Title-ProgressBar.png",
					tooltipText = L["Checkbox - Dialog / Title / Progress Bar - Tooltip"],
					tooltipImageType = "Large",
					type = "Checkbox",
					order = 10,
					hidden = function() return false end,
					locked = function() return false end,
					subcategory = 0,
					category = Appearance,
					get = function() return INTDB.profile.INT_PROGRESS_SHOW end,
					set = function(_, val)
						INTDB.profile.INT_PROGRESS_SHOW = val

						CallbackRegistry:Trigger("SETTINGS_TITLE_PROGRESS_VISIBILITY_CHANGED")
					end,
				},
				Range_Dialog_Title_Alpha = {
					name = L["Range - Dialog / Title / Text Alpha"],
					tooltipImage = "",
					tooltipText = L["Range - Dialog / Title / Text Alpha - Tooltip"],
					tooltipImageType = "Small",
					type = "Range",
					min = 0,
					max = 1,
					step = .1,
					order = 11,
					hidden = function() return false end,
					locked = function() return false end,
					subcategory = 0,
					category = Appearance,
					valueText = function(val)
						return string.format("%.0f", (val * 100)) .. "%"
					end,
					get = function() return INTDB.profile.INT_TITLE_ALPHA end,
					set = function(_, val)
						INTDB.profile.INT_TITLE_ALPHA = val

						CallbackRegistry:Trigger("SETTINGS_TITLE_ALPHA_CHANGED")
					end
				},
				Range_Dialog_Content_Preview_Alpha = {
					name = L["Range - Dialog / Content Preview Alpha"],
					tooltipImage = "",
					tooltipText = L["Range - Dialog / Content Preview Alpha - Tooltip"],
					tooltipImageType = "Small",
					type = "Range",
					min = 0,
					max = 1,
					step = .1,
					order = 12,
					hidden = function() return false end,
					subcategory = 0,
					category = Appearance,
					valueText = function(val)
						return string.format("%.0f", (val * 100)) .. "%"
					end,
					get = function() return INTDB.profile.INT_CONTENT_PREVIEW_ALPHA end,
					set = function(_, val)
						INTDB.profile.INT_CONTENT_PREVIEW_ALPHA = val
					end
				},
				Title_Quest = {
					name = L["Title - Quest"],
					type = "Title",
					order = 13,
					hidden = function() return false end,
					category = Appearance,
				},
				Checkbox_Quest_AlwaysShowQuest = {
					name = L["Checkbox - Always Show Quest Frame"],
					tooltipImage = "",
					tooltipText = L["Checkbox - Always Show Quest Frame - Tooltip"],
					tooltipImageType = "Small",
					type = "Checkbox",
					order = 14,
					hidden = function() return false end,
					locked = function() return addon.Interaction.Variables.Active end,
					subcategory = 0,
					category = Appearance,
					get = function() return INTDB.profile.INT_ALWAYS_SHOW_QUEST end,
					set = function(_, val)
						if not addon.Interaction.Variables.Active then
							INTDB.profile.INT_ALWAYS_SHOW_QUEST = val
						end
					end
				}
			}
		}

		local Elements_Effects = {
			name = L["Tab - Effects"],
			type = "Group",
			category = Effects,
			order = 1,
			args = {
				Title_Warning = {
					name = L["Warning - Leave NPC Interaction"],
					type = "Title",
					order = 2,
					hidden = function() return not addon.Interaction.Variables.Active end,
					category = Effects,
				},
				Title_Effects = {
					name = L["Title - Effects"],
					type = "Title",
					order = 3,
					hidden = function() return false end,
					locked = function() return addon.Interaction.Variables.Active end,
					category = Effects,
				},
				Checkbox_HideUI = {
					name = L["Checkbox - Hide UI"],
					tooltipImage = "",
					tooltipText = L["Checkbox - Hide UI - Tooltip"],
					tooltipImageType = "Small",
					type = "Checkbox",
					order = 4,
					hidden = function() return false end,
					locked = function() return addon.Interaction.Variables.Active end,
					subcategory = 0,
					category = Effects,
					get = function() return INTDB.profile.INT_HIDEUI end,
					set = function(_, val)
						addon.Database:PreventSetVariableDuringCinematicMode("INT_HIDEUI", val)
					end,
				},
				Range_Cinematic = {
					name = L["Range - Cinematic"],
					tooltipImage = "",
					tooltipText = L["Range - Cinematic - Tooltip"],
					tooltipImageType = "Small",
					type = "Range",
					min = 1,
					max = 4,
					step = 1,
					order = 5,
					hidden = function() return false end,
					locked = function() return addon.Interaction.Variables.Active end,
					subcategory = 0,
					category = Effects,
					valueText = function(val)
						if val == 1 then
							return "NONE"
						elseif val == 2 then
							return "FULL"
						elseif val == 3 then
							return "BALANCED"
						elseif val == 4 then
							return "CUSTOM"
						end
					end,
					grid = true,
					get = function() return INTDB.profile.INT_CINEMATIC_PRESET end,
					set = function(_, val)
						addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_PRESET", val)

						addon.Database:SetDynamicCinematicVariables()
					end
				},
				Group_Custom = {
					name = "Custom",
					type = "Group",
					order = 6,
					hidden = function() return (INTDB.profile.INT_CINEMATIC_PRESET < 4) end,
					locked = function() return addon.Interaction.Variables.Active end,
					category = Effects,
					args = {
						Checkbox_Zoom = {
							name = L["Checkbox - Zoom"],
							tooltipImage = "",
							tooltipText = "",
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 7,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 1,
							category = Effects,
							get = function() return INTDB.profile.INT_CINEMATIC_ZOOMIN end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ZOOMIN", val)
							end,
						},
						Range_Zoom_Distance = {
							name = L["Range - Zoom Distance"],
							tooltipImage = "",
							tooltipText = L["Range - Zoom Distance - Tooltip"],
							tooltipImageType = "Small",
							type = "Range",
							min = 1,
							max = 39,
							step = 1,
							order = 8,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_ZOOMIN end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							valueText = function(val)
								return string.format("%.1f", val)
							end,
							get = function() return INTDB.profile.INT_CINEMATIC_ZOOMIN_DISTANCE end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ZOOMIN_DISTANCE", val); end
						},
						Checkbox_Zoom_Pitch = {
							name = L["Checkbox - Zoom Pitch"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Zoom Pitch - Tooltip"],
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 9,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_ZOOMIN end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							get = function() return INTDB.profile.INT_CINEMATIC_ZOOMIN_PITCH end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ZOOMIN_PITCH", val)
							end,
						},
						Range_Zoom_Pitch_Level = {
							name = L["Range - Zoom Pitch / Level"],
							tooltipImage = "",
							tooltipText = L["Range - Zoom Pitch / Level - Tooltip"],
							tooltipImageType = "Small",
							type = "Range",
							min = 1,
							max = 89,
							step = 1,
							order = 10,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_ZOOMIN or not INTDB.profile.INT_CINEMATIC_ZOOMIN_PITCH end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 3,
							category = Effects,
							valueText = function(val)
								return string.format("%.1f", val)
							end,
							get = function() return INTDB.profile.INT_CINEMATIC_ZOOMIN_PITCH_LEVEL end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ZOOMIN_PITCH_LEVEL", val); end
						},
						Checkbox_FieldOfView = {
							name = L["Checkbox - Field Of View"],
							tooltipImage = "",
							tooltipText = "",
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 11,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_ZOOMIN end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							get = function() return INTDB.profile.INT_CINEMATIC_ZOOMIN_FOV end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ZOOMIN_FOV", val)
							end,
						},
						Checkbox_Pan = {
							name = L["Checkbox - Pan"],
							tooltipImage = "",
							tooltipText = "",
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 12,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 1,
							category = Effects,
							get = function() return INTDB.profile.INT_CINEMATIC_PAN end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_PAN", val)
							end,
						},
						Range_Pan_Speed = {
							name = L["Range - Pan / Speed"],
							tooltipImage = "",
							tooltipText = L["Range - Pan / Speed - Tooltip"],
							tooltipImageType = "Small",
							type = "Range",
							min = 0,
							max = 5,
							step = .25,
							order = 13,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_PAN end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							valueText = function(val)
								return string.format("%.0f", val * 100) .. "%"
							end,
							get = function() return INTDB.profile.INT_CINEMATIC_PAN_SPEED end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_PAN_SPEED", val); end
						},
						Checkbox_DynamicCamera = {
							name = L["Checkbox - Dynamic Camera"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Dynamic Camera - Tooltip"],
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 14,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 1,
							category = Effects,
							get = function() return INTDB.profile.INT_CINEMATIC_ACTIONCAM end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM", val)
							end,
						},
						Checkbox_DynamicCamera_SideView = {
							name = L["Checkbox - Dynamic Camera / Side View"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Dynamic Camera / Side View - Tooltip"],
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 15,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_ACTIONCAM end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							get = function() return INTDB.profile.INT_CINEMATIC_ACTIONCAM_SIDE end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_SIDE", val)
							end,
						},
						Range_DynamicCamera_SideView_Strength = {
							name = L["Range - Dynamic Camera / Side View / Strength"],
							tooltipImage = "",
							tooltipText = L["Range - Dynamic Camera / Side View / Strength - Tooltip"],
							tooltipImageType = "Small",
							type = "Range",
							min = 0,
							max = 3,
							step = .25,
							order = 16,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_ACTIONCAM or not INTDB.profile.INT_CINEMATIC_ACTIONCAM_SIDE end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 3,
							category = Effects,
							valueText = function(val)
								return string.format("%.0f", val * 100) .. "%"
							end,
							get = function() return INTDB.profile.INT_CINEMATIC_ACTIONCAM_SIDE_STRENGTH end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_SIDE_STRENGTH", val); end
						},
						Checkbox_DynamicCamera_Offset = {
							name = L["Checkbox - Dynamic Camera / Offset"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Dynamic Camera / Offset - Tooltip"],
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 17,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_ACTIONCAM end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							get = function() return INTDB.profile.INT_CINEMATIC_ACTIONCAM_OFFSET end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_OFFSET", val)
							end,
						},
						Range_DynamicCamera_Offset_Strength = {
							name = L["Range - Dynamic Camera / Offset / Strength"],
							tooltipImage = "",
							tooltipText = L["Range - Dynamic Camera / Offset / Strength - Tooltip"],
							tooltipImageType = "Small",
							type = "Range",
							min = 0,
							max = 25,
							step = .25,
							order = 18,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_ACTIONCAM or not INTDB.profile.INT_CINEMATIC_ACTIONCAM_OFFSET end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 3,
							category = Effects,
							valueText = function(val)
								return string.format("%.0f", val * 10) .. "%"
							end,
							get = function() return INTDB.profile.INT_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH", val); end
						},
						Checkbox_DynamicCamera_Focus = {
							name = L["Checkbox - Dynamic Camera / Focus"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Dynamic Camera / Focus - Tooltip"],
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 19,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_ACTIONCAM end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							get = function() return INTDB.profile.INT_CINEMATIC_ACTIONCAM_FOCUS end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_FOCUS", val)
							end,
						},
						Range_DynamicCamera_Focus_Strength = {
							name = L["Range - Dynamic Camera / Focus / Strength"],
							tooltipImage = "",
							tooltipText = L["Range - Dynamic Camera / Focus / Strength - Tooltip"],
							tooltipImageType = "Small",
							type = "Range",
							min = 0,
							max = 1,
							step = .1,
							order = 20,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_ACTIONCAM or not INTDB.profile.INT_CINEMATIC_ACTIONCAM_FOCUS end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 3,
							category = Effects,
							valueText = function(val)
								return string.format("%.0f", val * 100) .. "%"
							end,
							get = function() return INTDB.profile.INT_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH", val); end
						},
						Checkbox_DynamicCamera_Focus_X = {
							name = L["Checkbox - Dynamic Camera / Focus / X"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Dynamic Camera / Focus / X - Tooltip"],
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 21,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_ACTIONCAM or not INTDB.profile.INT_CINEMATIC_ACTIONCAM_FOCUS end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 3,
							category = Effects,
							get = function() return INTDB.profile.INT_CINEMATIC_ACTIONCAM_FOCUS_X end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_FOCUS_X", val)
							end,
						},
						Checkbox_DynamicCamera_Focus_Y = {
							name = L["Checkbox - Dynamic Camera / Focus / Y"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Dynamic Camera / Focus / Y - Tooltip"],
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 22,
							hidden = function() return not INTDB.profile.INT_CINEMATIC_ACTIONCAM or not INTDB.profile.INT_CINEMATIC_ACTIONCAM_FOCUS end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 3,
							category = Effects,
							get = function() return INTDB.profile.INT_CINEMATIC_ACTIONCAM_FOCUS_Y end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_FOCUS_Y", val)
							end,
						},
						Checkbox_Vignette = {
							name = L["Checkbox - Vignette"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Vignette - Tooltip"],
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 23,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 1,
							category = Effects,
							get = function() return INTDB.profile.INT_CINEMATIC_VIGNETTE end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_VIGNETTE", val)
							end,
						},
					}
				},
			}
		}

		local Elements_Playback = {
			name = L["Tab - Playback"],
			type = "Group",
			order = 1,
			category = Playback,
			args = {
				Title_Pace = {
					name = L["Title - Pace"],
					type = "Title",
					order = 2,
					hidden = function() return false end,
					category = Playback,
				},
				Range_PlaybackSpeed = {
					name = L["Range - Playback Speed"],
					tooltipImage = "",
					tooltipText = L["Range - Playback Speed - Tooltip"],
					tooltipImageType = "Small",
					type = "Range",
					min = .1,
					max = 2,
					step = .1,
					order = 3,
					hidden = function() return false end,
					subcategory = 0,
					category = Playback,
					valueText = function(val)
						return string.format("%.0f", val * 100) .. "%"
					end,
					get = function() return INTDB.profile.INT_PLAYBACK_SPEED end,
					set = function(_, val) INTDB.profile.INT_PLAYBACK_SPEED = val; end
				},
				Checkbox_DynamicPlayback = {
					name = L["Checkbox - Dynamic Playback"],
					tooltipImage = "",
					tooltipText = L["Checkbox - Dynamic Playback - Tooltip"],
					tooltipImageType = "Small",
					type = "Checkbox",
					order = 4,
					hidden = function() return false end,
					subcategory = 0,
					category = Playback,
					get = function() return INTDB.profile.INT_PLAYBACK_PUNCTUATION_PAUSING end,
					set = function(_, val) INTDB.profile.INT_PLAYBACK_PUNCTUATION_PAUSING = val end,
				},
				Title_AutoProgress = {
					name = L["Title - Auto Progress"],
					type = "Title",
					order = 5,
					hidden = function() return false end,
					category = Playback,
				},
				Checkbox_AutoProgress = {
					name = L["Checkbox - Auto Progress"],
					tooltipImage = "",
					tooltipText = L["Checkbox - Auto Progress - Tooltip"],
					tooltipImageType = "Small",
					type = "Checkbox",
					order = 6,
					hidden = function() return false end,
					subcategory = 0,
					category = Playback,
					get = function() return INTDB.profile.INT_PLAYBACK_AUTOPROGRESS end,
					set = function(_, val)
						INTDB.profile.INT_PLAYBACK_AUTOPROGRESS = val
					end,
				},
				Group_AutoProgress = {
					name = L["Title - Auto Progress"],
					type = "Group",
					order = 7,
					hidden = function() return not INTDB.profile.INT_PLAYBACK_AUTOPROGRESS end,
					category = Playback,
					args = {
						Checkbox_AutoProgress_AutoCloseDialog = {
							name = L["Checkbox - Auto Close Dialog"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Auto Close Dialog - Tooltip"],
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 8,
							hidden = function() return not INTDB.profile.INT_PLAYBACK_AUTOPROGRESS end,
							subcategory = 1,
							category = Playback,
							get = function() return INTDB.profile.INT_PLAYBACK_AUTOPROGRESS_AUTOCLOSE end,
							set = function(_, val)
								INTDB.profile.INT_PLAYBACK_AUTOPROGRESS_AUTOCLOSE = val
							end,
						},
						Range_AutoProgress_Delay = {
							name = L["Range - Auto Progress / Delay"],
							tooltipImage = "",
							tooltipText = L["Range - Auto Progress / Delay - Tooltip"],
							tooltipImageType = "Small",
							type = "Range",
							min = 0,
							max = 5,
							step = .5,
							order = 9,
							hidden = function() return not INTDB.profile.INT_PLAYBACK_AUTOPROGRESS end,
							subcategory = 1,
							category = Playback,
							valueText = function(val) return string.format("%.1f", val) .. "s" end,
							get = function() return INTDB.profile.INT_PLAYBACK_AUTOPROGRESS_DELAY end,
							set = function(_, val) INTDB.profile.INT_PLAYBACK_AUTOPROGRESS_DELAY = val; end
						},
					}
				},
				Title_TextToSpeech = {
					name = L["Title - Text To Speech"],
					type = "Title",
					order = 10,
					hidden = function() return false end,
					locked = function() return false end,
					category = Playback,
				},
				Checkbox_TextToSpeech = {
					name = L["Checkbox - Text To Speech"],
					tooltipImage = "",
					tooltipText = L["Checkbox - Text To Speech - Tooltip"],
					tooltipImageType = "Small",
					type = "Checkbox",
					order = 11,
					hidden = function() return false end,
					locked = function() return false end,
					subcategory = 0,
					category = Playback,
					get = function() return INTDB.profile.INT_TTS end,
					set = function(_, val)
						INTDB.profile.INT_TTS = val
					end,
				},
				Group_TextToSpeech = {
					name = L["Title - Text To Speech"],
					type = "Group",
					order = 12,
					hidden = function() return not INTDB.profile.INT_TTS end,
					category = Playback,
					args = {
						Title_TextToSpeech_Playback = {
							name = L["Title - Text To Speech / Playback"],
							type = "Title",
							order = 13,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
						},
						Range_TextToSpeech_Rate = {
							name = L["Range - Text To Speech / Rate"],
							tooltipImage = "",
							tooltipText = L["Range - Text To Speech / Rate - Tooltip"],
							tooltipImageType = "Small",
							type = "Range",
							min = -10,
							max = 10,
							step = .25,
							order = 14,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
							valueText = function(val)
								return string.format("%.0f", (val + 10) * 10) .. "%"
							end,
							get = function() return INTDB.profile.INT_TTS_SPEED end,
							set = function(_, val) INTDB.profile.INT_TTS_SPEED = val; end
						},
						Range_TextToSpeech_Volume = {
							name = L["Range - Text To Speech / Volume"],
							tooltipImage = "",
							tooltipText = L["Range - Text To Speech / Volume - Tooltip"],
							tooltipImageType = "Small",
							type = "Range",
							min = 0,
							max = 100,
							step = 10,
							order = 15,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
							valueText = function(val)
								return string.format("%.0f", val) .. "%"
							end,
							get = function() return INTDB.profile.INT_TTS_VOLUME end,
							set = function(_, val) INTDB.profile.INT_TTS_VOLUME = val; end
						},
						Title_TextToSpeech_Voice = {
							name = L["Title - Text To Speech / Voice"],
							type = "Title",
							order = 16,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
						},
						Dropdown_TextToSpeech_Neutral = {
							name = L["Dropdown - Text To Speech / Voice / Neutral"],
							tooltipImage = "",
							tooltipText = L["Dropdown - Text To Speech / Voice / Neutral - Tooltip"],
							tooltipImageType = "Small",
							type = "Dropdown",
							values = function()
								local table, voices = {}, C_VoiceChat.GetTtsVoices()
								for _, voice in ipairs(voices) do
									table[voice.voiceID + 1] = voice.name
								end
								return table
							end,
							order = 17,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
							get = function() return INTDB.profile.INT_TTS_VOICE end,
							set = function(_, val)
								INTDB.profile.INT_TTS_VOICE = val

								addon.TextToSpeech.Script:Speak(val, "Interaction example text.")
							end,
							open = function() NS.Utils.SetPreventMouse(true) end,
							close = function() NS.Utils.SetPreventMouse(false) end,
							autoCloseList = false
						},
						Dropdown_TextToSpeech_Male = {
							name = L["Dropdown - Text To Speech / Voice / Male"],
							tooltipImage = "",
							tooltipText = L["Dropdown - Text To Speech / Voice / Male - Tooltip"],
							tooltipImageType = "Small",
							type = "Dropdown",
							values = function()
								local table, voices = {}, C_VoiceChat.GetTtsVoices()
								for _, voice in ipairs(voices) do
									table[voice.voiceID + 1] = voice.name
								end
								return table
							end,
							order = 18,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
							get = function() return INTDB.profile.INT_TTS_VOICE_01 end,
							set = function(_, val)
								INTDB.profile.INT_TTS_VOICE_01 = val

								addon.TextToSpeech.Script:Speak(val, "Interaction example text.")
							end,
							open = function() NS.Utils.SetPreventMouse(true) end,
							close = function() NS.Utils.SetPreventMouse(false) end,
							autoCloseList = false
						},
						Dropdown_TextToSpeech_Female = {
							name = L["Dropdown - Text To Speech / Voice / Female"],
							tooltipImage = "",
							tooltipText = L["Dropdown - Text To Speech / Voice / Female - Tooltip"],
							tooltipImageType = "Small",
							type = "Dropdown",
							values = function()
								local table, voices = {}, C_VoiceChat.GetTtsVoices()
								for _, voice in ipairs(voices) do
									table[voice.voiceID + 1] = voice.name
								end
								return table
							end,
							order = 19,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
							get = function() return INTDB.profile.INT_TTS_VOICE_02 end,
							set = function(_, val)
								INTDB.profile.INT_TTS_VOICE_02 = val

								addon.TextToSpeech.Script:Speak(val, "Interaction example text.")
							end,
							open = function() NS.Utils.SetPreventMouse(true) end,
							close = function() NS.Utils.SetPreventMouse(false) end,
							autoCloseList = false
						},
						Dropdown_TextToSpeech_Emote = {
							name = L["Dropdown - Text To Speech / Voice / Emote"],
							tooltipImage = "",
							tooltipText = L["Dropdown - Text To Speech / Voice / Emote - Tooltip"],
							tooltipImageType = "Small",
							type = "Dropdown",
							values = function()
								local table, voices = {}, C_VoiceChat.GetTtsVoices()
								for _, voice in ipairs(voices) do
									table[voice.voiceID + 1] = voice.name
								end
								return table
							end,
							order = 20,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
							get = function() return INTDB.profile.INT_TTS_EMOTE_VOICE end,
							set = function(_, val)
								INTDB.profile.INT_TTS_EMOTE_VOICE = val

								addon.TextToSpeech.Script:Speak(val, "Interaction example text.")
							end,
							open = function() NS.Utils.SetPreventMouse(true) end,
							close = function() NS.Utils.SetPreventMouse(false) end,
							autoCloseList = false
						},
						Checkbox_TextToSpeech_PlayerVoice = {
							name = L["Checkbox - Text To Speech / Player / Voice"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Text To Speech / Player / Voice - Tooltip"],
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 21,
							hidden = function() return false end,
							subcategory = 1,
							category = Playback,
							get = function() return INTDB.profile.INT_TTS_PLAYER end,
							set = function(_, val)
								INTDB.profile.INT_TTS_PLAYER = val
							end,
						},
						Dropdown_TextToSpeech_PlayerVoice_Voice = {
							name = L["Dropdown - Text To Speech / Player / Voice / Voice"],
							tooltipImage = "",
							tooltipText = L["Dropdown - Text To Speech / Player / Voice / Voice - Tooltip"],
							tooltipImageType = "Small",
							type = "Dropdown",
							values = function()
								local table, voices = {}, C_VoiceChat.GetTtsVoices()
								for _, voice in ipairs(voices) do
									table[voice.voiceID + 1] = voice.name
								end
								return table
							end,
							order = 22,
							hidden = function() return not INTDB.profile.INT_TTS_PLAYER end,
							locked = function() return false end,
							subcategory = 2,
							category = Playback,
							get = function() return INTDB.profile.INT_TTS_PLAYER_VOICE end,
							set = function(_, val)
								INTDB.profile.INT_TTS_PLAYER_VOICE = val

								addon.TextToSpeech.Script:Speak(val, "Interaction example text.")
							end,
							open = function() NS.Utils.SetPreventMouse(true) end,
							close = function() NS.Utils.SetPreventMouse(false) end,
							autoCloseList = false
						},
					}
				},
				Title_More = {
					name = L["Title - More"],
					type = "Title",
					order = 23,
					hidden = function() return false end,
					locked = function() return false end,
					category = Playback,
				},
				Group_More = {
					name = L["Title - More"],
					type = "Group",
					order = 24,
					hidden = function() return false end,
					locked = function() return false end,
					category = Playback,
					args = {
						Checkbox_MuteDialog = {
							name = L["Checkbox - Mute Dialog"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Mute Dialog - Tooltip"],
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 25,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = Playback,
							get = function() return INTDB.profile.INT_MUTE_DIALOG end,
							set = function(_, val)
								INTDB.profile.INT_MUTE_DIALOG = val
							end,
						},
					}
				}
			}
		}

		local Elements_Controls = {
			name = L["Tab - Controls"],
			type = "Group",
			order = 1,
			category = Controls,
			args = {
				Title_Warning = {
					name = "Leave NPC Interaction to Adjust Settings.",
					type = "Title",
					order = 2,
					hidden = function() return not addon.Interaction.Variables.Active end,
					category = Controls,
				},
				Title_Platform = {
					name = "Platform",
					type = "Title",
					order = 3,
					hidden = function() return addon.Interaction.Variables.Active end,
					locked = function() return false end,
					category = Controls,
				},
				Range_Platform = {
					name = "Platform",
					tooltipImage = "",
					tooltipText = "Requires Interface Reload to take effect.",
					tooltipImageType = "Small",
					type = "Range",
					min = 1,
					max = 3,
					step = 1,
					order = 4,
					hidden = function() return false end,
					locked = function() return addon.Interaction.Variables.Active end,
					subcategory = 0,
					category = Controls,
					valueText = function(val)
						if val == 1 then
							return "PC"
						elseif val == 2 then
							return "Playstation"
						elseif val == 3 then
							return "Xbox"
						end
					end,
					get = function() return INTDB.profile.INT_PLATFORM end,
					set = function(_, val)
						if not addon.Interaction.Variables.Active then
							if val ~= INTDB.profile.INT_PLATFORM then
								INTDB.profile.TutorialSettingsShown = false

								--------------------------------

								if val ~= addon.Variables.Platform then
									NS.Utils.ReloadPrompt()
								else
									NS.Utils.ClearPrompt()
								end
							end

							INTDB.profile.INT_PLATFORM = val
						end
					end
				},
				Group_PC = {
					name = "PC",
					type = "Group",
					order = 5,
					hidden = function() return INTDB.profile.INT_PLATFORM > 1 end,
					category = Controls,
					args = {
						Title_Keyboard = {
							name = "Keyboard",
							type = "Title",
							order = 6,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 1,
							category = Controls,
						},
						Checkbox_UseInteractKey = {
							name = "Use Interact Key",
							tooltipImage = "",
							tooltipText = "Use the interact key for Skip/Accept instead of Space. Multi-key combinations not supported.\n\nDefault: Off.",
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 7,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 1,
							category = Controls,
							get = function() return INTDB.profile.INT_USEINTERACTKEY end,
							set = function(_, val)
								if not addon.Interaction.Variables.Active then
									if INTDB.profile.INT_USEINTERACTKEY ~= val then
										CallbackRegistry:Trigger("SETTINGS_CONTROLS_CHANGED")
									end

									--------------------------------

									INTDB.profile.INT_USEINTERACTKEY = val
								end
							end,
						},
						Title_Mouse = {
							name = "Mouse",
							type = "Title",
							order = 8,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 1,
							category = Controls,
						},
						Checkbox_FlipMouseControls = {
							name = "Flip Mouse Controls",
							tooltipImage = NS.Variables.TOOLTIP_PATH .. "FlipMouse.png",
							tooltipText = "Flip Left and Right mouse controls.\n\nDefault: Off.",
							tooltipImageType = "Large",
							type = "Checkbox",
							order = 9,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 1,
							category = Controls,
							get = function() return INTDB.profile.INT_FLIPMOUSE end,
							set = function(_, val)
								if not addon.Interaction.Variables.Active then
									INTDB.profile.INT_FLIPMOUSE = val
								end
							end,
						}
					}
				},
				Group_Controller = {
					name = "Controller",
					type = "Group",
					order = 10,
					hidden = function() return INTDB.profile.INT_PLATFORM == 1 end,
					category = Controls,
					args = {
						-- Title_Controller = {
						-- 	name = "Controller",
						-- 	type = "Title",
						-- 	order = 11,
						-- 	hidden = function() return false end,
						-- 	locked = function() return addon.Interaction.Variables.Active end,
						-- 	subcategory = 1,
						-- 	category = Controls,
						-- },
					}
				}
			}
		}

		local Elements_Gameplay = {
			name = L["Tab - Gameplay"],
			type = "Group",
			order = 1,
			category = Gameplay,
			args = {
				Group_Waypoint = {
					name = "Waypoint",
					type = "Group",
					order = 2,
					category = Gameplay,
					hidden = function() return addon.Variables.IS_CLASSIC end,
					locked = function() return addon.Variables.IS_CLASSIC end,
					args = {
						Title_Waypoint = {
							name = L["Title - Waypoint"],
							type = "Title",
							order = 3,
							hidden = function() return false end,
							locked = function() return false end,
							category = Gameplay,
						},
						Checkbox_Waypoint = {
							name = L["Checkbox - Waypoint"],
							tooltipImage = NS.Variables.TOOLTIP_PATH .. "Waypoint.png",
							tooltipText = L["Checkbox - Waypoint - Tooltip"],
							tooltipImageType = "Large",
							type = "Checkbox",
							order = 4,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = Gameplay,
							get = function() return INTDB.profile.INT_WAYPOINT end,
							set = function(_, val)
								NS.Utils.ReloadPrompt()

								INTDB.profile.INT_WAYPOINT = val
							end,
						},
						Checkbox_Waypoint_SoundEffects = {
							name = L["Checkbox - Waypoint / Audio"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Waypoint / Audio - Tooltip"],
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 5,
							hidden = function() return not INTDB.profile.INT_WAYPOINT end,
							locked = function() return false end,
							subcategory = 1,
							category = Gameplay,
							get = function() return INTDB.profile.INT_WAYPOINT_AUDIO end,
							set = function(_, val)
								INTDB.profile.INT_WAYPOINT_AUDIO = val
							end,
						},
					}
				},
				Group_Readable = {
					name = "Readable Items",
					type = "Group",
					order = 6,
					category = Gameplay,
					args = {
						Title_Warning = {
							name = L["Warning - Leave ReadableUI"],
							type = "Title",
							order = 7,
							hidden = function() return not InteractionReadableUIFrame:IsVisible() end,
							locked = function() return false end,
							category = Gameplay,
						},
						Title_Readable = {
							name = L["Title - Readable"],
							type = "Title",
							order = 8,
							hidden = function() return false end,
							locked = function() return InteractionReadableUIFrame:IsVisible() end,
							category = Gameplay,
						},
						Checkbox_Readable = {
							name = L["Checkbox - Readable"],
							tooltipImage = NS.Variables.TOOLTIP_PATH .. "Readable.png",
							tooltipText = L["Checkbox - Readable - Tooltip"],
							tooltipImageType = "Large",
							type = "Checkbox",
							order = 9,
							hidden = function() return false end,
							locked = function() return InteractionReadableUIFrame:IsVisible() end,
							subcategory = 0,
							category = Gameplay,
							get = function() return INTDB.profile.INT_READABLE end,
							set = function(_, val)
								if not InteractionReadableUIFrame:IsVisible() then
									NS.Utils.ReloadPrompt()

									--------------------------------

									INTDB.profile.INT_READABLE = val
								end
							end,
						},
						Group_Readable = {
							name = "Readable",
							type = "Group",
							order = 10,
							hidden = function() return not INTDB.profile.INT_READABLE end,
							locked = function() return InteractionReadableUIFrame:IsVisible() end,
							category = Gameplay,
							args = {
								Group_Display = {
									name = "Display",
									type = "Group",
									order = 11,
									hidden = function() return not INTDB.profile.INT_READABLE end,
									locked = function() return InteractionReadableUIFrame:IsVisible() end,
									category = Gameplay,
									args = {
										Title_Display = {
											name = L["Title - Readable / Display"],
											type = "Title",
											order = 12,
											hidden = function() return not INTDB.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
										},
										Checkbox_Display_AlwaysShowItem = {
											name = L["Checkbox - Readable / Display / Always Show Item"],
											tooltipImage = "",
											tooltipText = L["Checkbox - Readable / Display / Always Show Item - Tooltip"],
											tooltipImageType = "Small",
											type = "Checkbox",
											order = 13,
											hidden = function() return not INTDB.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
											get = function() return INTDB.profile.INT_READABLE_DISPLAY_ALWAYS_SHOW_ITEM end,
											set = function(_, val)
												if not InteractionReadableUIFrame:IsVisible() then
													INTDB.profile.INT_READABLE_DISPLAY_ALWAYS_SHOW_ITEM = val
												end
											end,
										},
									}
								},
								Group_Cinematic = {
									name = "Cinematic",
									type = "Group",
									order = 14,
									hidden = function() return not INTDB.profile.INT_READABLE end,
									locked = function() return InteractionReadableUIFrame:IsVisible() end,
									category = Gameplay,
									args = {
										Title_Cinematic = {
											name = L["Title - Readable / Viewport"],
											type = "Title",
											order = 15,
											hidden = function() return not INTDB.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
										},
										Checkbox_Cinematic = {
											name = L["Checkbox - Readable / Viewport"],
											tooltipImage = "",
											tooltipText = L["Checkbox - Readable / Viewport - Tooltip"],
											tooltipImageType = "Small",
											type = "Checkbox",
											order = 16,
											hidden = function() return not INTDB.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
											get = function() return INTDB.profile.INT_READABLE_CINEMATIC end,
											set = function(_, val)
												if not InteractionReadableUIFrame:IsVisible() then
													INTDB.profile.INT_READABLE_CINEMATIC = val
												end
											end,
										},
									}
								},
								Group_Shortcuts = {
									name = "Shortcuts",
									type = "Group",
									order = 17,
									hidden = function() return not INTDB.profile.INT_READABLE end,
									locked = function() return InteractionReadableUIFrame:IsVisible() end,
									category = Gameplay,
									args = {
										Title_Shortcuts = {
											name = "Shortcuts",
											type = "Title",
											order = 18,
											hidden = function() return not INTDB.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
										},
										Checkbox_Shortcuts_MinimapIcon = {
											name = "Minimap Icon",
											tooltipImage = NS.Variables.TOOLTIP_PATH .. "Minimap.png",
											tooltipText = "Display an icon on the minimap for quick access to library.\n\nDefault: Off.",
											tooltipImageType = "Large",
											type = "Checkbox",
											order = 19,
											hidden = function() return not INTDB.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
											get = function() return INTDB.profile.INT_MINIMAP end,
											set = function(_, val)
												if not InteractionReadableUIFrame:IsVisible() then
													if INTDB.profile.INT_MINIMAP ~= val then
														CallbackRegistry:Trigger("SETTINGS_MINIMAP_CHANGED")
													end

													--------------------------------

													INTDB.profile.INT_MINIMAP = val
												end
											end
										}
									}
								},
								-- Group_Audiobook = {
								-- 	name = "Audiobook",
								-- 	type = "Group",
								-- 	order = 20,
								-- 	hidden = function() return not INTDB.profile.INT_READABLE end,
								-- 	locked = function() return InteractionReadableUIFrame:IsVisible() end,
								-- 	category = Gameplay,
								-- 	args = {
								-- 		Title_Audiobook = {
								-- 			name = "Audiobook",
								-- 			type = "Title",
								-- 			order = 21,
								-- 			hidden = function() return not INTDB.profile.INT_READABLE end,
								-- 			locked = function() return InteractionReadableUIFrame:IsVisible() end,
								-- 			subcategory = 1,
								-- 			category = Gameplay,
								-- 		},
								-- 		Range_Audiobook_Rate = {
								-- 			name = "Rate",
								-- 			tooltipImage = "",
								-- 			tooltipText = "Playback rate.\n\nDefault: 100%",
								-- 			tooltipImageType = "Small",
								-- 			type = "Range",
								-- 			min = -10,
								-- 			max = 10,
								-- 			step = .25,
								-- 			order = 22,
								-- 			hidden = function() return false end,
								-- 			locked = function() return InteractionReadableUIFrame:IsVisible() end,
								-- 			subcategory = 1,
								-- 			category = Playback,
								-- 			valueText = function(val)
								-- 				return string.format("%.0f", (val + 10) * 10) .. "%"
								-- 			end,
								-- 			get = function() return INTDB.profile.INT_READABLE_AUDIOBOOK_RATE end,
								-- 			set = function(_, val)
								-- 				if not InteractionReadableUIFrame:IsVisible() then
								-- 					INTDB.profile.INT_READABLE_AUDIOBOOK_RATE = val;
								-- 				end
								-- 			end
								-- 		},
								-- 		Range_Audiobook_Volume = {
								-- 			name = "Volume",
								-- 			tooltipImage = "",
								-- 			tooltipText = "Playback volume.\n\nDefault: 100%.",
								-- 			tooltipImageType = "Small",
								-- 			type = "Range",
								-- 			min = 0,
								-- 			max = 100,
								-- 			step = 10,
								-- 			order = 23,
								-- 			hidden = function() return false end,
								-- 			locked = function() return InteractionReadableUIFrame:IsVisible() end,
								-- 			subcategory = 1,
								-- 			category = Playback,
								-- 			valueText = function(val)
								-- 				return string.format("%.0f", val) .. "%"
								-- 			end,
								-- 			get = function() return INTDB.profile.INT_READABLE_AUDIOBOOK_VOLUME end,
								-- 			set = function(_, val)
								-- 				if not InteractionReadableUIFrame:IsVisible() then
								-- 					INTDB.profile.INT_READABLE_AUDIOBOOK_VOLUME = val
								-- 				end
								-- 			end
								-- 		},
								-- 		Dropdown_Audiobook_Voice = {
								-- 			name = "Narrator",
								-- 			tooltipImage = "",
								-- 			tooltipText = "Playback voice.",
								-- 			tooltipImageType = "Small",
								-- 			type = "Dropdown",
								-- 			values = function()
								-- 				local table, voices = {}, C_VoiceChat.GetTtsVoices()
								-- 				for _, voice in ipairs(voices) do
								-- 					table[voice.voiceID + 1] = voice.name
								-- 				end
								-- 				return table
								-- 			end,
								-- 			order = 24,
								-- 			hidden = function() return false end,
								-- 			locked = function() return InteractionReadableUIFrame:IsVisible() end,
								-- 			subcategory = 1,
								-- 			category = Playback,
								-- 			get = function() return INTDB.profile.INT_READABLE_AUDIOBOOK_VOICE end,
								-- 			set = function(_, val)
								-- 				if not InteractionReadableUIFrame:IsVisible() then
								-- 					INTDB.profile.INT_READABLE_AUDIOBOOK_VOICE = val

								-- 					local Voice = (INTDB.profile.INT_READABLE_AUDIOBOOK_VOICE or 1) - 1
								-- 					local Rate = (INTDB.profile.INT_READABLE_AUDIOBOOK_RATE or 1) * .25
								-- 					local Volume = (INTDB.profile.INT_READABLE_AUDIOBOOK_VOLUME or 100)

								-- 					C_VoiceChat.StopSpeakingText()
								-- 					addon.Libraries.AceTimer:ScheduleTimer(function()
								-- 						C_VoiceChat.SpeakText(Voice, "Interaction example text.", Enum.VoiceTtsDestination.LocalPlayback, Rate, Volume)
								-- 					end, 0)
								-- 				end
								-- 			end,
								-- 			open = function() NS.Utils.SetPreventMouse(true) end,
								-- 			close = function() NS.Utils.SetPreventMouse(false) end,
								-- 			autoCloseList = false
								-- 		},
								-- 	}
								-- }
							}
						}
					}
				},
				Group_Gameplay = {
					name = "Gameplay",
					type = "Group",
					order = 20,
					hidden = function() return false end,
					locked = function() return false end,
					category = Gameplay,
					args = {
						Title_Gameplay = {
							name = L["Title - Gameplay"],
							type = "Title",
							order = 21,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = Gameplay,
						},
						Checkbox_AutoSelectOptions = {
							name = L["Checkbox - Gameplay / Auto Select Option"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Gameplay / Auto Select Option - Tooltip"],
							type = "Checkbox",
							order = 22,
							hidden = function() return false end,
							subcategory = 0,
							category = Playback,
							get = function() return INTDB.profile.INT_AUTO_SELECT_OPTION end,
							set = function(_, val) INTDB.profile.INT_AUTO_SELECT_OPTION = val end,
						},
					}
				}
			}
		}

		local Elements_More = {
			name = L["Tab - More"],
			type = "Group",
			order = 1,
			category = More,
			args = {
				Title_Audio = {
					name = L["Title - Audio"],
					type = "Title",
					order = 2,
					hidden = function() return false end,
					locked = function() return false end,
					category = More,
				},
				Checkbox_Audio = {
					name = L["Checkbox - Audio"],
					tooltipImage = "",
					tooltipText = L["Checkbox - Audio - Tooltip"],
					tooltipImageType = "Small",
					type = "Checkbox",
					order = 3,
					hidden = function() return false end,
					locked = function() return false end,
					subcategory = 0,
					category = More,
					get = function() return INTDB.profile.INT_AUDIO end,
					set = function(_, val)
						INTDB.profile.INT_AUDIO = val
					end,
				},
				Title_Settings = {
					name = L["Title - Settings"],
					type = "Title",
					order = 4,
					hidden = function() return false end,
					locked = function() return false end,
					category = More,
				},
				Button_ResetSettings = {
					name = L["Checkbox - Settings / Reset Settings"],
					tooltipImage = "",
					tooltipText = L["Checkbox - Settings / Reset Settings - Tooltip"],
					tooltipImageType = "Small",
					type = "Button",
					order = 5,
					hidden = function() return false end,
					locked = function() return false end,
					subcategory = 0,
					category = More,
					set = function()
						NS.Utils.ConfirmationPrompt(L["Prompt - Reset Settings"], L["Prompt - Reset Settings Button 1"], L["Prompt - Reset Settings Button 2"], function()
							addon.Database:ResetSettings()

							--------------------------------

							ReloadUI()
						end)
					end,
				}
			}
		}

		--------------------------------

		ElementsToCreate = {}

		function NS.Data:ScanElements(tbl, returnTbl)
			local element = {}

			for key, value in pairs(tbl) do
				element[key] = value

				if key == "args" then
					for subKey, subValue in pairs(value) do
						local subElement = NS.Data:ScanElements(subValue, returnTbl)
						subElement["parent"] = element

						returnTbl[subElement.order] = subElement
					end
				end
			end

			return element
		end

		function NS.Data:InitalizeElements()
			for i = 1, #CategoryNames do
				ElementsToCreate[CategoryNames[i]] = {}
			end

			--------------------------------

			local appearance = NS.Data:ScanElements(Elements_Appearance, ElementsToCreate[CategoryNames[1]])
			local viewport = NS.Data:ScanElements(Elements_Effects, ElementsToCreate[CategoryNames[2]])
			local playback = NS.Data:ScanElements(Elements_Playback, ElementsToCreate[CategoryNames[3]])
			local controls = NS.Data:ScanElements(Elements_Controls, ElementsToCreate[CategoryNames[4]])
			local gameplay = NS.Data:ScanElements(Elements_Gameplay, ElementsToCreate[CategoryNames[5]])
			local more = NS.Data:ScanElements(Elements_More, ElementsToCreate[CategoryNames[6]])

			--------------------------------

			table.insert(ElementsToCreate[CategoryNames[1]], appearance.order, appearance)
			table.insert(ElementsToCreate[CategoryNames[2]], viewport.order, viewport)
			table.insert(ElementsToCreate[CategoryNames[3]], playback.order, playback)
			table.insert(ElementsToCreate[CategoryNames[4]], controls.order, controls)
			table.insert(ElementsToCreate[CategoryNames[5]], gameplay.order, gameplay)
			table.insert(ElementsToCreate[CategoryNames[6]], more.order, more)
		end

		function NS.Data:CreateElements()
			for category = 1, #CategoryNames do
				CategoryTabs[category].widgetPool = {}

				--------------------------------

				for elementToCreate = 1, #ElementsToCreate[CategoryNames[category]] do
					addon.Libraries.AceTimer:ScheduleTimer(function()
						local CurrentElement = ElementsToCreate[CategoryNames[category]][elementToCreate]

						if CurrentElement then
							-- GENERAL
							local Category = CurrentElement.category
							local Parent = CurrentElement.parent
							local Name = CurrentElement.name
							local Type = CurrentElement.type
							local Subcategory = CurrentElement.subcategory

							local TooltipText = CurrentElement.tooltipText
							local TooltipImage = CurrentElement.tooltipImage
							local TooltipImageType = CurrentElement.tooltipImageType
							local Hidden = CurrentElement.hidden
							local Locked = CurrentElement.locked

							-- VALUES
							local SetCriteria = CurrentElement.setCriteria

							local Set = CurrentElement.set
							local Get = CurrentElement.get

							-- TITLE
							local Icon = CurrentElement.icon

							-- RANGE
							local Min = CurrentElement.min
							local Max = CurrentElement.max
							local Step = CurrentElement.step
							local ValueText = CurrentElement.valueText
							local Grid = CurrentElement.grid

							-- DROPDOWN
							local Values = CurrentElement.values
							local Open = CurrentElement.open
							local Close = CurrentElement.close
							local AutoCloseList = CurrentElement.autoCloseList

							--------------------------------


							local function SetToParent(frame)
								if Parent then
									frame:SetParent(Parent.frame)
								end
							end

							local function SetType(frame)
								frame.Type = Type
							end

							local function SetWidget(frame)
								ElementsToCreate[CategoryNames[category]][elementToCreate]["frame"] = frame

								table.insert(CategoryTabs[category].widgetPool, frame)
							end

							--------------------------------

							if Type == "Group" then
								local frame
								frame = NS.Widgets:CreateGroup(
									Category,
									Hidden,
									Locked
								)

								SetToParent(frame)
								SetType(frame)
								SetWidget(frame)
							end

							if Type == "Title" then
								local frame
								frame = NS.Widgets:CreateTitle(
									Category,
									Icon,
									17.5,
									Subcategory,
									Hidden,
									Locked
								)
								frame.label:SetText(Name)

								SetToParent(frame)
								SetType(frame)
								SetWidget(frame)
							end

							if Type == "Button" then
								local frame
								frame = NS.Widgets:CreateButton(
									Category,
									function(...)
										if SetCriteria and not SetCriteria(...) then
											return
										end

										--------------------------------

										Set(...)

										--------------------------------

										CallbackRegistry:Trigger("SETTING_CHANGED", frame)
									end,
									Subcategory,
									TooltipText,
									TooltipImage,
									TooltipImageType,
									Hidden,
									Locked
								)
								frame.button:SetText(Name)

								SetToParent(frame)
								SetType(frame)
								SetWidget(frame)
							end

							if Type == "Checkbox" then
								local frame
								frame = NS.Widgets:CreateCheckbox(
									Category,
									function(...)
										if SetCriteria and not SetCriteria(...) then
											return
										end

										--------------------------------

										Set(...)

										--------------------------------

										CallbackRegistry:Trigger("SETTING_CHANGED", frame)
									end,
									Get,
									Subcategory,
									TooltipText,
									TooltipImage,
									TooltipImageType,
									Hidden,
									Locked
								)
								frame.label:SetText(Name)

								SetToParent(frame)
								SetType(frame)
								SetWidget(frame)
							end

							if Type == "Range" then
								local frame
								frame = NS.Widgets:CreateSlider(
									Category,
									Step,
									Min,
									Max,
									Grid,
									ValueText,
									function(...)
										if SetCriteria and not SetCriteria(...) then
											return
										end

										--------------------------------

										Set(...)

										--------------------------------

										CallbackRegistry:Trigger("SETTING_CHANGED", frame)
									end,
									Get,
									Subcategory,
									TooltipText,
									TooltipImage,
									TooltipImageType,
									Hidden,
									Locked
								)
								frame.label:SetText(Name)

								SetToParent(frame)
								SetType(frame)
								SetWidget(frame)
							end

							if Type == "Dropdown" then
								local frame
								frame = NS.Widgets:CreateDropdown(
									Category,
									Values,
									Open,
									Close,
									AutoCloseList,
									function(...)
										if SetCriteria and not SetCriteria(...) then
											return
										end

										--------------------------------

										Set(...)

										--------------------------------

										CallbackRegistry:Trigger("SETTING_CHANGED", frame)
									end,
									Get,
									Subcategory,
									TooltipText,
									TooltipImage,
									TooltipImageType,
									Hidden,
									Locked
								)
								frame.label:SetText(Name)

								SetToParent(frame)
								SetType(frame)
								SetWidget(frame)
							end
						end
					end, elementToCreate / 25)
				end
			end
		end
	end

	--------------------------------
	-- SETUP
	--------------------------------

	do -- DATA
		NS.Data:InitalizeElements()
		addon.Libraries.AceTimer:ScheduleTimer(function()
			NS.Data:CreateElements()
		end, .5)
	end

	do -- LAYOUT
		addon.Libraries.AceTimer:ScheduleTimer(function()
			InteractionSettingsFrame.Sidebar.Legend.Update()
			InteractionSettingsFrame.Content.ScrollFrame.Update()
		end, .5)
	end
end
