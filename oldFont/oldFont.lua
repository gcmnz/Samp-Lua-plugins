script_name('oldFont')

require 'lib.moonloader'


local sampev = require 'lib.samp.events'


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if isSampLoaded() and isSampfuncsLoaded() then
		wait(1000)
	end

	while true do
		wait(0)
	end
end

function sampev.onShowTextDraw(id, data)
	if id == 2056 or id == 2059 then
        data.style = 0
        return {id, data}
    end
end