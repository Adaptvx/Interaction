local addon = select(2, ...)
local Animation = addon.API.Animation or {}
addon.API.Animation = Animation

local function fail(msg)
	if msg then print("Failed Animation: " .. msg) end
	return true
end

function Animation.EaseLinear(t)
	return t
end

function Animation.EaseSine(t, b, c, d)
	return c * math.sin(t / d * (math.pi / 2)) + b
end

function Animation.EaseOutSine(t, b, c, d)
	return (c - b) * math.sin(t / d * (math.pi / 2)) + b
end

function Animation.EaseInOutSine(t, b, c, d)
	return -(c - b) / 2 * (math.cos(math.pi * t / d) - 1) + b
end

function Animation.EaseQuad(t, b, c, d)
	local x = t / d
	return -c * x * (x - 2) + b
end

function Animation.EaseQuint(t, b, c, d)
	local x = t / d - 1
	return c * (x ^ 5 + 1) + b
end

function Animation.EaseQuart(t, b, c, d)
	local x = t / d - 1
	return -c * (x ^ 4 - 1) + b
end

function Animation.EaseCubic(t, b, c, d)
	local x = t / d - 1
	return c * (x ^ 3 + 1) + b
end

function Animation.EaseExpo(t, b, c, d)
	return t == d and b + c or c * (-2 ^ (-10 * t / d) + 1) + b
end

function Animation.EaseOutExpo(t, b, c, d)
	return t == d and b + (c - b) or (c - b) * (-2 ^ (-10 * t / d) + 1) + b
end

function Animation.EaseElastic(t, b, c, d)
	local p, s = .3 * d, (.3 * d) / 4
	if t == 0 then return b end
	if t >= d then return b + c end
	local x = t / d
	return c * (2 ^ (-10 * x) * math.sin((x * d - s) * (2 * math.pi) / p)) + c + b
end

function Animation:AddToQueue(frame, callback)
	local updateFrame = CreateFrame("Frame", nil, frame:GetParent())
	updateFrame:SetScript("OnUpdate", function(self, elapsed) callback(self, nil, elapsed) end)
	return updateFrame
end

function Animation:RemoveFromQueue(updateFrame)
	updateFrame:SetScript("OnUpdate", nil)
	updateFrame:Hide()
end

function Animation:Fade(frame, duration, startAlpha, endAlpha, animationStyle, stopEvent)
	if not duration and fail("No duration specified.") then return end
	if (startAlpha or 0) > 1 or (endAlpha or 0) > 1 then if fail("Alpha cannot be greater than 1.") then return end end
	if not frame and fail("No frame specified.") then return end

	local startTime = GetTime()
	local endTime = startTime + duration
	local animationFunc = animationStyle or Animation.EaseLinear
	frame.API_Animation_FadeIdentifier = startTime
	frame:SetAlpha(startAlpha)

	local function UpdateAlpha(updateFrame)
		if frame.API_Animation_FadeIdentifier ~= startTime or (stopEvent and stopEvent(frame)) then return Animation:RemoveFromQueue(updateFrame) end
		local currentTime = GetTime()
		local eased = animationFunc((currentTime - startTime) / duration, 0, 1, 1)
		frame:SetAlpha(math.min(1, math.max(0, startAlpha + (endAlpha - startAlpha) * eased)))
		if currentTime >= endTime then frame:SetAlpha(endAlpha) Animation:RemoveFromQueue(updateFrame) end
	end

	local updateFrame = Animation:AddToQueue(frame, UpdateAlpha)
	UpdateAlpha(updateFrame)
end

function Animation:FadeText(text, duration, width, startAlpha, animationStyle, stopEvent)
	if (not text or not duration or not width) and fail("Parameters not specified.") then return end
	text.API_Animation_FadeTextFrame = text.API_Animation_FadeTextFrame or CreateFrame("Frame", nil, text:GetParent())
	local frame = text.API_Animation_FadeTextFrame
	local animationFunc = animationStyle or Animation.EaseLinear
	text:SetAlpha(startAlpha or 1)
	text:SetAlphaGradient(0, width)
	text:SetIgnoreParentAlpha(true)

	C_Timer.After(0, function()
		local length = strlenutf8(text:GetText() or "")
		local speed = ceil(length / duration) + 10
		local progress, currentTime = 0, 0
		local function UpdateAlpha(updateFrame, _, elapsed)
			if stopEvent and stopEvent(text) then Animation:RemoveFromQueue(updateFrame) text:SetAlpha(1) text:SetIgnoreParentAlpha(false) return end
			currentTime, progress = currentTime + elapsed, progress + elapsed * speed
			local eased = animationFunc(currentTime, 0, 1, 1)
			if not text:SetAlphaGradient(progress * eased, width) then Animation:RemoveFromQueue(updateFrame) text:SetAlpha(1) text:SetIgnoreParentAlpha(false) end
		end
		Animation:AddToQueue(frame, UpdateAlpha)
	end)
end

function Animation:Scale(frame, duration, startScale, endScale, axis, animationStyle, stopEvent)
	if not duration and fail("No duration specified.") then return end
	if ((type(startScale) == "number" and startScale <= 0) or (type(endScale) == "number" and endScale <= 0)) and fail("Scale cannot be less than or equal to 0.") then return end
	if not frame and fail("No frame specified.") then return end

	local startTime, endTime = GetTime(), GetTime() + duration
	local animationFunc = animationStyle or Animation.EaseExpo
	frame.API_Animation_ScaleIdentifier = startTime
	local setWidth, setHeight, startW, startH, endW, endH
	if axis == "x" then setWidth, startW, endW = frame.SetWidth, startScale, endScale
	elseif axis == "y" then setHeight, startH, endH = frame.SetHeight, startScale, endScale
	elseif axis == "both" then setWidth, setHeight, startW, startH, endW, endH = frame.SetWidth, frame.SetHeight, startScale.x, startScale.y, endScale.x, endScale.y
	else setWidth, startW, endW = frame.SetScale, startScale, endScale end
	if setWidth then setWidth(frame, startW) end
	if setHeight then setHeight(frame, startH) end

	local function UpdateScale(updateFrame)
		if frame.API_Animation_ScaleIdentifier ~= startTime or (stopEvent and stopEvent(frame)) then return Animation:RemoveFromQueue(updateFrame) end
		local eased = animationFunc((GetTime() - startTime) / duration, 0, 1, 1)
		if setWidth then setWidth(frame, startW + (endW - startW) * eased) end
		if setHeight then setHeight(frame, startH + (endH - startH) * eased) end
		if GetTime() >= endTime then if setWidth then setWidth(frame, endW) end if setHeight then setHeight(frame, endH) end Animation:RemoveFromQueue(updateFrame) end
	end

	local updateFrame = Animation:AddToQueue(frame, UpdateScale)
	UpdateScale(updateFrame)
end

function Animation:Move(frame, duration, point, startPos, endPos, axis, animationStyle, stopEvent)
	if not duration and fail("No duration specified.") then return end
	if (not point or not startPos or not endPos) and fail("Parameters not specified.") then return end
	if not frame and fail("No frame specified.") then return end

	local startTime, endTime = GetTime(), GetTime() + duration
	local animationFunc = animationStyle or Animation.EaseExpo
	frame.API_Animation_PositionIdentifier = startTime
	local function UpdatePosition(updateFrame)
		if frame.API_Animation_PositionIdentifier ~= startTime or (stopEvent and stopEvent(frame)) then return Animation:RemoveFromQueue(updateFrame) end
		local eased = animationFunc((GetTime() - startTime) / duration, 0, 1, 1)
		local offset = startPos + (endPos - startPos) * eased
		local _, relativeTo, _, offsetX, offsetY = frame:GetPoint()
		frame:ClearAllPoints()
		if axis == "x" then frame:SetPoint(point, relativeTo, offset, offsetY) elseif axis == "y" then frame:SetPoint(point, relativeTo, offsetX, offset) end
		if GetTime() >= endTime then frame:ClearAllPoints() if axis == "x" then frame:SetPoint(point, relativeTo, endPos, offsetY) else frame:SetPoint(point, relativeTo, offsetX, endPos) end Animation:RemoveFromQueue(updateFrame) end
	end
	local updateFrame = Animation:AddToQueue(frame, UpdatePosition)
	UpdatePosition(updateFrame)
end

function Animation:PreciseMove(frame, duration, relativeTo, point, startX, startY, endX, endY, animationStyle, stopEvent)
	if not duration and fail("No duration specified.") then return end
	if (not point or not relativeTo or not startX or not startY or not endX or not endY) and fail("Parameters not specified.") then return end
	if not frame and fail("No frame specified.") then return end

	local startTime, endTime = GetTime(), GetTime() + duration
	local animationFunc = animationStyle or Animation.EaseExpo
	frame.API_Animation_PositionIdentifier = startTime
	local function UpdatePosition(updateFrame)
		if frame.API_Animation_PositionIdentifier ~= startTime or (stopEvent and stopEvent(frame)) then return Animation:RemoveFromQueue(updateFrame) end
		local eased = animationFunc((GetTime() - startTime) / duration, 0, 1, 1)
		frame:ClearAllPoints()
		frame:SetPoint(point, relativeTo, startX + (endX - startX) * eased, startY + (endY - startY) * eased)
		if GetTime() >= endTime then frame:ClearAllPoints() frame:SetPoint(point, relativeTo, endX, endY) Animation:RemoveFromQueue(updateFrame) end
	end
	local updateFrame = Animation:AddToQueue(frame, UpdatePosition)
	UpdatePosition(updateFrame)
end

function Animation:MoveTo(frame, duration, point, parent, currentX, currentY, endX, endY, animationStyle, stopEvent)
	if not duration and fail("No duration specified.") then return end
	if (not point or not parent or not endX or not endY) and fail("Parameters not specified.") then return end
	if not frame and fail("No frame specified.") then return end

	local startTime, endTime = GetTime(), GetTime() + duration
	local animationFunc = animationStyle or Animation.EaseExpo
	if not currentX or not currentY then local _, _, _, x, y = frame:GetPoint() currentX, currentY = x, y end
	frame.API_Animation_PositionIdentifier = startTime
	local function UpdatePosition(updateFrame)
		if frame.API_Animation_PositionIdentifier ~= startTime or (stopEvent and stopEvent(frame)) then return Animation:RemoveFromQueue(updateFrame) end
		local eased = animationFunc((GetTime() - startTime) / duration, 0, 1, 1)
		frame:ClearAllPoints()
		frame:SetPoint(point, parent, currentX + (endX - currentX) * eased, currentY + (endY - currentY) * eased)
		if GetTime() >= endTime then frame:ClearAllPoints() frame:SetPoint(point, parent, endX, endY) Animation:RemoveFromQueue(updateFrame) end
	end
	local updateFrame = Animation:AddToQueue(frame, UpdatePosition)
	UpdatePosition(updateFrame)
end

function Animation:Rotate(frame, duration, startRotation, endRotation, animationStyle, stopEvent)
	if not duration and fail("No duration specified.") then return end
	if (not startRotation or not endRotation) and fail("Parameters not specified.") then return end
	if not frame and fail("No frame specified.") then return end

	local startTime, endTime = GetTime(), GetTime() + duration
	local animationFunc = animationStyle or Animation.EaseExpo
	frame.API_Animation_RotationIdentifier = startTime
	frame:SetRotation(startRotation)

	local function UpdateRotation(updateFrame)
		if frame.API_Animation_RotationIdentifier ~= startTime or (stopEvent and stopEvent(frame)) then return Animation:RemoveFromQueue(updateFrame) end
		local eased = animationFunc((GetTime() - startTime) / duration, 0, 1, 1)
		frame:SetRotation((startRotation + (endRotation - startRotation) * eased) % 360)
		if GetTime() >= endTime then frame:SetRotation(endRotation % 360) Animation:RemoveFromQueue(updateFrame) end
	end

	local updateFrame = Animation:AddToQueue(frame, UpdateRotation)
	UpdateRotation(updateFrame)
end

function Animation:IntializeFrameForRotation(frame)
	if frame.API_Animation_RotationInitalized then return end
	frame.API_Animation_RotationInitalized = true
	local rotationFrame = CreateFrame("Frame")
	frame.API_Animation_Rotation = rotationFrame
	rotationFrame.StartTime, rotationFrame.Speed = 0, 0
	hooksecurefunc(rotationFrame, "Show", function() rotationFrame.SavedRotation, rotationFrame.StartTime = frame:GetRotation(), GetTime() end)
	rotationFrame:SetScript("OnUpdate", function(_, elapsed)
		local transition = math.min((GetTime() - rotationFrame.StartTime) / 0.1, 1)
		local delta = rotationFrame.Speed * elapsed * transition
		rotationFrame.SavedRotation = rotationFrame.SavedRotation + delta
		frame:SetRotation(rotationFrame.SavedRotation)
	end)
	rotationFrame:Hide()
end

function Animation:StartRotate(frame, speed)
	if not frame and fail("No frame specified.") then return end
	Animation:IntializeFrameForRotation(frame)
	frame.API_Animation_RotationIdentifier = nil
	frame.API_Animation_Rotation.Speed = speed
	frame.API_Animation_Rotation:Show()
end

function Animation:StopRotate(frame)
	if not frame and fail("No frame specified.") then return end
	Animation:IntializeFrameForRotation(frame)
	frame.API_Animation_Rotation:Hide()
end

function Animation:SetProgressTo(frame, value, duration, animationStyle, stopEvent)
	local currentValue, delta = frame:GetValue(), value - frame:GetValue()
	local startTime, endTime = GetTime(), GetTime() + duration
	local animationFunc = animationStyle or Animation.EaseExpo
	frame.API_Animation_ProgressIdentifier = startTime
	local function UpdateProgress(self)
		if frame.API_Animation_ProgressIdentifier ~= startTime or (stopEvent and stopEvent(frame)) then return self:SetScript("OnUpdate", nil) end
		local eased = animationFunc((GetTime() - startTime) / duration, 0, 1, 1)
		frame:SetValue(currentValue + delta * eased)
		if GetTime() >= endTime then frame:SetValue(value) self:SetScript("OnUpdate", nil) end
	end
	local updateFrame = CreateFrame("Frame", "addon.API.Animation -- UpdateProgress")
	updateFrame:SetScript("OnUpdate", UpdateProgress)
	UpdateProgress(updateFrame)
end

local function smoothScroll(frame, setter, getter, rangeGetter, deltaScale)
	frame:SetScript("OnMouseWheel", function(self, delta)
		local current = getter(self)
		local target = current + -delta * (deltaScale or 100)
		if rangeGetter then
			local minScroll, maxScroll = 0, rangeGetter(self)
			target = math.max(minScroll, math.min(target, maxScroll))
		end
		setter(self, current, target)
	end)
end

function Animation:SetVerticalScrollTo(frame, current, new)
	local startTime = GetTime()
	local duration = .25
	frame:SetScript("OnUpdate", function(self)
		local progress = (GetTime() - startTime) / duration
		if progress < 1 then frame:SetVerticalScroll(current + (new - current) * progress) else frame:SetVerticalScroll(new) self:SetScript("OnUpdate", nil) end
	end)
end

function Animation:AddSmoothVerticalScrolling(frame)
	smoothScroll(frame, function(obj, cur, target) Animation:SetVerticalScrollTo(obj, cur, target) end, frame.GetVerticalScroll, nil, 100)
end

function Animation:SetHorizontalScrollTo(frame, current, new)
	local startTime = GetTime()
	local duration = .25
	local minScroll, maxScroll = 0, frame:GetHorizontalScrollRange()
	new = math.max(minScroll, math.min(new, maxScroll))
	frame:SetScript("OnUpdate", function(self)
		local progress = (GetTime() - startTime) / duration
		if progress < 1 then frame:SetHorizontalScroll(math.max(minScroll, math.min(current + (new - current) * progress, maxScroll))) else frame:SetHorizontalScroll(new) self:SetScript("OnUpdate", nil) end
	end)
end

function Animation:AddSmoothHorizontalScrolling(frame)
	smoothScroll(frame, function(obj, cur, target) Animation:SetHorizontalScrollTo(obj, cur, target) end, frame.GetHorizontalScroll, frame.GetHorizontalScrollRange, 100)
end

function Animation:AddHorizontalScrolling(frame)
	smoothScroll(frame, function(obj, cur, target)
		obj:SetHorizontalScroll(target)
		local minScroll, maxScroll = 0, obj:GetHorizontalScrollRange()
		if obj:GetHorizontalScroll() <= minScroll then obj:SetHorizontalScroll(minScroll) elseif obj:GetHorizontalScroll() >= maxScroll then obj:SetHorizontalScroll(maxScroll) end
	end, frame.GetHorizontalScroll, frame.GetHorizontalScrollRange, 50)
end

function Animation:CreateSpriteSheet(parent, path, rows, columns, playbackSpeed)
	local frame = CreateFrame("Frame")
	frame:SetParent(parent)
	frame.texture = frame:CreateTexture(nil, "BACKGROUND")
	frame.texture:SetTexture(path)
	frame.texture:SetAllPoints(frame)
	local totalFrames, frameWidth, frameHeight = rows * columns, 1 / columns, 1 / rows
	local currentFrame = 0
	function frame.Play(reverse)
		frame:SetScript("OnUpdate", function(self, elapsed)
			self.elapsed = (self.elapsed or 0) + elapsed
			if self.elapsed < playbackSpeed then return end
			self.elapsed = 0
			currentFrame = currentFrame + 1
			if currentFrame >= totalFrames then frame:SetAlpha(0) currentFrame = 0 frame:SetScript("OnUpdate", nil) elseif frame:GetAlpha() == 0 then frame:SetAlpha(1) end
			local column, row = currentFrame % columns, math.floor(currentFrame / columns)
			local left, right, top, bottom = column * frameWidth, column * frameWidth + frameWidth, row * frameHeight, row * frameHeight + frameHeight
			if reverse then frame.texture:SetTexCoord(right, left, top, bottom) else frame.texture:SetTexCoord(left, right, top, bottom) end
		end)
	end
	return frame
end

function Animation:PlaySpriteSheet(frameTexture, playbackSpeed, path, totalFrames)
	local texture = frameTexture:GetTexture()
	frameTexture:SetTexture(path .. "_1.png")
	local currentFrame = 0
	function frameTexture.Play()
		frameTexture:SetScript("OnUpdate", function(self)
			currentFrame = currentFrame + 1
			if currentFrame >= totalFrames then frameTexture:SetTexture(texture) self:SetScript("OnUpdate", nil) end
			frameTexture:SetTexture(path .. "_" .. currentFrame .. ".png")
		end)
	end
	frameTexture.Play()
end

function Animation:AddParallax(frame, parent, startRequirement, snapStopEvent, isController)
	frame.EnterMouseX, frame.EnterMouseY = nil, nil
	local function FollowCursor()
		if not frame.EnterMouseX or not frame.EnterMouseY then return end
		local mouseX, mouseY = addon.API.FrameUtil:GetMouseDelta(frame.EnterMouseX, frame.EnterMouseY)
		if not isController and (not startRequirement or startRequirement()) then frame:SetPoint("CENTER", parent, mouseX / (25 * (frame.API_Animation_Parallax_Weight or 1)), -mouseY / (7.5 * (frame.API_Animation_Parallax_Weight or 1))) end
	end
	local function OnEnter()
		if not isController and startRequirement and startRequirement() then frame.EnterMouseX, frame.EnterMouseY = GetCursorPosition() frame.API_Animation_Parallax_Update:Show() end
	end
	local function OnLeave()
		frame.EnterMouseX, frame.EnterMouseY = nil, nil
		frame.API_Animation_Parallax_Update:Hide()
		Animation:MoveTo(frame, .5 / (frame.API_Animation_Parallax_Weight or 1), "CENTER", parent, nil, nil, 0, 0, Animation.EaseExpo, function() return frame.EnterMouseX ~= nil or frame.EnterMouseY ~= nil end)
	end
	addon.API.FrameTemplates:CreateMouseResponder(parent, { enterCallback = OnEnter, leaveCallback = OnLeave })
	frame.API_Animation_Parallax_Update = CreateFrame("Frame", "$parent.addon.API-Animation.lua -- Parallax", parent)
	frame.API_Animation_Parallax_Update:SetParent(parent)
	frame.API_Animation_Parallax_Update:SetScript("OnUpdate", FollowCursor)
end
