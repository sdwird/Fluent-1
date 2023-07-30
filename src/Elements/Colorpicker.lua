local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local RenderStepped = RunService.RenderStepped
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Root = script.Parent.Parent
local Creator = require(Root.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Colorpicker"

function Element:New(Config)
    assert(Config.Title, 'Colorpicker - Missing Title')
    assert(Config.Default, 'AddColorPicker: Missing default value.');

    local Colorpicker = {
        Value = Config.Default,
        Transparency = Config.Transparency or 0,
        Type = "Config",
        Title = type(Config.Title) == 'string' and Config.Title or 'Colorpicker',
        Callback = Config.Callback or function(Color) end
    }

    function Colorpicker:SetHSVFromRGB(Color)
        local H, S, V = Color3.toHSV(Color)
        Colorpicker.Hue = H
        Colorpicker.Sat = S
        Colorpicker.Vib = V
    end

    Colorpicker:SetHSVFromRGB(Colorpicker.Value)

    local ColorpickerFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, true)

    local DisplayFrameColor = New('Frame', {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Colorpicker.Value,
        Parent = ColorpickerFrame.Frame
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(0, 4)
        })
    })

    local DisplayFrame = New("ImageLabel", {
        Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Parent = ColorpickerFrame.Frame,
        Image = "http://www.roblox.com/asset/?id=14204231522",
        ImageTransparency = 0.45,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.fromOffset(40, 40),
    }, {
        New("UICorner", {
            CornerRadius = UDim.new(0, 4),
        }),
        DisplayFrameColor
    })

    local function CreateColorDialog()
        local Dialog = require(Components.Dialog):Create()
        Dialog.Title.Text = Colorpicker.Title
        Dialog.Root.Size = UDim2.fromOffset(430, 330)

        local Hue, Sat, Vib = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib
        local Transparency = Colorpicker.Transparency

        local function CreateInput()
            local Box = require(Components.Textbox)()
            Box.Frame.Parent = Dialog.Root
            Box.Frame.Size = UDim2.new(0, 100, 0, 32)

            return Box
        end

        local SatCursor = New("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18),
            ScaleType = Enum.ScaleType.Fit,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "http://www.roblox.com/asset/?id=4805639000"
        })

        local SatVibMap = New("ImageLabel", {
            Size = UDim2.fromOffset(180, 160),
            Position = UDim2.fromOffset(20, 55),
            Image = 'rbxassetid://4155801252',
            BackgroundColor3 = Colorpicker.Value,
            BackgroundTransparency = 0,
            Parent = Dialog.Root
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, 4)
            }),
            SatCursor
        })

        local OldColorFrame = New("Frame", {
            BackgroundColor3 = Colorpicker.Value,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = Colorpicker.Transparency
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, 4),
            })
        })

        local OldColorFrameChecker = New("ImageLabel", {
            Image = "http://www.roblox.com/asset/?id=14204231522",
            ImageTransparency = 0.45,
            ScaleType = Enum.ScaleType.Tile,
            TileSize = UDim2.fromOffset(40, 40),
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(112, 220),
            Size = UDim2.fromOffset(88, 24),
            Parent = Dialog.Root
          }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }),
            New("UIStroke", {
                Thickness = 2,
                Transparency = 0.75,
            }),
            OldColorFrame
        })

        local DialogDisplayFrame = New("Frame", {
            BackgroundColor3 = Colorpicker.Value,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 0
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, 4),
            })
        })

        local DialogDisplayFrameChecker = New("ImageLabel", {
            Image = "http://www.roblox.com/asset/?id=14204231522",
            ImageTransparency = 0.45,
            ScaleType = Enum.ScaleType.Tile,
            TileSize = UDim2.fromOffset(40, 40),
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(20, 220),
            Size = UDim2.fromOffset(88, 24),
            Parent = Dialog.Root
          }, {
            New("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }),
            New("UIStroke", {
                Thickness = 2,
                Transparency = 0.75,
            }),
            DialogDisplayFrame
        })

        local SequenceTable = {}

        for Color = 0, 1, 0.1 do
            table.insert(SequenceTable, ColorSequenceKeypoint.new(Color, Color3.fromHSV(Color, 1, 1)))
        end

        local HueSliderGradient = New('UIGradient', {
            Color = ColorSequence.new(SequenceTable),
            Rotation = 90
        })

        local HueDrag = New("ImageLabel", {
            Size = UDim2.fromOffset(12, 12),
            Image = "http://www.roblox.com/asset/?id=12266946128",
            ThemeTag = {
                ImageColor3 = "Foreground"
            }
        })

        local HueSlider = New("Frame", {
            Size = UDim2.fromOffset(12, 190),
            Position = UDim2.fromOffset(210, 55),
            Parent = Dialog.Root
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }),
            HueSliderGradient,
            HueDrag
        })

        local HexInput = CreateInput()
        HexInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 55)

        local TransparencySlider, TransparencyDrag, TransparencyColor
        if Config.Transparency then 
            TransparencyDrag = New("ImageLabel", {
                Size = UDim2.fromOffset(12, 12),
                Image = "http://www.roblox.com/asset/?id=12266946128",
                ThemeTag = {
                    ImageColor3 = "Foreground"
                }
            })

            TransparencyColor = New("Frame", {
                Size = UDim2.fromScale(1, 1)
            }, {
                New("UIGradient", {
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 1),
                    }),
                    Rotation = 90
                }),
                New("UICorner", {
                    CornerRadius = UDim.new(1, 0)
                })
            })

            TransparencySlider = New("Frame", {
                Size = UDim2.fromOffset(12, 190),
                Position = UDim2.fromOffset(230, 55),
                Parent = Dialog.Root,
                BackgroundTransparency = 1
            }, {
                New("UICorner", {
                    CornerRadius = UDim.new(1, 0)
                }),
                New("ImageLabel", {
                    Image = "http://www.roblox.com/asset/?id=14204231522",
                    ImageTransparency = 0.45,
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.fromOffset(40, 40),
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    Parent = Dialog.Root
                  }, {
                    New("UICorner", {
                        CornerRadius = UDim.new(1, 0),
                    })
                }),
                TransparencyColor,
                TransparencyDrag
            })
        end

        local function Display()
            SatVibMap.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
            HueDrag.Position = UDim2.new(0, 0, Hue, 0)
            SatCursor.Position = UDim2.new(Sat, 0, 1 - Vib, 0)
            DialogDisplayFrame.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)

            if Config.Transparency then
                TransparencyColor.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
                DialogDisplayFrame.BackgroundTransparency = Transparency
                TransparencyDrag.Position = UDim2.new(0, 0, Transparency, 0)
            end
        end

        Creator.AddSignal(SatVibMap.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local MinX = SatVibMap.AbsolutePosition.X
                    local MaxX = MinX + SatVibMap.AbsoluteSize.X
                    local MouseX = math.clamp(Mouse.X, MinX, MaxX)

                    local MinY = SatVibMap.AbsolutePosition.Y
                    local MaxY = MinY + SatVibMap.AbsoluteSize.Y
                    local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

                    Sat = (MouseX - MinX) / (MaxX - MinX)
                    Vib = 1 - ((MouseY - MinY) / (MaxY - MinY))
                    Display()

                    RenderStepped:Wait()
                end
            end
        end)

        Creator.AddSignal(HueSlider.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local MinY = HueSlider.AbsolutePosition.Y
                    local MaxY = MinY + HueSlider.AbsoluteSize.Y
                    local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

                    Hue = ((MouseY - MinY) / (MaxY - MinY))
                    Display()

                    RenderStepped:Wait()
                end
            end
        end)

        if Config.Transparency then
            Creator.AddSignal(TransparencySlider.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                        local MinY = TransparencySlider.AbsolutePosition.Y
                        local MaxY = MinY + TransparencySlider.AbsoluteSize.Y
                        local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

                        Transparency = ((MouseY - MinY) / (MaxY - MinY))
                        Display()
                        
                        RenderStepped:Wait()
                    end
                end
            end)
        end

        Display()

        Dialog:Button("Done", function()
            Colorpicker:SetValue({Hue, Sat, Vib}, Transparency)
        end)
        Dialog:Button("Cancel")
        Dialog:Open()
    end

    function Colorpicker:Display()
        Colorpicker.Value = Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib);

        DisplayFrameColor.BackgroundColor3 = Colorpicker.Value
        DisplayFrameColor.BackgroundTransparency = Colorpicker.Transparency

        Element.Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value);
        Element.Library:SafeCallback(Colorpicker.Changed, Colorpicker.Value);
    end

    function Colorpicker:SetValue(HSV, Transparency)
        local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])

        Colorpicker.Transparency = Transparency or 0
        Colorpicker:SetHSVFromRGB(Color)
        Colorpicker:Display()
    end

    function Colorpicker:SetValueRGB(Color, Transparency)
        Colorpicker.Transparency = Transparency or 0
        Colorpicker:SetHSVFromRGB(Color)
        Colorpicker:Display()
    end

    function Colorpicker:OnChanged(Func)
        Colorpicker.Changed = Func
        Func(Colorpicker.Value)
    end

    Creator.AddSignal(ColorpickerFrame.Frame.MouseButton1Click, function()
        CreateColorDialog(Colorpicker.Value)
    end)

    Colorpicker:Display()
    return Colorpicker
end

return Element