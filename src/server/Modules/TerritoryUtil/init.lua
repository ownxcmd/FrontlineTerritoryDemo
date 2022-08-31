

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local ServerModules = ServerScriptService:WaitForChild("Modules")

local GJK = require(script.GJK)
local Vertices = require(script.Vertices)

local Types = require(ServerModules.Types)

local function PointCloud(set, direction)
	local max, maxDot = set[1], set[1]:Dot(direction)
	for i = 2, #set do
		local dot = set[i]:Dot(direction)
		if (dot > maxDot) then
			max = set[i]
			maxDot = dot
		end
	end
	return max
end

local TerritoryUtil: Types.TerritoryUtil = {}

TerritoryUtil.territories = {}
TerritoryUtil.territoryCoordinates = {}
-- Adds a new territory section to the territory grid. 
function TerritoryUtil.addTerritorySection(TerritoryBlock: Types.TerritoryBlockInfo, Pos: Vector3?): Types.TerritoryBlockInfo
    TerritoryUtil.territories[Pos] = {
		Set = Vertices.Block(TerritoryBlock.CFrame, TerritoryBlock.Size/2),
		CFrame = TerritoryBlock.CFrame,
		Size = TerritoryBlock.Size,
        Part = TerritoryBlock.DebugPart,
	}

    return TerritoryUtil.territories[TerritoryBlock]
end

function TerritoryUtil.getPlayersinTerritory(Block: Types.TerritoryBlockInfo): {[number]: Player}
    local playersInTerritory: {[number]: Player} = {}

    -- get the players in the territory and return them in a table
    for _, Player in ipairs(Players:GetPlayers()) do
        local Character = Player.Character
        if not Character then
            continue
        end

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then
            continue
        end

        local gjk = GJK.new(Block.Set, {HumanoidRootPart.Position}, Block.CFrame.Position, HumanoidRootPart.Position, PointCloud, PointCloud)
        if not gjk:IsColliding() then
            continue
        end

        table.insert(playersInTerritory, Player)
    end

    return playersInTerritory
end

function TerritoryUtil.getPlayerTerritory(Player: Player): Part?
    local Character = Player.Character
    if not Character then
        return nil
    end

    local HumanoidRootPart: Part? = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then
        return nil
    end

    for _, Part in pairs(TerritoryUtil.territories) do
		local gjk = GJK.new(Part.Set, {HumanoidRootPart.Position}, Part.CFrame.Position, HumanoidRootPart.Position, PointCloud, PointCloud)
		if gjk:IsColliding() then
			return Part
		end
	end

    return nil
end

return TerritoryUtil