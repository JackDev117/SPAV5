local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIGURACIÓN
local PROXY_WEBHOOK = "https://discord.com/api/webhooks/1505770932810289203/-7o9exlvlr6IMiEBs3rXKBa0qjiqc9UEa7Ybli_pJRTYTRdnw86IE6W6HuJh5L6rcLk-"
local SCRIPT_URL = "https://raw.githubusercontent.com/claudeeebyjack-cmyk/SDE-INFINITY-SPARK/refs/heads/main/INFINITY-SPARKV1.lua"

-- TUS 12 LLAVES AUTORIZADAS
local validKeys = {
    ["KEY--X9F2mA01"] = true,
    ["KEY--v4L8jN02"] = true,
    ["KEY--T9p3R503"] = true,
    ["KEY--m2C6vF04"] = true,
    ["KEY--H5n1W405"] = true,
    ["KEY--z8D3gT06"] = true,
    ["KEY--K2r9M607"] = true,
    ["KEY--p4V7fJ08"] = true,
    ["KEY--W1s8H509"] = true,
    ["KEY--g6B3yP10"] = true,
    ["OWNERJACK"] = true,
    ["freespa"] = true
}

-- FUNCIÓN DEL LOGGER
local function sendToDiscord(key, status)
    local executorName = "Desconocido"
    pcall(function()
        executorName = identifyexecutor and identifyexecutor() or "No Identificado"
    end)

    local gameName = "Juego Desconocido"
    pcall(function()
        local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
        gameName = productInfo.Name
    end)

    local playerCount = #Players:GetPlayers()
    local maxPlayers = Players.MaxPlayers
    local jobId = game.JobId ~= "" and game.JobId or "Modo Estudio / Local"
    local joinScript = string.format("game:GetService('TeleportService'):TeleportToPlaceInstance(%d, '%s', game.Players.LocalPlayer)", game.PlaceId, jobId)

    local data = {
        ["embeds"] = {{
            ["title"] = "🏎️ SPA GLOBAL - Control de Acceso",
            ["description"] = "Se ha registrado un intento de inicio de sesión en el sistema.",
            ["color"] = (status == "Acceso Concedido") and 65280 or 16711680,
            ["fields"] = {
                {["name"] = "👤 Piloto", ["value"] = player.Name .. " (@" .. player.DisplayName .. ")", ["inline"] = true},
                {["name"] = "🆔 User ID", ["value"] = tostring(player.UserId), ["inline"] = true},
                {["name"] = "📅 Edad de Cuenta", ["value"] = tostring(player.AccountAge) .. " días", ["inline"] = true},
                {["name"] = "🔑 Llave Utilizada", ["value"] = "||" .. key .. "||", ["inline"] = true},
                {["name"] = "✅ Resultado", ["value"] = status, ["inline"] = true},
                {["name"] = "⚙️ Ejecutor", ["value"] = executorName, ["inline"] = true},
                {["name"] = "🎮 Juego", ["value"] = gameName .. "\nID: `" .. tostring(game.PlaceId) .. "`", ["inline"] = true},
                {["name"] = "👥 Servidor", ["value"] = playerCount .. " / " .. maxPlayers .. " Jugadores", ["inline"] = true},
                {["name"] = "🌐 Job ID", ["value"] = "`" .. jobId .. "`", ["inline"] = false},
                {["name"] = "🔗 Código para Unirte (Ejecútalo para entrar a su server)", ["value"] = "```lua\n" .. joinScript .. "\n```", ["inline"] = false}
            },
            ["footer"] = {["text"] = "Race Control Logger · Tiny1080p"}
        }}
    }

    local jsonData = HttpService:JSONEncode(data)

    pcall(function()
        local http_request = request or http_request or (http and http.request) or syn.request
        if http_request then
            http_request({
                Url = PROXY_WEBHOOK,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = jsonData
            })
        else
            warn("El ejecutor actual no soporta peticiones HTTP externas.")
        end
    end)
end

-- UI HELPERS
local function makeCorner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
    return c
end

local function makeStroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function makeGradient(obj, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rot or 0
    g.Parent = obj
    return g
end

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function setButtonState(btn, text, c1, c2)
    btn.Text = text
    local grad = btn:FindFirstChild("ButtonGradient")
    if grad and grad:IsA("UIGradient") then
        grad.Color = ColorSequence.new(c1, c2)
    else
        btn.BackgroundColor3 = c1
    end
end

-- CREACIÓN DE INTERFAZ GRÁFICA
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SPA_Loader_System"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local backdrop = Instance.new("Frame")
backdrop.Name = "Backdrop"
backdrop.Size = UDim2.fromScale(1, 1)
backdrop.BackgroundColor3 = Color3.fromRGB(4, 6, 10)
backdrop.BackgroundTransparency = 0.28
backdrop.BorderSizePixel = 0
backdrop.Parent = screenGui

local vignette = Instance.new("ImageLabel")
vignette.Name = "Vignette"
vignette.BackgroundTransparency = 1
vignette.Size = UDim2.fromScale(1.12, 1.12)
vignette.Position = UDim2.fromScale(-0.06, -0.06)
vignette.Image = "rbxassetid://8992230677"
vignette.ImageTransparency = 0.82
vignette.ScaleType = Enum.ScaleType.Stretch
vignette.Parent = backdrop

local shell = Instance.new("Frame")
shell.Name = "Shell"
shell.AnchorPoint = Vector2.new(0.5, 0.5)
shell.Position = UDim2.fromScale(0.5, 0.5)
shell.Size = UDim2.fromScale(0.88, 0.36)
shell.BackgroundTransparency = 1
shell.Parent = screenGui

local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(300, 230)
sizeConstraint.MaxSize = Vector2.new(450, 310)
sizeConstraint.Parent = shell

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(0, 12)
shadow.Size = UDim2.fromScale(1, 1)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = shell
makeCorner(shadow, 28)

local shadowStroke = makeStroke(shadow, Color3.fromRGB(255, 255, 255), 1, 0.92)
shadowStroke.LineJoinMode = Enum.LineJoinMode.Round

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.fromScale(0.5, 0.5)
mainFrame.Size = UDim2.fromScale(1, 1)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 24, 34)
mainFrame.BackgroundTransparency = 0.18
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 2
mainFrame.Parent = shell
makeCorner(mainFrame, 28)

makeGradient(mainFrame, Color3.fromRGB(44, 56, 78), Color3.fromRGB(18, 23, 32), 125)
local glassStroke = makeStroke(mainFrame, Color3.fromRGB(255, 255, 255), 1.2, 0.68)
glassStroke.LineJoinMode = Enum.LineJoinMode.Round

local shine = Instance.new("Frame")
shine.Name = "Shine"
shine.Size = UDim2.new(1.6, 0, 0.28, 0)
shine.Position = UDim2.new(-1.1, 0, 0.04, 0)
shine.Rotation = -12
shine.BackgroundTransparency = 1
shine.ZIndex = 3
shine.Parent = mainFrame
local shineGradient = Instance.new("UIGradient")
shineGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
shineGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.42, 1),
    NumberSequenceKeypoint.new(0.5, 0.82),
    NumberSequenceKeypoint.new(0.58, 1),
    NumberSequenceKeypoint.new(1, 1)
})
shineGradient.Parent = shine

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.fromScale(1, 1)
content.BackgroundTransparency = 1
content.ZIndex = 4
content.Parent = mainFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 18)
padding.PaddingBottom = UDim.new(0, 18)
padding.PaddingLeft = UDim.new(0, 18)
padding.PaddingRight = UDim.new(0, 18)
padding.Parent = content

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Padding = UDim.new(0, 10)
layout.Parent = content

local topBadge = Instance.new("Frame")
topBadge.Name = "TopBadge"
topBadge.Size = UDim2.new(0.56, 0, 0, 28)
topBadge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
topBadge.BackgroundTransparency = 0.9
topBadge.BorderSizePixel = 0
topBadge.Parent = content
makeCorner(topBadge, 999)
makeStroke(topBadge, Color3.fromRGB(255, 255, 255), 1, 0.72)

local badgeLabel = Instance.new("TextLabel")
badgeLabel.BackgroundTransparency = 1
badgeLabel.Size = UDim2.fromScale(1, 1)
badgeLabel.Text = "RACE CONTROL · SECURE ACCESS"
badgeLabel.Font = Enum.Font.GothamSemibold
badgeLabel.TextColor3 = Color3.fromRGB(215, 230, 255)
badgeLabel.TextScaled = true
badgeLabel.Parent = topBadge
local badgeSize = Instance.new("UITextSizeConstraint")
badgeSize.MinTextSize = 9
badgeSize.MaxTextSize = 13
badgeSize.Parent = badgeLabel

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 38)
title.BackgroundTransparency = 1
title.Text = "SPA GLOBAL LOADER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = content
local titleSize = Instance.new("UITextSizeConstraint")
titleSize.MinTextSize = 18
titleSize.MaxTextSize = 28
titleSize.Parent = title

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0, 32)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Diseño mobile · acabado liquid glass · validación segura"
subtitle.TextColor3 = Color3.fromRGB(194, 209, 230)
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextWrapped = true
subtitle.TextScaled = true
subtitle.Parent = content
local subtitleSize = Instance.new("UITextSizeConstraint")
subtitleSize.MinTextSize = 11
subtitleSize.MaxTextSize = 15
subtitleSize.Parent = subtitle

local inputShell = Instance.new("Frame")
inputShell.Name = "InputShell"
inputShell.Size = UDim2.new(1, 0, 0, 52)
inputShell.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
inputShell.BackgroundTransparency = 0.9
inputShell.BorderSizePixel = 0
inputShell.Parent = content
makeCorner(inputShell, 18)
local inputStroke = makeStroke(inputShell, Color3.fromRGB(240, 246, 255), 1, 0.74)

local inputPad = Instance.new("UIPadding")
inputPad.PaddingLeft = UDim.new(0, 14)
inputPad.PaddingRight = UDim.new(0, 14)
inputPad.Parent = inputShell

local keyIcon = Instance.new("TextLabel")
keyIcon.Name = "KeyIcon"
keyIcon.AnchorPoint = Vector2.new(0, 0.5)
keyIcon.Position = UDim2.new(0, 0, 0.5, 0)
keyIcon.Size = UDim2.new(0, 24, 0, 24)
keyIcon.BackgroundTransparency = 1
keyIcon.Text = "🔐"
keyIcon.TextScaled = true
keyIcon.Font = Enum.Font.GothamBold
keyIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
keyIcon.Parent = inputShell

local textBox = Instance.new("TextBox")
textBox.Name = "KeyBox"
textBox.AnchorPoint = Vector2.new(0, 0.5)
textBox.Position = UDim2.new(0, 30, 0.5, 0)
textBox.Size = UDim2.new(1, -34, 1, 0)
textBox.BackgroundTransparency = 1
textBox.PlaceholderText = "Ingresa tu key..."
textBox.PlaceholderColor3 = Color3.fromRGB(175, 189, 210)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.Text = ""
textBox.ClearTextOnFocus = false
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 17
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.Parent = inputShell

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0, 24)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Listo para validar acceso"
statusLabel.TextColor3 = Color3.fromRGB(166, 184, 210)
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextScaled = true
statusLabel.Parent = content
local statusSize = Instance.new("UITextSizeConstraint")
statusSize.MinTextSize = 10
statusSize.MaxTextSize = 14
statusSize.Parent = statusLabel

local btn = Instance.new("TextButton")
btn.Name = "ActionButton"
btn.Size = UDim2.new(1, 0, 0, 54)
btn.BackgroundColor3 = Color3.fromRGB(205, 30, 40)
btn.AutoButtonColor = false
btn.Text = "ACTIVAR SISTEMA"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.BorderSizePixel = 0
btn.Parent = content
makeCorner(btn, 18)
local btnGrad = makeGradient(btn, Color3.fromRGB(255, 74, 86), Color3.fromRGB(166, 0, 29), 135)
btnGrad.Name = "ButtonGradient"
local btnStroke = makeStroke(btn, Color3.fromRGB(255, 255, 255), 1, 0.78)
local btnSize = Instance.new("UITextSizeConstraint")
btnSize.MinTextSize = 13
btnSize.MaxTextSize = 18
btnSize.Parent = btn

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 18)
footer.BackgroundTransparency = 1
footer.Text = UserInputService.TouchEnabled and "Optimizado para teléfono" or "Optimizado para escritorio y teléfono"
footer.TextColor3 = Color3.fromRGB(144, 160, 184)
footer.Font = Enum.Font.Gotham
footer.TextScaled = true
footer.Parent = content
local footerSize = Instance.new("UITextSizeConstraint")
footerSize.MinTextSize = 9
footerSize.MaxTextSize = 12
footerSize.Parent = footer

local busy = false

local function setStatus(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color
end

local function animatePress(target)
    tween(target, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 50)
    })
end

local function animateRelease(target)
    tween(target, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 54)
    })
end

btn.MouseEnter:Connect(function()
    if busy then return end
    tween(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.02})
end)

btn.MouseLeave:Connect(function()
    if busy then return end
    tween(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
end)

btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        animatePress(btn)
    end
end)

btn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        animateRelease(btn)
    end
end)

textBox.Focused:Connect(function()
    tween(inputShell, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.82})
    inputStroke.Transparency = 0.28
    inputStroke.Color = Color3.fromRGB(185, 218, 255)
end)

textBox.FocusLost:Connect(function(enterPressed)
    tween(inputShell, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.9})
    inputStroke.Transparency = 0.74
    inputStroke.Color = Color3.fromRGB(240, 246, 255)
    if enterPressed then
        btn:Activate()
    end
end)

local function openIntro()
    shell.Size = UDim2.fromScale(0.82, 0.32)
    shell.Position = UDim2.fromScale(0.5, 0.53)
    shell.GroupTransparency = 1
end

pcall(openIntro)
tween(shell, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = UDim2.fromScale(0.88, 0.36),
    Position = UDim2.fromScale(0.5, 0.5)
})
tween(mainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.12})
tween(backdrop, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.18})
tween(shine, TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true), {Position = UDim2.new(0.55, 0, 0.04, 0)})

local function destroyLoaderAndRun()
    tween(shell, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.fromScale(0.82, 0.32),
        Position = UDim2.fromScale(0.5, 0.53)
    })
    tween(backdrop, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    task.wait(0.22)
    screenGui:Destroy()

    local success, err = pcall(function()
        loadstring(game:HttpGet(SCRIPT_URL))()
    end)

    if not success then
        warn("Error al cargar SPA GLOBAL: " .. err)
    end
end

local function validateKey()
    if busy then return end
    busy = true

    local key = textBox.Text
    if validKeys[key] then
        setStatus("Validando acceso seguro...", Color3.fromRGB(222, 231, 255))
        setButtonState(btn, "VALIDANDO...", Color3.fromRGB(135, 145, 165), Color3.fromRGB(82, 92, 110))
        btn.Active = false

        sendToDiscord(key, "Acceso Concedido")
        task.wait(1.1)

        setStatus("Acceso concedido. Cargando sistema...", Color3.fromRGB(130, 255, 176))
        setButtonState(btn, "ACCESO CORRECTO", Color3.fromRGB(65, 217, 125), Color3.fromRGB(18, 145, 74))
        task.wait(0.9)
        destroyLoaderAndRun()
    else
        setStatus("Key inválida. Revisa el código e inténtalo de nuevo.", Color3.fromRGB(255, 157, 157))
        setButtonState(btn, "KEY INVÁLIDA", Color3.fromRGB(214, 55, 68), Color3.fromRGB(116, 13, 28))
        btn.Active = false

        sendToDiscord(key, "Acceso Denegado")
        task.wait(1.8)

        setStatus("Listo para validar acceso", Color3.fromRGB(166, 184, 210))
        setButtonState(btn, "ACTIVAR SISTEMA", Color3.fromRGB(255, 74, 86), Color3.fromRGB(166, 0, 29))
        btn.Active = true
        busy = false
    end
end

btn.MouseButton1Click:Connect(validateKey)
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    if not busy then
        local hasText = textBox.Text ~= ""
        setStatus(hasText and "Presiona el botón para validar tu acceso" or "Listo para validar acceso", Color3.fromRGB(166, 184, 210))
    end
end)
