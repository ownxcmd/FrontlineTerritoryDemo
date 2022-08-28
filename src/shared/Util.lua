-- // services

local RunService = game:GetService("RunService")

-- // module body

local Util = {}

function Util.GetMajorityTeam(PlayerArray: {[number]: Player}): Team
    local TeamCounts: {[Team]: number} = {}
    local Highest: Team?, HighestCount: number = nil, 0

    for _, Player in pairs(PlayerArray) do
        local Team = Player.Team
        local Count = TeamCounts[Team] or 0
        TeamCounts[Team] = Count + 1
        
        if not Highest or Count > HighestCount then
            Highest = Team
            HighestCount = Count
        end
    end

    return Highest
end

function Util.SignalCooldown(Signal: RBXScriptSignal, Callback: (...any) -> nil, Delay: number?): RBXScriptConnection
    if not Delay then
        return Signal:Connect(Callback)
    end

    local Anchor = os.clock()

    return Signal:Connect(function()
        local Current = os.clock()

        if Current - Anchor >= Delay then
            Anchor = Current

            Callback()
        end
    end)
end

return Util