local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "<name> was unable to locate oUF install.")

local smoothing = {}
local function Smooth(self, value)
	local _, max = self:GetMinMaxValues()
	if value == self:GetValue() or (self._max and self._max ~= max) then
		smoothing[self] = nil
		self:SetValue_(value)
	else
		smoothing[self] = value
	end
	self._max = max
end

local function SmoothBar(self, bar)
	bar.SetValue_ = bar.SetValue
	bar.SetValue = Smooth
end

local function hook(frame)
	frame.SmoothBar = SmoothBar
	if frame.Health and frame.Health.Smooth then
		frame:SmoothBar(frame.Health)
	end
	if frame.Power and frame.Power.Smooth then
		frame:SmoothBar(frame.Power)
	end
	if frame.EclipseBar and frame.EclipseBar.Smooth then
		if frame.EclipseBar.LunarBar then
			frame:SmoothBar(frame.EclipseBar.LunarBar)
		end
		if frame.EclipseBar.SolarBar then
			frame:SmoothBar(frame.EclipseBar.SolarBar)
		end
	end
	if frame.DemonicFury and frame.DemonicFury.Smooth then
		frame:SmoothBar(frame.DemonicFury)
	end
	if frame.BurningEmbers and frame.BurningEmbers.Smooth then
		for i = 1, #frame.BurningEmbers do
			frame:SmoothBar(frame.BurningEmbers[i])
		end
	end
end

for i, frame in ipairs(oUF.objects) do hook(frame) end
oUF:RegisterInitCallback(hook)


local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function()
	local limit = 30/GetFramerate()
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local _, barmax = bar:GetMinMaxValues()
		local new = cur + math.min((value-cur)/10, math.max(value-cur, limit))
		if new ~= new then
			-- Mad hax to prevent QNAN.
			new = value
		end
		bar:SetValue_(new)
		if cur == value or abs(new - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)
