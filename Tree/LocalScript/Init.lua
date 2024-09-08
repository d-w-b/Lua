local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local CollectionService = game:GetService("CollectionService")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local initEvent = Remotes:WaitForChild("Init")
local Queue = require ( game:GetService("ReplicatedStorage").Script.Queue ) 
local Objects = ReplicatedStorage:WaitForChild("Objects")
local Zone = require(ReplicatedStorage:WaitForChild("Script"):WaitForChild("Zone"))

local TYCOON_TAG = "Tycoon"
local VIEW_TAG= "View"
local TRANSPARENT_TAG = "Transparent"

local function createBoolValue(object : Instance, value : boolean)
	local boolValue = Instance.new("BoolValue")
	boolValue.Value = value
	boolValue.Parent = object
	boolValue.Name = "Pass"
	return
end


local function bfs(
	startNode : number, 
	playerData : table
)
	local q = Queue.new()
	q:Enqueue(startNode)

	while not q:IsEmpty()  do
		local node = q:Dequeue()

		local object = Objects[tostring(node)]:Clone()
		object.Parent = workspace
		CollectionService:AddTag(object, TYCOON_TAG)

		if playerData[node] then
			CollectionService:AddTag(object, VIEW_TAG)
			for _, next in ipairs( object.Next:GetChildren() )  do
				q:Enqueue(tonumber(next.Name))
			end
		else 
			CollectionService:AddTag(object, TRANSPARENT_TAG)
		end
	end
end

--클라이언트가 시작되면 유저 데이터를 불러온 후 방문한 노드를 workspace에 올려줍니다.
initEvent.OnClientEvent:Connect(
	function(...: any) 
		local args = {...}
		local playerData = args[1]
		bfs(1, playerData.visited)
	end
)
