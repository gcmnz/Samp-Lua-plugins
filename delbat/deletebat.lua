script_name('UselessBatDelete')
script_author('Guccimane')

require 'lib.moonloader'

local sampev = require 'lib.samp.events'

local inicfg = require 'inicfg'
local directIni = 'moonloader\\config\\delbat.ini'
local mainIni = inicfg.load(nil, directIni)

local delbat = mainIni.config.delbat

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if isSampLoaded() and isSampfuncsLoaded() then
		wait(0)
	end

	sampRegisterChatCommand('delbat', cmd_delbat)

	while true do
		wait(0)
		local bat = hasCharGotWeapon(PLAYER_PED, 5)
		if delbat then
			if bat then
				removeWeaponFromChar(PLAYER_PED, 5)
			end
		end
	end
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