local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 1.000
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new(0, 1920, 0, 1080)  -- // Screen Size (i know i couldve used view )
Frame.Position = UDim2.new(0.5, -Frame.Size.X.Offset/2, 0.5, -Frame.Size.Y.Offset/2)

local fps = 0
local ping = 0

local function calculateFPS()
    local lastTime = tick()
    local frameCount = 0

    game:GetService("RunService").RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            fps = frameCount
            frameCount = 0
            lastTime = currentTime
        end
    end)
end

local function calculatePing()
    game:GetService("RunService").Heartbeat:Connect(function()
        ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
end

local function getTime()
    return os.date("%I:%M %p")
end

local function makeDraggable(frame, parentFrame)
    local UIS = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        local parentSize = parentFrame.AbsoluteSize
        local frameSize = frame.AbsoluteSize

        newPos = UDim2.new(
            newPos.X.Scale, math.clamp(newPos.X.Offset, 0, parentSize.X - frameSize.X),
            newPos.Y.Scale, math.clamp(newPos.Y.Offset, 0, parentSize.Y - frameSize.Y)
        )

        frame.Position = newPos
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

local function createWatermark(parentFrame)
    local watermark = {Container = nil, Objects = {}}
    local NewInd = Instance.new("Frame")
    NewInd.Name = "Watermark"
    NewInd.AutomaticSize = Enum.AutomaticSize.X
    NewInd.Position = UDim2.new(0, 20, 0, 20)
    NewInd.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    NewInd.BackgroundTransparency = 0.5
    NewInd.BorderSizePixel = 0
    NewInd.Size = UDim2.fromOffset(0, 20)
    NewInd.Parent = parentFrame
    NewInd.ZIndex = 100
    watermark.Container = NewInd

    local Outline = Instance.new("ImageLabel")
    Outline.Name = "Outline"
    Outline.AnchorPoint = Vector2.new(0, 0)
    Outline.AutomaticSize = Enum.AutomaticSize.X
    Outline.BackgroundTransparency = 1
    Outline.Image = "rbxassetid://3570695787"
    Outline.ImageColor3 = Color3.fromRGB(255, 255, 255)
    Outline.ScaleType = Enum.ScaleType.Slice
    Outline.SliceCenter = Rect.new(100, 100, 100, 100)
    Outline.SliceScale = 0.05
    Outline.Position = UDim2.new(0, 0, 0, 0)
    Outline.Size = UDim2.fromOffset(0, 20)
    Outline.Visible = true
    Outline.ZIndex = 101
    Outline.Parent = NewInd

    local gradientOutline = Instance.new("UIGradient")
    -- // Color Settings Gradient Outline
    gradientOutline.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(144, 238, 144)),  -- // Top
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))  -- // Bottom
    }
    gradientOutline.Rotation = 90
    gradientOutline.Parent = Outline

    local Inline = Instance.new("Frame")
    Inline.Name = "Inline"
    Inline.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Inline.BorderSizePixel = 0
    Inline.Position = UDim2.fromOffset(1, 1)
    Inline.Size = UDim2.new(1, -2, 1, -2)
    Inline.ZIndex = 102

    local UICorner2 = Instance.new("UICorner")
    UICorner2.Name = "UICorner_2"
    UICorner2.CornerRadius = UDim.new(0, 4)
    UICorner2.Parent = Inline

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
    Title.RichText = true
    Title.Text = "starhook<font color='rgb(144, 238, 144)'>.club</font> | FPS: 0 | Ping: 0ms | Time: 00:00 PM"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.AutomaticSize = Enum.AutomaticSize.X
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Title.BorderSizePixel = 0
    Title.Position = UDim2.fromOffset(5, 0)
    Title.Size = UDim2.fromScale(0, 1)
    Title.Parent = Inline
    Title.ZIndex = 103

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "UIPadding"
    UIPadding.PaddingRight = UDim.new(0, 6)
    UIPadding.Parent = Inline

    Inline.Parent = Outline

    watermark.Container = NewInd
    watermark.Title = Title

    makeDraggable(NewInd, parentFrame)
    return watermark
end

local function updateWatermark(watermark)
    local fpsColor = "rgb(255, 255, 255)"
    local pingColor = "rgb(255, 255, 255)"

    if fps > 100 then
        fpsColor = "rgb(0, 255, 0)"
    elseif fps > 50 then
        fpsColor = "rgb(255, 255, 0)"
    else
        fpsColor = "rgb(255, 0, 0)"
    end

    if ping < 30 then
        pingColor = "rgb(0, 255, 0)"
    elseif ping < 100 then
        pingColor = "rgb(255, 255, 0)"
    else
        pingColor = "rgb(255, 0, 0)"
    end

    -- // Watermark Name, FPS, Ping, Time
    local text = string.format(
        "Sharp<font color='rgb(144, 238, 144)'>.cc</font> | FPS: <font color='%s'>%d</font> | Ping: <font color='%s'>%dms</font> | Time: %s",
        fpsColor, fps, pingColor, ping, getTime()
    )
    watermark.Title.Text = text
end

local watermark = createWatermark(Frame)

calculateFPS()
calculatePing()

game:GetService("RunService").RenderStepped:Connect(function()
    updateWatermark(watermark)
end)
