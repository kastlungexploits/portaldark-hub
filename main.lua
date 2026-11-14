--[[
    PORTAL DARK
    Copyright (c) 2026 kastlungexploits

    Arquivo principal do projeto.
    Substitua este exemplo pelo código principal quando estiver pronto.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer

-- CONFIGURAÇÕES
local ROXO = Color3.fromRGB(170, 55, 255)
local AMARELO = Color3.fromRGB(255, 205, 65)
local FUNDO = Color3.fromRGB(12, 8, 18)

-- LINK PARA PEGAR KEY
local LINK_KEY = "https://seusite.com/key"

local gui = Instance.new("ScreenGui")
gui.Name = "PortalDark"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- JANELA PRINCIPAL
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(420, 260)
frame.Position = UDim2.new(0.5, -210, 0.5, -130)
frame.BackgroundColor3 = FUNDO
frame.BackgroundTransparency = 0.12
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)

local stroke = Instance.new("UIStroke")
stroke.Color = ROXO
stroke.Transparency = 0.35
stroke.Thickness = 1.5
stroke.Parent = frame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, ROXO),
    ColorSequenceKeypoint.new(1, AMARELO)
})
gradient.Rotation = 25
gradient.Parent = stroke

-- TÍTULO
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 45)
title.Position = UDim2.fromOffset(18, 8)
title.BackgroundTransparency = 1
title.Text = "PORTAL DARK"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 23
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- BOTÃO FECHAR
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 32)
close.Position = UDim2.new(1, -43, 0, 12)
close.BackgroundColor3 = Color3.fromRGB(220, 45, 55)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 17
close.Font = Enum.Font.GothamBold
close.Parent = frame

Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

close.Activated:Connect(function()
    gui:Destroy()
end)

-- TEXTBOX
local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -50, 0, 48)
box.Position = UDim2.fromOffset(25, 75)
box.BackgroundColor3 = Color3.fromRGB(40, 30, 52)
box.BackgroundTransparency = 0.2
box.Text = ""
box.PlaceholderText = "Coloca sua key aqui"
box.PlaceholderColor3 = Color3.fromRGB(180, 165, 195)
box.TextColor3 = Color3.new(1, 1, 1)
box.TextSize = 16
box.Font = Enum.Font.Code
box.ClearTextOnFocus = false
box.Parent = frame

Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)

-- CRIAR BOTÕES
local function criarBotao(nome, texto, posicao)
    local botao = Instance.new("TextButton")
    botao.Name = nome
    botao.Size = UDim2.fromOffset(175, 43)
    botao.Position = posicao
    botao.BackgroundColor3 = ROXO
    botao.Text = texto
    botao.TextColor3 = Color3.new(1, 1, 1)
    botao.TextSize = 15
    botao.Font = Enum.Font.GothamBold
    botao.Parent = frame

    Instance.new("UICorner", botao).CornerRadius =
        UDim.new(0, 12)

    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(ROXO, AMARELO)
    g.Parent = botao

    return botao
end

local pegar = criarBotao(
    "PegarKey",
    "Pegar Key",
    UDim2.fromOffset(25, 145)
)

local verificar = criarBotao(
    "VerificarKey",
    "Verificar Key",
    UDim2.fromOffset(220, 145)
)

-- STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -30, 0, 35)
status.Position = UDim2.fromOffset(15, 205)
status.BackgroundTransparency = 1
status.Text = "Aguardando sua key..."
status.TextColor3 = Color3.fromRGB(190, 175, 210)
status.TextSize = 14
status.Font = Enum.Font.Gotham
status.Parent = frame

-- PEGAR KEY
pegar.Activated:Connect(function()
    local sucesso = pcall(function()
        GuiService:OpenBrowserWindow(LINK_KEY)
    end)

    if sucesso then
        status.Text = "Link aberto!"
    else
        status.Text = "Não foi possível abrir o link."
    end
end)

-- VERIFICAR KEY
verificar.Activated:Connect(function()
    if box.Text == "" then
        status.Text = "Digite uma key primeiro!"
        return
    end

    status.Text = "Verificando..."

    local remote = ReplicatedStorage:WaitForChild("VerifyPortalKey")

    local success, valid = pcall(function()
        return remote:InvokeServer(box.Text)
    end)

    if not success then
        status.Text = "Erro ao conectar ao servidor."
        return
    end

    if valid then
        status.Text = "Key válida! Carregando..."

        task.wait(1)

        local loading = ReplicatedStorage:FindFirstChild("PortalDarkLoading")

        if loading and loading:IsA("ModuleScript") then
            require(loading).Start()
        end
    else
        status.Text = "Key inválida!"
    end
end)
