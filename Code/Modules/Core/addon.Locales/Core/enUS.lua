local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

local function Load()
	-- Base Localization -- Other languages if with no translations will default to this.
	-- Work In Progress -- Will add support for new localization system in the future!

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		-- WARNINGS
		L["Warning - Leave NPC Interaction"] = "Leave NPC Interaction to Adjust Settings."
		L["Warning - Leave ReadableUI"] = "Leave Readable UI to Adjust Settings."

		-- PROMPTS
		L["Prompt - Reload"] = "Interface Reload Required to Apply Settings"
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
		L["Range - Main Theme - Tooltip"] = "Sets the overall UI theme.\n\nDefault: Day."
		L["Range - Dialog Theme"] = "Dialog Theme"
		L["Range - Dialog Theme - Tooltip"] = "Sets the NPC dialog UI theme.\n\nDefault: Auto."
		L["Title - Appearance"] = "Appearance"
		L["Range - Orientation"] = "UI Direction"
		L["Range - Orientation - Tooltip"] = "Sets the UI direction."
		L["Title - Text"] = "Text"
		L["Range - Content Size"] = "Content Size"
		L["Range - Content Size - Tooltip"] = "Adjust size of dialog text."
		L["Title - Dialog"] = "Dialog"
		L["Checkbox - Dialog / Title / Progress Bar"] = "Show Progress Bar"
		L["Checkbox - Dialog / Title / Progress Bar - Tooltip"] = "Shows or hides the dialog progress bar.\n\nThis bar indicates how far you've progressed through the current conversation.\n\nDefault: On."
		L["Range - Dialog / Title / Text Alpha"] = "Title Opacity"
		L["Range - Dialog / Title / Text Alpha - Tooltip"] = "Sets the opacity of the dialog title.\n\nDefault: 50%."
		L["Range - Dialog / Content Preview Alpha"] = "Preview Opacity"
		L["Range - Dialog / Content Preview Alpha - Tooltip"] = "Sets the opacity of the dialog text preview.\n\nDefault: 50%."
		L["Title - Quest"] = "Quest"
		L["Checkbox - Always Show Quest Frame"] = "Always Show Quest Frame"
		L["Checkbox - Always Show Quest Frame - Tooltip"] = "Always show the quest frame when available instead of only after dialog.\n\nDefault: On."

		-- VIEWPORT
		L["Title - Effects"] = "Effects"
		L["Checkbox - Hide UI"] = "Hide UI"
		L["Checkbox - Hide UI - Tooltip"] = "Hides UI during NPC interaction.\n\nDefault: On."
		L["Range - Cinematic"] = "Camera Effects"
		L["Range - Cinematic - Tooltip"] = "Camera effects during interaction.\n\nDefault: Full."
		L["Checkbox - Zoom"] = "Zoom"
		L["Range - Zoom Distance"] = "Max Distance"
		L["Range - Zoom Distance - Tooltip"] = "Zoom threshold."
		L["Checkbox - Zoom Pitch"] = "Adjust Vertical Angle"
		L["Checkbox - Zoom Pitch - Tooltip"] = "Enable vertical camera angle adjustment."
		L["Range - Zoom Pitch / Level"] = "Max Angle"
		L["Range - Zoom Pitch / Level - Tooltip"] = "Vertical angle threshold."
		L["Checkbox - Field Of View"] = "Adjust FOV"
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
		L["Title - Platform"] = "Platform"
		L["Range - Platform"] = "Platform"
		L["Range - Platform - Tooltip"] = "Requires Interface Reload to take effect."
		L["Range - Platform - PC"] = "PC"
		L["Range - Platform - Playstation"] = "Playstation"
		L["Range - Platform - Xbox"] = "Xbox"
		L["Title - PC / Keyboard"] = "Keyboard"
		L["Checkbox - PC / Use Interact Key"] = "Use Interact Key"
		L["Checkbox - PC / Use Interact Key - Tooltip"] = "Use the interact key for Skip/Accept instead of Space. Multi-key combinations not supported.\n\nDefault: Off."
		L["Title - PC / Mouse"] = "Mouse"
		L["Checkbox - PC / Flip Mouse Controls"] = "Flip Mouse Controls"
		L["Checkbox - PC / Flip Mouse Controls - Tooltip"] = "Flip Left and Right mouse controls.\n\nDefault: Off."
		L["Title - Controller / Controller"] = "Controller"

		-- GAMEPLAY
		L["Title - Waypoint"] = "Waypoint"
		L["Checkbox - Waypoint"] = "Enable"
		L["Checkbox - Waypoint - Tooltip"] = "Waypoint replacement for Blizzard's in-game navigation.\n\n|cffBB0000This option will enable the Blizzard setting: 'In-game Navigation'.\n\nThis option will increase memory usage.|r\n\nDefault: Off."
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
		L["Title - Gameplay"] = "Gameplay"
		L["Checkbox - Gameplay / Auto Select Option"] = "Auto Select Options"
		L["Checkbox - Gameplay / Auto Select Option - Tooltip"] = "Selects best option for certain NPCs.\n\nDefault: Off."

		-- MORE
		L["Title - Audio"] = "Audio"
		L["Checkbox - Audio"] = "Enable Audio"
		L["Checkbox - Audio - Tooltip"] = "Enable sound effects and audio.\n\nDefault: On."
		L["Title - Settings"] = "Settings"
		L["Checkbox - Settings / Reset Settings"] = "Reset All Settings"
		L["Checkbox - Settings / Reset Settings - Tooltip"] = "Resets settings to default values.\n\nDefault: Off."
	end

	--------------------------------
	-- READABLE UI
	--------------------------------

	do
		-- PROMPTS
		L["Readable - Prompt - Delete"] = "This will permanently remove this entry from your library."
		L["Readable - Prompt - Delete Button 1"] = "Remove"
		L["Readable - Prompt - Delete Button 2"] = "Cancel"

		L["Readable - Prompt - Import"] = "Importing a saved state will overwrite your current library."
		L["Readable - Prompt - Import Button 1"] = "Import and Reload"
		L["Readable - Prompt - Import Button 2"] = "Cancel"

		L["Readable - TextPrompt - Import"] = "Paste Data Text"
		L["Readable - TextPrompt - Import Input Placeholder"] = "Enter Data Text"
		L["Readable - TextPrompt - Import Button 1"] = "Import"

		L["Readable - TextPrompt - Export"] = "Copy Data to Clipboard "
		L["Readable - TextPrompt - Export Input Placeholder"] = "Invalid Export Code"

		-- NOTIFICATIONS
		L["Readable - Notification - Saved To Library"] = "Saved to Library"

		-- SIDEBAR
		L["Readable - Show"] = "Show"
		L["Readable - Letters"] = "Letters"
		L["Readable - Books"] = "Books"
		L["Readable - Slates"] = "Slates"
		L["Readable - Show only World"] = "Only World"

		-- TITLE
		L["Readable - Showing Status Text - Subtext 1"] = "Showing "
		L["Readable - Showing Status Text - Subtext 2"] = " Items"

		-- CONTENT
		L["Readable - No Results Text - Subtext 1"] = "No Results for "
		L["Readable - No Results Text - Subtext 2"] = "."
		L["Readable - Empty Library Text"] = "Empty Library."
	end

	--------------------------------
	-- INTERACTION QUEST FRAME
	--------------------------------

	do
		L["InteractionQuestFrame - Objectives"] = "Objectives"
		L["InteractionQuestFrame - Rewards"] = "Rewards"
		L["InteractionQuestFrame - Required Items"] = "Required Items"

		L["InteractionQuestFrame - Quest Log Full"] = "Quest Log Full"
		L["InteractionQuestFrame - Accept"] = "Accept"
		L["InteractionQuestFrame - Decline"] = "Decline"
		L["InteractionQuestFrame - Goodbye"] = "Goodbye"
		L["InteractionQuestFrame - Continue"] = "Continue"
		L["InteractionQuestFrame - In Progress"] = "In Progress"
		L["InteractionQuestFrame - Complete"] = "Complete"
	end

	--------------------------------
	-- INTERACTION DIALOG FRAME
	--------------------------------

	do
		L["InteractionDialogFrame - Skip"] = "SKIP"
	end

	--------------------------------
	-- INTERACTION GOSSIP FRAME
	--------------------------------

	do
		L["InteractionGossipFrame - Close"] = "Goodbye"
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
		L["MinimapIcon - Text"] = "Open Interaction Library."
	end

	--------------------------------
	-- BLIZZARD SETTINGS
	--------------------------------

	do
		L["BlizzardSettings - Title"] = "Open Settings"
		L["BlizzardSettings - Shortcut - Controller"] = "in any Interaction UI."
	end

	--------------------------------
	-- AUTO SELECT OPTIONS
	--------------------------------

	do
		L["AutoSelectOptions - Check - Trading Post"] = ""
	end

	--------------------------------
	-- ALERTS
	--------------------------------

	do
		L["Alert - Under Attack"] = "Under Attack"
		L["Alert - Open Settings"] = "To open settings."
	end

	--------------------------------
	-- GOSSIP DATA
	--------------------------------

	do
		L["GossipData - Trigger - Quest"] = "%(Quest%)"
		L["GossipData - Trigger - Movie 1"] = "%(Play%)"
		L["GossipData - Trigger - Movie 2"] = "%(Play Movie%)"
		L["GossipData - Trigger - NPC Dialog"] = "%<Stay awhile and listen.%>"
		L["GossipData - Trigger - NPC Dialog - Subtext 1"] = "Stay awhile and listen."
	end
end

Load()
