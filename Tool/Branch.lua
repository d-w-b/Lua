local tool = script.Parent
local damage = 35
local Debris = game:GetService("Debris")
local connection = nil
local damagePart = tool.Handle.DamagePart
local Players = game:GetService("Players")
local activationDebounced = false
local touchEnabled = false
local animationLength = 4
local animations = tool.Handle.Animations
local debounced = false

local toolOwnerCharacter = nil
local toolOwnerHumanoid = nil
local connection = nil

local rig15Animations = {
	Equip = animations.R15.Equip,
	LeftSlash = animations.R15.LeftSlash,
	RightSlash = animations.R15.RightSlash,
	SideSwipe = animations.R15.SideSwipe,
	Summon = animations.R15.Summon,
	Swing = animations.R15.Swing
}
local rig6Animations = {
	Equip = animations.R6.Equip,
	LeftSlash = animations.R6.LeftSlash,
	RightSlash = animations.R6.RightSlash,
	SideSwipe = animations.R6.SideSwipe,
	Summon = animations.R6.Summon,
	Swing = animations.R6.Swing
}

Grips = {
	Equip = tool.Grip
}


local animation = nil
local count = 0

local function handleActivated( )
	if not activationDebounced then
		count += 1
		activationDebounced = true
		touchEnabled = true

		if toolOwnerHumanoid.RigType == Enum.HumanoidRigType.R15 then
			animation = rig15Animations
		elseif toolOwnerHumanoid.RigType == Enum.HumanoidRigType.R6 then
			animation = rig6Animations
		end
		
		if count % 2 == 0 then
			animation = animation[ "LeftSlash" ]
		else 
			animation = animation[ "RightSlash" ]
		end
		
		local animationTrack = toolOwnerHumanoid:LoadAnimation(animation)
		animationLength = animationTrack.Length
		animationTrack:Play()
		wait(animationLength)
		activationDebounced = false
		touchEnabled = false
		debounced = false
	end
end

local Tool = script.Parent
Tool.Activated:Connect(
	handleActivated
)

Tool.Equipped:Connect(
	function(mouse: Mouse) 
		activationDebounced = true
		toolOwnerCharacter = tool.Parent
		toolOwnerHumanoid = toolOwnerCharacter:WaitForChild("Humanoid")
		
		if toolOwnerHumanoid.RigType == Enum.HumanoidRigType.R15 then
			animation = rig15Animations["Equip"]
		elseif toolOwnerHumanoid.RigType == Enum.HumanoidRigType.R6 then
			animation = rig6Animations["Equip"]
		end
		
		local animationTrack = toolOwnerHumanoid:LoadAnimation(animation)
		animationLength = animationTrack.Length
		animationTrack:Play()
		wait(animationLength)
		
		activationDebounced = false
	end
)

Tool.Unequipped:Connect(
	function() 
		local toolOwnerCharacter = nil
		local toolOwnerHumanoid = nil
	end
)

Tool.Handle.DamagePart.Touched:Connect(
	function(otherPart: BasePart)
		local character = otherPart.Parent
		local player = Players:GetPlayerFromCharacter(character)
		if touchEnabled and not player and not debounced then
			debounced = true
			local humanoid = character:FindFirstChild("Humanoid")
			if humanoid then
				local creator = humanoid:FindFirstChild("Creator")
				if creator then
					Debris:AddItem(creator, 1)
				end
				local newTag= Instance.new("ObjectValue")
				newTag.Value = Players:GetPlayerFromCharacter(tool.Parent)
				newTag.Name = "Creator"
				newTag.Parent = humanoid
				humanoid:TakeDamage(damage)
			end
		end	
	end
)

