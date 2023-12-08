script_name('+kill')
script_author('guccimane')
script_properties("work-in-pause")

require 'lib.sampfuncs'
require 'lib.moonloader'

local sampev = require 'lib.samp.events'


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if isSampLoaded() and isSampfuncsLoaded() then
		wait(0)
	end

	while true do
		wait(0)
	end
end

function sampev.onPlayerDeathNotification(killerId, killedId, reason)
	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if id == killedId then printStyledString('+kill', 3000, 2) end
end