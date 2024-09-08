local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Objects = ReplicatedStorage:WaitForChild("Objects")
local touchPadEvent = Remotes:WaitForChild("TouchPad")
local LoadEvent = Remotes:WaitForChild("Load")
local GetPointEvent = Remotes:WaitForChild("GetPoint")

local playerData = LoadEvent:InvokeServer()

local TYCOON_TAG = "Tycoon"
local VIEW_TAG= "View"
local TRANSPARENT_TAG = "Transparent"
local GENIE_TAG = "Genie"
local WAIT_GENIE_TAG = "WaitForGenie"

humanoid.Touched:Connect(
	function(hit)
		if hit.Name == "Pad" then
			local object = hit.Parent
			local id = tonumber(object.Name)
			local visited = playerData.visited
			local points = playerData.points
			print(playerData, visited, points)
			if not visited[id] and points >= object.Cost.Value then
				visited[id] = true
				touchPadEvent:FireServer(id)

				CollectionService:RemoveTag(object, TRANSPARENT_TAG)
				CollectionService:AddTag(object, VIEW_TAG)
			end
		end

		if hit.Name == "LampPad" then
			local object = hit.Parent
			local tags = CollectionService:GetTags(object)
			for _, tag in ipairs(tags) do
				if tag == GENIE_TAG then
					CollectionService:RemoveTag(object, GENIE_TAG)
					CollectionService:AddTag(object, WAIT_GENIE_TAG)
					GetPointEvent:FireServer("Lamp")
				end
			end
		end
	end
)