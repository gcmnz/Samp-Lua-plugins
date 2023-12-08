script_name('Speedbike')
script_author('Guccimane')
script_properties("work-in-pause")

require 'lib.moonloader'

local sampev = require 'lib.samp.events'

local idcars = {
	[461] = 'bike',
	[463] = 'bike',
	[462] = 'bike',
	[468] = 'bike',
	[522] = 'bike',
	[521] = 'bike',
	[581] = 'bike'
}

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if isSampLoaded() and isSampfuncsLoaded() then
		wait(1000)
	end

	go = lua_thread.create_suspended(thread_go)

	while true do
		wait(0)
		if not sampIsCursorActive() and isCharInAnyCar(PLAYER_PED) then
			carhandle = storeCarCharIsInNoSave(PLAYER_PED)
			idcar = getCarModel(carhandle)
			if idcars[idcar] == 'bike' then
				if isKeyDown(VK_W) then
					setVirtualKeyDown(VK_SHIFT, true)
					wait(20)
					setVirtualKeyDown(VK_SHIFT, false)
					wait(30)
				end
			end
		end
	end
end