local _, ns = ...
local E, C, PrC, M, L, P, D, PrD, oUF = ns.E, ns.C, ns.PrC, ns.M, ns.L, ns.P, ns.D, ns.PrD, ns.oUF
local UF = P:GetModule("UnitFrames")

-- Lua
local _G = getfenv(0)
local unpack = _G.unpack

-- Mine
local isInit = false
local NUM_PARTY_FRAMES = 8
local party_proto = {}
local holder

function UF:CreatePartyHolder()
	holder = CreateFrame("Frame", "LSPartyHolder", UIParent)
	holder:SetPoint(unpack(C.db.profile.units.party.point))
	E.Movers:Create(holder)
	holder._children = {}

	return holder
end

function UF:UpdatePartyHolder()
	if IsInRaid() and IsActiveBattlefieldArena() == false then
		holder:Hide()
	else
		holder:Show()

		if not holder._config then
			holder._config = {
				num = NUM_PARTY_FRAMES,
			}
		end

		holder._config.width = C.db.profile.units.party.width
		holder._config.height = C.db.profile.units.party.height
		holder._config.per_row = C.db.profile.units.party.per_row
		holder._config.spacing = C.db.profile.units.party.spacing
		holder._config.x_growth = C.db.profile.units.party.x_growth
		holder._config.y_growth = C.db.profile.units.party.y_growth

		E.Layout:Update(holder)
	end
end

E:RegisterEvent("GROUP_ROSTER_UPDATE", function()
	if not InCombatLockdown() and PrC.db.profile.units.party.enabled then
		UF:UpdatePartyHolder()
	end
end)

function party_proto:Update()
	UF.large_proto.Update(self)
end

function UF:HasPartyFrame()
	return isInit
end

function UF:CreatePartyFrame(frame)
	Mixin(self:CreateLargeFrame(frame), party_proto)

	isInit = true

	return frame
end
