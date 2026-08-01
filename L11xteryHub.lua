-- ============================================================
-- L11xteryHub ULTIMATE V7.0
-- ЦЕНА: 9000₽ (ПРЕМИУМ ВЕРСИЯ)
-- Разработчик: L11xteryTeam
-- Telegram: https://t.me/L11xteryTeam
-- ============================================================

-- === ЗАЩИТА ОТ ОШИБОК ===
local function safeCall(func)
    local success, result = pcall(func)
    if not success then
        warn("[L11xteryHub] Ошибка: " .. tostring(result))
        return nil
    end
    return result
end

-- === СЕРВИСЫ ===
local Players = safeCall(function() return game:GetService("Players") end) or game:GetService("Players")
local RunService = safeCall(function() return game:GetService("RunService") end) or game:GetService("RunService")
local UserInputService = safeCall(function() return game:GetService("UserInputService") end) or game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    error("LocalPlayer не найден!")
end

-- === ОЖИДАНИЕ ПЕРСОНАЖА ===
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- === ГЛОБАЛЬНЫЕ НАСТРОЙКИ ===
_G.L11xtery = {
    Fly = false,
    Noclip = false,
    ESP = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    WalkSpeed = 16,
    JumpPower = 50,
    Aimbot = false,
    AimbotFOV = 90,
    Price = "9000₽" -- ЦЕННИК
}

-- === ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ===
local function getHumanoid(player)
    if not player or not player.Character then return nil end
    return player.Character:FindFirstChild("Humanoid")
end

local function getHRP(player)
    if not player or not player.Character then return nil end
    return player.Character:FindFirstChild("HumanoidRootPart")
end

local function getNearest()
    local hrp = getHRP(LocalPlayer)
    if not hrp then return nil end
    
    local nearest, minDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local targetHrp = getHRP(player)
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

-- === КОМАНДЫ ЧЕРЕЗ КОНСОЛЬ ===
print("========================================")
print("L11xteryHub V7.0 ПРЕМИУМ")
print("ЦЕНА: 9000₽")
print("Telegram: https://t.me/L11xteryTeam")
print("========================================")
print("Управление:")
print("  [F] - Вкл/Выкл полет")
print("  [G] - Вкл/Выкл ноклип")
print("  [E] - Вкл/Выкл ESP")
print("  [P] - Убить всех игроков")
print("  [H] - Вылечиться")
print("  [J] - Телепорт на спавн")
print("  [K] - Показать информацию о цене")
print("========================================")

-- === НАСТРОЙКА КЛАВИШ ===
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode
    
    -- F - Полет
    if key == Enum.KeyCode.F then
        _G.L11xtery.Fly = not _G.L11xtery.Fly
        local hum = getHumanoid(LocalPlayer)
        if hum then
            hum.PlatformStand = _G.L11xtery.Fly
        end
        print("[L11xteryHub] Fly: " .. tostring(_G.L11xtery.Fly))
    end
    
    -- G - Ноклип
    if key == Enum.KeyCode.G then
        _G.L11xtery.Noclip = not _G.L11xtery.Noclip
        print("[L11xteryHub] Noclip: " .. tostring(_G.L11xtery.Noclip))
    end
    
    -- E - ESP
    if key == Enum.KeyCode.E then
        _G.L11xtery.ESP = not _G.L11xtery.ESP
        if not _G.L11xtery.ESP then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local esp = player.Character:FindFirstChild("ESP")
                    if esp then esp:Destroy() end
                end
            end
        end
        print("[L11xteryHub] ESP: " .. tostring(_G.L11xtery.ESP))
    end
    
    -- P - Kill All
    if key == Enum.KeyCode.P then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local hum = getHumanoid(player)
                if hum and hum.Health > 0 then
                    hum.Health = 0
                end
            end
        end
        print("[L11xteryHub] Все игроки убиты")
    end
    
    -- H - Heal
    if key == Enum.KeyCode.H then
        local hum = getHumanoid(LocalPlayer)
        if hum then
            hum.Health = hum.MaxHealth
            print("[L11xteryHub] Вылечен")
        end
    end
    
    -- J - Teleport to Spawn
    if key == Enum.KeyCode.J then
        local hrp = getHRP(LocalPlayer)
        if hrp then
            hrp.CFrame = CFrame.new(0, 10, 0)
            print("[L11xteryHub] Телепорт на спавн")
        end
    end
    
    -- K - Информация о цене
    if key == Enum.KeyCode.K then
        print("========================================")
        print("L11xteryHub V7.0 ПРЕМИУМ")
        print("ЦЕНА: 9000₽")
        print("Telegram: https://t.me/L11xteryTeam")
        print("========================================")
        print("Функции:")
        print("  - Полет (F)")
        print("  - Ноклип (G)")
        print("  - ESP (E)")
        print("  - Убить всех (P)")
        print("  - Лечение (H)")
        print("  - Телепорт на спавн (J)")
        print("  - Аимбот (вкл/выкл через консоль)")
        print("========================================")
    end
end)

-- === ОСНОВНОЙ ЦИКЛ ===
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = getHRP(LocalPlayer)
    if not hrp then return end
    
    -- Скорость и прыжок
    local hum = getHumanoid(LocalPlayer)
    if hum then
        hum.WalkSpeed = _G.L11xtery.WalkSpeed
        hum.JumpPower = _G.L11xtery.JumpPower
    end
    
    -- Полет
    if _G.L11xtery.Fly then
        hrp.Velocity = Vector3.new(0, 0, 0)
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
    
    -- Ноклип
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
                local targetChar = player.Character
                if targetChar then
                    local targetHrp = getHRP(player)
                    if targetHrp then
                        local esp = targetChar:FindFirstChild("ESP")
                        if not esp then
                            local success = pcall(function()
                                esp = Instance.new("BillboardGui")
                                esp.Name = "ESP"
                                esp.Size = UDim2.new(0, 200, 0, 50)
                                esp.AlwaysOnTop = true
                                esp.Parent = targetChar
                                
                                local label = Instance.new("TextLabel")
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.Text = player.Name .. " | 9000₽"
                                label.TextColor3 = _G.L11xtery.ESPColor
                                label.TextScaled = true
                                label.Parent = esp
                            end)
                            if not success then
                                print("[L11xteryHub] Ошибка создания ESP для " .. player.Name)
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Аимбот
    if _G.L11xtery.Aimbot then
        local target = getNearest()
        if target then
            local targetHrp = getHRP(target)
            if targetHrp then
                local cam = workspace.CurrentCamera
                if cam then
                    pcall(function()
                        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetHrp.Position)
                    end)
                end
            end
        end
    end
end)

-- === СОЗДАНИЕ ПРОСТОГО GUI С ЦЕНОЙ ===
local function createPriceGUI()
    local success, result = pcall(function()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "L11xteryPrice"
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        screenGui.ResetOnSpawn = false
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 300, 0, 100)
        frame.Position = UDim2.new(0.5, -150, 0, 10)
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BackgroundTransparency = 0.7
        frame.BorderSizePixel = 2
        frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
        frame.Parent = screenGui
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0.5, 0)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "L11xteryHub PREMIUM"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 18
        title.Font = Enum.Font.GothamBold
        title.Parent = frame
        
        local price = Instance.new("TextLabel")
        price.Size = UDim2.new(1, 0, 0.5, 0)
        price.Position = UDim2.new(0, 0, 0.5, 0)
        price.BackgroundTransparency = 1
        price.Text = "ЦЕНА: 9000₽"
        price.TextColor3 = Color3.fromRGB(255, 0, 0)
        price.TextSize = 22
        price.Font = Enum.Font.GothamBold
        price.Parent = frame
        
        return screenGui
    end)
    
    if not success then
        print("[L11xteryHub] GUI с ценой не создан (ошибка: " .. tostring(result) .. ")")
    end
end

-- === ЗАПУСК GUI С ЦЕНОЙ ===
createPriceGUI()

-- === ФИНАЛЬНОЕ СООБЩЕНИЕ ===
print("L11xteryHub V7.0 ПРЕМИУМ загружен!")
print("Цена: 9000₽")
print("Telegram: https://t.me/L11xteryTeam")
