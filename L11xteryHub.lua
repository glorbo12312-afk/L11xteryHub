local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Library:CreateWindow({
    Name = "PidorHub",
    Icon = 0,
    LoadingTitle = "PidorHub",
    LoadingSubtitle = "by Yrdhhdbxxnvdb",
    Theme = "Dark",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PidorHub",
        FileName = "PidorHub"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = true,
    KeySettings = {
        Title = "PidorHub Access",
        Subtitle = "Enter Key to Continue",
        Note = "Key: Pidoras",
        FileName = "PidorHubKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {
            "Pidoras"
        }
    }
})

local CombatTab = Window:CreateTab("Combat", 123456789)
local MovementTab = Window:CreateTab("Movement", 987654321)
local VisualTab = Window:CreateTab("Visuals", 567891234)
local UtilityTab = Window:CreateTab("Utility", 345678912)

local function GetNearestPlayer()
    if not LocalPlayer.Character then return nil end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local nearest = nil
    local distance = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHrp = player.Character.HumanoidRootPart
            local mag = (hrp.Position - targetHrp.Position).Magnitude
            if mag < distance then
                distance = mag
                nearest = player
            end
        end
    end
    return nearest
end

CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        _G.Aimbot = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {0, 360},
    Increment = 1,
    CurrentValue = 90,
    Flag = "AimbotFOV",
    Callback = function(Value)
        _G.AimbotFOV = Value
    end,
})

CombatTab:CreateButton({
    Name = "Kill All Players",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hum = player.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    hum.Health = 0
                end
            end
        end
    end,
})

MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        _G.Fly = Value
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.PlatformStand = Value
            end
        end
    end,
})

MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        _G.Noclip = Value
    end,
})

MovementTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        _G.WalkSpeed = Value
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = Value
            end
        end
    end,
})

MovementTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 250},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        _G.JumpPower = Value
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.JumpPower = Value
            end
        end
    end,
})

VisualTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        _G.ESP = Value
    end,
})

VisualTab:CreateColorPicker({
    Name = "ESP Color",
    CurrentValue = Color3.fromRGB(255, 255, 255),
    Flag = "ESPColor",
    Callback = function(Value)
        _G.ESPColor = Value
    end,
})

VisualTab:CreateToggle({
    Name = "Chams",
    CurrentValue = false,
    Flag = "Chams",
    Callback = function(Value)
        _G.Chams = Value
    end,
})

UtilityTab:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(0, 10, 0)
            end
        end
    end,
})

UtilityTab:CreateButton({
    Name = "Heal",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.Health = hum.MaxHealth
            end
        end
    end,
})

UtilityTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end,
})

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    if _G.Fly then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
            local moveDirection = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + hrp.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - hrp.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - hrp.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + hrp.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hrp.Velocity = Vector3.new(0, 50, 0)
            end
            hrp.Velocity = moveDirection * 50
        end
    end

    if _G.Noclip then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    if _G.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetChar = player.Character
                local hrp = targetChar:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local billboard = targetChar:FindFirstChild("ESP")
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESP"
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = targetChar

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = player.Name
                        label.TextColor3 = _G.ESPColor or Color3.fromRGB(255, 255, 255)
                        label.TextScaled = true
                        label.Parent = billboard
                    end
                end
            end
        end
    end
    
    if _G.Chams then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetChar = player.Character
                for _, part in ipairs(targetChar:GetChildren()) do
                    if part:IsA("BasePart") and not part:FindFirstChild("Chams") then
                        local cham = Instance.new("BoxHandleAdornment")
                        cham.Name = "Chams"
                        cham.Size = part.Size
                        cham.CFrame = part.CFrame
                        cham.Color3 = _G.ESPColor or Color3.fromRGB(255, 255, 255)
                        cham.Transparency = 0.5
                        cham.AlwaysOnTop = true
                        cham.Parent = part
                    end
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if _G.Aimbot then
        local target = GetNearestPlayer()
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local cam = workspace.CurrentCamera
                if cam then
                    pcall(function()
                        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, hrp.Position)
                    end)
                end
            end
        end
    end
end)

print("PidorHub Loaded Successfully!")
