local _, ns = ...
local E, C, M = ns.E, ns.C, ns.M

local UF = E.UF

function UF:ConstructTargetTargetFrame(frame)
	local level = frame:GetFrameLevel()
	
	frame.mouseovers = {}
	frame:SetSize(112, 38)

	local bg = frame:CreateTexture(nil, "BACKGROUND", nil, 2)
	bg:SetTexture("Interface\\AddOns\\oUF_LS\\media\\frame_other_short")
	bg:SetTexCoord(0 / 256, 112 / 256, 0 / 128, 38 / 128)
	bg:SetAllPoints()

	local cover = CreateFrame("Frame", nil, frame)
	cover:SetFrameLevel(level + 2)
	cover:SetAllPoints()
	frame.Cover = cover

	local gloss = cover:CreateTexture(nil, "BACKGROUND", nil, 0)
	gloss:SetTexture("Interface\\AddOns\\oUF_LS\\media\\frame_other_short")
	gloss:SetTexCoord(80 / 256, 174 / 256, 38 / 128, 58 / 128)
	gloss:SetSize(94, 20)
	gloss:SetPoint("CENTER")

	local fg = cover:CreateTexture(nil, "ARTWORK", nil, 2)
	fg:SetTexture("Interface\\AddOns\\oUF_LS\\media\\frame_other_short")
	fg:SetTexCoord(112 / 256, 218 / 256, 4 / 128, 34 / 128)
	fg:SetSize(106, 30)
	fg:SetPoint("CENTER")

	frame.Health = UF:CreateHealthBar(frame, 12, true)
	frame.Health:SetFrameLevel(level + 1)
	frame.Health:SetSize(90, 20)
	frame.Health:SetPoint("CENTER")
	frame.Health.Value:SetJustifyH("RIGHT")
	frame.Health.Value:SetParent(cover)
	frame.Health.Value:SetPoint("RIGHT", -12, 0)
	tinsert(frame.mouseovers, frame.Health)

	frame.HealPrediction = UF:CreateHealPrediction(frame)

	local absrobGlow = cover:CreateTexture(nil, "ARTWORK", nil, 1)
	absrobGlow:SetTexture("Interface\\AddOns\\oUF_LS\\media\\frame_other_short")
	absrobGlow:SetTexCoord(218 / 256, 234 / 256, 4 / 128, 30 / 128)
	absrobGlow:SetVertexColor(E:ColorLighten(0, 0.7, 0.95, 0.35))
	absrobGlow:SetSize(16, 26)
	absrobGlow:SetPoint("CENTER", 42, 0)
	absrobGlow:SetAlpha(0)
	frame.AbsorbGlow = absrobGlow

	-- frame.Power = UF:CreatePowerBar(frame, 10, 4, true)
	-- frame.Power:SetSize(62, 2)
	-- frame.Power:SetPoint("CENTER", 0, -11)
	-- frame.Power.Value:SetJustifyH("LEFT")
	-- frame.Power.Value:SetPoint("LEFT")
	-- frame.Power.Value:SetDrawLayer("OVERLAY", 2)
	-- tinsert(frame.mouseovers, frame.Power)

	-- local tube = frame.Power:CreateTexture(nil, "OVERLAY", nil, 0)
	-- tube:SetTexture("Interface\\AddOns\\oUF_LS\\media\\frame_other_short")
	-- tube:SetTexCoord(0 / 256, 80 / 256, 38 / 128, 48 / 128)
	-- tube:SetSize(80, 10)
	-- tube:SetPoint("CENTER")
	-- frame.Power.Tube = tube

	-- frame.Castbar = UF:CreateCastBar(frame, 102, {"TOP", frame, "BOTTOM", 0, -20})

	-- frame.PvP = UF:CreateIcon(frame, "PvP", 14)
	-- frame.PvP:SetPoint("BOTTOMLEFT", 4, -12)

	-- frame.PhaseIcon = UF:CreateIcon(frame, "Phase", 14)
	-- frame.PhaseIcon:SetPoint("BOTTOMLEFT", 20, -12)

	-- frame.Leader = UF:CreateIcon(frame, "Leader", 14)
	-- frame.Leader:SetPoint("BOTTOMRIGHT", -20, -12)

	-- frame.LFDRole = UF:CreateIcon(frame, "LFDRole", 14)
	-- frame.LFDRole:SetPoint("BOTTOMRIGHT", -4, -12)

	-- frame.QuestIcon = UF:CreateIcon(frame, "Quest", 14)
	-- frame.QuestIcon:SetPoint("TOPLEFT", 4, 12)

	-- frame.ReadyCheck = cover:CreateTexture("$parentReadyCheckIcon", "BACKGROUND")
	-- frame.ReadyCheck:SetSize(32, 32)
	-- frame.ReadyCheck:SetPoint("CENTER")

	frame.RaidIcon = cover:CreateTexture("$parentRaidIcon", "ARTWORK", nil, 3)
	frame.RaidIcon:SetSize(24, 24)
	frame.RaidIcon:SetPoint("TOP", 0, 22)

	local name = E:CreateFontString(cover, 12, "$parentNameText", true)
	name:SetDrawLayer("ARTWORK", 4)
	name:SetPoint("LEFT", frame, "LEFT", 2, 0)
	name:SetPoint("RIGHT", frame, "RIGHT", -2, 0)
	name:SetPoint("BOTTOM", frame, "TOP", 0, 0)
	frame:Tag(name, "[difficulty][level][shortclassification]|r [custom:name]")

	-- frame.Threat = UF:CreateThreat(frame, "Interface\\AddOns\\oUF_LS\\media\\frame_other_short", 0 / 256, 58 / 256, 59 / 128, 92 / 128)
	-- frame.Threat:SetSize(58, 33)
	-- frame.Threat:SetPoint("CENTER", -29, 4)

	-- frame.DebuffHighlight = UF:CreateDebuffHighlight(frame, "Interface\\AddOns\\oUF_LS\\media\\frame_other_short", 58 / 256, 116 / 256, 59 / 128, 92 / 128)
	-- frame.DebuffHighlight:SetSize(58, 33)
	-- frame.DebuffHighlight:SetPoint("CENTER", 29, 4)

	-- frame.Buffs = UF:CreateBuffs(frame, {"BOTTOMRIGHT", frame, "TOPRIGHT", 0, 30}, 8)
	-- frame.Debuffs = UF:CreateDebuffs(frame, {"BOTTOMLEFT", frame, "TOPLEFT", 0, 30}, 8)
end
