local _, ns = ...
local E, C, PrC, M, L, P, D, PrD, oUF = ns.E, ns.C, ns.PrC, ns.M, ns.L, ns.P, ns.D, ns.PrD, ns.oUF
local UF = P:AddModule("UnitFrames")

-- Lua
local _G = getfenv(0)
local next = _G.next
local rawset = _G.rawset
local s_upper = _G.string.upper
local type = _G.type
local unpack = _G.unpack

-- Mine
local isInit = false
local NUM_BOSS_FRAMES = 8
local NUM_PARTY_FRAMES = 8
local objects = {}
local units = {}

local configIgnoredKeys = {
	alt_power = true,
	auras = true,
	border = true,
	castbar = true,
	class = true,
	class_power = true,
	custom_texts = true,
	debuff = true,
	health = true,
	insets = true,
	name = true,
	portrait = true,
	power = true,
	pvp = true,
	raid_target = true,
	threat = true,
}

local frame_proto = {}

function frame_proto:UpdateConfig()
	self._config = E:CopyTable(C.db.profile.units[self.__unit], self._config, configIgnoredKeys)
end

function frame_proto:OnEnter()
	GameTooltip_SetDefaultAnchor(GameTooltip, self)
	GameTooltip:SetUnit(self.unit)
end

function frame_proto:OnLeave()
	GameTooltip:FadeOut()
end

function frame_proto:UpdateSize()
	self:SetSize(self._config.width, self._config.height)

	local mover = E.Movers:Get(self, true)
	if mover then
		mover:UpdateSize()
	end
end

function frame_proto:For(element, method, ...)
	if self[element] and self[element][method] then
		self[element][method](self[element], ...)
	end
end

function UF:UpdateHealthColors()
	oUF.colors.health:SetRGB(C.db.global.colors.health:GetRGB())
	oUF.colors.tapped:SetRGB(C.db.global.colors.tapped:GetRGB())
	oUF.colors.disconnected:SetRGB(C.db.global.colors.disconnected:GetRGB())
end

function UF:UpdateReactionColors()
	local color = oUF.colors.reaction
	for k, v in next, C.db.global.colors.reaction do
		if color[k] then
			color[k]:SetRGB(v:GetRGB())
		end
	end
end

function UF:UpdatePowerColors()
	local color = oUF.colors.power
	for k, myColor in next, C.db.global.colors.power do
		if type(k) == "string" then
			if color[k] then
				if type(myColor[1]) == "table" then
					for i, myColor_ in next, myColor do
						color[k][i]:SetRGB(myColor_:GetRGB())
					end
				else
					color[k]:SetRGB(myColor:GetRGB())
				end
			end
		end
	end

	color = oUF.colors.runes
	for k, v in next, C.db.global.colors.rune do
		color[k]:SetRGB(v:GetRGB())
	end
end

function UF:UpdateTags()
	oUF.Tags.SharedEvents["PLAYER_REGEN_DISABLED"] = true
	oUF.Tags.SharedEvents["PLAYER_REGEN_ENABLED"] = true

	for name, data in next, C.db.global.tags do
		oUF.Tags.Events[name] = data.events

		rawset(oUF.Tags.Methods, name, nil)
		oUF.Tags.Methods[name] = data.func

		rawset(oUF.Tags.Vars, name, nil)
		oUF.Tags.Vars[name] = data.vars
	end

	for name, vars in next, C.db.global.tag_vars do
		rawset(oUF.Tags.Vars, name, nil)
		oUF.Tags.Vars[name] = vars
	end
end

function UF:UpdateBlizzCastbars()
	if not C.db.profile.units.player.castbar.enabled and C.db.profile.units.player.castbar.blizz_enabled then
		PlayerCastingBarFrame:OnLoad()
		PetCastingBarFrame:PetCastingBar_OnLoad()
	else
		PlayerCastingBarFrame:SetUnit(nil)
		PetCastingBarFrame:SetUnit(nil)
	end
end

local eventlessUnits = {
	["boss6"] = true,
	["boss7"] = true,
	["boss8"] = true,
}

local function isEventlessUnit(unit)
	return unit:match("%w+target") or eventlessUnits[unit]
end

function UF:Create(unit)
	if not units[unit] then
		local name = "LS" .. unit:gsub("^%l", s_upper):gsub("t(arget)", "T%1")

		if unit == "boss" then
			local holder = self:CreateBossHolder()

			for i = 1, NUM_BOSS_FRAMES do
				local object = oUF:Spawn(unit .. i, name .. i .. "Frame")
				objects[unit .. i] = object

				object._parent = holder
				holder._children[i] = object

				if isEventlessUnit(unit .. i) then
					object.onUpdateFrequency = 0.2

					oUF:HandleEventlessUnit(object)
				end
			end
		elseif unit == "party" then
			local partyHolder = self:CreatePartyHolder()

			for i = 1, NUM_PARTY_FRAMES do
				local object = oUF:Spawn(unit .. i, name .. i .. "Frame")
				objects[unit .. i] = object

				object._parent = partyHolder
				partyHolder._children[i] = object

				if isEventlessUnit(unit .. i) then
					object.onUpdateFrequency = 0.2

					oUF:HandleEventlessUnit(object)
				end
			end
		else
			local object = oUF:Spawn(unit, name .. "Frame")
			object:SetPoint(unpack(C.db.profile.units[unit].point))
			E.Movers:Create(object)
			objects[unit] = object

			if isEventlessUnit(unit) then
				object.onUpdateFrequency = 0.2

				oUF:HandleEventlessUnit(object)
			end
		end

		units[unit] = true
	end
end

local allowedMethodsIfDisabled = {
	Update = true,
	UpdateConfig = true,
}

function UF:For(unit, method, ...)
	if units[unit] and (C.db.profile.units[unit].enabled or allowedMethodsIfDisabled[method]) then
		if unit == "boss"then
			for i = 1, NUM_BOSS_FRAMES do
				if objects[unit .. i][method] then
					objects[unit .. i][method](objects[unit .. i], ...)
				end
			end

			if method == "Update" then
				UF:UpdateBossHolder()
			end
		elseif unit == "party" then
			for i = 1, NUM_PARTY_FRAMES do
				if objects[unit .. i][method] then
					objects[unit .. i][method](objects[unit .. i], ...)
				end
			end

			if method == "Update" then
				UF:UpdatePartyHolder()
			end
		elseif objects[unit] then
			if objects[unit][method] then
				objects[unit][method](objects[unit], ...)
			end
		end
	end
end

function UF:ForEach(method, ...)
	for unit in next, units do
		self:For(unit, method, ...)
	end
end

function UF:GetUnits(ignoredUnits)
	local temp = {}

	for unit in next, units do
		if not ignoredUnits or not ignoredUnits[unit] then
			temp[unit] = unit
		end
	end

	return temp
end

function UF:IsInit()
	return isInit
end

function UF:Init()
	if not isInit and PrC.db.profile.units.enabled then
		self:UpdateHealthColors()
		self:UpdateReactionColors()
		self:UpdatePowerColors()
		self:UpdateTags()

		oUF:Factory(function()
			oUF:RegisterStyle("LS", function(frame, unit)
				Mixin(frame, frame_proto)
				frame.__unit = unit:gsub("%d+", "")

				frame:RegisterForClicks("AnyUp")
				frame:SetScript("OnEnter", frame.OnEnter)
				frame:SetScript("OnLeave", frame.OnLeave)

				if unit == "player" then
					UF:CreatePlayerFrame(frame)
				elseif unit == "pet" then
					UF:CreatePetFrame(frame)
				elseif unit == "target" then
					UF:CreateTargetFrame(frame)
				elseif unit == "targettarget" then
					UF:CreateTargetTargetFrame(frame)
				elseif unit == "focus" then
					UF:CreateFocusFrame(frame)
				elseif unit == "focustarget" then
					UF:CreateFocusTargetFrame(frame)
				elseif unit:match("^boss%d") then
					UF:CreateBossFrame(frame)
				elseif unit:match("^party%d") then
					UF:CreatePartyFrame(frame)
				end
			end)
			oUF:SetActiveStyle("LS")

			if PrC.db.profile.units.player.enabled then
				UF:Create("player")
				UF:For("player", "Update")
				UF:Create("pet")
				UF:For("pet", "Update")
			end

			if PrC.db.profile.units.target.enabled then
				UF:Create("target")
				UF:For("target", "Update")
				UF:Create("targettarget")
				UF:For("targettarget", "Update")
			end

			if PrC.db.profile.units.focus.enabled then
				UF:Create("focus")
				UF:For("focus", "Update")
				UF:Create("focustarget")
				UF:For("focustarget", "Update")
			end

			if PrC.db.profile.units.boss.enabled then
				UF:Create("boss")
				UF:For("boss", "Update")
			end

			if PrC.db.profile.units.party.enabled then
				UF:Create("party")
				UF:For("party", "Update")
			end
		end)

		isInit = true
	end
end

function UF:Update()
	if isInit then
		self:ForEach("Update")
	end
end
