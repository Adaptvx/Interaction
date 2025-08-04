---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales
local NS = addon.SettingsUI; addon.SettingsUI = NS

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

			do -- OPTIONS
				local function CreateOption(name, index)
					local frame = NS.Widgets:CreateTabButton(InteractionSettingsFrame.Sidebar.LegendScrollChildFrame,
						function(button)
							NS.Script:SelectTab(button, index)
						end
					)
					table.insert(Widgets, frame)
					frame.Button:SetText(name)
					frame.Button.SavedText = name

					return frame
				end

				--------------------------------

				CreateOption(L["Tab - Appearance"], 1)
				CreateOption(L["Tab - Effects"], 2)
				CreateOption(L["Tab - Playback"], 3)
				CreateOption(L["Tab - Controls"], 4)
				CreateOption(L["Tab - Gameplay"], 5)
				CreateOption(L["Tab - More"], 6)

				--------------------------------

				InteractionSettingsFrame.Tab_Appearance = InteractionSettingsFrame.Content.ScrollFrame.CreateTab(1)
				InteractionSettingsFrame.Tab_Effects = InteractionSettingsFrame.Content.ScrollFrame.CreateTab(2)
				InteractionSettingsFrame.Tab_Playback = InteractionSettingsFrame.Content.ScrollFrame.CreateTab(3)
				InteractionSettingsFrame.Tab_Controls = InteractionSettingsFrame.Content.ScrollFrame.CreateTab(4)
				InteractionSettingsFrame.Tab_Gameplay = InteractionSettingsFrame.Content.ScrollFrame.CreateTab(5)
				InteractionSettingsFrame.Tab_More = InteractionSettingsFrame.Content.ScrollFrame.CreateTab(6)
			end

			--------------------------------

			InteractionSettingsFrame.Sidebar.Legend.widgetPool = Widgets
		end

		--------------------------------

		InteractionSettingsFrame.Sidebar.Legend.CreateOptions()
	end

	do -- CONTENT
		do -- TEMPLATES
			-- Button = {
			-- 	name = "Default",
			-- 	tooltipImage = "",
			-- 	tooltipText = "Placeholder",
			-- 	tooltipTextDynamic = nil,
			-- 	tooltipImageType = "Small",
			-- 	type = "Button",
			-- 	order = 1,
			-- 	hidden = function() return false end,
			-- 	locked = function() return false end,
			-- 	subcategory = 0,
			-- 	category = Default,
			-- 		setCriteria = function() return true end,
			-- 	set = function() print("Click") end,
			-- }

			-- Title = {
			-- 	name = "Default",
			-- 	tooltipImage = "",
			-- 	tooltipText = nil,
			-- 	tooltipTextDynamic = nil,
			-- 	tooltipImageSize = nil,
			-- 	type = "Title",
			-- 	order = 1,
			-- 	isSubtitle = false,
			-- 	hidden = function() return false end,
			-- 	locked = function() return false end,
			-- 	category = Default,
			-- }

			-- Spacer = {
			-- 	name = "Default",
			-- 	type = "Spacer",
			-- 	order = 1,
			-- 	spacing = 1,
			-- 	hidden = function() return false end,
			-- 	locked = function() return false end,
			-- 	category = Default,
			-- }

			-- Checkbox = {
			-- 	name = "Default",
			-- 	tooltipImage = "",
			-- 	tooltipText = "Placeholder",
			-- 	tooltipTextDynamic = nil,
			-- 	tooltipImageType = "Small",
			-- 	type = "Checkbox",
			-- 	order = 1,
			-- 	hidden = function() return false end,
			-- 	locked = function() return false end,
			-- 	subcategory = 0,
			-- 	category = Default,
			-- 	get = function() return variable end,
			-- 	setCriteria = function() return true end,
			-- 	set = function(_, val)
			-- 		variable = val
			-- 	end,
			-- }

			-- Range = {
			-- 	name = "Default",
			-- 	tooltipImage = "",
			-- 	tooltipText = "Placeholder",
			-- 	tooltipTextDynamic = nil,
			-- 	tooltipImageType = "Small",
			-- 	type = "Range",
			-- 	min = 0,
			-- 	max = 1,
			-- 	step = .5,
			-- 	order = 1,
			-- 	hidden = function() return false end,
			-- 	locked = function() return false end,
			-- 	subcategory = 0,
			-- 	category = Default,
			-- 	valueText = nil,
			-- 	grid = false,
			-- 	get = function() return variable end,
			-- 	setCriteria = function() return true end,
			-- 	set = function(_, val) variable = val; end
			-- }

			-- Dropdown = {
			-- 	name = "Default",
			-- 	tooltipImage = "",
			-- 	tooltipText = "Placeholder",
			-- 	tooltipTextDynamic = nil,
			-- 	tooltipImageType = "Small",
			-- 	type = "Dropdown",
			-- 	values = {
			-- 		[1] = {
			-- 			name = "Value1"
			-- 		},
			-- 		[2] = {
			-- 			name = "Value2"
			-- 		}
			-- 	},
			-- 	order = 1,
			-- 	hidden = function() return false end,
			-- 	locked = function() return false end,
			-- 	subcategory = 0,
			-- 	category = Default,
			-- 	get = function() return variable end,
			-- 	setCriteria = function() return true end,
			-- 	set = function(_, val) variable = val end,
			-- 	open = function() print("List Opened") end,
			-- 	close = function() print("List Closed") end,
			-- 	autoCloseList = true
			-- }

			-- Keybind = {
			-- 	name = "Default",
			-- 	tooltipImage = "",
			-- 	tooltipText = "Placeholder",
			-- 	tooltipTextDynamic = nil,
			-- 	tooltipImageType = "Small",
			-- 	type = "Keybind",
			-- 	order = 1,
			-- 	hidden = function() return false end,
			-- 	locked = function() return variable end,
			-- 	subcategory = 1,
			-- 	category = Controls,
			-- 	get = function() variable end,
			-- 	set = function(_, val) variable = val end,
			-- },
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
					tooltipTextDynamic = nil,
					tooltipImageType = "Large",
					type = "Range",
					min = 1,
					max = 3,
					step = 1,
					order = 3,
					hidden = function() return false end,
					subcategory = 0,
					category = Appearance,
					valueText = function(val)
						if val == 1 then
							return L["Range - Main Theme - Day"]
						elseif val == 2 then
							return L["Range - Main Theme - Night"]
						elseif val == 3 then
							return L["Range - Main Theme - Dynamic"]
						end
					end,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_MAIN_THEME end,
					set = function(_, val)
						if val ~= addon.Database.DB_GLOBAL.profile.INT_MAIN_THEME then
							addon.Libraries.AceTimer:ScheduleTimer(function()
								CallbackRegistry:Trigger("THEME_UPDATE")
							end, .125)
						end

						addon.Database.DB_GLOBAL.profile.INT_MAIN_THEME = val
					end
				},
				Range_DialogTheme = {
					name = L["Range - Dialog Theme"],
					tooltipImage = NS.Variables.TOOLTIP_PATH .. "Theme-Dialog.png",
					tooltipText = L["Range - Dialog Theme - Tooltip"],
					tooltipTextDynamic = nil,
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
							return L["Range - Dialog Theme - Auto"]
						elseif val == 2 then
							return L["Range - Dialog Theme - Day"]
						elseif val == 3 then
							return L["Range - Dialog Theme - Night"]
						elseif val == 4 then
							return L["Range - Dialog Theme - Rustic"]
						end
					end,
					grid = true,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_DIALOG_THEME end,
					set = function(_, val)
						if val ~= addon.Database.DB_GLOBAL.profile.INT_DIALOG_THEME then
							addon.Libraries.AceTimer:ScheduleTimer(function()
								CallbackRegistry:Trigger("THEME_UPDATE")
							end, 0)
						end

						addon.Database.DB_GLOBAL.profile.INT_DIALOG_THEME = val
					end
				},
				Title_Appearance = {
					name = L["Title - Appearance"],
					type = "Title",
					order = 5,
					hidden = function() return false end,
					category = Appearance,
				},
				Range_UIDirection = {
					name = L["Range - UIDirection"],
					tooltipImage = NS.Variables.TOOLTIP_PATH .. "UIDirection.png",
					tooltipText = L["Range - UIDirection - Tooltip"],
					tooltipTextDynamic = nil,
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
							return L["Range - UIDirection - Left"]
						elseif val == 2 then
							return L["Range - UIDirection - Right"]
						end
					end,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION end,
					set = function(_, val)
						addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION = val

						CallbackRegistry:Trigger("SETTINGS_UIDIRECTION_CHANGED")
					end
				},
				Range_UIDirection_Dialog = {
					name = L["Range - UIDirection / Dialog"],
					tooltipImage = NS.Variables.TOOLTIP_PATH .. "UIDirection-Dialog.png",
					tooltipText = L["Range - UIDirection / Dialog - Tooltip"],
					tooltipTextDynamic = nil,
					tooltipImageType = "Large",
					type = "Range",
					min = 1,
					max = 3,
					step = 1,
					order = 7,
					hidden = function() return false end,
					subcategory = 1,
					category = Appearance,
					valueText = function(val)
						if val == 1 then
							return L["Range - UIDirection / Dialog - Top"]
						elseif val == 2 then
							return L["Range - UIDirection / Dialog - Center"]
						elseif val == 3 then
							return L["Range - UIDirection / Dialog - Bottom"]
						end
					end,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION_DIALOG end,
					set = function(_, val)
						addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION_DIALOG = val

						CallbackRegistry:Trigger("SETTINGS_UIDIRECTION_CHANGED")
					end
				},
				Checkbox_UIDirection_Dialog_Mirror = {
					name = L["Checkbox - UIDirection / Dialog / Mirror"],
					tooltipImage = NS.Variables.TOOLTIP_PATH .. "UIDirection-Dialog-Mirror.png",
					tooltipText = L["Checkbox - UIDirection / Dialog / Mirror - Tooltip"],
					tooltipTextDynamic = nil,
					tooltipImageType = "Large",
					type = "Checkbox",
					order = 8,
					hidden = function() return false end,
					subcategory = 2,
					category = Appearance,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION_DIALOG_MIRROR end,
					set = function(_, val)
						addon.Database.DB_GLOBAL.profile.INT_UIDIRECTION_DIALOG_MIRROR = val

						CallbackRegistry:Trigger("SETTINGS_UIDIRECTION_CHANGED")
					end,
				},
				Range_QuestFrameSize = {
					name = L["Range - Quest Frame Size"],
					tooltipImage = NS.Variables.TOOLTIP_PATH .. "QuestFrameSize.png",
					tooltipText = L["Range - Quest Frame Size - Tooltip"],
					tooltipTextDynamic = nil,
					tooltipImageType = "Large",
					type = "Range",
					min = 1,
					max = 4,
					step = 1,
					order = 9,
					hidden = function() return false end,
					subcategory = 0,
					category = Appearance,
					valueText = function(val)
						if val == 1 then
							return L["Range - Quest Frame Size - Small"]
						elseif val == 2 then
							return L["Range - Quest Frame Size - Medium"]
						elseif val == 3 then
							return L["Range - Quest Frame Size - Large"]
						elseif val == 4 then
							return L["Range - Quest Frame Size - Extra Large"]
						end
					end,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_QUESTFRAME_SIZE end,
					set = function(_, val)
						addon.Database.DB_GLOBAL.profile.INT_QUESTFRAME_SIZE = val

						--------------------------------

						CallbackRegistry:Trigger("SETTINGS_QUESTFRAME_SIZE_CHANGED")
					end
				},
				Range_TextSize = {
					name = L["Range - Text Size"],
					tooltipImage = "",
					tooltipText = L["Range - Text Size - Tooltip"],
					tooltipTextDynamic = nil,
					tooltipImageType = "Small",
					type = "Range",
					min = 10,
					max = 25,
					step = .5,
					order = 10,
					hidden = function() return false end,
					subcategory = 0,
					category = Appearance,
					valueText = function(val)
						return string.format("%.1f", val) .. " PT"
					end,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE end,
					set = function(_, val)
						addon.Database.DB_GLOBAL.profile.INT_CONTENT_SIZE = val

						CallbackRegistry:Trigger("SETTINGS_CONTENT_SIZE_CHANGED")
					end
				},
				Title_Dialog = {
					name = L["Title - Dialog"],
					type = "Title",
					order = 11,
					hidden = function() return false end,
					category = Appearance,
				},
				Checkbox_Dialog_Title_ProgressBar = {
					name = L["Checkbox - Dialog / Title / Progress Bar"],
					tooltipImage = NS.Variables.TOOLTIP_PATH .. "Title-ProgressBar.png",
					tooltipText = L["Checkbox - Dialog / Title / Progress Bar - Tooltip"],
					tooltipTextDynamic = nil,
					tooltipImageType = "Large",
					type = "Checkbox",
					order = 12,
					hidden = function() return false end,
					locked = function() return false end,
					subcategory = 0,
					category = Appearance,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_PROGRESS_SHOW end,
					set = function(_, val)
						addon.Database.DB_GLOBAL.profile.INT_PROGRESS_SHOW = val

						CallbackRegistry:Trigger("SETTINGS_TITLE_PROGRESS_VISIBILITY_CHANGED")
					end,
				},
				Range_Dialog_Title_Alpha = {
					name = L["Range - Dialog / Title / Text Alpha"],
					tooltipImage = "",
					tooltipText = L["Range - Dialog / Title / Text Alpha - Tooltip"],
					tooltipTextDynamic = nil,
					tooltipImageType = "Small",
					type = "Range",
					min = 0,
					max = 1,
					step = .1,
					order = 13,
					hidden = function() return false end,
					locked = function() return false end,
					subcategory = 0,
					category = Appearance,
					valueText = function(val)
						return string.format("%.0f", (val * 100)) .. "%"
					end,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_TITLE_ALPHA end,
					set = function(_, val)
						addon.Database.DB_GLOBAL.profile.INT_TITLE_ALPHA = val

						CallbackRegistry:Trigger("SETTINGS_TITLE_ALPHA_CHANGED")
					end
				},
				Range_Dialog_Content_Preview_Alpha = {
					name = L["Range - Dialog / Content Preview Alpha"],
					tooltipImage = "",
					tooltipText = L["Range - Dialog / Content Preview Alpha - Tooltip"],
					tooltipTextDynamic = nil,
					tooltipImageType = "Small",
					type = "Range",
					min = 0,
					max = 1,
					step = .1,
					order = 14,
					hidden = function() return false end,
					subcategory = 0,
					category = Appearance,
					valueText = function(val)
						return string.format("%.0f", (val * 100)) .. "%"
					end,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_CONTENT_PREVIEW_ALPHA end,
					set = function(_, val)
						addon.Database.DB_GLOBAL.profile.INT_CONTENT_PREVIEW_ALPHA = val
					end
				},
				Title_Gossip = {
					name = L["Title - Gossip"],
					type = "Title",
					order = 15,
					hidden = function() return false end,
					category = Appearance,
				},
				Checkbox_Gossip_AlwaysShowGossip = {
					name = L["Checkbox - Always Show Gossip Frame"],
					tooltipImage = "",
					tooltipText = L["Checkbox - Always Show Gossip Frame - Tooltip"],
					tooltipTextDynamic = nil,
					tooltipImageType = "Small",
					type = "Checkbox",
					order = 16,
					hidden = function() return false end,
					locked = function() return addon.Interaction.Variables.Active end,
					subcategory = 0,
					category = Appearance,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_ALWAYS_SHOW_GOSSIP end,
					set = function(_, val)
						if not addon.Variables.Active then
							addon.Database.DB_GLOBAL.profile.INT_ALWAYS_SHOW_GOSSIP = val
						end
					end
				},
				Title_Quest = {
					name = L["Title - Quest"],
					type = "Title",
					order = 17,
					hidden = function() return false end,
					category = Appearance,
				},
				Checkbox_Quest_AlwaysShowQuest = {
					name = L["Checkbox - Always Show Quest Frame"],
					tooltipImage = "",
					tooltipText = L["Checkbox - Always Show Quest Frame - Tooltip"],
					tooltipTextDynamic = nil,
					tooltipImageType = "Small",
					type = "Checkbox",
					order = 18,
					hidden = function() return false end,
					locked = function() return addon.Interaction.Variables.Active end,
					subcategory = 0,
					category = Appearance,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_ALWAYS_SHOW_QUEST end,
					set = function(_, val)
						if not addon.Interaction.Variables.Active then
							addon.Database.DB_GLOBAL.profile.INT_ALWAYS_SHOW_QUEST = val
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
					tooltipTextDynamic = nil,
					tooltipImageType = "Small",
					type = "Checkbox",
					order = 4,
					hidden = function() return false end,
					locked = function() return addon.Interaction.Variables.Active end,
					subcategory = 0,
					category = Effects,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_HIDEUI end,
					set = function(_, val)
						addon.Database:PreventSetVariableDuringCinematicMode("INT_HIDEUI", val)
					end,
				},
				Range_Cinematic = {
					name = L["Range - Cinematic"],
					tooltipImage = "",
					tooltipText = L["Range - Cinematic - Tooltip"],
					tooltipTextDynamic = nil,
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
							return L["Range - Cinematic - None"]
						elseif val == 2 then
							return L["Range - Cinematic - Full"]
						elseif val == 3 then
							return L["Range - Cinematic - Balanced"]
						elseif val == 4 then
							return L["Range - Cinematic - Custom"]
						end
					end,
					grid = true,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_PRESET end,
					set = function(_, val)
						addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_PRESET", val)

						addon.Database:SetDynamicCinematicVariables()
					end
				},
				Group_Custom = {
					name = "Custom",
					type = "Group",
					order = 6,
					hidden = function() return (addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_PRESET < 4) end,
					locked = function() return addon.Interaction.Variables.Active end,
					category = Effects,
					args = {
						Checkbox_Zoom = {
							name = L["Checkbox - Zoom"],
							tooltipImage = "",
							tooltipText = "",
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 7,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 1,
							category = Effects,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ZOOM", val)
							end,
						},
						Range_Zoom_MinDistance = {
							name = L["Range - Zoom / Min Distance"],
							tooltipImage = "",
							tooltipText = L["Range - Zoom / Min Distance - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Range",
							min = 1,
							max = 39,
							step = 1,
							order = 8,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							valueText = function(val)
								return string.format("%.1f", val)
							end,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_DISTANCE_MIN end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ZOOM_DISTANCE_MIN", math.min(val, addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_DISTANCE_MAX)) end
						},
						Range_Zoom_MaxDistance = {
							name = L["Range - Zoom / Max Distance"],
							tooltipImage = "",
							tooltipText = L["Range - Zoom / Max Distance - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Range",
							min = 1,
							max = 39,
							step = 1,
							order = 9,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							valueText = function(val)
								return string.format("%.1f", val)
							end,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_DISTANCE_MAX end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ZOOM_DISTANCE_MAX", math.max(val, addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_DISTANCE_MIN)) end
						},
						Checkbox_Zoom_Pitch = {
							name = L["Checkbox - Zoom / Pitch"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Zoom Pitch - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 10,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_PITCH end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ZOOM_PITCH", val)
							end,
						},
						Range_Zoom_Pitch_Level = {
							name = L["Range - Zoom / Pitch / Level"],
							tooltipImage = "",
							tooltipText = L["Range - Zoom Pitch / Level - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Range",
							min = 1,
							max = 89,
							step = 1,
							order = 11,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM or not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_PITCH end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 3,
							category = Effects,
							valueText = function(val)
								return string.format("%.1f", val)
							end,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_PITCH_LEVEL end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ZOOM_PITCH_LEVEL", val); end
						},
						Checkbox_FieldOfView = {
							name = L["Checkbox - Zoom / Field Of View"],
							tooltipImage = "",
							tooltipText = "",
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 12,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ZOOM_FOV end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ZOOM_FOV", val)
							end,
						},
						Checkbox_Pan = {
							name = L["Checkbox - Pan"],
							tooltipImage = "",
							tooltipText = "",
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 13,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 1,
							category = Effects,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_PAN end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_PAN", val)
							end,
						},
						Range_Pan_Speed = {
							name = L["Range - Pan / Speed"],
							tooltipImage = "",
							tooltipText = L["Range - Pan / Speed - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Range",
							min = 0,
							max = 5,
							step = .25,
							order = 14,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_PAN end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							valueText = function(val)
								return string.format("%.0f", val * 100) .. "%"
							end,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_PAN_SPEED end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_PAN_SPEED", val); end
						},
						Checkbox_DynamicCamera = {
							name = L["Checkbox - Dynamic Camera"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Dynamic Camera - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 15,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 1,
							category = Effects,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM", val)
							end,
						},
						Checkbox_DynamicCamera_SideView = {
							name = L["Checkbox - Dynamic Camera / Side View"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Dynamic Camera / Side View - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 16,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_SIDE end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_SIDE", val)
							end,
						},
						Range_DynamicCamera_SideView_Strength = {
							name = L["Range - Dynamic Camera / Side View / Strength"],
							tooltipImage = "",
							tooltipText = L["Range - Dynamic Camera / Side View / Strength - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Range",
							min = 0,
							max = 3,
							step = .25,
							order = 17,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM or not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_SIDE end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 3,
							category = Effects,
							valueText = function(val)
								return string.format("%.0f", val * 100) .. "%"
							end,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_SIDE_STRENGTH end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_SIDE_STRENGTH", val); end
						},
						Checkbox_DynamicCamera_Offset = {
							name = L["Checkbox - Dynamic Camera / Offset"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Dynamic Camera / Offset - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 18,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_OFFSET end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_OFFSET", val)
							end,
						},
						Range_DynamicCamera_Offset_Strength = {
							name = L["Range - Dynamic Camera / Offset / Strength"],
							tooltipImage = "",
							tooltipText = L["Range - Dynamic Camera / Offset / Strength - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Range",
							min = 0,
							max = 25,
							step = .25,
							order = 19,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM or not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_OFFSET end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 3,
							category = Effects,
							valueText = function(val)
								return string.format("%.0f", val * 10) .. "%"
							end,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_OFFSET_STRENGTH", val); end
						},
						Checkbox_DynamicCamera_Focus = {
							name = L["Checkbox - Dynamic Camera / Focus"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Dynamic Camera / Focus - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 20,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_FOCUS end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_FOCUS", val)
							end,
						},
						Range_DynamicCamera_Focus_Strength = {
							name = L["Range - Dynamic Camera / Focus / Strength"],
							tooltipImage = "",
							tooltipText = L["Range - Dynamic Camera / Focus / Strength - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Range",
							min = 0,
							max = 1,
							step = .1,
							order = 21,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM or not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_FOCUS end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 3,
							category = Effects,
							valueText = function(val)
								return string.format("%.0f", val * 100) .. "%"
							end,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH end,
							set = function(_, val) addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_FOCUS_STRENGTH", val); end
						},
						Checkbox_DynamicCamera_Focus_X = {
							name = L["Checkbox - Dynamic Camera / Focus / X"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Dynamic Camera / Focus / X - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 22,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM or not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_FOCUS end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 3,
							category = Effects,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_FOCUS_X end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_FOCUS_X", val)
							end,
						},
						Checkbox_DynamicCamera_Focus_Y = {
							name = L["Checkbox - Dynamic Camera / Focus / Y"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Dynamic Camera / Focus / Y - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 23,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM or not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_FOCUS end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 3,
							category = Effects,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_ACTIONCAM_FOCUS_Y end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_ACTIONCAM_FOCUS_Y", val)
							end,
						},
						Checkbox_Vignette = {
							name = L["Checkbox - Vignette"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Vignette - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 24,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 1,
							category = Effects,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_VIGNETTE end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_VIGNETTE", val)
							end,
						},
						Checkbox_Vignette_Gradient = {
							name = L["Checkbox - Vignette / Gradient"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Vignette / Gradient - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 25,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_VIGNETTE end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 2,
							category = Effects,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CINEMATIC_VIGNETTE_GRADIENT end,
							set = function(_, val)
								addon.Database:PreventSetVariableDuringCinematicMode("INT_CINEMATIC_VIGNETTE_GRADIENT", val)
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
					tooltipTextDynamic = nil,
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
					get = function() return addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_SPEED end,
					set = function(_, val) addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_SPEED = val; end
				},
				Checkbox_DynamicPlayback = {
					name = L["Checkbox - Dynamic Playback"],
					tooltipImage = "",
					tooltipText = L["Checkbox - Dynamic Playback - Tooltip"],
					tooltipTextDynamic = nil,
					tooltipImageType = "Small",
					type = "Checkbox",
					order = 4,
					hidden = function() return false end,
					subcategory = 0,
					category = Playback,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_PUNCTUATION_PAUSING end,
					set = function(_, val) addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_PUNCTUATION_PAUSING = val end,
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
					tooltipTextDynamic = nil,
					tooltipImageType = "Small",
					type = "Checkbox",
					order = 6,
					hidden = function() return false end,
					subcategory = 0,
					category = Playback,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS end,
					set = function(_, val)
						addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS = val
					end,
				},
				Group_AutoProgress = {
					name = L["Title - Auto Progress"],
					type = "Group",
					order = 7,
					hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS end,
					category = Playback,
					args = {
						Checkbox_AutoProgress_AutoCloseDialog = {
							name = L["Checkbox - Auto Close Dialog"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Auto Close Dialog - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 8,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS end,
							subcategory = 1,
							category = Playback,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS_AUTOCLOSE end,
							set = function(_, val)
								addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS_AUTOCLOSE = val
							end,
						},
						Range_AutoProgress_Delay = {
							name = L["Range - Auto Progress / Delay"],
							tooltipImage = "",
							tooltipText = L["Range - Auto Progress / Delay - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Range",
							min = 0,
							max = 5,
							step = .5,
							order = 9,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS end,
							subcategory = 1,
							category = Playback,
							valueText = function(val) return string.format("%.1f", val) .. "s" end,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS_DELAY end,
							set = function(_, val) addon.Database.DB_GLOBAL.profile.INT_PLAYBACK_AUTOPROGRESS_DELAY = val; end
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
					tooltipTextDynamic = nil,
					tooltipImageType = "Small",
					type = "Checkbox",
					order = 11,
					hidden = function() return false end,
					locked = function() return false end,
					subcategory = 0,
					category = Playback,
					get = function() return addon.Database.DB_GLOBAL.profile.INT_TTS end,
					set = function(_, val)
						addon.Database.DB_GLOBAL.profile.INT_TTS = val
					end,
				},
				Group_TextToSpeech = {
					name = L["Title - Text To Speech"],
					type = "Group",
					order = 12,
					hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_TTS end,
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
						Checkbox_TextToSpeech_Quest = {
							name = L["Checkbox - Text To Speech / Quest"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Text To Speech / Quest - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 14,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_TTS_QUEST end,
							set = function(_, val)
								addon.Database.DB_GLOBAL.profile.INT_TTS_QUEST = val
							end,
						},
						Checkbox_TextToSpeech_Gossip = {
							name = L["Checkbox - Text To Speech / Gossip"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Text To Speech / Gossip - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 15,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_TTS_GOSSIP end,
							set = function(_, val)
								addon.Database.DB_GLOBAL.profile.INT_TTS_GOSSIP = val
							end,
						},
						Range_TextToSpeech_Rate = {
							name = L["Range - Text To Speech / Rate"],
							tooltipImage = "",
							tooltipText = L["Range - Text To Speech / Rate - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Range",
							min = -10,
							max = 10,
							step = .25,
							order = 16,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
							valueText = function(val)
								return string.format("%.0f", (val + 10) * 10) .. "%"
							end,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_TTS_SPEED end,
							set = function(_, val) addon.Database.DB_GLOBAL.profile.INT_TTS_SPEED = val; end
						},
						Range_TextToSpeech_Volume = {
							name = L["Range - Text To Speech / Volume"],
							tooltipImage = "",
							tooltipText = L["Range - Text To Speech / Volume - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Range",
							min = 0,
							max = 100,
							step = 10,
							order = 17,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
							valueText = function(val)
								return string.format("%.0f", val) .. "%"
							end,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_TTS_VOLUME end,
							set = function(_, val) addon.Database.DB_GLOBAL.profile.INT_TTS_VOLUME = val; end
						},
						Title_TextToSpeech_Voice = {
							name = L["Title - Text To Speech / Voice"],
							type = "Title",
							order = 18,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
						},
						Dropdown_TextToSpeech_Neutral = {
							name = L["Dropdown - Text To Speech / Voice / Neutral"],
							tooltipImage = "",
							tooltipText = L["Dropdown - Text To Speech / Voice / Neutral - Tooltip"],
							tooltipTextDynamic = nil,
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
							get = function() return addon.Database.DB_GLOBAL.profile.INT_TTS_VOICE end,
							set = function(_, val)
								addon.Database.DB_GLOBAL.profile.INT_TTS_VOICE = val

								addon.TextToSpeech.Script:PlayConfiguredTTS(val, "Interaction example text.")
							end,
							open = function() NS.Utils.SetPreventMouse(true) end,
							close = function() NS.Utils.SetPreventMouse(false) end,
							autoCloseList = false
						},
						Dropdown_TextToSpeech_Male = {
							name = L["Dropdown - Text To Speech / Voice / Male"],
							tooltipImage = "",
							tooltipText = L["Dropdown - Text To Speech / Voice / Male - Tooltip"],
							tooltipTextDynamic = nil,
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
							get = function() return addon.Database.DB_GLOBAL.profile.INT_TTS_VOICE_01 end,
							set = function(_, val)
								addon.Database.DB_GLOBAL.profile.INT_TTS_VOICE_01 = val

								addon.TextToSpeech.Script:PlayConfiguredTTS(val, "Interaction example text.")
							end,
							open = function() NS.Utils.SetPreventMouse(true) end,
							close = function() NS.Utils.SetPreventMouse(false) end,
							autoCloseList = false
						},
						Dropdown_TextToSpeech_Female = {
							name = L["Dropdown - Text To Speech / Voice / Female"],
							tooltipImage = "",
							tooltipText = L["Dropdown - Text To Speech / Voice / Female - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Dropdown",
							values = function()
								local table, voices = {}, C_VoiceChat.GetTtsVoices()
								for _, voice in ipairs(voices) do
									table[voice.voiceID + 1] = voice.name
								end
								return table
							end,
							order = 21,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_TTS_VOICE_02 end,
							set = function(_, val)
								addon.Database.DB_GLOBAL.profile.INT_TTS_VOICE_02 = val

								addon.TextToSpeech.Script:PlayConfiguredTTS(val, "Interaction example text.")
							end,
							open = function() NS.Utils.SetPreventMouse(true) end,
							close = function() NS.Utils.SetPreventMouse(false) end,
							autoCloseList = false
						},
						Dropdown_TextToSpeech_Emote = {
							name = L["Dropdown - Text To Speech / Voice / Emote"],
							tooltipImage = "",
							tooltipText = L["Dropdown - Text To Speech / Voice / Emote - Tooltip"],
							tooltipTextDynamic = nil,
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
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 1,
							category = Playback,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_TTS_EMOTE_VOICE end,
							set = function(_, val)
								addon.Database.DB_GLOBAL.profile.INT_TTS_EMOTE_VOICE = val

								addon.TextToSpeech.Script:PlayConfiguredTTS(val, "Interaction example text.")
							end,
							open = function() NS.Utils.SetPreventMouse(true) end,
							close = function() NS.Utils.SetPreventMouse(false) end,
							autoCloseList = false
						},
						Checkbox_TextToSpeech_PlayerVoice = {
							name = L["Checkbox - Text To Speech / Player / Voice"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Text To Speech / Player / Voice - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 23,
							hidden = function() return false end,
							subcategory = 1,
							category = Playback,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_TTS_PLAYER end,
							set = function(_, val)
								addon.Database.DB_GLOBAL.profile.INT_TTS_PLAYER = val
							end,
						},
						Dropdown_TextToSpeech_PlayerVoice_Voice = {
							name = L["Dropdown - Text To Speech / Player / Voice / Voice"],
							tooltipImage = "",
							tooltipText = L["Dropdown - Text To Speech / Player / Voice / Voice - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Dropdown",
							values = function()
								local table, voices = {}, C_VoiceChat.GetTtsVoices()
								for _, voice in ipairs(voices) do
									table[voice.voiceID + 1] = voice.name
								end
								return table
							end,
							order = 24,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_TTS_PLAYER end,
							locked = function() return false end,
							subcategory = 2,
							category = Playback,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_TTS_PLAYER_VOICE end,
							set = function(_, val)
								addon.Database.DB_GLOBAL.profile.INT_TTS_PLAYER_VOICE = val

								addon.TextToSpeech.Script:PlayConfiguredTTS(val, "Interaction example text.")
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
					order = 25,
					hidden = function() return false end,
					locked = function() return false end,
					category = Playback,
				},
				Group_More = {
					name = L["Title - More"],
					type = "Group",
					order = 26,
					hidden = function() return false end,
					locked = function() return false end,
					category = Playback,
					args = {
						Checkbox_MuteDialog = {
							name = L["Checkbox - Mute Dialog"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Mute Dialog - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 27,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = Playback,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_MUTE_DIALOG end,
							set = function(_, val)
								addon.Database.DB_GLOBAL.profile.INT_MUTE_DIALOG = val
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
					name = L["Warning - Leave NPC Interaction"],
					type = "Title",
					order = 2,
					hidden = function() return not addon.Interaction.Variables.Active end,
					category = Controls,
				},
				Group_UI = {
					name = L["Title - UI"],
					type = "Group",
					order = 4,
					hidden = function() return false end,
					locked = function() return addon.Interaction.Variables.Active end,
					category = Controls,
					args = {
						Title_UI = {
							name = L["Title - UI"],
							type = "Title",
							order = 5,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							category = Controls,
						},
						Checkbox_ControlGuide = {
							name = L["Checkbox - UI / Control Guide"],
							tooltipImage = "",
							tooltipText = L["Checkbox - UI / Control Guide - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 6,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 0,
							category = Controls,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_CONTROLGUIDE end,
							set = function(_, val)
								if not addon.Interaction.Variables.Active then
									addon.Database.DB_GLOBAL.profile.INT_CONTROLGUIDE = val
								end
							end,
						}
					},
				},
				Group_Platform = {
					name = L["Title - Platform"],
					type = "Group",
					order = 7,
					hidden = function() return false end,
					locked = function() return addon.Interaction.Variables.Active end,
					category = Controls,
					args = {
						Title_Platform = {
							name = L["Title - Platform"],
							type = "Title",
							order = 8,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							category = Controls,
						},
						Range_Platform = {
							name = L["Range - Platform"],
							tooltipImage = "",
							tooltipText = L["Range - Platform - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Range",
							min = 1,
							max = 3,
							step = 1,
							order = 9,
							hidden = function() return false end,
							locked = function() return addon.Interaction.Variables.Active end,
							subcategory = 0,
							category = Controls,
							valueText = function(val)
								if val == 1 then
									return L["Range - Platform - PC"]
								elseif val == 2 then
									return L["Range - Platform - Playstation"]
								elseif val == 3 then
									return L["Range - Platform - Xbox"]
								end
							end,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_PLATFORM end,
							set = function(_, val)
								if not addon.Interaction.Variables.Active then
									if val ~= addon.Database.DB_GLOBAL.profile.INT_PLATFORM then
										addon.Database.DB_GLOBAL.profile.TutorialSettingsShown = false

										--------------------------------

										if val ~= addon.Variables.Platform then
											NS.Utils:Prompt_Reload()
										else
											NS.Utils:Prompt_Clear()
										end
									end

									addon.Database.DB_GLOBAL.profile.INT_PLATFORM = val
								end
							end
						},
						Group_PC = {
							name = L["Title - PC"],
							type = "Group",
							order = 10,
							hidden = function() return addon.Database.DB_GLOBAL.profile.INT_PLATFORM > 1 end,
							category = Controls,
							args = {
								Group_PC_Keyboard = {
									name = L["Title - PC / Keyboard"],
									type = "Group",
									order = 11,
									hidden = function() return false end,
									category = Controls,
									args = {
										Title_Keyboard = {
											name = L["Title - PC / Keyboard"],
											type = "Title",
											order = 12,
											hidden = function() return false end,
											locked = function() return addon.Interaction.Variables.Active end,
											subcategory = 1,
											category = Controls,
										},
										Checkbox_UseInteractKey = {
											name = L["Checkbox - PC / Keyboard / Use Interact Key"],
											tooltipImage = "",
											tooltipText = L["Checkbox - PC / Keyboard / Use Interact Key - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Small",
											type = "Checkbox",
											order = 13,
											hidden = function() return false end,
											locked = function() return addon.Interaction.Variables.Active end,
											subcategory = 1,
											category = Controls,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_USEINTERACTKEY end,
											set = function(_, val)
												if not addon.Interaction.Variables.Active then
													if addon.Database.DB_GLOBAL.profile.INT_USEINTERACTKEY ~= val then
														CallbackRegistry:Trigger("SETTINGS_CONTROLS_CHANGED")
													end

													--------------------------------

													addon.Database.DB_GLOBAL.profile.INT_USEINTERACTKEY = val
												end
											end,
										},
									}
								},
								Group_PC_Mouse = {
									name = L["Title - PC / Mouse"],
									type = "Group",
									order = 14,
									hidden = function() return false end,
									category = Controls,
									args = {
										Title_Mouse = {
											name = L["Title - PC / Mouse"],
											type = "Title",
											order = 15,
											hidden = function() return false end,
											locked = function() return addon.Interaction.Variables.Active end,
											subcategory = 1,
											category = Controls,
										},
										Checkbox_FlipMouseControls = {
											name = L["Checkbox - PC / Mouse / Flip Mouse Controls"],
											tooltipImage = "",
											tooltipText = L["Checkbox - PC / Mouse / Flip Mouse Controls - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Small",
											type = "Checkbox",
											order = 16,
											hidden = function() return false end,
											locked = function() return addon.Interaction.Variables.Active end,
											subcategory = 1,
											category = Controls,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE end,
											set = function(_, val)
												if not addon.Interaction.Variables.Active then
													addon.Database.DB_GLOBAL.profile.INT_FLIPMOUSE = val
												end
											end,
										},
									}
								},
								Group_PC_Keybind = {
									name = L["Title - PC / Keybind"],
									type = "Group",
									order = 17,
									hidden = function() return false end,
									category = Controls,
									args = {
										Title_Keybind = {
											name = L["Title - PC / Keybind"],
											type = "Title",
											order = 18,
											hidden = function() return false end,
											locked = function() return addon.Interaction.Variables.Active end,
											subcategory = 1,
											category = Controls,
										},
										Keybind_Previous = {
											name = L["Keybind - PC / Keybind / Previous"],
											tooltipImage = "",
											tooltipText = L["Keybind - PC / Keybind / Previous - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Small",
											type = "Keybind",
											order = 19,
											hidden = function() return false end,
											locked = function() return addon.Interaction.Variables.Active end,
											subcategory = 1,
											category = Controls,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_KEY_PREVIOUS end,
											setCriteria = function()
												if not addon.Interaction.Variables.Active then
													return true
												else
													return false
												end
											end,
											set = function(_, val)
												if not addon.Interaction.Variables.Active then
													addon.Database.DB_GLOBAL.profile.INT_KEY_PREVIOUS = val
												end
											end,
										},
										Keybind_Next = {
											name = L["Keybind - PC / Keybind / Next"],
											tooltipImage = "",
											tooltipText = L["Keybind - PC / Keybind / Next - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Small",
											type = "Keybind",
											order = 20,
											hidden = function() return false end,
											locked = function() return addon.Interaction.Variables.Active end,
											subcategory = 1,
											category = Controls,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_KEY_NEXT end,
											setCriteria = function()
												if not addon.Interaction.Variables.Active then
													return true
												else
													return false
												end
											end,
											set = function(_, val)
												if not addon.Interaction.Variables.Active then
													addon.Database.DB_GLOBAL.profile.INT_KEY_NEXT = val
												end
											end,
										},
										Keybind_Progress = {
											name = L["Keybind - PC / Keybind / Progress"],
											tooltipImage = "",
											tooltipText = L["Keybind - PC / Keybind / Progress - Tooltip"],
											tooltipTextDynamic = function() if addon.Database.DB_GLOBAL.profile.INT_USEINTERACTKEY then return L["Keybind - PC / Keybind / Progress - Tooltip / Conflict"] else return nil end end,
											tooltipImageType = "Small",
											type = "Keybind",
											order = 21,
											hidden = function() return false end,
											locked = function() return addon.Database.DB_GLOBAL.profile.INT_USEINTERACTKEY or addon.Interaction.Variables.Active end,
											subcategory = 1,
											category = Controls,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_KEY_PROGRESS end,
											setCriteria = function()
												if not addon.Interaction.Variables.Active then
													return true
												else
													return false
												end
											end,
											set = function(_, val)
												if not addon.Interaction.Variables.Active then
													addon.Database.DB_GLOBAL.profile.INT_KEY_PROGRESS = val
												end
											end
										},
										Keybind_Quest_Progress = {
											name = L["Keybind - PC / Keybind / Quest Next Reward"],
											tooltipImage = "",
											tooltipText = L["Keybind - PC / Keybind / Quest Next Reward - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Small",
											type = "Keybind",
											order = 22,
											hidden = function() return false end,
											locked = function() return addon.Interaction.Variables.Active end,
											subcategory = 1,
											category = Controls,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_KEY_QUEST_NEXTREWARD end,
											setCriteria = function()
												if not addon.Interaction.Variables.Active then
													return true
												else
													return false
												end
											end,
											set = function(_, val)
												if not addon.Interaction.Variables.Active then
													addon.Database.DB_GLOBAL.profile.INT_KEY_QUEST_NEXTREWARD = val
												end
											end
										},
										Keybind_Close = {
											name = L["Keybind - PC / Keybind / Close"],
											tooltipImage = "",
											tooltipText = L["Keybind - PC / Keybind / Close - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Small",
											type = "Keybind",
											order = 23,
											hidden = function() return false end,
											locked = function() return addon.Interaction.Variables.Active end,
											subcategory = 1,
											category = Controls,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_KEY_CLOSE end,
											setCriteria = function()
												if not addon.Interaction.Variables.Active then
													return true
												else
													return false
												end
											end,
											set = function(_, val)
												if not addon.Interaction.Variables.Active then
													addon.Database.DB_GLOBAL.profile.INT_KEY_CLOSE = val
												end
											end
										}
									}
								},
							}
						},
						Group_Controller = {
							name = L["Title - Controller"],
							type = "Group",
							order = 24,
							hidden = function() return addon.Database.DB_GLOBAL.profile.INT_PLATFORM == 1 end,
							category = Controls,
							args = {
								-- Group_Controller_Controller = {
								-- 	name = L["Title - Controller / Controller"],
								-- 	type = "Group",
								-- 	order = 25,
								-- 	hidden = function() return false end,
								-- 	category = Controls,
								-- 	args = {
								-- 		Title_Controller = {
								-- 			name = L["Title - Controller / Controller"],
								-- 			type = "Title",
								-- 			order = 25,
								-- 			hidden = function() return false end,
								-- 			locked = function() return addon.Interaction.Variables.Active end,
								-- 			subcategory = 1,
								-- 			category = Controls,
								-- 		},
								-- 	}
								-- }
							}
						}
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
					hidden = function() return addon.Variables.IS_WOW_VERSION_CLASSIC_ALL or addon.LoadedAddons.WaypointUI end,
					locked = function() return addon.Variables.IS_WOW_VERSION_CLASSIC_ALL or addon.LoadedAddons.WaypointUI end,
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
							tooltipTextDynamic = nil,
							tooltipImageType = "Large",
							type = "Checkbox",
							order = 4,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = Gameplay,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_WAYPOINT end,
							set = function(_, val)
								NS.Utils:Prompt_Reload()

								addon.Database.DB_GLOBAL.profile.INT_WAYPOINT = val
							end,
						},
						Checkbox_Waypoint_SoundEffects = {
							name = L["Checkbox - Waypoint / Audio"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Waypoint / Audio - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 5,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_WAYPOINT end,
							locked = function() return false end,
							subcategory = 1,
							category = Gameplay,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_WAYPOINT_AUDIO end,
							set = function(_, val)
								addon.Database.DB_GLOBAL.profile.INT_WAYPOINT_AUDIO = val
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
							tooltipTextDynamic = nil,
							tooltipImageType = "Large",
							type = "Checkbox",
							order = 9,
							hidden = function() return false end,
							locked = function() return InteractionReadableUIFrame:IsVisible() end,
							subcategory = 0,
							category = Gameplay,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_READABLE end,
							set = function(_, val)
								if not InteractionReadableUIFrame:IsVisible() then
									NS.Utils:Prompt_Reload()

									--------------------------------

									addon.Database.DB_GLOBAL.profile.INT_READABLE = val
								end
							end,
						},
						Group_Readable = {
							name = L["Title - Readable"],
							type = "Group",
							order = 10,
							hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_READABLE end,
							locked = function() return InteractionReadableUIFrame:IsVisible() end,
							category = Gameplay,
							args = {
								Group_Display = {
									name = L["Title - Readable / Display"],
									type = "Group",
									order = 11,
									hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_READABLE end,
									locked = function() return InteractionReadableUIFrame:IsVisible() end,
									category = Gameplay,
									args = {
										Title_Display = {
											name = L["Title - Readable / Display"],
											type = "Title",
											order = 12,
											hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
										},
										Checkbox_Display_AlwaysShowItem = {
											name = L["Checkbox - Readable / Display / Always Show Item"],
											tooltipImage = "",
											tooltipText = L["Checkbox - Readable / Display / Always Show Item - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Small",
											type = "Checkbox",
											order = 13,
											hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_READABLE_DISPLAY_ALWAYS_SHOW_ITEM end,
											set = function(_, val)
												if not InteractionReadableUIFrame:IsVisible() then
													addon.Database.DB_GLOBAL.profile.INT_READABLE_DISPLAY_ALWAYS_SHOW_ITEM = val
												end
											end,
										},
									}
								},
								Group_Viewport = {
									name = L["Title - Readable / Viewport"],
									type = "Group",
									order = 14,
									hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_READABLE end,
									locked = function() return InteractionReadableUIFrame:IsVisible() end,
									category = Gameplay,
									args = {
										Title_Viewport = {
											name = L["Title - Readable / Viewport"],
											type = "Title",
											order = 15,
											hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
										},
										Checkbox_Viewport = {
											name = L["Checkbox - Readable / Viewport"],
											tooltipImage = "",
											tooltipText = L["Checkbox - Readable / Viewport - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Small",
											type = "Checkbox",
											order = 16,
											hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_READABLE_CINEMATIC end,
											set = function(_, val)
												if not InteractionReadableUIFrame:IsVisible() then
													addon.Database.DB_GLOBAL.profile.INT_READABLE_CINEMATIC = val
												end
											end,
										},
									}
								},
								Group_Shortcuts = {
									name = L["Title - Readable / Shortcuts"],
									type = "Group",
									order = 17,
									hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_READABLE end,
									locked = function() return InteractionReadableUIFrame:IsVisible() end,
									category = Gameplay,
									args = {
										Title_Shortcuts = {
											name = L["Title - Readable / Shortcuts"],
											type = "Title",
											order = 18,
											hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
										},
										Checkbox_Shortcuts_MinimapIcon = {
											name = L["Checkbox - Readable / Shortcuts / Minimap Icon"],
											tooltipImage = NS.Variables.TOOLTIP_PATH .. "Minimap.png",
											tooltipText = L["Checkbox - Readable / Shortcuts / Minimap Icon - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Large",
											type = "Checkbox",
											order = 19,
											hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_MINIMAP end,
											set = function(_, val)
												if not InteractionReadableUIFrame:IsVisible() then
													if addon.Database.DB_GLOBAL.profile.INT_MINIMAP ~= val then
														CallbackRegistry:Trigger("SETTINGS_MINIMAP_CHANGED")
													end

													--------------------------------

													addon.Database.DB_GLOBAL.profile.INT_MINIMAP = val
												end
											end
										}
									}
								},
								Group_Audiobook = {
									name = L["Title - Readable / Audiobook"],
									type = "Group",
									order = 20,
									hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_READABLE end,
									locked = function() return InteractionReadableUIFrame:IsVisible() end,
									category = Gameplay,
									args = {
										Title_Audiobook = {
											name = L["Title - Readable / Audiobook"],
											type = "Title",
											order = 21,
											hidden = function() return not addon.Database.DB_GLOBAL.profile.INT_READABLE end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Gameplay,
										},
										Range_Audiobook_Rate = {
											name = L["Range - Readable / Audiobook - Rate"],
											tooltipImage = "",
											tooltipText = L["Range - Readable / Audiobook - Rate - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Small",
											type = "Range",
											min = -10,
											max = 10,
											step = .25,
											order = 22,
											hidden = function() return false end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Playback,
											valueText = function(val)
												return string.format("%.0f", (val + 10) * 10) .. "%"
											end,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_RATE end,
											set = function(_, val)
												if not InteractionReadableUIFrame:IsVisible() then
													addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_RATE = val;
												end
											end
										},
										Range_Audiobook_Volume = {
											name = L["Range - Readable / Audiobook - Volume"],
											tooltipImage = "",
											tooltipText = L["Range - Readable / Audiobook - Volume - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Small",
											type = "Range",
											min = 0,
											max = 100,
											step = 10,
											order = 23,
											hidden = function() return false end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Playback,
											valueText = function(val)
												return string.format("%.0f", val) .. "%"
											end,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOLUME end,
											set = function(_, val)
												if not InteractionReadableUIFrame:IsVisible() then
													addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOLUME = val
												end
											end
										},
										Dropdown_Audiobook_Voice = {
											name = L["Dropdown - Readable / Audiobook - Voice"],
											tooltipImage = "",
											tooltipText = L["Dropdown - Readable / Audiobook - Voice - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Small",
											type = "Dropdown",
											values = function()
												local table, voices = {}, C_VoiceChat.GetTtsVoices()
												for _, voice in ipairs(voices) do
													table[voice.voiceID + 1] = voice.name
												end
												return table
											end,
											order = 24,
											hidden = function() return false end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Playback,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOICE end,
											set = function(_, val)
												if not InteractionReadableUIFrame:IsVisible() then
													addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOICE = val

													local Voice = (addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOICE or 1) - 1
													local Rate = (addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_RATE or 1) * .25
													local Volume = (addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOLUME or 100)

													addon.TextToSpeech.Script:StopSpeakingText()
													addon.Libraries.AceTimer:ScheduleTimer(function()
														addon.TextToSpeech.Script:SpeakText(Voice, "Interaction example text.", Enum.VoiceTtsDestination and Enum.VoiceTtsDestination.LocalPlayback or 1, Rate, Volume)
													end, 0)
												end
											end,
											setCriteria = function()
												if not InteractionReadableUIFrame:IsVisible() then
													return true
												else
													return false
												end
											end,
											open = function() NS.Utils.SetPreventMouse(true) end,
											close = function() NS.Utils.SetPreventMouse(false) end,
											autoCloseList = false
										},
										Dropdown_Audiobook_SpecialVoice = {
											name = L["Dropdown - Readable / Audiobook - Special Voice"],
											tooltipImage = "",
											tooltipText = L["Dropdown - Readable / Audiobook - Special Voice - Tooltip"],
											tooltipTextDynamic = nil,
											tooltipImageType = "Small",
											type = "Dropdown",
											values = function()
												local table, voices = {}, C_VoiceChat.GetTtsVoices()
												for _, voice in ipairs(voices) do
													table[voice.voiceID + 1] = voice.name
												end
												return table
											end,
											order = 25,
											hidden = function() return false end,
											locked = function() return InteractionReadableUIFrame:IsVisible() end,
											subcategory = 1,
											category = Playback,
											get = function() return addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOICE_SPECIAL end,
											set = function(_, val)
												if not InteractionReadableUIFrame:IsVisible() then
													addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOICE_SPECIAL = val

													local Voice = (addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOICE_SPECIAL or 1) - 1
													local Rate = (addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_RATE or 1) * .25
													local Volume = (addon.Database.DB_GLOBAL.profile.INT_READABLE_AUDIOBOOK_VOLUME or 100)

													addon.TextToSpeech.Script:StopSpeakingText()
													addon.Libraries.AceTimer:ScheduleTimer(function()
														addon.TextToSpeech.Script:SpeakText(Voice, "Interaction example text.", Enum.VoiceTtsDestination and Enum.VoiceTtsDestination.LocalPlayback or 1, Rate, Volume)
													end, 0)
												end
											end,
											setCriteria = function()
												if not InteractionReadableUIFrame:IsVisible() then
													return true
												else
													return false
												end
											end,
											open = function() NS.Utils.SetPreventMouse(true) end,
											close = function() NS.Utils.SetPreventMouse(false) end,
											autoCloseList = false
										},
									}
								}
							}
						}
					}
				},
				Group_Gameplay = {
					name = "Gameplay",
					type = "Group",
					order = 26,
					hidden = function() return false end,
					locked = function() return false end,
					category = Gameplay,
					args = {
						Title_Gameplay = {
							name = L["Title - Gameplay"],
							type = "Title",
							order = 27,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = Gameplay,
						},
						Checkbox_AutoSelect = {
							name = L["Checkbox - Gameplay / Auto Select Option"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Gameplay / Auto Select Option - Tooltip"],
							tooltipTextDynamic = nil,
							type = "Checkbox",
							order = 28,
							hidden = function() return false end,
							subcategory = 0,
							category = Playback,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_AUTO_SELECT_OPTION end,
							set = function(_, val) addon.Database.DB_GLOBAL.profile.INT_AUTO_SELECT_OPTION = val end,
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
				Group_Audio = {
					name = L["Title - Audio"],
					type = "Group",
					order = 2,
					hidden = function() return false end,
					locked = function() return false end,
					category = More,
					args = {
						Title_Audio = {
							name = L["Title - Audio"],
							type = "Title",
							order = 3,
							hidden = function() return false end,
							locked = function() return false end,
							category = More,
						},
						Checkbox_Audio = {
							name = L["Checkbox - Audio"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Audio - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Checkbox",
							order = 4,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = More,
							get = function() return addon.Database.DB_GLOBAL.profile.INT_AUDIO end,
							set = function(_, val)
								addon.Database.DB_GLOBAL.profile.INT_AUDIO = val
							end,
						},
					}
				},
				Group_Settings = {
					name = L["Title - Settings"],
					type = "Group",
					order = 5,
					hidden = function() return false end,
					locked = function() return false end,
					category = More,
					args = {
						Title_Settings = {
							name = L["Title - Settings"],
							type = "Title",
							order = 6,
							hidden = function() return false end,
							locked = function() return false end,
							category = More,
						},
						Button_ResetSettings = {
							name = L["Checkbox - Settings / Reset Settings"],
							tooltipImage = "",
							tooltipText = L["Checkbox - Settings / Reset Settings - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Small",
							type = "Button",
							order = 7,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = More,
							set = function()
								NS.Utils:Prompt_Confirm(L["Prompt - Reset Settings"], L["Prompt - Reset Settings Button 1"], L["Prompt - Reset Settings Button 2"], function()
									addon.Database:ResetSettings()

									--------------------------------

									ReloadUI()
								end)
							end,
						}
					}
				},
				Group_Credits = {
					name = L["Title - Credits"],
					type = "Group",
					order = 8,
					opacity = .5,
					hidden = function() return false end,
					locked = function() return false end,
					category = More,
					args = {
						Spacer_Credits_Header = {
							name = L["Title - Credits"],
							type = "Spacer",
							order = 9,
							spacing = 2,
							hidden = function() return false end,
							locked = function() return false end,
							category = More,
						},
						Title_Credits = {
							name = L["Title - Credits"],
							type = "Title",
							order = 10,
							hidden = function() return false end,
							locked = function() return false end,
							category = More,
						},
						Title_Credits_ZamestoTV = {
							name = L["Title - Credits / ZamestoTV"],
							tooltipImage = NS.Variables.TOOLTIP_PATH .. "Acknowledgement.png",
							tooltipText = L["Title - Credits / ZamestoTV - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Large",
							type = "Title",
							order = 11,
							isSubtitle = true,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = More,
						},
						Title_Credits_AKArenan = {
							name = L["Title - Credits / AKArenan"],
							tooltipImage = NS.Variables.TOOLTIP_PATH .. "Acknowledgement.png",
							tooltipText = L["Title - Credits / AKArenan - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Large",
							type = "Title",
							order = 12,
							isSubtitle = true,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = More,
						},
						Title_Credits_El1as1989 = {
							name = L["Title - Credits / El1as1989"],
							tooltipImage = NS.Variables.TOOLTIP_PATH .. "Acknowledgement.png",
							tooltipText = L["Title - Credits / El1as1989 - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Large",
							type = "Title",
							order = 13,
							isSubtitle = true,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = More,
						},
						Title_Credits_huchang47 = {
							name = L["Title - Credits / huchang47"],
							tooltipImage = NS.Variables.TOOLTIP_PATH .. "Acknowledgement.png",
							tooltipText = L["Title - Credits / huchang47 - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Large",
							type = "Title",
							order = 14,
							isSubtitle = true,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = More,
						},
						Title_Credits_muiqo = {
							name = L["Title - Credits / muiqo"],
							tooltipImage = NS.Variables.TOOLTIP_PATH .. "Acknowledgement.png",
							tooltipText = L["Title - Credits / muiqo - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Large",
							type = "Title",
							order = 15,
							isSubtitle = true,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = More,
						},
						Title_Credits_Crazyyoungs = {
							name = L["Title - Credits / Crazyyoungs"],
							tooltipImage = NS.Variables.TOOLTIP_PATH .. "Acknowledgement.png",
							tooltipText = L["Title - Credits / Crazyyoungs - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Large",
							type = "Title",
							order = 16,
							isSubtitle = true,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = More,
						},
						Title_Credits_joaoc_pires = {
							name = L["Title - Credits / joaoc_pires"],
							tooltipImage = NS.Variables.TOOLTIP_PATH .. "Acknowledgement.png",
							tooltipText = L["Title - Credits / joaoc_pires - Tooltip"],
							tooltipTextDynamic = nil,
							tooltipImageType = "Large",
							type = "Title",
							order = 17,
							isSubtitle = true,
							hidden = function() return false end,
							locked = function() return false end,
							subcategory = 0,
							category = More,
						},
						Spacer_Credits_Footer = {
							name = L["Title - Credits"],
							type = "Spacer",
							order = 18,
							spacing = 1,
							hidden = function() return false end,
							locked = function() return false end,
							category = More,
						}
					}
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
							local TooltipTextDynamic = CurrentElement.tooltipTextDynamic
							local TooltipImage = CurrentElement.tooltipImage
							local TooltipImageType = CurrentElement.tooltipImageType
							local Hidden = CurrentElement.hidden
							local Locked = CurrentElement.locked
							local Opacity = CurrentElement.opacity

							-- VALUES
							local SetCriteria = CurrentElement.setCriteria

							local Get = CurrentElement.get
							local Set = CurrentElement.set

							-- TITLE
							local IsSubtitle = CurrentElement.isSubtitle

							-- SPACER
							local Spacing = CurrentElement.spacing

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

							local function SetInfo(frame)
								frame.Type = Type

								frame.TooltipText = TooltipText
								frame.TooltipTextDynamic = TooltipTextDynamic
								frame.TooltipImage = TooltipImage
								frame.TooltipImageType = TooltipImageType

								frame.Opacity = Opacity or 1
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
									Locked,
									Opacity
								)

								SetToParent(frame)
								SetInfo(frame)
								SetWidget(frame)
							end

							if Type == "Title" then
								local frame
								frame = NS.Widgets:CreateTitle(
									Category,
									IsSubtitle,
									IsSubtitle and 15 or 17.5,
									Subcategory,
									TooltipText,
									TooltipTextDynamic,
									TooltipImage,
									TooltipImageType,
									Hidden,
									Locked,
									Opacity
								)
								frame.Label:SetText(Name)

								SetToParent(frame)
								SetInfo(frame)
								SetWidget(frame)
							end

							if Type == "Spacer" then
								local frame
								frame = NS.Widgets:CreateSpacer(
									Category,
									Spacing,
									Subcategory
								)

								SetToParent(frame)
								SetInfo(frame)
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
									TooltipTextDynamic,
									TooltipImage,
									TooltipImageType,
									Hidden,
									Locked,
									Opacity
								)
								frame.Button:SetText(Name)

								SetToParent(frame)
								SetInfo(frame)
								SetWidget(frame)
							end

							if Type == "Checkbox" then
								local frame
								frame = NS.Widgets:CreateCheckbox(
									Category,
									Get,
									function(...)
										if SetCriteria and not SetCriteria(...) then
											return
										end

										--------------------------------

										local _, val = ...
										if tostring(val) ~= tostring(Get()) then
											Set(...)

											--------------------------------

											CallbackRegistry:Trigger("SETTING_CHANGED", frame)
										end
									end,
									Subcategory,
									TooltipText,
									TooltipTextDynamic,
									TooltipImage,
									TooltipImageType,
									Hidden,
									Locked,
									Opacity
								)
								frame.Text:SetText(Name)

								SetToParent(frame)
								SetInfo(frame)
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
									function()
										CallbackRegistry:Trigger("SETTING_CHANGED", frame)
									end,
									Get,
									function(...)
										if SetCriteria and not SetCriteria(...) then
											return
										end

										--------------------------------

										local _, val = ...
										if tostring(val) ~= tostring(Get()) then
											Set(...)
										end
									end,
									Subcategory,
									TooltipText,
									TooltipTextDynamic,
									TooltipImage,
									TooltipImageType,
									Hidden,
									Locked,
									Opacity
								)
								frame.Text:SetText(Name)

								SetToParent(frame)
								SetInfo(frame)
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
									Get,
									function(...)
										if SetCriteria and not SetCriteria(...) then
											return
										end

										--------------------------------

										local _, val = ...
										if tostring(val) ~= tostring(Get()) then
											Set(...)

											--------------------------------

											CallbackRegistry:Trigger("SETTING_CHANGED", frame)
										end
									end,
									function(...)
										if SetCriteria and not SetCriteria(...) then
											return false
										else
											return true
										end
									end,
									Subcategory,
									TooltipText,
									TooltipTextDynamic,
									TooltipImage,
									TooltipImageType,
									Hidden,
									Locked,
									Opacity
								)
								frame.Text:SetText(Name)

								SetToParent(frame)
								SetInfo(frame)
								SetWidget(frame)
							end

							if Type == "Keybind" then
								local frame
								frame = NS.Widgets:CreateKeybindButton(
									Category,
									Get,
									function(...)
										if SetCriteria and not SetCriteria(...) then
											return
										end

										--------------------------------

										local _, val = ...
										if tostring(val) ~= tostring(Get()) then
											Set(...)

											--------------------------------

											CallbackRegistry:Trigger("SETTING_CHANGED", frame)
											CallbackRegistry:Trigger("KEYBIND_CHANGED", frame)
										end
									end,
									function(...)
										if SetCriteria and not SetCriteria(...) then
											return false
										else
											return true
										end
									end,
									Subcategory,
									TooltipText,
									TooltipTextDynamic,
									TooltipImage,
									TooltipImageType,
									Hidden,
									Locked,
									Opacity
								)
								frame.Text:SetText(Name)

								SetToParent(frame)
								SetInfo(frame)
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
