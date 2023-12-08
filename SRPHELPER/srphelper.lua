script_name('SRPHelper')
script_author('Stressout. thx4help Guccimane')
script_description('/srphelp')
script_version('1.0')

require 'lib.moonloader'

local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local directIni = 'moonloader\\config\\srphelper.ini'
local mainIni = inicfg.load(nil, directIni)
local aza = mainIni.config.aza
local craftammo = mainIni.config.craftammo
local minammo = mainIni.config.minammo
local patron = '������'
local materials = mainIni.config.materials
local fcad = mainIni.config.fcad
local easygang = mainIni.config.easygang
local esafe = mainIni.config.esafe

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end

	if isSampLoaded() and isSampfuncsLoaded() then
		wait(0)
		sampAddChatMessage('{6986bf}[SRPHelper]: {FFFFFF}��������. ���������� ��� ������� � {6986bf}/srphelp', 0x6986bf)
	end

	sampRegisterChatCommand('srphelp', cmd_srphelp)
	sampRegisterChatCommand('easygang', cmd_easygang)
	sampRegisterChatCommand('eginfo', cmd_eginfo)
	sampRegisterChatCommand('de', cmd_de)
	sampRegisterChatCommand('sd', cmd_sd)
	sampRegisterChatCommand('ri', cmd_ri)
	sampRegisterChatCommand('sh', cmd_sh)
	sampRegisterChatCommand('smg', cmd_smg)
	sampRegisterChatCommand('ak', cmd_ak)
	sampRegisterChatCommand('m4', cmd_m4)
	sampRegisterChatCommand('gg', cmd_gg)
	sampRegisterChatCommand('gd', cmd_gd)
	sampRegisterChatCommand('us', cmd_us)
	sampRegisterChatCommand('iv', cmd_iv)
	sampRegisterChatCommand('uv', cmd_uv)
	sampRegisterChatCommand('gr', cmd_gr)
	sampRegisterChatCommand('sk', cmd_sk)
	sampRegisterChatCommand('sln', cmd_sln)
	sampRegisterChatCommand('sld', cmd_sld)
	sampRegisterChatCommand('fc', cmd_fc)
	sampRegisterChatCommand('ffc', cmd_ffc)
	sampRegisterChatCommand('mg', cmd_mg)
	sampRegisterChatCommand('mp', cmd_mp)
	sampRegisterChatCommand('hl', cmd_hl)
	sampRegisterChatCommand('un', cmd_un)
	sampRegisterChatCommand('wa', cmd_wa)
	sampRegisterChatCommand('mb', cmd_mb)
	sampRegisterChatCommand('sp', cmd_sp)
	sampRegisterChatCommand('sw', cmd_sw)
	sampRegisterChatCommand('wl', cmd_wl)
	sampRegisterChatCommand('rh', cmd_rh)
	sampRegisterChatCommand('cl', cmd_cl)
	sampRegisterChatCommand('fcad', cmd_fcad)
	sampRegisterChatCommand('esafe', cmd_esafe)

	sampRegisterChatCommand('tma', cmd_tma)
	thr_tma = lua_thread.create_suspended(thread_tma)

	sampRegisterChatCommand('tde', cmd_tde)
	thr_tde = lua_thread.create_suspended(thread_tde)

	sampRegisterChatCommand('tdr', cmd_tdr)
	thr_tdr = lua_thread.create_suspended(thread_tdr)

	sampRegisterChatCommand('pma', cmd_pma)
	thr_pma = lua_thread.create_suspended(thread_pma)

	sampRegisterChatCommand('pde', cmd_pde)
	thr_pde = lua_thread.create_suspended(thread_pde)

	sampRegisterChatCommand('pdr', cmd_pdr)
	thr_pdr = lua_thread.create_suspended(thread_pdr)

	sampRegisterChatCommand('aza', cmd_aza)
	sampRegisterChatCommand('ca', cmd_craftammo)
	sampRegisterChatCommand('ma', cmd_minammo)

	while true do
		wait(0)
		if getAmmoInCharWeapon(PLAYER_PED, 24) == tonumber(minammo) then
			craft()
			wait(1000)
		end
		wait(0)
		if fcad then
        	if isCharDead(PLAYER_PED) and not dead then
           		sampSendChat('/fixcar')
           		sampAddChatMessage('{6986bf}[FixCarAfterDeath]: {FFFFFF}������ ��������� �����������!')
            	dead = true 
        	elseif not isCharDead(PLAYER_PED) and dead then
            	dead = false
            end
        end
	end
end

function cmd_fcad()
	if fcad then
		sampAddChatMessage('{6986bf}[FixCarAfterDeath]: {FFFFFF}��������!', 0x6986bf)
		fcad = false
	else
		fcad = true
		sampAddChatMessage('{6986bf}[FixCarAfterDeath]: {FFFFFF}�������!', 0x6986bf)
	end
	mainIni.config.fcad = fcad
	if inicfg.save(mainIni, directIni) then end
end

function cmd_aza()
	if aza then
		sampAddChatMessage('{6986bf}[AntiZeroAmmo]: {ffffff}��������!', 0x6986bf)
		aza = false
	else
		aza = true
		sampAddChatMessage('{6986bf}[AntiZeroAmmo]: {ffffff}�������!', 0x6986bf)
	end
	mainIni.config.aza = aza
	if inicfg.save(mainIni, directIni) then end
end

function cmd_craftammo(value)
	if aza then
		if value == '' or tonumber(value) < 1 or tonumber(value) > 100 then
			sampAddChatMessage('{6986bf}[AntiZeroAmmo]: {ffffff}/ca [1-100]', 0x6986bf)
		else
			craftammo = tonumber(value)
			if craftammo == 1 then
				patron = '������!'
			elseif craftammo > 1 and craftammo < 5 then
				patron = '�������!'
			else
				patron = '��������!'
			end
			mainIni.config.craftammo = value
			if inicfg.save(mainIni, directIni) then end
			sampAddChatMessage('{6986bf}[AntiZeroAmmo]: {ffffff}��� ' .. minammo .. '{ffffff} �� ������� '.. value .. '{ffffff} ' .. patron, 0x6986bf)
		end
	else
		sampAddChatMessage('{6986bf}[AntiZeroAmmo]: {ffffff}�������� ������!', 0x6986bf)
	end
end

function cmd_minammo(value)
	if aza then
		if value == '' or tonumber(value) < 1 or tonumber(value) > 100 then
			sampAddChatMessage('{6986bf}[AntiZeroAmmo]: {ffffff}/ma [1-100]', 0x6986bf)
		else
			minammo = value
			mainIni.config.minammo = value
			if inicfg.save(mainIni, directIni) then end
			sampAddChatMessage('{6986bf}[AntiZeroAmmo]: {ffffff}��� {ffffff}' .. minammo .. '{ffffff} �� ������� {ffffff}'.. craftammo .. '{ffffff} ' .. patron, 0x6986bf)
		end
	else
		sampAddChatMessage('{6986bf}[AntiZeroAmmo]: {ffffff}�������� ������!', 0x6986bf)
	end
end

function craft()
	if aza then
		if tonumber(materials) > tonumber(craftammo)*3 then
			sampSendChat('/gun deagle ' .. tostring(craftammo))
		else
			sampAddChatMessage('{6986bf}[AntiZeroAmmo]: {ffffff}������������ ����������!', 0x6986bf)
			wait(5000)
		end
	end
end

function cmd_eginfo()
	sampShowDialog(10, '{6986bf}EasyGang', '{6986bf}����������� �������: {FFFFFF}(SRPHelper)\n\n{6986bf}/easygang {FFFFFF}� ��������/��������� ����������� �������\n{6986bf}/de {FFFFFF}� ���������� �������� ��� �������� Desert Eagle\n{6986bf}/sd {FFFFFF}� ���������� �������� ��� �������� Silenced Pistol\n{6986bf}/ri {FFFFFF}� ���������� �������� ��� �������� Rifle\n{6986bf}/sh {FFFFFF}� ���������� �������� ��� �������� Shotgun\n{6986bf}/smg {FFFFFF}� ���������� �������� ��� �������� SMG\n{6986bf}/ak {FFFFFF}� ���������� �������� ��� �������� AK47\n{6986bf}/m4 {FFFFFF}� ���������� �������� ��� �������� M4\n{6986bf}/gg {FFFFFF}� ���������� ���������� ��� ������ �� ������\n{6986bf}/gd {FFFFFF}� ���������� ���������� ��� ������� � �������\n{6986bf}/us {FFFFFF}� ���������� ���������� ��� ������������\n{6986bf}/iv {FFFFFF}� [ID ������] � ������� ������ � �����\n{6986bf}/uv {FFFFFF}� [ID ������] [�������] {FFFFFF}� ������� ������ � �����\n{6986bf}/gr {FFFFFF}� [ID ������] [RANG] � ������ ���� ������\n{6986bf}/sk {FFFFFF}� [ID ������] [����] � ������� ���� �� ������ ������\n{6986bf}/sln {FFFFFF}� [ID ������] [���������� ����������] [����] {FFFFFF}� ������� ��������� ������\n{6986bf}/sld {FFFFFF}�[���������� ������] [����] [ID] ������� Desert Eagle ������\n{6986bf}/ffc {FFFFFF}� [�����] � ������������ ��������� �����������\n{6986bf}/fc {FFFFFF}� ������������ ������ ������������ ��������\n{6986bf}/mg {FFFFFF}� ����� ���� � ����������� (LVA, SFA)\n{6986bf}/mp {FFFFFF}� �������� ���� � ����������� � ������\n{6986bf}/hl {FFFFFF}� ������������ ������� � ���� ��� �� ����\n{6986bf}/un {FFFFFF}� ���������� ������ � ����������� �� ����� �����\n{6986bf}/wa {FFFFFF}� ��������� ���������� ���������� �� ������\n{6986bf}/mb {FFFFFF}� ��������� ���������� ������� ������ �� �������\n{6986bf}/sp {FFFFFF}� ������� ����� ������\n{6986bf}/sw {FFFFFF}� ������ ������� �����\n{6986bf}/wl {FFFFFF}� �������/������� �����\n{6986bf}/rh {FFFFFF}� �������� ���������� ����\n{6986bf}/esc {FFFFFF}� ����� �� ������ � ������� �����\n{6986bf}/tpn {FFFFFF}� ��������/��������� �������\n{6986bf}/cl {FFFFFF}� ��������� �����', '�������')
end

function cmd_srphelp()
	sampShowDialog(10, '{6986bf}SRPHelper', '{6986bf}����������� �������: {FFFFFF}(EasyGang)\n\n{6986bf}/eginfo {FFFFFF}� ���������� ������ ����������� ������\n\n{6986bf}������� ����� ������: {FFFFFF}(FixCarAfterDeath)\n\n{6986bf}/fcad {FFFFFF}� ��������/��������� ������� ����� ������\n\n{6986bf}�������������� � ������: {FFFFFF}(EasySafe)\n\n{6986bf}/esafe {FFFFFF}� ��������/��������� �������������� � ������\n{6986bf}/tma {FFFFFF}� ����� ��������� � �����\n{6986bf}/tdr {FFFFFF}� ����� ��������� � �����\n{6986bf}/tde {FFFFFF}� ����� Desert Eagle � �����\n{6986bf}/pma {FFFFFF}� �������� ��������� � ����\n{6986bf}/pdr {FFFFFF}� �������� ��������� � ����\n{6986bf}/pde {FFFFFF}� �������� Desert Eaagle � ����\n\n{6986bf}AntiZeroAmmo: {ffffff}(by Guccimane)\n\n{6986bf}/aza {ffffff}� ���������/���������� �������\n{6986bf}/ma {ffffff}� ����������� ���������� ��������\n{6986bf}/ca {ffffff}� ���������� ������ ��� ������', '�������')
end

function cmd_easygang()
	if easygang then
		sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}��������!', 0x6986bf)
		easygang = false
	else
		easygang = true
		sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}�������!', 0x6986bf)
	end
	mainIni.config.easygang = easygang
	if inicfg.save(mainIni, directIni) then end
end

function cmd_fcad()
	if fcad then
		sampAddChatMessage('{6986bf}[FixCarAfterDeath]: {FFFFFF}��������!', 0x6986bf)
		fcad = false
	else
		fcad = true
		sampAddChatMessage('{6986bf}[FixCarAfterDeath]: {FFFFFF}�������!', 0x6986bf)
	end
	mainIni.config.fcad = fcad
	if inicfg.save(mainIni, directIni) then end
end

function cmd_esafe()
	if esafe then
		sampAddChatMessage('{6986bf}[EasySafe]: {FFFFFF}��������!', 0x6986bf)
		esafe = false
	else
		esafe = true
		sampAddChatMessage('{6986bf}[EasySafe]: {FFFFFF}�������!', 0x6986bf)
	end
	mainIni.config.esafe = esafe
	if inicfg.save(mainIni, directIni) then end
end

function cmd_de(ammo)
	if easygang then
		_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if ammo == "" then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ���������� �������� ��� ������ Desert Eagle!', 0x6986bf)
		else
			sampSendChat('/sellgun deagle ' .. ammo .. ' 4 ' .. id )
		end
	end
end

function cmd_sd(ammo)
	if easygang then
		_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if ammo == '' then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ���������� �������� ��� ������ Silenced Pistol!', 0x6986bf)
		else
			sampSendChat('/sellgun sdpistol ' .. ammo .. ' 4 ' .. id)
		end
	end
end

function cmd_ri(ammo)
	if easygang then
		_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if ammo == '' then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ���������� �������� ��� ������ Rifle!', 0x6986bf)
		else
			sampSendChat('/sellgun rifle ' .. ammo .. ' 4 ' .. id)
		end
	end
end

function cmd_sh(ammo)
	if easygang then
		_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if ammo == '' then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ���������� �������� ��� ������ Shotgun!', 0x6986bf)
		else
			sampSendChat('/sellgun shotgun ' .. ammo .. ' 4 ' .. id)
		end
	end
end

function cmd_smg(ammo)
	if easygang then
		_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if ammo == '' then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ���������� �������� ��� ������ SMG!', 0x6986bf)
		else
			sampSendChat('/sellgun smg ' .. ammo .. ' 4 ' .. id)
		end
	end
end

function cmd_ak(ammo)
	if easygang then
		_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if ammo == '' then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ���������� �������� ��� ������ AK47!', 0x6986bf)
		else
			sampSendChat('/sellgun ak47 ' .. ammo .. ' 4 ' .. id)
		end
	end
end

function cmd_m4(ammo)
	if easygang then
		_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if ammo == '' then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ���������� �������� ��� ������ M4!', 0x6986bf)
		else
			sampSendChat('/sellgun m4 ' .. ammo .. ' 4 ' .. id)
		end
	end
end

function cmd_gg(materials)
	if easygang then
		if materials == '' then
		sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ���������� ����������, ������� ������ ����� �� ������!', 0x6986bf)
		else
			sampSendChat('/get guns ' .. materials)
		end
	end
end

function cmd_gd(drugs)
	if easygang then
		if drugs == '' then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF} ������� ���������� ����������, ������� ������ ������ � �������!', 0x6986bf)
		else
			sampSendChat('/get drugs ' .. drugs)
		end
	end
end

function cmd_us(drugs)
	if easygang then
		if drugs == '' then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ���������� ����������, ������� ������ ����������!', 0x6986bf)
		else
			sampSendChat('/usedrugs ' .. drugs)
		end
	end
end

function cmd_iv(id)
	if easygang then
		if id == '' then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ID!', 0x6986bf)
		else
			sampSendChat('/invite ' .. id)
		end
	end
end

function cmd_uv(arg)
	if easygang then
		id_ped, reason = string.match(arg, '(.+) (.+)')
		if id_ped == '' or id_ped == nil then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ID � �������!', 0x6986bf)
		else
			sampSendChat('/uninvite ' .. id_ped .. ' ' .. reason)
		end
	end
end

function cmd_gr(arg)
	if easygang then
		id_ped, rank = string.match(arg, "(.+) (.+)")
		if id_ped == '' or id_ped == nil then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ID � ����!', 0x6986bf)
		else
			sampSendChat('/giverank ' .. id_ped .. ' ' .. rank)
		end
	end
end

function cmd_cl()
	if easygang then
		sampSendChat('/clist 0')
	end
end

function cmd_mg()
	if easygang then
		sampSendChat('/materials get')
	end
end

function cmd_mp()
	if easygang then
		sampSendChat('/materials put')
	end
end

function cmd_hl()
	if easygang then
		sampSendChat('/healme')
	end
end

function cmd_un()
	if easygang then
		sampSendChat('/unloading')
	end
end

function cmd_wa()
	if easygang then
		sampSendChat('/warehouse')
	end
end

function cmd_mb()
	if easygang then
		sampSendChat('/members')
	end
end

function cmd_sp()
	if easygang then
		sampSendChat('/spawnchange')
	end
end

function cmd_sw()
	if easygang then
		sampSendChat('/switchskin')
	end
end

function cmd_wl()
	if easygang then
		sampSendChat('/warelock')
	end
end

function cmd_rh()
	if easygang then
		sampSendChat('/robhouse')
	end
end

function cmd_fc()
	if easygang then
		sampSendChat('/fixcar')
	end
end

function cmd_ffc(arg)
	if easygang then
		if arg == '' then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� �����(�������) �����, ������� ����� ����������� ��������� �����������!', 0x6986bf)
		else
			sampSendChat('/ffixcar ' .. arg)
		end
	end
end

function cmd_sln(arg)
	if easygang then
		id, amount, price = string.match(arg, '(.+) (.+) (.+)')
		if id == '' or id == nil then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ID, ���������� � ����!', 0x6986bf)
		else
			sampSendChat('/selldrugs ' .. id .. ' ' .. amount .. ' ' .. price)
		end
	end
end

function cmd_sld(arg)
	if easygang then
		amount, price, id = string.match(arg, '(.+) (.+) (.+)')
		if amout == '' or amount == nil then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ���������� ������, ���� � ID!', 0x6986bf)
		else
			sampSendChat('/sellgun deagle ' .. amount .. ' ' .. price .. ' ' .. id)
		end
	end
end

function cmd_esc()
	if easygang then
		sampSendChat('/escape')
	end
end

function cmd_sk(arg)
	if easygang then
		id, price = string.match(arg, '(.+) (.+)')
		if id == '' or id == nil then
			sampAddChatMessage('{6986bf}[EasyGang]: {FFFFFF}������� ID � ����!', 0x6986bf)
		else
			sampSendChat('/sellekey ' .. id .. ' ' .. price)
		end
	end
end

function cmd_tma(arg)
	if esafe then
		if arg == '' or tonumber(arg) < 1 or tonumber(arg) > 500 then
			sampAddChatMessage('{6986bf}[EasySafe]: {FFFFFF}������� ���������� ����������, ������� ������ ����� �����!', 0x6986bf1)
		else
			thr_tma:run(arg)
		end
	end
end

function thread_tma(arg)
	sampSendChat('/safe')
	sampSendDialogResponse(217, 1, 0, nil)
	sampSendDialogResponse(218, 1, 0, nil)
	sampSendDialogResponse(219, 1, nil, arg)
	wait(200)
	sampCloseCurrentDialogWithButton(0)
	wait(200)
	sampCloseCurrentDialogWithButton(0)
end

function cmd_tde(arg)
	if esafe then
		if arg == '' or tonumber(arg) < 1 or tonumber(arg) > 500 then
			sampAddChatMessage('{6986bf}[EasySafe]: {FFFFFF}������� ���������� ������ Desert Eagle, ������� ������ ����� � �����!', 0x6986bf1)
		else
			thr_tde:run(arg)
		end
	end
end

function thread_tde(arg)
	sampSendChat('/safe')
	sampSendDialogResponse(217, 1, 0, nil)
	sampSendDialogResponse(218, 1, 5, nil)
	sampSendDialogResponse(219, 1, nil, arg)
	wait(200)
	sampCloseCurrentDialogWithButton(0)
	wait(200)
	sampCloseCurrentDialogWithButton(0)
end

function cmd_tdr(arg)
	if esafe then
		if arg == '' or tonumber(arg) < 1 or tonumber(arg) > 150 then
			sampAddChatMessage('{6986bf}[EasySafe]: {FFFFFF}������� ���������� ����������, ������� ������ ����� � �����!', 0x6986bf1)
		else
			thr_tdr:run(arg)
		end
	end
end

function thread_tdr(arg)
	sampSendChat('/safe')
	sampSendDialogResponse(217, 1, 0, nil)
	sampSendDialogResponse(218, 1, 1, nil)
	sampSendDialogResponse(219, 1, nil, arg)
	wait(200)
	sampCloseCurrentDialogWithButton(0)
	wait(200)
	sampCloseCurrentDialogWithButton(0)
end

function cmd_pma(arg)
	if esafe then
		if arg == '' or tonumber(arg) < 1 or tonumber(arg) > 500 then
			sampAddChatMessage('{6986bf}[EasySafe]: {FFFFFF}������� ���������� ����������, ������� ������ �������� � ����!', 0x6986bf1)
		else
			thr_pma:run(arg)
		end
	end
end

function thread_pma(arg)
	sampSendChat('/safe')
	sampSendDialogResponse(217, 1, 1, nil)
	sampSendDialogResponse(218, 1, 0, nil)
	sampSendDialogResponse(219, 1, nil, arg)
	wait(200)
	sampCloseCurrentDialogWithButton(0)
	wait(200)
	sampCloseCurrentDialogWithButton(0)
end


function cmd_pde(arg)
	if esafe then
		if arg == '' or tonumber(arg) < 1 or tonumber(arg) > 450 then
			sampAddChatMessage('{6986bf}[EasySafe]: {FFFFFF}������� ���������� �������� Desert Eagle, ������� ������ �������� � ����!', 0x6986bf1)
		else
			thr_pde:run(arg)
		end
	end
end

function thread_pde(arg)
	sampSendChat('/safe')
	sampSendDialogResponse(217, 1, 1, nil)
	sampSendDialogResponse(218, 1, 5, nil)
	sampSendDialogResponse(219, 1, nil, arg)
	wait(200)
	sampCloseCurrentDialogWithButton(0)
	wait(200)
	sampCloseCurrentDialogWithButton(0)
end

function cmd_pdr(arg)
	if esafe then
		if arg == '' or tonumber(arg) < 1 or tonumber(arg) > 150 then
			sampAddChatMessage('{6986bf}[EasySafe]: {FFFFFF}������� ���������� ����������, ������� ������ �������� � ����!', 0x6986bf1)
		else
			thr_pdr:run(arg)
		end
	end
end

function thread_pdr(arg)
	sampSendChat('/safe')
	sampSendDialogResponse(217, 1, 1, nil)
	sampSendDialogResponse(218, 1, 1, nil)
	sampSendDialogResponse(219, 1, nil, arg)
	wait(200)
	sampCloseCurrentDialogWithButton(0)
	wait(200)
	sampCloseCurrentDialogWithButton(0)
end

function sampev.onServerMessage(color, text)
	if text:find('{6AB1FF}�������������� � �����') and color == -1 then
		_,id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		nick = sampGetPlayerNickname(id)
		if text:find(nick) then
			sampAddChatMessage('{6986bf}[FixCarAfterDeath]: {FFFFFF}��������!', 0x6986bf)
			fcad = false
			mainIni.config.fcad = fcad
			if inicfg.save(mainIni, directIni) then return end
		end
	end
	if text:find('{6AB1FF}�������� �����') and color == -1 then
		_,id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		nick = sampGetPlayerNickname(id)
		if text:find(nick) then
			sampAddChatMessage('{6986bf}[FixCarAfterDeath]: {FFFFFF}�������!', 0x6986bf)
			fcad = true
			mainIni.config.fcad = fcad
			if inicfg.save(mainIni, directIni) then return end
		end
	end
end


