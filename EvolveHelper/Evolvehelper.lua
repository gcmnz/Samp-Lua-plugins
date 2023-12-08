script_name('EvolveHelper')
script_author('Guccimane')
script_description('work-in-pause')

require 'lib.moonloader'

local sampev = require 'lib.samp.events'
local ffi = require("ffi")
ffi.cdef[[
bool SetCursorPos(int X, int Y);
]]

local dialog = false
local color = 0x82e5a0
local flood = false

local inicfg = require 'inicfg'
local directIni = 'moonloader\\config\\EvolveHelper.ini'
local mainIni = inicfg.load(nil, directIni)
local kill = mainIni.config.kill
local delbat = mainIni.config.delbat
local status = mainIni.config.status

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if isSampLoaded() and isSampfuncsLoaded() then
		wait(1000)
		sampAddChatMessage('{82e5a0}[ERP helper] загружен. Автор: Guccimane. Команды - /erphelp', color)
	end

	
	sampRegisterChatCommand('fi', cmd_fi)
	sampRegisterChatCommand('fp', cmd_fp)
	sampRegisterChatCommand('fr', cmd_fr)
	sampRegisterChatCommand('fmb', cmd_fmb)
	sampRegisterChatCommand('resphelp', cmd_resphelp)
	sampRegisterChatCommand('re', cmd_re)
	sampRegisterChatCommand('dom', cmd_dom)
	sampRegisterChatCommand('dnk', cmd_dnk)
	sampRegisterChatCommand('fam', cmd_fam)
	sampRegisterChatCommand('delbat', cmd_delbat)
	sampRegisterChatCommand('+kill', cmd_kill)
	sampRegisterChatCommand('binder', cmd_ehelp)
	sampRegisterChatCommand('erphelp', cmd_erphelp)

	sampRegisterChatCommand('fuckreport', cmd_fuckreport)
	fucking = lua_thread.create_suspended(thread_fucking)

	re = lua_thread.create_suspended(thread_cmd_re)
	dom = lua_thread.create_suspended(thread_cmd_dom)
	dnk = lua_thread.create_suspended(thread_cmd_dnk)
	fam = lua_thread.create_suspended(thread_cmd_fam)


	sampRegisterChatCommand('flood', cmd_flood)
	flooding = lua_thread.create_suspended(thread_flood)

	cm = lua_thread.create_suspended(thread_cm)

	while true do
		wait(0)
		local bat = hasCharGotWeapon(PLAYER_PED, 5)
		if delbat then
			if bat then
				removeWeaponFromChar(PLAYER_PED, 5)
			end
		end
		if not sampIsCursorActive() and status then
			if isKeyJustPressed(VK_Z) then
				sampSendChat('/fixcar')
			elseif isKeyJustPressed(VK_L) or isKeyJustPressed(VK_XBUTTON1) then
				sampSendChat('/lock')
			elseif isKeyJustPressed(VK_Y) then
				sampSendChat('/changemap')
			elseif isKeyJustPressed(VK_N) then
				sampSendChat('/inv')
			elseif isKeyJustPressed(VK_B) then
				fastmask()
			elseif isKeyJustPressed(VK_H) then
				sampSendChat('/healme')
			end
		end
	end
end

function cmd_erphelp()
	sampShowDialog(10, '{82e5a0}[EvolveHelper] {82e5a0}Основные команды:', '{82e5a0}/binder\t\t{ffffff}Вкл/Выкл бинды\n{82e5a0}/+kill\t\t{ffffff}+kill на экране после фрага\n{82e5a0}/resphelp\t{ffffff}Информайия о быстрой смене спавна\n{82e5a0}/flood\t\t{ffffff}Флудер\n{82e5a0}/delbat\t\t{ffffff}Удаление биты\n\n{82e500}HotKeys:\n{82e5a0}L & MXB{ffffff}\t/lock\n{82e5a0}Y{ffffff}\t\t/changemap\n{82e5a0}Z{ffffff}\t\t/fixcar\n{82e5a0}B{ffffff}\t\tfastMask (маску на 1 слот)\n{82e5a0}H{ffffff}\t\t/healme', 'Вкурил', 'Не вкурил', 0)
end

function cmd_fuckreport()
	if fuck then
		fuck = false
		sampAddChatMessage('stopfucking', color)
	else
		fuck = true
		fucking:run()
	end
end

function thread_fucking()
	while fuck do
		sampSendChat('/report 1 aimbot')
		wait(121000)
	end
end

function cmd_ehelp()
	if status then
		sampAddChatMessage('Бинды выключены!', -1)
		status = false
	else
		sampAddChatMessage('Бинды включены!', -1)
		status = true
	end
	mainIni.config.status = status
	if inicfg.save(mainIni, directIni) then return end
end


function sampev.onPlayerDeathNotification(killerId, killedId, reason)
	if kill then
		_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if id == killerId then printStyledString('+kill', 1000, 2) end
	end
end

function cmd_kill()
	if kill then
		kill = false
		sampAddChatMessage('+kill выключен!', -1)
	else
		sampAddChatMessage('+kill включен!', -1)
		kill = true
	end
	mainIni.config.kill = kill
	if inicfg.save(mainIni, directIni) then return end
end

function cmd_delbat()
	if delbat == false then
		delbat = true
		sampAddChatMessage('Биту удаляем', -1)
	else
		delbat = false
		sampAddChatMessage('Биту возвращаем', -1)
	end
	mainIni.config.delbat = delbat
	if inicfg.save(mainIni, directIni) then return end
end

function cmd_resphelp()
	sampAddChatMessage('/re - Спавн на респу', color)
	sampAddChatMessage('/dom - Спавн в доме', color)
	sampAddChatMessage('/dnk - Спавн в днк', color)
	sampAddChatMessage('/fam - Спавн в доме фамы', color)
end

function cmd_re()
	sampSendChat('/spawnchange')
	re:run()
end

function cmd_dom()
	sampSendChat('/spawnchange')
	dom:run()
end

function cmd_dnk()
	sampSendChat('/spawnchange')
	dnk:run()
end

function cmd_fam()
	sampSendChat('/spawnchange')
	fam:run()
end

function thread_cmd_re()
	result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    ping = sampGetPlayerPing(id)
	sampSendDialogResponse(1701, 1, 0, '')
	wait(ping*2)
	sampCloseCurrentDialogWithButton(1)
end

function thread_cmd_dom()
	result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    ping = sampGetPlayerPing(id)
	sampSendDialogResponse(1701, 1, 1, '')
	wait(ping*2)
	sampCloseCurrentDialogWithButton(1)
end

function thread_cmd_dnk()
	result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    ping = sampGetPlayerPing(id)
	sampSendDialogResponse(1701, 1, 2, '')
	wait(ping*2)
	sampCloseCurrentDialogWithButton(1)
end

function thread_cmd_fam()
	result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    ping = sampGetPlayerPing(id)
	sampSendDialogResponse(1701, 1, 4, '')
	wait(ping*2)
	sampCloseCurrentDialogWithButton(1)
end

function fastmask()
	sampSendChat('/items')
	result, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    ping = sampGetPlayerPing(id)
	wait(ping)
	sampSendClickTextdraw(2167)
	sampSendDialogResponse(24700, 1, 1, '')
	sampSendClickTextdraw(90)
	wait(ping*3)
	sampCloseCurrentDialogWithButton(1)
	wait(800)
	sampSendChat('/mask')
end

function cmd_flood(value)
	if value == '' then
		sampAddChatMessage('/flood [text]', color)
	else
		if flood then
			sampAddChatMessage('off', color)
			flood = false
		else
			sampAddChatMessage('on', color)
			flood = true
			flooding:run(value)
		end
	end
end

function thread_flood(value)
	while flood do
		sampSendChat(value)
		wait(tonumber(400))
	end
end

function cmd_fp()
	sampSendChat('/fpanel')
end

function cmd_fi(id)
	sampSendChat('/finvite ' .. id)
end

function cmd_fr(value)
	id, rank = string.match(value, '(.+) (.+)')
	if id == '' or id == nil then
		sampAddChatMessage('/fr [id] [rank]', color)
	else
		sampSendChat('/fgiverank ' .. id .. ' ' .. rank)
	end
end

function cmd_fmb()
	sampSendChat('/fmembers')
end