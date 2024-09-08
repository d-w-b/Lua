local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local CollectionService = game:GetService("CollectionService")

local Objects = ReplicatedStorage:WaitForChild("Objects")
local Zone = require(ReplicatedStorage:WaitForChild("Script"):WaitForChild("Zone"))
local touchPadEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TouchPad")

local TYCOON_TAG = "Tycoon"
local VIEW_TAG= "View"
local TRANSPARENT_TAG = "Transparent"

local ModelController = {}
ModelController.__index = ModelController

function ModelController.new(
	object:Instance 
)
	local self = setmetatable({}, ModelController)
	self.object = object
	self.id = tonumber(object.Name)
	self.enabled = true
	self.connections = {}
	self.viewModel = self.object:FindFirstChildOfClass("Model")
	self.nextNodes = self.object.Next:GetChildren()
	self.pad = self.object.Pad
	self.padEnterPart = self.object.Pad.Enter
	self.player = game.Players.LocalPlayer
	self.zone = Zone.new(self.padEnterPart)
	--self:ConnectEntered()
	return self
end


function ModelController:ConnectEntered()
	table.insert(
		self.connections, 
		self.zone.localPlayerEntered:Connect(
			function() 
				print('entered')
				local player = game.Players.LocalPlayer

				if self.enabled then
					self.enabled = false
					self:UpdatePlayerData(self.player)
					print(self.nextNodes)
					for _, next in ipairs(self.nextNodes) do
						local node = next.Name
						Objects[node]:Clone().Parent = workspace
					end
				end
			end
		)
	)
end

function ModelController:UpdatePlayerData(player)
	touchPadEvent:FireServer(self.id)
end

function ModelController:Render()
	local pass = self.viewModel:WaitForChild("Pass").Value
	if pass then
		self:RemovePad()
	else 
		self:UpdateVisibility()
		self:ConnectPadEntered()
	end
end

function ModelController:PlaceModel()
	self.viewModel.Parent = self.object
	local targetPosition = self.viewModel.PrimaryPart.CFrame.Position
	local startPosition = targetPosition - Vector3.new(0, targetPosition.Y + 10, 0)
	self.viewModel.PrimaryPart:PivotTo(CFrame.new(startPosition))
	local tween = TweenService:Create(self.viewModel.PrimaryPart, TweenInfo.new(.7), {CFrame = CFrame.new( targetPosition )})
	tween:Play()
	tween.Completed:Wait()
end

function ModelController:RemoveModel()
	self.viewModel.Parent = nil
end

function ModelController:PlacePad()
	self.pad.Parent = self.object
end

function ModelController:PlaceNextPads()
	for _, nextNode in ipairs(self.nextNodes) do
		local object = Objects[nextNode.Name]:Clone()
		CollectionService:AddTag(object, TYCOON_TAG)
		CollectionService:AddTag(object, TRANSPARENT_TAG)
		object.Parent = workspace
	end
end

function ModelController:RemovePad()
	Debris:AddItem(self.pad, 1)
	self.pad:Destroy()
	self.pad = nil
	return
end

function ModelController:UpdateVisibility()
	local pass = self.viewModel:WaitForChild("Pass").Value
	local model = self.viewModel:FindFirstChildClassOf("Model")
	for _, part in model:GetDescendants() do
		if part:IsA("BasePart") or part:IsA("MeshPart") then
			part.Transparency = ( pass and 0 ) or 1
		end
	end
end

function ModelController:Remove()
	for _, connection:RBXScriptConnection in pairs(self.connections) do
		connection:Disconnect()
	end
	self.connections = {}
	self.padPart:Destroy()
	Debris:AddItem( self.padPart, 1 )
	self.enabled = false
	self:Destroy()
end

return ModelController
