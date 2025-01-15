-- Localization and translation ZamestoTV

local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

local addonName, addon = ...
local CallbackRegistry = addon.CallbackRegistry
local L = addon.Locales

--------------------------------

local function Load()
	if GetLocale() ~= "ruRU" then
		return
	end

	--------------------------------
	-- SETTINGS
	--------------------------------

	do
		-- WARNINGS
		L["Warning - Leave NPC Interaction"] = "Оставьте взаимодействие с НПС для настройки параметров."
		L["Warning - Leave ReadableUI"] = "Оставьте удобочитаемый пользовательский интерфейс для настройки параметров."

		-- PROMPTS
		L["Prompt - Reload"] = "Для применения настроек требуется перезагрузка интерфейса"
		L["Prompt - Reload Button 1"] = "Перезагрузить"
		L["Prompt - Reload Button 2"] = "Закрыть"
		L["Prompt - Reset Settings"] = "Вы уверены, что хотите сбросить настройки?"
		L["Prompt - Reset Settings Button 1"] = "Сбросить"
		L["Prompt - Reset Settings Button 2"] = "Отмена"

		-- TABS
		L["Tab - Appearance"] = "Внешний вид"
		L["Tab - Effects"] = "Эффекты"
		L["Tab - Playback"] = "Воспроизведение"
		L["Tab - Controls"] = "Управление"
		L["Tab - Gameplay"] = "Игровой процесс"
		L["Tab - More"] = "Больше"

		-- ELEMENTS
		-- APPEARANCE
		L["Title - Theme"] = "Тема"
		L["Range - Main Theme"] = "Основная тема"
		L["Range - Main Theme - Tooltip"] = "Устанавливает общую тему пользовательского интерфейса.\n\nПо умолчанию: День.\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "Динамичная" .. addon.Theme.Settings.Tooltip_Text_Note .. " настройка устанавливает основную тему в соответствии с игровым циклом день/ночь.|r"
		L["Range - Main Theme - Day"] = "ДЕНЬ"
		L["Range - Main Theme - Night"] = "НОЧЬ"
		L["Range - Main Theme - Dynamic"] = "ДИНАМИЧНАЯ"
		L["Range - Dialog Theme"] = "Тема диалога"
		L["Range - Dialog Theme - Tooltip"] = "Устанавливает тему пользовательского интерфейса диалогового окна НПС.\n\nПо умолчанию: Соответствие.\n\n" .. addon.Theme.Settings.Tooltip_Text_Note_Highlight .. "Соответствие" .. addon.Theme.Settings.Tooltip_Text_Note .. " настройка задает тему диалога в соответствии с основной темой.|r"
		L["Range - Dialog Theme - Auto"] = "СООТВЕТСТВИЕ"
		L["Range - Dialog Theme - Day"] = "ДЕНЬ"
		L["Range - Dialog Theme - Night"] = "НОЧЬ"
		L["Range - Dialog Theme - Rustic"] = "ПРОСТОЙ"
		L["Title - Appearance"] = "Внешний вид"
		L["Range - UIDirection"] = "Направление пользовательского интерфейса"
		L["Range - UIDirection - Tooltip"] = "Задает направление пользовательского интерфейса."
		L["Range - UIDirection - Left"] = "ЛЕВО"
		L["Range - UIDirection - Right"] = "ПРАВО"
		L["Range - UIDirection / Dialog"] = "Фиксированное положение диалога"
		L["Range - UIDirection / Dialog - Tooltip"] = "Устанавливает фиксированное положение диалога.\n\nИсправлен диалог, используемый при недоступности окна с именем НПС."
		L["Range - UIDirection / Dialog - Top"] = "ВВЕРХ"
		L["Range - UIDirection / Dialog - Center"] = "ЦЕНТР"
		L["Range - UIDirection / Dialog - Bottom"] = "НИЗ"
		L["Checkbox - UIDirection / Dialog / Mirror"] = "Зеркало"
		L["Checkbox - UIDirection / Dialog / Mirror - Tooltip"] = "Отражает направление пользовательского интерфейса."
		L["Range - Quest Frame Size"] = "Размер окна задания"
		L["Range - Quest Frame Size - Tooltip"] = "Отрегулируйте размер окна задания.\n\nПо умолчанию: БОЛЬШОЙ."
		L["Range - Quest Frame Size - Small"] = "МАЛЕНЬКИЙ"
		L["Range - Quest Frame Size - Medium"] = "СРЕДНИЙ"
		L["Range - Quest Frame Size - Large"] = "БОЛЬШОЙ"
		L["Range - Quest Frame Size - Extra Large"] = "ОЧЕНЬ БОЛЬШОЙ"
		L["Range - Text Size"] = "Размер текста"
		L["Range - Text Size - Tooltip"] = "Изменить размер текста."
		L["Range - Text Size"] = "Размер содержимого"
		L["Range - Text Size - Tooltip"] = "Настройте размер текста диалога."
		L["Title - Dialog"] = "Диалог"
		L["Checkbox - Dialog / Title / Progress Bar"] = "Показать полосу прогресса"
		L["Checkbox - Dialog / Title / Progress Bar - Tooltip"] = "Показывает или скрывает полосу прогресса диалога.\n\nЭта полоса показывает, насколько далеко вы продвинулись в текущем разговоре.\n\nПо умолчанию: Вкл."
		L["Range - Dialog / Title / Text Alpha"] = "Непрозрачность заголовка"
		L["Range - Dialog / Title / Text Alpha - Tooltip"] = "Устанавливает непрозрачность заголовка диалогового окна.\n\nПо умолчанию: 50%."
		L["Range - Dialog / Content Preview Alpha"] = "Предварительный просмотр непрозрачности"
		L["Range - Dialog / Content Preview Alpha - Tooltip"] = "Устанавливает непрозрачность предварительного просмотра текста диалогового окна.\n\nПо умолчанию: 50%."
		L["Title - Quest"] = "Задание"
		L["Checkbox - Always Show Quest Frame"] = "Всегда показывать окно задания"
		L["Checkbox - Always Show Quest Frame - Tooltip"] = "Всегда показывать окно задания, когда оно доступно, а не только после диалога.\n\nПо умолчанию: Вкл."

		-- VIEWPORT
		L["Title - Effects"] = "Эффекты"
		L["Checkbox - Hide UI"] = "Скрыть пользовательский интерфейс"
		L["Checkbox - Hide UI - Tooltip"] = "Скрывает пользовательский интерфейс во время взаимодействия с НПС.\n\nПо умолчанию: Вкл."
		L["Range - Cinematic"] = "Эффекты камеры"
		L["Range - Cinematic - Tooltip"] = "Эффекты камеры во время взаимодействия.\n\nПо умолчанию: Все."
		L["Range - Cinematic - None"] = "НЕТ"
		L["Range - Cinematic - Full"] = "ВСЕ"
		L["Range - Cinematic - Balanced"] = "СБАЛАНСИРОВАННЫЙ"
		L["Range - Cinematic - Custom"] = "ПОЛЬЗОВАТЕЛЬСКИЙ"
		L["Checkbox - Zoom"] = "Увеличение"
		L["Range - Zoom / Min Distance"] = "Минимальное расстояние"
		L["Range - Zoom / Min Distance - Tooltip"] = "Если текущий зум ниже этого порога, камера будет увеличивать изображение до этого уровня."
		L["Range - Zoom / Max Distance"] = "Макс. расстояние"
		L["Range - Zoom / Max Distance - Tooltip"] = "Если текущий зум превышает этот порог, камера будет увеличивать изображение до этого уровня."
		L["Checkbox - Zoom / Pitch"] = "Отрегулируйте вертикальный угол"
		L["Checkbox - Zoom / Pitch - Tooltip"] = "Включить регулировку угла наклона камеры по вертикали."
		L["Range - Zoom / Pitch / Level"] = "Макс. угол"
		L["Range - Zoom / Pitch / Level - Tooltip"] = "Порог вертикального угла."
		L["Checkbox - Zoom / Field Of View"] = "Отрегулируйте поле зрения"
		L["Checkbox - Pan"] = "Панорама"
		L["Range - Pan / Speed"] = "Скорость"
		L["Range - Pan / Speed - Tooltip"] = "Максимальная скорость панорамирования."
		L["Checkbox - Dynamic Camera"] = "Динамическая камера"
		L["Checkbox - Dynamic Camera - Tooltip"] = "Включить динамические настройки камеры."
		L["Checkbox - Dynamic Camera / Side View"] = "Вид сбоку"
		L["Checkbox - Dynamic Camera / Side View - Tooltip"] = "Отрегулируйте камеру для бокового обзора."
		L["Range - Dynamic Camera / Side View / Strength"] = "Сила"
		L["Range - Dynamic Camera / Side View / Strength - Tooltip"] = "Более высокое значение увеличивает боковое перемещение."
		L["Checkbox - Dynamic Camera / Offset"] = "Смещение"
		L["Checkbox - Dynamic Camera / Offset - Tooltip"] = "Смещение области просмотра от персонажа."
		L["Range - Dynamic Camera / Offset / Strength"] = "Сила"
		L["Range - Dynamic Camera / Offset / Strength - Tooltip"] = "Более высокое значение увеличивает смещение."
		L["Checkbox - Dynamic Camera / Focus"] = "Фокус"
		L["Checkbox - Dynamic Camera / Focus - Tooltip"] = "Фокусировка области просмотра на цели."
		L["Range - Dynamic Camera / Focus / Strength"] = "Сила"
		L["Range - Dynamic Camera / Focus / Strength - Tooltip"] = "Более высокое значение увеличивает силу фокусировки."
		L["Checkbox - Dynamic Camera / Focus / X"] = "Игнорировать ось X"
		L["Checkbox - Dynamic Camera / Focus / X - Tooltip"] = "Запретить фокусировку по оси X."
		L["Checkbox - Dynamic Camera / Focus / Y"] = "Игнорировать ось Y"
		L["Checkbox - Dynamic Camera / Focus / Y - Tooltip"] = "Запретить фокусировку по оси Y."
		L["Checkbox - Vignette"] = "Виньетка"
		L["Checkbox - Vignette - Tooltip"] = "Уменьшает яркость краев."
		L["Checkbox - Vignette / Gradient"] = "Градиент"
		L["Checkbox - Vignette / Gradient - Tooltip"] = "Уменьшить яркость элементов интерфейса сплетен и заданий."

		-- PLAYBACK
		L["Title - Pace"] = "Шаг"
		L["Range - Playback Speed"] = "Скорость воспроизведения"
		L["Range - Playback Speed - Tooltip"] = "Скорость воспроизведения текста.\n\nПо умолчанию: 100%."
		L["Checkbox - Dynamic Playback"] = "Естественное воспроизведение"
		L["Checkbox - Dynamic Playback - Tooltip"] = "Добавляет пунктуационные паузы в диалоге.\n\nПо умолчанию: Вкл."
		L["Title - Auto Progress"] = "Авто Прогресс"
		L["Checkbox - Auto Progress"] = "Включено"
		L["Checkbox - Auto Progress - Tooltip"] = "Автоматически переходить к следующему диалогу.\n\nПо умолчанию: Вкл."
		L["Checkbox - Auto Close Dialog"] = "Автоматическое закрытие"
		L["Checkbox - Auto Close Dialog - Tooltip"] = "Остановить взаимодействие с НПС, если нет доступных вариантов.\n\nПо умолчанию: Вкл."
		L["Range - Auto Progress / Delay"] = "Задержка"
		L["Range - Auto Progress / Delay - Tooltip"] = "Задержка перед следующим диалогом.\n\nПо умолчанию: 1."
		L["Title - Text To Speech"] = "Текст в речь"
		L["Checkbox - Text To Speech"] = "Включено"
		L["Checkbox - Text To Speech - Tooltip"] = "Зачитывает текст диалога.\n\nПо умолчанию: Выкл."
		L["Title - Text To Speech / Playback"] = "Воспроизведение"
		L["Checkbox - Text To Speech / Quest"] = "Воспроизвести задание"
		L["Checkbox - Text To Speech / Quest - Tooltip"] = "Включить преобразование текста в речь в диалоговом окне задания.\n\nПо умолчанию: Вкл."
		L["Checkbox - Text To Speech / Gossip"] = "Воспроизвести сплетни"
		L["Checkbox - Text To Speech / Gossip - Tooltip"] = "Включить преобразование текста в речь в диалоговом окне Сплетен.\n\nПо умолчанию: Вкл."
		L["Range - Text To Speech / Rate"] = "Скорость"
		L["Range - Text To Speech / Rate - Tooltip"] = "Смещение скорости речи.\n\nПо умолчанию: 100%."
		L["Range - Text To Speech / Volume"] = "Громкость"
		L["Range - Text To Speech / Volume - Tooltip"] = "Громкость речи.\n\nПо умолчанию: 100%."
		L["Title - Text To Speech / Voice"] = "Голос"
		L["Dropdown - Text To Speech / Voice / Neutral"] = "Нейтральный"
		L["Dropdown - Text To Speech / Voice / Neutral - Tooltip"] = "Используется для гендерно-нейтральных НПС."
		L["Dropdown - Text To Speech / Voice / Male"] = "Мужской"
		L["Dropdown - Text To Speech / Voice / Male - Tooltip"] = "Используется для мужских НПС."
		L["Dropdown - Text To Speech / Voice / Female"] = "Женский"
		L["Dropdown - Text To Speech / Voice / Female - Tooltip"] = "Используется для женских НПС."
		L["Dropdown - Text To Speech / Voice / Emote"] = "Выражение"
		L["Dropdown - Text To Speech / Voice / Emote - Tooltip"] = "Используется для диалогов в '<>'."
		L["Checkbox - Text To Speech / Player / Voice"] = "Голос игрока"
		L["Checkbox - Text To Speech / Player / Voice - Tooltip"] = "Воспроизводит TTS при выборе опции диалога.\n\nПо умолчанию: Вкл."
		L["Dropdown - Text To Speech / Player / Voice / Voice"] = "Голос"
		L["Dropdown - Text To Speech / Player / Voice / Voice - Tooltip"] = "Голос для диалоговых опций."
		L["Title - More"] = "Более"
		L["Checkbox - Mute Dialog"] = "Отключить диалог НПС"
		L["Checkbox - Mute Dialog - Tooltip"] = "Отключает звук диалогов НПС Blizzard во время взаимодействия с НПС.\n\nПо умолчанию: Выкл."

		-- CONTROLS
		L["Title - UI"] = "UI"
		L["Checkbox - UI / Control Guide"] = "Показать руководство по управлению"
		L["Checkbox - UI / Control Guide - Tooltip"] = "Показывает направляющее окно управления.\n\nПо умолчанию: Вкл."
		L["Title - Platform"] = "Платформа"
		L["Range - Platform"] = "Платформа"
		L["Range - Platform - Tooltip"] = "Для вступления изменений в силу требуется перезагрузка интерфейса."
		L["Range - Platform - PC"] = "PC"
		L["Range - Platform - Playstation"] = "Playstation"
		L["Range - Platform - Xbox"] = "Xbox"
		L["Title - PC"] = "PC"
		L["Title - PC / Keyboard"] = "Клавиатура"
		L["Checkbox - PC / Keyboard / Use Interact Key"] = "Использовать клавишу взаимодействия"
		L["Checkbox - PC / Keyboard / Use Interact Key - Tooltip"] = "Используйте клавишу взаимодействия для пропуска/принятия вместо пробела. Комбинации из нескольких клавиш не поддерживаются.\n\nПо умолчанию: Выкл."
		L["Title - PC / Mouse"] = "Мышь"
		L["Checkbox - PC / Mouse / Flip Mouse Controls"] = "Переключайте элементы управления мышью"
		L["Checkbox - PC / Mouse / Flip Mouse Controls - Tooltip"] = "Переключайте элементы управления ЛКМ и ПКМ.\n\nПо умолчанию: Выкл."
		L["Title - PC / Keybind"] = "Сочетания клавиш"
		L["Keybind - PC / Keybind / Previous"] = "Предыдущее"
		L["Keybind - PC / Keybind / Previous - Tooltip"] = "Предыдущее диалоговое сочетание клавиш.\n\nПо умолчанию: Q."
		L["Keybind - PC / Keybind / Next"] = "Следующий"
		L["Keybind - PC / Keybind / Next - Tooltip"] = "Следующая комбинация клавиш диалога.\n\nПо умолчанию: E."
		L["Keybind - PC / Keybind / Progress"] = "Прогресс"
		L["Keybind - PC / Keybind / Progress - Tooltip"] = "Сочетание клавиш для:\n- Пропуск\n- Принять\n- Продолжить\n- Завершить\n\nПо умолчанию: ПРОБЕЛ."
		L["Keybind - PC / Keybind / Progress - Tooltip / Conflict"] = addon.Theme.Settings.Tooltip_Text_Warning_Highlight .. "Использовать сочетание клавиш" .. addon.Theme.Settings.Tooltip_Text_Warning .. " для настройки этой привязки клавиш необходимо отключить эту опцию.|r"
		L["Keybind - PC / Keybind / Quest Next Reward"] = "Следующая награда"
		L["Keybind - PC / Keybind / Quest Next Reward - Tooltip"] = "Сочетание клавиш для выбора следующей награды за задание.\n\nПо умолчанию: TAB."
		L["Title - Controller"] = "Контроллер"
		L["Title - Controller / Controller"] = "Контроллер"

		-- GAMEPLAY
		L["Title - Waypoint"] = "Точка маршрута"
		L["Checkbox - Waypoint"] = "Включено"
		L["Checkbox - Waypoint - Tooltip"] = "Замена точек маршрута для внутриигровой навигации Blizzard.\n\nПо умолчанию: Вкл."
		L["Checkbox - Waypoint / Audio"] = "Аудио"
		L["Checkbox - Waypoint / Audio - Tooltip"] = "Звуковые эффекты при изменении состояния точки маршрута.\n\nПо умолчанию: Вкл."
		L["Title - Readable"] = "Читаемые предметы"
		L["Checkbox - Readable"] = "Включено"
		L["Checkbox - Readable - Tooltip"] = "Включить настраиваемую библиотеку для читаемых предметов и их хранения.\n\nПо умолчанию: Вкл."
		L["Title - Readable / Display"] = "Отображать"
		L["Checkbox - Readable / Display / Always Show Item"] = "Всегда показывать предмет"
		L["Checkbox - Readable / Display / Always Show Item - Tooltip"] = "Предотвратить закрытие библиотеки при выходе за пределы игрового объекта.\n\nПо умолчанию: Выкл."
		L["Title - Readable / Viewport"] = "Область просмотра"
		L["Checkbox - Readable / Viewport"] = "Использовать эффекты области просмотра"
		L["Checkbox - Readable / Viewport - Tooltip"] = "Эффекты области просмотра при запуске библиотеки.\n\nПо умолчанию: Вкл."
		L["Title - Readable / Shortcuts"] = "Ярлыки"
		L["Checkbox - Readable / Shortcuts / Minimap Icon"] = "Значок на миникарте"
		L["Checkbox - Readable / Shortcuts / Minimap Icon - Tooltip"] = "Отобразить значок на мини-карте для быстрого доступа к библиотеке.\n\nПо умолчанию: Вкл."
		L["Title - Readable / Audiobook"] = "Аудиокнига"
		L["Range - Readable / Audiobook - Rate"] = "Скорость"
		L["Range - Readable / Audiobook - Rate - Tooltip"] = "Скорость воспроизведения.\n\nПо умолчанию: 100%."
		L["Range - Readable / Audiobook - Volume"] = "Громкость"
		L["Range - Readable / Audiobook - Volume - Tooltip"] = "Громкость воспроизведения.\n\nПо умолчанию: 100%."
		L["Dropdown - Readable / Audiobook - Voice"] = "Рассказчик"
		L["Dropdown - Readable / Audiobook - Voice - Tooltip"] = "Воспроизведение голоса."
		L["Title - Gameplay"] = "Геймплей"
		L["Checkbox - Gameplay / Auto Select Option"] = "Автоматический выбор параметров"
		L["Checkbox - Gameplay / Auto Select Option - Tooltip"] = "Выбирает лучший вариант для определенных НПС.\n\nПо умолчанию: Выкл."

		-- MORE
		L["Title - Audio"] = "Аудио"
		L["Checkbox - Audio"] = "Включить аудио"
		L["Checkbox - Audio - Tooltip"] = "Включить звуковые эффекты и аудио.\n\nПо умолчанию: Вкл."
		L["Title - Settings"] = "Настройки"
		L["Checkbox - Settings / Reset Settings"] = "Сбросить все настройки"
		L["Checkbox - Settings / Reset Settings - Tooltip"] = "Сбрасывает настройки до значений по умолчанию.\n\nПо умолчанию: Выкл."

		L["Title - Credits"] = "Acknowledgements"
		L["Title - Credits / ZamestoTV"] = "ZamestoTV | Translator - Russian"
		L["Title - Credits / ZamestoTV - Tooltip"] = "Special thanks to ZamestoTV for the Russian translations!"
	end

	--------------------------------
	-- READABLE UI
	--------------------------------

	do -- LIBRARY
		-- PROMPTS
		L["Readable - Library - Prompt - Delete"] = "Это навсегда удалит эту запись из вашей библиотеки."
		L["Readable - Library - Prompt - Delete Button 1"] = "Удалить"
		L["Readable - Library - Prompt - Delete Button 2"] = "Отмена"

		L["Readable - Library - Prompt - Import"] = "Импорт сохраненного состояния перезапишет вашу текущую библиотеку."
		L["Readable - Library - Prompt - Import Button 1"] = "Импорт и перезагрузка"
		L["Readable - Library - Prompt - Import Button 2"] = "Отмена"

		L["Readable - Library - TextPrompt - Import"] = "Вставить текст данных"
		L["Readable - Library - TextPrompt - Import Input Placeholder"] = "Введите текст данных"
		L["Readable - Library - TextPrompt - Import Button 1"] = "Импорт"

		L["Readable - Library - TextPrompt - Export"] = "Копировать данные в буфер обмена "
		L["Readable - Library - TextPrompt - Export Input Placeholder"] = "Неверный экспортный код"

		-- SIDEBAR
		L["Readable - Library - Search Input Placeholder"] = "Поиск"
		L["Readable - Library - Export Button"] = "Экспорт"
		L["Readable - Library - Import Button"] = "Импорт"
		L["Readable - Library - Show"] = "Показать"
		L["Readable - Library - Letters"] = "Письма"
		L["Readable - Library - Books"] = "Книги"
		L["Readable - Library - Slates"] = "Скрижали"
		L["Readable - Library - Show only World"] = "Только Мир"

		-- TITLE
		L["Readable - Library - Name Text Append"] = " Библиотека"
		L["Readable - Library - Showing Status Text - Subtext 1"] = "Показ "
		L["Readable - Library - Showing Status Text - Subtext 2"] = " Предметы"

		-- CONTENT
		L["Readable - Library - No Results Text - Subtext 1"] = "Нет результатов для "
		L["Readable - Library - No Results Text - Subtext 2"] = "."
		L["Readable - Library - Empty Library Text"] = "Пустая библиотека."
	end

	do -- READABLE
		-- NOTIFICATIONS
		L["Readable - Library - Notification - Saved To Library"] = "Сохранено в библиотеке"

		-- TOOLTIP
		L["Readable - Tooltip - Change Page"] = "Прокрутите, чтобы сменить страницу."
	end

	--------------------------------
	-- INTERACTION QUEST FRAME
	--------------------------------

	do
		L["InteractionQuestFrame - Objectives"] = "Цели"
		L["InteractionQuestFrame - Rewards"] = "Награды"
		L["InteractionQuestFrame - Required Items"] = "Необходимые предметы"

		L["InteractionQuestFrame - Accept - Quest Log Full"] = "Журнал заданий заполнен"
		L["InteractionQuestFrame - Accept - Auto Accept"] = "Автоматически принято"
		L["InteractionQuestFrame - Accept"] = "Принять"
		L["InteractionQuestFrame - Decline"] = "Отклонить"
		L["InteractionQuestFrame - Goodbye"] = "До встречи"
		L["InteractionQuestFrame - Goodbye - Auto Accept"] = "Понятно"
		L["InteractionQuestFrame - Continue"] = "Продолжить"
		L["InteractionQuestFrame - In Progress"] = "В ходе выполнения"
		L["InteractionQuestFrame - Complete"] = "Завершенное"
	end

	--------------------------------
	-- INTERACTION DIALOG FRAME
	--------------------------------

	do
		L["InteractionDialogFrame - Skip"] = "ПРОПУСК"
	end

	--------------------------------
	-- INTERACTION GOSSIP FRAME
	--------------------------------

	do
		L["InteractionGossipFrame - Close"] = "До встречи"
	end

	--------------------------------
	-- INTERACTION CONTROL GUIDE
	--------------------------------

	do
		L["ControlGuide - Back"] = "Назад"
		L["ControlGuide - Next"] = "Следующий"
		L["ControlGuide - Skip"] = "Пропустить"
		L["ControlGuide - Accept"] = "Принять"
		L["ControlGuide - Continue"] = "Продолжить"
		L["ControlGuide - Complete"] = "Завершенно"
		L["ControlGuide - Decline"] = "Отклонить"
		L["ControlGuide - Goodbye"] = "До встречи"
		L["ControlGuide - Got it"] = "Понятно"
		L["ControlGuide - Gossip Option Interact"] = "Выбор настроек"
		L["ControlGuide - Quest Next Reward"] = "Следующая награда"
	end

	--------------------------------
	-- ALERT NOTIFiCATION
	--------------------------------

	do
		L["Alert Notification - Accept"] = "Задание принято"
		L["Alert Notification - Complete"] = "Задание завершено"
	end

	--------------------------------
	-- WAYPOINT
	--------------------------------

	do
		L["Waypoint - Ready for Turn-in"] = "Готов к сдаче"

		L["Waypoint - Waypoint"] = "Точка маршрута"
		L["Waypoint - Quest"] = "Задание"
		L["Waypoint - Flight Point"] = "Точка полета"
		L["Waypoint - Pin"] = "Pin"
		L["Waypoint - Party Member"] = "Член группы"
		L["Waypoint - Content"] = "Содержание"
	end

	--------------------------------
	-- PLAYER STATUS BAR
	--------------------------------

	do
		L["PlayerStatusBar - TooltipLine1"] = "Текущий XP: "
		L["PlayerStatusBar - TooltipLine2"] = "Оставшийся XP: "
		L["PlayerStatusBar - TooltipLine3"] = "Уровень "
	end

	--------------------------------
	-- MINIMAP ICON
	--------------------------------

	do
		L["MinimapIcon - Text"] = "Открытая библиотека взаимодействия."
	end

	--------------------------------
	-- BLIZZARD SETTINGS
	--------------------------------

	do
		L["BlizzardSettings - Title"] = "Открыть настройки"
		L["BlizzardSettings - Shortcut - Controller"] = "в любом интерактивном пользовательском интерфейсе."
	end

	--------------------------------
	-- ALERTS
	--------------------------------

	do
		L["Alert - Under Attack"] = "Под атакой"
		L["Alert - Open Settings"] = "Чтобы открыть настройки."
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
		}

		-- Modifier of dialog playback speed to match the rough speed of base TTS in the language. Higher = faster.
		L["DialogData - PlaybackSpeedModifier"] = 1
	end

	--------------------------------
	-- GOSSIP DATA
	--------------------------------

	do
		-- Need to match Blizzard's special gossip option prefix text.
		L["GossipData - Trigger - Quest"] = "%(Задание%)"
		L["GossipData - Trigger - Movie 1"] = "%(Воспроизвести%)"
		L["GossipData - Trigger - Movie 2"] = "%(Воспроизвести ролик%)"
		L["GossipData - Trigger - NPC Dialog"] = "%<Останься немного и послушай.%>"
		L["GossipData - Trigger - NPC Dialog - Subtext 1"] = "Останься немного и послушай."
	end
end

Load()
