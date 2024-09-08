local CollectionService = game:GetService("CollectionService")
local ReplicateStorage = game:GetService("ReplicatedStorage")
local Scripts = ReplicateStorage:WaitForChild("Script")
local ModelController = require( Scripts:WaitForChild("ModelController") )
local LampController = require( Scripts:WaitForChild("LampController") )
local controllers = {}
local lampControllers = {}

local TYCOON_TAG = "Tycoon"
local VIEW_TAG= "View"
local TRANSPARENT_TAG = "Transparent"
local GENIE_TAG = "Genie"
local WAIT_GENIE_TAG = "WaitForGenie"


local function TycoonAdded( model : Instance )
	local object = model
	controllers[object] = ModelController.new(object)
end

local function ViewAdded( model : Instance )
	local object = model	
	local modelController = controllers[object]
	modelController:RemovePad()
	modelController:PlaceModel()
end

local function TransparentAdded( model : Instance )
	local object = model
	local modelController = controllers[object]
	modelController:PlacePad()
	modelController:RemoveModel()
end

local function TransparentRemoved( model : Instance )
	local object = model
	local modelController = controllers[object]
	modelController:PlaceNextPads()
end

local function WaitForGenieTagAdded( model : Instance )
	local object = model
	lampControllers[object] = LampController.new(object)
	local lampController = lampControllers[object]

	while wait(10) do
		if lampController then
			lampController:Activate()
			break
		end
	end
end


CollectionService:GetInstanceAddedSignal("Tycoon"):Connect(TycoonAdded)
CollectionService:GetInstanceAddedSignal("View"):Connect(ViewAdded)
CollectionService:GetInstanceAddedSignal("Transparent"):Connect(TransparentAdded)

CollectionService:GetInstanceRemovedSignal("Transparent"):Connect(TransparentRemoved)

return controllers
