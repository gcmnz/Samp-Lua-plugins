script_name('Dnk Helper')
script_author('Guccimane')
script_version('1.8')

-- ������ 1.2: 
-- 	1. ���������� ������� � ����� ����������� �������
--	2. ��� �������������� � ���������� ����� ����� �������� � ����� ��� �������� �������

-- ������ 1.3:
-- 1. ��������� ������ ������� ��� �������
-- 2. �������� �������� (������ �������� ����������� ������� + ����������� ������� ���-�� �����)
-- 3. ��������� ����������� �������������� � �������� ������

-- ������ 1.4:
-- 1. �������� AutoGetGuns
-- 2. ��������� ������� ��� �������� ������ ���������� � �����

-- ������ 1.5(����������):
-- 1. ��������� ������������ ��������� �������
-- 2. ��� �������� ����������� ����������� ���������
-- 3. �������� ��� � ����������� (������ ���������� �� ������ �� ����� � ��������� � �����)
-- 4. �������� ��� � "����������" ��������� ������/����������� (������ �� ������ ����� ����������� ��� ����)
-- 5. ������ ����������� ����, ������/���������� ������� ���������� �������

-- ������ 1.6:
-- 1. ��������� �������, ������� ������������ ���������� ����� � ���������/������� �����
-- 2. �������� "AutoGetGuns" � ��� (��� ������ � ��� ������������� ���� ���� �� 500)

-- ������ 1.7:
-- 1. ��������� ����������� ����� ����� �� ����� � ���������/������� �����
-- 2. �������� ����� ���-�� ���������� � ���������� �� ������

-- ������ 1.8:
-- 1. ��������� ������� �������, ����������� �� ����������
-- 2. ������������� ���, ������/�������� ������ �������, ����������, ������ � ��, ����� �����
-- 3. ��������� ������� ��� �������� ������ ���������� �� ������ �� �����
-- 4. ��������� �������, ������������ ��� � "����������" �����������
-- 5. ��������� ��� ��������� ��� ������

require 'lib.moonloader'
local vkeys = require 'vkeys'
local sampev = require'lib.samp.events'
local inicfg = require 'inicfg'

local fixedSafeTextDraws = {2204, 2180, 2216, 2222}
local safeTextDraws = {2196, 2172, 2208, 2214}
local cells = {2179, 2180, 2181, 2182, 2183, 2184, 2185, 2186, 2172, 2177}

local hello = '{d0ff00}[DnkHelper]{ff931a} ��������. �����: Guccimane. �������� ������� - /dhelp'

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
		sampAddChatMessage('{d0ff00}[DnkHelper] {ffb600}���������� ����� {00ff00}����������!', color)
	end)

	sampRegisterChatCommand('vtake', cmd_vtake)
	sampRegisterChatCommand('vput', cmd_vput)
	sampRegisterChatCommand('tr', function()
		sampSendChat('/trunk')
	end)
		sampRegisterChatCommand('slotinfo', function()
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} [1] [2] [3] [4]', color)
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} [5] [6] [7] [8]', color)
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} + 1 �������� = +8 � ������� �����', color)
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
		sampAddChatMessage(toginfo and '{d0ff00}[DnkHelper] {ffb600}����� ���-�� ���������� � ���������� {00ff00}�������!' or '{d0ff00}[DnkHelper] {ffb600}����� ���-�� ���������� � ���������� {ff0000}��������!', color)
		mainIni.config.toginfo = toginfo
		if inicfg.save(mainIni, directIni) then return end
	end)

	clickTD = lua_thread.create_suspended(thread_ClickTD)
	clickTDSAFE = lua_thread.create_suspended(thread_ClickTDSAFE)

	sampRegisterChatCommand('agg', function()
		status = not status
		sampAddChatMessage(status and '{d0ff00}[DnkHelper]{ff931a} AutoGetGuns {00ff00}�������!' or '{d0ff00}[DnkHelper]{ff931a} AutoGetGuns {ff0000}��������!', color)
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
	sampShowDialog(10, '{d0ff00}[DnkHelper] {ffb600}�������� �������:', '{ffb600}�������������� � ������:\n{d0ff00}/pde{ffffff}  �������� ���� � ����\n{d0ff00}/pd{ffffff}  �������� ����� � ����\n{d0ff00}/pm{ffffff}  �������� ��������� � ����\n{d0ff00}/vm{ffffff}  ����� ��������� �� �����\n{d0ff00}/vd{ffffff}  ����� ��������� �� �����\n\n{ffb600}�������������� � �������� ������:\n{d0ff00}/fpde{ffffff}  �������� ���� � ����\n{d0ff00}/fpd{ffffff}  �������� ����� � ����\n{d0ff00}/fpm{ffffff}  �������� ��������� � ����\n{d0ff00}/fvm{ffffff}  ����� ��������� �� �����\n{d0ff00}/fvd{ffffff}  ����� ��������� �� �����\n\n{ffb600}�������������� � ����������:\n{d0ff00}/vtake{ffffff}  ������� �� ���������\n{d0ff00}/vput{ffffff}  �������� � ��������\n{d0ff00}/fm{ffffff}  �������� �������� ����������� (�������� � ������ ����)\n{d0ff00}/fd{ffffff}  �������� �������� ����������� (�������� � ������ ����)\n{d0ff00}/fde{ffffff}  �������� �������� ������ (�������� � ������ ����)\n{d0ff00}/slotinfo{ffffff}  ������� ���������� � ������ ���������\n\n{ffb600}��������������� �������:\n{d0ff00}/gg{ffffff}  �������������� ������ ���������� �� �����\n{d0ff00}/agg{ffffff}  ���������/���������� AutoGetGuns\n{d0ff00}/toginfo{ffffff}  ����� ���-�� ���������� � ���������� �� ������\n{d0ff00}/fix{ffffff}  ����������� ����������� ����� (���� ����������� �������� /pm /pd � ��..)\n\n{ffb600}HotKeys:\n{d0ff00}/hkinfo{ffffff}  ���������� ���������� � ������� ��������\n{d0ff00}/hotkeys{ffffff}  ��������/��������� ������� �������', '������', '�� ������', 0)
end

																					--HOTKEYS
function cmd_hotkeys()
	sampShowDialog(10, '{d0ff00}[DnkHelper] {ffb600}HotKeys:', '{d0ff00}3{ffffff}  ������� 30 �����\n{d0ff00}4{ffffff}  ����� ��������� �� ����� � �����\n{d0ff00}5{ffffff}  ����� ��������� �� ����� � �����', '������', '�� ������', 0)
end

function cmd_hotkeyoff()
	hotkey = not hotkey
	sampAddChatMessage(hotkey and '{d0ff00}[DnkHelper]{ff931a} ������� ������� {00ff00}��������!' or '{d0ff00}[DnkHelper]{ff931a} ������� ������� {ff0000}���������!', color)
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
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ���������: /pm [����������]', color)
	elseif tonumber(value) < 1 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����������!', color)
	else
		sampSendChat('/safe')
		clickTDSAFE:run(value, 3, 4)
	end
end

function cmd_pd(value)
	if value == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ���������: /pd [����������]', color)
	elseif tonumber(value) < 1 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����������!', color)
	else
		sampSendChat('/safe')
		clickTDSAFE:run(value, 1, 4)
	end
end

function cmd_pde(value)
	if value == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ���������: /pde [����������]', color)
	elseif tonumber(value) < 1 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����������!', color)
	else
		sampSendChat('/safe')
		clickTDSAFE:run(value, 2, 4)
	end
end

function cmd_fpm(value)
	if value == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ���������: /pm [����������]', color)
	elseif tonumber(value) < 1 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����������!', color)
	else
		sampSendChat('/fsafe')
		clickTDSAFE:run(value, 3, 4)
	end
end

function cmd_fpd(value)
	if value == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ���������: /pd [����������]', color)
	elseif tonumber(value) < 1 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����������!', color)
	else
		sampSendChat('/fsafe')
		clickTDSAFE:run(value, 1, 4)
	end
end

function cmd_fpde(value)
	if value == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ���������: /pde [����������]', color)
	elseif tonumber(value) < 1 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����������!', color)
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
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} /vtake [���-��] [����� �����]', color)
	elseif tonumber(cell) < 1 or tonumber(cell) > 32 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����!', color)
	elseif tonumber(amount) < 1 or tonumber(amount) > 1000 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����������!', color)
	else
		sampSendChat('/trunk')
		put = 1
		clickTD:run(amount, cell, put)
	end
end

function cmd_vput(value)
	local amount, cell = string.match(value, '(.+) (.+)')
	if amount == nil and cell == nil then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} /vput [���-��] [����� �����]', color)
	elseif tonumber(cell) < 1 or tonumber(cell) > 32 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����!', color)
	elseif tonumber(amount) < 1 or tonumber(amount) > 1000 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����������!', color)
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
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ���������: /fm [����������] [����]', color)
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ����������� ���������� ��������: 500', color)
	elseif tonumber(cell) < 1 or tonumber(cell) > 32 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����!', color)
	elseif tonumber(amount) < 1 or tonumber(amount) > 500 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����������!', color)
	else
		sampSendChat('/trunk')
		clickTD:run(amount, cell, 8)
	end
end

function cmd_fd(value)
	local amount, cell = string.match(value, '(.+) (.+)')
	if amount == nil or amount == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ���������: /fd [����������] [����]', color)
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ����������� ���������� ��������: 250', color)
	elseif tonumber(cell) < 1 or tonumber(cell) > 32 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����!', color)
	elseif tonumber(amount) < 1 or tonumber(amount) > 250 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����������!', color)
	else
		sampSendChat('/trunk')
		clickTD:run(amount, cell, 7)
	end
end

function cmd_fde(value)
	local amount, cell = string.match(value, '(.+) (.+)')
	if amount == nil or amount == '' then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ���������: /fde [����������] [����]', color)
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ����������� ���������� ��������: 300', color)
	elseif tonumber(cell) < 1 or tonumber(cell) > 32 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����!', color)
	elseif tonumber(amount) < 1 or tonumber(amount) > 300 then
		sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} �������� ����������!', color)
	else
		sampSendChat('/trunk')
		clickTD:run(amount, cell, 1)
	end
end
																					--/FULL


																					--AGG
function sampev.onServerMessage(color, text)
	if color == 1687547391 and text:find('�� ������ ') and text:find('����� ���������� �� ') and text:find('� ��� ���� ') then
		drugs = 150
		thr_uhavedrugs:run()
		mainIni.config.drugs = drugs
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -86 and text:find(' �������: ') and text:find(' ����� ') then
		drugs = text:sub(14, text:len() - 9)
		thr_uhavedrugs:run()
		mainIni.config.drugs = drugs
		if inicfg.save(mainIni, directIni) then return end
	end

	if color == -858993409 and text:find(' �� �������� � ���� ') and text:find(' ����������') then
		drugs = drugs - text:sub(21, text:len() - 11)
		thr_uhavedrugs:run()
		mainIni.config.drugs = drugs
		if inicfg.save(mainIni, directIni) then return end
	end

	if color == -858993409 and text:find(' ����������') and text:find(' �� ����� ') then
		drugs = drugs + text:sub(11, text:len() - 11)
		thr_uhavedrugs:run()
		mainIni.config.drugs = drugs
		if inicfg.save(mainIni, directIni) then return end
	end

	if color == -858993409 and text:find(' ��.') and text:find(' �� ����� �� ��������� {FFFFFF}"���������{CCCCCC}" � �������') then
		drugs = drugs + text:sub(62, text:len() - 4)
		thr_uhavedrugs:run()
		mainIni.config.drugs = drugs
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -858993409 and text:find(' ��.') and text:find(' �� �������� � �������� {FFFFFF}"���������" {CCCCCC}� ������� ') then
		drugs = drugs - text:sub(63, text:len() - 4)
		thr_uhavedrugs:run()
		mainIni.config.drugs = drugs
		if inicfg.save(mainIni, directIni) then return end
	end
    if string.find(text, '� ��� ��� ������� �������� Deagle', 1, true) or string.find(text, '������� �� ������ �������� (�� 1 �� 300)', 1, true) then
    	sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ���� ���� ���� ��� ������� �������� ��������', 0xFFFF00)
    	return false
    elseif string.find(text, '� ��� ��� � ����� Silenced pistol', 1, true) or string.find(text, '������� �� ������ �������� (�� 1 �� 300)', 1, true) then
    	sampAddChatMessage('{d0ff00}[DnkHelper]{ff931a} ���� ���� ���� ��� ������� �������� ��������', 0xFFFF00)
    	return false
    end
    if color == -858993409 and text:find('����������') and text:find('�� ����� ') then
    	materials = materials + text:sub(11, -12)
		thr_uhavematerials:run()
		mainIni.config.materials = materials
		if inicfg.save(mainIni, directIni) then return end
	elseif color == -858993409 and text:find('����������') and text:find('�� �������� � ����') then
		materials = materials - text:sub(21, -12)
		thr_uhavematerials:run()
		mainIni.config.materials = materials
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -858993409 and text:find('�� ����� �� ��������� {FFFFFF}"���������{CCCCCC}" � ������� ') then
		materials = materials + text:sub(62, -5)
		thr_uhavematerials:run()
		mainIni.config.materials = materials
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -858993409 and text:find('�� �������� � �������� {FFFFFF}"���������" {CCCCCC}� ������� ') then
		materials = materials - text:sub(63, -5)
		thr_uhavematerials:run()
		mainIni.config.materials = materials
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -86 and text:find(' ���������� � �����') and text:find('� ���') then
		materials = text:sub(8, -24)
		thr_uhavematerials:run()
		mainIni.config.materials = materials:sub(1, temp)
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -1029514582 and text:find('�������� ����������:') then
		materials = string.sub(text, 23)
		thr_uhavematerials:run()
		mainIni.config.materials = materials
		if inicfg.save(mainIni, directIni) then
			if status and warehouse then
				getguns:run(materials, 1000)
			end
		end
	end
	if color == 12145578 and text:find('{33AA33}������ {00B953}������ � ������ � �����������!') then
		if status then
			getguns:run(materials, 0)
		end
		warehouse = true
	end
	if color == 12145578 and text:find('{BC2C2C}������ {00B953}������ � ������ � �����������!') then
		warehouse = false
	end
	if color == -1263159297 and text == ' �� �� �� ����� ����' then
		if status then return false end
	end
	if color == 1687547391 and text == ' �� ����� ��������� ����������' then
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