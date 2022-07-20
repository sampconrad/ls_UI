local _, CONFIG = ...

-- Lua
local _G = getfenv(0)
local unpack = _G.unpack

-- Mine
local E, M, L, C, D, PrC, PrD, P, oUF = unpack(ls_UI)
local BARS = P:GetModule("Bars")

local orders = {}

local function reset(order, v)
	orders[order] = v or 1
	return orders[order]
end

local function inc(order)
	orders[order] = orders[order] + 1
	return orders[order]
end


local INDICATORS = {
	["button"] = L["ICON"],
	["hotkey"] = L["KEYBIND_TEXT"],
}

local FORMATS = {
	["NUM"] = L["NUMERIC"],
	["NUM_PERC"] = L["NUMERIC_PERCENTAGE"]
}

local VISIBILITY = {
	[1] = L["ALWAYS_SHOW"],
	[2] = L["SHOW_ON_MOUSEOVER"],
}

local function isModuleDisabled()
	return not BARS:IsInit()
end

local function isXPBarDisabled()
	return not BARS:HasXPBar()
end

local function isXPBarDisabledOrRestricted()
	return BARS:IsRestricted() or not BARS:HasXPBar()
end

local function isModuleDisabledOrRestricted()
	return BARS:IsRestricted() or not BARS:IsInit()
end

function CONFIG:CreateActionBarsOptions(order)
	self.options.args.bars = {
		order = order,
		type = "group",
		name = L["ACTION_BARS"],
		childGroups = "tree",
		get = function(info)
			return C.db.profile.bars[info[#info]]
		end,
		set = function(info, value)
			if C.db.profile.bars[info[#info]] ~= value then
				C.db.profile.bars[info[#info]] = value
				BARS:ForEach("UpdateConfig")
				BARS:ForEach("UpdateButtonConfig")
			end
		end,
		args = {
			enabled = {
				order = reset(1),
				type = "toggle",
				name = L["ENABLE"],
				get = function()
					return PrC.db.profile.bars.enabled
				end,
				set = function(_, value)
					PrC.db.profile.bars.enabled = value

					if BARS:IsInit() then
						if not value then
							CONFIG:ShowStaticPopup("RELOAD_UI")
						end
					else
						if value then
							P:Call(BARS.Init, BARS)
						end
					end
				end,
			},
			restricted = {
				order = inc(1),
				type = "toggle",
				name = L["RESTRICTED_MODE"],
				desc = L["RESTRICTED_MODE_DESC"],
				get = function()
					return PrC.db.profile.bars.restricted
				end,
				set = function(_, value)
					PrC.db.profile.bars.restricted = value

					if BARS:IsInit() then
						CONFIG:ShowStaticPopup("RELOAD_UI")
					end
				end,
			},
			blizz_vehicle = {
				order = inc(1),
				type = "toggle",
				name = L["USE_BLIZZARD_VEHICLE_UI"],
				disabled = isModuleDisabledOrRestricted,
				set = function(_, value)
					C.db.profile.bars.blizz_vehicle = value

					if BARS:IsInit() then
						BARS:UpdateBlizzVehicle()
					end
				end,
			},
			spacer_1 = {
				order = inc(1),
				type = "description",
				name = " ",
			},
			lock = {
				order = inc(1),
				type = "toggle",
				name = L["LOCK_BUTTONS"],
				desc = L["LOCK_BUTTONS_DESC"],
				disabled = isModuleDisabled,
				set = function(_, value)
					C.db.profile.bars.lock = value
					BARS:ForEach("UpdateConfig")
					BARS:ForEach("UpdateButtonConfig")

					SetCVar("lockActionBars", value and 1 or 0)
				end,
			},
			rightclick_selfcast = {
				order = inc(1),
				type = "toggle",
				name = L["RCLICK_SELFCAST"],
				disabled = isModuleDisabled,
			},
			click_on_down = {
				order = inc(1),
				type = "toggle",
				name = L["CAST_ON_KEY_DOWN"],
				desc = L["CAST_ON_KEY_DOWN_DESC"],
				disabled = isModuleDisabled,
				set = function(_, value)
					C.db.profile.bars.click_on_down = value
					BARS:ForEach("UpdateConfig")
					BARS:ForEach("UpdateButtonConfig")

					SetCVar("ActionButtonUseKeyDown", value and 1 or 0)
				end,
			},
			range_indicator = {
				order = inc(1),
				type = "select",
				name = L["OOR_INDICATOR"],
				values = INDICATORS,
				disabled = isModuleDisabled,
			},
			mana_indicator = {
				order = inc(1),
				type = "select",
				name = L["OOM_INDICATOR"],
				values = INDICATORS,
				disabled = isModuleDisabled,
			},
			spacer_2 = {
				order = inc(1),
				type = "description",
				name = " ",
			},
			desaturation = {
				order = inc(1),
				type = "group",
				name = L["DESATURATION"],
				inline = true,
				disabled = isModuleDisabled,
				get = function(info)
					return C.db.profile.bars.desaturation[info[#info]]
				end,
				set = function(info, value)
					if C.db.profile.bars.desaturation[info[#info]] ~= value then
						C.db.profile.bars.desaturation[info[#info]] = value
						BARS:ForEach("UpdateConfig")
						BARS:ForEach("UpdateButtonConfig")
					end
				end,
				args = {
					unusable = {
						order = reset(2),
						type = "toggle",
						name = L["UNUSABLE"],
					},
					mana = {
						order = inc(2),
						type = "toggle",
						name = L["OOM"],
					},
					range = {
						order = inc(2),
						type = "toggle",
						name = L["OOR"],
					},
				},
			},
			spacer_3 = {
				order = inc(1),
				type = "description",
				name = " ",
			},
			cooldown = {
				order = inc(1),
				type = "group",
				name = L["COOLDOWN"],
				inline = true,
				disabled = isModuleDisabled,
				get = function(info)
					return C.db.profile.bars.cooldown[info[#info]]
				end,
				set = function(info, value)
					if C.db.profile.bars.cooldown[info[#info]] ~= value then
						C.db.profile.bars.cooldown[info[#info]] = value
						BARS:ForEach("UpdateConfig")
						BARS:ForEach("UpdateCooldownConfig")
					end
				end,
				args = {
					reset = {
						type = "execute",
						order = reset(1),
						name = L["RESTORE_DEFAULTS"],
						confirm = CONFIG.ConfirmReset,
						func = function()
							CONFIG:CopySettings(D.profile.bars.cooldown, C.db.profile.bars.cooldown)
							BARS:ForEach("UpdateConfig")
							BARS:ForEach("UpdateCooldownConfig")
						end,
					},
					spacer_1 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					exp_threshold = {
						order = inc(2),
						type = "range",
						name = L["EXP_THRESHOLD"],
						min = 1, max = 10, step = 1,
					},
					m_ss_threshold = {
						order = inc(2),
						type = "range",
						name = L["M_SS_THRESHOLD"],
						desc = L["M_SS_THRESHOLD_DESC"],
						min = 0, max = 3599, step = 1,
						softMin = 91,
						set = function(info, value)
							if C.db.profile.bars.cooldown[info[#info]] ~= value then
								if value < info.option.softMin then
									value = info.option.min
								end

								C.db.profile.bars.cooldown[info[#info]] = value
								BARS:ForEach("UpdateConfig")
								BARS:ForEach("UpdateCooldownConfig")
							end
						end,
					},
					s_ms_threshold = {
						order = inc(2),
						type = "range",
						name = L["S_MS_THRESHOLD"],
						desc = L["S_MS_THRESHOLD_DESC"],
						min = 1, max = 10, step = 1,
						set = function(info, value)
							if C.db.profile.bars.cooldown[info[#info]] ~= value then
								C.db.profile.bars.cooldown[info[#info]] = value
								BARS:ForEach("UpdateConfig")
								BARS:ForEach("UpdateCooldownConfig")
							end
						end,
					},
					spacer_2 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					swipe = {
						order = inc(2),
						type = "group",
						name = L["COOLDOWN_SWIPE"],
						inline = true,
						get = function(info)
							return C.db.profile.bars.cooldown.swipe[info[#info]]
						end,
						set = function(info, value)
							if C.db.profile.bars.cooldown.swipe[info[#info]] ~= value then
								C.db.profile.bars.cooldown.swipe[info[#info]] = value
								BARS:ForEach("UpdateConfig")
								BARS:ForEach("UpdateCooldownConfig")
							end
						end,
						args = {
							enabled = {
								order = reset(3),
								type = "toggle",
								name = L["SHOW"],
							},
							reversed = {
								order = inc(3),
								type = "toggle",
								disabled = function()
									return not C.db.profile.bars.cooldown.swipe.enabled
								end,
								name = L["REVERSE"],
							},
						},
					},
				},
			},
			action_bar_1 = CONFIG:CreateBarOptions(inc(1), "bar1", L["BAR_1"]),
			action_bar_2 = CONFIG:CreateBarOptions(inc(1), "bar2", L["BAR_2"]),
			action_bar_3 = CONFIG:CreateBarOptions(inc(1), "bar3", L["BAR_3"]),
			action_bar_4 = CONFIG:CreateBarOptions(inc(1), "bar4", L["BAR_4"]),
			action_bar_5 = CONFIG:CreateBarOptions(inc(1), "bar5", L["BAR_5"]),
			action_bar_6 = CONFIG:CreateBarOptions(inc(1), "bar6", L["PET_BAR"]),
			action_bar_7 = CONFIG:CreateBarOptions(inc(1), "bar7", L["STANCE_BAR"]),
			pet_battle = CONFIG:CreateBarOptions(inc(1), "pet_battle", L["PET_BATTLE_BAR"]),
			extra = CONFIG:CreateExtraBarOptions(inc(1), "extra", L["EXTRA_ACTION_BUTTON"]),
			zone = CONFIG:CreateExtraBarOptions(inc(1), "zone", L["ZONE_ABILITY_BUTTON"]),
			vehicle = {
				order = inc(1),
				type = "group",
				childGroups = "select",
				name = L["VEHICLE_EXIT_BUTTON"],
				disabled = isModuleDisabled,
				get = function(info)
					return C.db.profile.bars.vehicle[info[#info]]
				end,
				set = function(info, value)
					if C.db.profile.bars.vehicle[info[#info]] ~= value then
						C.db.profile.bars.vehicle[info[#info]] = value

						BARS:GetBar("vehicle"):Update()
					end
				end,
				args = {
					reset = {
						type = "execute",
						order = reset(2),
						name = L["RESTORE_DEFAULTS"],
						confirm = CONFIG.ConfirmReset,
						func = function()
							CONFIG:CopySettings(D.profile.bars.vehicle, C.db.profile.bars.vehicle, {visible = true, point = true})
							BARS:GetBar("vehicle"):Update()
						end,
					},
					spacer_1 = {
						order =inc(2),
						type = "description",
						name = " ",
					},
					visible = {
						order = inc(2),
						type = "toggle",
						name = L["SHOW"],
						set = function(_, value)
							C.db.profile.bars.vehicle.visible = value

							BARS:GetBar("vehicle"):UpdateConfig()
							BARS:GetBar("vehicle"):UpdateFading()
							BARS:GetBar("vehicle"):UpdateVisibility()
						end
					},
					width = {
						order = inc(2),
						type = "range",
						name = L["WIDTH"],
						min = 16, max = 64, step = 1,
					},
					height = {
						order = inc(2),
						type = "range",
						name = L["HEIGHT"],
						desc = L["HEIGHT_OVERRIDE_DESC"],
						min = 0, max = 64, step = 1,
						softMin = 16,
						set = function(info, value)
							if C.db.profile.bars.vehicle.height ~= value then
								if value < info.option.softMin then
									value = info.option.min
								end
							end

							C.db.profile.bars.vehicle.height = value

							BARS:GetBar("vehicle"):Update()
						end,
					},
					spacer_2 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					fading = CONFIG:CreateBarFadingOptions(inc(2), "vehicle"),
				},
			},
			micromenu = CONFIG:CreateMicroMenuOptions(inc(1)),
			xpbar = {
				order = inc(1),
				type = "group",
				childGroups = "select",
				name = L["XP_BAR"],
				get = function(info)
					return C.db.profile.bars.xpbar[info[#info]]
				end,
				args = {
					enabled = {
						order = reset(2),
						type = "toggle",
						name = L["ENABLE"],
						disabled = isModuleDisabledOrRestricted,
						get = function()
							return PrC.db.profile.bars.xpbar.enabled
						end,
						set = function(_, value)
							PrC.db.profile.bars.xpbar.enabled = value

							if BARS:IsInit() then
								if BARS:HasXPBar() then
									if not value then
										CONFIG:ShowStaticPopup("RELOAD_UI")
									end
								else
									if value then
										BARS:CreateXPBar()
									end
								end
							end
						end,
					},
					reset = {
						type = "execute",
						order = inc(2),
						name = L["RESTORE_DEFAULTS"],
						disabled = isXPBarDisabledOrRestricted,
						confirm = CONFIG.ConfirmReset,
						func = function()
							CONFIG:CopySettings(D.profile.bars.xpbar, C.db.profile.bars.xpbar, {point = true})
							BARS:GetBar("xpbar"):Update()
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
						min = 530, max = 1900, step = 2,
						disabled = isXPBarDisabledOrRestricted,
						set = function(info, value)
							if C.db.profile.bars.xpbar[info[#info]] ~= value then
								C.db.profile.bars.xpbar[info[#info]] = value

								BARS:GetBar("xpbar"):UpdateConfig()
								BARS:GetBar("xpbar"):UpdateSize(value, C.db.profile.bars.xpbar.height)
							end
						end,
					},
					height = {
						order = inc(2),
						type = "range",
						name = L["HEIGHT"],
						min = 8, max = 32, step = 4,
						disabled = isXPBarDisabledOrRestricted,
						set = function(info, value)
							if C.db.profile.bars.xpbar[info[#info]] ~= value then
								C.db.profile.bars.xpbar[info[#info]] = value

								BARS:GetBar("xpbar"):UpdateConfig()
								BARS:GetBar("xpbar"):UpdateSize(C.db.profile.bars.xpbar.width, value)
							end
						end,
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
						disabled = isXPBarDisabled,
						get = function(info)
							return C.db.profile.bars.xpbar.text[info[#info]]
						end,
						set = function(info, value)
							if C.db.profile.bars.xpbar.text[info[#info]] ~= value then
								C.db.profile.bars.xpbar.text[info[#info]] = value

								BARS:ForBar("xpbar", "UpdateConfig")
								BARS:ForBar("xpbar", "UpdateFont")
							end
						end,
						args = {
							size = {
								order = reset(3),
								type = "range",
								name = L["SIZE"],
								min = 8, max = 32, step = 1,
							},
							format = {
								order = inc(3),
								type = "select",
								name = L["FORMAT"],
								values = FORMATS,
								set = function(info, value)
									if C.db.profile.bars.xpbar.text[info[#info]] ~= value then
										C.db.profile.bars.xpbar.text[info[#info]] = value

										BARS:ForBar("xpbar", "UpdateConfig")
										BARS:ForBar("xpbar", "UpdateTextFormat")
										BARS:ForBar("xpbar", "ForEach", "UpdateText")
									end
								end,
							},
							visibility = {
								order = inc(3),
								type = "select",
								name = L["VISIBILITY"],
								values = VISIBILITY,
								set = function(info, value)
									if C.db.profile.bars.xpbar.text[info[#info]] ~= value then
										C.db.profile.bars.xpbar.text[info[#info]] = value

										BARS:ForBar("xpbar", "UpdateConfig")
										BARS:ForBar("xpbar", "UpdateTextVisibility")
									end
								end,
							},
						},
					},
					spacer_3 = {
						order = inc(2),
						type = "description",
						name = " ",
					},
					fading = CONFIG:CreateBarFadingOptions(inc(2), "xpbar"),
				},
			},
		},
	}
end
