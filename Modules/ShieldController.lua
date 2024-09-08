local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local ShieldController = {}
ShieldController.__index = ShieldController

function ShieldController.new(
	player: Player,
	viewModel : Model
)
	local self = {
		player = player,
		character = player.Character,
		viewModel = viewModel,
		playerHumanoid = player.Character.Humanoid
	}
	setmetatable(self, ShieldController)
	return self	
end

function ShieldController:Activate()
	self.shield = self.viewModel:Clone()
	
	local connections = {}
	
	-- 터치 이벤트
	table.insert(
		connections, 
		self.shield.PrimaryPart.Touched:Connect(
			function(hit : BasePart)
				local hitCharacter = hit.Parent
				local hitPlayer = Players:GetPlayerFromCharacter(hitCharacter)
				if not hitPlayer and hitCharacter:FindFirstChild("Humanoid") then
					local humanoid = hitCharacter.Humanoid
					humanoid:TakeDamage(30)
				end
			end
		)
	)
	self.shield:PivotTo( self.character.HumanoidRootPart.CFrame )
	self.shield.Parent = workspace
	
	local follow = coroutine.resume(
		coroutine.create(
			function()
				for i = 1 , 30 do
					task.wait(0.1)
					self:Move()
				end
			end
		)
	)
	
	
	wait(3)
	
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end
	
	self.shield:Destroy()
	Debris:AddItem(self.shield, 1)
	self.shield = nil
end

function ShieldController:Move()
	-- 플레이어가 이동 중이면, 쉴드도 따라가야 함
	if self.shield and self.playerHumanoid.MoveDirection.Magnitude > 0 then
		local direction = self.playerHumanoid.MoveDirection
		local tween = TweenService:Create(
			self.shield.PrimaryPart,
			TweenInfo.new(0.1),
			{ Position = self.character.HumanoidRootPart.CFrame.Position + direction * 3 }
		)
		
		tween:Play()
	end
end

return ShieldController
