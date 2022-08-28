local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClientModules = ReplicatedStorage:WaitForChild("Client")
local Modules = ReplicatedStorage:WaitForChild("Common")

_G.obtain = function(module)
    local Data = ClientModules:FindFirstChild(module, true) or Modules:FindFirstChild(module, true)

    if not Data or not Data:IsA("ModuleScript") then
        error("[Obtain] Module " .. module .. " not found")
    end

    return require(Data)
end

for _, Module in ipairs(ClientModules:GetChildren()) do
    if not Module:IsA("ModuleScript") then
        continue
    end

    local ModuleData = require(Module)

    if type(ModuleData) == "table" and ModuleData.init then
        ModuleData.init()
    end
end