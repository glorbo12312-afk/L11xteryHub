-- ============================================================
-- L11xteryTeamHub — ULTIMATE EDITION (NO NICK CHECK)
-- Разработчик: L11xteryTeam
-- Цена: 9000₽
-- Telegram: https://t.me/L11xteryTeam
-- ============================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerName = LocalPlayer.Name
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- === УДАЛЁН БЛОК С РАЗРЕШЁННЫМИ НИКАМИ ===
-- Больше нет ALLOWED_USERNAMES и функции IsUsernameAllowed

-- === УДАЛЁН КИК ПРИ НЕВЕРНОМ НИКЕ ===
-- Весь блок с условием if not IsUsernameAllowed(PlayerName) then ... end УДАЛЁН

print("[L11xteryTeamHub] Loaded for user: " .. PlayerName .. " (no nick check)")

-- === КЛЮЧ ===
local MASTER_KEY = "L11xteryHub"

-- === ЗАЩИТА ПАМЯТИ ===
local function ProtectMemory()
    local mt = getmetatable(_G) or {}
    local oldIndex = mt.__index or function() end
    local oldNewIndex = mt.__newindex or function() end

    mt.__index = function(t, k)
        if k == "L11xteryKey" or k == "HubKey" then
            return MASTER_KEY
        end
        return oldIndex(t, k)
    end

    mt.__newindex = function(t, k, v)
        if k == "L11xteryKey" or k == "HubKey" then
            return
        end
        return oldNewIndex(t, k, v)
    end

    setmetatable(_G, mt)
end

-- === АНТИ-ОТКЛЮЧЕНИЕ RAYFIELD ===
local function AntiRayfieldKill()
    local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
    local oldDestroy = Rayfield.Destroy
    Rayfield.Destroy = function()
        return
    end
    return Rayfield
end

-- === ЗАЩИТА КЛЮЧА ===
local function KeyGuard()
    local keyMonitor = Instance.new("BoolValue")
    keyMonitor.Name = "KeyGuard"
    keyMonitor.Value = true
    keyMonitor.Parent = LocalPlayer

    keyMonitor:GetPropertyChangedSignal("Value"):Connect(function()
        if _G.L11xteryKey ~= MASTER_KEY then
            LocalPlayer:Kick("[L11xteryTeamHub] Key compromised.")
        end
    end)

    local con = keyMonitor.AncestryChanged:Connect(function()
        if not keyMonitor.Parent then
            local newGuard = Instance.new("BoolValue")
            newGuard.Name = "KeyGuard"
            newGuard.Value = true
            newGuard.Parent = LocalPlayer
            keyMonitor = newGuard
        end
    end)

    return keyMonitor
end

-- === ЗАЩИТА ГЛОБАЛОВ ===
local function LockGlobals()
    local protectedVars = {
        "L11xteryKey",
        "HubKey",
        "MASTER_KEY"
    }
    for _, var in ipairs(protectedVars) do
        _G[var] = MASTER_KEY
    end
end

-- === ИНИЦИАЛИЗАЦИЯ ===
ProtectMemory()
local Rayfield = AntiRayfieldKill()
KeyGuard()
LockGlobals()

-- === НАСТРОЙКА ЦВЕТОВ (красный + тёмно-красный) ===
local COLORS = {
    Main = Color3.fromRGB(255, 0, 0),        -- Красный
    Border = Color3.fromRGB(139, 0, 0),      -- Тёмно-красный
    Background = Color3.fromRGB(0, 0, 0),    -- Чёрный
    Text = Color3.fromRGB(255, 255, 255)     -- Белый
}

-- === GUI С КАСТОМНЫМ ОКНОМ КЛЮЧА ===
local Window = Rayfield:CreateWindow({
    Name = "L11xteryTeamHub",
    Icon = 0,
    LoadingTitle = "L11xteryTeamHub",
    LoadingSubtitle = "Enter Key to Continue",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "L11xteryTeamHub",
        FileName = "L11xteryTeamHub"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = false
    },
    KeySystem = true,
    KeySettings = {
        Title = "L11xteryTeamHub Access",
        Subtitle = "Price: 9000₽ | Telegram: https://t.me/L11xteryTeam",
        Note = "Key: L11xteryHub",
        FileName = "L11xteryTeamHubKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {
            MASTER_KEY
        }
    }
})

-- === ДОБАВЛЯЕМ КОТА СО СЛЮНОЙ ===
local function AddCatImage()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local catGui = Instance.new("ScreenGui")
    catGui.Name = "CatImage"
    catGui.Parent = playerGui
    catGui.ResetOnSpawn = false

    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(0, 200, 0, 200)
    imageLabel.Position = UDim2.new(0.5, -100, 0.5, -100)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = "https://i.imgur.com/2nRtA8C.png" -- Картинка кота со слюной (замени на реальный URL)
    imageLabel.Parent = catGui
end

-- === ДОБАВЛЯЕМ ИКОНКУ L НА ЧЁРНОМ ФОНЕ ===
local function AddIconL()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local iconGui = Instance.new("ScreenGui")
    iconGui.Name = "IconL"
    iconGui.Parent = playerGui
    iconGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 60, 0, 60)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Чёрный
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(139, 0, 0) -- Тёмно-красный
    frame.Parent = iconGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "L"
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Красный
    textLabel.TextSize = 40
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    textLabel.Parent = frame
end

-- === ВЫЗОВ ФУНКЦИЙ ДЛЯ ДОБАВЛЕНИЯ ЭЛЕМЕНТОВ ===
AddCatImage()
AddIconL()

-- === ПОСЛЕ АКТИВАЦИИ КЛЮЧА МЕНЯЕМ ФОН НА L ===
local function SetBackgroundAfterActivation()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local bgGui = Instance.new("ScreenGui")
    bgGui.Name = "BackgroundL"
    bgGui.Parent = playerGui
    bgGui.ResetOnSpawn = false

    local bgFrame = Instance.new("Frame")
    bgFrame.Size = UDim2.new(1, 0, 1, 0)
    bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Чёрный
    bgFrame.Parent = bgGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "L"
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Красный
    textLabel.TextSize = 200
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    textLabel.Parent = bgFrame
end

-- === ЖДЁМ АКТИВАЦИИ КЛЮЧА ===
local function WaitForKeyActivation()
    local keyActivated = false
    local function CheckKey()
        if _G.L11xteryKey == MASTER_KEY and not keyActivated then
            keyActivated = true
            SetBackgroundAfterActivation()
            -- Удаляем старую иконку L
            local iconGui = LocalPlayer.PlayerGui:FindFirstChild("IconL")
            if iconGui then iconGui:Destroy() end
        end
    end

    RunService.Heartbeat:Connect(function()
        CheckKey()
    end)
end

WaitForKeyActivation()

-- === ОСНОВНЫЕ ВКЛАДКИ ===
local MiscTab = Window:CreateTab("Misc", 987654321)
local PlayerTab = Window:CreateTab("Players", 123456789)
local MainTab = Window:CreateTab("Main", 448336245)

-- === MISC TAB ===
MiscTab:CreateButton({
    Name = "Fly Mode (Toggle)",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.PlatformStand = not hum.PlatformStand
            end
        end
    end,
})

-- === PLAYERS TAB ===
PlayerTab:CreateButton({
    Name = "Kill All Players",
    Callback = function()
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local hum = v.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.Health = 0
                end
            end
        end
    end,
})

-- === MAIN TAB ===
MainTab:CreateButton({
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

MainTab:CreateButton({
    Name = "Infinite Jump",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
            end
        end
    end,
})

print("[L11xteryTeamHub] Fully loaded for: " .. PlayerName)
