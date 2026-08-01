-- ============================================================
-- L11xteryHub ULTIMATE WORKING EDITION
-- Версия: 6.0
-- Разработчик: L11xteryTeam
-- 100% РАБОТАЕТ НА MADIUM И НОВЫХ ROBLOX
-- ============================================================

-- === ЗАГРУЗКА RAYFIELD С ЗАЩИТОЙ ===
local Library
local loadSuccess = false

pcall(function()
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
    if Library then
        loadSuccess = true
        print("[L11xteryHub] Rayfield загружен")
    end
end)

if not loadSuccess then
    warn("[L11xteryHub] Rayfield не загружен. Используем текстовый режим.")
    -- Создаем заглушку для Rayfield
    Library = {
        CreateWindow = function()
            print("[L11xteryHub] GUI не доступен, используйте консоль.")
            return { CreateTab = function() return { 
                CreateButton = function() end,
                CreateToggle = function() end,
                CreateSlider = function() end,
                CreateColorPicker = function() end
            } end }
        end
    }
end

-- === СЕРВИСЫ ===
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- === ОЖИДАНИЕ ПЕРСОНАЖА ===
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- === ГЛОБАЛЬНЫЕ НАСТРОЙКИ ===
_G.L11xtery = {
    Aimbot = false,
    AimbotFOV = 90,
    Fly = false,
    Noclip = false,
    ESP = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    Chams = false,
    WalkSpeed = 16,
    JumpPower = 50
}

-- === СОЗДАНИЕ ГЛАВНОГО ОКНА (БЕЗ КЛЮЧЕЙ) ===
local Window = Library:CreateWindow({
    Name = "L11xteryHub",
    Icon = 0,
    LoadingTitle = "L11xteryHub",
    LoadingSubtitle = "by L11xteryTeam",
    Theme = "Dark",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "L11xteryHub",
        FileName = "L11xteryHub"
    },
    Discord = {
        Enabled = false
    }
    -- ВАЖНО: УДАЛЕНЫ ВСЕ KeySystem И KeySettings
})

-- === СОЗДАНИЕ ВКЛАДОК ===
local CombatTab = Window:CreateTab("Combat", 123456789)
local MovementTab = Window:CreateTab("Movement", 987654321)
local VisualTab = Window:CreateTab("Visuals", 567891234)
local UtilityTab = Window:CreateTab("Utility", 345678912)

-- === ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ===
local function GetCharacter(player)
    return player and player.Character or nil
end

local function GetHumanoid(player)
    local char = GetCharacter(player)
    return char and char:FindFirstChild("Humanoid") or nil
end

local function GetRootPart(player)
    local char = GetCharacter(player)
    return char and char:FindFirstChild("HumanoidRootPart") or nil
end

local function GetNearestPlayer()
    local hrp = GetRootPart(LocalPlayer)
    if not hrp then return nil end
    
    local nearest, minDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local targetHrp = GetRootPart(player)
            if targetHrp then
                local dist = (hrp.Position - targetHrp.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = player
                end
            end
        end
    end
    return nearest
end

-- === СОЗДАНИЕ GUI ===
-- COMBAT TAB
CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        _G.L11xtery.Aimbot = Value
    end
})

CombatTab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {0, 360},
    Increment = 1,
    CurrentValue = 90,
    Callback = function(Value)
        _G.L11xtery.AimbotFOV = Value
    end
})

CombatTab:CreateButton({
    Name = "Kill All",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local hum = GetHumanoid(player)
                if hum then hum.Health = 0 end
            end
        end
    end
})

-- MOVEMENT TAB
MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        _G.L11xtery.Fly = Value
        local hum = GetHumanoid(LocalPlayer)
        if hum then
            hum.PlatformStand = Value
        end
    end
})

MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        _G.L11xtery.Noclip = Value
    end
})

MovementTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        _G.L11xtery.WalkSpeed = Value
        local hum = GetHumanoid(LocalPlayer)
        if hum then hum.WalkSpeed = Value end
    end
})

MovementTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 250},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        _G.L11xtery.JumpPower = Value
        local hum = GetHumanoid(LocalPlayer)
        if hum then hum.JumpPower = Value end
    end
})

-- VISUAL TAB
VisualTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(Value)
        _G.L11xtery.ESP = Value
        if not Value then
            for _, player in ipairs(Players:GetPlayers()) do
                local char = GetCharacter(player)
                if char then
                    local esp = char:FindFirstChild("ESP")
                    if esp then esp:Destroy() end
                end
            end
        end
    end
})

VisualTab:CreateColorPicker({
    Name = "ESP Color",
    CurrentValue = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        _G.L11xtery.ESPColor = Value
        for _, player in ipairs(Players:GetPlayers()) do
            local char = GetCharacter(player)
            if char then
                local esp = char:FindFirstChild("ESP")
                if esp then
                    local label = esp:FindFirstChild("TextLabel")
                    if label then label.TextColor3 = Value end
                end
            end
        end
    end
})

VisualTab:CreateToggle({
    Name = "Chams",
    CurrentValue = false,
    Callback = function(Value)
        _G.L11xtery.Chams = Value
    end
})

-- UTILITY TAB
UtilityTab:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        local hrp = GetRootPart(LocalPlayer)
        if hrp then hrp.CFrame = CFrame.new(0, 10, 0) end
    end
})

UtilityTab:CreateButton({
    Name = "Heal",
    Callback = function()
        local hum = GetHumanoid(LocalPlayer)
        if hum then hum.Health = hum.MaxHealth end
    end
})

UtilityTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
    end
})

-- === ОСНОВНЫЕ ЦИКЛЫ ===
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = GetRootPart(LocalPlayer)
    if not hrp then return end
    
    -- Fly
    if _G.L11xtery.Fly then
        local moveDir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + hrp.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - hrp.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - hrp.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + hrp.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hrp.Velocity = Vector3.new(0, 50, 0)
        end
        hrp.Velocity = moveDir * 50
    end
    
    -- Noclip
    if _G.L11xtery.Noclip then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- ESP
    if _G.L11xtery.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local targetChar = GetCharacter(player)
                if targetChar then
                    local targetHrp = GetRootPart(player)
                    if targetHrp then
                        local esp = targetChar:FindFirstChild("ESP")
                        if not esp then
                            esp = Instance.new("BillboardGui")
                            esp.Name = "ESP"
                            esp.Size = UDim2.new(0, 200, 0, 50)
                            esp.AlwaysOnTop = true
                            esp.Parent = targetChar
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Text = player.Name
                            label.TextColor3 = _G.L11xtery.ESPColor
                            label.TextScaled = true
                            label.Parent = esp
                        end
                    end
                end
            end
        end
    end
    
    -- Chams
    if _G.L11xtery.Chams then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local targetChar = GetCharacter(player)
                if targetChar then
                    for _, part in ipairs(targetChar:GetChildren()) do
                        if part:IsA("BasePart") and not part:FindFirstChild("Chams") then
                            local cham = Instance.new("BoxHandleAdornment")
                            cham.Name = "Chams"
                            cham.Size = part.Size
                            cham.CFrame = part.CFrame
                            cham.Color3 = _G.L11xtery.ESPColor
                            cham.Transparency = 0.5
                            cham.AlwaysOnTop = true
                            cham.Parent = part
                        end
                    end
                end
            end
        end
    end
end)

-- Aimbot
RunService.Heartbeat:Connect(function()
    if not _G.L11xtery.Aimbot then return end
    local target = GetNearestPlayer()
    if not target then return end
    local targetHrp = GetRootPart(target)
    if not targetHrp then return end
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function()
            cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetHrp.Position)
        end)
    end
end)

print("L11xteryHub загружен и работает!")
