local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIGURATION
local LOCK_ON_KEY = Enum.KeyCode.Q
local MAX_DISTANCE = 100
local SMOOTHNESS = 0.15 -- Lower = smoother/slower (less suspicious), Higher = snappier
local JITTER_STRENGTH = 0.05 -- How much the mouse shakes/jitters
local isLocked = false

local function getClosestPlayerHead()
    local closestHead = nil
    local shortestDistance = MAX_DISTANCE
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if head and humanoid and humanoid.Health > 0 then
                local distance = (LocalPlayer.Character:GetPivot().Position - head.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestHead = head
                end
            end
        end
    end
    return closestHead
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == LOCK_ON_KEY then
        isLocked = not isLocked
    end
end)

RunService.RenderStepped:Connect(function()
    if isLocked and LocalPlayer.Character then
        local targetHead = getClosestPlayerHead()
        if targetHead then
            -- 1. CALCULATE DIRECTION
            -- We add a tiny bit of random math to the target position to create "jitter"
            local jitter = Vector3.new(
                math.random(-100, 100) / 1000 * JITTER_STRENGTH,
                math.random(-100, 100) / 1000 * JITTER_STRENGTH,
                math.random(-100, 100) / 1000 * JITTER_STRENGTH
            )
            
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position + jitter)

            -- 2. SMOOTH ROTATION (LERP)
            -- Instead of snapping, we move a percentage of the way there (SMOOTHNESS)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, SMOOTHNESS)
        end
    end
end)
