local TweenService = game:GetService("TweenService")
local TweenCoinEv = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TweenCoin")
local Debris = game:GetService("Debris")

local player = game.Players.LocalPlayer
local MountPoint = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("MountPoint")
local buttonsFrame = MountPoint:WaitForChild("0.25grid"):WaitForChild("4"):WaitForChild("Frame"):WaitForChild("Buttons")
local goldFrame = buttonsFrame:WaitForChild("Gold")

local image = MountPoint:WaitForChild("0.17grid"):WaitForChild("Last"):WaitForChild("Frame"):WaitForChild("Clover"):WaitForChild("ImageButton")
local targetPosition = MountPoint:WaitForChild("0.17grid"):WaitForChild("Last"):WaitForChild("Frame"):WaitForChild("Clover"):WaitForChild("ImageButton").AbsolutePosition
local startPosition = Vector2.new( MountPoint.AbsoluteSize.X /2 - 30 , MountPoint.AbsoluteSize.Y /2  - 70)
--local midPosition = (startPosition + targetPosition) / 2 + Vector2.new( 100, -100 )
local midPosition = Vector2.new(0,100)



local function Lerp(a, b, c)
	return a + (b - a) * c
end

local function QuadBezier (StartPosition, MidPosition, EndPosition, Offset)
	local L1 = Lerp(StartPosition, MidPosition, Offset)
	local L2 = Lerp(MidPosition, EndPosition, Offset)
	local QuadBezier = Lerp(L1, L2, Offset)

	return QuadBezier
end


local function tweenObject(object, count, maxCount)
	if count > maxCount then
		object:Remove()
		Debris:AddItem(object,1)
		return
	end
	
	local currentPosition = QuadBezier(startPosition, midPosition, targetPosition, count / maxCount)
	local PositionTween = game.TweenService:Create(
		object,
		TweenInfo.new( 1 / maxCount ),  -- 트윈에 걸리는 시간이 총 1초라고 가정
		{ Position = UDim2.new( 0, currentPosition.X, 0, currentPosition.Y ) }
	)

	PositionTween:Play()
	PositionTween.Completed:Connect(
		function(playbackState: Enum.PlaybackState) 
			--print(playbackState)
			--애니메이션 완료 이벤트에 재귀 호출
			tweenObject(object, count+1, maxCount)
		end
	)
end

local function tweenCloverGui(position : Vector3)
	local screenPoint = workspace.Camera:WorldToScreenPoint(position)
	startPosition = Vector2.new(screenPoint.X, screenPoint.Y)
	
	for i = 0, 15  do
		local object = image:Clone()
		object.Position = UDim2.new( 0, startPosition.X , 0, startPosition.Y )
		object.Size= UDim2.new(0, image.AbsoluteSize.X, 0 , image.AbsoluteSize.Y)
		object.Parent = MountPoint

		tweenObject(object, 0, 10)
		wait(0.25 - i/39)
	end
end


TweenCoinEv.Event:Connect(
	function(...: any) 
		local args = {...}
		tweenCloverGui(args[1])	
	end
)



