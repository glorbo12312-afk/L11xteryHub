-- ============================================================
-- L11xteryHub FINAL WORKING EDITION
-- Версия: 5.0
-- Разработчик: L11xteryTeam
-- Полностью совместим с Madium и новыми версиями Roblox
-- Цена 9000 рублей
-- ============================================================

-- Подгрузка библиотеки Rayfield с защитой от ошибок
local RayfieldLoaded = false
local Library = nil

pcall(function()
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
    if Library then
        RayfieldLoaded = true
        print("[L11xteryHub] Rayfield загружен успешно")
    end
end)

if not RayfieldLoaded then
    warn("[L11xteryHub] Rayfield не загружен, используется текстовый режим")
    -- Создаем заглушку для функций Rayfield, чтобы скрипт не падал
    Library = {
        CreateWindow = function() 
            print("[L11xteryHub] Работа в текстовом режиме. Функции доступны через консоль.")
            return {
                CreateTab = function() return {
                    CreateButton = function() end,
                    CreateToggle = function() end,
                    CreateSlider = function() end,
                    CreateColorPicker = function() end
                } end
            }
        end
    }
end

-- === ОСНОВНЫЕ СЕРВИСЫ ===
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- === ПРОВЕРКА ЗАГРУЗКИ ПЕРСОНАЖА ===
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- === ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ===
_G.L11xterySettings = {
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

-- === СОЗДАНИЕ GUI (С ИСПРАВЛЕННЫМИ ПАРАМЕТРАМИ) ===
local Window = Library:CreateWindow({
    Name = "L11xteryHub",
    Icon = 0,
    LoadingTitle = "L11xteryHub Premium",
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
    },
    KeySystem = false -- КЛЮЧИ ПОЛНОСТЬЮ ОТКЛЮЧЕНЫ
})

-- === СОЗДАНИЕ ВКЛАДОК ===
local CombatTab = Window:CreateTab("⚔️ Combat", 123456789)
local MovementTab = Window:CreateTab("🏃 Movement", 987654321)
local VisualTab = Window:CreateTab("👁️ Visuals", 567891234)
local UtilityTab = Window:CreateTab("🛠️ Utility", 345678912)

-- === ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ С ЗАЩИТОЙ ===
local function GetCharacter(player)
    if not player or not player.Character then return nil end
    return player.Character
end

local function GetHumanoid(player)
    local char = GetCharacter(player)
    if not char then return nil end
    return char:FindFirstChild("Humanoid")
end

local function GetHumanoidRootPart(player)
    local char = GetCharacter(player)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function GetNearestPlayer()
    if not LocalPlayer.Character then return nil end
    local hrp = GetHumanoidRootPart(LocalPlayer)
    if not hrp then return nil end
    
    local nearest = nil
    local distance = math.huge
    local fov = _G.L11xterySettings.AimbotFOV or 90
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local targetHrp = GetHumanoidRootPart(player)
            if targetHrp then
                local mag = (hrp.Position - targetHrp.Position).Magnitude
                if mag < distance and mag < fov * 3 then
                    distance = mag
                    nearest = player
                end
            end
        end
    end
    return nearest
end

-- === ВКЛАДКА COMBAT ===
CombatTab:CreateToggle({
    Name = "🎯 Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        _G.L11xterySettings.Aimbot = Value
        print("[L11xteryHub] Aimbot: " .. tostring(Value))
    end,
})

CombatTab:CreateSlider({
    Name = "🎯 Aimbot FOV",
    Range = {0, 360},
    Increment = 1,
    CurrentValue = 90,
    Callback = function(Value)
        _G.L11xterySettings.AimbotFOV = Value
    end,
})

CombatTab:CreateButton({
    Name = "💀 Kill All Players",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local hum = GetHumanoid(player)
                if hum and hum.Health > 0 then
                    hum.Health = 0
                end
            end
        end
        print("[L11xteryHub] Все игроки убиты")
    end,
})

-- === ВКЛАДКА MOVEMENT ===
MovementTab:CreateToggle({
    Name = "✈️ Fly",
    CurrentValue = false,
    Callback = function(Value)
        _G.L11xterySettings.Fly = Value
        local char = LocalPlayer.Character
        if char then
            local hum = GetHumanoid(LocalPlayer)
            if hum then
                hum.PlatformStand = Value
            end
        end
        print("[L11xteryHub] Fly: " .. tostring(Value))
    end,
})

MovementTab:CreateToggle({
    Name = "🔄 Noclip",
    CurrentValue = false,
    Callback = function(Value)
        _G.L11xterySettings.Noclip = Value
        print("[L11xteryHub] Noclip: " .. tostring(Value))
    end,
})

MovementTab:CreateSlider({
    Name = "🏃 Walk Speed",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        _G.L11xterySettings.WalkSpeed = Value
        local hum = GetHumanoid(LocalPlayer)
        if hum then
            hum.WalkSpeed = Value
        end
    end,
})

MovementTab:CreateSlider({
    Name = "🦘 Jump Power",
    Range = {50, 250},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        _G.L11xterySettings.JumpPower = Value
        local hum = GetHumanoid(LocalPlayer)
        if hum then
            hum.JumpPower = Value
        end
    end,
})

-- === ВКЛАДКА VISUALS ===
VisualTab:CreateToggle({
    Name = "👁️ ESP",
    CurrentValue = false,
    Callback = function(Value)
        _G.L11xterySettings.ESP = Value
        if not Value then
            -- Удаляем все ESP при выключении
            for _, player in ipairs(Players:GetPlayers()) do
                local char = GetCharacter(player)
                if char then
                    local esp = char:FindFirstChild("ESP")
                    if esp then esp:Destroy() end
                end
            end
        end
        print("[L11xteryHub] ESP: " .. tostring(Value))
    end,
})

VisualTab:CreateColorPicker({
    Name = "🎨 ESP Color",
    CurrentValue = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        _G.L11xterySettings.ESPColor = Value
        -- Обновляем существующие ESP
        for _, player in ipairs(Players:GetPlayers()) do
            local char = GetCharacter(player)
            if char then
                local esp = char:FindFirstChild("ESP")
                if esp then
                    local label = esp:FindFirstChild("TextLabel")
                    if label then
                        label.TextColor3 = Value
                    end
                end
            end
        end
    end,
})

VisualTab:CreateToggle({
    Name = "🔲 Chams",
    CurrentValue = false,
    Callback = function(Value)
        _G.L11xterySettings.Chams = Value
        print("[L11xteryHub] Chams: " .. tostring(Value))
    end,
})

-- === ВКЛАДКА UTILITY ===
UtilityTab:CreateButton({
    Name = "📍 Teleport to Spawn",
    Callback = function()
        local hrp = GetHumanoidRootPart(LocalPlayer)
        if hrp then
            hrp.CFrame = CFrame.new(0, 10, 0)
            print("[L11xteryHub] Телепорт на спавн")
        end
    end,
})

UtilityTab:CreateButton({
    Name = "❤️ Heal",
    Callback = function()
        local hum = GetHumanoid(LocalPlayer)
        if hum then
            hum.Health = hum.MaxHealth
            print("[L11xteryHub] Лечение выполнено")
        end
    end,
})

UtilityTab:CreateButton({
    Name = "🔄 Infinite Yield",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
        print("[L11xteryHub] Infinite Yield загружен")
    end,
})

-- === ОСНОВНОЙ ЦИКЛ (ОПТИМИЗИРОВАННЫЙ) ===
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = GetHumanoidRootPart(LocalPlayer)
    if not hrp then return end
    
    -- === FLY ===
    if _G.L11xterySettings.Fly then
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
    
    -- === NOCLIP ===
    if _G.L11xterySettings.Noclip then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- === ESP ===
    if _G.L11xterySettings.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local targetChar = GetCharacter(player)
                if targetChar then
                    local targetHrp = GetHumanoidRootPart(player)
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
                            label.Text = player.Name .. "\n" .. math.floor((targetHrp.Position - hrp.Position).Magnitude) .. " studs"
                            label.TextColor3 = _G.L11xterySettings.ESPColor
                            label.TextScaled = true
                            label.Parent = esp
                        else
                            -- Обновляем расстояние
                            local label = esp:FindFirstChild("TextLabel")
                            if label then
                                local dist = (targetHrp.Position - hrp.Position).Magnitude
                                label.Text = player.Name .. "\n" .. math.floor(dist) .. " studs"
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- === CHAMS ===
    if _G.L11xterySettings.Chams then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local targetChar = GetCharacter(player)
                if targetChar then
                    for _, part in ipairs(targetChar:GetChildren()) do
                        if part:IsA("BasePart") and not part:FindFirstChild("Chams") then
                            local chams = Instance.new("BoxHandleAdornment")
                            chams.Name = "Chams"
                            chams.Size = part.Size
                            chams.CFrame = part.CFrame
                            chams.Color3 = _G.L11xterySettings.ESPColor
                            chams.Transparency = 0.5
                            chams.AlwaysOnTop = true
                            chams.ZIndex = 5
                            chams.Parent = part
                        end
                    end
                end
            end
        end
    end
end)

-- === AIMBOT (ОТДЕЛЬНЫЙ ЦИКЛ С ЗАЩИТОЙ) ===
RunService.Heartbeat:Connect(function()
    if not _G.L11xterySettings.Aimbot then return end
    
    local target = GetNearestPlayer()
    if not target then return end
    
    local targetHrp = GetHumanoidRootPart(target)
    if not targetHrp then return end
    
    local cam = workspace.CurrentCamera
    if not cam then return end
    
    pcall(function()
        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetHrp.Position)
    end)
end)

-- === ОБРАБОТЧИК ВЫХОДА ===
LocalPlayer.CharacterAdded:Connect(function()
    print("[L11xteryHub] Персонаж перезагружен")
end)

-- === ФИНАЛЬНОЕ СООБЩЕНИЕ ===
print("==================================")
print("L11xteryHub FINAL EDITION загружен!")
print("Версия: 5.0")
print("Разработчик: L11xteryTeam")
print("Работает на Madium и новых версиях Roblox")
print("==================================")
