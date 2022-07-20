local _, CONFIG = ...

-- Lua
local _G = getfenv(0)
local unpack = _G.unpack

-- Mine
local E, M, L, C, D, PrC, PrD, P, oUF = unpack(ls_UI)
local BLIZZARD = P:GetModule("Blizzard")

local orders = {}

local function reset(order)
	orders[order] = 1
	return orders[order]
end

local function inc(order)
	orders[order] = orders[order] + 1
	return orders[order]
end

local DRAG_KEYS = {
	[1] = _G.ALT_KEY,
	[2] = _G.CTRL_KEY,
	[3] = _G.SHIFT_KEY,
	[4] = _G.NONE_KEY,
}

local DRAG_KEY_VALUES = {
	[1] = "ALT",
	[2] = "CTRL",
	[3] = "SHIFT",
	[4] = "NONE",
}

local DRAG_KEY_INDICES = {
	["ALT"] = 1,
	["CTRL"] = 2,
	["SHIFT"] = 3,
	["NONE"] = 4,
}

local SHOW_PET_OPTIONS = {
	[-1] = L["AUTO"],
	[ 0] = L["HIDE"],
	[ 1] = L["SHOW"],
}

local function isModuleDisabled()
	return not BLIZZARD:IsInit()
end

function CONFIG:CreateBlizzardOptions(order)
	self.options.args.blizzard = {
		order = order,
		type = "group",
		name = L["BLIZZARD"],
		childGroups = "tab",
		get = function(info)
			return PrC.db.profile.blizzard[info[#info]].enabled
		end,
		args = {
			enabled = {
				order = reset(1),
				type = "toggle",
				name = L["ENABLE"],
				get = function()
					return PrC.db.profile.blizzard.enabled
				end,
				set = function(_, value)
					PrC.db.profile.blizzard.enabled = value

					if not BLIZZARD:IsInit() then
						if value then
							P:Call(BLIZZARD.Init, BLIZZARD)
						end
					else
						if not value then
							CONFIG:ShowStaticPopup("RELOAD_UI")
						end
					end
				end,
			},
			spacer_1 = {
				order = inc(1),
				type = "description",
				name = " ",
				width = "full",
			},
			command_bar = {
				order = inc(1),
				type = "toggle",
				name = L["COMMAND_BAR"],
				disabled = isModuleDisabled,
				set = function(_, value)
					PrC.db.profile.blizzard.command_bar.enabled = value

					if not BLIZZARD:HasCommandBar() then
						if value then
							BLIZZARD:SetUpCommandBar()
						end
					else
						if not value then
							CONFIG:ShowStaticPopup("RELOAD_UI")
						end
					end
				end,
			},
			durability = {
				order = inc(1),
				type = "toggle",
				name = L["DURABILITY_FRAME"],
				disabled = isModuleDisabled,
				set = function(_, value)
					PrC.db.profile.blizzard.durability.enabled = value

					if not BLIZZARD:HasDurabilityFrame() then
						if value then
							BLIZZARD:SetUpDurabilityFrame()
						end
					else
						if not value then
							CONFIG:ShowStaticPopup("RELOAD_UI")
						end
					end
				end,
			},
			gm = {
				order = inc(1),
				type = "toggle",
				name = L["GM_FRAME"],
				disabled = isModuleDisabled,
				set = function(_, value)
					PrC.db.profile.blizzard.gm.enabled = value

					if not BLIZZARD:HasGMFrame() then
						if value then
							BLIZZARD:SetUpGMFrame()
						end
					else
						if not value then
							CONFIG:ShowStaticPopup("RELOAD_UI")
						end
					end
				end,
			},
			mail = {
				order = inc(1),
				type = "toggle",
				name = L["MAIL"],
				disabled = isModuleDisabled,
				set = function(_, value)
					PrC.db.profile.blizzard.mail.enabled = value

					if not BLIZZARD:HasMail() then
						if value then
							BLIZZARD:SetUpMail()
						end
					else
						if not value then
							CONFIG:ShowStaticPopup("RELOAD_UI")
						end
					end
				end,
			},
			maw_buffs = {
				order = inc(1),
				type = "toggle",
				name = L["MAW_BUFFS"],
				disabled = isModuleDisabled,
				set = function(_, value)
					PrC.db.profile.blizzard.maw_buffs.enabled = value

					if not BLIZZARD:HasMawBuffs() then
						if value then
							BLIZZARD:SetUpMawBuffs()
						end
					else
						if not value then
							CONFIG:ShowStaticPopup("RELOAD_UI")
						end
					end
				end,
			},
			player_alt_power_bar = {
				order = inc(1),
				type = "toggle",
				name = L["ALT_POWER_BAR"],
				disabled = isModuleDisabled,
				set = function(_, value)
					PrC.db.profile.blizzard.player_alt_power_bar.enabled = value

					if not BLIZZARD:HasAltPowerBar() then
						if value then
							BLIZZARD:SetUpAltPowerBar()
						end
					else
						if not value then
							CONFIG:ShowStaticPopup("RELOAD_UI")
						end
					end
				end,
			},
			vehicle = {
				order = inc(1),
				type = "toggle",
				name = L["VEHICLE_SEAT_INDICATOR"],
				disabled = isModuleDisabled,
				set = function(_, value)
					PrC.db.profile.blizzard.vehicle.enabled = value

					if not BLIZZARD:HasVehicleSeatFrame() then
						if value then
							BLIZZARD:SetUpVehicleSeatFrame()
						end
					else
						if not value then
							CONFIG:ShowStaticPopup("RELOAD_UI")
						end
					end
				end,
			},
			castbar = {
				order = inc(1),
				type = "group",
				name = L["CASTBAR"],
				disabled = function()
					return not BLIZZARD:IsInit() or P:GetModule("UnitFrames"):HasPlayerFrame()
				end,
				get = function(info)
					return C.db.profile.blizzard.castbar[info[#info]]
				end,
				set = function(info, value)
					if C.db.profile.blizzard.castbar[info[#info]] ~= value then
						C.db.profile.blizzard.castbar[info[#info]] = value

						BLIZZARD:UpdateCastBars()
					end
				end,
				args = {
					enabled = {
						order = reset(2),
						type = "toggle",
						name = L["ENABLE"],
						get = function()
							return PrC.db.profile.blizzard.castbar.enabled
						end,
						set = function(_, value)
							PrC.db.profile.blizzard.castbar.enabled = value

							if not BLIZZARD:HasCastBars() then
								if value then
									BLIZZARD:SetUpCastBars()
								end
							else
								if not value then
									CONFIG:ShowStaticPopup("RELOAD_UI")
								end
							end
						end,
					},
					reset = {
						type = "execute",
						order = inc(2),
						name = L["RESTORE_DEFAULTS"],
						confirm = CONFIG.ConfirmReset,
						func = function()
							CONFIG:CopySettings(D.profile.blizzard.castbar, C.db.profile.blizzard.castbar)

							BLIZZARD:UpdateCastBars()
						end,
					},
					spacer_1 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					latency = {
						order = inc(2),
						type = "toggle",
						name = L["LATENCY"],
					},
					show_pet = {
						order = inc(2),
						type = "select",
						name = L["PET_CASTBAR"],
						values = SHOW_PET_OPTIONS,
					},
					spacer_2 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					width = {
						order = inc(2),
						type = "range",
						name = L["WIDTH"],
						min = 96, max = 1024, step = 2,
					},
					height = {
						order = inc(2),
						type = "range",
						name = L["HEIGHT"],
						min = 8, max = 32, step = 4,
					},
					icon = {
						order = inc(2),
						type = "select",
						name = L["ICON"],
						values = CONFIG.CASTBAR_ICON_POSITIONS,
						get = function()
							return C.db.profile.blizzard.castbar.icon.position
						end,
						set = function(_, value)
							if C.db.profile.blizzard.castbar.icon.position ~= value then
								C.db.profile.blizzard.castbar.icon.position = value
								BLIZZARD:UpdateCastBars()
							end
						end,
					},
					size = {
						order = inc(2),
						type = "range",
						name = L["BAR_TEXT"],
						min = 8, max = 32, step = 1,
						get = function()
							return C.db.profile.blizzard.castbar.text.size
						end,
						set = function(_, value)
							if C.db.profile.blizzard.castbar.text.size ~= value then
								C.db.profile.blizzard.castbar.text.size = value

								BLIZZARD:UpdateCastBars()
							end
						end,
					},
				},
			},
			character_frame = {
				order = inc(1),
				type = "group",
				name = L["CHARACTER_FRAME"],
				disabled = isModuleDisabled,
				get = function(info)
					return C.db.profile.blizzard.character_frame[info[#info]]
				end,
				set = function(info, value)
					if C.db.profile.blizzard.character_frame[info[#info]] ~= value then
						C.db.profile.blizzard.character_frame[info[#info]] = value

						BLIZZARD:UpadteCharacterFrame()
					end
				end,
				args = {
					enabled = {
						order = reset(2),
						type = "toggle",
						name = L["ENABLE"],
						get = function()
							return PrC.db.profile.blizzard.character_frame.enabled
						end,
						set = function(_, value)
							PrC.db.profile.blizzard.character_frame.enabled = value

							if not BLIZZARD:HasCharacterFrame() then
								if value then
									BLIZZARD:SetUpCharacterFrame()
								end
							else
								if not value then
									CONFIG:ShowStaticPopup("RELOAD_UI")
								end
							end
						end,
					},
					reset = {
						type = "execute",
						order = inc(2),
						name = L["RESTORE_DEFAULTS"],
						confirm = CONFIG.ConfirmReset,
						func = function()
							CONFIG:CopySettings(D.profile.blizzard.character_frame, C.db.profile.blizzard.character_frame)

							BLIZZARD:UpadteCharacterFrame()
						end,
					},
					spacer_1 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					ilvl = {
						order = inc(2),
						type = "toggle",
						name = L["ILVL"],
					},
					enhancements = {
						order = inc(2),
						type = "toggle",
						name = L["ENCHANTS"],
					},
				},
			},
			digsite_bar = {
				order = inc(1),
				type = "group",
				name = L["DIGSITE_BAR"],
				disabled = isModuleDisabled,
				get = function(info)
					return C.db.profile.blizzard.digsite_bar[info[#info]]
				end,
				set = function(info, value)
					if C.db.profile.blizzard.digsite_bar[info[#info]] ~= value then
						C.db.profile.blizzard.digsite_bar[info[#info]] = value

						BLIZZARD:UpdateDigsiteBar()
					end
				end,
				args = {
					enabled = {
						order = reset(2),
						type = "toggle",
						name = L["ENABLE"],
						get = function()
							return PrC.db.profile.blizzard.digsite_bar.enabled
						end,
						set = function(_, value)
							PrC.db.profile.blizzard.digsite_bar.enabled = value

							if not BLIZZARD:HasDigsiteBar() then
								if value then
									BLIZZARD:SetUpDigsiteBar()
								end
							else
								if not value then
									CONFIG:ShowStaticPopup("RELOAD_UI")
								end
							end
						end,
					},
					reset = {
						type = "execute",
						order = inc(2),
						name = L["RESTORE_DEFAULTS"],
						confirm = CONFIG.ConfirmReset,
						func = function()
							CONFIG:CopySettings(D.profile.blizzard.digsite_bar, C.db.profile.blizzard.digsite_bar)

							BLIZZARD:UpdateDigsiteBar()
						end,
					},
					spacer_1 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					width = {
						order = inc(2),
						type = "range",
						name = L["WIDTH"],
						min = 128, max = 1024, step = 2,
					},
					height = {
						order = inc(2),
						type = "range",
						name = L["HEIGHT"],
						min = 8, max = 32, step = 4,
					},
					spacer_2 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					text = {
						order = inc(2),
						type = "group",
						name = L["TEXT"],
						inline = true,
						get = function(info)
							return C.db.profile.blizzard.digsite_bar[info[#info - 1]][info[#info]]
						end,
						set = function(info, value)
							if C.db.profile.blizzard.digsite_bar[info[#info - 1]][info[#info]] ~= value then
								C.db.profile.blizzard.digsite_bar[info[#info - 1]][info[#info]] = value

								BLIZZARD:UpdateDigsiteBar()
							end
						end,
						args = {
							size = {
								order = reset(3),
								type = "range",
								name = L["SIZE"],
								min = 8, max = 48, step = 1,
							},
						},
					},
				},
			},
			timer = {
				order = inc(1),
				type = "group",
				name = L["MIRROR_TIMER"],
				desc = L["MIRROR_TIMER_DESC"],
				disabled = isModuleDisabled,
				get = function(info)
					return C.db.profile.blizzard.timer[info[#info]]
				end,
				set = function(info, value)
					if C.db.profile.blizzard.timer[info[#info]] ~= value then
						C.db.profile.blizzard.timer[info[#info]] = value

						BLIZZARD:UpdateMirrorTimers()
					end
				end,
				args = {
					enabled = {
						order = reset(2),
						type = "toggle",
						name = L["ENABLE"],
						get = function()
							return PrC.db.profile.blizzard.timer.enabled
						end,
						set = function(_, value)
							PrC.db.profile.blizzard.timer.enabled = value

							if not BLIZZARD:HasMirrorTimer() then
								if value then
									BLIZZARD:SetUpMirrorTimers()
								end
							else
								if not value then
									CONFIG:ShowStaticPopup("RELOAD_UI")
								end
							end
						end,
					},
					reset = {
						order = inc(2),
						type = "execute",
						name = L["RESTORE_DEFAULTS"],
						confirm = CONFIG.ConfirmReset,
						func = function()
							CONFIG:CopySettings(D.profile.blizzard.timer, C.db.profile.blizzard.timer)

							BLIZZARD:UpdateMirrorTimers()
						end,
					},
					spacer_1 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					width = {
						order = inc(2),
						type = "range",
						name = L["WIDTH"],
						min = 128, max = 1024, step = 2,
					},
					height = {
						order = inc(2),
						type = "range",
						name = L["HEIGHT"],
						min = 8, max = 32, step = 4,
					},
					spacer_2 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					text = {
						order = inc(2),
						type = "group",
						name = L["TEXT"],
						inline = true,
						get = function(info)
							return C.db.profile.blizzard.timer[info[#info - 1]][info[#info]]
						end,
						set = function(info, value)
							if C.db.profile.blizzard.timer[info[#info - 1]][info[#info]] ~= value then
								C.db.profile.blizzard.timer[info[#info - 1]][info[#info]] = value

								BLIZZARD:UpdateMirrorTimers()
							end
						end,
						args = {
							size = {
								order = reset(3),
								type = "range",
								name = L["SIZE"],
								min = 8, max = 48, step = 1,
							},
						},
					},
				},
			},
			objective_tracker = {
				order = inc(1),
				type = "group",
				name = L["OBJECTIVE_TRACKER"],
				disabled = isModuleDisabled,
				args = {
					enabled = {
						order = reset(2),
						type = "toggle",
						name = L["ENABLE"],
						get = function()
							return PrC.db.profile.blizzard.objective_tracker.enabled
						end,
						set = function(_, value)
							PrC.db.profile.blizzard.objective_tracker.enabled = value

							if not BLIZZARD:HasObjectiveTracker() then
								if value then
									BLIZZARD:SetUpObjectiveTracker()
								end
							else
								if not value then
									CONFIG:ShowStaticPopup("RELOAD_UI")
								end
							end
						end,
					},
					reset = {
						type = "execute",
						order = inc(2),
						name = L["RESTORE_DEFAULTS"],
						confirm = CONFIG.ConfirmReset,
						func = function()
							CONFIG:CopySettings(D.profile.blizzard.objective_tracker, C.db.profile.blizzard.objective_tracker)

							BLIZZARD:UpdateObjectiveTracker()
						end,
					},
					spacer_1 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					height = {
						order = inc(2),
						type = "range",
						name = L["HEIGHT"],
						disabled = function()
							return not BLIZZARD:HasObjectiveTracker()
						end,
						min = 400, max = 1000, step = 2,
						get = function()
							return C.db.profile.blizzard.objective_tracker.height
						end,
						set = function(_, value)
							C.db.profile.blizzard.objective_tracker.height = value

							BLIZZARD:UpdateObjectiveTracker()
						end,
					},
					drag_key = {
						order = inc(2),
						type = "select",
						name = L["DRAG_KEY"],
						values = DRAG_KEYS,
						get = function()
							return DRAG_KEY_INDICES[C.db.profile.blizzard.objective_tracker.drag_key]
						end,
						set = function(_, value)
							C.db.profile.blizzard.objective_tracker.drag_key = DRAG_KEY_VALUES[value]
						end,
					},
				},
			},
			talking_head = {
				order = inc(1),
				type = "group",
				name = L["TALKING_HEAD_FRAME"],
				disabled = isModuleDisabled,
				get = function(info)
					return C.db.profile.blizzard.talking_head[info[#info]]
				end,
				set = function(info, value)
					C.db.profile.blizzard.talking_head[info[#info]] = value
				end,
				args = {
					enabled = {
						order = reset(2),
						type = "toggle",
						name = L["ENABLE"],
						get = function()
							return PrC.db.profile.blizzard.talking_head.enabled
						end,
						set = function(_, value)
							PrC.db.profile.blizzard.talking_head.enabled = value

							if not BLIZZARD:HasTalkingHead() then
								if value then
									BLIZZARD:SetUpTalkingHead()
								end
							else
								if not value then
									CONFIG:ShowStaticPopup("RELOAD_UI")
								end
							end
						end,
					},
					reset = {
						type = "execute",
						order = inc(2),
						name = L["RESTORE_DEFAULTS"],
						confirm = CONFIG.ConfirmReset,
						func = function()
							CONFIG:CopySettings(D.profile.blizzard.talking_head, C.db.profile.blizzard.talking_head)
						end,
					},
					spacer_1 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					hide = {
						order = inc(2),
						type = "toggle",
						name = L["HIDE"],
					},
				},
			},
		},
	}
end
