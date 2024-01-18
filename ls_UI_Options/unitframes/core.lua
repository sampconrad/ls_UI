-- Lua
local _G = getfenv(0)
local s_split = _G.string.split
local unpack = _G.unpack

-- Mine
local E, M, L, C, D, PrC, PrD, P, oUF, CONFIG = unpack(ls_UI)
local UNITFRAMES = P:GetModule("UnitFrames")

local function isModuleDisabled()
	return not UNITFRAMES:IsInit()
end

local function isPlayerFrameDisabled()
	return not UNITFRAMES:HasPlayerFrame()
end

local function isTargetFrameDisabled()
	return not UNITFRAMES:HasTargetFrame()
end

local function isFocusFrameDisabled()
	return not UNITFRAMES:HasFocusFrame()
end

local function isBossFrameDisabled()
	return not UNITFRAMES:HasBossFrame()
end

local function isPartyFrameDisabled()
	return not UNITFRAMES:HasPartyFrame()
end

local function isOCCEnabled()
	return E.OMNICC
end

local function getUnitFrameOptions(order, unit, name)
	local copyIgnoredUnits = {
		[unit] = true,
	}

	local temp = {
		order = order,
		type = "group",
		childGroups = "tab",
		name = name,
		args = {
			enabled = {
				order = 1,
				type = "toggle",
				name = L["ENABLE"],
				get = function()
					return C.db.profile.units[unit].enabled
				end,
				set = function(_, value)
					C.db.profile.units[unit].enabled = value

					UNITFRAMES:For(unit, "Update")
				end,
			}, -- 1
			copy = {
				order = 2,
				type = "select",
				name = L["COPY_FROM"],
				desc = L["COPY_FROM_DESC"],
				values = function()
					return UNITFRAMES:GetUnits(copyIgnoredUnits)
				end,
				get = function() end,
				set = function(_, value)
					CONFIG:CopySettings(C.db.profile.units[value], C.db.profile.units[unit], {["blizz_enabled"] = true})
					UNITFRAMES:For(unit, "Update")
				end,
			}, -- 2
			reset = {
				order = 3,
				type = "execute",
				name = L["RESTORE_DEFAULTS"],
				confirm = CONFIG.ConfirmReset,
				func = function()
					CONFIG:CopySettings(D.profile.units[unit], C.db.profile.units[unit])
					UNITFRAMES:For(unit, "Update")
				end,
			}, -- 3
			spacer_1 = {
				order = 4,
				type = "description",
				name = " ",
			}, -- 4
			width = {
				order = 5,
				type = "range",
				name = L["WIDTH"],
				min = 96, max = 512, step = 2,
				get = function()
					return C.db.profile.units[unit].width
				end,
				set = function(_, value)
					if C.db.profile.units[unit].width ~= value then
						C.db.profile.units[unit].width = value

						UNITFRAMES:For(unit, "Update")
					end
				end,
			}, -- 5
			height = {
				order = 6,
				type = "range",
				name = L["HEIGHT"],
				min = 28, max = 256, step = 2,
				get = function()
					return C.db.profile.units[unit].height
				end,
				set = function(_, value)
					if C.db.profile.units[unit].height ~= value then
						C.db.profile.units[unit].height = value

						UNITFRAMES:For(unit, "Update")
					end
				end,
			}, -- 6
			top_inset = {
				order = 7,
				type = "range",
				name = L["TOP_INSET_SIZE"],
				desc = L["TOP_INSET_SIZE_DESC"],
				min = 0.01, max = 0.33, step = 0.01,
				isPercent = true,
				get = function()
					return C.db.profile.units[unit].insets.t_size
				end,
				set = function(_, value)
					if C.db.profile.units[unit].insets.t_size ~= value then
						C.db.profile.units[unit].insets.t_size = value

						UNITFRAMES:For(unit, "UpdateLayout")
					end
				end,
			}, -- 7
			bottom_inset = {
				order = 8,
				type = "range",
				name = L["BOTTOM_INSET_SIZE"],
				desc = L["BOTTOM_INSET_SIZE_DESC"],
				min = 0.01, max = 0.5, step = 0.01,
				isPercent = true,
				get = function()
					return C.db.profile.units[unit].insets.b_size
				end,
				set = function(_, value)
					if C.db.profile.units[unit].insets.b_size ~= value then
						C.db.profile.units[unit].insets.b_size = value

						UNITFRAMES:For(unit, "UpdateLayout")
					end
				end,
			}, -- 8
			-- per_row = {}, -- 9
			-- spacing = {}, -- 10
			-- growth_dir = {}, -- 11
			threat = {
				order = 13,
				type = "toggle",
				name = L["THREAT_GLOW"],
				get = function()
					return C.db.profile.units[unit].threat.enabled
				end,
				set = function(_, value)
					C.db.profile.units[unit].threat.enabled = value

					UNITFRAMES:For(unit, "UpdateThreatIndicator")
				end,
			}, -- 13
			pvp = {
				order = 14,
				type = "toggle",
				name = L["PVP_ICON"],
				get = function()
					return C.db.profile.units[unit].pvp.enabled
				end,
				set = function(_, value)
					C.db.profile.units[unit].pvp.enabled = value

					UNITFRAMES:For(unit, "UpdatePvPIndicator")
				end,
			}, -- 14
			status = {
				order = 15,
				type = "toggle",
				name = L["STATUS_ICONS"],
				get = function()
					return C.db.profile.units[unit].status.enabled
				end,
				set = function(_, value)
					C.db.profile.units[unit].status.enabled = value

					UNITFRAMES:For(unit, "UpdateConfig")
					UNITFRAMES:For(unit, "UpdateStatus")
				end,
			}, -- 15
			mirror_widgets = {
				order = 16,
				type = "toggle",
				name = L["MIRROR_WIDGETS"],
				desc = L["MIRROR_WIDGETS_DESC"],
				get = function()
					return C.db.profile.units[unit].mirror_widgets
				end,
				set = function(_, value)
					C.db.profile.units[unit].mirror_widgets = value

					UNITFRAMES:For(unit, "UpdateConfig")
					UNITFRAMES:For(unit, "AlignWidgets")
				end,
			}, -- 16
			spacer_2 = {
				order = 20,
				type = "description",
				name = " ",
			}, -- 20
			border = {
				order = 21,
				type = "group",
				name = L["BORDER_COLOR"],
				inline = true,
				get = function(info)
					return C.db.profile.units[unit].border.color[info[#info]]
				end,
				set = function(info, value)
					C.db.profile.units[unit].border.color[info[#info]] = value

					UNITFRAMES:For(unit, "UpdateClassIndicator")
				end,
				args = {
					class = {
						order = 1,
						type = "toggle",
						name = L["CLASS"],
					},
					reaction = {
						order = 2,
						type = "toggle",
						name = L["REACTION"],
					},
				},
			}, -- 21
			spacer_4 = {
				order = 30,
				type = "description",
				name = " ",
			}, -- 30
			health = CONFIG:CreateUnitFrameHealthOptions(31, unit),
			power = CONFIG:CreateUnitFramePowerOptions(32, unit),
			-- alt_power = {}, -- 33
			-- class_power = {}, -- 33
			-- castbar = {}, -- 34
			-- auras = {}, -- 35
			portrait = CONFIG:CreateUnitFramePortraitOptions(36, unit),
			raid_target = CONFIG:CreateUnitFrameRaidTargetOptions(37, unit),
			name = CONFIG:CreateUnitFrameNameOptions(38, unit),
			debuff = CONFIG:CreateUnitFrameDebuffIconsOptions(39, unit),
			-- custom_texts = {}, -- 40
			fading = CONFIG:CreateUnitFrameFadingOptions(41, unit)
		},
	}

	if unit == "player" then
		temp.disabled = isPlayerFrameDisabled
		temp.args.class_power = CONFIG:CreateUnitFrameClassPowerOptions(33, unit)
		temp.args.castbar = CONFIG:CreateUnitFrameCastbarOptions(34, unit)
		temp.args.custom_texts = CONFIG:CreateUnitFrameCustomTextsOptions(40, unit)
		temp.args.auras = CONFIG:CreateUnitFrameAurasOptions(35, unit)
	elseif unit == "pet" then
		temp.disabled = isPlayerFrameDisabled
		temp.args.castbar = CONFIG:CreateUnitFrameCastbarOptions(34, unit)
		temp.args.auras = CONFIG:CreateUnitFrameAurasOptions(35, unit)
		temp.args.custom_texts = CONFIG:CreateUnitFrameCustomTextsOptions(40, unit)
		temp.args.pvp = nil
		temp.args.status = nil
		temp.args.mirror_widgets = nil
	elseif unit == "target" then
		temp.disabled = isTargetFrameDisabled
		temp.args.castbar = CONFIG:CreateUnitFrameCastbarOptions(34, unit)
		temp.args.auras = CONFIG:CreateUnitFrameAurasOptions(35, unit)
		temp.args.custom_texts = CONFIG:CreateUnitFrameCustomTextsOptions(40, unit)
	elseif unit == "targettarget" then
		temp.disabled = isTargetFrameDisabled
		temp.args.debuff = nil
		temp.args.pvp = nil
		temp.args.mirror_widgets = nil
	elseif unit == "focus" then
		temp.disabled = isFocusFrameDisabled
		temp.args.castbar = CONFIG:CreateUnitFrameCastbarOptions(34, unit)
		temp.args.auras = CONFIG:CreateUnitFrameAurasOptions(35, unit)
		temp.args.custom_texts = CONFIG:CreateUnitFrameCustomTextsOptions(40, unit)
	elseif unit == "focustarget" then
		temp.disabled = isFocusFrameDisabled
		temp.args.debuff = nil
		temp.args.pvp = nil
		temp.args.mirror_widgets = nil
	elseif unit == "boss" then
		temp.disabled = isBossFrameDisabled
		temp.args.alt_power = CONFIG:CreateUnitFrameAltPowerOptions(33, unit)
		temp.args.castbar = CONFIG:CreateUnitFrameCastbarOptions(34, unit)
		temp.args.auras = CONFIG:CreateUnitFrameAurasOptions(35, unit)
		temp.args.custom_texts = CONFIG:CreateUnitFrameCustomTextsOptions(40, unit)
		temp.args.pvp = nil
		temp.args.status = nil
		temp.args.mirror_widgets = nil

		temp.args.per_row = {
			order = 10,
			type = "range",
			name = L["PER_ROW"],
			min = 1, max = 5, step = 1,
			get = function()
				return C.db.profile.units[unit].per_row
			end,
			set = function(_, value)
				if C.db.profile.units[unit].per_row ~= value then
					C.db.profile.units[unit].per_row = value

					UNITFRAMES:UpdateBossHolder()
				end
			end,
		}

		temp.args.spacing = {
			order = 11,
			type = "range",
			name = L["SPACING"],
			min = 8, max = 64, step = 2,
			get = function()
				return C.db.profile.units[unit].spacing
			end,
			set = function(_, value)
				if C.db.profile.units[unit].spacing ~= value then
					C.db.profile.units[unit].spacing = value

					UNITFRAMES:UpdateBossHolder()
				end
			end,
		}

		temp.args.growth_dir = {
			order = 12,
			type = "select",
			name = L["GROWTH_DIR"],
			values = CONFIG.GROWTH_DIRS,
			get = function()
				return C.db.profile.units[unit].x_growth .. "_" .. C.db.profile.units[unit].y_growth
			end,
			set = function(_, value)
				C.db.profile.units[unit].x_growth, C.db.profile.units[unit].y_growth = s_split("_", value)

				UNITFRAMES:UpdateBossHolder()
			end,
		}
	elseif unit == "party" then
		temp.disabled = isPartyFrameDisabled
		temp.args.castbar = CONFIG:CreateUnitFrameCastbarOptions(34, unit)
		temp.args.auras = CONFIG:CreateUnitFrameAurasOptions(35, unit)
		temp.args.custom_texts = CONFIG:CreateUnitFrameCustomTextsOptions(40, unit)

		temp.args.per_row = {
			order = 10,
			type = "range",
			name = L["PER_ROW"],
			min = 1, max = 5, step = 1,
			get = function()
				return C.db.profile.units[unit].per_row
			end,
			set = function(_, value)
				if C.db.profile.units[unit].per_row ~= value then
					C.db.profile.units[unit].per_row = value

					UNITFRAMES:UpdatePartyHolder()
				end
			end,
		}

		temp.args.spacing = {
			order = 11,
			type = "range",
			name = L["SPACING"],
			min = 8, max = 64, step = 2,
			get = function()
				return C.db.profile.units[unit].spacing
			end,
			set = function(_, value)
				if C.db.profile.units[unit].spacing ~= value then
					C.db.profile.units[unit].spacing = value

					UNITFRAMES:UpdatePartyHolder()
				end
			end,
		}

		temp.args.growth_dir = {
			order = 12,
			type = "select",
			name = L["GROWTH_DIR"],
			values = CONFIG.GROWTH_DIRS,
			get = function()
				return C.db.profile.units[unit].x_growth .. "_" .. C.db.profile.units[unit].y_growth
			end,
			set = function(_, value)
				C.db.profile.units[unit].x_growth, C.db.profile.units[unit].y_growth = s_split("_", value)

				UNITFRAMES:UpdatePartyHolder()
			end,
		}
	end

	return temp
end

function CONFIG:CreateUnitFramesOptions(order)
	self.options.args.unitframes = {
		order = order,
		type = "group",
		name = L["UNIT_FRAME"],
		childGroups = "tree",
		args = {
			enabled = {
				order = 1,
				type = "toggle",
				name = L["ENABLE"],
				get = function()
					return PrC.db.profile.units.enabled
				end,
				set = function(_, value)
					PrC.db.profile.units.enabled = value

					if UNITFRAMES:IsInit() then
						if not value then
							CONFIG:ShowStaticPopup("RELOAD_UI")
						end
					else
						if value then
							P:Call(UNITFRAMES.Init, UNITFRAMES)
						end
					end
				end,
			}, -- 1
			spacer_1 = {
				order = 2,
				type = "description",
				name = " ",
			}, -- 2
			units = {
				order = 3,
				type = "group",
				name = L["UNITS"],
				inline = true,
				disabled = isModuleDisabled,
				get = function(info)
					return PrC.db.profile.units[info[#info]].enabled
				end,
				set = function(info, value)
					PrC.db.profile.units[info[#info]].enabled = value

					if UNITFRAMES:IsInit() then
						if value then
							if info[#info] == "player" then
								UNITFRAMES:Create("player")
								UNITFRAMES:For("player", "Update")

								UNITFRAMES:Create("pet")
								UNITFRAMES:For("pet", "Update")
							elseif info[#info] == "target" then
								UNITFRAMES:Create("target")
								UNITFRAMES:For("target", "Update")

								UNITFRAMES:Create("targettarget")
								UNITFRAMES:For("targettarget", "Update")
							elseif info[#info] == "focus" then
								UNITFRAMES:Create("focus")
								UNITFRAMES:For("focus", "Update")

								UNITFRAMES:Create("focustarget")
								UNITFRAMES:For("focustarget", "Update")
							elseif info[#info] == "party" then
								UNITFRAMES:Create("party")
								UNITFRAMES:For("party", "Update")
							else
								UNITFRAMES:Create("boss")
								UNITFRAMES:For("boss", "Update")
							end
						else
							CONFIG:ShowStaticPopup("RELOAD_UI")
						end
					end
				end,
				args = {
					player = {
						order = 1,
						type = "toggle",
						name = L["PLAYER_PET"],
					},
					target = {
						order = 2,
						type = "toggle",
						name = L["TARGET_TOT"],
					},
					focus = {
						order = 3,
						type = "toggle",
						name = L["FOCUS_TOF"],
					},
					boss = {
						order = 4,
						type = "toggle",
						name = L["BOSS"],
					},
					party = {
						order = 5,
						type = "toggle",
						name = L["PARTY"],
					},
				},
			}, -- 3
			spacer_2 = {
				order = 4,
				type = "description",
				name = " ",
			}, -- 4
			gloss = {
				order = 5,
				type = "range",
				name = L["GLOSS"],
				disabled = isModuleDisabled,
				min = 0, max = 1, step = 0.05,
				isPercent = true,
				get = function()
					return C.db.profile.units.inlay.alpha
				end,
				set = function(_, value)
					if C.db.profile.units.inlay.alpha ~= value then
						C.db.profile.units.inlay.alpha = value

						UNITFRAMES:ForEach("UpdateInlay")
					end
				end,
			}, -- 5
			spacer_3 = {
				order = 6,
				type = "description",
				name = " ",
			}, -- 6
			change = {
				order = 7,
				type = "group",
				name = L["PROGRESS_BARS"],
				inline = true,
				disabled = isModuleDisabled,
				get = function(info)
					return C.db.profile.units.change[info[#info]]
				end,
				set = function(info, value)
					if C.db.profile.units.change[info[#info]] ~= value then
						C.db.profile.units.change[info[#info]] = value

						UNITFRAMES:ForEach("For", "Health", "UpdateConfig")
						UNITFRAMES:ForEach("For", "Health", "UpdateSmoothing")

						UNITFRAMES:ForEach("For", "HealthPrediction", "UpdateSmoothing")
						UNITFRAMES:ForEach("For", "HealthPrediction", "UpdateSmoothing")

						UNITFRAMES:ForEach("For", "Power", "UpdateConfig")
						UNITFRAMES:ForEach("For", "Power", "UpdateSmoothing")

						UNITFRAMES:ForEach("For", "AdditionalPower", "UpdateConfig")
						UNITFRAMES:ForEach("For", "AdditionalPower", "UpdateSmoothing")

						UNITFRAMES:ForEach("For", "AlternativePower", "UpdateConfig")
						UNITFRAMES:ForEach("For", "AlternativePower", "UpdateSmoothing")

						UNITFRAMES:ForEach("For", "Stagger", "UpdateConfig")
						UNITFRAMES:ForEach("For", "Stagger", "UpdateSmoothing")
					end
				end,
				args = {
					smooth = {
						order = 1,
						type = "toggle",
						name = L["PROGRESS_BAR_SMOOTH"],
					},
				},
			}, -- 7
			spacer_4 = {
				order = 8,
				type = "description",
				name = " ",
			}, -- 8
			cooldown = {
				order = 9,
				type = "group",
				name = L["COOLDOWN_TEXT"],
				inline = true,
				disabled = isModuleDisabled,
				get = function(info)
					return C.db.profile.units.cooldown[info[#info]]
				end,
				set = function(info, value)
					if C.db.profile.units.cooldown[info[#info]] ~= value then
						C.db.profile.units.cooldown[info[#info]] = value

						UNITFRAMES:ForEach("For", "Auras", "UpdateConfig")
						UNITFRAMES:ForEach("For", "Auras", "UpdateCooldownConfig")
					end
				end,
				args = {
					reset = {
						type = "execute",
						order = 1,
						name = L["RESTORE_DEFAULTS"],
						confirm = CONFIG.ConfirmReset,
						func = function()
							CONFIG:CopySettings(D.profile.units.cooldown, C.db.profile.units.cooldown)
							UNITFRAMES:ForEach("For", "Auras", "UpdateConfig")
							UNITFRAMES:ForEach("For", "Auras", "UpdateCooldownConfig")
						end,
					},
					spacer_1 = {
						order = 9,
						type = "description",
						name = " ",
					},
					exp_threshold = {
						order = 10,
						type = "range",
						name = L["EXP_THRESHOLD"],
						min = 1, max = 10, step = 1,
						disabled = isOCCEnabled,
					},
					m_ss_threshold = {
						order = 11,
						type = "range",
						name = L["M_SS_THRESHOLD"],
						desc = L["M_SS_THRESHOLD_DESC"],
						min = 0, max = 3599, step = 1,
						softMin = 91,
						disabled = isOCCEnabled,
						set = function(info, value)
							if C.db.profile.units.cooldown[info[#info]] ~= value then
								if value < info.option.softMin then
									value = info.option.min
								end

								C.db.profile.units.cooldown[info[#info]] = value

								UNITFRAMES:ForEach("For", "Auras", "UpdateConfig")
								UNITFRAMES:ForEach("For", "Auras", "UpdateCooldownConfig")
							end
						end,
					},
					s_ms_threshold = {
						order = 12,
						type = "range",
						name = L["S_MS_THRESHOLD"],
						desc = L["S_MS_THRESHOLD_DESC"],
						min = 1, max = 10, step = 1,
						disabled = isOCCEnabled,
						set = function(info, value)
							if C.db.profile.units.cooldown[info[#info]] ~= value then
								C.db.profile.units.cooldown[info[#info]] = value

								UNITFRAMES:ForEach("For", "Auras", "UpdateConfig")
								UNITFRAMES:ForEach("For", "Auras", "UpdateCooldownConfig")
							end
						end,
					},
					spacer_2 = {
						order = 19,
						type = "description",
						name = " ",
					},
					swipe = {
						order = 20,
						type = "group",
						name = L["COOLDOWN_SWIPE"],
						inline = true,
						get = function(info)
							return C.db.profile.units.cooldown.swipe[info[#info]]
						end,
						set = function(info, value)
							if C.db.profile.units.cooldown.swipe[info[#info]] ~= value then
								C.db.profile.units.cooldown.swipe[info[#info]] = value

								UNITFRAMES:ForEach("For", "Auras", "UpdateConfig")
								UNITFRAMES:ForEach("For", "Auras", "UpdateCooldownConfig")
							end
						end,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = L["SHOW"],
							},
							reversed = {
								order = 2,
								type = "toggle",
								disabled = function()
									return not C.db.profile.units.cooldown.swipe.enabled
								end,
								name = L["REVERSE"],
							},
						},
					},
				},
			}, -- 9
			player = getUnitFrameOptions(10, "player", L["PLAYER_FRAME"]),
			pet = getUnitFrameOptions(11, "pet", L["PET_FRAME"]),
			target = getUnitFrameOptions(12, "target", L["TARGET_FRAME"]),
			targettarget = getUnitFrameOptions(13, "targettarget", L["TOT_FRAME"]),
			focus = getUnitFrameOptions(14, "focus", L["FOCUS_FRAME"]),
			focustarget = getUnitFrameOptions(15, "focustarget", L["TOF_FRAME"]),
			boss = getUnitFrameOptions(16, "boss", L["BOSS_FRAMES"]),
			party = getUnitFrameOptions(16, "party", L["PARTY_FRAMES"]),
		},
	}

	self:AddCallback(self.UpdateUnitFrameAuraFilters)
end
