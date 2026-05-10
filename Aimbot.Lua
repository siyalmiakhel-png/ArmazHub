local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIGURATION
local MAX_DISTANCE = 100
local SMOOTHNESS = 0.15 
local JITTER_STRENGTH = 0.05 

local function getClosestPlayerHead()
    local closestHead = nil
    local shortestDistance = MAX_DISTANCE
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if head and humanoid and humanoid.Health > 0 then
                -- Get distance from your character to the target
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local distance = (character.HumanoidRootPart.Position - head.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestHead = head
                    end
                end
            end
        end
    end
    return closestHead
end

-- This runs every frame automatically
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character then
        local targetHead = getClosestPlayerHead()
        
        if targetHead then
            -- 1. CALCULATE DIRECTION WITH JITTER
            local jitter = Vector3.new(
                math.random(-100, 100) / 1000 * JITTER_STRENGTH,
                math.random(-100, 100) / 1000 * JITTER_STRENGTH,
                math.random(-100, 100) / 1000 * JITTER_STRENGTH
            )
            
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position + jitter)

            -- 2. SMOOTH ROTATION (LERP)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, SMOOTHNESS)
        end
    end
end)
