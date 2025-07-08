-- Localization and translation muiqo

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

local function Load()
	if GetLocale() ~= "deDE" then
		return
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		-- WARNINGS
		L["Warning - Leave NPC Interaction"] = "Verlasse die NPC-Interaktion, um Einstellungen anzupassen."
		L["Warning - Leave ReadableUI"] = "Verlasse die Lesbare UI, um Einstellungen anzupassen."

		-- PROMPTS
		L["Prompt - Reload"] = "Interface-Neuladen erforderlich, um Einstellungen anzuwenden"
		L["Prompt - Reload Button 1"] = "Neuladen"
		L["Prompt - Reload Button 2"] = "Schließen"
		L["Prompt - Reset Settings"] = "Bist du sicher, dass du die Einstellungen zurücksetzen möchtest?"
		L["Prompt - Reset Settings Button 1"] = "Zurücksetzen"
		L["Prompt - Reset Settings Button 2"] = "Abbrechen"

		-- TABS
		L["Tab - Appearance"] = "Aussehen"
		L["Tab - Effects"] = "Effekte"
		L["Tab - Playback"] = "Wiedergabe"
		L["Tab - Controls"] = "Steuerung"
		L["Tab - Gameplay"] = "Gameplay"
		L["Tab - More"] = "Mehr"

		-- ELEMENTS
		-- APPEARANCE
		L["Title - Theme"] = "Theme"
		L["Range - Main Theme"] = "Haupt-Theme"
		L["Range - Main Theme - Tooltip"] = "Legt das allgemeine UI-Theme fest.\n\nStandard: Tag.\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "Dynamisch" .. addon.Theme.Settings.Tooltip_Text_Note .. " Option setzt das Haupt-Theme entsprechend dem Tag/Nacht-Zyklus im Spiel.|r"
		L["Range - Main Theme - Day"] = "TAG"
		L["Range - Main Theme - Night"] = "NACHT"
		L["Range - Main Theme - Dynamic"] = "DYNAMISCH"
		L["Range - Dialog Theme"] = "Dialog-Theme"
		L["Range - Dialog Theme - Tooltip"] = "Legt das NPC-Dialog-UI-Theme fest.\n\nStandard: Dynamisch.\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "Dynamisch" .. addon.Theme.Settings.Tooltip_Text_Note .. " Option setzt das Dialog-Theme passend zum Haupt-Theme.|r"
		L["Range - Dialog Theme - Auto"] = "DYNAMISCH"
		L["Range - Dialog Theme - Day"] = "TAG"
		L["Range - Dialog Theme - Night"] = "NACHT"
		L["Range - Dialog Theme - Rustic"] = "RUSTIKAL"
		L["Title - Appearance"] = "Aussehen"
		L["Range - UIDirection"] = "UI-Richtung"
		L["Range - UIDirection - Tooltip"] = "Legt die UI-Richtung fest."
		L["Range - UIDirection - Left"] = "LINKS"
		L["Range - UIDirection - Right"] = "RECHTS"
		L["Range - UIDirection / Dialog"] = "Feste Dialog-Position"
		L["Range - UIDirection / Dialog - Tooltip"] = "Legt die feste Dialog-Position fest.\n\nFester Dialog wird verwendet, wenn das Namensschild des NPCs nicht verfügbar ist."
		L["Range - UIDirection / Dialog - Top"] = "OBEN"
		L["Range - UIDirection / Dialog - Center"] = "MITTE"
		L["Range - UIDirection / Dialog - Bottom"] = "UNTEN"
		L["Checkbox - UIDirection / Dialog / Mirror"] = "Spiegeln"
		L["Checkbox - UIDirection / Dialog / Mirror - Tooltip"] = "Spiegelt die UI-Richtung."
		L["Range - Quest Frame Size"] = "Quest-Fenster-Größe"
		L["Range - Quest Frame Size - Tooltip"] = "Quest-Fenster-Größe anpassen.\n\nStandard: Mittel."
		L["Range - Quest Frame Size - Small"] = "KLEIN"
		L["Range - Quest Frame Size - Medium"] = "MITTEL"
		L["Range - Quest Frame Size - Large"] = "GROß"
		L["Range - Quest Frame Size - Extra Large"] = "EXTRA GROß"
		L["Range - Text Size"] = "Textgröße"
		L["Range - Text Size - Tooltip"] = "Textgröße anpassen."
		L["Title - Dialog"] = "Dialog"
		L["Checkbox - Dialog / Title / Progress Bar"] = "Fortschrittsbalken anzeigen"
		L["Checkbox - Dialog / Title / Progress Bar - Tooltip"] = "Zeigt oder versteckt den Dialog-Fortschrittsbalken.\n\nDieser Balken zeigt an, wie weit du im aktuellen Gespräch vorangeschritten bist.\n\nStandard: An."
		L["Range - Dialog / Title / Text Alpha"] = "Titel-Transparenz"
		L["Range - Dialog / Title / Text Alpha - Tooltip"] = "Legt die Transparenz des Dialog-Titels fest.\n\nStandard: 50%."
		L["Range - Dialog / Content Preview Alpha"] = "Vorschau-Transparenz"
		L["Range - Dialog / Content Preview Alpha - Tooltip"] = "Legt die Transparenz der Dialog-Text-Vorschau fest.\n\nStandard: 50%."
		L["Title - Gossip"] = "Geschwätz"
		L["Checkbox - Always Show Gossip Frame"] = "Geschwätz-Fenster immer anzeigen"
		L["Checkbox - Always Show Gossip Frame - Tooltip"] = "Geschwätz-Fenster immer anzeigen, wenn verfügbar, anstatt nur nach dem Dialog.\n\nStandard: An."
		L["Title - Quest"] = "Quest"
		L["Checkbox - Always Show Quest Frame"] = "Quest-Fenster immer anzeigen"
		L["Checkbox - Always Show Quest Frame - Tooltip"] = "Quest-Fenster immer anzeigen, wenn verfügbar, anstatt nur nach dem Dialog.\n\nStandard: An."

		-- VIEWPORT
		L["Title - Effects"] = "Effekte"
		L["Checkbox - Hide UI"] = "UI verstecken"
		L["Checkbox - Hide UI - Tooltip"] = "Versteckt die UI während der NPC-Interaktion.\n\nStandard: An."
		L["Range - Cinematic"] = "Kamera-Effekte"
		L["Range - Cinematic - Tooltip"] = "Kamera-Effekte während der Interaktion.\n\nStandard: Vollständig."
		L["Range - Cinematic - None"] = "KEINE"
		L["Range - Cinematic - Full"] = "VOLLSTÄNDIG"
		L["Range - Cinematic - Balanced"] = "AUSGEWOGEN"
		L["Range - Cinematic - Custom"] = "BENUTZERDEFINIERT"
		L["Checkbox - Zoom"] = "Zoom"
		L["Range - Zoom / Min Distance"] = "Min Entfernung"
		L["Range - Zoom / Min Distance - Tooltip"] = "Wenn der aktuelle Zoom unter diesem Schwellenwert liegt, zoomt die Kamera auf dieses Level."
		L["Range - Zoom / Max Distance"] = "Max Entfernung"
		L["Range - Zoom / Max Distance - Tooltip"] = "Wenn der aktuelle Zoom über diesem Schwellenwert liegt, zoomt die Kamera auf dieses Level."
		L["Checkbox - Zoom / Pitch"] = "Vertikalen Winkel anpassen"
		L["Checkbox - Zoom / Pitch - Tooltip"] = "Aktiviert die Anpassung des vertikalen Kamerawinkels."
		L["Range - Zoom / Pitch / Level"] = "Max Winkel"
		L["Range - Zoom / Pitch / Level - Tooltip"] = "Schwellenwert für den vertikalen Winkel."
		L["Checkbox - Zoom / Field Of View"] = "Sichtfeld anpassen"
		L["Checkbox - Pan"] = "Schwenken"
		L["Range - Pan / Speed"] = "Geschwindigkeit"
		L["Range - Pan / Speed - Tooltip"] = "Maximale Schwenkgeschwindigkeit."
		L["Checkbox - Dynamic Camera"] = "Dynamische Kamera"
		L["Checkbox - Dynamic Camera - Tooltip"] = "Aktiviert Einstellungen für dynamische Kamera."
		L["Checkbox - Dynamic Camera / Side View"] = "Seitenansicht"
		L["Checkbox - Dynamic Camera / Side View - Tooltip"] = "Passt Kamera für Seitenansicht an."
		L["Range - Dynamic Camera / Side View / Strength"] = "Stärke"
		L["Range - Dynamic Camera / Side View / Strength - Tooltip"] = "Höherer Wert verstärkt die seitliche Bewegung."
		L["Checkbox - Dynamic Camera / Offset"] = "Versatz"
		L["Checkbox - Dynamic Camera / Offset - Tooltip"] = "Versetzt das Ansichtsfenster vom Charakter."
		L["Range - Dynamic Camera / Offset / Strength"] = "Stärke"
		L["Range - Dynamic Camera / Offset / Strength - Tooltip"] = "Höherer Wert verstärkt den Versatz."
		L["Checkbox - Dynamic Camera / Focus"] = "Fokus"
		L["Checkbox - Dynamic Camera / Focus - Tooltip"] = "Fokussiert das Ansichtsfenster auf das Ziel."
		L["Range - Dynamic Camera / Focus / Strength"] = "Stärke"
		L["Range - Dynamic Camera / Focus / Strength - Tooltip"] = "Höherer Wert verstärkt die Fokusstärke."
		L["Checkbox - Dynamic Camera / Focus / X"] = "X-Achse ignorieren"
		L["Checkbox - Dynamic Camera / Focus / X - Tooltip"] = "Verhindert X-Achsen-Fokus."
		L["Checkbox - Dynamic Camera / Focus / Y"] = "Y-Achse ignorieren"
		L["Checkbox - Dynamic Camera / Focus / Y - Tooltip"] = "Verhindert Y-Achsen-Fokus."
		L["Checkbox - Vignette"] = "Vignette"
		L["Checkbox - Vignette - Tooltip"] = "Reduziert die Randhelligkeit."
		L["Checkbox - Vignette / Gradient"] = "Verlauf"
		L["Checkbox - Vignette / Gradient - Tooltip"] = "Reduziert die Helligkeit hinter Geschwätz- und Quest-Interface-Elementen."

		-- PLAYBACK
		L["Title - Pace"] = "Tempo"
		L["Range - Playback Speed"] = "Wiedergabegeschwindigkeit"
		L["Range - Playback Speed - Tooltip"] = "Geschwindigkeit der Textwiedergabe.\n\nStandard: 100%."
		L["Checkbox - Dynamic Playback"] = "Natürliche Wiedergabe"
		L["Checkbox - Dynamic Playback - Tooltip"] = "Fügt Interpunktionspausen im Dialog hinzu.\n\nStandard: An."
		L["Title - Auto Progress"] = "Auto-Fortschritt"
		L["Checkbox - Auto Progress"] = "Aktivieren"
		L["Checkbox - Auto Progress - Tooltip"] = "Automatisch zum nächsten Dialog fortschreiten.\n\nStandard: An."
		L["Checkbox - Auto Close Dialog"] = "Auto-Schließen"
		L["Checkbox - Auto Close Dialog - Tooltip"] = "NPC-Interaktion beenden, wenn keine Optionen verfügbar sind.\n\nStandard: An."
		L["Range - Auto Progress / Delay"] = "Verzögerung"
		L["Range - Auto Progress / Delay - Tooltip"] = "Verzögerung vor dem nächsten Dialog.\n\nStandard: 1."
		L["Title - Text To Speech"] = "Text-zu-Sprache"
		L["Checkbox - Text To Speech"] = "Aktivieren"
		L["Checkbox - Text To Speech - Tooltip"] = "Liest Dialog-Text vor.\n\nStandard: Aus."
		L["Title - Text To Speech / Playback"] = "Wiedergabe"
		L["Checkbox - Text To Speech / Quest"] = "Quest abspielen"
		L["Checkbox - Text To Speech / Quest - Tooltip"] = "Aktiviert Text-zu-Sprache für Quest-Dialoge.\n\nStandard: An."
		L["Checkbox - Text To Speech / Gossip"] = "Geschwätz abspielen"
		L["Checkbox - Text To Speech / Gossip - Tooltip"] = "Aktiviert Text-zu-Sprache für Geschwätz-Dialoge.\n\nStandard: An."
		L["Range - Text To Speech / Rate"] = "Geschwindigkeit"
		L["Range - Text To Speech / Rate - Tooltip"] = "Sprachgeschwindigkeits-Versatz.\n\nStandard: 100%."
		L["Range - Text To Speech / Volume"] = "Lautstärke"
		L["Range - Text To Speech / Volume - Tooltip"] = "Sprach-Lautstärke.\n\nStandard: 100%."
		L["Title - Text To Speech / Voice"] = "Stimme"
		L["Dropdown - Text To Speech / Voice / Neutral"] = "Neutral"
		L["Dropdown - Text To Speech / Voice / Neutral - Tooltip"] = "Verwendet für geschlechtsneutrale NPCs."
		L["Dropdown - Text To Speech / Voice / Male"] = "Männlich"
		L["Dropdown - Text To Speech / Voice / Male - Tooltip"] = "Verwendet für männliche NPCs."
		L["Dropdown - Text To Speech / Voice / Female"] = "Weiblich"
		L["Dropdown - Text To Speech / Voice / Female - Tooltip"] = "Verwendet für weibliche NPCs."
		L["Dropdown - Text To Speech / Voice / Emote"] = "Ausdruck"
		L["Dropdown - Text To Speech / Voice / Emote - Tooltip"] = "Verwendet für Dialoge in '<>'."
		L["Checkbox - Text To Speech / Player / Voice"] = "Spieler-Stimme"
		L["Checkbox - Text To Speech / Player / Voice - Tooltip"] = "Spielt TTS beim Auswählen einer Dialog-Option ab.\n\nStandard: An."
		L["Dropdown - Text To Speech / Player / Voice / Voice"] = "Stimme"
		L["Dropdown - Text To Speech / Player / Voice / Voice - Tooltip"] = "Stimme für Dialog-Optionen."
		L["Title - More"] = "Mehr"
		L["Checkbox - Mute Dialog"] = "NPC-Dialog stummschalten"
		L["Checkbox - Mute Dialog - Tooltip"] = "Schaltet Blizzards NPC-Dialog-Audio während der NPC-Interaktion stumm.\n\nStandard: Aus."

		-- CONTROLS
		L["Title - UI"] = "UI"
		L["Checkbox - UI / Control Guide"] = "Steuerungsanleitung anzeigen"
		L["Checkbox - UI / Control Guide - Tooltip"] = "Zeigt das Steuerungsanleitungs-Fenster an.\n\nStandard: An."
		L["Title - Platform"] = "Plattform"
		L["Range - Platform"] = "Plattform"
		L["Range - Platform - Tooltip"] = "Erfordert Interface-Neuladen, um wirksam zu werden."
		L["Range - Platform - PC"] = "PC"
		L["Range - Platform - Playstation"] = "Playstation"
		L["Range - Platform - Xbox"] = "Xbox"
		L["Title - PC"] = "PC"
		L["Title - PC / Keyboard"] = "Tastatur"
		L["Checkbox - PC / Keyboard / Use Interact Key"] = "Interaktions-Taste verwenden"
		L["Checkbox - PC / Keyboard / Use Interact Key - Tooltip"] = "Verwende die Interaktions-Taste zum Fortschreiten. Mehrfach-Tastenkombinationen werden nicht unterstützt.\n\nStandard: Aus."
		L["Title - PC / Mouse"] = "Maus"
		L["Checkbox - PC / Mouse / Flip Mouse Controls"] = "Maussteuerung umkehren"
		L["Checkbox - PC / Mouse / Flip Mouse Controls - Tooltip"] = "Kehrt linke und rechte Maussteuerung um.\n\nStandard: Aus."
		L["Title - PC / Keybind"] = "Tastenbelegung"
		L["Keybind - PC / Keybind / Previous"] = "Vorherige"
		L["Keybind - PC / Keybind / Previous - Tooltip"] = "Vorheriger Dialog-Tastenbelegung.\n\nStandard: Q."
		L["Keybind - PC / Keybind / Next"] = "Nächste"
		L["Keybind - PC / Keybind / Next - Tooltip"] = "Nächster Dialog-Tastenbelegung.\n\nStandard: E."
		L["Keybind - PC / Keybind / Progress"] = "Fortschritt"
		L["Keybind - PC / Keybind / Progress - Tooltip"] = "Tastenbelegung für:\n- Überspringen\n- Akzeptieren\n- Fortfahren\n- Abschließen\n\nStandard: LEERTASTE."
		L["Keybind - PC / Keybind / Progress - Tooltip / Conflict"] = addon.Theme.Settings.Tooltip_Text_Warning_Highlight .. "Interaktions-Taste verwenden" .. addon.Theme.Settings.Tooltip_Text_Warning .. " Option muss deaktiviert sein, um diese Tastenbelegung anzupassen.|r"
		L["Keybind - PC / Keybind / Quest Next Reward"] = "Nächste Belohnung"
		L["Keybind - PC / Keybind / Quest Next Reward - Tooltip"] = "Tastenbelegung zur Auswahl der nächsten Quest-Belohnung.\n\nStandard: TAB."
		L["Keybind - PC / Keybind / Close"] = "Schließen"
		L["Keybind - PC / Keybind / Close - Tooltip"] = "Tastenbelegung zum Schließen des aktuell aktiven Interaktions-Fensters.\n\nStandard: ESC."
		L["Title - Controller"] = "Controller"
		L["Title - Controller / Controller"] = "Controller"

		-- GAMEPLAY
		L["Title - Waypoint"] = "Wegpunkt"
		L["Checkbox - Waypoint"] = "Aktivieren"
		L["Checkbox - Waypoint - Tooltip"] = "Wegpunkt-Ersatz für Blizzards In-Game-Navigation.\n\nStandard: An."
		L["Checkbox - Waypoint / Audio"] = "Audio"
		L["Checkbox - Waypoint / Audio - Tooltip"] = "Soundeffekte, wenn sich der Wegpunkt-Status ändert.\n\nStandard: An."
		L["Title - Readable"] = "Lesbare Gegenstände"
		L["Checkbox - Readable"] = "Aktivieren"
		L["Checkbox - Readable - Tooltip"] = "Aktiviert benutzerdefinierte Oberfläche für Lesbare Gegenstände - und Bibliothek zur Speicherung.\n\nStandard: An."
		L["Title - Readable / Display"] = "Anzeige"
		L["Checkbox - Readable / Display / Always Show Item"] = "Gegenstand immer anzeigen"
		L["Checkbox - Readable / Display / Always Show Item - Tooltip"] = "Verhindert, dass sich die lesbare Oberfläche schließt, wenn man die Entfernung zu einem Gegenstand in der Welt verlässt.\n\nStandard: Aus."
		L["Title - Readable / Viewport"] = "Ansichtsfenster"
		L["Checkbox - Readable / Viewport"] = "Ansichtsfenster-Effekte verwenden"
		L["Checkbox - Readable / Viewport - Tooltip"] = "Ansichtsfenster-Effekte beim Initiieren der Lesbaren UI.\n\nStandard: An."
		L["Title - Readable / Shortcuts"] = "Verknüpfungen"
		L["Checkbox - Readable / Shortcuts / Minimap Icon"] = "Minimap-Symbol"
		L["Checkbox - Readable / Shortcuts / Minimap Icon - Tooltip"] = "Zeigt ein Symbol auf der Minimap für schnellen Zugriff auf die Bibliothek.\n\nStandard: An."
		L["Title - Readable / Audiobook"] = "Hörbuch"
		L["Range - Readable / Audiobook - Rate"] = "Geschwindigkeit"
		L["Range - Readable / Audiobook - Rate - Tooltip"] = "Wiedergabe-Geschwindigkeit.\n\nStandard: 100%."
		L["Range - Readable / Audiobook - Volume"] = "Lautstärke"
		L["Range - Readable / Audiobook - Volume - Tooltip"] = "Wiedergabe-Lautstärke.\n\nStandard: 100%."
		L["Dropdown - Readable / Audiobook - Voice"] = "Erzähler"
		L["Dropdown - Readable / Audiobook - Voice - Tooltip"] = "Wiedergabe-Stimme."
		L["Dropdown - Readable / Audiobook - Special Voice"] = "Zweiter Erzähler"
		L["Dropdown - Readable / Audiobook - Special Voice - Tooltip"] = "Wiedergabe-Stimme für spezielle Absätze wie die in '<>' eingeschlossenen."
		L["Title - Gameplay"] = "Gameplay"
		L["Checkbox - Gameplay / Auto Select Option"] = "Optionen automatisch auswählen"
		L["Checkbox - Gameplay / Auto Select Option - Tooltip"] = "Wählt die beste Option für bestimmte NPCs.\n\nStandard: Aus."

		-- MORE
		L["Title - Audio"] = "Audio"
		L["Checkbox - Audio"] = "Audio aktivieren"
		L["Checkbox - Audio - Tooltip"] = "Aktiviert Soundeffekte und Audio.\n\nStandard: An."
		L["Title - Settings"] = "Einstellungen"
		L["Checkbox - Settings / Reset Settings"] = "Alle Einstellungen zurücksetzen"
		L["Checkbox - Settings / Reset Settings - Tooltip"] = "Setzt Einstellungen auf Standardwerte zurück.\n\nStandard: Aus."

		L["Title - Credits"] = "Danksagungen"
	end

	--------------------------------
	-- READABLE UI
	--------------------------------

	do
		do -- LIBRARY
			-- PROMPTS
			L["Readable - Library - Prompt - Delete - Local"] = "Dies wird diesen Eintrag permanent aus deiner SPIELER-Bibliothek entfernen."
			L["Readable - Library - Prompt - Delete - Global"] = "Dies wird diesen Eintrag permanent aus der KRIEGSTRUPP-Bibliothek entfernen."
			L["Readable - Library - Prompt - Delete Button 1"] = "Entfernen"
			L["Readable - Library - Prompt - Delete Button 2"] = "Abbrechen"

			L["Readable - Library - Prompt - Import - Local"] = "Das Importieren eines gespeicherten Zustands überschreibt deine SPIELER-Bibliothek."
			L["Readable - Library - Prompt - Import - Global"] = "Das Importieren eines gespeicherten Zustands überschreibt die KRIEGSTRUPP-Bibliothek."
			L["Readable - Library - Prompt - Import Button 1"] = "Importieren und Neuladen"
			L["Readable - Library - Prompt - Import Button 2"] = "Abbrechen"

			L["Readable - Library - TextPrompt - Import - Local"] = "In Spieler-Bibliothek importieren"
			L["Readable - Library - TextPrompt - Import - Global"] = "In Kriegstrupp-Bibliothek importieren"
			L["Readable - Library - TextPrompt - Import Input Placeholder"] = "Datentext eingeben"
			L["Readable - Library - TextPrompt - Import Button 1"] = "Importieren"

			L["Readable - Library - TextPrompt - Export - Local"] = "Spielerdaten in Zwischenablage kopieren"
			L["Readable - Library - TextPrompt - Export - Global"] = "Kriegstrupp-Daten in Zwischenablage kopieren"
			L["Readable - Library - TextPrompt - Export Input Placeholder"] = "Ungültiger Export-Code"

			-- SIDEBAR
			L["Readable - Library - Search Input Placeholder"] = "Suchen"
			L["Readable - Library - Export Button"] = "Exportieren"
			L["Readable - Library - Import Button"] = "Importieren"
			L["Readable - Library - Show"] = "Anzeigen"
			L["Readable - Library - Letters"] = "Briefe"
			L["Readable - Library - Books"] = "Bücher"
			L["Readable - Library - Slates"] = "Tafeln"
			L["Readable - Library - Show only World"] = "Nur Welt"

			-- TITLE
			L["Readable - Library - Name Text - Global"] = "Kriegstrupp-Bibliothek"
			L["Readable - Library - Name Text - Local - Subtext 1"] = ""
			L["Readable - Library - Name Text - Local - Subtext 2"] = "s Bibliothek"
			L["Readable - Library - Showing Status Text - Subtext 1"] = "Zeige "
			L["Readable - Library - Showing Status Text - Subtext 2"] = " Gegenstände"

			-- CONTENT
			L["Readable - Library - No Results Text - Subtext 1"] = "Keine Ergebnisse für "
			L["Readable - Library - No Results Text - Subtext 2"] = "."
			L["Readable - Library - Empty Library Text"] = "Keine Einträge."
		end

		do -- READABLE
			-- NOTIFICATIONS
			L["Readable - Notification - Saved To Library"] = "In Bibliothek gespeichert"

			-- TOOLTIP
			L["Readable - Tooltip - Change Page"] = "Scrollen zum Seitenwechsel."
		end
	end

	--------------------------------
	-- AUDIOBOOK
	--------------------------------

	do
		L["Audiobook - Action Tooltip"] = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/mouse-left.png", 16, 16, 0, 0) .. " zum Ziehen.\n" .. addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/mouse-right.png", 16, 16, 0, 0) .. " zum Schließen."
	end

	--------------------------------
	-- INTERACTION QUEST FRAME
	--------------------------------

	do
		L["InteractionFrame.QuestFrame - Objectives"] = "Quest-Ziele"
		L["InteractionFrame.QuestFrame - Rewards"] = "Belohnungen"
		L["InteractionFrame.QuestFrame - Required Items"] = "Benötigte Gegenstände"

		L["InteractionFrame.QuestFrame - Accept - Quest Log Full"] = "Questlog voll"
		L["InteractionFrame.QuestFrame - Accept - Auto Accept"] = "Automatisch akzeptiert"
		L["InteractionFrame.QuestFrame - Accept"] = "Annehmen"
		L["InteractionFrame.QuestFrame - Decline"] = "Ablehnen"
		L["InteractionFrame.QuestFrame - Goodbye"] = "Tschüss"
		L["InteractionFrame.QuestFrame - Goodbye - Auto Accept"] = "Verstanden"
		L["InteractionFrame.QuestFrame - Continue"] = "Fortfahren"
		L["InteractionFrame.QuestFrame - In Progress"] = "In Bearbeitung"
		L["InteractionFrame.QuestFrame - Complete"] = "Abschließen"
	end

	--------------------------------
	-- INTERACTION DIALOG FRAME
	--------------------------------

	do
		L["InteractionFrame.DialogFrame - Skip"] = "ÜBERSPRINGEN"
	end

	--------------------------------
	-- INTERACTION GOSSIP FRAME
	--------------------------------

	do
		L["InteractionFrame.GossipFrame - Close"] = "Tschüss"
	end

	--------------------------------
	-- INTERACTION CONTROL GUIDE
	--------------------------------

	do
		L["ControlGuide - Back"] = "Zurück"
		L["ControlGuide - Next"] = "Weiter"
		L["ControlGuide - Skip"] = "Überspringen"
		L["ControlGuide - Accept"] = "Akzeptieren"
		L["ControlGuide - Continue"] = "Fortfahren"
		L["ControlGuide - Complete"] = "Abschließen"
		L["ControlGuide - Decline"] = "Ablehnen"
		L["ControlGuide - Goodbye"] = "Tschüss"
		L["ControlGuide - Got it"] = "Verstanden"
		L["ControlGuide - Gossip Option Interact"] = "Option wählen"
		L["ControlGuide - Quest Next Reward"] = "Nächste Belohnung"
	end

	--------------------------------
	-- ALERT NOTIFICATION
	--------------------------------

	do
		L["Alert Notification - Accept"] = "Quest angenommen"
		L["Alert Notification - Complete"] = "Quest abgeschlossen"
	end

	--------------------------------
	-- WAYPOINT
	--------------------------------

	do
		L["Waypoint - Ready for Turn-in"] = "Bereit zur Abgabe"

		L["Waypoint - Waypoint"] = "Wegpunkt"
		L["Waypoint - Quest"] = "Quest"
		L["Waypoint - Flight Point"] = "Flugpunkt"
		L["Waypoint - Pin"] = "Markierung"
		L["Waypoint - Party Member"] = "Gruppenmitglied"
		L["Waypoint - Content"] = "Inhalt"
	end

	--------------------------------
	-- PLAYER STATUS BAR
	--------------------------------

	do
		L["PlayerStatusBar - TooltipLine1"] = "Aktuelle EP: "
		L["PlayerStatusBar - TooltipLine2"] = "Verbleibende EP: "
		L["PlayerStatusBar - TooltipLine3"] = "Level "
	end

	--------------------------------
	-- MINIMAP ICON
	--------------------------------

	do
		L["MinimapIcon - Tooltip - Title"] = "Interaktions-Bibliothek"
		L["MinimapIcon - Tooltip - Entries - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Subtext 2"] = " Einträge"
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 2"] = " Eintrag"
		L["MinimapIcon - Tooltip - Entries - Empty"] = "Keine Einträge."
	end

	--------------------------------
	-- BLIZZARD SETTINGS
	--------------------------------

	do
		L["BlizzardSettings - Title"] = "Einstellungen öffnen"
		L["BlizzardSettings - Shortcut - Controller"] = "in jeder Interaktions-UI."
	end

	--------------------------------
	-- ALERTS
	--------------------------------

	do
		L["Alert - Under Attack"] = "Unter Beschuss"
		L["Alert - Open Settings"] = "Um Einstellungen zu öffnen."
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
		L["GossipData - Trigger - Quest"] = "%(Aufgabe%)"
		L["GossipData - Trigger - Movie 1"] = "%(Abspielen%)"
		L["GossipData - Trigger - Movie 2"] = "%(Film abspielen%)"
		L["GossipData - Trigger - NPC Dialog"] = "%<Bleibt ein Weilchen und hört zu.%>"
		L["GossipData - Trigger - NPC Dialog - Append"] = "Bleibt ein Weilchen und hört zu."
	end

	--------------------------------
	-- AUDIOBOOK DATA
	--------------------------------

	do
		-- Estimated character per second to roughly match the speed of the base TTS in the language. Higher = faster.
		-- This is a workaround for Blizzard TTS where it sometimes fails to continue to the next line, so we need to manually start it back up after a period of time.
		L["AudiobookData - EstimatedCharPerSecond"] = 12
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
			L["SupportedAddons - BtWQuests - Tooltip - Call to Action"] = addon.Theme.RGB_ORANGE_HEXCODE .. "Klicken, um Questkette in BtWQuests zu öffnen" .. "|r"
		end
	end
end

Load()
