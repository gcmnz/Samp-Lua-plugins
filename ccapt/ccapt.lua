script_name('ccapt')
script_author('Guccimane')
script_properties("work-in-pause")

require 'lib.moonloader'

local sampev = require 'lib.samp.events'
local capt = false

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if isSampLoaded() and isSampfuncsLoaded() then
		wait(1000)
		sampAddChatMessage('ccapt loaded', -1)
	end

	sampRegisterChatCommand('ccapt', cmd_capt)
	capture = lua_thread.create_suspended(thread_capt)


	while true do
		wait(0)
	end
end

function cmd_capt(value)
	if capt then
		capt = false
		sampAddChatMessage('off', -1)
	else
		if value == '' or tonumber(value) < 100 or tonumber(value) > 1000 then
			sampAddChatMessage('/ccapt [100-1000]', -1)
			capt = false
		else
			sampAddChatMessage('on', -1)
			capt = true
			capture:run(value)
		end
	end
end

function thread_capt(value)
	while capt do
		sampSendChat('/capture')
		wait(tonumber(value))
	end
end