local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerModules = ServerScriptService.Modules
local Modules = ReplicatedStorage.Common

_G.obtain = function(module)
    local Data = ServerModules:FindFirstChild(module, true) or Modules:FindFirstChild(module, true)

    if not Data or not Data:IsA("ModuleScript") then
        error("[Obtain] Module " .. module .. " not found")
    end

    return require(Data)
end

for _, Module in ipairs(ServerModules:GetChildren()) do
    if not Module:IsA("ModuleScript") then
        continue
    end

    print("[Server] Initializing module " .. Module.Name)

    local ModuleData = require(Module)

    if type(ModuleData) == "table" and ModuleData.init then
        task.spawn(ModuleData.init)
    end
end