local addonName, ns = ...

-- Lua
local _G = getfenv(0)
local assert = _G.assert
local geterrorhandler = _G.geterrorhandler
local hooksecurefunc = _G.hooksecurefunc
local next = _G.next
local pairs = _G.pairs
local s_format = _G.string.format
local s_split = _G.string.split
local select = _G.select
local t_insert = _G.table.insert
local type = _G.type
local xpcall = _G.xpcall

-- Mine
local E, C, D, M, L, P = {}, {}, {}, {}, {}, {} -- engine, config, defaults, media, locales, private
ns.E, ns.C, ns.D, ns.M, ns.L, ns.P = E, C, D, M, L, P

_G[addonName] = {
	[1] = ns.E,
	[2] = ns.M,
	[3] = ns.C,
	[4] = ns.L
}

------------
-- EVENTS --
------------

do
	local oneTimeEvents = {ADDON_LOADED = false, PLAYER_LOGIN = false}
	local registeredEvents = {}

	local dispatcher = CreateFrame("Frame", "LSEventFrame")
	dispatcher:SetScript("OnEvent", function(_, event, ...)
		for func in pairs(registeredEvents[event]) do
			func(...)
		end

		if oneTimeEvents[event] == false then
			oneTimeEvents[event] = true
		end
	end)

	function E:RegisterEvent(event, func)
		assert(not oneTimeEvents[event], s_format("Failed to register for '%s' event, already fired!", event))

		if not registeredEvents[event] then
			registeredEvents[event] = {}

			dispatcher:RegisterEvent(event)
		end

		registeredEvents[event][func] = true
	end

	function E:UnregisterEvent(event, func)
		local funcs = registeredEvents[event]

		if funcs and funcs[func] then
			funcs[func] = nil

			if not next(funcs) then
				registeredEvents[event] = nil

				dispatcher:UnregisterEvent(event)
			end
		end
	end
end

------------
-- MIXINS --
------------

do
	function P:Mixin(obj, ...)
		for i = 1, select("#", ...) do
			local mixin = select(i, ...)
			for k, v in next, mixin do
				obj[k] = v
			end
		end

		return obj
	end
end

------------
-- ERRORS --
------------

do
	local function errorHandler(err)
		return geterrorhandler()(err)
	end

	function P:Call(func, ...)
		return xpcall(func, errorHandler, ...)
	end
end

-------------
-- MODULES --
-------------

do
	local modules = {}

	function P:AddModule(name)
		modules[name] = {}

		return modules[name]
	end

	function P:GetModule(name)
		return modules[name]
	end

	function P:InitModules()
		for _, module in next, modules do
			P:Call(module.Init, module)
		end
	end

	function P:UpdateModules()
		for _, module in next, modules do
			if module.Update then
				P:Call(module.Update, module)
			end
		end
	end
end

--------------------------
-- ADDON SPECIFIC STUFF --
--------------------------

do
	local onLoadTasks = {}

	hooksecurefunc("LoadAddOn", function(name)
		local tasks = onLoadTasks[name]

		if tasks then
			if not IsAddOnLoaded(name) then return end

			for i = 1, #tasks do
				tasks[i]()
			end
		end
	end)

	function E:AddOnLoadTask(name, func)
		onLoadTasks[name] = onLoadTasks[name] or {}
		t_insert(onLoadTasks[name], func)
	end
end

--------------------
-- SLASH COMMANDS --
--------------------

do
	local commands = {}

	SLASH_LSUI1 = "/lsui"
	SlashCmdList["LSUI"] = function(msg)
		msg = msg:gsub("^ +", "")
		local command, arg = s_split(" ", msg, 2)
		arg = arg and arg:gsub(" ", "")

		if commands[command] then
			commands[command].func(arg)
		end
	end

	function P:AddCommand(command, handler, desc)
		commands[command] = {func = handler, desc = desc or "no description"}
	end

	SLASH_RELOADUI1 = "/rl"
	SlashCmdList["RELOADUI"] = ReloadUI
end

------------
-- TABLES --
------------

function E:CopyTable(src, dest, ignore)
	if type(dest) ~= "table" then
		dest = {}
	end

	for k, v in next, src do
		if not ignore or not ignore[k] then
			if type(v) == "table" then
				dest[k] = self:CopyTable(v, dest[k])
			else
				dest[k] = v
			end
		end
	end

	return dest
end

function E:UpdateTable(src, dest)
	if type(dest) ~= "table" then
		dest = {}
	end

	for k, v in next, src do
		if type(v) == "table" then
			dest[k] = self:UpdateTable(v, dest[k])
		else
			if dest[k] == nil then
				dest[k] = v
			end
		end
	end

	return dest
end

function E:ReplaceTable(src, dest)
	if type(dest) ~= "table" then
		dest = {}
	end

	for k, v in next, dest do
		if type(src[k]) == "table" then
			dest[k] = self:ReplaceTable(src[k], v)
		else
			dest[k] = src[k]
		end
	end

	return dest
end

function E:DiffTable(src , dest)
	if type(dest) ~= "table" then
		return {}
	end

	if type(src) ~= "table" then
		return dest
	end

	for k, v in next, dest do
		if type(v) == "table" then
			if not next(self:DiffTable(src[k], v)) then
				dest[k] = nil
			end
		elseif v == src[k] then
			dest[k] = nil
		end
	end

	return dest
end

local function isEqualTable(a, b)
	for k, v in next, a do
		if type(v) == "table" and type(b[k]) == "table" then
			if not isEqualTable(v, b[k]) then
				return false
			end
		else
			if v ~= b[k] then
				return false
			end
		end
	end

	for k, v in next, b do
		if type(v) == "table" and type(a[k]) == "table" then
			if not isEqualTable(v, a[k]) then
				return false
			end
		else
			if v ~= a[k] then
				return false
			end
		end
	end

	return true
end

function E:IsEqualTable(a, b)
	if type(a) ~= type(b) then
		return false
	end

	if type(a) == "table" then
		return isEqualTable(a, b)
	else
		return a == b
	end
end
