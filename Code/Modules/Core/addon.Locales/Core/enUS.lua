-- Base Localization
-- Languages with no translations will default to this:

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

local function Load()
	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		-- WARNINGS
		L["Warning - Leave NPC Interaction"] = "Leave NPC Interaction to adjust settings."
		L["Warning - Leave ReadableUI"] = "Leave Readable UI to adjust settings."

		-- PROMPTS
		L["Prompt - Reload"] = "Interface Reload required to apply settings"
		L["Prompt - Reload Button 1"] = "Reload"
		L["Prompt - Reload Button 2"] = "Close"
		L["Prompt - Reset Settings"] = "Are you sure you want to reset settings?"
		L["Prompt - Reset Settings Button 1"] = "Reset"
		L["Prompt - Reset Settings Button 2"] = "Cancel"

		-- TABS
		L["Tab - Appearance"] = "Appearance"
		L["Tab - Effects"] = "Effects"
		L["Tab - Playback"] = "Playback"
		L["Tab - Controls"] = "Controls"
		L["Tab - Gameplay"] = "Gameplay"
		L["Tab - More"] = "More"

		-- ELEMENTS
		-- APPEARANCE
		L["Title - Theme"] = "Theme"
		L["Range - Main Theme"] = "Main Theme"
		L["Range - Main Theme - Tooltip"] = "Sets the overall UI theme.\n\nDefault: Day.\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "Dynamic" .. addon.Theme.Settings.Tooltip_Text_Note .. " option sets the main theme according to in-game day/night cycle.|r"
		L["Range - Main Theme - Day"] = "DAY"
		L["Range - Main Theme - Night"] = "NIGHT"
		L["Range - Main Theme - Dynamic"] = "DYNAMIC"
		L["Range - Dialog Theme"] = "Dialog Theme"
		L["Range - Dialog Theme - Tooltip"] = "Sets the NPC dialog UI theme.\n\nDefault: Match.\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "Match" .. addon.Theme.Settings.Tooltip_Text_Note .. " option sets the dialog theme to match the main theme.|r"
		L["Range - Dialog Theme - Auto"] = "MATCH"
		L["Range - Dialog Theme - Day"] = "DAY"
		L["Range - Dialog Theme - Night"] = "NIGHT"
		L["Range - Dialog Theme - Rustic"] = "RUSTIC"
		L["Title - Appearance"] = "Appearance"
		L["Range - UIDirection"] = "UI Direction"
		L["Range - UIDirection - Tooltip"] = "Sets the UI direction."
		L["Range - UIDirection - Left"] = "LEFT"
		L["Range - UIDirection - Right"] = "RIGHT"
		L["Range - UIDirection / Dialog"] = "Fixed Dialog Position"
		L["Range - UIDirection / Dialog - Tooltip"] = "Sets the fixed dialog position.\n\nFixed dialog is used when the NPC's nameplate is unavailable."
		L["Range - UIDirection / Dialog - Top"] = "TOP"
		L["Range - UIDirection / Dialog - Center"] = "CENTER"
		L["Range - UIDirection / Dialog - Bottom"] = "BOTTOM"
		L["Checkbox - UIDirection / Dialog / Mirror"] = "Mirror"
		L["Checkbox - UIDirection / Dialog / Mirror - Tooltip"] = "Mirrors the UI direction."
		L["Range - Quest Frame Size"] = "Quest Frame Size"
		L["Range - Quest Frame Size - Tooltip"] = "Adjust quest frame size.\n\nDefault: Medium."
		L["Range - Quest Frame Size - Small"] = "SMALL"
		L["Range - Quest Frame Size - Medium"] = "MEDIUM"
		L["Range - Quest Frame Size - Large"] = "LARGE"
		L["Range - Quest Frame Size - Extra Large"] = "EXTRA LARGE"
		L["Range - Text Size"] = "Text Size"
		L["Range - Text Size - Tooltip"] = "Adjust text size."
		L["Title - Dialog"] = "Dialog"
		L["Checkbox - Dialog / Title / Progress Bar"] = "Show Progress Bar"
		L["Checkbox - Dialog / Title / Progress Bar - Tooltip"] = "Shows or hides the dialog progress bar.\n\nThis bar indicates how far you've progressed through the current conversation.\n\nDefault: On."
		L["Range - Dialog / Title / Text Alpha"] = "Title Opacity"
		L["Range - Dialog / Title / Text Alpha - Tooltip"] = "Sets the opacity of the dialog title.\n\nDefault: 50%."
		L["Range - Dialog / Content Preview Alpha"] = "Preview Opacity"
		L["Range - Dialog / Content Preview Alpha - Tooltip"] = "Sets the opacity of the dialog text preview.\n\nDefault: 50%."
		L["Title - Gossip"] = "Gossip"
		L["Checkbox - Always Show Gossip Frame"] = "Always Show Gossip Frame"
		L["Checkbox - Always Show Gossip Frame - Tooltip"] = "Always show the gossip frame when available instead of only after dialog.\n\nDefault: On."
		L["Title - Quest"] = "Quest"
		L["Checkbox - Always Show Quest Frame"] = "Always Show Quest Frame"
		L["Checkbox - Always Show Quest Frame - Tooltip"] = "Always show the quest frame when available instead of only after dialog.\n\nDefault: On."

		-- VIEWPORT
		L["Title - Effects"] = "Effects"
		L["Checkbox - Hide UI"] = "Hide UI"
		L["Checkbox - Hide UI - Tooltip"] = "Hides UI during NPC interaction.\n\nDefault: On."
		L["Range - Cinematic"] = "Camera Effects"
		L["Range - Cinematic - Tooltip"] = "Camera effects during interaction.\n\nDefault: Full."
		L["Range - Cinematic - None"] = "NONE"
		L["Range - Cinematic - Full"] = "FULL"
		L["Range - Cinematic - Balanced"] = "BALANCED"
		L["Range - Cinematic - Custom"] = "CUSTOM"
		L["Checkbox - Zoom"] = "Zoom"
		L["Range - Zoom / Min Distance"] = "Min Distance"
		L["Range - Zoom / Min Distance - Tooltip"] = "If the current zoom is under this threshold, the camera will zoom to this level."
		L["Range - Zoom / Max Distance"] = "Max Distance"
		L["Range - Zoom / Max Distance - Tooltip"] = "If the current zoom is above this threshold, the camera will zoom to this level."
		L["Checkbox - Zoom / Pitch"] = "Adjust Vertical Angle"
		L["Checkbox - Zoom / Pitch - Tooltip"] = "Enable vertical camera angle adjustment."
		L["Range - Zoom / Pitch / Level"] = "Max Angle"
		L["Range - Zoom / Pitch / Level - Tooltip"] = "Vertical angle threshold."
		L["Checkbox - Zoom / Field Of View"] = "Adjust FOV"
		L["Checkbox - Pan"] = "Pan"
		L["Range - Pan / Speed"] = "Speed"
		L["Range - Pan / Speed - Tooltip"] = "Max panning speed."
		L["Checkbox - Dynamic Camera"] = "Dynamic Camera"
		L["Checkbox - Dynamic Camera - Tooltip"] = "Enable Dynamic Camera settings."
		L["Checkbox - Dynamic Camera / Side View"] = "Side View"
		L["Checkbox - Dynamic Camera / Side View - Tooltip"] = "Adjust camera for side view."
		L["Range - Dynamic Camera / Side View / Strength"] = "Strength"
		L["Range - Dynamic Camera / Side View / Strength - Tooltip"] = "Higher value increases side movement."
		L["Checkbox - Dynamic Camera / Offset"] = "Offset"
		L["Checkbox - Dynamic Camera / Offset - Tooltip"] = "Offset viewport from character."
		L["Range - Dynamic Camera / Offset / Strength"] = "Strength"
		L["Range - Dynamic Camera / Offset / Strength - Tooltip"] = "Higher value increases offset."
		L["Checkbox - Dynamic Camera / Focus"] = "Focus"
		L["Checkbox - Dynamic Camera / Focus - Tooltip"] = "Focus viewport on target."
		L["Range - Dynamic Camera / Focus / Strength"] = "Strength"
		L["Range - Dynamic Camera / Focus / Strength - Tooltip"] = "Higher value incrases focus strength."
		L["Checkbox - Dynamic Camera / Focus / X"] = "Ignore X Axis"
		L["Checkbox - Dynamic Camera / Focus / X - Tooltip"] = "Prevent X axis focus."
		L["Checkbox - Dynamic Camera / Focus / Y"] = "Ignore Y Axis"
		L["Checkbox - Dynamic Camera / Focus / Y - Tooltip"] = "Prevent Y axis focus."
		L["Checkbox - Vignette"] = "Vignette"
		L["Checkbox - Vignette - Tooltip"] = "Reduces edge brightness."
		L["Checkbox - Vignette / Gradient"] = "Gradient"
		L["Checkbox - Vignette / Gradient - Tooltip"] = "Reduce brightness behind gossip and quest interface elements."

		-- PLAYBACK
		L["Title - Pace"] = "Pace"
		L["Range - Playback Speed"] = "Playback Speed"
		L["Range - Playback Speed - Tooltip"] = "Speed of text playback.\n\nDefault: 100%."
		L["Checkbox - Dynamic Playback"] = "Natural Playback"
		L["Checkbox - Dynamic Playback - Tooltip"] = "Adds punctuation pauses in dialog.\n\nDefault: On."
		L["Title - Auto Progress"] = "Auto Progress"
		L["Checkbox - Auto Progress"] = "Enable"
		L["Checkbox - Auto Progress - Tooltip"] = "Automatically progress to next dialog.\n\nDefault: On."
		L["Checkbox - Auto Close Dialog"] = "Auto Close"
		L["Checkbox - Auto Close Dialog - Tooltip"] = "Stop NPC interaction when no options available.\n\nDefault: On."
		L["Range - Auto Progress / Delay"] = "Delay"
		L["Range - Auto Progress / Delay - Tooltip"] = "Delay before to next dialog.\n\nDefault: 1."
		L["Title - Text To Speech"] = "Text To Speech"
		L["Checkbox - Text To Speech"] = "Enable"
		L["Checkbox - Text To Speech - Tooltip"] = "Reads out dialog text.\n\nDefault: Off."
		L["Title - Text To Speech / Playback"] = "Playback"
		L["Checkbox - Text To Speech / Quest"] = "Play Quest"
		L["Checkbox - Text To Speech / Quest - Tooltip"] = "Enable Text to Speech on quest dialog.\n\nDefault: On."
		L["Checkbox - Text To Speech / Gossip"] = "Play Gossip"
		L["Checkbox - Text To Speech / Gossip - Tooltip"] = "Enable Text to Speech on gossip dialog.\n\nDefault: On."
		L["Range - Text To Speech / Rate"] = "Rate"
		L["Range - Text To Speech / Rate - Tooltip"] = "Speech rate offset.\n\nDefault: 100%."
		L["Range - Text To Speech / Volume"] = "Volume"
		L["Range - Text To Speech / Volume - Tooltip"] = "Speech volume.\n\nDefault: 100%."
		L["Title - Text To Speech / Voice"] = "Voice"
		L["Dropdown - Text To Speech / Voice / Neutral"] = "Neutral"
		L["Dropdown - Text To Speech / Voice / Neutral - Tooltip"] = "Used for gender-neutral NPCs."
		L["Dropdown - Text To Speech / Voice / Male"] = "Male"
		L["Dropdown - Text To Speech / Voice / Male - Tooltip"] = "Used for male NPCs."
		L["Dropdown - Text To Speech / Voice / Female"] = "Female"
		L["Dropdown - Text To Speech / Voice / Female - Tooltip"] = "Used for female NPCs."
		L["Dropdown - Text To Speech / Voice / Emote"] = "Expression"
		L["Dropdown - Text To Speech / Voice / Emote - Tooltip"] = "Used for dialogs in '<>'."
		L["Checkbox - Text To Speech / Player / Voice"] = "Player Voice"
		L["Checkbox - Text To Speech / Player / Voice - Tooltip"] = "Plays TTS when selecting a dialog option.\n\nDefault: On."
		L["Dropdown - Text To Speech / Player / Voice / Voice"] = "Voice"
		L["Dropdown - Text To Speech / Player / Voice / Voice - Tooltip"] = "Voice for dialog options."
		L["Title - More"] = "More"
		L["Checkbox - Mute Dialog"] = "Mute NPC Dialog"
		L["Checkbox - Mute Dialog - Tooltip"] = "Mutes Blizzard's NPC dialog audio during NPC interaction.\n\nDefault: Off."

		-- CONTROLS
		L["Title - UI"] = "UI"
		L["Checkbox - UI / Control Guide"] = "Show Control Guide"
		L["Checkbox - UI / Control Guide - Tooltip"] = "Shows the control guide frame.\n\nDefault: On."
		L["Title - Platform"] = "Platform"
		L["Range - Platform"] = "Platform"
		L["Range - Platform - Tooltip"] = "Requires Interface Reload to take effect."
		L["Range - Platform - PC"] = "PC"
		L["Range - Platform - Playstation"] = "Playstation"
		L["Range - Platform - Xbox"] = "Xbox"
		L["Title - PC"] = "PC"
		L["Title - PC / Keyboard"] = "Keyboard"
		L["Checkbox - PC / Keyboard / Use Interact Key"] = "Use Interact Key"
		L["Checkbox - PC / Keyboard / Use Interact Key - Tooltip"] = "Use the interact key for progressing. Multi-key combinations not supported.\n\nDefault: Off."
		L["Title - PC / Mouse"] = "Mouse"
		L["Checkbox - PC / Mouse / Flip Mouse Controls"] = "Flip Mouse Controls"
		L["Checkbox - PC / Mouse / Flip Mouse Controls - Tooltip"] = "Flip Left and Right mouse controls.\n\nDefault: Off."
		L["Title - PC / Keybind"] = "Keybinds"
		L["Keybind - PC / Keybind / Previous"] = "Previous"
		L["Keybind - PC / Keybind / Previous - Tooltip"] = "Previous dialog keybind.\n\nDefault: Q."
		L["Keybind - PC / Keybind / Next"] = "Next"
		L["Keybind - PC / Keybind / Next - Tooltip"] = "Next dialog keybind.\n\nDefault: E."
		L["Keybind - PC / Keybind / Progress"] = "Progress"
		L["Keybind - PC / Keybind / Progress - Tooltip"] = "Keybind for:\n- Skip\n- Accept\n- Continue\n- Complete\n\nDefault: SPACE."
		L["Keybind - PC / Keybind / Progress - Tooltip / Conflict"] = addon.Theme.Settings.Tooltip_Text_Warning_Highlight .. "Use Interact Key" .. addon.Theme.Settings.Tooltip_Text_Warning .. " option must be disabled to adjust this keybind.|r"
		L["Keybind - PC / Keybind / Quest Next Reward"] = "Next Reward"
		L["Keybind - PC / Keybind / Quest Next Reward - Tooltip"] = "Keybind to select the next quest reward.\n\nDefault: TAB."
		L["Keybind - PC / Keybind / Close"] = "Close"
		L["Keybind - PC / Keybind / Close - Tooltip"] = "Keybind to close the current active Interaction window.\n\nDefault: ESCAPE."
		L["Title - Controller"] = "Controller"
		L["Title - Controller / Controller"] = "Controller"

		-- GAMEPLAY
		L["Title - Waypoint"] = "Waypoint"
		L["Checkbox - Waypoint"] = "Enable"
		L["Checkbox - Waypoint - Tooltip"] = "Waypoint replacement for Blizzard's in-game navigation.\n\nDefault: On."
		L["Checkbox - Waypoint / Audio"] = "Audio"
		L["Checkbox - Waypoint / Audio - Tooltip"] = "Sound effects when Waypoint state changes.\n\nDefault: On."
		L["Title - Readable"] = "Readable Items"
		L["Checkbox - Readable"] = "Enable"
		L["Checkbox - Readable - Tooltip"] = "Enable custom interface for Readable Items - and Library for storing them.\n\nDefault: On."
		L["Title - Readable / Display"] = "Display"
		L["Checkbox - Readable / Display / Always Show Item"] = "Always Show Item"
		L["Checkbox - Readable / Display / Always Show Item - Tooltip"] = "Prevent the readable interface from closing when leaving the distance of an in-world item.\n\nDefault: Off."
		L["Title - Readable / Viewport"] = "Viewport"
		L["Checkbox - Readable / Viewport"] = "Use Viewport Effects"
		L["Checkbox - Readable / Viewport - Tooltip"] = "Viewport effects when initiating the Readable UI.\n\nDefault: On."
		L["Title - Readable / Shortcuts"] = "Shortcuts"
		L["Checkbox - Readable / Shortcuts / Minimap Icon"] = "Minimap Icon"
		L["Checkbox - Readable / Shortcuts / Minimap Icon - Tooltip"] = "Display an icon on the minimap for quick access to library.\n\nDefault: On."
		L["Title - Readable / Audiobook"] = "Audiobook"
		L["Range - Readable / Audiobook - Rate"] = "Rate"
		L["Range - Readable / Audiobook - Rate - Tooltip"] = "Playback rate.\n\nDefault: 100%."
		L["Range - Readable / Audiobook - Volume"] = "Volume"
		L["Range - Readable / Audiobook - Volume - Tooltip"] = "Playback volume.\n\nDefault: 100%."
		L["Dropdown - Readable / Audiobook - Voice"] = "Narrator"
		L["Dropdown - Readable / Audiobook - Voice - Tooltip"] = "Playback voice."
		L["Dropdown - Readable / Audiobook - Special Voice"] = "Secondary Narrator"
		L["Dropdown - Readable / Audiobook - Special Voice - Tooltip"] = "Playback voice used on special paragraphs such as those wrapped in '<>'."
		L["Title - Gameplay"] = "Gameplay"
		L["Checkbox - Gameplay / Auto Select Option"] = "Auto Select Options"
		L["Checkbox - Gameplay / Auto Select Option - Tooltip"] = "Selects the best option for certain NPCs.\n\nDefault: Off."

		-- MORE
		L["Title - Audio"] = "Audio"
		L["Checkbox - Audio"] = "Enable Audio"
		L["Checkbox - Audio - Tooltip"] = "Enable sound effects and audio.\n\nDefault: On."
		L["Title - Settings"] = "Settings"
		L["Checkbox - Settings / Reset Settings"] = "Reset All Settings"
		L["Checkbox - Settings / Reset Settings - Tooltip"] = "Resets settings to default values.\n\nDefault: Off."

		L["Title - Credits"] = "Acknowledgements"
		L["Title - Credits / ZamestoTV"] = "ZamestoTV | Translator - Russian"
		L["Title - Credits / ZamestoTV - Tooltip"] = "Special thanks to ZamestoTV for the Russian translations!"
		L["Title - Credits / AKArenan"] = "AKArenan | Translator - Brazilian Portuguese"
		L["Title - Credits / AKArenan - Tooltip"] = "Special thanks to AKArenan for the Brazilian Portuguese translations!"
		L["Title - Credits / El1as1989"] = "El1as1989 | Translator - Spanish"
		L["Title - Credits / El1as1989 - Tooltip"] = "Special thanks to El1as1989 for the Spanish translations!"
		L["Title - Credits / huchang47"] = "huchang47 | Translator - Chinese (Simplified)"
		L["Title - Credits / huchang47 - Tooltip"] = "Special thanks to huchang47 for the Chinese (Simplified) translations!"
		L["Title - Credits / muiqo"] = "muiqo | Translator - German"
		L["Title - Credits / muiqo - Tooltip"] = "Special thanks to muiqo for the German translations!"
		L["Title - Credits / Crazyyoungs"] = "Crazyyoungs | Translator - Korean"
		L["Title - Credits / Crazyyoungs - Tooltip"] = "Special thanks to Crazyyoungs for the Korean translations!"
		L["Title - Credits / fang2hou"] = "fang2hou | Translator - Chinese (Traditional)"
		L["Title - Credits / fang2hou - Tooltip"] = "Special thanks to fang2hou for the Chinese (Traditional) translations!"
		L["Title - Credits / joaoc_pires"] = "Joao Pires | Code - Bug Fix"
		L["Title - Credits / joaoc_pires - Tooltip"] = "Special thanks to Joao Pires for the bug fix!"
	end

	--------------------------------
	-- READABLE UI
	--------------------------------

	do
		do -- LIBRARY
			-- PROMPTS
			L["Readable - Library - Prompt - Delete - Local"] = "This will permanently remove this entry from your PLAYER library."
			L["Readable - Library - Prompt - Delete - Global"] = "This will permanently remove this entry from the WARBAND library."
			L["Readable - Library - Prompt - Delete Button 1"] = "Remove"
			L["Readable - Library - Prompt - Delete Button 2"] = "Cancel"

			L["Readable - Library - Prompt - Import - Local"] = "Importing a saved state will overwrite your PLAYER library."
			L["Readable - Library - Prompt - Import - Global"] = "Importing a saved state will overwrite the WARBAND library."
			L["Readable - Library - Prompt - Import Button 1"] = "Import and Reload"
			L["Readable - Library - Prompt - Import Button 2"] = "Cancel"

			L["Readable - Library - TextPrompt - Import - Local"] = "Import to Player Library"
			L["Readable - Library - TextPrompt - Import - Global"] = "Import to Warband Library"
			L["Readable - Library - TextPrompt - Import Input Placeholder"] = "Enter Data Text"
			L["Readable - Library - TextPrompt - Import Button 1"] = "Import"

			L["Readable - Library - TextPrompt - Export - Local"] = "Copy Player Data to Clipboard "
			L["Readable - Library - TextPrompt - Export - Global"] = "Copy Warband Data to Clipboard "
			L["Readable - Library - TextPrompt - Export Input Placeholder"] = "Invalid Export Code"

			-- SIDEBAR
			L["Readable - Library - Search Input Placeholder"] = "Search"
			L["Readable - Library - Export Button"] = "Export"
			L["Readable - Library - Import Button"] = "Import"
			L["Readable - Library - Show"] = "Show"
			L["Readable - Library - Letters"] = "Letters"
			L["Readable - Library - Books"] = "Books"
			L["Readable - Library - Slates"] = "Slates"
			L["Readable - Library - Show only World"] = "Only World"

			-- TITLE
			L["Readable - Library - Name Text - Global"] = "Warband Library"
			L["Readable - Library - Name Text - Local - Subtext 1"] = ""
			L["Readable - Library - Name Text - Local - Subtext 2"] = "'s Library"
			L["Readable - Library - Showing Status Text - Subtext 1"] = "Showing "
			L["Readable - Library - Showing Status Text - Subtext 2"] = " Items"

			-- CONTENT
			L["Readable - Library - No Results Text - Subtext 1"] = "No Results for "
			L["Readable - Library - No Results Text - Subtext 2"] = "."
			L["Readable - Library - Empty Library Text"] = "No Entries."
		end

		do -- READABLE
			-- NOTIFICATIONS
			L["Readable - Notification - Saved To Library"] = "Saved to Library"

			-- TOOLTIP
			L["Readable - Tooltip - Change Page"] = "Scroll to change pages."
		end
	end

	--------------------------------
	-- AUDIOBOOK
	--------------------------------

	do
		L["Audiobook - Action Tooltip"] = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/mouse-left.png", 16, 16, 0, 0) .. " to Drag.\n" .. addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/mouse-right.png", 16, 16, 0, 0) .. " to Close."
	end

	--------------------------------
	-- INTERACTION QUEST FRAME
	--------------------------------

	do
		L["InteractionFrame.QuestFrame - Objectives"] = "Quest Objectives"
		L["InteractionFrame.QuestFrame - Rewards"] = "Rewards"
		L["InteractionFrame.QuestFrame - Required Items"] = "Required Items"

		L["InteractionFrame.QuestFrame - Accept - Quest Log Full"] = "Quest Log Full"
		L["InteractionFrame.QuestFrame - Accept - Auto Accept"] = "Auto Accepted"
		L["InteractionFrame.QuestFrame - Accept"] = "Accept"
		L["InteractionFrame.QuestFrame - Decline"] = "Decline"
		L["InteractionFrame.QuestFrame - Goodbye"] = "Goodbye"
		L["InteractionFrame.QuestFrame - Goodbye - Auto Accept"] = "Got it"
		L["InteractionFrame.QuestFrame - Continue"] = "Continue"
		L["InteractionFrame.QuestFrame - In Progress"] = "In Progress"
		L["InteractionFrame.QuestFrame - Complete"] = "Complete"
	end

	--------------------------------
	-- INTERACTION DIALOG FRAME
	--------------------------------

	do
		L["InteractionFrame.DialogFrame - Skip"] = "SKIP"
	end

	--------------------------------
	-- INTERACTION GOSSIP FRAME
	--------------------------------

	do
		L["InteractionFrame.GossipFrame - Close"] = "Goodbye"
	end

	--------------------------------
	-- INTERACTION CONTROL GUIDE
	--------------------------------

	do
		L["ControlGuide - Back"] = "Back"
		L["ControlGuide - Next"] = "Next"
		L["ControlGuide - Skip"] = "Skip"
		L["ControlGuide - Accept"] = "Accept"
		L["ControlGuide - Continue"] = "Continue"
		L["ControlGuide - Complete"] = "Complete"
		L["ControlGuide - Decline"] = "Decline"
		L["ControlGuide - Goodbye"] = "Goodbye"
		L["ControlGuide - Got it"] = "Got it"
		L["ControlGuide - Gossip Option Interact"] = "Select Option"
		L["ControlGuide - Quest Next Reward"] = "Next Reward"
	end

	--------------------------------
	-- ALERT NOTIFICATION
	--------------------------------

	do
		L["Alert Notification - Accept"] = "Quest Accepted"
		L["Alert Notification - Complete"] = "Quest Completed"
	end

	--------------------------------
	-- WAYPOINT
	--------------------------------

	do
		L["Waypoint - Ready for Turn-in"] = "Ready for Turn-in"

		L["Waypoint - Waypoint"] = "Waypoint"
		L["Waypoint - Quest"] = "Quest"
		L["Waypoint - Flight Point"] = "Flight Point"
		L["Waypoint - Pin"] = "Pin"
		L["Waypoint - Party Member"] = "Party Member"
		L["Waypoint - Content"] = "Content"
	end

	--------------------------------
	-- PLAYER STATUS BAR
	--------------------------------

	do
		L["PlayerStatusBar - TooltipLine1"] = "Current XP: "
		L["PlayerStatusBar - TooltipLine2"] = "Remaining XP: "
		L["PlayerStatusBar - TooltipLine3"] = "Level "
	end

	--------------------------------
	-- MINIMAP ICON
	--------------------------------

	do
		L["MinimapIcon - Tooltip - Title"] = "Interaction Library"
		L["MinimapIcon - Tooltip - Entries - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Subtext 2"] = " Entries"
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 2"] = " Entry"
		L["MinimapIcon - Tooltip - Entries - Empty"] = "No Entries."
	end

	--------------------------------
	-- BLIZZARD SETTINGS
	--------------------------------

	do
		L["BlizzardSettings - Title"] = "Open Settings"
		L["BlizzardSettings - Shortcut - Controller"] = "in any Interaction UI."
	end

	--------------------------------
	-- ALERTS
	--------------------------------

	do
		L["Alert - Under Attack"] = "Under Attack"
		L["Alert - Open Settings"] = "To open settings."
	end

	--------------------------------
	-- DIALOG DATA
	--------------------------------

	do
		-- Characters used for 'Dynamic Playback' pausing. Only supports single characters.
		L["DialogData - PauseCharDB"] = {
			"…",
			"!",
			"?",
			".",
			",",
			";",
		}

		-- Modifier of dialog playback speed to match the rough speed of base TTS in the language. Higher = faster.
		L["DialogData - PlaybackSpeedModifier"] = 1
	end

	--------------------------------
	-- GOSSIP DATA
	--------------------------------

	do
		-- Need to match Blizzard's special gossip option prefix text.
		L["GossipData - Trigger - Quest"] = "%(Quest%)"
		L["GossipData - Trigger - Movie 1"] = "%(Play%)"
		L["GossipData - Trigger - Movie 2"] = "%(Play Movie%)"
		L["GossipData - Trigger - NPC Dialog"] = "%<Stay awhile and listen.%>"
		L["GossipData - Trigger - NPC Dialog - Append"] = "Stay awhile and listen."
	end

	--------------------------------
	-- AUDIOBOOK DATA
	--------------------------------

	do
		-- Estimated character per second to roughly match the speed of the base TTS in the language. Higher = faster.
		-- This is a workaround for Blizzard TTS where it sometimes fails to continue to the next line, so we need to manually start it back up after a period of time.
		L["AudiobookData - EstimatedCharPerSecond"] = 10
	end

	--------------------------------
	-- SUPPORTED ADDONS
	--------------------------------

	do
		do -- BtWQuests
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Completed - Subtext 1"] = addon.Theme.RGB_GREEN_HEXCODE
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Completed - Subtext 2"] = "|r"
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Active - Subtext 1"] = addon.Theme.RGB_WHITE_HEXCODE
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Active - Subtext 2"] = "|r"
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Incomplete - Subtext 1"] = addon.Theme.RGB_GRAY_HEXCODE
			L["SupportedAddons - BtWQuests - Tooltip - Quest - Incomplete - Subtext 2"] = "|r"
			L["SupportedAddons - BtWQuests - Tooltip - Call to Action"] = addon.Theme.RGB_ORANGE_HEXCODE .. "Click to open quest chain in BtWQuests" .. "|r"
		end
	end
end

Load()
