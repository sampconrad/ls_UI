local _, ns = ...
local E, C, PrC, M, L, P = ns.E, ns.C, ns.PrC, ns.M, ns.L, ns.P
local MODULE = P:AddModule("Minimap")

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local m_floor = _G.math.floor
local next = _G.next
local t_wipe = _G.table.wipe
local unpack = _G.unpack

-- Mine
local isInit = false

local zoneTypeToColor = {
	["arena"] = "hostile",
	["combat"] = "hostile",
	["contested"] = "contested",
	["friendly"] = "friendly",
	["hostile"] = "hostile",
	["sanctuary"] = "sanctuary",
}

local minimap_proto = {}

function minimap_proto:UpdateBorderColor()
	if self._config.color.border then
		self.Border:SetVertexColor(E:GetRGB(C.db.global.colors.zone[zoneTypeToColor[GetZonePVPInfo() or "contested"]]))
	else
		self.Border:SetVertexColor(1, 1, 1)
	end
end

function minimap_proto:OnEventHook(event)
	if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" then
		self:UpdateBorderColor()
	end
end

local function updateHybridMinimap()
	if C.db.profile.minimap[E.UI_LAYOUT].shape == "square" then
		HybridMinimap.CircleMask:SetTexture("Interface\\BUTTONS\\WHITE8X8", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	else
		HybridMinimap.CircleMask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	end

	HybridMinimap.MapCanvas:SetMaskTexture(HybridMinimap.CircleMask)
end

function minimap_proto:UpdateConfig()
	self._config = E:CopyTable(C.db.profile.minimap[E.UI_LAYOUT], self._config)
	self._config.color = E:CopyTable(C.db.profile.minimap.color, self._config.color)

	MinimapCluster._config = t_wipe(MinimapCluster._config or {})
	MinimapCluster._config.fade = E:CopyTable(C.db.profile.minimap.fade, MinimapCluster._config.fade)
end

local borderInfo = {
	[100] = {
		{1 / 1024, 433 / 1024, 1 / 512, 433 / 512}, -- outer
		{434 / 1024, 866 / 1024, 1 / 512, 433 / 512}, -- inner
		432 / 2,
	},
}

-- At odds with the fierce looking face...
local function theBodyIsRound()
	return "ROUND"
end

local function theBodyIsSquare()
	return "SQUARE"
end

function minimap_proto:UpdateLayout()
	local scale = self._config.scale
	local shape = self._config.shape
	local info = borderInfo[scale] or borderInfo[100]

	self.Border:SetTexture("Interface\\AddOns\\ls_UI\\assets\\minimap-" .. shape .. "-" .. scale)
	self.Border:SetTexCoord(unpack(info[1]))
	self.Border:SetSize(info[3], info[3])

	self.Foreground:SetTexture("Interface\\AddOns\\ls_UI\\assets\\minimap-" .. shape .. "-" .. scale)
	self.Foreground:SetTexCoord(unpack(info[2]))
	self.Foreground:SetSize(info[3], info[3])

	if shape == "round" then
		self:SetArchBlobRingScalar(1)
		self:SetQuestBlobRingScalar(1)
		self:SetTaskBlobRingScalar(1)
		self:SetMaskTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")

		self.Background:Hide()

		-- for LDBIcon-1.0
		GetMinimapShape = theBodyIsRound
	else
		self:SetArchBlobRingScalar(0)
		self:SetQuestBlobRingScalar(0)
		self:SetTaskBlobRingScalar(0)
		self:SetMaskTexture("Interface\\BUTTONS\\WHITE8X8")

		Minimap.Background:Show()

		-- for LDBIcon-1.0
		GetMinimapShape = theBodyIsSquare
	end

	MinimapCluster:SetSize(info[3] + 24, info[3] + 24)
	MinimapCluster:GetMover():UpdateSize()

	self:SetSize(info[3] - 22, info[3] - 22)
	self:ClearAllPoints()

	MinimapCluster.BorderTop:ClearAllPoints()
	MinimapCluster.BorderTop:SetPoint("LEFT", "Minimap", "LEFT", 1, 0)
	MinimapCluster.BorderTop:SetPoint("RIGHT", "Minimap", "RIGHT", -1, 0)

	MinimapCluster.InstanceDifficulty:ClearAllPoints()
	MinimapCluster.InstanceDifficulty:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT", -2, -24)

	if self._config.flip then
		self:SetPoint("CENTER", "MinimapCluster", "CENTER", 0, 8, true)

		MinimapCluster.BorderTop:SetPoint("BOTTOM", "MinimapCluster", "BOTTOM", 0, 1)

		MinimapCluster.MailFrame:ClearAllPoints()
		MinimapCluster.MailFrame:SetPoint("BOTTOMLEFT", MinimapCluster.Tracking, "TOPLEFT", -1, 2)
	else
		self:SetPoint("CENTER", "MinimapCluster", "CENTER", 0, -8, true)

		MinimapCluster.BorderTop:SetPoint("TOP", "MinimapCluster", "TOP", 0, -1)

		MinimapCluster.MailFrame:ClearAllPoints()
		MinimapCluster.MailFrame:SetPoint("TOPLEFT", MinimapCluster.Tracking, "BOTTOMLEFT", -1, -2)
	end

	if HybridMinimap then
		updateHybridMinimap()
	end
end

function minimap_proto:UpdateRotation()
	SetCVar("rotateMinimap", self._config.rotate)
end

function MODULE:IsInit()
	return isInit
end

function MODULE:Init()
	if not isInit and PrC.db.profile.minimap.enabled then
		if not IsAddOnLoaded("Blizzard_TimeManager") then
			LoadAddOn("Blizzard_TimeManager")
		end

		MinimapCluster:ClearAllPoints()
		MinimapCluster:SetPoint(unpack(C.db.profile.minimap[E.UI_LAYOUT].point))
		E.Movers:Create(MinimapCluster)

		Mixin(Minimap, minimap_proto)

		Minimap:RegisterEvent("ZONE_CHANGED")
		Minimap:RegisterEvent("ZONE_CHANGED_INDOORS")
		Minimap:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		Minimap:HookScript("OnEvent", Minimap.OnEventHook)

		local textureParent = CreateFrame("Frame", nil, Minimap)
		textureParent:SetFrameLevel(Minimap:GetFrameLevel() + 1)
		textureParent:SetPoint("BOTTOMRIGHT", 0, 0)
		textureParent:SetPoint("TOPLEFT", 0, 0)
		Minimap.TextureParent = textureParent

		local border = textureParent:CreateTexture(nil, "BORDER", nil, 1)
		border:SetPoint("CENTER", 0, 0)
		E:SmoothColor(border)
		Minimap.Border = border

		local foreground = textureParent:CreateTexture(nil, "BORDER", nil, 3)
		foreground:SetPoint("CENTER", 0, 0)
		Minimap.Foreground = foreground

		local background = Minimap:CreateTexture(nil, "BACKGROUND", nil, -7)
		background:SetAllPoints(Minimap)
		background:SetTexture("Interface\\HELPFRAME\\DarkSandstone-Tile", "REPEAT", "REPEAT")
		background:SetHorizTile(true)
		background:SetVertTile(true)
		background:Hide()
		Minimap.Background = background

		local DELAY = 337.5 -- 256 * 337.5 = 86400 = 24H
		-- local DELAY = 0.05 -- 256 * 337.5 = 86400 = 24H
		local STEP = 0.00390625 -- 1 / 256

		local function checkTexPoint(point, base)
			if point then
				return point >= base / 256 + 1 and base / 256 or point
			else
				return base / 256
			end
		end

		local function scrollTexture(t, delay, offset)
			t.l = checkTexPoint(t.l, 64) + offset
			t.r = checkTexPoint(t.r, 192) + offset

			t:SetTexCoord(t.l, t.r, 40 / 128, 68 / 128) -- 64, 14

			C_Timer.After(delay, function() scrollTexture(t, DELAY, STEP) end)
		end

		local mask = MinimapCluster.BorderTop:CreateMaskTexture()
		mask:SetTexture("Interface\\AddOns\\ls_UI\\assets\\daytime-mask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		mask:SetPoint("TOPRIGHT", -1, -1)
		mask:SetPoint("BOTTOMLEFT", MinimapCluster.BorderTop, "BOTTOMRIGHT", -65, 2)

		local indicator = MinimapCluster.BorderTop:CreateTexture(nil, "BACKGROUND", nil, 1)
		indicator:SetTexture("Interface\\Minimap\\HumanUITile-TimeIndicator", true)
		indicator:SetPoint("TOPRIGHT", -1, -1)
		indicator:SetPoint("BOTTOMLEFT", MinimapCluster.BorderTop, "BOTTOMRIGHT", -65, 2)
		indicator:AddMaskTexture(mask)

		local h, m = GetGameTime()
		local s = (h * 60 + m) * 60
		local mult = m_floor(s / DELAY)

		scrollTexture(indicator, (mult + 1) * DELAY - s, STEP * mult)

		-- E:ForceShow(MinimapCluster.InstanceDifficulty)

		hooksecurefunc(MinimapCluster, "SetHeaderUnderneath", function()
			Minimap:UpdateConfig()
			Minimap:UpdateLayout()
		end)

		hooksecurefunc(MinimapCluster, "SetRotateMinimap", function()
			Minimap:UpdateConfig()
			Minimap:UpdateRotation()
		end)

		hooksecurefunc(Minimap, "SetPoint", function(_, _, _, _, _, _, shouldIgnore)
			if not shouldIgnore then
				Minimap:UpdateLayout()
			end
		end)

		MinimapCompassTexture:SetTexture(nil)

		MinimapCluster.BorderTop:SetWidth(0)
		MinimapCluster.BorderTop:SetHeight(17)

		MinimapCluster.Tracking:SetSize(18, 17)
		MinimapCluster.Tracking.Button:SetSize(14, 14)
		MinimapCluster.Tracking.Button:ClearAllPoints()
		MinimapCluster.Tracking.Button:SetPoint("TOPLEFT", 1, -1)

		MinimapCluster.ZoneTextButton:SetSize(0, 16)
		MinimapCluster.ZoneTextButton:ClearAllPoints()
		MinimapCluster.ZoneTextButton:SetPoint("TOPLEFT", MinimapCluster.BorderTop, "TOPLEFT", 4, 0)
		MinimapCluster.ZoneTextButton:SetPoint("TOPRIGHT", MinimapCluster.BorderTop, "TOPRIGHT", -48, 0)

		MinimapZoneText:SetSize(0, 16)
		MinimapZoneText:ClearAllPoints()
		MinimapZoneText:SetPoint("LEFT", 2, 1)
		MinimapZoneText:SetPoint("RIGHT", -2, 1)
		MinimapZoneText:SetJustifyH("LEFT")
		MinimapZoneText:SetJustifyV("MIDDLE")

		TimeManagerClockButton:ClearAllPoints()
		TimeManagerClockButton:SetPoint("TOPRIGHT", MinimapCluster.BorderTop, "TOPRIGHT", -4, 0)

		TimeManagerClockTicker:SetJustifyH("RIGHT")
		TimeManagerClockTicker:SetJustifyV("MIDDLE")
		TimeManagerClockTicker:SetFontObject("GameFontNormal")
		TimeManagerClockTicker:SetTextColor(1, 1, 1)
		TimeManagerClockTicker:SetSize(40, 16)
		TimeManagerClockTicker:ClearAllPoints()
		TimeManagerClockTicker:SetPoint("CENTER", 0, 1)

		GameTimeFrame:ClearAllPoints()
		GameTimeFrame:SetPoint("TOPLEFT", MinimapCluster.BorderTop, "TOPRIGHT", 4, 0)

		for _, obj in next, {
				Minimap.ZoomIn,
				Minimap.ZoomOut,
				Minimap.ZoomHitArea,
		} do
			E:ForceHide(obj)
		end

		if not HybridMinimap then
			E:AddOnLoadTask("Blizzard_HybridMinimap", updateHybridMinimap)
		end

		E:SetUpFading(MinimapCluster)

		isInit = true

		self:Update()
	end
end

function MODULE:Update()
	if isInit then
		Minimap:UpdateConfig()
		Minimap:UpdateLayout()
		Minimap:UpdateBorderColor()
		MinimapCluster:UpdateFading()
	end
end

function MODULE:GetMinimap()
	return Minimap
end
