-- // services

local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

-- // imports

local ServerModules = ServerScriptService:WaitForChild("Modules")

local Types = require(ServerModules.Types)

local obtain = _G.obtain

local TerritoryUtil: Types.TerritoryUtil = obtain("TerritoryUtil")
local Util: Types.Util = obtain("Util")

-- // constants

local DEBUG_TERRITORY_CONTAINER: Folder = workspace.Territory
local DEBUG_SHOW_TERRITORY = true

local CHECK_DELAY = 2
local TERRITORY_GRID

local DEBUG_TEMPLATE_TERRITORY_PART = Instance.new("Part") do
    DEBUG_TEMPLATE_TERRITORY_PART.Anchored = true
    DEBUG_TEMPLATE_TERRITORY_PART.Transparency = 0
    DEBUG_TEMPLATE_TERRITORY_PART.Locked = true
    DEBUG_TEMPLATE_TERRITORY_PART.CanCollide = false
end

--// module body

--[[
    print(tostring(Part.Position))
        local Players: {[number]: Player} = TerritoryUtil.getPlayersinTerritory(Part)
        local HoldingTeam: Team? = Util.GetMajorityTeam(Players)

        if not HoldingTeam then
            Part.BrickColor = BrickColor.new("Medium stone grey")
            return
        end

        Part.BrickColor = HoldingTeam.TeamColor
]]

-- this is kind of messy
local function GenerateTerritoryGrid(Origin: Vector3, BlockSize: Vector2, Size: Vector2)
    -- generate the grid of parts that make up the territory
    -- size*size parts will be generated of width and length BlockSize and centered around Origin
    local Grid: {[number]: {[number]: Types.TerritoryBlockInfo}} = {}
    local From, To = -Size.X/2+0.5, Size.Y/2-0.5
    local X, Y = 0, 0
    for i = From, To do
        X += 1

        Grid[X] = {}
        for j = From, To do
            Y += 1
            if Y > Size.Y then
                Y = 1
            end

            local TerritoryBlock = {}
            TerritoryBlock.Size = Vector3.new(BlockSize.X, 25, BlockSize.Y)
            TerritoryBlock.CFrame = CFrame.new(Origin + Vector3.new(i*BlockSize.X, 0, j*BlockSize.Y))
            

            if DEBUG_SHOW_TERRITORY then
                local NewPart = DEBUG_TEMPLATE_TERRITORY_PART:Clone()
                NewPart.Size = Vector3.new(BlockSize.X, 25, BlockSize.Y)
                NewPart.CFrame = CFrame.new(Origin + Vector3.new(i*BlockSize.X, 0, j*BlockSize.Y))
                NewPart.Parent = DEBUG_TERRITORY_CONTAINER

                TerritoryBlock.DebugPart = NewPart
            end

            Grid[X][Y] = TerritoryBlock
        end
    end

    return Grid
end

local function TerritoryCheck()
    for Position, TerritoryInfo in pairs(TerritoryUtil.territories) do
        local PlayersInTerritory: {[number]: Player} = TerritoryUtil.getPlayersinTerritory(TerritoryInfo)

        for _, Player in pairs(PlayersInTerritory) do
            print(Player.Name .. " is in " .. tostring(Position))
        end

        local HoldingTeam = Util.GetMajorityTeam(PlayersInTerritory)

        if not HoldingTeam then
            continue
        end

        if DEBUG_SHOW_TERRITORY then
            TerritoryInfo.Part.BrickColor = HoldingTeam.TeamColor
        end
    end
end

local function init()
    TERRITORY_GRID = GenerateTerritoryGrid(Vector3.new(0, 0, 0), Vector2.new(300, 300), Vector2.new(100, 100))

    for X, YArray in pairs(TERRITORY_GRID) do
        for Y, Block: Types.TerritoryBlockInfo in pairs(YArray) do
            task.spawn(function()
                -- We need to use Vector3s due to the native Luau type. It allows us to use it as an key in a table and access it
                TERRITORY_GRID[X][Y] = TerritoryUtil.addTerritorySection(Block, Vector3.new(X, Y))
            end)
        end
    end

    Util.SignalCooldown(RunService.Stepped, TerritoryCheck, CHECK_DELAY)
end

return {init = init}