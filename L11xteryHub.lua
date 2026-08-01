-- ============================================================
-- L11xteryHub
-- Версия: 5.1
-- Разработчик: L11xteryTeam
-- РАБОТАЕТ НА ЛЮБОМ ИНЖЕКТОРЕ
-- ============================================================

-- === СЕРВИСЫ ===
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

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
    Chams = false,
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

local function getNearestPlayer()
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
    local success, err = pcall(function()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "L11xteryHub"
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        screenGui.ResetOnSpawn = false
        
        -- ОСНОВНОЕ ОКНО
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 320, 0, 420)
        mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        mainFrame.BorderSizePixel = 2
        mainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.Parent = screenGui
        
        -- ЗАГОЛОВОК
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 35)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        title.BorderSizePixel = 0
        title.Text = "L11xteryHub"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 20
        title.Font = Enum.Font.GothamBold
        title.Parent = mainFrame
        
        -- ПОДЗАГОЛОВОК
        local subtitle = Instance.new("TextLabel")
        subtitle.Size = UDim2.new(1, 0, 0, 20)
        subtitle.Position = UDim2.new(0, 0, 0, 35)
        subtitle.BackgroundTransparency = 1
        subtitle.Text = "by L11xteryTeam"
        subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        subtitle.TextSize = 12
        subtitle.Font = Enum.Font.Gotham
        subtitle.Parent = mainFrame
        
        -- РАЗДЕЛИТЕЛЬ
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, -20, 0, 2)
        line.Position = UDim2.new(0, 10, 0, 60)
        line.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        line.BorderSizePixel = 0
        line.Parent = mainFrame
        
        -- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ
        local function createButton(text, pos, callback, color)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 130, 0, 30)
            btn.Position = pos
            btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.fromRGB(255, 50, 50)
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
        
        -- ФУНКЦИЯ СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЯ
        local function createToggle(text, pos, getValue, setValue)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 130, 0, 30)
            frame.Position = pos
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            frame.BorderSizePixel = 1
            frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
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
            toggle.BorderColor3 = Color3.fromRGB(255, 50, 50)
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
        
        -- === ВСЕ ЭЛЕМЕНТЫ GUI ===
        
        -- Ряд 1
        createToggle("Fly", UDim2.new(0, 15, 0, 75),
            function() return _G.L11xtery.Fly end,
            function(v) 
                _G.L11xtery.Fly = v
                local hum = getHumanoid(LocalPlayer)
                if hum then hum.PlatformStand = v end
            end
        )
        
        createToggle("Noclip", UDim2.new(0, 175, 0, 75),
            function() return _G.L11xtery.Noclip end,
            function(v) _G.L11xtery.Noclip = v end
        )
        
        -- Ряд 2
        createToggle("ESP", UDim2.new(0, 15, 0, 115),
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
        
        createToggle("Chams", UDim2.new(0, 175, 0, 115),
            function() return _G.L11xtery.Chams end,
            function(v) _G.L11xtery.Chams = v end
        )
        
        createToggle("Aimbot", UDim2.new(0, 15, 0, 155),
            function() return _G.L11xtery.Aimbot end,
            function(v) _G.L11xtery.Aimbot = v end
        )
        
        -- Кнопки
        createButton("Kill All", UDim2.new(0, 15, 0, 195), function()
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
        
        createButton("Heal", UDim2.new(0, 175, 0, 195), function()
            local hum = getHumanoid(LocalPlayer)
            if hum then
                hum.Health = hum.MaxHealth
                print("[L11xteryHub] Вылечен")
            end
        end, Color3.fromRGB(0, 80, 0))
        
        createButton("Teleport", UDim2.new(0, 15, 0, 235), function()
            local hrp = getHRP(LocalPlayer)
            if hrp then
                hrp.CFrame = CFrame.new(0, 10, 0)
                print("[L11xteryHub] Телепорт на спавн")
            end
        end, Color3.fromRGB(0, 0, 100))
        
        createButton("Infinite Yield", UDim2.new(0, 175, 0, 235), function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            end)
            print("[L11xteryHub] Infinite Yield загружен")
        end, Color3.fromRGB(80, 0, 80))
        
        -- Регуляторы скорости
        local speedLabel = Instance.new("TextLabel")
        speedLabel.Size = UDim2.new(0, 130, 0, 25)
        speedLabel.Position = UDim2.new(0, 15, 0, 275)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Text = "Speed: " .. _G.L11xtery.WalkSpeed
        speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedLabel.TextSize = 12
        speedLabel.Font = Enum.Font.Gotham
        speedLabel.TextXAlignment = Enum.TextXAlignment.Left
        speedLabel.Parent = mainFrame
        
        createButton("+", UDim2.new(0, 150, 0, 275), function()
            _G.L11xtery.WalkSpeed = math.min(250, _G.L11xtery.WalkSpeed + 5)
            speedLabel.Text = "Speed: " .. _G.L11xtery.WalkSpeed
            local hum = getHumanoid(LocalPlayer)
            if hum then hum.WalkSpeed = _G.L11xtery.WalkSpeed end
        end, Color3.fromRGB(0, 80, 0))
        
        createButton("-", UDim2.new(0, 185, 0, 275), function()
            _G.L11xtery.WalkSpeed = math.max(16, _G.L11xtery.WalkSpeed - 5)
            speedLabel.Text = "Speed: " .. _G.L11xtery.WalkSpeed
            local hum = getHumanoid(LocalPlayer)
            if hum then hum.WalkSpeed = _G.L11xtery.WalkSpeed end
        end, Color3.fromRGB(100, 0, 0))
        
        -- Регуляторы прыжка
        local jumpLabel = Instance.new("TextLabel")
        jumpLabel.Size = UDim2.new(0, 130, 0, 25)
        jumpLabel.Position = UDim2.new(0, 15, 0, 310)
        jumpLabel.BackgroundTransparency = 1
        jumpLabel.Text = "Jump: " .. _G.L11xtery.JumpPower
        jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        jumpLabel.TextSize = 12
        jumpLabel.Font = Enum.Font.Gotham
        jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
        jumpLabel.Parent = mainFrame
        
        createButton("+", UDim2.new(0, 150, 0, 310), function()
            _G.L11xtery.JumpPower = math.min(250, _G.L11xtery.JumpPower + 5)
            jumpLabel.Text = "Jump: " .. _G.L11xtery.JumpPower
            local hum = getHumanoid(LocalPlayer)
            if hum then hum.JumpPower = _G.L11xtery.JumpPower end
        end, Color3.fromRGB(0, 80, 0))
        
        createButton("-", UDim2.new(0, 185, 0, 310), function()
            _G.L11xtery.JumpPower = math.max(50, _G.L11xtery.JumpPower - 5)
            jumpLabel.Text = "Jump: " .. _G.L11xtery.JumpPower
            local hum = getHumanoid(LocalPlayer)
            if hum then hum.JumpPower = _G.L11xtery.JumpPower end
        end, Color3.fromRGB(100, 0, 0))
        
        -- КНОПКА ЗАКРЫТИЯ
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 80, 0, 25)
        closeBtn.Position = UDim2.new(1, -90, 1, -35)
        closeBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        closeBtn.BorderSizePixel = 1
        closeBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
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
        print("[L11xteryHub] Ошибка создания GUI: " .. tostring(err))
    end
end

-- === ЗАПУСК GUI ===
createGUI()

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
    
    -- Fly
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
            if player ~= LocalPlayer and player.Character then
                local targetChar = player.Character
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
                            label.Text = player.Name
                            label.TextColor3 = _G.L11xtery.ESPColor
                            label.TextScaled = true
                            label.Parent = esp
                        end)
                    end
                end
            end
        end
    end
    
    -- Chams
    if _G.L11xtery.Chams then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetChar = player.Character
                for _, part in ipairs(targetChar:GetChildren()) do
                    if part:IsA("BasePart") and not part:FindFirstChild("Chams") then
                        pcall(function()
                            local cham = Instance.new("BoxHandleAdornment")
                            cham.Name = "Chams"
                            cham.Size = part.Size
                            cham.CFrame = part.CFrame
                            cham.Color3 = _G.L11xtery.ESPColor
                            cham.Transparency = 0.5
                            cham.AlwaysOnTop = true
                            cham.Parent = part
                        end)
                    end
                end
            end
        end
    end
    
    -- Aimbot
    if _G.L11xtery.Aimbot then
        local target = getNearestPlayer()
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

-- === ИНФОРМАЦИЯ В КОНСОЛИ ===
print("========================================")
print("L11xteryHub загружен!")
print("Разработчик: L11xteryTeam")
print("========================================")
print("GUI появится автоматически")
print("========================================")
