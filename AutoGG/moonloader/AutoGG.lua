script_name('AutoGetGuns')
script_author('Guccimane')
script_description('work-in-pause')

require 'lib.moonloader'

local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'

local directIni = 'moonloader\\config\\AutoGetGuns.ini'
local mainIni = inicfg.load(nil, directIni)

local materials = mainIni.config.materials
local warehouse = false
local status = mainIni.config.status
local color = 0x12b6ff

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if isSampLoaded() and isSampfuncsLoaded() then
		wait(1000)
		sampAddChatMessage('[AutoGetGuns] Загружен. Автор: Guccimane. Используй /agg', color)
	end

	sampRegisterChatCommand('agg', cmd_agg)

	getguns = lua_thread.create_suspended(thread_getguns)

	while true do
		wait(0)
	end
end

function cmd_agg()
	if status then
		status = false
		sampAddChatMessage('[AutoGetGuns] Выключен!', color)
	else
		status = true
		sampAddChatMessage('[AutoGetGuns] Включён!', color)
	end
	mainIni.config.status = status
	if inicfg.save(mainIni, directIni) then return end
end

function sampev.onServerMessage(color, text)
	if color == -86 and text:find(' материалов с собой') and text:find('У вас') then
		materials = text:sub(8)
		if materials:len() == 24 then
			temp = 1
		elseif materials:len() == 25 then
			temp = 2
		elseif materials:len() == 26 then
			temp = 3
		end
		materials = materials:sub(1, temp)
		mainIni.config.materials = materials:sub(1, temp)
		if inicfg.save(mainIni, directIni) then return end
	end
	if color == -1029514582 and text:find('Осталось материалов:') then
		materials  = string.sub(text, 23)
		mainIni.config.materials = string.sub(text, 23)
		if inicfg.save(mainIni, directIni) then return end
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
		mainIni.config.materials = materials
		if inicfg.save(mainIni, directIni) then return end
	end
end

function thread_getguns(value, waiting)
	wait(tonumber(waiting))
	sampSendChat('/get guns ' .. 500 - materials)
end

function sampev.onSendSpawn()
	if warehouse and status then
		getguns:run(materials, 200)
	end
end