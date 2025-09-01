-- Localization and translation El1as1989

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

local function Load()
	if GetLocale() ~= "esES" then
		return
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		-- WARNINGS
		L["Warning - Leave NPC Interaction"] = "Deja de interactuar con los NPC para ajustar la configuración."
		L["Warning - Leave ReadableUI"] = "Salga de la interfaz para ajustar la configuración."

		-- PROMPTS
		L["Prompt - Reload"] = "Es necesario recargar la interfaz para aplicar los ajustes."
		L["Prompt - Reload Button 1"] = "Recarga"
		L["Prompt - Reload Button 2"] = "Cerrar"
		L["Prompt - Reset Settings"] = "¿Seguro que quieres restablecer la configuración?"
		L["Prompt - Reset Settings Button 1"] = "Restablecer"
		L["Prompt - Reset Settings Button 2"] = "Cancelar"

		-- TABS
		L["Tab - Appearance"] = "Apariencia"
		L["Tab - Effects"] = "Efectos"
		L["Tab - Playback"] = "Reproducción"
		L["Tab - Controls"] = "Controles"
		L["Tab - Gameplay"] = "Jugabilidad"
		L["Tab - More"] = "Más"

		-- ELEMENTS
		-- APPEARANCE
		L["Title - Theme"] = "Tema"
		L["Range - Main Theme"] = "Tema Principal"
		L["Range - Main Theme - Tooltip"] = "Define el tema general de la interfaz.\n\nPor defecto: DÍA\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "Dinámico" .. addon.Theme.Settings.Tooltip_Text_Note .. "La opción establece el tema principal según el ciclo día/noche dentro del juego.|r"
		L["Range - Main Theme - Day"] = "DÍA"
		L["Range - Main Theme - Night"] = "NOCHE"
		L["Range - Main Theme - Dynamic"] = "DINÁMICO"
		L["Range - Dialog Theme"] = "Tema del diálogo"
		L["Range - Dialog Theme - Tooltip"] = "Establece el tema de la interfaz de diálogo del NPC.\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "AUTO" .. addon.Theme.Settings.Tooltip_Text_Note .. " Esta opción ajusta el tema del diálogo para que coincida con el tema principal.|r"
		L["Range - Dialog Theme - Auto"] = "AUTO"
		L["Range - Dialog Theme - Day"] = "DÍA"
		L["Range - Dialog Theme - Night"] = "NOCHE"
		L["Range - Dialog Theme - Rustic"] = "RÚSTICO"
		L["Title - Appearance"] = "Apariencia"
		L["Range - UIDirection"] = "Posicionamiento de la interfaz"
		L["Range - UIDirection - Tooltip"] = "Define la posición de la interfaz."
		L["Range - UIDirection - Left"] = "IZQUIERDA"
		L["Range - UIDirection - Right"] = "DERECHA"
		L["Range - UIDirection / Dialog"] = "Posición fija de la ventana de diálogo"
		L["Range - UIDirection / Dialog - Tooltip"] = "Establece la posición fija de la ventana de diálogo.\n\nPosición fija de diálogo se utiliza cuando la placa de nombre del NPC no está disponible."
		L["Range - UIDirection / Dialog - Top"] = "TOP"
		L["Range - UIDirection / Dialog - Center"] = "CENTRO"
		L["Range - UIDirection / Dialog - Bottom"] = "INFERIOR"
		L["Checkbox - UIDirection / Dialog / Mirror"] = "Invertir"
		L["Checkbox - UIDirection / Dialog / Mirror - Tooltip"] = "Invierte la dirección de la interfaz."
		L["Range - Quest Frame Size"] = "Tamaño del tablero de la misión"
		L["Range - Quest Frame Size - Tooltip"] = "Ajuste el tamaño del tablero de la misión.\n\nEstándar: Medio."
		L["Range - Quest Frame Size - Small"] = "PEQUEÑO"
		L["Range - Quest Frame Size - Medium"] = "MEDIO"
		L["Range - Quest Frame Size - Large"] = "GRANDE"
		L["Range - Quest Frame Size - Extra Large"] = "EXTRA GRANDE"
		L["Range - Text Size"] = "Tamaño de letra"
		L["Range - Text Size - Tooltip"] = "Ajusta el tamaño de letra."
		L["Title - Dialog"] = "Diálogo"
		L["Checkbox - Dialog / Title / Progress Bar"] = "Mostrar barra de progreso"
		L["Checkbox - Dialog / Title / Progress Bar - Tooltip"] = "Muestra u oculta la barra de progreso del diálogo.\n\nLa barra indica cuánto has avanzado en la conversación actual.\n\nPor defecto: Activado."
		L["Range - Dialog / Title / Text Alpha"] = "Opacidad del título"
		L["Range - Dialog / Title / Text Alpha - Tooltip"] = "Establece la opacidad del título del diálogo.\n\nPor defecto: 50%."
		L["Range - Dialog / Content Preview Alpha"] = "Opacidad de la vista previa del texto"
		L["Range - Dialog / Content Preview Alpha - Tooltip"] = "Establece la opacidad de la vista previa del texto del diálogo.\n\nPor defecto: 50%."
		L["Title - Quest"] = "Misión"
		L["Checkbox - Always Show Gossip Frame"] = "Always Show Gossip Frame"
		L["Checkbox - Always Show Gossip Frame - Tooltip"] = "Always show the gossip frame when available instead of only after dialog.\n\nDefault: On."
		L["Checkbox - Always Show Quest Frame"] = "Mostrar siempre el Tablón de Misiones"
		L["Checkbox - Always Show Quest Frame - Tooltip"] = "Muestra siempre el tablón de misiones cuando esté disponible, en lugar de hacerlo sólo después del diálogo.\n\nPor defecto: Activado."

		-- VIEWPORT
		L["Title - Effects"] = "Efectos"
		L["Checkbox - Hide UI"] = "Ocultar la interfaz"
		L["Checkbox - Hide UI - Tooltip"] = "Oculta la interfaz durante la interacción con el NPC.\n\nPor defecto: Activado."
		L["Range - Cinematic"] = "Efectos de cámara"
		L["Range - Cinematic - Tooltip"] = "Efectos de cámara durante la interacción.\n\nPor defecto: COMPLETO."
		L["Range - Cinematic - None"] = "NINGUNO"
		L["Range - Cinematic - Full"] = "COMPLETO"
		L["Range - Cinematic - Balanced"] = "EQUILIBRADO"
		L["Range - Cinematic - Custom"] = "PERSONALIZADO"
		L["Checkbox - Zoom"] = "Zoom"
		L["Range - Zoom / Min Distance"] = "Distancia mínima"
		L["Range - Zoom / Min Distance - Tooltip"] = "Si el zoom actual está por debajo de este límite, la cámara hará zoom hasta este nivel."
		L["Range - Zoom / Max Distance"] = "Distancia máxima"
		L["Range - Zoom / Max Distance - Tooltip"] = "Si el zoom actual está por encima de este límite, la cámara hará zoom hasta este nivel."
		L["Checkbox - Zoom / Pitch"] = "Ajustar ángulo vertical"
		L["Checkbox - Zoom / Pitch - Tooltip"] = "Activa el ajuste vertical del ángulo de la cámara."
		L["Range - Zoom / Pitch / Level"] = "Ángulo máximo"
		L["Range - Zoom / Pitch / Level - Tooltip"] = "Límite de ángulo vertical."
		L["Checkbox - Zoom / Field Of View"] = "Ajustar FOV"
		L["Checkbox - Pan"] = "Panorámica"
		L["Range - Pan / Speed"] = "Velocidad"
		L["Range - Pan / Speed - Tooltip"] = "Velocidad panorámica máxima."
		L["Checkbox - Dynamic Camera"] = "Cámara Dinámica"
		L["Checkbox - Dynamic Camera - Tooltip"] = "Activa los ajustes dinámicos de la cámara."
		L["Checkbox - Dynamic Camera / Side View"] = "Vista lateral"
		L["Checkbox - Dynamic Camera / Side View - Tooltip"] = "Ajuste la cámara para la vista lateral."
		L["Range - Dynamic Camera / Side View / Strength"] = "Fuerza de la cámara"
		L["Range - Dynamic Camera / Side View / Strength - Tooltip"] = "Un valor más alto aumenta el movimiento lateral."
		L["Checkbox - Dynamic Camera / Offset"] = "Desplazamiento"
		L["Checkbox - Dynamic Camera / Offset - Tooltip"] = "Mueve la vista de la pantalla en relación con el personaje."
		L["Range - Dynamic Camera / Offset / Strength"] = "Fuerza de la cámara"
		L["Range - Dynamic Camera / Offset / Strength - Tooltip"] = "Un valor más alto aumenta el desplazamiento."
		L["Checkbox - Dynamic Camera / Focus"] = "Enfoque"
		L["Checkbox - Dynamic Camera / Focus - Tooltip"] = "Centra la vista de la pantalla en el objetivo."
		L["Range - Dynamic Camera / Focus / Strength"] = "Fuerza de la cámara"
		L["Range - Dynamic Camera / Focus / Strength - Tooltip"] = "Un valor más alto aumenta la fuerza del enfoque."
		L["Checkbox - Dynamic Camera / Focus / X"] = "Ignorar eje X"
		L["Checkbox - Dynamic Camera / Focus / X - Tooltip"] = "Evitar que se centre en el eje X."
		L["Checkbox - Dynamic Camera / Focus / Y"] = "Ignorar eje Y"
		L["Checkbox - Dynamic Camera / Focus / Y - Tooltip"] = "Evitar el enfoque en el eje Y."
		L["Checkbox - Vignette"] = "Viñeta"
		L["Checkbox - Vignette - Tooltip"] = "Reduce el brillo de los bordes."
		L["Checkbox - Vignette / Gradient"] = "Gradiente"
		L["Checkbox - Vignette / Gradient - Tooltip"] = "Reduce el brillo del fondo de los globos de mensajes y misiones."

		-- PLAYBACK
		L["Title - Pace"] = "Diálogos"
		L["Range - Playback Speed"] = "Velocidad del texto"
		L["Range - Playback Speed - Tooltip"] = "Velocidad de reproducción del texto.\n\nPor defecto: 100%."
		L["Checkbox - Dynamic Playback"] = "Reproducción natural"
		L["Checkbox - Dynamic Playback - Tooltip"] = "Añade pausas de puntuación al diálogo.\n\nPor defecto: Activado."
		L["Title - Auto Progress"] = "Progreso automático"
		L["Checkbox - Auto Progress"] = "Activar"
		L["Checkbox - Auto Progress - Tooltip"] = "Avanza automáticamente al siguiente diálogo.\n\nPor defecto: Activado."
		L["Checkbox - Auto Close Dialog"] = "Cierre automático"
		L["Checkbox - Auto Close Dialog - Tooltip"] = "Detener la interacción con el NPC cuando no hay opciones disponibles.\n\nPor defecto: Activado."
		L["Range - Auto Progress / Delay"] = "Retraso"
		L["Range - Auto Progress / Delay - Tooltip"] = "emorar antes de cerrar la conversación con el NPC.\n\nPor defecto: 1."
		L["Title - Text To Speech"] = "Texto a voz"
		L["Checkbox - Text To Speech"] = "Activar"
		L["Checkbox - Text To Speech - Tooltip"] = "Lee el texto del diálogo en voz alta.\n\nPor defecto: Desactivado."
		L["Title - Text To Speech / Playback"] = "Reproducción"
		L["Checkbox - Text To Speech / Quest"] = "Iniciar misión"
		L["Checkbox - Text To Speech / Quest - Tooltip"] = "Activar la conversión de texto a voz en el diálogo de la misión.\n\nPor defecto: Activado."
		L["Checkbox - Text To Speech / Gossip"] = "Reproducir en el globo de mensajes"
		L["Checkbox - Text To Speech / Gossip - Tooltip"] = "Activa la conversión de texto a voz en el diálogo del globo de mensaje.\n\nPor defecto: Activado."
		L["Range - Text To Speech / Rate"] = "Tasa"
		L["Range - Text To Speech / Rate - Tooltip"] = "Velocidad del habla.\n\nPor defecto: 100%."
		L["Range - Text To Speech / Volume"] = "Volumen"
		L["Range - Text To Speech / Volume - Tooltip"] = "Volumen del habla.\n\nPor defecto: 100%."
		L["Title - Text To Speech / Voice"] = "Voz"
		L["Dropdown - Text To Speech / Voice / Neutral"] = "Neutral"
		L["Dropdown - Text To Speech / Voice / Neutral - Tooltip"] = "Usado para NPCs de gênero neutro."
		L["Dropdown - Text To Speech / Voice / Male"] = "Masculino"
		L["Dropdown - Text To Speech / Voice / Male - Tooltip"] = "Usado para NPCs masculinos."
		L["Dropdown - Text To Speech / Voice / Female"] = "Feminino"
		L["Dropdown - Text To Speech / Voice / Female - Tooltip"] = "Usado para NPCs femininos."
		L["Dropdown - Text To Speech / Voice / Emote"] = "Expresión"
		L["Dropdown - Text To Speech / Voice / Emote - Tooltip"] = "Usado para los diálogos en '<>'."
		L["Checkbox - Text To Speech / Player / Voice"] = "Voz del jugador"
		L["Checkbox - Text To Speech / Player / Voice - Tooltip"] = "Reproduce TTS cuando seleccionas una opción de diálogo.\n\nPor defecto: Activado."
		L["Dropdown - Text To Speech / Player / Voice / Voice"] = "Voz"
		L["Dropdown - Text To Speech / Player / Voice / Voice - Tooltip"] = "Voz para las opciones de diálogo."
		L["Title - More"] = "Más"
		L["Checkbox - Mute Dialog"] = "Silenciar diálogo de NPC"
		L["Checkbox - Mute Dialog - Tooltip"] = "Silencia el audio de los diálogos de los NPCs de Blizzard durante la interacción con el NPC.\n\nPor defecto: Desactivado."

		-- CONTROLS
		L["Title - UI"] = "Interfaz"
		L["Checkbox - UI / Control Guide"] = "Mostrar guía de control"
		L["Checkbox - UI / Control Guide - Tooltip"] = "Muestra la pantalla de la guía de control.\n\nPor defecto: Activado."
		L["Title - Platform"] = "Plataforma"
		L["Range - Platform"] = "Plataforma"
		L["Range - Platform - Tooltip"] = "Requiere reiniciar la interfaz para que surta efecto."
		L["Range - Platform - PC"] = "PC"
		L["Range - Platform - Playstation"] = "Playstation"
		L["Range - Platform - Xbox"] = "Xbox"
		L["Title - PC"] = "PC"
		L["Title - PC / Keyboard"] = "Teclado"
		L["Checkbox - PC / Keyboard / Use Interact Key"] = "Utilizar la tecla de interacción"
		L["Checkbox - PC / Keyboard / Use Interact Key - Tooltip"] = "Utilice la tecla de interacción para avanzar. No se admiten combinaciones múltiples de teclas.\n\nPor defecto: Desactivado."
		L["Title - PC / Mouse"] = "Ratón"
		L["Checkbox - PC / Mouse / Flip Mouse Controls"] = "Invertir los controles del ratón"
		L["Checkbox - PC / Mouse / Flip Mouse Controls - Tooltip"] = "Invierte los controles izquierdo y derecho del ratón.\n\nPor defecto: Desactivado."
		L["Title - PC / Keybind"] = "Atajos de teclado"
		L["Keybind - PC / Keybind / Previous"] = "Anterior"
		L["Keybind - PC / Keybind / Previous - Tooltip"] = "Acceso directo al diálogo anterior.\n\nPor defecto: Q."
		L["Keybind - PC / Keybind / Next"] = "Siguiente"
		L["Keybind - PC / Keybind / Next - Tooltip"] = "Acceso directo al siguiente diálogo.\n\nPor defecto: E."
		L["Keybind - PC / Keybind / Progress"] = "Progreso"
		L["Keybind - PC / Keybind / Progress - Tooltip"] = "Acceso directo a:\n- Saltar\n- Aceptar\n- Continuar\n- Completar\n\nPor defecto: ESPACIO."
		L["Keybind - PC / Keybind / Progress - Tooltip / Conflict"] = addon.Theme.Settings.Tooltip_Text_Warning_Highlight .. "Utilizar la tecla de interacción" .. addon.Theme.Settings.Tooltip_Text_Warning .. "La opción debe estar desactivada para ajustar este acceso directo.|r"
		L["Keybind - PC / Keybind / Quest Next Reward"] = "Próxima recompensa"
		L["Keybind - PC / Keybind / Quest Next Reward - Tooltip"] = "Acceso directo para seleccionar la recompensa de la siguiente misión.\n\nPor defecto: TAB."
		L["Keybind - PC / Keybind / Close"] = "Close"
		L["Keybind - PC / Keybind / Close - Tooltip"] = "Keybind to close the current active Interaction window.\n\nDefault: ESCAPE."
		L["Title - Controller"] = "Controlar"
		L["Title - Controller / Controller"] = "Controlar"

		-- GAMEPLAY
		L["Title - Waypoint"] = "Punto de navegación"
		L["Checkbox - Waypoint"] = "Activar"
		L["Checkbox - Waypoint - Tooltip"] = "Sustitución del punto de navegación para la navegación Addon.\n\nPor defecto: Activado."
		L["Checkbox - Waypoint / Audio"] = "Audio"
		L["Checkbox - Waypoint / Audio - Tooltip"] = "Efectos de sonido cuando cambia el estado del punto de navegación.\n\nPor defecto: Activado."
		L["Title - Readable"] = "Itens de lectura"
		L["Checkbox - Readable"] = "Activar"
		L["Checkbox - Readable - Tooltip"] = "Activa una interfaz personalizada para libros y textos y una biblioteca para organizarlos.\n\nPor defecto: Activado."
		L["Title - Readable / Display"] = "Exposición"
		L["Checkbox - Readable / Display / Always Show Item"] = "Mostrar elemento siempre visible"
		L["Checkbox - Readable / Display / Always Show Item - Tooltip"] = "Evita que la interfaz de lectura se cierre cuando te alejas de un elemento del mundo.\n\nPor defecto: Desactivado."
		L["Title - Readable / Viewport"] = "Área de visualización"
		L["Checkbox - Readable / Viewport"] = "Activar efectos en el área de visualización"
		L["Checkbox - Readable / Viewport - Tooltip"] = "Efectos en el área de visualización al iniciar la interfaz de lectura.\n\nPor defecto: Activado."
		L["Title - Readable / Shortcuts"] = "Atajos"
		L["Checkbox - Readable / Shortcuts / Minimap Icon"] = "Icono del minimapa"
		L["Checkbox - Readable / Shortcuts / Minimap Icon - Tooltip"] = "Muestra un icono en el minimapa para acceder rápidamente a la biblioteca de libros.\n\nPor defecto: Activado."
		L["Title - Readable / Audiobook"] = "Audio-book"
		L["Range - Readable / Audiobook - Rate"] = "Velocidad del texto"
		L["Range - Readable / Audiobook - Rate - Tooltip"] = "Velocidad de reproducción.\n\nPor defecto: 100%."
		L["Range - Readable / Audiobook - Volume"] = "Volumen"
		L["Range - Readable / Audiobook - Volume - Tooltip"] = "Volumen de reproducción.\n\nPor defecto: 100%."
		L["Dropdown - Readable / Audiobook - Voice"] = "Narrador"
		L["Dropdown - Readable / Audiobook - Voice - Tooltip"] = "Voz de reproducción."
		L["Dropdown - Readable / Audiobook - Special Voice"] = "Narrador secundario"
		L["Dropdown - Readable / Audiobook - Special Voice - Tooltip"] = "Voz de reproducción utilizada en párrafos especiales, como los envueltos en '<>'."
		L["Title - Gameplay"] = "Jugabilidad"
		L["Checkbox - Gameplay / Auto Select Option"] = "Seleccionar opciones automáticamente"
		L["Checkbox - Gameplay / Auto Select Option - Tooltip"] = "Selecciona la mejor opción para determinados NPCs.\n\nPor defecto: Desactivado."


		-- MORE
		L["Title - Audio"] = "Audio"
		L["Checkbox - Audio"] = "Activar audio"
		L["Checkbox - Audio - Tooltip"] = "Activa los efectos de sonido y audio.\n\nPor defecto: Activado."
		L["Title - Settings"] = "Ajustes"
		L["Checkbox - Settings / Reset Settings"] = "Restablecer todos los ajustes"
		L["Checkbox - Settings / Reset Settings - Tooltip"] = "Restablece los valores por defecto..\n\nPor defecto: Desactivado."

		L["Title - Credits"] = "Agradecimentos"
		L["Title - Credits / ZamestoTV"] = "ZamestoTV | Traducción - Ruso"
		L["Title - Credits / ZamestoTV - Tooltip"] = "Agradecimientos especiales a ZamestoTV por las traducciones al Ruso!"
		L["Title - Credits / AKArenan"] = "AKArenan | Traducción - Português de Brasil"
		L["Title - Credits / AKArenan - Tooltip"] = "Un agradecimiento especial a AKArenan par las traducciones al portugués de Brasil!"
		L["Title - Credits / El1as1989"] = "El1as1989 | Traducción - Español"
		L["Title - Credits / El1as1989 - Tooltip"] = "Agradecimientos especiales a El1as1989 por las traducciones al Español!"
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
			L["Readable - Library - Prompt - Delete Button 1"] = "Eliminar"
			L["Readable - Library - Prompt - Delete Button 2"] = "Cancelar"

			L["Readable - Library - Prompt - Import - Local"] = "Importing a saved state will overwrite your PLAYER library."
			L["Readable - Library - Prompt - Import - Global"] = "Importing a saved state will overwrite the WARBAND library."
			L["Readable - Library - Prompt - Import Button 1"] = "Importar y recargar"
			L["Readable - Library - Prompt - Import Button 2"] = "Cancelar"

			L["Readable - Library - TextPrompt - Import - Local"] = "Import to Player Library"
			L["Readable - Library - TextPrompt - Import - Global"] = "Import to Warband Library"
			L["Readable - Library - TextPrompt - Import Input Placeholder"] = "Insertar texto de datos"
			L["Readable - Library - TextPrompt - Import Button 1"] = "Importar"

			L["Readable - Library - TextPrompt - Export - Local"] = "Copy Player Data to Clipboard "
			L["Readable - Library - TextPrompt - Export - Global"] = "Copy Warband Data to Clipboard "
			L["Readable - Library - TextPrompt - Export Input Placeholder"] = "Código de exportación no válido"


			-- SIDEBAR
			L["Readable - Library - Search Input Placeholder"] = "Buscar en"
			L["Readable - Library - Export Button"] = "Exportar"
			L["Readable - Library - Import Button"] = "Importar"
			L["Readable - Library - Show"] = "Mostrar"
			L["Readable - Library - Letters"] = "Cartas"
			L["Readable - Library - Books"] = "Libros"
			L["Readable - Library - Slates"] = "Notas"
			L["Readable - Library - Show only World"] = "Sólo el mundo"

			-- TITLE
			L["Readable - Library - Name Text - Global"] = "Librería Bando de Guerra"
			L["Readable - Library - Name Text - Local - Subtext 1"] = ""
			L["Readable - Library - Name Text - Local - Subtext 2"] = "'s Biblioteca"
			L["Readable - Library - Showing Status Text - Subtext 1"] = "Mostrar"
			L["Readable - Library - Showing Status Text - Subtext 2"] = "Itens"

			-- CONTENT
			L["Readable - Library - No Results Text - Subtext 1"] = "No hay resultados para"
			L["Readable - Library - No Results Text - Subtext 2"] = "."
			L["Readable - Library - Empty Library Text"] = "Biblioteca vacía."
		end

		do -- READABLE
			-- NOTIFICATIONS
			L["Readable - Notification - Saved To Library"] = "Guardado en la biblioteca"

			-- TOOLTIP
			L["Readable - Tooltip - Change Page"] = "Desplácese para cambiar de página."
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
		L["InteractionFrame.QuestFrame - Objectives"] = "Objetivos de la misión"
		L["InteractionFrame.QuestFrame - Rewards"] = "Recompensas"
		L["InteractionFrame.QuestFrame - Required Items"] = "Itens Necesarios"

		L["InteractionFrame.QuestFrame - Accept - Quest Log Full"] = "Registro de misiones Completo"
		L["InteractionFrame.QuestFrame - Accept - Auto Accept"] = "Aceptar automáticamente"
		L["InteractionFrame.QuestFrame - Accept"] = "Aceptar"
		L["InteractionFrame.QuestFrame - Decline"] = "Rechazar"
		L["InteractionFrame.QuestFrame - Goodbye"] = "Adiós"
		L["InteractionFrame.QuestFrame - Goodbye - Auto Accept"] = "Entendido"
		L["InteractionFrame.QuestFrame - Continue"] = "Continuar"
		L["InteractionFrame.QuestFrame - In Progress"] = "En proceso"
		L["InteractionFrame.QuestFrame - Complete"] = "Completar"
	end

	--------------------------------
	-- INTERACTION DIALOG FRAME
	--------------------------------

	do
		L["InteractionFrame.DialogFrame - Skip"] = "SALTAR"
	end

	--------------------------------
	-- INTERACTION GOSSIP FRAME
	--------------------------------

	do
		L["InteractionFrame.GossipFrame - Close"] = "Adiós"
	end

	--------------------------------
	-- INTERACTION CONTROL GUIDE
	--------------------------------

	do
		L["ControlGuide - Back"] = "Volver"
		L["ControlGuide - Next"] = "Siguiente"
		L["ControlGuide - Skip"] = "Saltar"
		L["ControlGuide - Accept"] = "Aceptar"
		L["ControlGuide - Continue"] = "Continuar"
		L["ControlGuide - Complete"] = "Completar"
		L["ControlGuide - Decline"] = "Rechazar"
		L["ControlGuide - Goodbye"] = "Adiós"
		L["ControlGuide - Got it"] = "Entendido"
		L["ControlGuide - Gossip Option Interact"] = "Seleccionar opción"
		L["ControlGuide - Quest Next Reward"] = "Próxima recompensa"
	end

	--------------------------------
	-- ALERT NOTIFICATION
	--------------------------------

	do
		L["Alert Notification - Accept"] = "Búsqueda aceptada"
		L["Alert Notification - Complete"] = "Misión completada"
	end

	--------------------------------
	-- WAYPOINT
	--------------------------------

	do
		L["Waypoint - Ready for Turn-in"] = "Listo para entregar"

		L["Waypoint - Waypoint"] = "Punto de navegación"
		L["Waypoint - Quest"] = "Misión"
		L["Waypoint - Flight Point"] = "Punto de Vuelo"
		L["Waypoint - Pin"] = "Marcador"
		L["Waypoint - Party Member"] = "Miembro del Grupo"
		L["Waypoint - Content"] = "Contenido"
	end

	--------------------------------
	-- PLAYER STATUS BAR
	--------------------------------

	do
		L["PlayerStatusBar - TooltipLine1"] = "XP actual: "
		L["PlayerStatusBar - TooltipLine2"] = "XP restante: "
		L["PlayerStatusBar - TooltipLine3"] = "Nível "
	end

	--------------------------------
	-- MINIMAP ICON
	--------------------------------

	do
		L["MinimapIcon - Tooltip - Title"] = "Colección de libros"
		L["MinimapIcon - Tooltip - Entries - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Subtext 2"] = " Registros"
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 2"] = " Registro"
		L["MinimapIcon - Tooltip - Entries - Empty"] = "Sin registros"
	end

	--------------------------------
	-- BLIZZARD SETTINGS
	--------------------------------

	do
		L["BlizzardSettings - Title"] = "Abrir la configuración"
		L["BlizzardSettings - Shortcut - Controller"] = "En cualquier interfaz de interacción."
	end

	--------------------------------
	-- ALERTS
	--------------------------------

	do
		L["Alert - Under Attack"] = "Bajo ataque"
		L["Alert - Open Settings"] = "Para abrir los ajustes."
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
		L["GossipData - Trigger - Quest"] = "%(Misión%)"
		L["GossipData - Trigger - Movie 1"] = "%(Reproducir%)"
		L["GossipData - Trigger - Movie 2"] = "%(Reproducir video%)"
		L["GossipData - Trigger - NPC Dialog"] = "%<Quédate un rato y escucha.%>"
		L["GossipData - Trigger - NPC Dialog - Append"] = "Quédate un rato y escucha."
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
