-- [[ KA HUB | ULTIMATE V8 REBORN + SPEED HACK ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIGURAÇÕES
local Config = {
    Aimbot = false,
    FOV = 150,
    ESP = false,
    Clicking = false,
    ClickCount = 0,
    LastClickCount = 0,
    LastUpdate = tick(),
    SpeedHack = false,
    WalkSpeed = 16
}

local heartbeatConn

-- [[ MIRA FÍSICA V8 (ARRASTÁVEL) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KA_V8_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local CursorHitbox = Instance.new("Frame", ScreenGui)
CursorHitbox.Size = UDim2.new(0, 60, 0, 60)
CursorHitbox.Position = UDim2.new(0.5, -30, 0.5, -30)
CursorHitbox.BackgroundTransparency = 1
CursorHitbox.Active = true
CursorHitbox.Draggable = true

local CursorVisual = Instance.new("Frame", CursorHitbox)
CursorVisual.Size = UDim2.new(0, 40, 0, 40)
CursorVisual.Position = UDim2.new(0.5, -20, 0.5, -20)
CursorVisual.BackgroundTransparency = 1

local function createLine(size, pos)
    local l = Instance.new("Frame", CursorVisual)
    l.Size = size
    l.Position = pos
    l.BackgroundColor3 = Color3.new(1, 1, 1)
    l.BorderSizePixel = 0
    return l
end

createLine(UDim2.new(1, 0, 0, 2), UDim2.new(0, 0, 0.5, -1))
createLine(UDim2.new(0, 2, 1, 0), UDim2.new(0.5, -1, 0, 0))

local CenterDot = Instance.new("Frame", CursorVisual)
CenterDot.Size = UDim2.new(0, 8, 0, 8)
CenterDot.Position = UDim2.new(0.5, -4, 0.5, -4)
CenterDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Instance.new("UICorner", CenterDot).CornerRadius = UDim.new(1, 0)

-- [[ FUNÇÃO DE CLIQUE ]]
local function doV8Click()
    if not Config.Clicking then return end
    local pos = CursorHitbox.AbsolutePosition + (CursorHitbox.AbsoluteSize / 2)
    VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
    VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
    Config.ClickCount = Config.ClickCount + 1
end

-- [[ JANELA PRINCIPAL ]]
local Window = Rayfield:CreateWindow({
   Name = "KA Hub | V8 Premium",
   LoadingTitle = "Iniciando Sistemas...",
   LoadingSubtitle = "Speed Hack Adicionado",
   ConfigurationSaving = { Enabled = false }
})

-- ABA AUTO CLICKER
local ClickTab = Window:CreateTab("Auto Clicker", 4483362458)
local CPSLabel = ClickTab:CreateLabel("CPS Atual: 0")

ClickTab:CreateToggle({
   Name = "ATIVAR MODO V8 (MAX SPEED)",
   CurrentValue = false,
   Callback = function(Value)
      Config.Clicking = Value
      if Value then heartbeatConn = RunService.Heartbeat:Connect(doV8Click)
      else if heartbeatConn then heartbeatConn:Disconnect() end end
   end,
})

-- ABA COMBATE
local CombatTab = Window:CreateTab("Combate", 4483362458)
CombatTab:CreateToggle({Name = "Aimbot (Head)", CurrentValue = false, Callback = function(v) Config.Aimbot = v end})
CombatTab:CreateToggle({Name = "ESP (Highlights)", CurrentValue = false, Callback = function(v) Config.ESP = v end})

-- ABA MOVIMENTO (SPEED HACK)
local MoveTab = Window:CreateTab("Movimento", 4483362458)

MoveTab:CreateToggle({
   Name = "Ativar Speed Hack",
   CurrentValue = false,
   Callback = function(v) Config.SpeedHack = v end,
})

MoveTab:CreateSlider({
   Name = "Velocidade (WalkSpeed)",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) Config.WalkSpeed = v end,
})

-- [[ LOOP PRINCIPAL ]]
RunService.RenderStepped:Connect(function()
    -- Atualiza CPS
    if tick() - Config.LastUpdate >= 1 then
        CPSLabel:Set("CPS Atual: " .. (Config.ClickCount - Config.LastClickCount))
        Config.LastClickCount = Config.ClickCount
        Config.LastUpdate = tick()
    end

    -- Speed Hack Loop
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if Config.SpeedHack then
            LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeed
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end

    -- ESP Loop
    if Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("V8_ESP") or Instance.new("Highlight", p.Character)
                h.Name = "V8_ESP"
                h.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end

    -- Aimbot Loop
    if Config.Aimbot then
        local target = nil
        local dist = Config.FOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < dist then dist = mag target = p end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
    end
end)

Rayfield:Notify({Title = "KA HUB V8", Content = "Speed Hack e Auto Clicker prontos!", Duration = 5})
