-- Localization and translation AKArenan

---@class addon
local addon = select(2, ...)
local CallbackRegistry = addon.CallbackRegistry
local PrefabRegistry = addon.PrefabRegistry
local L = addon.Locales

--------------------------------

local function Load()
	if GetLocale() ~= "ptBR" then
		return
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		-- WARNINGS
		L["Warning - Leave NPC Interaction"] = "Deixe de interagir com NPC para ajustar as configurações."
		L["Warning - Leave ReadableUI"] = "Saia da interface para ajustar as configurações."

		-- PROMPTS
		L["Prompt - Reload"] = "É necessário recarregar a interface para aplicar as configurações."
		L["Prompt - Reload Button 1"] = "Recarregar"
		L["Prompt - Reload Button 2"] = "Fechar"
		L["Prompt - Reset Settings"] = "em certeza de que deseja redefinir as configurações?"
		L["Prompt - Reset Settings Button 1"] = "Resetar"
		L["Prompt - Reset Settings Button 2"] = "Cancelar"

		-- TABS
		L["Tab - Appearance"] = "Aparência"
		L["Tab - Effects"] = "Efeitos"
		L["Tab - Playback"] = "Reprodução"
		L["Tab - Controls"] = "Controles"
		L["Tab - Gameplay"] = "Jogabilidade"
		L["Tab - More"] = "Mais"

		-- ELEMENTS
		-- APPEARANCE
		L["Title - Theme"] = "Tema"
		L["Range - Main Theme"] = "Tema Principal"
		L["Range - Main Theme - Tooltip"] = "Define o tema geral da interface.\n\nPadrão: DIA.\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "Dinâmico" .. addon.Theme.Settings.Tooltip_Text_Note .. " A opção define o tema principal de acordo com o ciclo dia/noite dentro do jogo.|r"
		L["Range - Main Theme - Day"] = "DIA"
		L["Range - Main Theme - Night"] = "NOITE"
		L["Range - Main Theme - Dynamic"] = "DINÂMICO"
		L["Range - Dialog Theme"] = "Tema do Diálogo"
		L["Range - Dialog Theme - Tooltip"] = "Define o tema da interface de diálogo com NPC.\n\nPadrão: Auto.\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "AUTO" .. addon.Theme.Settings.Tooltip_Text_Note .. " A opção define o tema do diálogo para combinar com o tema principal.|r"
		L["Range - Dialog Theme - Auto"] = "AUTO"
		L["Range - Dialog Theme - Day"] = "DIA"
		L["Range - Dialog Theme - Night"] = "NOITE"
		L["Range - Dialog Theme - Rustic"] = "RUSTICO"
		L["Title - Appearance"] = "Aparência"
		L["Range - UIDirection"] = "Posicionamento da Interface"
		L["Range - UIDirection - Tooltip"] = "Define o posicionamento da interface."
		L["Range - UIDirection - Left"] = "ESQUERDA"
		L["Range - UIDirection - Right"] = "DIREITA"
		L["Range - UIDirection / Dialog"] = "Posição Fixa da Janela de Diálogo"
		L["Range - UIDirection / Dialog - Tooltip"] = "Define a posição fixa da janela de diálogo.\n\nPosição O diálogo é usado quando a placa de nome do NPC está indisponível."
		L["Range - UIDirection / Dialog - Top"] = "TOPO"
		L["Range - UIDirection / Dialog - Center"] = "CENTRO"
		L["Range - UIDirection / Dialog - Bottom"] = "INFERIOR"
		L["Checkbox - UIDirection / Dialog / Mirror"] = "Inverter"
		L["Checkbox - UIDirection / Dialog / Mirror - Tooltip"] = "Inverte a direção da interface."
		L["Range - Quest Frame Size"] = "Tamanho do Quadro de Missão"
		L["Range - Quest Frame Size - Tooltip"] = "Ajusta o tamanho do quadro de missão.\n\nPadrão: Médio."
		L["Range - Quest Frame Size - Small"] = "PEQUENO"
		L["Range - Quest Frame Size - Medium"] = "MÉDIO"
		L["Range - Quest Frame Size - Large"] = "GRANDE"
		L["Range - Quest Frame Size - Extra Large"] = "EXTRA GRANDE"
		L["Range - Text Size"] = "Tamanho da Fonte"
		L["Range - Text Size - Tooltip"] = "Ajusta o tamanho da fonte."
		L["Title - Dialog"] = "Diálogo"
		L["Checkbox - Dialog / Title / Progress Bar"] = "Exibir Barra de Progresso"
		L["Checkbox - Dialog / Title / Progress Bar - Tooltip"] = "Exibe ou oculta a barra de progresso do diálogo.\n\nA barra indica o quanto você avançou na conversa atual.\n\nPadrão: Ligado."
		L["Range - Dialog / Title / Text Alpha"] = "Opacidade do Título"
		L["Range - Dialog / Title / Text Alpha - Tooltip"] = "Define a opacidade do título do diálogo.\n\nPadrão: 50%."
		L["Range - Dialog / Content Preview Alpha"] = "Opacidade da Pré-visualização do Texto"
		L["Range - Dialog / Content Preview Alpha - Tooltip"] = "Define a opacidade da pré-visualização do texto do diálogo.\n\nPadrão: 50%."
		L["Title - Quest"] = "Missão"
		L["Checkbox - Always Show Gossip Frame"] = "Sempre mostrar a janela de diálogos"
		L["Checkbox - Always Show Gossip Frame - Tooltip"] = "Sempre exibir a janela de diálogos quando disponível, em vez de mostrar só depois da conversa começar.\n\nDefault: Ligado."
		L["Checkbox - Always Show Quest Frame"] = "Sempre Exibir o Quadro de Missão"
		L["Checkbox - Always Show Quest Frame - Tooltip"] = "Sempre exibir o quadro de missão quando disponível, em vez de apenas após o diálogo.\n\nPadrão: Ligado."

		-- VIEWPORT
		L["Title - Effects"] = "Efeitos"
		L["Checkbox - Hide UI"] = "Ocultar a Interface"
		L["Checkbox - Hide UI - Tooltip"] = "Oculta a interface durante a interação com o NPC.\n\nPadrão: Ligado."
		L["Range - Cinematic"] = "Efeitos da Câmera"
		L["Range - Cinematic - Tooltip"] = "Efeitos de câmera durante a interação.\n\nPadrão: COMPLETO."
		L["Range - Cinematic - None"] = "NENHUM"
		L["Range - Cinematic - Full"] = "COMPLETO"
		L["Range - Cinematic - Balanced"] = "EQUILIBRADO"
		L["Range - Cinematic - Custom"] = "PERSONALIZADO"
		L["Checkbox - Zoom"] = "Zoom"
		L["Range - Zoom / Min Distance"] = "Distância Mínima"
		L["Range - Zoom / Min Distance - Tooltip"] = "Se o zoom atual estiver abaixo deste limite, a câmera irá fazer o zoom até este nível."
		L["Range - Zoom / Max Distance"] = "Distância Máxima"
		L["Range - Zoom / Max Distance - Tooltip"] = "Se o zoom atual estiver acima deste limite, a câmera irá fazer o zoom até este nível."
		L["Checkbox - Zoom / Pitch"] = "Ajusta o Ângulo Vertical"
		L["Checkbox - Zoom / Pitch - Tooltip"] = "Habilitar ajuste do ângulo vertical da câmera."
		L["Range - Zoom / Pitch / Level"] = "Ângulo Máximo"
		L["Range - Zoom / Pitch / Level - Tooltip"] = "Limite do Ângulo Vertical."
		L["Checkbox - Zoom / Field Of View"] = "Ajusta o FOV"
		L["Checkbox - Pan"] = "Panorama"
		L["Range - Pan / Speed"] = "Velocidade"
		L["Range - Pan / Speed - Tooltip"] = "Velocidade máxima de panorama."
		L["Checkbox - Dynamic Camera"] = "Câmera Dinâmica"
		L["Checkbox - Dynamic Camera - Tooltip"] = "Ativa configurações de câmera dinâmica."
		L["Checkbox - Dynamic Camera / Side View"] = "Visão lateral"
		L["Checkbox - Dynamic Camera / Side View - Tooltip"] = "Ajustar câmera para visão lateral."
		L["Range - Dynamic Camera / Side View / Strength"] = "Força da câmera"
		L["Range - Dynamic Camera / Side View / Strength - Tooltip"] = "Valor mais alto aumenta o movimento lateral."
		L["Checkbox - Dynamic Camera / Offset"] = "Deslocamento"
		L["Checkbox - Dynamic Camera / Offset - Tooltip"] = "Deslocar a visualização da tela em relação ao personagem."
		L["Range - Dynamic Camera / Offset / Strength"] = "Força da câmera"
		L["Range - Dynamic Camera / Offset / Strength - Tooltip"] = "Valor mais alto aumenta o deslocamento."
		L["Checkbox - Dynamic Camera / Focus"] = "Foco"
		L["Checkbox - Dynamic Camera / Focus - Tooltip"] = "Foca a visualização da tela no alvo."
		L["Range - Dynamic Camera / Focus / Strength"] = "Força da câmera"
		L["Range - Dynamic Camera / Focus / Strength - Tooltip"] = "Valor mais alto aumenta a força do foco."
		L["Checkbox - Dynamic Camera / Focus / X"] = "Ignorar eixo X"
		L["Checkbox - Dynamic Camera / Focus / X - Tooltip"] = "Impedir foco no eixo X."
		L["Checkbox - Dynamic Camera / Focus / Y"] = "Ignorar eixo Y"
		L["Checkbox - Dynamic Camera / Focus / Y - Tooltip"] = "Impedir foco no eixo Y."
		L["Checkbox - Vignette"] = "Vinheta"
		L["Checkbox - Vignette - Tooltip"] = "Reduz a claridade nas bordas."
		L["Checkbox - Vignette / Gradient"] = "Degradê"
		L["Checkbox - Vignette / Gradient - Tooltip"] = "Reduz a luminosidade ao fundo dos balões de mensagem e das missões."

		-- PLAYBACK
		L["Title - Pace"] = "Diálogos"
		L["Range - Playback Speed"] = "Velocidade de Texto"
		L["Range - Playback Speed - Tooltip"] = "velocidade de reprodução do texto.\n\nPadrão: 100%."
		L["Checkbox - Dynamic Playback"] = "Reprodução natural"
		L["Checkbox - Dynamic Playback - Tooltip"] = "Adiciona pausas de pontuação no diálogo.\n\nPadrão: Ligado."
		L["Title - Auto Progress"] = "Progresso Automático"
		L["Checkbox - Auto Progress"] = "Ativar"
		L["Checkbox - Auto Progress - Tooltip"] = "Progredir automaticamente para o próximo diálogo.\n\nPadrão: Ligado."
		L["Checkbox - Auto Close Dialog"] = "Fechamento Automático"
		L["Checkbox - Auto Close Dialog - Tooltip"] = "Para a interação com NPC quando não houver opções disponíveis.\n\nPadrão: Ligado."
		L["Range - Auto Progress / Delay"] = "Atraso"
		L["Range - Auto Progress / Delay - Tooltip"] = "Atraso antes de fechar a conversa com o NPC.\n\nPadrão: 1."
		L["Title - Text To Speech"] = "Texto para fala"
		L["Checkbox - Text To Speech"] = "Ativar"
		L["Checkbox - Text To Speech - Tooltip"] = "Lê o texto do diálogo em voz alta.\n\nPadrão: Desligado."
		L["Title - Text To Speech / Playback"] = "Reprodução"
		L["Checkbox - Text To Speech / Quest"] = "Reproduzir Missão"
		L["Checkbox - Text To Speech / Quest - Tooltip"] = "Ativa texto para fala no diálogo da missão.\n\nPadrão: Ligado."
		L["Checkbox - Text To Speech / Gossip"] = "Reproduzir no Balão de Mensagem"
		L["Checkbox - Text To Speech / Gossip - Tooltip"] = "Ativa texto para fala no diálogo de balão de mensagem.\n\nPadrão: Ligado."
		L["Range - Text To Speech / Rate"] = "Velocidade da Fala"
		L["Range - Text To Speech / Rate - Tooltip"] = "Velocidade da fala.\n\nPadrão: 100%."
		L["Range - Text To Speech / Volume"] = "Volume"
		L["Range - Text To Speech / Volume - Tooltip"] = "Volume da fala.\n\nPadrão: 100%."
		L["Title - Text To Speech / Voice"] = "Voz"
		L["Dropdown - Text To Speech / Voice / Neutral"] = "Neutro"
		L["Dropdown - Text To Speech / Voice / Neutral - Tooltip"] = "Usado para NPCs de gênero neutro."
		L["Dropdown - Text To Speech / Voice / Male"] = "Masculino"
		L["Dropdown - Text To Speech / Voice / Male - Tooltip"] = "Usado para NPCs masculinos."
		L["Dropdown - Text To Speech / Voice / Female"] = "Feminino"
		L["Dropdown - Text To Speech / Voice / Female - Tooltip"] = "Usado para NPCs femininos."
		L["Dropdown - Text To Speech / Voice / Emote"] = "Expressão"
		L["Dropdown - Text To Speech / Voice / Emote - Tooltip"] = "Usado para diálogos em '<>'."
		L["Checkbox - Text To Speech / Player / Voice"] = "Voz do jogador"
		L["Checkbox - Text To Speech / Player / Voice - Tooltip"] = "Reproduz TTS ao selecionar uma opção de diálogo.\n\nPadrão: Ligado."
		L["Dropdown - Text To Speech / Player / Voice / Voice"] = "Voz"
		L["Dropdown - Text To Speech / Player / Voice / Voice - Tooltip"] = "Voz para opções de diálogo."
		L["Title - More"] = "Mais"
		L["Checkbox - Mute Dialog"] = "Silenciar diálogo de NPC"
		L["Checkbox - Mute Dialog - Tooltip"] = "Silencia o áudio de diálogo dos NPCs da Blizzard durante a interação com o NPC.\n\nPadrão: Desligado."

		-- CONTROLS
		L["Title - UI"] = "Interface"
		L["Checkbox - UI / Control Guide"] = "Mostrar guia de controle"
		L["Checkbox - UI / Control Guide - Tooltip"] = "Exibe a tela do guia de controle.\n\nPadrão: Ligado."
		L["Title - Platform"] = "Plataforma"
		L["Range - Platform"] = "Plataforma"
		L["Range - Platform - Tooltip"] = "Requer recarregamento da interface para ter efeito."
		L["Range - Platform - PC"] = "PC"
		L["Range - Platform - Playstation"] = "Playstation"
		L["Range - Platform - Xbox"] = "Xbox"
		L["Title - PC"] = "PC"
		L["Title - PC / Keyboard"] = "Teclado"
		L["Checkbox - PC / Keyboard / Use Interact Key"] = "Usar tecla de interação"
		L["Checkbox - PC / Keyboard / Use Interact Key - Tooltip"] = "Use a tecla de interação para avançar. Combinações de múltiplas teclas não são suportadas.\n\nPadrão: Desligado."
		L["Title - PC / Mouse"] = "Mouse"
		L["Checkbox - PC / Mouse / Flip Mouse Controls"] = "Inverter controles do mouse"
		L["Checkbox - PC / Mouse / Flip Mouse Controls - Tooltip"] = "Inverter controles do mouse esquerdo e direito.\n\nPadrão: Desligado."
		L["Title - PC / Keybind"] = "Atalhos do Teclado"
		L["Keybind - PC / Keybind / Previous"] = "Anterior"
		L["Keybind - PC / Keybind / Previous - Tooltip"] = "Atalho para o diálogo anterior.\n\nPadrão: Q."
		L["Keybind - PC / Keybind / Next"] = "Próximo"
		L["Keybind - PC / Keybind / Next - Tooltip"] = "Atalho para o próximo diálogo.\n\nPadrão: E."
		L["Keybind - PC / Keybind / Progress"] = "Avançar"
		L["Keybind - PC / Keybind / Progress - Tooltip"] = "Atalho para:\n- Skip\n- Accept\n- Continue\n- Complete\n\nPadrão: ESPAÇO."
		L["Keybind - PC / Keybind / Progress - Tooltip / Conflict"] = addon.Theme.Settings.Tooltip_Text_Warning_Highlight .. "Usar tecla de interação" .. addon.Theme.Settings.Tooltip_Text_Warning .. " A opção deve estar desativada para ajustar este atalho.|r"
		L["Keybind - PC / Keybind / Quest Next Reward"] = "Próxima recompensa"
		L["Keybind - PC / Keybind / Quest Next Reward - Tooltip"] = "Atalho para selecionar a próxima recompensa da missão.\n\nPadrão: TAB."
		L["Keybind - PC / Keybind / Close"] = "Fechar"
		L["Keybind - PC / Keybind / Close - Tooltip"] = "Atalho para fechar a janela de interação ativa atual.\n\nPadrão: ESC."
		L["Title - Controller"] = "Controle"
		L["Title - Controller / Controller"] = "Controle"

		-- GAMEPLAY
		L["Title - Waypoint"] = "Ponto de Navegação"
		L["Checkbox - Waypoint"] = "Ativar"
		L["Checkbox - Waypoint - Tooltip"] = "Substituição do ponto de navegação para a navegação do Addon.\n\nPadrão: Ligado."
		L["Checkbox - Waypoint / Audio"] = "Audio"
		L["Checkbox - Waypoint / Audio - Tooltip"] = "Efeitos sonoros quando o estado do ponto de navegação muda.\n\nPadrão: Ligado."
		L["Title - Readable"] = "Itens de Leitura"
		L["Checkbox - Readable"] = "Ativar"
		L["Checkbox - Readable - Tooltip"] = "Ativa interface personalizada para livros e textos e biblioteca para organizá-los.\n\nPadrão: Ligado."
		L["Title - Readable / Display"] = "Exibição"
		L["Checkbox - Readable / Display / Always Show Item"] = "Mostrar item sempre visível"
		L["Checkbox - Readable / Display / Always Show Item - Tooltip"] = "Impede que a interface de leitura feche quando se afasta de um item no mundo.\n\nPadrão: Desligado."
		L["Title - Readable / Viewport"] = "Área de visualização"
		L["Checkbox - Readable / Viewport"] = "Ativar efeitos na área de visualização"
		L["Checkbox - Readable / Viewport - Tooltip"] = "Efeitos na área de visualização ao iniciar a interface de leitura.\n\nPadrão: Ligado."
		L["Title - Readable / Shortcuts"] = "Atalhos"
		L["Checkbox - Readable / Shortcuts / Minimap Icon"] = "Ícone no Minimapa"
		L["Checkbox - Readable / Shortcuts / Minimap Icon - Tooltip"] = "Exibi um ícone no minimapa para acesso rápido à biblioteca de livros.\n\nPadrão: Ligado."
		L["Title - Readable / Audiobook"] = "Audiolivro"
		L["Range - Readable / Audiobook - Rate"] = "Velocidade de Texto"
		L["Range - Readable / Audiobook - Rate - Tooltip"] = "Velocidade de reprodução.\n\nPadrão: 100%."
		L["Range - Readable / Audiobook - Volume"] = "Volume"
		L["Range - Readable / Audiobook - Volume - Tooltip"] = "Volume de reprodução.\n\nPadrão: 100%."
		L["Dropdown - Readable / Audiobook - Voice"] = "Narrador"
		L["Dropdown - Readable / Audiobook - Voice - Tooltip"] = "Voz de reprodução."
		L["Dropdown - Readable / Audiobook - Special Voice"] = "Narrador Secundário"
		L["Dropdown - Readable / Audiobook - Special Voice - Tooltip"] = "Voz de reprodução usada em parágrafos especiais, como aqueles envoltos em '<>'."
		L["Title - Gameplay"] = "Jogabilidade"
		L["Checkbox - Gameplay / Auto Select Option"] = "Selecionar Opções Automaticamente"
		L["Checkbox - Gameplay / Auto Select Option - Tooltip"] = "Seleciona a melhor opção para certos NPCs.\n\nPadrão: Desligado."

		-- MORE
		L["Title - Audio"] = "Audio"
		L["Checkbox - Audio"] = "Ativar Audio"
		L["Checkbox - Audio - Tooltip"] = "Ativa efeitos sonoros e áudio.\n\nPadrão: Ligado."
		L["Title - Settings"] = "Configurações"
		L["Checkbox - Settings / Reset Settings"] = "Resetar todas as configurações"
		L["Checkbox - Settings / Reset Settings - Tooltip"] = "Redefine as configurações para os valores padrão..\n\nPadrão: Desligado."

		L["Title - Credits"] = "Agradecimentos"
		L["Title - Credits / ZamestoTV"] = "ZamestoTV | Tradução - Russo"
		L["Title - Credits / ZamestoTV - Tooltip"] = "Agradecimento especial a ZamestoTV pela tradução em Russo!"
		L["Title - Credits / AKArenan"] = "AKArenan | Tradução - Português do Brasil"
		L["Title - Credits / AKArenan - Tooltip"] = "Agradecimento especial a AKArenan pela tradução em Português do Brasil!"
		L["Title - Credits / El1as1989"] = "El1as1989 | Tradução - Espanhol"
		L["Title - Credits / El1as1989 - Tooltip"] = "Agradecimento especial a El1as1989 pela tradução em Espanhol!"
		L["Title - Credits / huchang47"] = "huchang47 | Tradução - Chinês (Simplificado)"
		L["Title - Credits / huchang47 - Tooltip"] = "Agradecimento especial a huchang47 pela tradução em Chinês (Simplificado)!"
		L["Title - Credits / muiqo"] = "muiqo | Tradução - Alemão"
		L["Title - Credits / muiqo - Tooltip"] = "Agradecimento especial a muiqo pela tradução em Alemão!"
		L["Title - Credits / Crazyyoungs"] = "Crazyyoungs | Tradução - Coreano"
		L["Title - Credits / Crazyyoungs - Tooltip"] = "Agradecimento especial a Crazyyoungs pela tradução em Coreano!"
		L["Title - Credits / fang2hou"] = "fang2hou | Translator - Chinese (Traditional)"
		L["Title - Credits / fang2hou - Tooltip"] = "Special thanks to fang2hou for the Chinese (Traditional) translations!"
		L["Title - Credits / joaoc_pires"] = "Joao Pires | Código - Bug Fix"
		L["Title - Credits / joaoc_pires - Tooltip"] = "Agradecimento especial a João Pires pela correção de código!"
	end

	--------------------------------
	-- READABLE UI
	--------------------------------

	do
		do -- LIBRARY
			-- PROMPTS
			L["Readable - Library - Prompt - Delete - Local"] = "Isso removerá permanentemente esta entrada da sua biblioteca do PERSONAGEM."
			L["Readable - Library - Prompt - Delete - Global"] = "Isso removerá permanentemente esta entrada da sua biblioteca do BANDO DE GUERRA."
			L["Readable - Library - Prompt - Delete Button 1"] = "Remover"
			L["Readable - Library - Prompt - Delete Button 2"] = "Cancelar"

			L["Readable - Library - Prompt - Import - Local"] = "Importar um estado salvo vai sobrescrever a sua biblioteca do PERSONAGEM."
			L["Readable - Library - Prompt - Import - Global"] = "Importar um estado salvo vai sobrescrever a sua biblioteca do BANDO DE GUERRA."
			L["Readable - Library - Prompt - Import Button 1"] = "Importar e Recarregar"
			L["Readable - Library - Prompt - Import Button 2"] = "Cancelar"

			L["Readable - Library - TextPrompt - Import - Local"] = "Importar para a Biblioteca do PERSONAGEM"
			L["Readable - Library - TextPrompt - Import - Global"] = "Importar para a Biblioteca do BANDO DE GUERRA"
			L["Readable - Library - TextPrompt - Import Input Placeholder"] = "Inserir texto de dados"
			L["Readable - Library - TextPrompt - Import Button 1"] = "Importar"

			L["Readable - Library - TextPrompt - Export - Local"] = "Copiar Dados do Personagem para a Área de Transferência. "
			L["Readable - Library - TextPrompt - Export - Global"] = "Copiar Dados do Bando de Guerra para a Área de Transferência. "
			L["Readable - Library - TextPrompt - Export Input Placeholder"] = "Código de exportação inválido"

			-- SIDEBAR
			L["Readable - Library - Search Input Placeholder"] = "Pesquisar"
			L["Readable - Library - Export Button"] = "Exportar"
			L["Readable - Library - Import Button"] = "Importar"
			L["Readable - Library - Show"] = "Mostrar"
			L["Readable - Library - Letters"] = "Cartas"
			L["Readable - Library - Books"] = "Livros"
			L["Readable - Library - Slates"] = "Anotções"
			L["Readable - Library - Show only World"] = "Não Colecionável"

			-- TITLE
			L["Readable - Library - Name Text - Global"] = "Livraria Bando de Guerra"
			L["Readable - Library - Name Text - Local - Subtext 1"] = ""
			L["Readable - Library - Name Text - Local - Subtext 2"] = "'s Biblioteca"
			L["Readable - Library - Showing Status Text - Subtext 1"] = "Mostrando "
			L["Readable - Library - Showing Status Text - Subtext 2"] = " Itens"

			-- CONTENT
			L["Readable - Library - No Results Text - Subtext 1"] = "Sem resultados para "
			L["Readable - Library - No Results Text - Subtext 2"] = "."
			L["Readable - Library - Empty Library Text"] = "Biblioteca vazia."
		end

		do -- READABLE
			-- NOTIFICATIONS
			L["Readable - Notification - Saved To Library"] = "Salvo na biblioteca"

			-- TOOLTIP
			L["Readable - Tooltip - Change Page"] = "Role para mudar as páginas."
		end
	end

	--------------------------------
	-- AUDIOBOOK
	--------------------------------

	do
		L["Audiobook - Action Tooltip"] = addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/mouse-left.png", 16, 16, 0, 0) .. " para Arrastar.\n" .. addon.API.Util:InlineIcon(addon.Variables.PATH_ART .. "Icons/mouse-right.png", 16, 16, 0, 0) .. " para Fechar."
	end

	--------------------------------
	-- INTERACTION QUEST FRAME
	--------------------------------

	do
		L["InteractionFrame.QuestFrame - Objectives"] = "Objetivos da Missão"
		L["InteractionFrame.QuestFrame - Rewards"] = "Recompensas"
		L["InteractionFrame.QuestFrame - Required Items"] = "Itens Necessários"

		L["InteractionFrame.QuestFrame - Accept - Quest Log Full"] = "Registro de Missões Cheio"
		L["InteractionFrame.QuestFrame - Accept - Auto Accept"] = "Aceitar Automaticamente"
		L["InteractionFrame.QuestFrame - Accept"] = "Aceitar"
		L["InteractionFrame.QuestFrame - Decline"] = "Recusar"
		L["InteractionFrame.QuestFrame - Goodbye"] = "Adeus"
		L["InteractionFrame.QuestFrame - Goodbye - Auto Accept"] = "Entendido"
		L["InteractionFrame.QuestFrame - Continue"] = "Continuar"
		L["InteractionFrame.QuestFrame - In Progress"] = "Em andamento"
		L["InteractionFrame.QuestFrame - Complete"] = "Completar"
	end

	--------------------------------
	-- INTERACTION DIALOG FRAME
	--------------------------------

	do
		L["InteractionFrame.DialogFrame - Skip"] = "PULAR"
	end

	--------------------------------
	-- INTERACTION GOSSIP FRAME
	--------------------------------

	do
		L["InteractionFrame.GossipFrame - Close"] = "Adeus"
	end

	--------------------------------
	-- INTERACTION CONTROL GUIDE
	--------------------------------

	do
		L["ControlGuide - Back"] = "Voltar"
		L["ControlGuide - Next"] = "Próximo"
		L["ControlGuide - Skip"] = "Pular"
		L["ControlGuide - Accept"] = "Aceitar"
		L["ControlGuide - Continue"] = "Continuar"
		L["ControlGuide - Complete"] = "Completar"
		L["ControlGuide - Decline"] = "Recusar"
		L["ControlGuide - Goodbye"] = "Adeus"
		L["ControlGuide - Got it"] = "Entendido"
		L["ControlGuide - Gossip Option Interact"] = "Selecionar Opção"
		L["ControlGuide - Quest Next Reward"] = "Próxima recompensa"
	end

	--------------------------------
	-- ALERT NOTIFICATION
	--------------------------------

	do
		L["Alert Notification - Accept"] = "Missão Aceita"
		L["Alert Notification - Complete"] = "Missão completada"
	end

	--------------------------------
	-- WAYPOINT
	--------------------------------

	do
		L["Waypoint - Ready for Turn-in"] = "Pronto para Entrega"

		L["Waypoint - Waypoint"] = "Ponto de Navegação"
		L["Waypoint - Quest"] = "Missão"
		L["Waypoint - Flight Point"] = "Ponto de Voo"
		L["Waypoint - Pin"] = "Marcador"
		L["Waypoint - Party Member"] = "Membro do Grupo"
		L["Waypoint - Content"] = "Conteúdo"
	end

	--------------------------------
	-- PLAYER STATUS BAR
	--------------------------------

	do
		L["PlayerStatusBar - TooltipLine1"] = "XP Atual: "
		L["PlayerStatusBar - TooltipLine2"] = "XP Restante: "
		L["PlayerStatusBar - TooltipLine3"] = "Nível "
	end

	--------------------------------
	-- MINIMAP ICON
	--------------------------------

	do
		L["MinimapIcon - Tooltip - Title"] = "Coleção de Livros"
		L["MinimapIcon - Tooltip - Entries - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Subtext 2"] = " Registros"
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 1"] = ""
		L["MinimapIcon - Tooltip - Entries - Singular - Subtext 2"] = " Registro"
		L["MinimapIcon - Tooltip - Entries - Empty"] = "Sem Registros."
	end

	--------------------------------
	-- BLIZZARD SETTINGS
	--------------------------------

	do
		L["BlizzardSettings - Title"] = "Abrir Configurações"
		L["BlizzardSettings - Shortcut - Controller"] = "Em qualquer interface de interação."
	end

	--------------------------------
	-- ALERTS
	--------------------------------

	do
		L["Alert - Under Attack"] = "Sob ataque"
		L["Alert - Open Settings"] = "Para abrir as configurações."
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
		L["GossipData - Trigger - Quest"] = "%(Missão%)"
		L["GossipData - Trigger - Movie 1"] = "%(Reproduzir%)"
		L["GossipData - Trigger - Movie 2"] = "%(Reproduzir Filme%)"
		L["GossipData - Trigger - NPC Dialog"] = "%<Fique um pouco e ouça.%>"
		L["GossipData - Trigger - NPC Dialog - Append"] = "Fique um tempo e escute."
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
			L["SupportedAddons - BtWQuests - Tooltip - Call to Action"] = addon.Theme.RGB_ORANGE_HEXCODE .. "Clique para abrir a sequência de missões no BtWQuests" .. "|r"
		end
	end
end

Load()
