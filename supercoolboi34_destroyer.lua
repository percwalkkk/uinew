-- // some cool script i made as anti aim


getgenv().desyncenabled = true 
local newcframe         = CFrame.new
local localplayer       = game.Players.LocalPlayer
local runservice        = game:GetService("RunService")
local userinputservice  = game:GetService("UserInputService")

local storedcframe

local function desynccframe()
    if localplayer.Character then 
        local humanoidrootpart = localplayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidrootpart then
            local offset = humanoidrootpart.CFrame * newcframe(0, 0/1, math.huge)
            
            if getgenv().desyncenabled then 
                storedcframe = humanoidrootpart.CFrame
                humanoidrootpart.CFrame = offset
                runservice.RenderStepped:Wait()
                humanoidrootpart.CFrame = storedcframe
            end 
        end
    end 
end

runservice.Heartbeat:Connect(function()
    if getgenv().desyncenabled then
        desynccframe()
    end
end)

local function auto()
    while true do
        wait(0.1) 
        getgenv().desyncenabled = not getgenv().desyncenabled
        
        if not getgenv().desyncenabled then 
            if localplayer.Character and storedcframe then
                localplayer.Character.HumanoidRootPart.CFrame = storedcframe
            end
        else 
            storedcframe = nil 
        end 
    end
end

spawn(auto)

local hooker
hooker = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if not checkcaller() then
        if key == "CFrame" and getgenv().desyncenabled and localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart") and localplayer.Character:FindFirstChild("Humanoid") and localplayer.Character.Humanoid.Health > 0 then
            if self == localplayer.Character.HumanoidRootPart and storedcframe ~= nil then
                return storedcframe
            end
        end
    end
    return hooker(self, key)
end))


userinputservice.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then  -- Press 'P' to toggle "desync"
        getgenv().desyncenabled = not getgenv().desyncenabled
        if not getgenv().desyncenabled and localplayer.Character and storedcframe then
            localplayer.Character.HumanoidRootPart.CFrame = storedcframe
        else
            storedcframe = nil
        end
    end
end)
