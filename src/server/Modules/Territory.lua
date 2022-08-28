-- // services

local RunService = game:GetService("RunService")

-- // imports

local obtain = _G.obtain

local TerritoryUtil = obtain("TerritoryUtil")
local Util = obtain("Util")

-- // constants

local TERRITORY_CONTAINER = workspace.Territory
local CHECK_DELAY = 1/10

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

local function TerritoryCheck()
    for Part, TerritoryInfo in pairs(TerritoryUtil.territories) do
        local Players: {[number]: Player} = TerritoryUtil.getPlayersinTerritory(Part)
        local HoldingTeam: Team? = Util.GetMajorityTeam(Players)

        if not HoldingTeam then
            continue
        end

        Part.BrickColor = HoldingTeam.TeamColor
    end
end

local function init()
    for _, TerritoryPart in pairs(TERRITORY_CONTAINER:GetChildren()) do
        print("Adding part " .. tostring(TerritoryPart.Position))
        TerritoryUtil.addTerritorySection(TerritoryPart)
    end

    Util.SignalCooldown(RunService.Stepped, TerritoryCheck, CHECK_DELAY)
end

return {init = init}