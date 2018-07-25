﻿-- Contributors: aenerv7@GitHub

local _, ns = ...
local E, L = ns.E, ns.L

-- Lua
local _G = getfenv(0)

if _G.GetLocale() ~= "zhCN" then return end

-- Lua
local m_modf = _G.math.modf
local s_format = _G.string.format

-- Mine
do
	local BreakUpLargeNumbers = _G.BreakUpLargeNumbers
	local SECOND_NUMBER_CAP_NO_SPACE = _G.SECOND_NUMBER_CAP_NO_SPACE
	local FIRST_NUMBER_CAP_NO_SPACE = _G.FIRST_NUMBER_CAP_NO_SPACE

	function E:NumberFormat(v, mod)
		if v >= 1E8 then
			local i, f = m_modf(v / 1E8)

			if mod and mod > 0 then
				return s_format("%s.%d"..SECOND_NUMBER_CAP_NO_SPACE, BreakUpLargeNumbers(i), f * 10 ^ mod)
			else
				return s_format("%s"..SECOND_NUMBER_CAP_NO_SPACE, BreakUpLargeNumbers(i))
			end
		elseif v >= 1E4 then
			local i, f = m_modf(v / 1E4)

			if mod and mod > 0 then
				return s_format("%s.%d"..FIRST_NUMBER_CAP_NO_SPACE, BreakUpLargeNumbers(i), f * 10 ^ mod)
			else
				return s_format("%s"..FIRST_NUMBER_CAP_NO_SPACE, BreakUpLargeNumbers(i))
			end
		elseif v >= 0 then
			return BreakUpLargeNumbers(v)
		else
			return 0
		end
	end
end

L["ACTION_BARS"] = "动作条"
--[[ L["ADDITIONAL_BAR"] = "Additional Bar" ]]
L["ADVENTURE_JOURNAL_DESC"] = "显示团队副本锁定信息"
L["ALT_POWER_BAR"] = "第二资源条"
--[[ L["ALT_POWER_FORMAT_DESC"] = [=[Provide a string to change the text. To disable, leave the field blank.

Tags:
- |cffffd200[ls:altpower:cur]|r - the current value;
- |cffffd200[ls:altpower:max]|r - the max value;
- |cffffd200[ls:altpower:perc]|r - the percentage;
- |cffffd200[ls:altpower:cur-max]|r - the current value followed by the max value;
- |cffffd200[ls:altpower:cur-color-max]|r - the current value followed by the coloured max value;
- |cffffd200[ls:altpower:cur-perc]|r - the current value followed by the percentage;
- |cffffd200[ls:altpower:cur-color-perc]|r - the current value followed by the coloured percentage;
- |cffffd200[ls:color:altpower]|r - colour.

If the current value is equal to the max value, only the max value will be displayed.

Use |cffffd200||r|r to close colour tags.
Use |cffffd200[nl]|r for line breaking.]=] ]]
L["ALTERNATIVE_POWER"] = "第二资源"
L["ALWAYS_SHOW"] = "总是显示"
L["ANCHOR"] = "依附于"
--[[ L["ANCHOR_TO_CURSOR"] = "Attach to Cursor" ]]
L["ARTIFACT_LEVEL_TOOLTIP"] = "神器等级：|cffffffff%s|r"
L["ARTIFACT_POWER"] = "神器能量"
L["ASCENDING"] = "升序"
L["AURA_TRACKER"] = "光环追踪器"
L["AURAS"] = "光环"
--[[ L["AUTO"] = "Auto" ]]
--[[ L["BAG_SLOTS"] = "Bag Slots" ]]
--[[ L["BAR"] = "Bar" ]]
L["BAR_1"] = "动作条 1"
L["BAR_2"] = "动作条 2"
L["BAR_3"] = "动作条 3"
L["BAR_4"] = "动作条 4"
L["BAR_5"] = "动作条 5"
L["BAR_COLOR"] = "生命条颜色"
L["BAR_TEXT"] = "动作条文字"
L["BLIZZARD"] = "暴雪默认 UI"
L["BONUS_HONOR_TOOLTIP"] = "奖励荣誉：|cffffffff%s|r"
L["BONUS_XP_TOOLTIP"] = "奖励经验：|cffffffff%s|r"
L["BORDER"] = "边框"
L["BORDER_COLOR"] = "边框颜色"
L["BOSS"] = "首领"
L["BOSS_BUFFS"] = "首领增益效果"
L["BOSS_BUFFS_DESC"] = "显示首领施放的增益效果"
L["BOSS_DEBUFFS"] = "首领减益效果"
L["BOSS_DEBUFFS_DESC"] = "显示首领施放的减益效果"
L["BOSS_FRAMES"] = "首领框架"
L["BOTTOM"] = "底部"
L["BOTTOM_INSET_SIZE"] = "底部插页尺寸"
L["BOTTOM_INSET_SIZE_DESC"] = "被资源条使用"
L["BUFFS"] = "增益效果"
L["BUFFS_AND_DEBUFFS"] = "增益效果和减益效果"
L["BUTTON_GRID"] = "按钮边框"
L["CALENDAR"] = "日历"
L["CAST_ON_KEY_DOWN"] = "按下时施法"
L["CASTABLE_BUFFS"] = "可施放增益效果"
L["CASTABLE_BUFFS_DESC"] = "显示你施放的增益效果"
L["CASTABLE_BUFFS_PERMA"] = "可施放的永久增益效果"
L["CASTABLE_BUFFS_PERMA_DESC"] = "显示你施放的永久增益效果"
L["CASTABLE_DEBUFFS"] = "可施放的减益效果"
L["CASTABLE_DEBUFFS_DESC"] = "显示你施放的减益效果"
L["CASTABLE_DEBUFFS_PERMA"] = "可施放的永久减益效果"
L["CASTABLE_DEBUFFS_PERMA_DESC"] = "显示你施放的永久减益效果"
L["CASTBAR"] = "施法条"
L["CHARACTER_BUTTON_DESC"] = "显示装备耐久度信息"
L["CLASS_POWER"] = "职业能量"
L["CLASSIC"] = "经典"
L["CLOCK"] = "时钟"
--[[ L["COLOR_BY_SPEC"] = "Colour by Spec" ]]
--[[ L["COLORS"] = "Colours" ]]
L["COMMAND_BAR"] = "命令条"
--[[ L["COOLDOWN"] = "Cooldown" ]]
--[[ L["COOLDOWN_TEXT"] = "Cooldown Text" ]]
L["COPY_FROM"] = "复制自"
L["COPY_FROM_DESC"] = "选择一份配置文件复制"
L["COST_PREDICTION"] = "花费预测"
L["COST_PREDICTION_DESC"] = "显示法术将要花费的资源，对瞬发法术不生效"
L["COUNT_TEXT"] = "数量文字"
L["DAILY_QUEST_RESET_TIME_TOOLTIP"] = "日常任务重置时间：|cffffffff%s|r"
--[[ L["DAMAGE_ABSORB_FORMAT_DESC"] = [=[Provide a string to change the text. To disable, leave the field blank.

Tags:
- |cffffd200[ls:absorb:damage]|r - the current value;
- |cffffd200[ls:color:absorb-damage]|r - the colour.

Use |cffffd200||r|r to close colour tags.
Use |cffffd200[nl]|r for line breaking.]=] ]]
L["DAMAGE_ABSORB_TEXT"] = "伤害吸收文字"
--[[ L["DAYS"] = "Days" ]]
L["DEAD"] = "死亡"
L["DEBUFFS"] = "减益效果"
--[[ L["DESATURATION"] = "Desaturation" ]]
L["DESCENDING"] = "降序"
L["DETACH_FROM_FRAME"] = "从框架脱离"
L["DIFFICULTY_FLAG"] = "难度标记"
L["DIGSITE_BAR"] = "考古进度条"
L["DISABLE_MOUSE"] = "禁用鼠标"
L["DISABLE_MOUSE_DESC"] = "忽略鼠标事件"
L["DISPELLABLE_BUFFS"] = "可驱散的增益效果"
L["DISPELLABLE_BUFFS_DESC"] = "显示目标身上你可以偷取或是驱散的增益效果"
L["DISPELLABLE_DEBUFF_ICONS"] = "可驱散的减益效果图标"
L["DISPELLABLE_DEBUFFS"] = "可驱散的减益效果"
L["DISPELLABLE_DEBUFFS_DESC"] = "显示目标身上你可以驱散的减益效果"
L["DOWN"] = "下"
L["DRAG_KEY"] = "拖动键"
L["DRAW_COOLDOWN_BLING"] = "显示冷却完成闪烁"
L["DRAW_COOLDOWN_BLING_DESC"] = "在冷却完成时显示闪烁动画"
L["DUNGEONS_BUTTON_DESC"] = "显示随机稀缺职业奖励信息"
L["DURABILITY_FRAME"] = "耐久度框架"
L["ELITE"] = "精英"
L["ENEMY_UNITS"] = "敌对单位"
L["ENHANCED_TOOLTIPS"] = "鼠标提示增强"
L["ENTER_SPELL_ID"] = "输入法术 ID"
--[[ L["EXP_THRESHOLD"] = "Expiration Threshold" ]]
--[[ L["EXP_THRESHOLD_DESC"] = "The threshold (in seconds) below which the remaining time will be shown as a decimal number." ]]
L["EXPERIENCE"] = "经验值"
--[[ L["EXPIRATION"] = "Expiration" ]]
L["EXTRA_ACTION_BUTTON"] = "额外动作按钮"
L["FADE_IN_DELAY"] = "延迟淡入"
L["FADE_IN_DURATION"] = "淡入时长"
L["FADE_OUT_DELAY"] = "延迟淡出"
L["FADE_OUT_DURATION"] = "淡出时长"
L["FADING"] = "渐隐"
L["FCF"] = "浮动战斗反馈"
L["FILTER_SETTINGS"] = "过滤器设置"
L["FILTERS"] = "过滤器"
L["FLAG"] = "标记"
L["FLYOUT_DIR"] = "弹出方向"
L["FOCUS_FRAME"] = "焦点目标框架"
L["FOCUS_TOF"] = "焦点目标 & 焦点目标的目标"
--[[ L["FONT"] = "Font" ]]
L["FORMAT"] = "格式"
L["FRAME"] = "框架"
--[[ L["FREE_BAG_SLOTS_TOOLTIP"] = "Free Bag Slots: |cffffffff%s|r" ]]
L["FRIENDLY_UNITS"] = "友好单位"
L["GM_FRAME"] = "申请状态框架"
L["GOLD"] = "金币"
L["GROWTH_DIR"] = "增长方向"
--[[ L["HEAL_ABSORB_FORMAT_DESC"] = [=[Provide a string to change the text. To disable, leave the field blank.

Tags:
- |cffffd200[ls:absorb:heal]|r - the current value;
- |cffffd200[ls:color:absorb-heal]|r - the colour.

Use |cffffd200||r|r to close colour tags.
Use |cffffd200[nl]|r for line breaking.]=] ]]
L["HEAL_ABSORB_TEXT"] = "治疗吸收文本"
L["HEAL_PREDICTION"] = "治疗预测"
L["HEALTH"] = "生命值"
--[[ L["HEALTH_FORMAT_DESC"] = [=[Provide a string to change the text. To disable, leave the field blank.

Tags:
- |cffffd200[ls:health:cur]|r - the current value;
- |cffffd200[ls:health:perc]|r - the percentage;
- |cffffd200[ls:health:cur-perc]|r - the current value followed by the percentage;
- |cffffd200[ls:health:deficit]|r - the deficit value.

If the current value is equal to the max value, only the max value will be displayed.

Use |cffffd200[nl]|r for line breaking.]=] ]]
L["HEALTH_TEXT"] = "生命值文本"
L["HEIGHT"] = "高度"
L["HONOR"] = "荣誉"
L["HONOR_LEVEL_TOOLTIP"] = "荣誉等级：|cffffffff%d|r"
L["HORIZ_GROWTH_DIR"] = "水平增长"
--[[ L["HOURS"] = "Hours" ]]
L["ICON"] = "图标"
L["INDEX"] = "索引"
L["INSPECT_INFO"] = "玩家信息"
L["INSPECT_INFO_DESC"] = "显示当前单位的专精和装备等级，这些数据可能不是马上就能显示"
--[[ L["INVENTORY_BUTTON"] = "Inventory" ]]
--[[ L["INVENTORY_BUTTON_DESC"] = "Show currency information." ]]
--[[ L["INVENTORY_BUTTON_RCLICK_TOOLTIP"] = "|cffffffffRight-Click|r to toggle bag slots." ]]
L["ITEM_COUNT"] = "物品计数"
L["ITEM_COUNT_DESC"] = "显示银行和背包中该物品的总数"
L["KEYBIND_TEXT"] = "快捷键绑定文字"
L["LATENCY"] = "延迟"
L["LATENCY_HOME"] = "本地"
L["LATENCY_WORLD"] = "世界"
L["LATER"] = "稍后"
L["LEFT"] = "左"
L["LEFT_DOWN"] = "左下"
L["LEFT_UP"] = "左上"
L["LEVEL_TOOLTIP"] = "等级：|cffffffff%d|r"
L["LOCK"] = "锁定"
L["LOCK_BUTTONS"] = "锁定按钮"
L["LOCK_BUTTONS_DESC"] = "防止图标被拖离动作条"
--[[ L["LOOT_ALL"] = "Loot All" ]]
--[[ L["M_SS_THRESHOLD"] = "M:SS Threshold" ]]
--[[ L["M_SS_THRESHOLD_DESC"] = "The threshold (in seconds) below which the remaining time will be shown in the M:SS format. Set to 0 to disable." ]]
L["MACRO_TEXT"] = "宏文字"
--[[ L["MAIN_BAR"] = "Main Bar" ]]
L["MAINMENU_BUTTON_DESC"] = "显示性能信息"
L["MAINMENU_BUTTON_HOLD_TOOLTIP"] = "|cffffffff按住 Shift|r 来显示内存占用"
L["MAX_ALPHA"] = "最大透明度"
L["MEMORY"] = "内存"
L["MICRO_BUTTONS"] = "微型菜单按钮"
L["MIN_ALPHA"] = "最小透明度"
--[[ L["MINUTES"] = "Minutes" ]]
L["MIRROR_TIMER"] = "镜像计时器"
--[[ L["MIRROR_TIMER_DESC"] = "Breath, fatigue and other indicators." ]]
L["MODE"] = "模式"
L["MOUNT_AURAS"] = "坐骑光环"
L["MOUNT_AURAS_DESC"] = "显示坐骑光环"
L["MOUSEOVER_SHOW"] = "鼠标经过时显示"
L["MOVER_BUTTONS_DESC"] = "|cffffffff点击|r 激活按钮"
L["MOVER_CYCLE_DESC"] = "按 |cffffffffAlt|r 键切换位于鼠标位置的不同组件"
L["MOVER_RESET_DESC"] = "|cffffffffShift 加点击|r 来重置位置"
L["NAME"] = "名称"
--[[ L["NAME_FORMAT_DESC"] = [=[Provide a string to change the text. To disable, leave the field blank.

Tags:
- |cffffd200[ls:name]|r - the name;
- |cffffd200[ls:name:5]|r - the name shortened to 5 characters;
- |cffffd200[ls:name:10]|r - the name shortened to 10 characters;
- |cffffd200[ls:name:15]|r - the name shortened to 15 characters;
- |cffffd200[ls:name:20]|r - the name shortened to 20 characters;
- |cffffd200[ls:server]|r - the (*) tag for players from foreign realms;
- |cffffd200[ls:color:class]|r - the class colour;
- |cffffd200[ls:color:reaction]|r - the reaction colour;
- |cffffd200[ls:color:difficulty]|r - the difficulty colour.

Use |cffffd200||r|r to close colour tags.
Use |cffffd200[nl]|r for line breaking.]=] ]]
L["NO_SEPARATION"] = "不分隔"
--[[ L["NOTHING_TO_SHOW"] = "Nothing to show." ]]
L["NPC_CLASSIFICATION"] = "NPC 类型"
L["NPE_FRAME"] = "新手引导框架"
L["NUM_BUTTONS"] = "按钮数量"
L["NUM_ROWS"] = "行数量"
L["OBJECTIVE_TRACKER"] = "目标追踪器"
--[[ L["ON_COOLDOWN"] = "On Cooldown" ]]
--[[ L["OOM"] = "Out of Power" ]]
--[[ L["OOM_INDICATOR"] = "Out-of-Power Indicator" ]]
--[[ L["OOR"] = "Out of Range" ]]
L["OOR_INDICATOR"] = "超出距离指示器"
L["OPEN_CONFIG"] = "打开设置"
L["ORBS"] = "球形"
L["OTHER"] = "其他"
L["OTHERS_FIRST"] = "他人优先"
L["OUTLINE"] = "大纲"
L["PER_ROW"] = "每行"
L["PET_BAR"] = "宠物条"
L["PET_BATTLE_BAR"] = "宠物对战条"
--[[ L["PET_CAST_BAR"] = "Pet Casting Bar" ]]
L["PET_FRAME"] = "宠物框架"
L["PLAYER_CLASS"] = "玩家职业"
L["PLAYER_FRAME"] = "玩家框架"
L["PLAYER_PET"] = "玩家 & 宠物"
L["PLAYER_TITLE"] = "玩家头衔"
L["POINT"] = "锚点"
L["POINT_DESC"] = "对象的锚点"
L["POSITION"] = "位置"
L["POWER"] = "资源"
--[[ L["POWER_FORMAT_DESC"] = [=[Provide a string to change the text. To disable, leave the field blank.

Tags:
- |cffffd200[ls:power:cur]|r - the current value;
- |cffffd200[ls:power:max]|r - the max value;
- |cffffd200[ls:power:perc]|r - the percentage;
- |cffffd200[ls:power:cur-max]|r - the current value followed by the max value;
- |cffffd200[ls:power:cur-color-max]|r - the current value followed by the coloured max value;
- |cffffd200[ls:power:cur-perc]|r - the current value followed by the percentage;
- |cffffd200[ls:power:cur-color-perc]|r - the current value followed by the coloured percentage;
- |cffffd200[ls:power:deficit]|r - the deficit value;
- |cffffd200[ls:color:power]|r - the colour.

If the current value is equal to the max value, only the max value will be displayed.

Use |cffffd200||r|r to close colour tags.
Use |cffffd200[nl]|r for line breaking.]=] ]]
L["POWER_TEXT"] = "资源文字"
L["PRESTIGE_LEVEL_TOOLTIP"] = "威望等级：|cffffffff%s|r"
L["PREVIEW"] = "预览"
L["PVP_ICON"] = "PvP 图标"
L["QUESTLOG_BUTTON_DESC"] = "显示每日任务重置计时器"
L["RAID_ICON"] = "团队图标"
L["RCLICK_SELFCAST"] = "右击自我施法"
L["REACTION"] = "关系"
L["RELATIVE_POINT"] = "相对锚点"
L["RELATIVE_POINT_DESC"] = "对象依附的区域的锚点"
L["RELOAD_NOW"] = "立刻重载"
L["RELOAD_UI_ON_CHAR_SETTING_CHANGE_POPUP"] = "你刚刚修改了特定角色的设置，这些设置独立于你账号的设置，想让这些设置生效你需要重载界面"
L["RELOAD_UI_WARNING"] = "设置完插件后重载 UI"
L["RESTORE_DEFAULTS"] = "恢复默认"
L["RESTRICTED_MODE"] = "受限模式"
--[[ L["RESTRICTED_MODE_DESC"] = [=[Enables artwork, animations and dynamic resizing for the main action bar.

|cffdc4436Warning!|r Many action bar customisation options won't be available in this mode.|r]=] ]]
L["RIGHT"] = "右"
L["RIGHT_DOWN"] = "右下"
L["RIGHT_UP"] = "右上"
L["ROWS"] = "行"
--[[ L["RUNES"] = "Runes" ]]
L["SECOND_ANCHOR"] = "第二锚点"
--[[ L["SECONDS"] = "Seconds" ]]
L["SELF_BUFFS"] = "自我增益"
L["SELF_BUFFS_DESC"] = "显示单位施放的增益效果"
L["SELF_BUFFS_PERMA"] = "永久自我增益"
L["SELF_BUFFS_PERMA_DESC"] = "显示单位施放的永久性增益效果"
L["SELF_DEBUFFS"] = "自我减益"
L["SELF_DEBUFFS_DESC"] = "显示单位施放的减益效果"
L["SELF_DEBUFFS_PERMA"] = "永久自我减益"
L["SELF_DEBUFFS_PERMA_DESC"] = "显示单位施放的永久性减益效果"
L["SEPARATION"] = "分隔"
L["SHADOW"] = "阴影"
L["SHIFT_CLICK_TO_SHOW_AS_XP"] = "|cffffffffShift 加点击|r 来显示经验条"
L["SIZE"] = "尺寸"
L["SIZE_OVERRIDE"] = "覆盖原有尺寸"
L["SIZE_OVERRIDE_DESC"] = "如果设置为 0 的话，UI 元素的尺寸将会被自动计算"
L["SORT_DIR"] = "排序方向"
L["SORT_METHOD"] = "排序方法"
L["SPACING"] = "间距"
L["STANCE_BAR"] = "姿态条"
L["TALKING_HEAD_FRAME"] = "剧情动画框架"
L["TARGET_FRAME"] = "目标框架"
L["TARGET_INFO"] = "目标信息"
L["TARGET_INFO_DESC"] = "显示单位的目标"
L["TARGET_TOT"] = "目标 & 目标的目标"
--[[ L["TEXT"] = "Text" ]]
L["TEXT_HORIZ_ALIGNMENT"] = "水平对齐"
L["TEXT_VERT_ALIGNMENT"] = "垂直对齐"
L["THREAT_GLOW"] = "仇恨目标边框"
L["TIME"] = "时间"
L["TOF_FRAME"] = "焦点目标的目标框架"
L["TOGGLE_ANCHORS"] = "激活锚点"
L["TOOLTIP_IDS"] = "法术和物品 ID"
L["TOOLTIPS"] = "鼠标提示"
L["TOP"] = "顶部"
L["TOP_INSET_SIZE"] = "顶部插页尺寸"
L["TOP_INSET_SIZE_DESC"] = "职业资源，职业第二资源以及职业其他资源使用"
L["TOT_FRAME"] = "目标的目标框架"
L["TOTEMS"] = "图腾"
L["UI_LAYOUT"] = "UI 布局"
L["UI_LAYOUT_DESC"] = "修改玩家和宠物框架外观，与此同时也会修改 UI 布局"
L["UNITS"] = "单位"
L["UNSPENT_TRAIT_POINTS_TOOLTIP"] = "未使用的神器点数：|cffffffff%s|r"
--[[ L["UNUSABLE"] = "Not Usable" ]]
L["UP"] = "上"
--[[ L["USABLE"] = "Usable" ]]
L["USE_BLIZZARD_VEHICLE_UI"] = "使用暴雪载具 UI"
L["VEHICLE_EXIT_BUTTON"] = "离开载具按钮"
L["VEHICLE_SEAT_INDICATOR"] = "载具座位指示器"
L["VERT_GROWTH_DIR"] = "垂直增长"
L["VISIBILITY"] = "可见性"
L["WIDTH"] = "宽度"
L["WIDTH_OVERRIDE"] = "覆盖原有宽度"
L["WORD_WRAP"] = "文字换行"
L["X_OFFSET"] = "X 轴便宜"
L["XP_BAR"] = "经验条"
L["Y_OFFSET"] = "Y 轴便宜"
L["YOURS_FIRST"] = "你的优先"
L["ZONE_ABILITY_BUTTON"] = "区域特殊能力按钮"
L["ZONE_TEXT"] = "区域文字"
