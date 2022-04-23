local _, CONFIG = ...

-- Lua
local _G = getfenv(0)
local unpack = _G.unpack

-- Libs
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local LibKeyBound = LibStub("LibKeyBound-1.0")

-- Mine
local E, M, L, C, D, PrC, PrD, P, oUF = unpack(ls_UI)

local isInit = false

function CONFIG:Open()
	if not isInit then
		self.options = {
			type = "group",
			name = L["LS_UI"],
			disabled = function()
				return InCombatLockdown()
			end,
			args = {
				layout = {
					order = 1,
					type = "select",
					name = L["UI_LAYOUT"],
					desc = L["UI_LAYOUT_DESC"],
					values = {
						round = L["LAYOUT_ROUND"],
						rect = L["LAYOUT_RECT"]
					},
					get = function()
						return PrC.db.profile.layout
					end,
					set = function(_, value)
						PrC.db.profile.layout = value

						if E.UI_LAYOUT ~= value then
							CONFIG:ShowStaticPopup("RELOAD_UI")
						end
					end,
				},
				toggle_anchors = {
					order = 2,
					type = "execute",
					name = L["TOGGLE_ANCHORS"],
					width = 1.25,
					func = function()
						E.Movers:ToggleAll(true)

						AceConfigDialog:Close("ls_UI")
					end,
				},
				keybind_mode = {
					order = 3,
					type = "execute",
					name = LibKeyBound.L.BindingMode,
					width = 1.25,
					func = function()
						LibKeyBound:Toggle()
					end,
				},
				reload_ui = {
					order = 4,
					type = "execute",
					name = L["RELOAD_UI"],
					width = 1.25,
					func = function()
						ReloadUI()
					end,
				},
				profiles = CONFIG:CreateProfilesPanel(100)
			},
		}

		CONFIG:GetGeneralOptions(5)
		CONFIG:CreateActionBarsPanel(6)
		CONFIG:CreateAuraTrackerPanel(7)
		CONFIG:CreateBlizzardPanel(8)
		CONFIG:CreateAurasPanel(9)
		CONFIG:GetLootOptions(10)
		CONFIG:CreateMinimapPanel(11)
		CONFIG:CreateTooltipsPanel(12)
		CONFIG:CreateUnitFramesPanel(13)

		AceConfig:RegisterOptionsTable("ls_UI", self.options)
		AceConfigDialog:SetDefaultSize("ls_UI", 1228, 768)

		P:AddCommand("kb", function()
			if not InCombatLockdown() then
				LibKeyBound:Toggle()
			end
		end)

		E:RegisterEvent("PLAYER_REGEN_DISABLED", function()
			AceConfigDialog:Close("ls_UI")
		end)

		CONFIG:RunCallbacks()

		isInit = true
	end

	AceConfigDialog:Open("ls_UI")
end
