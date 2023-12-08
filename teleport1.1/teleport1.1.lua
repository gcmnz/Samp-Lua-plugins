script_name('TeleportForEvolve rp')
script_author('Guccimane')
script_description('work-in-pause')
script_version('1.1')

require 'lib.moonloader'

local sampev = require 'lib.samp.events'
local tp = false

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if isSampLoaded() and isSampfuncsLoaded() then
		wait(0)
		sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Загружен. Автор: Guccimane. Посмотреть все команды - /tphelp', -1)
	end

	sampRegisterChatCommand('tp', cmd_tp)
	sampRegisterChatCommand('tphelp', cmd_tphelp)


	teleport = lua_thread.create_suspended(thread_teleport)



	while true do
		wait(0)
		if isKeyJustPressed(VK_R) and isKeyJustPressed(VK_G) then
			x, y, z = getCharCoordinates(PLAYER_PED)
			setCharCoordinates(PLAYER_PED, x, y, z + 4)
		end
	end
end

function cmd_tphelp()
sampShowDialog(10, '{ffa0ad}[TeleportForEvolveRP] {ffffff}by Guccimane', '{ffa0ad}/tp - {ffffff}Телепорт на точку.\n{ffa0ad}Доступные точки: {ffffff}ballas, grove, vagos, rifa, aztec, og, drugs, aw, ab, paint, dnkbuy, metka.\n{ffa0ad}R+G - {ffffff}слап на случай, если всё-таки оказался под текстурами.', 'Закрыть')
end

function cmd_tp(value)
	if tp == false then
		if value == 'og' then
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Пиздуем на сходку дегенератов.', -1)
			ogx = 2058
			ogy = -1907
			ogz = 14
			tp = true
			teleport:run(ogx, ogy, ogz)
		elseif value == 'ballas' then
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Пиздуем к балларам.', -1)
			ogx = 2638
			ogy = -2000
			ogz = 14
			tp = true
			teleport:run(ogx, ogy, ogz)
		elseif value == 'grove' then
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Пиздуем на улицу рощи.', -1)
			ogx = 2472
			ogy = -1686
			ogz = 14
			tp = true
			teleport:run(ogx, ogy, ogz)
		elseif value == 'vagos' then
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Пиздуем к желторотикам.', -1)
			ogx = 2776
			ogy = -1603
			ogz = 11
			tp = true
			teleport:run(ogx, ogy, ogz)
			elseif value == 'rifa' then
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Пиздуем к усатым латиносам.', -1)
			ogx = 2167
			ogy = -1800
			ogz = 14
			tp = true
			teleport:run(ogx, ogy, ogz)
		elseif value == 'aztec' then
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Пиздуем к короносам.', -1)
			ogx = 1678
			ogy = -2121
			ogz = 14
			tp = true
			teleport:run(ogx, ogy, ogz)
		elseif value == 'drugs' then
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Пиздуем за героином.', -1)
			ogx = 2168
			ogy = -1684
			ogz = 16
			tp = true
			teleport:run(ogx, ogy, ogz)
		elseif value == 'aw' then
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Пиздуем в переход покупать права.', -1)
			ogx = -2030
			ogy = -94
			ogz = 37
			tp = true
			teleport:run(ogx, ogy, ogz)
		elseif value == 'ab' then
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Пиздуем автобазарить.', -1)
			ogx = 1940
			ogy = 737
			ogz = 11
			tp = true
			teleport:run(ogx, ogy, ogz)
		elseif value == 'dnkbuy' then
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Пиздуем за говном за колёсах.', -1)
			ogx = -1636
			ogy = 1203
			ogz = 8
			tp = true
			teleport:run(ogx, ogy, ogz)
		elseif value == 'paint' then
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Пиздуем унижать раков.',1)
			ogx = 1198
			ogy = -1756
			ogz = 14
			tp = true
			teleport:run(ogx, ogy, ogz)
		elseif value == 'metka' then
			res, x, y, z = getTargetBlipCoordinates()
			if res == false then
				sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Поставь метку.', -1)
			else
				sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Пиздуем на метку.', -1)
				tp = true
				teleport:run(x, y, z)
			end
		else
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}/tp (куда)', color2)
			sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Доступные точки: ballas, grove, vagos, rifa, aztec, og, drugs, aw, ab, paint, dnkbuy, metka.', -1)
		end
	else
		tp = false
		sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Античит говно.', -1)
	end
end


function thread_teleport(ogx, ogy, ogz)
	x, y, z = getCharCoordinates(PLAYER_PED)
	x = tonumber(x)
	y = tonumber(y)
	z = tonumber(z)
	ogx = tonumber(ogx)
	ogy = tonumber(ogy)
	ogz = tonumber(ogz)
	freezeCharPosition(PLAYER_PED, true)
	setCharCoordinates(PLAYER_PED, x, y, z - 10)
	wait(300)
	setCharCoordinates(PLAYER_PED, x, y, z - 20)
	wait(300)
	setCharCoordinates(PLAYER_PED, x, y, z - 30)
	wait(300)
	while true do
		if tp == true then
			if x == ogx and y == ogy then
				sampAddChatMessage('{ffa0ad}[TeleportForEvolveRP] {ffffff}Античит говно.', color3)
				freezeCharPosition(PLAYER_PED, false)
				tp = false
				break
			else
				freezeCharPosition(PLAYER_PED, true)
				if x > ogx then
					if x - ogx > 12 then
						x = x - 12
					else
						x = ogx
					end
				elseif x < ogx then
					if ogx - x > 12 then
						x = x + 12
					else
						x = ogx
					end
				end
				if y > ogy then
					if y - ogy > 12 then
						y = y - 12
					else
						y = ogy
					end
				elseif y < ogy then
					if ogy - y > 12 then
						y = y + 12
					else
						y = ogy
					end
				end
				setCharCoordinates(PLAYER_PED, x, y, z - 30)
				wait(300)
			end
		else
			break
		end
	end
	x, y, z = getCharCoordinates(PLAYER_PED)
	while true do
		if z ~= ogz then
			if ogz - z > 10 then
				z = z + 15
				setCharCoordinates(PLAYER_PED, x, y, z)
				wait(300)
			else
				setCharCoordinates(PLAYER_PED, x, y, ogz)
				break
			end
		end
	end
	freezeCharPosition(PLAYER_PED, false)
end