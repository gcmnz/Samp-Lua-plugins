script_name('Dnk Helper')
script_author('Guccimane')
script_version('1.8')

-- Версия 1.2: 
-- 	1. Переписаны команды в более сокращённый вариант
--	2. При взаимодействии с багажником номер слота вводится в конце для экономии времени

-- Версия 1.3:
-- 1. Полностью изменён внешний вид плагина
-- 2. Изменена задержка (теперь действия выполняются быстрее + пофиксилось большое кол-во багов)
-- 3. Добавлена возможность взаимодействия с семейным сейфом

-- Версия 1.4:
-- 1. Добавлен AutoGetGuns
-- 2. Добавлены команды для быстрого взятия материалов с сейфа

-- Версия 1.5(глобальная):
-- 1. Полностью переработана структура плагина
-- 2. Все действия выполняются практически мгновенно
-- 3. Пофикшен баг с разрешением (теперь разрешение не влияет на слоты в багажнике и сейфе)
-- 4. Пофикшен баг с "непрожимом" некоторых клавиш/текстдравов (теперь всё всегда будет прожиматься как надо)
-- 5. Полная оптимизация кода, убрано/переписано большое количество функций

-- Версия 1.6:
-- 1. Добавлены команды, берущие максимальное количество нарко с семейного/личного сейфа
-- 2. Добавлен "AutoGetGuns" с ДНК (при спавне в ДНК автоматически берёт маты до 500)

-- Версия 1.7:
-- 1. Добавлена возможность взять нарко до фулла с семейного/личного сейфа
-- 2. Добавлен вывод кол-ва материалов и наркотиков на экране

-- Версия 1.8:
-- 1. Добавлены горячие клавиши, возможность их отключения
-- 2. Оптимизирован код, убраны/заменены лишние функции, переменные, потоки и тд, убран мусор
-- 3. Добавлена команда для быстрого взятия материалов со склада до фулла
-- 4. Добавлена команда, исправляющая баг с "непрожимом" текстдравов
-- 5. Исправлен кик античитом при спавне

require 'lib.moonloader'
local vkeys = require 'vkeys'
local sampev = require'lib.samp.events'
local inicfg = require 'inicfg'

local fixedSafeTextDraws = {2204, 2180, 2216, 2222}
local safeTextDraws = {2196, 2172, 2208, 2214}
local cells = {2179, 2180, 2181, 2182, 2183, 2184, 2185, 2186, 2172, 2177}

local hello = '{d0ff00}[DnkHelper]{ff931a} Загружен. Автор: Guccimane. Показать команды - /dhelp'

local color = 0xd0ff00
local color2 = 0xff931a


local directIni = 'moonloader\\config\\DnkHelper.ini'
local mainIni = inicfg.load(nil, directIni)

local materials = mainIni.config.materials
local warehouse = false
local status = mainIni.config.status
local drugs = mainIni.config.drugs
local toginfo = mainIni.config.toginfo
local hotkey = mainIni.config.hotkey

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if isSampLoaded() and isSampfuncsLoaded() then
		sampAddChatMessage(hello, color)
	end

	sampRegisterChatCommand('dhelp', cmd_dhelp)

	sampRegisterChatCommand('hkinfo', cmd_hotkeys)
	sampRegisterChatCommand('hotkeys', cmd_hotkeyoff)

	sampRegisterChatCommand('fix', function()
		fixedSafeTextDraws, safeTextDraws = safeTextDraws, fixedSafeTextDraws
		sampAddChatMessage('{d0ff00}[DnkHelper] {ffb600}Текстдравы сейфа {00ff00}исправлены!', color)
	end)

	sampRegisterChatCommand('vtake', cmd_vtake)
	sampRegisterChatCommand('vput', cmd_vput)
	sampRegisterChatCommand('tr', function()
		sampSendChat('/trunk')
	end)
		sampRegisterChatCommand('slotinfo', function()
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} [1] [2] [3] [4]', color)
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} [5] [6] [7] [8]', color)
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} + 1 страница = +8 к каждому слоту', color)
	end)

	sampRegisterChatCommand('sa', cmd_sa)
	sampRegisterChatCommand('fsa', cmd_fsa)

	sampRegisterChatCommand('pde', cmd_pde)
	sampRegisterChatCommand('pd', cmd_pd)
	sampRegisterChatCommand('pm', cmd_pm)

	sampRegisterChatCommand('fpde', cmd_fpde)
	sampRegisterChatCommand('fpd', cmd_fpd)
	sampRegisterChatCommand('fpm', cmd_fpm)

	sampRegisterChatCommand('fm', cmd_fm)
	sampRegisterChatCommand('fd', cmd_fd)
	sampRegisterChatCommand('fde', cmd_fde)

	sampRegisterChatCommand('vm', cmd_vm)
	sampRegisterChatCommand('fvm', cmd_fvm)
	sampRegisterChatCommand('vd', cmd_vd)
	sampRegisterChatCommand('fvd', cmd_fvd)

	sampRegisterChatCommand('toginfo', function()
		toginfo = not toginfo
		sampAddChatMessage(toginfo and '{d0ff00}[DnkHelper] {ffb600}Вывод кол-ва материалов и наркотиков {00ff00}Включен!' or '{d0ff00}[DnkHelper] {ffb600}Вывод кол-ва материалов и наркотиков {ff0000}Выключен!', color)
		mainIni.config.toginfo = toginfo
		if inicfg.save(mainIni, directIni) then return end
	end)

	clickTD = lua_thread.create_suspended(thread_ClickTD)
	clickTDSAFE = lua_thread.create_suspended(thread_ClickTDSAFE)

	sampRegisterChatCommand('agg', function()
		status = not status
		sampAddChatMessage(status and '{d0ff00}[DnkHelper]{ff931a} AutoGetGuns {00ff00}Включен!' or '{d0ff00}[DnkHelper]{ff931a} AutoGetGuns {ff0000}Выключен!', color)
		mainIni.config.status = status
		if inicfg.save(mainIni, directIni) then return end
	end)
	sampRegisterChatCommand('gg', function() sampSendChat('/get guns ' .. 500 - materials) end)

	getguns = lua_thread.create_suspended(thread_getguns)

	thr_uhavedrugs = lua_thread.create_suspended(thread_uhavedrugs)
	thr_uhavematerials = lua_thread.create_suspended(thread_uhavematerials)

	while true do
		wait(0)
		if isKeyJustPressed(VK_3) and not sampIsCursorActive() and hotkey then
			sampSendChat('/de 30')
		elseif isKeyJustPressed(VK_4) and not sampIsCursorActive() and hotkey then
			sampSendChat('/safe materials ' .. 500 - materials)
		elseif isKeyJustPressed(VK_5) and not sampIsCursorActive() and hotkey then
			sampSendChat('/safe drugs ' .. 150 - drugs)
		end
	end
end

function cmd_dhelp()
	sampShowDialog(10, '{d0ff00}[DnkHelper] {ffb600}Основные команды:', '{ffb600}Взаимодействие с сейфом:\n{d0ff00}/pde{ffffff}  Положить дигл в сейф\n{d0ff00}/pd{ffffff}  Положить нарко в сейф\n{d0ff00}/pm{ffffff}  Положить материалы в сейф\n{d0ff00}/vm{ffffff}  Взять материалы до фулла\n{d0ff00}/vd{ffffff}  Взять наркотики до фулла\n\n{ffb600}Взаимодействие с семейным сейфом:\n{d0ff00}/fpde{ffffff}  Положить дигл в сейф\n{d0ff00}/fpd{ffffff}  Положить нарко в сейф\n{d0ff00}/fpm{ffffff}  Положить материалы в сейф\n{d0ff00}/fvm{ffffff}  Взять материалы до фулла\n{d0ff00}/fvd{ffffff}  Взять наркотики до фулла\n\n{ffb600}Взаимодействие с багажником:\n{d0ff00}/vtake{ffffff}  Достать из багажника\n{d0ff00}/vput{ffffff}  Положить в багажник\n{d0ff00}/fm{ffffff}  Зафулить багажник материалами (положить в пустой слот)\n{d0ff00}/fd{ffffff}  Зафулить багажник наркотиками (положить в пустой слот)\n{d0ff00}/fde{ffffff}  Зафулить багажник диглом (положить в пустой слот)\n{d0ff00}/slotinfo{ffffff}  Вывести информацию о слотах багажника\n\n{ffb600}Допольнительные функции:\n{d0ff00}/gg{ffffff}  Автоматическое взятия материалов до фулла\n{d0ff00}/agg{ffffff}  Включение/выключение AutoGetGuns\n{d0ff00}/toginfo{ffffff}  Вывод кол-ва материалов и наркотиков на экране\n{d0ff00}/fix{ffffff}  Исправление текстдравов сейфа (если некорректно работают /pm /pd и тд..)\n\n{ffb600}HotKeys:\n{d0ff00}/hkinfo{ffffff}  Посмотреть информацию о горячих клавишах\n{d0ff00}/hotkeys{ffffff}  Включить/выключить горячие клавиши', 'Вкурил', 'Не вкурил', 0)
end

																					--HOTKEYS
function cmd_hotkeys()
	sampShowDialog(10, '{d0ff00}[DnkHelper] {ffb600}HotKeys:', '{d0ff00}3{ffffff}  Сделать 30 дигла\n{d0ff00}4{ffffff}  Взять материалы до фулла с сейфа\n{d0ff00}5{ffffff}  Взять наркотики до фулла с сейфа', 'Вкурил', 'Не вкурил', 0)
end

function cmd_hotkeyoff()
	hotkey = not hotkey
	sampAddChatMessage(hotkey and '{d0ff00}[DnkHelper]{ff931a} Горячие клавиши {00ff00}Включены!' or '{d0ff00}[DnkHelper]{ff931a} Горячие клавиши {ff0000}Выключены!', color)
	mainIni.config.hotkey = hotkey
	if inicfg.save(mainIni, directIni) then return end
end
																					--/HOTKEYS


																					--SAFE FSAFE
function cmd_sa(value)
	parameter, value = string.match(value, '(.+) (.+)')
	if parameter == '' or parameter == nil then
		sampSendChat('/safe')
	else
		sampSendChat('/safe ' .. parameter .. ' ' .. value)
	end
end

function cmd_fsa(value)
	parameter, value = string.match(value, '(.+) (.+)')
	if parameter == '' or parameter == nil then
		sampSendChat('/fsafe')
	else
		sampSendChat('/fsafe ' .. parameter .. ' ' .. value)
	end
end

function thread_ClickTDSAFE(amount, textdraw, takeorput)
	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	ping = sampGetPlayerPing(id)
	temp = 3
	sampSendClickTextdraw(safeTextDraws[textdraw])
	wait(ping*temp)
	sampSendClickTextdraw(safeTextDraws[takeorput])
	sampSendDialogResponse(32700, 1, 0, amount)
	wait(ping*temp)
	setVirtualKeyDown(VK_RETURN, true)
	setVirtualKeyDown(VK_RETURN, false)
end

function cmd_pm(value)
	if value == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Используй: /pm [количество]', color)
	elseif tonumber(value) < 1 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверное количество!', color)
	else
		sampSendChat('/safe')
		clickTDSAFE:run(value, 3, 4)
	end
end

function cmd_pd(value)
	if value == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Используй: /pd [количество]', color)
	elseif tonumber(value) < 1 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверное количество!', color)
	else
		sampSendChat('/safe')
		clickTDSAFE:run(value, 1, 4)
	end
end

function cmd_pde(value)
	if value == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Используй: /pde [количество]', color)
	elseif tonumber(value) < 1 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверное количество!', color)
	else
		sampSendChat('/safe')
		clickTDSAFE:run(value, 2, 4)
	end
end

function cmd_fpm(value)
	if value == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Используй: /pm [количество]', color)
	elseif tonumber(value) < 1 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверное количество!', color)
	else
		sampSendChat('/fsafe')
		clickTDSAFE:run(value, 3, 4)
	end
end

function cmd_fpd(value)
	if value == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Используй: /pd [количество]', color)
	elseif tonumber(value) < 1 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверное количество!', color)
	else
		sampSendChat('/fsafe')
		clickTDSAFE:run(value, 1, 4)
	end
end

function cmd_fpde(value)
	if value == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Используй: /pde [количество]', color)
	elseif tonumber(value) < 1 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверное количество!', color)
	else
		sampSendChat('/fsafe')
		clickTDSAFE:run(value, 2, 4)
	end
end
																					--/SAFE FSAFE


																					--TAKEPUT
function thread_ClickTD(amount, cell, state)
	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	ping = sampGetPlayerPing(id)
	cell = tonumber(cell)
	amount = tonumber(amount)
	temp = 3
	if cell > 0 and cell < 9 then
		i = 0
	elseif cell > 8 and cell < 17 then
		i = 1
	elseif cell > 16 and cell < 25 then
		i = 2
	else
		i = 3
	end
	for list = 1, i do
		sampSendClickTextdraw(cells[9])
		wait(ping*temp)
	end
	if cell%8 == 0 then
		cell = 8
	else
		cell = cell%8
	end
	sampSendClickTextdraw(cells[cell])
	sampSendDialogResponse(32700, 1, state, '')
	sampSendDialogResponse(32700, 1, 0, amount)
	wait(ping*temp)
	setVirtualKeyDown(VK_RETURN, true)
	setVirtualKeyDown(VK_RETURN, false)
	sampSendClickTextdraw(cells[10])
end

function cmd_vtake(value)
	local amount, cell = string.match(value, '(.+) (.+)')
	if amount == nil or cell == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} /vtake [кол-во] [номер слота]', color)
	elseif tonumber(cell) < 1 or tonumber(cell) > 32 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверный слот!', color)
	elseif tonumber(amount) < 1 or tonumber(amount) > 1000 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверное количество!', color)
	else
		sampSendChat('/trunk')
		put = 1
		clickTD:run(amount, cell, put)
	end
end

function cmd_vput(value)
	local amount, cell = string.match(value, '(.+) (.+)')
	if amount == nil and cell == nil then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} /vput [кол-во] [номер слота]', color)
	elseif tonumber(cell) < 1 or tonumber(cell) > 32 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверный слот!', color)
	elseif tonumber(amount) < 1 or tonumber(amount) > 1000 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверное количество!', color)
	else
		sampSendChat('/trunk')
		put = 0
		clickTD:run(amount, cell, put)
	end
end
																					--/TAKEPUT


																					--FULL
function cmd_fm(value)
	local amount, cell = string.match(value, '(.+) (.+)')
	if amount == nil or amount == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Используй: /fm [количество] [слот]', color)
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Максимально допустимое значение: 500', color)
	elseif tonumber(cell) < 1 or tonumber(cell) > 32 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверный слот!', color)
	elseif tonumber(amount) < 1 or tonumber(amount) > 500 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверное количество!', color)
	else
		sampSendChat('/trunk')
		clickTD:run(amount, cell, 8)
	end
end

function cmd_fd(value)
	local amount, cell = string.match(value, '(.+) (.+)')
	if amount == nil or amount == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Используй: /fd [количество] [слот]', color)
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Максимально допустимое значение: 250', color)
	elseif tonumber(cell) < 1 or tonumber(cell) > 32 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверный слот!', color)
	elseif tonumber(amount) < 1 or tonumber(amount) > 250 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверное количество!', color)
	else
		sampSendChat('/trunk')
		clickTD:run(amount, cell, 7)
	end
end

function cmd_fde(value)
	local amount, cell = string.match(value, '(.+) (.+)')
	if amount == nil or amount == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Используй: /fde [количество] [слот]', color)
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Максимально допустимое значение: 300', color)
	elseif tonumber(cell) < 1 or tonumber(cell) > 32 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверный слот!', color)
	elseif tonumber(amount) < 1 or tonumber(amount) > 300 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Неверное количество!', color)
	else
		sampSendChat('/trunk')
		clickTD:run(amount, cell, 1)
	end
end
																					--/FULL


																					--AGG
function sampev.onServerMessage(color, text)
	if color == 1687547391 and text:find('Вы купили ') and text:find('грамм наркотиков за ') and text:find('У вас есть ') then
		drugs = 150
		thr_uhavedrugs:run()
		mainIni.config.drugs = drugs
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -86 and text:find(' Остаток: ') and text:find(' грамм ') then
		drugs = text:sub(14, text:len() - 9)
		thr_uhavedrugs:run()
		mainIni.config.drugs = drugs
		if inicfg.save(mainIni, directIni) then return end
	end

	if color == -858993409 and text:find(' Вы положили в сейф ') and text:find(' наркотиков') then
		drugs = drugs - text:sub(21, text:len() - 11)
		thr_uhavedrugs:run()
		mainIni.config.drugs = drugs
		if inicfg.save(mainIni, directIni) then return end
	end

	if color == -858993409 and text:find(' наркотиков') and text:find(' Вы взяли ') then
		drugs = drugs + text:sub(11, text:len() - 11)
		thr_uhavedrugs:run()
		mainIni.config.drugs = drugs
		if inicfg.save(mainIni, directIni) then return end
	end

	if color == -858993409 and text:find(' ед.') and text:find(' Вы взяли из багажника {FFFFFF}"Наркотики{CCCCCC}" в размере') then
		drugs = drugs + text:sub(62, text:len() - 4)
		thr_uhavedrugs:run()
		mainIni.config.drugs = drugs
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -858993409 and text:find(' ед.') and text:find(' Вы положили в багажник {FFFFFF}"Наркотики" {CCCCCC}в размере ') then
		drugs = drugs - text:sub(63, text:len() - 4)
		thr_uhavedrugs:run()
		mainIni.config.drugs = drugs
		if inicfg.save(mainIni, directIni) then return end
	end
    if string.find(text, 'У вас нет столько патронов Deagle', 1, true) or string.find(text, 'Указано не верное значение (от 1 до 300)', 1, true) then
    	sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Этот слот пуст или введено неверное значение', 0xFFFF00)
    	return false
    elseif string.find(text, 'У вас нет с собой Silenced pistol', 1, true) or string.find(text, 'Указано не верное значение (от 1 до 300)', 1, true) then
    	sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} Этот слот пуст или введено неверное значение', 0xFFFF00)
    	return false
    end
    if color == -858993409 and text:find('материалов') and text:find('Вы взяли ') then
    	materials = materials + text:sub(11, -12)
		thr_uhavematerials:run()
		mainIni.config.materials = materials
		if inicfg.save(mainIni, directIni) then return end
	elseif color == -858993409 and text:find('материалов') and text:find('Вы положили в сейф') then
		materials = materials - text:sub(21, -12)
		thr_uhavematerials:run()
		mainIni.config.materials = materials
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -858993409 and text:find('Вы взяли из багажника {FFFFFF}"Материалы{CCCCCC}" в размере ') then
		materials = materials + text:sub(62, -5)
		thr_uhavematerials:run()
		mainIni.config.materials = materials
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -858993409 and text:find('Вы положили в багажник {FFFFFF}"Материалы" {CCCCCC}в размере ') then
		materials = materials - text:sub(63, -5)
		thr_uhavematerials:run()
		mainIni.config.materials = materials
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -86 and text:find(' материалов с собой') and text:find('У вас') then
		materials = text:sub(8, -24)
		thr_uhavematerials:run()
		mainIni.config.materials = materials:sub(1, temp)
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -1029514582 and text:find('Осталось материалов:') then
		materials = string.sub(text, 23)
		thr_uhavematerials:run()
		mainIni.config.materials = materials
		if inicfg.save(mainIni, directIni) then
			if status and warehouse then
				getguns:run(materials, 1000)
			end
		end
	end
	if color == 12145578 and text:find('{33AA33}Открыл {00B953}доступ к складу с материалами!') then
		if status then
			getguns:run(materials, 0)
		end
		warehouse = true
	end
	if color == 12145578 and text:find('{BC2C2C}Закрыл {00B953}доступ к складу с материалами!') then
		warehouse = false
	end
	if color == -1263159297 and text == ' Вы не на своей базе' then
		if status then return false end
	end
	if color == 1687547391 and text == ' Вы взяли несколько комплектов' then
		materials = 500
		thr_uhavematerials:run()
		mainIni.config.materials = materials
		if inicfg.save(mainIni, directIni) then return end
	end
end

function thread_getguns(value, waiting)
	wait(tonumber(waiting))
	sampSendChat('/get guns ' .. 500 - value)
end

function sampev.onSendSpawn()
	if warehouse and status then
		_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		ping = sampGetPlayerPing(id)
		getguns:run(materials, ping)
	end
end

    																				--/AGG


																					--VM FVM
function cmd_vm()
	sampSendChat('/safe materials ' .. 500 - materials)
end

function cmd_fvm()
	sampSendChat('/fsafe materials ' .. 500 - materials)
end

																					--/VM FVM



																					--VD FVD
function cmd_vd()
	sampSendChat('/safe drugs ' .. 150 - drugs)
end

function cmd_fvd()
	sampSendChat('/fsafe drugs ' .. 150 - drugs)
end
																					--/VD FVD

																					--TEXTDRAWS

function customTexdraw(td_id, td_text, x, y, td_align, td_style, td_proportional, td_shadow, td_shadowColor, td_outline, td_outlineColor, td_sizex, td_sizey, td_color)
	sampTextdrawCreate(td_id, td_text, x, y)
	sampTextdrawSetString(td_id, td_text)
	sampTextdrawSetAlign(td_id, td_align)
	sampTextdrawSetStyle(td_id, td_style)
	sampTextdrawSetProportional(td_id, td_proportional)
	sampTextdrawSetShadow(td_id, td_shadow, td_shadowColor)
	sampTextdrawSetOutlineColor(td_id, td_outline, td_outlineColor)
	sampTextdrawSetLetterSizeAndColor(td_id, td_sizex, td_sizey, td_color)
end

function thread_uhavedrugs()
	if toginfo then
		while true do
			sampTextdrawDelete(1006)
			sampTextdrawDelete(1007)
			sampTextdrawDelete(1005)
			customTexdraw(1001, 'You have', 635, 287, 3, 0, 1, 1, 0xFF0000, 1.5, 0xFF000000, 1, 2.6, 4293050214)
			customTexdraw(1002, drugs, 520, 310, 3, 0, 1, 1, 0xFF0000, 1.5, 0xFF000000, 1, 2.6, 4281548418)
			customTexdraw(1003, 'drugs', 620, 310, 3, 0, 1, 1, 0xFF0000, 1.5, 0xFF000000, 0.95, 2.6, 4281622573)
			wait(9000)
			sampTextdrawDelete(1003)
			sampTextdrawDelete(1002)
			sampTextdrawDelete(1001)
			break
		end
	end
end

function thread_uhavematerials()
	if toginfo then
		while true do
			sampTextdrawDelete(1003)
			sampTextdrawDelete(1002)
			sampTextdrawDelete(1001)
			customTexdraw(1005, 'You have', 635, 287, 3, 0, 1, 1, 0xFF0000, 1.5, 0xFF000000, 1, 2.6, 4293050214)
			customTexdraw(1006, materials, 500, 310, 3, 0, 1, 1, 0xFF0000, 1.5, 0xFF000000, 1, 2.6, 4281548418)
			customTexdraw(1007, 'materials', 620, 310, 3, 0, 1, 1, 0xFF0000, 1.5, 0xFF000000, 0.95, 2.6, 4281622573)
			wait(9000)
			sampTextdrawDelete(1006)
			sampTextdrawDelete(1007)
			sampTextdrawDelete(1005)
			break
		end
	end
end

																					--/TEXTDRAWS