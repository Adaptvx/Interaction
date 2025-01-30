local addonName, addon = ...

--------------------------------
-- VARIABLES
--------------------------------

AdaptiveAPI.Animation = {}

do -- MAIN

end

do -- CONSTANTS

end

--------------------------------
-- EASING CALCULATION
--------------------------------

do
	-- Linear
	function AdaptiveAPI.Animation.EaseLinear(t, b, c, d)
		return t
	end

	-- Sine
	function AdaptiveAPI.Animation.EaseSine(t, b, c, d)
		return c * math.sin(t / d * (math.pi / 2)) + b
	end

	-- Out sine
	function AdaptiveAPI.Animation.EaseOutSine(t, b, c, d)
		return (c - b) * math.sin(t / d * (math.pi / 2)) + b
	end

	-- In out sine
	function AdaptiveAPI.Animation.EaseInOutSine(t, b, c, d)
		return -(c - b) / 2 * (math.cos(math.pi * t / d) - 1) + b
	end

	-- Quad
	function AdaptiveAPI.Animation.EaseQuad(t, b, c, d)
		t = t / d
		return -c * t * (t - 2) + b
	end

	-- Quint
	function AdaptiveAPI.Animation.EaseQuint(t, b, c, d)
		t = t / d - 1
		return c * (t * t * t * t * t + 1) + b
	end

	-- Quart
	function AdaptiveAPI.Animation.EaseQuart(t, b, c, d)
		t = t / d - 1
		return -c * (t * t * t * t - 1) + b
	end

	-- Cubic
	function AdaptiveAPI.Animation.EaseCubic(t, b, c, d)
		t = t / d - 1
		return c * (t * t * t + 1) + b
	end

	-- Expo
	function AdaptiveAPI.Animation.EaseExpo(t, b, c, d)
		if t == d then
			return b + c
		end
		return c * (-2 ^ (-10 * t / d) + 1) + b
	end

	-- Out Expo
	function AdaptiveAPI.Animation.EaseOutExpo(t, b, c, d)
		if t == d then
			return b + (c - b)
		end
		return (c - b) * (-2 ^ (-10 * t / d) + 1) + b
	end

	-- Elastic
	function AdaptiveAPI.Animation.EaseElastic(t, b, c, d)
		local p = .3 * d
		local s = p / 4

		if t == 0 then
			return b
		elseif t >= d then
			return b + c
		end

		t = t / d
		return c * (2 ^ (-10 * t) * math.sin((t * d - s) * (2 * math.pi) / p)) + c + b
	end
end

--------------------------------
-- FUNCTIONS
--------------------------------

do -- UPDATE QUEUE
	function AdaptiveAPI.Animation:AddToQueue(frame, animType, callback, priority)
		local _ = CreateFrame("Frame", nil, frame:GetParent())
		_:SetScript("OnUpdate", function(self, elapsed)
			callback(self, self, elapsed)
		end)

		--------------------------------

		return _
	end

	function AdaptiveAPI.Animation:RemoveFromQueue(updateFrame)
		updateFrame:SetScript("OnUpdate", nil)
		updateFrame:Hide()
	end
end

do -- ANIMATIONS
	-- Fades in the frame over the duration from A to B. Not restricted.
	function AdaptiveAPI.Animation:Fade(frame, duration, startAlpha, endAlpha, animationStyle, stopEvent)
		if not duration then
			print("Failed Animation: No duration specified.")
			return
		end

		if startAlpha > 1 or endAlpha > 1 then
			print("Failed Animation: Alpha cannot be greater than 1.")
			return
		end

		if not frame then
			print("Failed Animation: No frame specified.")
			return
		end

		--------------------------------

		local startTime = GetTime()
		local endTime = startTime + duration
		local animationFunc
		if animationStyle then
			animationFunc = animationStyle
		else
			animationFunc = AdaptiveAPI.Animation.EaseLinear
		end

		--------------------------------

		frame.AdaptiveAPI_Animation_FadeIdentifier = startTime

		--------------------------------

		frame:SetAlpha(startAlpha)

		--------------------------------

		local function UpdateAlpha(updateFrame)
			local function RemoveFromQueue()
				AdaptiveAPI.Animation:RemoveFromQueue(updateFrame)
			end

			if frame.AdaptiveAPI_Animation_FadeIdentifier ~= startTime then
				RemoveFromQueue()
				return
			end

			if stopEvent and stopEvent() then
				RemoveFromQueue()
				return
			end

			-- if not frame:IsVisible() then
			-- 	RemoveFromQueue()
			-- 	return
			-- end

			--------------------------------

			local currentTime = GetTime()
			local progress = (currentTime - startTime) / duration

			--------------------------------

			local easedProgress = animationFunc(progress, 0, 1, 1)
			local currentAlpha = startAlpha + (endAlpha - startAlpha) * easedProgress

			if currentAlpha > 1 then currentAlpha = 1 end
			if currentAlpha < 0 then currentAlpha = 0 end

			--------------------------------

			frame:SetAlpha(currentAlpha)

			--------------------------------

			if currentTime >= endTime then
				frame:SetAlpha(endAlpha)

				--------------------------------

				RemoveFromQueue()
			end
		end

		--------------------------------

		local UpdateFrame = AdaptiveAPI.Animation:AddToQueue(frame, "Fade", UpdateAlpha, 1)

		--------------------------------

		UpdateAlpha(UpdateFrame)
	end

	-- Fades a text over the duration from A to B. Not restricted. Must be used on 'FontString'.
	function AdaptiveAPI.Animation:FadeText(text, duration, width, startAlpha, animationStyle, stopEvent)
		if not text or not duration or not width then
			print("Failed Animation: Parameters not specified.")
			return
		end

		--------------------------------

		if not text.AdaptiveAPI_Animation_FadeTextFrame then
			text.AdaptiveAPI_Animation_FadeTextFrame = CreateFrame("Frame", nil, text:GetParent())
		end
		local frame = text.AdaptiveAPI_Animation_FadeTextFrame

		--------------------------------

		local animationFunc = animationStyle or AdaptiveAPI.Animation.EaseLinear

		--------------------------------

		local textParent = text:GetParent():GetParent()
		local textFrame = text:GetParent()

		text:SetAlpha(startAlpha or 1)
		text:SetAlphaGradient(0, width)
		text:SetIgnoreParentAlpha(true)

		--------------------------------

		addon.Libraries.AceTimer:ScheduleTimer(function()
			local Length = strlenutf8(text:GetText() or "")
			local Speed = ceil(Length / duration) + 10
			local Progress = 0

			local CurrentTime = 0
			-- local AlphaUpdateInterval = .025
			-- local NextAlphaUpdateTime = CurrentTime + AlphaUpdateInterval

			--------------------------------

			local function UpdateAlpha(updateFrame, self, elapsed)
				local function RemoveFromQueue()
					AdaptiveAPI.Animation:RemoveFromQueue(updateFrame)
					text:SetAlpha(1)
					text:SetIgnoreParentAlpha(false)
				end

				if stopEvent and stopEvent() then
					RemoveFromQueue()
					return
				end

				-- if not text:IsVisible() then
				-- 	RemoveFromQueue()
				-- 	return
				-- end

				--------------------------------

				CurrentTime = CurrentTime + elapsed
				Progress = Progress + (elapsed * Speed)

				local EasedProgress = animationFunc(CurrentTime, 0, 1, 1)
				local NewProgress = Progress * EasedProgress

				-- if CurrentTime >= NextAlphaUpdateTime then
				-- 	local SavedAlpha = textParent:GetEffectiveAlpha()
				-- 	text:SetAlpha(SavedAlpha)
				-- 	text:SetAlphaGradient(NewProgress, width)

				-- 	NextAlphaUpdateTime = CurrentTime + AlphaUpdateInterval
				-- end

				if not text:SetAlphaGradient(NewProgress, width) then
					RemoveFromQueue()
				end
			end

			--------------------------------

			AdaptiveAPI.Animation:AddToQueue(frame, "FadeText", UpdateAlpha, 5)
		end, 0)
	end

	-- Scales the frame from A to B over the duration. Not restricted.
	function AdaptiveAPI.Animation:Scale(frame, duration, startScale, endScale, axis, animationStyle, stopEvent)
		if not duration then
			print("Failed Animation: No duration specified.")
			return
		end

		if (type(startScale) == "number" and startScale <= 0) or (type(endScale) == "number" and endScale <= 0) then
			print("Failed Animation: Scale cannot be less than or equal to 0.")
			return
		end

		if not frame then
			print("Failed Animation: No frame specified.")
			return
		end

		--------------------------------

		local startTime = GetTime()
		local endTime = startTime + duration
		local animationFunc
		if animationStyle then
			animationFunc = animationStyle
		else
			animationFunc = AdaptiveAPI.Animation.EaseExpo
		end

		--------------------------------

		frame.AdaptiveAPI_Animation_ScaleIdentifier = startTime

		--------------------------------

		local setWidthFunc, setHeightFunc
		local startWidth, startHeight
		local endWidth, endHeight
		if axis == "x" then
			setWidthFunc = frame.SetWidth
			setHeightFunc = nil
			startWidth = startScale
			endWidth = endScale
		elseif axis == "y" then
			setHeightFunc = frame.SetHeight
			setWidthFunc = nil
			startHeight = startScale
			endHeight = endScale
		elseif axis == "both" then
			setWidthFunc = frame.SetWidth
			setHeightFunc = frame.SetHeight
			startWidth = startScale.x
			startHeight = startScale.y
			endWidth = endScale.x
			endHeight = endScale.y
		else
			setWidthFunc = frame.SetScale
			setHeightFunc = nil
			startWidth = startScale
			endWidth = endScale
		end

		--------------------------------

		if setWidthFunc then
			setWidthFunc(frame, startWidth)
		end
		if setHeightFunc then
			setHeightFunc(frame, startHeight)
		end

		--------------------------------

		local function UpdateScale(updateFrame, self, elapsed)
			local function RemoveFromQueue()
				AdaptiveAPI.Animation:RemoveFromQueue(updateFrame)
			end

			if frame.AdaptiveAPI_Animation_ScaleIdentifier ~= startTime then
				RemoveFromQueue()
				return
			end

			if stopEvent and stopEvent() then
				RemoveFromQueue()
				return
			end

			-- if not frame:IsVisible() then
			-- 	RemoveFromQueue()
			-- 	return
			-- end

			--------------------------------

			local currentTime = GetTime()
			local progress = (currentTime - startTime) / duration

			local easedProgress = animationFunc(progress, 0, 1, 1)

			if setWidthFunc then
				local currentWidth = startWidth + (endWidth - startWidth) * easedProgress

				--------------------------------

				setWidthFunc(frame, currentWidth)
			end
			if setHeightFunc then

				--------------------------------

				local currentHeight = startHeight + (endHeight - startHeight) * easedProgress
				setHeightFunc(frame, currentHeight)
			end

			--------------------------------

			if currentTime >= endTime then
				if setWidthFunc then
					setWidthFunc(frame, endWidth)
				end
				if setHeightFunc then
					setHeightFunc(frame, endHeight)
				end

				--------------------------------

				RemoveFromQueue()
			end
		end

		--------------------------------

		local UpdateFrame = AdaptiveAPI.Animation:AddToQueue(frame, "Scale", UpdateScale, 1)

		--------------------------------

		UpdateScale(UpdateFrame)
	end

	-- Moves the frame from Point A to B over the duration. Restricted.
	function AdaptiveAPI.Animation:Move(frame, duration, point, startPosition, endPosition, axis, animationStyle, stopEvent)
		if not duration then
			print("Failed Animation: No duration specified.")
			return
		end

		if not point or not startPosition or not endPosition then
			print("Failed Animation: Parameters not specified.")
			return
		end

		if not frame then
			print("Failed Animation: No frame specified.")
			return
		end

		--------------------------------

		local startTime = GetTime()
		local endTime = startTime + duration
		local animationFunc = AdaptiveAPI.Animation.EaseExpo
		if animationStyle then
			animationFunc = animationStyle
		end

		--------------------------------

		frame.AdaptiveAPI_Animation_PositionIdentifier = startTime

		--------------------------------

		local function UpdatePosition(updateFrame, self, elapsed)
			local function RemoveFromQueue()
				AdaptiveAPI.Animation:RemoveFromQueue(updateFrame)
				return
			end

			if frame.AdaptiveAPI_Animation_PositionIdentifier ~= startTime then
				RemoveFromQueue()
				return
			end

			if stopEvent and stopEvent() then
				RemoveFromQueue()
				return
			end

			-- if not frame:IsVisible() then
			-- 	RemoveFromQueue()
			-- 	return
			-- end

			--------------------------------

			local currentTime = GetTime()
			local progress = (currentTime - startTime) / duration

			local easedProgress = animationFunc(progress, 0, 1, 1)
			local currentOffset = startPosition + (endPosition - startPosition) * easedProgress

			local _point, _relativeTo, _relativePoint, _offsetX, _offsetY = frame:GetPoint()

			--------------------------------

			frame:ClearAllPoints()
			if axis == "x" then
				frame:SetPoint(point, _relativeTo, currentOffset, _offsetY)
			elseif axis == "y" then
				frame:SetPoint(point, _relativeTo, _offsetX, currentOffset)
			end

			--------------------------------

			if currentTime >= endTime then
				frame:ClearAllPoints()
				if axis == "x" then
					frame:SetPoint(point, _relativeTo, endPosition, _offsetY)
				elseif axis == "y" then
					frame:SetPoint(point, _relativeTo, _offsetX, endPosition)
				end

				--------------------------------

				RemoveFromQueue()
			end
		end

		--------------------------------

		local UpdateFrame = AdaptiveAPI.Animation:AddToQueue(frame, "Move", UpdatePosition, 1)

		--------------------------------

		UpdatePosition(UpdateFrame)
	end

	-- Moves the frame in both X and Y axes. Not restricted.
	function AdaptiveAPI.Animation:PreciseMove(frame, duration, relativeTo, point, startX, startY, endX, endY, animationStyle, stopEvent)
		if not duration then
			print("Failed Animation: No duration specified.")
			return
		end

		if not point or not relativeTo or not startX or not startY or not endX or not endY then
			print("Failed Animation: Parameters not specified.")
			return
		end

		if not frame then
			print("Failed Animation: No frame specified.")
			return
		end

		--------------------------------

		local startTime = GetTime()
		local endTime = startTime + duration
		local animationFunc = AdaptiveAPI.Animation.EaseExpo
		if animationStyle then
			animationFunc = animationStyle
		end

		--------------------------------

		frame.AdaptiveAPI_Animation_PositionIdentifier = startTime

		--------------------------------

		local function UpdatePosition(updateFrame, self, elapsed)
			local function RemoveFromQueue()
				AdaptiveAPI.Animation:RemoveFromQueue(updateFrame)
			end

			if frame.AdaptiveAPI_Animation_PositionIdentifier ~= startTime then
				RemoveFromQueue()
				return
			end

			if stopEvent and stopEvent() then
				RemoveFromQueue()
				return
			end

			-- if not frame:IsVisible() then
			-- 	RemoveFromQueue()
			-- 	return
			-- end

			--------------------------------

			local currentTime = GetTime()
			local progress = (currentTime - startTime) / duration

			local easedProgress = animationFunc(progress, 0, 1, 1)
			local newX = startX + (endX - startX) * easedProgress
			local newY = startY + (endY - startY) * easedProgress

			--------------------------------

			frame:ClearAllPoints()
			frame:SetPoint(point, relativeTo, newX, newY)

			--------------------------------

			if currentTime >= endTime then
				frame:ClearAllPoints()
				frame:SetPoint(point, relativeTo, endX, endY)

				--------------------------------

				RemoveFromQueue()
			end
		end

		--------------------------------

		local UpdateFrame = AdaptiveAPI.Animation:AddToQueue(frame, "PreciseMove", UpdatePosition, 1)

		--------------------------------

		UpdatePosition(UpdateFrame)
	end

	-- Moves the frame from the current position to the specified position over the duration. Restricted.
	function AdaptiveAPI.Animation:MoveTo(frame, duration, point, parent, currentX, currentY, endX, endY, animationStyle, stopEvent)
		if not duration then
			print("Failed Animation: No duration specified.")
			return
		end

		if not point or not parent or not endX or not endY then
			print("Failed Animation: Parameters not specified.")
			return
		end

		if not frame then
			print("Failed Animation: No frame specified.")
			return
		end

		--------------------------------

		local startTime = GetTime()
		local endTime = startTime + duration
		local animationFunc = AdaptiveAPI.Animation.EaseExpo
		if animationStyle then
			animationFunc = animationStyle
		end

		--------------------------------

		if not currentX or not currentY then
			local _, _, _, _currentX, _currentY = frame:GetPoint()
			currentX = _currentX
			currentY = _currentY
		end

		--------------------------------

		frame.AdaptiveAPI_Animation_PositionIdentifier = startTime

		--------------------------------

		local function UpdatePosition(updateFrame, self, elapsed)
			local function RemoveFromQueue()
				AdaptiveAPI.Animation:RemoveFromQueue(updateFrame)
			end

			if frame.AdaptiveAPI_Animation_PositionIdentifier ~= startTime then
				RemoveFromQueue()
				return
			end

			if stopEvent and stopEvent() then
				RemoveFromQueue()
				return
			end

			-- if not frame:IsVisible() then
			-- 	RemoveFromQueue()
			-- 	return
			-- end

			--------------------------------

			local currentTime = GetTime()
			local progress = (currentTime - startTime) / duration

			local easedProgress = animationFunc(progress, 0, 1, 1)
			local newX = currentX + (endX - currentX) * easedProgress
			local newY = currentY + (endY - currentY) * easedProgress

			--------------------------------

			frame:ClearAllPoints()
			frame:SetPoint(point, parent, newX, newY)

			--------------------------------

			if currentTime >= endTime then
				frame:ClearAllPoints()
				frame:SetPoint(point, parent, endX, endY)

				--------------------------------

				RemoveFromQueue()
			end
		end

		--------------------------------

		local UpdateFrame = AdaptiveAPI.Animation:AddToQueue(frame, "MoveTo", UpdatePosition, 1)

		--------------------------------

		UpdatePosition(UpdateFrame)
	end

	-- Rotates the texture from Point A to B over the duration. Not Restricted. Must be used on 'Texture'.
	function AdaptiveAPI.Animation:Rotate(frame, duration, startRotation, endRotation, animationStyle, stopEvent)
		if not duration then
			print("Failed Animation: No duration specified.")
			return
		end

		if not startRotation or not endRotation then
			print("Failed Animation: Parameters not specified.")
			return
		end

		if not frame then
			print("Failed Animation: No frame specified.")
			return
		end

		--------------------------------

		local startTime = GetTime()
		local endTime = startTime + duration
		local animationFunc = animationStyle or AdaptiveAPI.Animation.EaseExpo

		--------------------------------

		frame.AdaptiveAPI_Animation_RotationIdentifier = startTime

		--------------------------------

		frame:SetRotation(startRotation)

		--------------------------------

		local function UpdateRotation(updateFrame, self, elapsed)
			local function RemoveFromQueue()
				AdaptiveAPI.Animation:RemoveFromQueue(updateFrame)
			end

			if frame.AdaptiveAPI_Animation_RotationIdentifier ~= startTime then
				RemoveFromQueue()
				return
			end

			if stopEvent and stopEvent() then
				RemoveFromQueue()
				return
			end

			-- if not frame:IsVisible() then
			-- 	RemoveFromQueue()
			-- 	return
			-- end

			--------------------------------

			local currentTime = GetTime()
			local progress = (currentTime - startTime) / duration

			local easedProgress = animationFunc(progress, 0, 1, 1)
			local currentRotation = startRotation + (endRotation - startRotation) * easedProgress

			currentRotation = currentRotation % 360

			--------------------------------

			frame:SetRotation(currentRotation)

			--------------------------------

			if currentTime >= endTime then
				frame:SetRotation(endRotation % 360)

				--------------------------------

				RemoveFromQueue()
			end
		end

		--------------------------------

		local UpdateFrame = AdaptiveAPI.Animation:AddToQueue(frame, "Rotate", UpdateRotation, 1)

		--------------------------------

		UpdateRotation(UpdateFrame)
	end

	-- [BACKEND] Initalizes the frame to support rotation functions.
	function AdaptiveAPI.Animation:IntializeFrameForRotation(frame)
		if not frame.AdaptiveAPI_Animation_RotationInitalized then
			frame.AdaptiveAPI_Animation_RotationInitalized = true

			--------------------------------

			local RotationFrame = CreateFrame("Frame"); frame.AdaptiveAPI_Animation_Rotation = RotationFrame
			RotationFrame.StartTime = 0
			RotationFrame.Speed = 0

			--------------------------------

			hooksecurefunc(RotationFrame, "Show", function()
				RotationFrame.SavedRotation = frame:GetRotation()
				RotationFrame.StartTime = GetTime()
			end)

			RotationFrame:SetScript("OnUpdate", function(self, TimeElapsed)
				local Speed = RotationFrame.Speed

				local StartTime = RotationFrame.StartTime
				local CurrentTime = GetTime()
				local Duration = .1
				local Transition = (CurrentTime - StartTime) / Duration

				if Transition >= 1 then
					Transition = 1
				end

				--------------------------------

				frame:SetRotation(RotationFrame.SavedRotation + (Speed * TimeElapsed * Transition))
				RotationFrame.SavedRotation = RotationFrame.SavedRotation + (Speed * TimeElapsed * Transition)
			end)

			--------------------------------

			RotationFrame:Hide()
		end
	end

	-- Starts rotating the Texture until cancelled. Not Restricted. Must be used on 'Texture'.
	function AdaptiveAPI.Animation:StartRotate(frame, speed)
		if not frame then
			print("Failed Animation: No frame specified.")
			return
		end

		--------------------------------

		AdaptiveAPI.Animation:IntializeFrameForRotation(frame)

		--------------------------------

		frame.AdaptiveAPI_Animation_RotationIdentifier = nil
		frame.AdaptiveAPI_Animation_Rotation.Speed = speed

		--------------------------------

		frame.AdaptiveAPI_Animation_Rotation:Show()
	end

	-- Stops rotating the Texture. Not Restricted. Must be used on 'Texture'.
	function AdaptiveAPI.Animation:StopRotate(frame)
		if not frame then
			print("Failed Animation: No frame specified.")
			return
		end

		--------------------------------

		AdaptiveAPI.Animation:IntializeFrameForRotation(frame)

		--------------------------------

		frame.AdaptiveAPI_Animation_Rotation:Hide()
	end

	-- Sets and animates the current progress to the new value. Not restricted. Must be used on 'StatusBar'.
	function AdaptiveAPI.Animation:SetProgressTo(frame, value, duration, animationStyle, stopEvent)
		local currentValue = frame:GetValue()
		local delta = value - currentValue
		local startTime = GetTime()
		local endTime = startTime + duration

		--------------------------------

		local animationFunc = AdaptiveAPI.Animation.EaseExpo
		if animationStyle then
			animationFunc = animationStyle
		end

		--------------------------------

		frame.AdaptiveAPI_Animation_ProgressIdentifier = startTime

		--------------------------------

		local function UpdateProgress(self)
			if frame.AdaptiveAPI_Animation_ProgressIdentifier ~= startTime then
				self:SetScript("OnUpdate", nil)
				return
			end

			if stopEvent and stopEvent() then
				self:SetScript("OnUpdate", nil)
				return
			end

			--------------------------------

			local currentTime = GetTime()
			local progress = (currentTime - startTime) / duration

			local easedProgress = animationFunc(progress, 0, 1, 1)
			local newValue = currentValue + delta * easedProgress

			--------------------------------

			frame:SetValue(newValue)

			--------------------------------

			if currentTime >= endTime then
				frame:SetValue(value)

				self:SetScript("OnUpdate", nil)
			end
		end

		--------------------------------

		local _ = CreateFrame("Frame", "AdaptiveAPI.Animation -- UpdateProgress")
		_:SetScript("OnUpdate", UpdateProgress)

		--------------------------------

		UpdateProgress()
	end

	-- Sets and animates the current vertical scroll position to the new position. Not restricted. Must be used on "ScrollFrame"
	function AdaptiveAPI.Animation:SetVerticalScrollTo(frame, current, new)
		local startTime = GetTime()
		local duration = .25

		--------------------------------

		local function UpdateScrollPosition(self)
			local timeNow = GetTime()
			local deltaTime = timeNow - startTime
			local progress = deltaTime / duration

			--------------------------------

			if progress < 1 then
				local newPos = current + (new - current) * progress
				frame:SetVerticalScroll(newPos)
			else
				frame:SetVerticalScroll(new)

				self:SetScript("OnUpdate", nil)
			end
		end

		--------------------------------

		frame:SetScript("OnUpdate", UpdateScrollPosition)
	end

	-- Adds smooth vertical scrolling. Not restricted. Must be used on "ScrollFrame"
	function AdaptiveAPI.Animation:AddSmoothVerticalScrolling(frame)
		frame:SetScript("OnMouseWheel", function(self, delta)
			local current = self:GetVerticalScroll()

			--------------------------------

			AdaptiveAPI.Animation:SetVerticalScrollTo(self, current, current + -delta * 100)
		end)
	end

	-- Sets and animates the current vertical scroll position to the new position. Not restricted. Must be used on "ScrollFrame"
	function AdaptiveAPI.Animation:SetHorizontalScrollTo(frame, current, new)
		local startTime = GetTime()
		local duration = .25

		local minScroll = 0
		local maxScroll = frame:GetHorizontalScrollRange()

		new = math.max(minScroll, math.min(new, maxScroll))

		--------------------------------

		local function UpdateScrollPosition(self)
			local timeNow = GetTime()
			local deltaTime = timeNow - startTime
			local progress = deltaTime / duration

			--------------------------------

			if progress < 1 then
				local newPos = current + (new - current) * progress
				newPos = math.max(minScroll, math.min(newPos, maxScroll))
				frame:SetHorizontalScroll(newPos)
			else
				frame:SetHorizontalScroll(new)

				self:SetScript("OnUpdate", nil)
			end
		end

		--------------------------------

		frame:SetScript("OnUpdate", UpdateScrollPosition)
	end

	-- Adds smooth vertical scrolling. Not restricted. Must be used on "ScrollFrame"
	function AdaptiveAPI.Animation:AddSmoothHorizontalScrolling(frame)
		frame:SetScript("OnMouseWheel", function(self, delta)
			local current = self:GetHorizontalScroll()

			--------------------------------

			AdaptiveAPI.Animation:SetHorizontalScrollTo(self, current, current + -delta * 100)
		end)
	end

	-- Adds smooth vertical scrolling. Not restricted. Must be used on "ScrollFrame"
	function AdaptiveAPI.Animation:AddHorizontalScrolling(frame)
		frame:SetScript("OnMouseWheel", function(self, delta)
			local current = self:GetHorizontalScroll()
			local minScroll = 0
			local maxScroll = frame:GetHorizontalScrollRange()

			--------------------------------

			self:SetHorizontalScroll(current + -delta * 50)

			--------------------------------

			if self:GetHorizontalScroll() <= minScroll then
				self:SetHorizontalScroll(minScroll)
			elseif self:GetHorizontalScroll() >= maxScroll then
				self:SetHorizontalScroll(maxScroll)
			end
		end)
	end

	-- Returns a texture with spritesheet playback. Use "frame.Play()" to start playback. Not restricted.
	function AdaptiveAPI.Animation:CreateSpriteSheet(parent, path, rows, columns, playbackSpeed, autoPlay)
		local frame = CreateFrame("Frame")
		frame:SetParent(parent)

		--------------------------------

		local function Texture()
			frame.texture = frame:CreateTexture(nil, "BACKGROUND")
			frame.texture:SetTexture(path)
			frame.texture:SetAllPoints(frame)
		end

		--------------------------------

		Texture()

		--------------------------------

		local totalRows = rows
		local totalColumns = columns
		local totalFrames = totalRows * totalColumns
		local frameWidth = 1 / totalColumns
		local frameHeight = 1 / totalRows

		local currentFrame = 0

		--------------------------------

		frame.Play = function(reverse)
			local function Play(reverse)
				currentFrame = currentFrame + 1

				--------------------------------

				if currentFrame >= totalFrames then
					frame:SetAlpha(0)
					currentFrame = 0

					--------------------------------

					frame:SetScript("OnUpdate", nil)
				else
					if frame:GetAlpha() == 0 then
						frame:SetAlpha(1)
					end
				end

				--------------------------------

				local column = currentFrame % totalColumns
				local row = math.floor(currentFrame / totalColumns)

				local left = column * frameWidth
				local right = left + frameWidth
				local top = row * frameHeight
				local bottom = top + frameHeight

				--------------------------------

				if reverse then
					frame.texture:SetTexCoord(right, left, top, bottom)
				else
					frame.texture:SetTexCoord(left, right, top, bottom)
				end
			end

			--------------------------------

			frame:SetScript("OnUpdate", function(self, elapsed)
				self.elapsed = (self.elapsed or 0) + elapsed

				--------------------------------

				if self.elapsed >= playbackSpeed then
					self.elapsed = 0

					--------------------------------

					Play(reverse)
				end
			end)
		end

		--------------------------------

		return frame
	end

	-- Use an existing texture to play a spritesheet animation. Not restricted. Must be used on "Texture".
	function AdaptiveAPI.Animation:PlaySpriteSheet(frameTexture, playbackSpeed, path, totalFrames)
		local texture = frameTexture:GetTexture()
		frameTexture:SetTexture(path .. "_" .. "1" .. ".png")

		--------------------------------

		local currentFrame = 0

		--------------------------------

		frameTexture.Play = function()
			local function Play()
				currentFrame = currentFrame + 1

				--------------------------------

				if currentFrame >= totalFrames then
					frameTexture:SetTexture(texture)

					--------------------------------

					frameTexture:SetScript("OnUpdate", nil)
				end

				--------------------------------

				frameTexture:SetTexture(path .. "_" .. currentFrame .. ".png")
			end

			--------------------------------

			frameTexture:SetScript("OnUpdate", Play)
		end

		--------------------------------

		frameTexture.Play()
	end

	function AdaptiveAPI.Animation:AddParallax(frame, parent, startRequirement, snapStopEvent, isController)
		frame.EnterMouseX = nil
		frame.EnterMouseY = nil

		--------------------------------

		local function FollowCursor()
			if frame.EnterMouseX and frame.EnterMouseY then
				local MouseX, MouseY = AdaptiveAPI:GetMouseDelta(frame.EnterMouseX, frame.EnterMouseY)

				--------------------------------

				if not isController then
					if not startRequirement or (startRequirement and startRequirement()) then
						frame:SetPoint("CENTER", parent, MouseX / (25 * (frame.AdaptiveAPI_Animation_Parallax_Weight or 1)), -MouseY / (7.5 * (frame.AdaptiveAPI_Animation_Parallax_Weight or 1)))
					end
				end
			end
		end

		local function OnEnter()
			if not isController then
				if startRequirement() then
					frame.EnterMouseX, frame.EnterMouseY = GetCursorPosition()
					frame.AdaptiveAPI_Animation_Parallax_Update:Show()
				end
			end
		end

		local function OnLeave()
			frame.EnterMouseX, frame.EnterMouseY = nil, nil
			frame.AdaptiveAPI_Animation_Parallax_Update:Hide()

			--------------------------------

			AdaptiveAPI.Animation:MoveTo(frame, (.5 / (frame.AdaptiveAPI_Animation_Parallax_Weight or 1)), "CENTER", parent, nil, nil, 0, 0, AdaptiveAPI.Animation.EaseExpo, function() return frame.EnterMouseX ~= nil or frame.EnterMouseY ~= nil end)
		end

		--------------------------------

		AdaptiveAPI.FrameTemplates:CreateMouseResponder(parent, OnEnter, OnLeave, nil, nil)

		--------------------------------

		frame.AdaptiveAPI_Animation_Parallax_Update = CreateFrame("Frame", "$parent.AdaptiveAPI-Animation.lua -- Parallax", parent)
		frame.AdaptiveAPI_Animation_Parallax_Update:SetParent(parent)
		frame.AdaptiveAPI_Animation_Parallax_Update:SetScript("OnUpdate", function()
			FollowCursor()
		end)
	end
end
