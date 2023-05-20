local _, ns = ...
local E, C, PrC, M, L, P, D, PrD, oUF, Profiler = ns.E, ns.C, ns.PrC, ns.M, ns.L, ns.P, ns.D, ns.PrD, ns.oUF, ns.Profiler
local MODULE = P:GetModule("Blizzard")

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local unpack = _G.unpack

-- Mine
local isInit = false

function MODULE:HasDigsiteBar()
	return isInit
end

function MODULE:SetUpDigsiteBar()
	if not isInit and PrC.db.profile.blizzard.digsite_bar.enabled then
		local isLoaded = true
		if not IsAddOnLoaded("Blizzard_ArchaeologyUI") then
			isLoaded = LoadAddOn("Blizzard_ArchaeologyUI")
		end

		if isLoaded then
			ArcheologyDigsiteProgressBar.ignoreFramePositionManager = true

			E:HandleStatusBar(ArcheologyDigsiteProgressBar)

			ArcheologyDigsiteProgressBar:ClearAllPoints()
			ArcheologyDigsiteProgressBar:SetPoint(unpack(C.db.profile.blizzard.digsite_bar.point))
			E.Movers:Create(ArcheologyDigsiteProgressBar)

			ArcheologyDigsiteProgressBar.Text:SetText("")
			ArcheologyDigsiteProgressBar.Texture:SetVertexColor(C.db.global.colors.orange:GetRGB())

			hooksecurefunc("ArcheologyDigsiteProgressBar_OnEvent", function(self, event, num, total)
				if event == "ARCHAEOLOGY_SURVEY_CAST" or event == "ARCHAEOLOGY_FIND_COMPLETE" then
					self.Text:SetText(num .. " / ".. total)
				end
			end)

			isInit = true

			self:UpdateDigsiteBar()
		end
	end
end

function MODULE:UpdateDigsiteBar()
	if isInit then
		local config = C.db.profile.blizzard.digsite_bar

		ArcheologyDigsiteProgressBar:SetSize(config.width, config.height)

		local mover = E.Movers:Get(ArcheologyDigsiteProgressBar, true)
		if mover then
			mover:UpdateSize()
		end

		E:SetStatusBarSkin(ArcheologyDigsiteProgressBar, "HORIZONTAL-" .. config.height)

		ArcheologyDigsiteProgressBar.Text:UpdateFont(config.text.size)
	end
end
