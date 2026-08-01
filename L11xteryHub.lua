-- ============================================================
-- L11xteryHub V7.2
-- Цена: 9000₽
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
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
    AimbotFOV = 90
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

-- === СОЗДАНИЕ GUI ===
local function createGUI()
    local success, result = pcall(function()
        -- Главный экран
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "L11xteryHub"
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        screenGui.ResetOnSpawn = false
        
        -- Основное окно
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 300, 0, 400)
        mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        mainFrame.BorderSizePixel = 2
        mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.Parent = screenGui
        
        -- Заголовок
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 35)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        title.BorderSizePixel = 0
        title.Text = "L11xteryHub | 9000₽"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 18
        title.Font = Enum.Font.GothamBold
        title.Parent = mainFrame
        
        -- Разделитель
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, -20, 0, 2)
        line.Position = UDim2.new(0, 10, 0, 40)
        line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        line.BorderSizePixel = 0
        line.Parent = mainFrame
        
        -- Функция создания кнопок
        local function createButton(text, position, callback, color)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 120, 0, 30)
            btn.Position = position
            btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 13
            btn.Font = Enum.Font.Gotham
            btn.Parent = mainFrame
            
            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            
            return btn
        end
        
        -- Функция создания переключателей
        local function createToggle(text, position, getValue, setValue)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 120, 0, 30)
            frame.Position = position
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            frame.BorderSizePixel = 1
            frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
            frame.Parent = mainFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 70, 1, 0)
            label.Position = UDim2.new(0, 5, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 12
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(0, 30, 0, 22)
            toggle.Position = UDim2.new(1, -35, 0, 4)
            toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            toggle.BorderSizePixel = 1
            toggle.BorderColor3 = Color3.fromRGB(255, 0, 0)
            toggle.Text = "OFF"
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggle.TextSize = 10
            toggle.Font = Enum.Font.Gotham
            toggle.Parent = frame
            
            local function update()
                if getValue() then
                    toggle.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                    toggle.Text = "ON"
                else
                    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    toggle.Text = "OFF"
                end
            end
            update()
            
            toggle.MouseButton1Click:Connect(function()
                setValue(not getValue())
                update()
            end)
            
            return toggle
        end
        
        -- РЯД 1 (строка 55)
        createToggle("Полет", UDim2.new(0, 10, 0, 55),
            function() return _G.L11xtery.Fly end,
            function(v) 
                _G.L11xtery.Fly = v
                local hum = getHumanoid(LocalPlayer)
                if hum then hum.PlatformStand = v end
            end
        )
        
        createToggle("Ноклип", UDim2.new(0, 160, 0, 55),
            function() return _G.L11xtery.Noclip end,
            function(v) _G.L11xtery.Noclip = v end
        )
        
        -- РЯД 2 (строка 95)
        createToggle("ESP", UDim2.new(0, 10, 0, 95),
            function() return _G.L11xtery.ESP end,
            function(v) 
                _G.L11xtery.ESP = v
                if not v then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player.Character then
                            local esp = player.Character:FindFirstChild("ESP")
                            if esp then esp:Destroy() end
                        end
                    end
                end
            end
        )
        
        createToggle("Аимбот", UDim2.new(0, 160, 0, 95),
            function() return _G.L11xtery.Aimbot end,
            function(v) _G.L11xtery.Aimbot = v end
        )
        
        -- КНОПКИ РЯД 3 (строка 135)
        createButton("Убить всех", UDim2.new(0, 10, 0, 135), function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local hum = getHumanoid(player)
                    if hum and hum.Health > 0 then
                        hum.Health = 0
                    end
                end
            end
            print("[L11xteryHub] Все игроки убиты")
        end, Color3.fromRGB(100, 0, 0))
        
        createButton("Вылечиться", UDim2.new(0, 160, 0, 135), function()
            local hum = getHumanoid(LocalPlayer)
            if hum then
                hum.Health = hum.MaxHealth
                print("[L11xteryHub] Вылечен")
            end
        end, Color3.fromRGB(0, 80, 0))
        
        -- КНОПКИ РЯД 4 (строка 175)
        createButton("Телепорт", UDim2.new(0, 10, 0, 175), function()
            local hrp = getHRP(LocalPlayer)
            if hrp then
                hrp.CFrame = CFrame.new(0, 10, 0)
                print("[L11xteryHub] Телепорт на спавн")
            end
        end, Color3.fromRGB(0, 0, 100))
        
        createButton("Infinite Yield", UDim2.new(0, 160, 0, 175), function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            end)
            print("[L11xteryHub] Infinite Yield загружен")
        end, Color3.fromRGB(80, 0, 80))
        
        -- РЕГУЛЯТОРЫ (строка 220)
        local speedLabel = Instance.new("TextLabel")
        speedLabel.Size = UDim2.new(0, 120, 0, 25)
        speedLabel.Position = UDim2.new(0, 10, 0, 220)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Text = "Скорость: " .. _G.L11xtery.WalkSpeed
        speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedLabel.TextSize = 12
        speedLabel.Font = Enum.Font.Gotham
        speedLabel.Parent = mainFrame
        
        createButton("+", UDim2.new(0, 130, 0, 220), function()
            _G.L11xtery.WalkSpeed = math.min(250, _G.L11xtery.WalkSpeed + 5)
            speedLabel.Text = "Скорость: " .. _G.L11xtery.WalkSpeed
            local hum = getHumanoid(LocalPlayer)
            if hum then hum.WalkSpeed = _G.L11xtery.WalkSpeed end
        end, Color3.fromRGB(0, 80, 0)):SetAttribute("Size", UDim2.new(0, 30, 0, 25))
        
        createButton("-", UDim2.new(0, 170, 0, 220), function()
            _G.L11xtery.WalkSpeed = math.max(16, _G.L11xtery.WalkSpeed - 5)
            speedLabel.Text = "Скорость: " .. _G.L11xtery.WalkSpeed
            local hum = getHumanoid(LocalPlayer)
            if hum then hum.WalkSpeed = _G.L11xtery.WalkSpeed end
        end, Color3.fromRGB(100, 0, 0)):SetAttribute("Size", UDim2.new(0, 30, 0, 25))
        
        -- ПРЫЖОК (строка 255)
        local jumpLabel = Instance.new("TextLabel")
        jumpLabel.Size = UDim2.new(0, 120, 0, 25)
        jumpLabel.Position = UDim2.new(0, 10, 0, 255)
        jumpLabel.BackgroundTransparency = 1
        jumpLabel.Text = "Прыжок: " .. _G.L11xtery.JumpPower
        jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        jumpLabel.TextSize = 12
        jumpLabel.Font = Enum.Font.Gotham
        jumpLabel.Parent = mainFrame
        
        createButton("+", UDim2.new(0, 130, 0, 255), function()
            _G.L11xtery.JumpPower = math.min(250, _G.L11xtery.JumpPower + 5)
            jumpLabel.Text = "Прыжок: " .. _G.L11xtery.JumpPower
            local hum = getHumanoid(LocalPlayer)
            if hum then hum.JumpPower = _G.L11xtery.JumpPower end
        end, Color3.fromRGB(0, 80, 0)):SetAttribute("Size", UDim2.new(0, 30, 0, 25))
        
        createButton("-", UDim2.new(0, 170, 0, 255), function()
            _G.L11xtery.JumpPower = math.max(50, _G.L11xtery.JumpPower - 5)
            jumpLabel.Text = "Прыжок: " .. _G.L11xtery.JumpPower
            local hum = getHumanoid(LocalPlayer)
            if hum then hum.JumpPower = _G.L11xtery.JumpPower end
        end, Color3.fromRGB(100, 0, 0)):SetAttribute("Size", UDim2.new(0, 30, 0, 25))
        
        -- ЗАКРЫТИЕ (строка 295)
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 80, 0, 25)
        closeBtn.Position = UDim2.new(1, -90, 1, -35)
        closeBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        closeBtn.BorderSizePixel = 1
        closeBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
        closeBtn.Text = "Закрыть"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextSize = 12
        closeBtn.Font = Enum.Font.Gotham
        closeBtn.Parent = mainFrame
        
        closeBtn.MouseButton1Click:Connect(function()
            screenGui:Destroy()
            print("[L11xteryHub] GUI закрыт")
        end)
        
        print("[L11xteryHub] GUI создан")
        return screenGui
    end)
    
    if not success then
        print("[L11xteryHub] Ошибка GUI: " .. tostring(result))
    end
end

-- === ЗАПУСК GUI ===
createGUI()

-- === ИНФОРМАЦИЯ В КОНСОЛИ ===
print("========================================")
print("L11xteryHub V7.2 загружен!")
print("Цена: 9000₽")
print("Telegram: https://t.me/L11xteryTeam")
print("========================================")

-- === ОСНОВНОЙ ЦИКЛ ===
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = getHRP(LocalPlayer)
    if not hrp then return end
    
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
                            pcall(function()
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

print("L11xteryHub V7.2 работает!")
