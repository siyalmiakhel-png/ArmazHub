local Players = game:GetService("Players")

-- SETTINGS
local WALK_SPEED = 24

local function addHighlight(character)
	if not character then return end

	-- avoid duplicates
	if character:FindFirstChild("GlobalHighlight") then return end

	local highlight = Instance.new("Highlight")
	highlight.Name = "GlobalHighlight"
	highlight.FillColor = Color3.fromRGB(255, 0, 0)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 0.5
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = character
end

local function setupCharacter(player, character)
	local humanoid = character:WaitForChild("Humanoid")

	-- speed boost
	humanoid.WalkSpeed = WALK_SPEED

	-- add ESP for everyone
	addHighlight(character)
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		setupCharacter(player, character)
	end)

	-- if already spawned
	if player.Character then
		setupCharacter(player, player.Character)
	end
end)

-- also handle existing players
for _, player in ipairs(Players:GetPlayers()) do
	if player.Character then
		setupCharacter(player, player.Character)
	end
	player.CharacterAdded:Connect(function(char)
		setupCharacter(player, char)
	end)
end
