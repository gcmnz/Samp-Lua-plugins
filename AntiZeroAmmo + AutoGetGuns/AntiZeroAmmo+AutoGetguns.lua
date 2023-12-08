script_name('AntiZeroAmmo&AutoGetguns')
script_author('Guccimane')
script_version('1.0')

require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'

local directIni = 'moonloader\\config\\AntiZeroAmmo+AutoGetguns.ini'
local mainIni = inicfg.load(nil, directIni)

local aza = mainIni.config.aza
local craftammo = mainIni.config.CraftAmmo
local minammo = mainIni.config.MinAmmo
local agg = mainIni.config.agg

local patron = '������'
local materials = mainIni.config.materials

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if isSampLoaded() and isSampfuncsLoaded() then
		wait(1000)
		sampAddChatMessage('{E53935}[AntiZeroAmmo & AutoGetGuns] {ffffff}��������. �����: Guccimane. ���������� ��� ������� - /azahelp', -1)
	end

	sampRegisterChatCommand('aza', cmd_aza)
	sampRegisterChatCommand('ca', cmd_craftammo)
	sampRegisterChatCommand('ma', cmd_minammo)
	sampRegisterChatCommand('azahelp', cmd_azahelp)
	sampRegisterChatCommand('agg', cmd_agg)

	gg = lua_thread.create_suspended(thread_gg)

	while true do
		wait(0)
		if getAmmoInCharWeapon(PLAYER_PED, 24) == tonumber(minammo) then
			craft()
			wait(1000)
		end
	end
end

function cmd_aza()
	if aza then
		sampAddChatMessage('{E53935}[AntiZeroAmmo] {ffffff}��������.', -1)
		aza = false
	else
		aza = true
		sampAddChatMessage('{E53935}[AntiZeroAmmo] {ffffff}�������.', -1)
	end
	mainIni.config.aza = aza
	if inicfg.save(mainIni, directIni) then end
end

function cmd_craftammo(value)
	if aza then
		if value == '' or tonumber(value) < 1 or tonumber(value) > 100 then
			sampAddChatMessage('{E53935}[AntiZeroAmmo] {ffffff}/ca [1-100]', -1)
		else
			craftammo = tonumber(value)
			if craftammo == 1 then
				patron = '������!'
			elseif craftammo > 1 and craftammo < 5 then
				patron = '�������!'
			else
				patron = '��������!'
			end
			mainIni.config.CraftAmmo = value
			if inicfg.save(mainIni, directIni) then end
			sampAddChatMessage('{E53935}[AntiZeroAmmo] {ffffff}��� ' .. minammo .. '{ffffff} �� ������� '.. value .. '{ffffff} ' .. patron, -1)
		end
	else
		sampAddChatMessage('{E53935}[AntiZeroAmmo] {ffffff}������.', -1)
	end
end

function cmd_minammo(value)
	if aza then
		if value == '' or tonumber(value) < 1 or tonumber(value) > 100 then
			sampAddChatMessage('{E53935}[AntiZeroAmmo] {ffffff}/ma [1-100]', -1)
		else
			minammo = value
			mainIni.config.MinAmmo = value
			if inicfg.save(mainIni, directIni) then end
			sampAddChatMessage('{E53935}[AntiZeroAmmo] {ffffff}��� {ffffff}' .. minammo .. '{ffffff} �� ������� {ffffff}'.. craftammo .. '{ffffff} ' .. patron, -1)
		end
	else
		sampAddChatMessage('{E53935}[AntiZeroAmmo] {ffffff}������.', -1)
	end
end

function craft()
	if aza then
		if tonumber(materials) > tonumber(craftammo)*3 then
			sampSendChat('/gun deagle ' .. tostring(craftammo))
		else
			sampAddChatMessage('{E53935}[AntiZeroAmmo] {ffffff}������������ ����������.', -1)
			wait(5000)
		end
	end
end

function cmd_azahelp()
	sampShowDialog(10, '{E53935}[AntiZeroAmmo & AutoGetGuns] {ffffff}by Guccimane', '{E53935}/aza  {ffffff}���������/���������� �������\n{E53935}/ca    {ffffff}������� ��� ������\n{E53935}/ma {ffffff}  ����������� ���������� ��������\n{E53935}/agg {ffffff} �������������� ������ ���������� �� ������', '�������')
end

function sampev.onServerMessage(color, text)
	if text:find('�������: ') and text:find(' ���������� ') then
		if text:len() == 30 then
			temp = 14
			temp2 = 16
		elseif text:len() == 29 then
			temp = 14
			temp2 = 15
		elseif text:len() == 28 then
			temp = 14
			temp2 = 14
		end
		text = string.sub(text, temp, temp2)
		materials = text
		mainIni.config.materials = text
		if inicfg.save(mainIni, directIni) then end
	end
	if text:find('� ��� 500') and text:find('500 ���������� � �����')then
		materials = 500
		mainIni.config.materials = 500
		if inicfg.save(mainIni, directIni) then end
	end
	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick = sampGetPlayerNickname(id)
    if text:find('������') and text:find('����� � �������') then 
    	getguns = true
    	if agg then
   			gg:run()
   		end
    end
    if text:find('������') and text:find('����� � �������') then
    	getguns = false
    end
    if text:find(nick) and text:find('���� ������ �� ����������') and text:find('c�����') then
    	if getguns then
    		if agg then
    			gg:run()
    		end
    	end
    end
end

function cmd_agg()
	if agg then
		sampAddChatMessage('{E53935}[AutoGetGuns] {ffffff}��������.', -1)
		agg = false
	else
		sampAddChatMessage('{E53935}[AutoGetGuns] {ffffff}�������.', -1)
		agg = true
	end
	mainIni.config.agg = agg
	if inicfg.save(mainIni, directIni) then end
end

function sampev.onSendSpawn()
	if getguns then
		sampSendChat('/get guns')
	end
end

function thread_gg()
	wait(200)
	sampSendChat('/get guns')
end