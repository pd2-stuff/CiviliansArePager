local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if Network:is_client() then
	return
end

_G.CiviliansArePager = _G.CiviliansArePager or {}
CiviliansArePager.path = ModPath
CiviliansArePager.data_path = SavePath .. 'pagerarecivilians.txt'
CiviliansArePager.settings = {
	cops_in_disguise = 1,
}
CiviliansArePager.cops_in_disguise_chance = {0, 1}
CiviliansArePager.civilians_killed_by_player = {}
CiviliansArePager.civilians_to_avenge_nr = 0

function CiviliansArePager:load()
	local file = io.open(self.data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
end

function CiviliansArePager:save()
	local file = io.open(self.data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

CiviliansArePager:load()

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_CiviliansArePager', function(loc)
	local language_filename
	for _, filename in pairs(file.GetFiles(CiviliansArePager.path .. 'loc/')) do
		local str = filename:match('^(.*).txt$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			language_filename = filename
			break
		end
	end

	if language_filename then
		loc:load_localization_file(CiviliansArePager.path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(CiviliansArePager.path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_CiviliansArePager', function(menu_manager)
	MenuCallbackHandler.CiviliansArePager_set_cops_in_disguise = function(this, item)
		CiviliansArePager.settings.cops_in_disguise = item:value()
	end

	MenuCallbackHandler.CiviliansArePager_save = function(this, item)
		CiviliansArePager:save()
	end

	MenuHelper:LoadFromJsonFile(CiviliansArePager.path .. 'menu/options.txt', CiviliansArePager, CiviliansArePager.settings)
end)

function CiviliansArePager:on_civilian_killed(civilian_unit, peer)
	local steam_id = peer:user_id()
	local ck_nr = self.civilians_killed_by_player[steam_id] or 0
	self.civilians_killed_by_player[steam_id] = ck_nr + 1

	self.civilians_to_avenge_nr = self.civilians_to_avenge_nr + 1

end