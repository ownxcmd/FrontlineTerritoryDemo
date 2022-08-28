local TerritoryUtil = {}

local Players = game:GetService("Players")

type TerritoryBlockInfo = {
    Set: table, -- do later
    CFrame: CFrame,
    Size: Vector3,
}

local GJK = require(script:WaitForChild("GJK"))
local Vertices = require(script:WaitForChild("Vertices"))

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

TerritoryUtil.territories = {}
-- return the index of the new territory section for use later
function TerritoryUtil.addTerritorySection(Part: BasePart): number
    print("Adding part " .. tostring(Part.Position))
    TerritoryUtil.territories[Part] = {
		Set = Vertices.Block(Part.CFrame, Part.Size/2),
		CFrame = Part.CFrame,
		Size = Part.Size
	}
end

function TerritoryUtil.getPlayersinTerritory(Part: Part): {[number]: Player}
    local territory = TerritoryUtil.territories[Part]
    if not territory then
        error("Part is not a territory")
    end

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

        local gjk = GJK.new(territory.Set, {HumanoidRootPart.Position}, territory.CFrame.Position, HumanoidRootPart.Position, PointCloud, PointCloud)
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
end

return TerritoryUtil