local _, ns = ...
local E, C, M, L, P = ns.E, ns.C, ns.M, ns.L, ns.P
local UF = P:GetModule("UnitFrames")

-- Lua
local _G = getfenv(0)

-- Mine
function UF:ConstructTargetFrame(frame)
	local level = frame:GetFrameLevel()

	frame._config = C.units.target
	frame._mouseovers = {}

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetTexture("Interface\\AddOns\\ls_UI\\media\\unit-frame-bg", true)
	bg:SetHorizTile(true)

	local fg_parent = _G.CreateFrame("Frame", nil, frame)
	fg_parent:SetFrameLevel(level + 7)
	fg_parent:SetAllPoints()
	frame.FGParent = fg_parent

	local text_parent = _G.CreateFrame("Frame", nil, frame)
	text_parent:SetFrameLevel(level + 9)
	text_parent:SetAllPoints()
	frame.TextParent = text_parent

	frame.Insets = UF:CreateInsets(frame, fg_parent, level)

	local health = self:CreateHealth(frame, true, "LS12Font_Shadow", text_parent)
	health:SetFrameLevel(level + 1)
	health:SetPoint("LEFT", frame, "LEFT", 0, 0)
	health:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
	health:SetPoint("TOP", frame.Insets.Top, "BOTTOM", 0, 0)
	health:SetPoint("BOTTOM", frame.Insets.Bottom, "TOP", 0, 0)
	health:SetClipsChildren(true)
	frame.Health = health

	frame.HealthPrediction = self:CreateHealthPrediction(health)

	local power = self:CreatePower(frame, true, "LS12Font_Shadow", text_parent)
	power:SetFrameLevel(level + 1)
	power:SetPoint("LEFT", frame, "LEFT", 0, 0)
	power:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
	power:SetPoint("TOP", frame.Insets.Bottom, "TOP", 0, -2)
	power:SetPoint("BOTTOM", frame.Insets.Bottom, "BOTTOM", 0, 0)
	power.Inset = frame.Insets.Bottom
	frame.Power = power

	frame.Castbar = self:CreateCastbar(frame)
	frame.Castbar.Holder:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 3, -6)

	frame.Name = UF:CreateName(text_parent, "LS12Font_Shadow")

	frame.RaidTargetIndicator = UF:CreateRaidTargetIndicator(text_parent)

	local pvp = self:CreatePvPIndicator(fg_parent)
	pvp:SetPoint("TOPRIGHT", fg_parent, "BOTTOMRIGHT", -8, -2)

	pvp.Holder.PostExpand = function()
		local width = frame.Castbar.Holder._width - 48
		frame.Castbar.Holder._width = width

		frame.Castbar.Holder:SetWidth(width)
	end
	pvp.Holder.PostCollapse = function()
		local width = frame.Castbar.Holder._width + 48
		frame.Castbar.Holder._width = width

		frame.Castbar.Holder:SetWidth(width)
	end

	frame.PvPIndicator = pvp

	frame.DebuffIndicator = UF:CreateDebuffIndicator(text_parent)

	frame.Auras = self:CreateAuras(frame, "target", 32, nil, nil, 8)
	frame.Auras:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", -1, 7)

	local statusIcons = text_parent:CreateFontString("$parentStatusIcons", "ARTWORK", "LSStatusIcon16Font")
	statusIcons:SetJustifyH("LEFT")
	statusIcons:SetPoint("LEFT", frame, "BOTTOMLEFT", 4, -1)
	frame:Tag(statusIcons, "[ls:questicon][ls:sheepicon][ls:phaseicon][ls:leadericon][ls:lfdroleicon][ls:classicon]")

	E:CreateBorder(fg_parent, true)

	local glass = fg_parent:CreateTexture(nil, "OVERLAY")
	glass:SetAllPoints(health)
	glass:SetTexture("Interface\\AddOns\\ls_UI\\media\\unit-frame-glass", true)
	glass:SetHorizTile(true)

	self:CreateRarityIndicator(frame)
end

function UF:UpdateTargetFrame(frame)
	local config = frame._config

	frame:SetSize(config.width, config.height)

	self:UpdateInsets(frame)
	self:UpdateHealth(frame)
	self:UpdateHealthPrediction(frame)
	self:UpdatePower(frame)
	self:UpdateCastbar(frame)
	self:UpdateName(frame)
	self:UpdateRaidTargetIndicator(frame)
	self:UpdatePvPIndicator(frame)
	self:UpdateDebuffIndicator(frame)

	frame:UpdateAllElements("LSUI_TargetFrameUpdate")
end
