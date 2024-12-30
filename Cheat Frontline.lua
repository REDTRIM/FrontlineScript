-- ESP Configuration et autres options
local HitboxSize = Vector3.new(10, 10, 10) -- Taille par défaut des hitboxes
local ModifyHitboxes = true -- Activer/Désactiver la modification des hitboxes

if getgenv().c then 
    getgenv().c:Disconnect() 
end

-- Fonction pour rendre les éléments déplaçables
local function makeDraggable(frame)
    local UIS = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Variable pour stocker le menu principal
local Frame

-- Création du menu
local function createMenu()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 250)
    Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    makeDraggable(Frame)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.Text = "Cheat Frontline Undetect By Redtrim"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.Parent = Frame

    -- Case à cocher pour activer/désactiver
    local EnableButton = Instance.new("TextButton")
    EnableButton.Size = UDim2.new(0.9, 0, 0, 30)
    EnableButton.Position = UDim2.new(0.05, 0, 0.2, 0)
    EnableButton.Text = "Enable Hitbox Modification"
    EnableButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    EnableButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    EnableButton.Font = Enum.Font.Gotham
    EnableButton.TextSize = 14
    EnableButton.Parent = Frame

    EnableButton.MouseButton1Click:Connect(function()
        ModifyHitboxes = not ModifyHitboxes
        EnableButton.Text = ModifyHitboxes and "Disable Hitbox Modification" or "Enable Hitbox Modification"
        EnableButton.BackgroundColor3 = ModifyHitboxes and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    end)

    -- Slider pour ajuster la taille des hitboxes
    local SizeSliderLabel = Instance.new("TextLabel")
    SizeSliderLabel.Size = UDim2.new(0.9, 0, 0, 30)
    SizeSliderLabel.Position = UDim2.new(0.05, 0, 0.4, 0)
    SizeSliderLabel.BackgroundTransparency = 1
    SizeSliderLabel.Text = "Hitbox Size: 10"
    SizeSliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SizeSliderLabel.Font = Enum.Font.Gotham
    SizeSliderLabel.TextSize = 14
    SizeSliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SizeSliderLabel.Parent = Frame

    local SizeSlider = Instance.new("TextBox")
    SizeSlider.Size = UDim2.new(0.9, 0, 0, 30)
    SizeSlider.Position = UDim2.new(0.05, 0, 0.5, 0)
    SizeSlider.Text = "10"
    SizeSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SizeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    SizeSlider.Font = Enum.Font.Gotham
    SizeSlider.TextSize = 14
    SizeSlider.TextXAlignment = Enum.TextXAlignment.Center
    SizeSlider.Parent = Frame

    SizeSlider.FocusLost:Connect(function()
        local newValue = tonumber(SizeSlider.Text)
        if newValue then
            HitboxSize = Vector3.new(newValue, newValue, newValue)
            SizeSliderLabel.Text = "Hitbox Size: " .. newValue
        else
            SizeSlider.Text = tostring(HitboxSize.X)
        end
    end)

    -- Bouton pour activer le script ESP
    local ESPButton = Instance.new("TextButton")
    ESPButton.Size = UDim2.new(0.9, 0, 0, 30)
    ESPButton.Position = UDim2.new(0.05, 0, 0.7, 0)
    ESPButton.Text = "Activate ESP"
    ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPButton.Font = Enum.Font.Gotham
    ESPButton.TextSize = 14
    ESPButton.Parent = Frame

    ESPButton.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://pastebin.com/raw/2J01Jtpq"))()
    end)
end

-- Appeler la fonction pour créer le menu
createMenu()

-- Modifier les hitboxes
getgenv().c = game:GetService("RunService").RenderStepped:Connect(function()
    if ModifyHitboxes then
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and v.Color == Color3.new(1, 0, 0) then
                v.Transparency = 0.5
                v.Size = HitboxSize
            end
        end
    end
end)

-- Gérer la visibilité du menu avec F3
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F3 then
        Frame.Visible = not Frame.Visible
    end
end)
