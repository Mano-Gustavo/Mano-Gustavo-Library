--[[ 
    🌟 MANO GUSTAVO UI - DIAMOND EDITION (V7.7)
    [Update: Search Bar (Barra de Pesquisa), Notificações Premium, Color Picker]
]]

local Library = (function()
    --// CONFIGURAÇÕES GERAIS //--
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")

    local Lib = {}
    local UIConfig = {
        MainColor = Color3.fromRGB(25, 25, 25),
        SecondaryColor = Color3.fromRGB(35, 35, 35),
        AccentColor = Color3.fromRGB(0, 110, 255),
        HoverColor = Color3.fromRGB(45, 45, 45),
        TextColor = Color3.fromRGB(240, 240, 240),
        StrokeColor = Color3.fromRGB(60, 60, 60),
        Font = Enum.Font.GothamMedium,
        Transparency = 0.1
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GustavoHub_V7"
    if CoreGui:FindFirstChild("GustavoHub_V7") then CoreGui["GustavoHub_V7"]:Destroy() end
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    --// UTILS //--
    local function CreateInstance(cls, props)
        local inst = Instance.new(cls)
        for i,v in pairs(props) do inst[i] = v end
        return inst
    end

    local function MakeDraggable(frame, trigger)
        local dragging, dragStart, startPos, dragInput
        trigger.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = frame.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        trigger.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                TweenService:Create(frame, TweenInfo.new(0.15), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
            end
        end)
    end

    --// NOTIFICAÇÕES //--
    local NotifHolder = Instance.new("Frame")
    NotifHolder.Parent = ScreenGui
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Position = UDim2.new(1, -20, 1, -20) 
    NotifHolder.AnchorPoint = Vector2.new(1, 1)
    NotifHolder.Size = UDim2.new(0, 300, 1, 0)
    
    local NotifLayout = Instance.new("UIListLayout")
    NotifLayout.Parent = NotifHolder
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.Padding = UDim.new(0, 8)

    function Lib:Notification(Config)
        local Title, Text, Duration, Type = Config.Title or "Notificação", Config.Text or "", Config.Duration or 5, Config.Type or "Info"
        local TypeConfig = {
            Success = {Color = Color3.fromRGB(100, 255, 100), Icon = "rbxassetid://11419719540"},
            Error   = {Color = Color3.fromRGB(255, 80, 80),   Icon = "rbxassetid://11419713314"},
            Warning = {Color = Color3.fromRGB(255, 200, 50),  Icon = "rbxassetid://11419716952"},
            Info    = {Color = UIConfig.AccentColor,          Icon = "rbxassetid://11419715764"}
        }
        local SelectedType = TypeConfig[Type] or TypeConfig.Info

        local Frame = Instance.new("Frame"); Frame.Parent = NotifHolder; Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Frame.Size = UDim2.new(1, 0, 0, 0); Frame.BorderSizePixel = 0; Frame.ClipsDescendants = true; Frame.BackgroundTransparency = 0.1
        local Corner = Instance.new("UICorner"); Corner.CornerRadius = UDim.new(0, 8); Corner.Parent = Frame
        local Stroke = Instance.new("UIStroke"); Stroke.Color = SelectedType.Color; Stroke.Thickness = 1; Stroke.Transparency = 0.5; Stroke.Parent = Frame
        local IconImg = Instance.new("ImageLabel"); IconImg.Parent = Frame; IconImg.BackgroundTransparency = 1; IconImg.Position = UDim2.new(0, 10, 0, 10); IconImg.Size = UDim2.new(0, 24, 0, 24); IconImg.Image = SelectedType.Icon; IconImg.ImageColor3 = SelectedType.Color
        local T_Title = Instance.new("TextLabel"); T_Title.Parent = Frame; T_Title.BackgroundTransparency = 1; T_Title.Text = Title; T_Title.TextColor3 = SelectedType.Color; T_Title.Font = Enum.Font.GothamBold; T_Title.TextSize = 14; T_Title.Position = UDim2.new(0, 42, 0, 12); T_Title.Size = UDim2.new(1, -50, 0, 20); T_Title.TextXAlignment = 0
        local T_Text = Instance.new("TextLabel"); T_Text.Parent = Frame; T_Text.BackgroundTransparency = 1; T_Text.Text = Text; T_Text.TextColor3 = UIConfig.TextColor; T_Text.Font = Enum.Font.Gotham; T_Text.TextSize = 12; T_Text.Position = UDim2.new(0, 42, 0, 32); T_Text.Size = UDim2.new(1, -50, 0, 30); T_Text.TextXAlignment = 0; T_Text.TextWrapped = true
        local Bar = Instance.new("Frame"); Bar.Parent = Frame; Bar.BackgroundColor3 = SelectedType.Color; Bar.BorderSizePixel = 0; Bar.Size = UDim2.new(1, 0, 0, 2); Bar.Position = UDim2.new(0, 0, 1, -2)

        TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 70)}):Play()
        TweenService:Create(Bar, TweenInfo.new(Duration), {Size = UDim2.new(0, 0, 0, 2)}):Play()
        
        task.delay(Duration, function()
            local tw = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(1, 100, 0, 0), Transparency = 1}); tw:Play(); tw.Completed:Wait(); Frame:Destroy()
        end)
    end

    --// MAIN WINDOW //--
    function Lib:CreateWindow(Config)
        local OpenKey = Config.Keybind or Enum.KeyCode.RightControl
        local UI_Hidden = false

        -- Botão Abrir Móvel
        local OpenBtn = CreateInstance("ImageButton", {
            Parent = ScreenGui, Visible = false, BackgroundColor3 = UIConfig.SecondaryColor,
            Position = UDim2.new(0, 20, 0.5, 0), Size = UDim2.new(0, 45, 0, 45), AutoButtonColor = false,
            BackgroundTransparency = 0.2
        })
        CreateInstance("UICorner", {Parent = OpenBtn, CornerRadius = UDim.new(0, 10)})
        CreateInstance("UIStroke", {Parent = OpenBtn, Color = UIConfig.AccentColor, Thickness = 2})
        CreateInstance("ImageLabel", {Parent = OpenBtn, BackgroundTransparency = 1, Image = "rbxassetid://6031068390", Size = UDim2.new(0,28,0,28), Position = UDim2.new(0.5,-14,0.5,-14), ImageColor3 = UIConfig.AccentColor})
        MakeDraggable(OpenBtn, OpenBtn)

        -- Janela Principal
        local Main = CreateInstance("Frame", {
            Parent = ScreenGui, BackgroundColor3 = UIConfig.MainColor, Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(500, 360), AnchorPoint = Vector2.new(0.5, 0.5), ClipsDescendants = true,
            BackgroundTransparency = UIConfig.Transparency
        })
        CreateInstance("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
        CreateInstance("UIStroke", {Parent = Main, Color = UIConfig.StrokeColor, Thickness = 1})
        
        -- Topbar
        local Topbar = CreateInstance("Frame", {Parent = Main, BackgroundColor3 = Color3.fromRGB(30,30,30), Size = UDim2.new(1,0,0,38), BackgroundTransparency = 0.1})
        CreateInstance("UICorner", {Parent = Topbar, CornerRadius = UDim.new(0, 10)})
        
        -- Título
        local TitleLbl = CreateInstance("TextLabel", {Parent = Topbar, BackgroundTransparency = 1, Text = "  " .. (Config.Title or "Hub"), Size = UDim2.new(1,-90,1,0), Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = UIConfig.TextColor, TextXAlignment = 0})

        -- Botões da Topbar (Fechar e Search)
        local CloseBtn = CreateInstance("ImageButton", {Parent = Topbar, BackgroundTransparency = 1, Position = UDim2.new(1, -30, 0, 4), Size = UDim2.new(0, 26, 0, 26), Image = "rbxassetid://6031094678", ImageColor3 = Color3.fromRGB(255, 60, 60)})
        
        --== IMPLEMENTAÇÃO DA SEARCH BAR ==--
        local SearchBtn = CreateInstance("ImageButton", {Parent = Topbar, BackgroundTransparency = 1, Position = UDim2.new(1, -60, 0, 4), Size = UDim2.new(0, 26, 0, 26), Image = "rbxassetid://6031154871", ImageColor3 = Color3.fromRGB(200, 200, 200)})
        
        local SearchBarBG = CreateInstance("Frame", {Parent = Topbar, BackgroundColor3 = Color3.fromRGB(40,40,40), Position = UDim2.new(1, -60, 0, 4), Size = UDim2.new(0, 0, 0, 26), BackgroundTransparency = 0.2, ClipsDescendants = true, Visible = false})
        CreateInstance("UICorner", {Parent = SearchBarBG, CornerRadius = UDim.new(0, 5)})
        CreateInstance("UIStroke", {Parent = SearchBarBG, Color = UIConfig.StrokeColor, Thickness = 1})
        
        local SearchInput = CreateInstance("TextBox", {Parent = SearchBarBG, BackgroundTransparency = 1, Position = UDim2.new(0, 5, 0, 0), Size = UDim2.new(1, -10, 1, 0), Text = "", PlaceholderText = "Buscar...", Font = UIConfig.Font, TextSize = 13, TextColor3 = Color3.new(1,1,1), PlaceholderColor3 = Color3.new(0.6,0.6,0.6), TextXAlignment = 0})

        MakeDraggable(Main, Topbar)

        -- Lógica da Search Bar
        local SearchOpen = false
        local PageHolder -- Forward declaration para acesso no Search
        
        local function DoSearch(text)
            text = text:lower()
            -- Descobre a página ativa (ScrolingFrame que está visível no PageHolder)
            local ActivePage = nil
            for _, page in pairs(PageHolder:GetChildren()) do
                if page:IsA("ScrollingFrame") and page.Visible then
                    ActivePage = page
                    break
                end
            end
            
            if ActivePage then
                for _, item in pairs(ActivePage:GetChildren()) do
                    if item:IsA("Frame") or item:IsA("TextButton") then
                        -- Procura por Texto dentro dos itens (Normalmente Buttons e Toggles tem um TextLabel interno)
                        local label = item:FindFirstChild("TextLabel", true) -- Busca recursiva
                        if label then
                            if string.find(label.Text:lower(), text) then
                                item.Visible = true
                            else
                                item.Visible = false
                            end
                        end
                        -- Label Puro é um caso a parte
                         if item:IsA("Frame") and item:FindFirstChild("TextLabel") and not item:FindFirstChild("TextButton") then
                             local lbl = item:FindFirstChild("TextLabel")
                             if string.find(lbl.Text:lower(), text) then item.Visible = true else item.Visible = false end
                         end
                    end
                end
            end
        end

        SearchBtn.MouseButton1Click:Connect(function()
            SearchOpen = not SearchOpen
            if SearchOpen then
                SearchBarBG.Visible = true
                TweenService:Create(SearchBarBG, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 200, 0, 26), Position = UDim2.new(1, -270, 0, 4)}):Play()
                SearchInput:CaptureFocus()
            else
                TweenService:Create(SearchBarBG, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 0, 0, 26), Position = UDim2.new(1, -60, 0, 4)}):Play()
                task.delay(0.3, function() SearchBarBG.Visible = false end)
                SearchInput.Text = ""
                DoSearch("") -- Restaura visibilidade
            end
        end)
        
        SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
            DoSearch(SearchInput.Text)
        end)

        -- Lógica de Abrir/Fechar
        local function ToggleUI(State)
            UI_Hidden = not State
            Main.Visible = State
            OpenBtn.Visible = not State
        end

        CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)
        OpenBtn.MouseButton1Click:Connect(function() ToggleUI(true) end)

        UserInputService.InputBegan:Connect(function(input, gp)
            if not gp and input.KeyCode == OpenKey then
                ToggleUI(UI_Hidden)
            end
        end)

        -- Sidebar e Conteúdo
        local SidebarWidth = 105
        local ContentOffset = SidebarWidth + 15

        local TabHolder = CreateInstance("ScrollingFrame", {
            Parent = Main, BackgroundTransparency = 1, 
            Position = UDim2.new(0, 10, 0, 48), Size = UDim2.new(0, SidebarWidth, 1, -58), ScrollBarThickness = 0
        })
        CreateInstance("UIListLayout", {Parent = TabHolder, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
        
        PageHolder = CreateInstance("Frame", {
            Parent = Main, BackgroundTransparency = 1, 
            Position = UDim2.new(0, ContentOffset, 0, 48), Size = UDim2.new(1, -ContentOffset - 10, 1, -58), ClipsDescendants = true
        })

        local Tabs = {}
        local First = true

        function Tabs:CreateTab(Name)
            local TabBtn = CreateInstance("TextButton", {
                Parent = TabHolder, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,30), Text = "  "..Name, 
                Font = UIConfig.Font, TextSize = 13, TextColor3 = Color3.fromRGB(150,150,150), TextXAlignment = 0
            })
            local Indicator = CreateInstance("Frame", {
                Parent = TabBtn, BackgroundColor3 = UIConfig.AccentColor, Size = UDim2.new(0,2,0,16), Position = UDim2.new(0,0,0.5,-8), Transparency = 1
            })
            
            local Page = CreateInstance("ScrollingFrame", {
                Parent = PageHolder, Size = UDim2.new(1,0,1,0), Visible = false, BackgroundTransparency = 1, 
                ScrollBarThickness = 2, ScrollBarImageColor3 = UIConfig.AccentColor, 
                AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0)
            })
            CreateInstance("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)})
            CreateInstance("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 10), PaddingRight = UDim.new(0, 5), PaddingLeft = UDim.new(0, 10)})

            local function Activate()
                -- Resetar busca ao trocar de aba para evitar bugs visuais
                if SearchOpen then 
                   SearchInput.Text = "" 
                   DoSearch("")
                end

                for _,v in pairs(PageHolder:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
                for _,v in pairs(TabHolder:GetChildren()) do 
                    if v:IsA("TextButton") then 
                        TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150,150,150)}):Play()
                        TweenService:Create(v.Frame, TweenInfo.new(0.2), {Transparency = 1}):Play()
                    end
                end
                Page.Visible = true
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = UIConfig.TextColor}):Play()
                TweenService:Create(Indicator, TweenInfo.new(0.2), {Transparency = 0}):Play()
            end
            TabBtn.MouseButton1Click:Connect(Activate)
            if First then Activate(); First = false end

            local Elems = {}
            local Order = 0
            
            local function AddHover(Btn)
                Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = UIConfig.HoverColor}):Play() end)
                Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = UIConfig.SecondaryColor}):Play() end)
            end

            -- // COMPONENTES DA LIBRARY //
            function Elems:CreateLabel(Txt)
                Order += 1
                local Lbl = CreateInstance("Frame", {LayoutOrder = Order, Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,26)})
                CreateInstance("TextLabel", {Parent = Lbl, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = Txt, TextXAlignment = 0, Font = Enum.Font.GothamBold, TextColor3 = UIConfig.AccentColor, TextSize = 13})
                CreateInstance("Frame", {Parent = Lbl, BackgroundColor3 = UIConfig.AccentColor, Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,1,-2), Transparency = 0.6})
            end

            function Elems:CreateButton(Txt, Callback)
                Order += 1
                local Btn = CreateInstance("TextButton", {LayoutOrder = Order, Parent = Page, BackgroundColor3 = UIConfig.SecondaryColor, Size = UDim2.new(1,0,0,34), Text = "", AutoButtonColor = false, BackgroundTransparency = 0.1})
                CreateInstance("UICorner", {Parent = Btn, CornerRadius = UDim.new(0,6)}); CreateInstance("UIStroke", {Parent = Btn, Color = UIConfig.StrokeColor, Thickness = 1})
                CreateInstance("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Text = Txt, Size = UDim2.new(1,-10,1,0), Position = UDim2.new(0,10,0,0), TextXAlignment = 0, Font = UIConfig.Font, TextColor3 = UIConfig.TextColor, TextSize = 13})
                CreateInstance("ImageLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(1,-25,0.5,-9), Size = UDim2.new(0,18,0,18), Image = "rbxassetid://6031068390", ImageColor3 = Color3.new(0.8,0.8,0.8)})
                AddHover(Btn)
                Btn.MouseButton1Click:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(0.98,0,0,32)}):Play(); wait(0.1)
                    TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1,0,0,34)}):Play()
                    pcall(Callback)
                end)
            end

            function Elems:CreateToggle(Txt, Callback, Default)
                Order += 1
                local State = Default or false
                local Btn = CreateInstance("TextButton", {LayoutOrder = Order, Parent = Page, BackgroundColor3 = UIConfig.SecondaryColor, Size = UDim2.new(1,0,0,34), Text = "", AutoButtonColor = false, BackgroundTransparency = 0.1})
                CreateInstance("UICorner", {Parent = Btn, CornerRadius = UDim.new(0,6)}); CreateInstance("UIStroke", {Parent = Btn, Color = UIConfig.StrokeColor, Thickness = 1})
                CreateInstance("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Text = Txt, Size = UDim2.new(1,-50,1,0), Position = UDim2.new(0,10,0,0), TextXAlignment = 0, Font = UIConfig.Font, TextColor3 = UIConfig.TextColor, TextSize = 13})
                local CheckBG = CreateInstance("Frame", {Parent = Btn, BackgroundColor3 = (State and UIConfig.AccentColor or Color3.fromRGB(50,50,50)), Size = UDim2.new(0,36,0,18), Position = UDim2.new(1,-46,0.5,-9)})
                CreateInstance("UICorner", {Parent = CheckBG, CornerRadius = UDim.new(1,0)})
                local Dot = CreateInstance("Frame", {Parent = CheckBG, BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.new(0,14,0,14), Position = (State and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7))}); CreateInstance("UICorner", {Parent = Dot, CornerRadius = UDim.new(1,0)})
                AddHover(Btn)
                Btn.MouseButton1Click:Connect(function()
                    State = not State
                    TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = (State and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7))}):Play()
                    TweenService:Create(CheckBG, TweenInfo.new(0.2), {BackgroundColor3 = (State and UIConfig.AccentColor or Color3.fromRGB(50,50,50))}):Play()
                    pcall(Callback, State)
                end)
            end

            function Elems:CreateSlider(Txt, Min, Max, Default, Callback)
                Order += 1
                local Sld = CreateInstance("Frame", {LayoutOrder = Order, Parent = Page, BackgroundColor3 = UIConfig.SecondaryColor, Size = UDim2.new(1,0,0,45), BackgroundTransparency = 0.1})
                CreateInstance("UICorner", {Parent = Sld, CornerRadius = UDim.new(0,6)}); CreateInstance("UIStroke", {Parent = Sld, Color = UIConfig.StrokeColor, Thickness = 1})
                CreateInstance("TextLabel", {Parent = Sld, BackgroundTransparency = 1, Text = Txt, Size = UDim2.new(0.7,0,0,20), Position = UDim2.new(0,10,0,4), TextXAlignment = 0, Font = UIConfig.Font, TextColor3 = UIConfig.TextColor, TextSize = 13})
                local ValLbl = CreateInstance("TextLabel", {Parent = Sld, BackgroundTransparency = 1, Text = tostring(Default), Size = UDim2.new(0.3,-15,0,20), Position = UDim2.new(0.7,0,0,4), TextXAlignment = 1, Font = UIConfig.Font, TextColor3 = Color3.new(0.8,0.8,0.8), TextSize = 12})
                local BarBG = CreateInstance("Frame", {Parent = Sld, BackgroundColor3 = Color3.fromRGB(50,50,50), Size = UDim2.new(1,-20,0,4), Position = UDim2.new(0,10,0,30)}); CreateInstance("UICorner", {Parent = BarBG, CornerRadius = UDim.new(1,0)})
                local Fill = CreateInstance("Frame", {Parent = BarBG, BackgroundColor3 = UIConfig.AccentColor, Size = UDim2.new((Default-Min)/(Max-Min),0,1,0)}); CreateInstance("UICorner", {Parent = Fill, CornerRadius = UDim.new(1,0)})
                local Trigger = CreateInstance("TextButton", {Parent = BarBG, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = ""})
                local isDrag = false
                Trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then isDrag = true end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then isDrag = false end end)
                UserInputService.InputChanged:Connect(function(i)
                    if isDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        local scale = math.clamp((i.Position.X - BarBG.AbsolutePosition.X)/BarBG.AbsoluteSize.X, 0, 1)
                        local newVal = math.floor(Min + ((Max-Min)*scale))
                        ValLbl.Text = tostring(newVal)
                        TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(scale,0,1,0)}):Play()
                        pcall(Callback, newVal)
                    end
                end)
            end
            
            function Elems:CreateColorPicker(Txt, Default, Callback)
                Order += 1
                local Expanded = false
                local MinH = 34
                local MaxH = 140
                
                local CurColor = Default or Color3.fromRGB(255, 255, 255)
                local R, G, B = math.floor(CurColor.R*255), math.floor(CurColor.G*255), math.floor(CurColor.B*255)
                
                local Container = CreateInstance("Frame", {LayoutOrder = Order, Parent = Page, BackgroundColor3 = UIConfig.SecondaryColor, Size = UDim2.new(1,0,0,MinH), ClipsDescendants = true, BackgroundTransparency = 0.1})
                CreateInstance("UICorner", {Parent = Container, CornerRadius = UDim.new(0,6)}); CreateInstance("UIStroke", {Parent = Container, Color = UIConfig.StrokeColor, Thickness = 1})
                
                local HeaderBtn = CreateInstance("TextButton", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,MinH), Text = ""})
                CreateInstance("TextLabel", {Parent = HeaderBtn, BackgroundTransparency = 1, Text = Txt, Size = UDim2.new(1,-70,1,0), Position = UDim2.new(0,10,0,0), TextXAlignment = 0, Font = UIConfig.Font, TextColor3 = UIConfig.TextColor, TextSize = 13})
                local ColorPreview = CreateInstance("Frame", {Parent = HeaderBtn, BackgroundColor3 = CurColor, Size = UDim2.new(0,35,0,20), Position = UDim2.new(1,-45,0.5,-10)}); CreateInstance("UICorner", {Parent = ColorPreview, CornerRadius = UDim.new(0,4)}); CreateInstance("UIStroke", {Parent = ColorPreview, Color = Color3.fromRGB(80,80,80), Thickness = 1})
                
                local SlidersFrame = CreateInstance("Frame", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,MaxH-MinH), Position = UDim2.new(0,0,0,MinH)})
                
                local function UpdateColor()
                    CurColor = Color3.fromRGB(R, G, B)
                    TweenService:Create(ColorPreview, TweenInfo.new(0.1), {BackgroundColor3 = CurColor}):Play()
                    pcall(Callback, CurColor)
                end
                
                local function CreateRGBItem(Name, Col, MaxVal, YPos)
                    local Lab = CreateInstance("TextLabel", {Parent = SlidersFrame, BackgroundTransparency = 1, Text = Name, TextColor3 = Col, Position = UDim2.new(0,10,0,YPos), Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(0,20,0,20)})
                    local ValLab = CreateInstance("TextLabel", {Parent = SlidersFrame, BackgroundTransparency = 1, Text = tostring(MaxVal), TextColor3 = Color3.new(0.8,0.8,0.8), Position = UDim2.new(1,-30,0,YPos), Font = Enum.Font.Gotham, TextSize = 12, Size = UDim2.new(0,20,0,20)})
                    local BarBG = CreateInstance("Frame", {Parent = SlidersFrame, BackgroundColor3 = Color3.fromRGB(45,45,45), Position = UDim2.new(0,35,0,YPos+8), Size = UDim2.new(1,-70,0,4)}); CreateInstance("UICorner", {Parent = BarBG, CornerRadius = UDim.new(1,0)})
                    local Fill = CreateInstance("Frame", {Parent = BarBG, BackgroundColor3 = Col, Size = UDim2.new(MaxVal/255,0,1,0)}); CreateInstance("UICorner", {Parent = Fill, CornerRadius = UDim.new(1,0)})
                    local Trig = CreateInstance("TextButton", {Parent = BarBG, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = ""})
                    
                    local drag = false
                    Trig.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag = true end end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag = false end end)
                    UserInputService.InputChanged:Connect(function(i)
                        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                            local scale = math.clamp((i.Position.X - BarBG.AbsolutePosition.X)/BarBG.AbsoluteSize.X, 0, 1)
                            local val = math.floor(scale * 255)
                            ValLab.Text = tostring(val)
                            TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(scale,0,1,0)}):Play()
                            if Name == "R" then R = val elseif Name == "G" then G = val else B = val end
                            UpdateColor()
                        end
                    end)
                end
                
                CreateRGBItem("R", Color3.fromRGB(255,80,80), R, 10)
                CreateRGBItem("G", Color3.fromRGB(80,255,80), G, 40)
                CreateRGBItem("B", Color3.fromRGB(80,80,255), B, 70)
                
                HeaderBtn.MouseButton1Click:Connect(function()
                    Expanded = not Expanded
                    TweenService:Create(Container, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,0, Expanded and MaxH or MinH)}):Play()
                end)
            end

            function Elems:CreateDropdown(Txt, Options, Callback)
                Order += 1
                local Expanded = false
                local DropH = 34
                local Container = CreateInstance("Frame", {LayoutOrder = Order, Parent = Page, BackgroundColor3 = UIConfig.SecondaryColor, Size = UDim2.new(1,0,0,DropH), ClipsDescendants = true, BackgroundTransparency = 0.1})
                CreateInstance("UICorner", {Parent = Container, CornerRadius = UDim.new(0,6)}); CreateInstance("UIStroke", {Parent = Container, Color = UIConfig.StrokeColor, Thickness = 1})
                local HeadBtn = CreateInstance("TextButton", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,34), Text = ""})
                local Label = CreateInstance("TextLabel", {Parent = HeadBtn, BackgroundTransparency = 1, Text = Txt .. "...", Size = UDim2.new(1,-40,1,0), Position = UDim2.new(0,10,0,0), TextXAlignment = 0, Font = UIConfig.Font, TextColor3 = UIConfig.TextColor, TextSize = 13})
                local Arrow = CreateInstance("ImageLabel", {Parent = HeadBtn, BackgroundTransparency = 1, Image = "rbxassetid://6031091004", Size = UDim2.new(0,20,0,20), Position = UDim2.new(1,-30,0.5,-10), ImageColor3 = Color3.new(0.7,0.7,0.7)})
                local ListFrame = CreateInstance("Frame", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,0,34), ClipsDescendants = true})
                local ListLayout = CreateInstance("UIListLayout", {Parent = ListFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,2)})
                for _, opt in pairs(Options) do
                    local OptBtn = CreateInstance("TextButton", {Parent = ListFrame, BackgroundColor3 = Color3.fromRGB(40,40,40), Size = UDim2.new(1,-10,0,26), Text = opt, Font = UIConfig.Font, TextSize = 12, TextColor3 = Color3.new(0.9,0.9,0.9), BackgroundTransparency = 0.2})
                    CreateInstance("UICorner", {Parent = OptBtn, CornerRadius = UDim.new(0,4)})
                    OptBtn.MouseButton1Click:Connect(function()
                        Expanded = false
                        Label.Text = Txt .. ": " .. opt
                        pcall(Callback, opt)
                        TweenService:Create(Container, TweenInfo.new(0.2), {Size = UDim2.new(1,0,0,DropH)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    end)
                end
                HeadBtn.MouseButton1Click:Connect(function()
                    Expanded = not Expanded
                    local ContentSize = ListLayout.AbsoluteContentSize.Y + 40
                    TweenService:Create(Container, TweenInfo.new(0.2), {Size = UDim2.new(1,0,0, Expanded and ContentSize or DropH)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = Expanded and 180 or 0}):Play()
                    TweenService:Create(ListFrame, TweenInfo.new(0.2), {Size = UDim2.new(1,0,0, Expanded and (ContentSize-34) or 0)}):Play()
                end)
            end

            function Elems:CreateTextBox(Txt, Placeholder, Callback)
                Order += 1
                local BoxFrame = CreateInstance("Frame", {LayoutOrder = Order, Parent = Page, BackgroundColor3 = UIConfig.SecondaryColor, Size = UDim2.new(1,0,0,55), BackgroundTransparency = 0.1})
                CreateInstance("UICorner", {Parent = BoxFrame, CornerRadius = UDim.new(0,6)}); CreateInstance("UIStroke", {Parent = BoxFrame, Color = UIConfig.StrokeColor, Thickness = 1})
                CreateInstance("TextLabel", {Parent = BoxFrame, BackgroundTransparency = 1, Text = Txt, Size = UDim2.new(1,-10,0,20), Position = UDim2.new(0,10,0,4), TextXAlignment = 0, Font = UIConfig.Font, TextColor3 = UIConfig.TextColor, TextSize = 13})
                local InputBG = CreateInstance("Frame", {Parent = BoxFrame, BackgroundColor3 = Color3.fromRGB(25,25,25), Size = UDim2.new(1,-20,0,24), Position = UDim2.new(0,10,0,25), BackgroundTransparency = 0.2})
                CreateInstance("UICorner", {Parent = InputBG, CornerRadius = UDim.new(0,4)})
                CreateInstance("UIStroke", {Parent = InputBG, Color = Color3.fromRGB(60,60,60), Thickness = 1})
                local Input = CreateInstance("TextBox", {Parent = InputBG, BackgroundTransparency = 1, Size = UDim2.new(1,-10,1,0), Position = UDim2.new(0,5,0,0), Text = "", PlaceholderText = Placeholder, TextXAlignment = 0, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Color3.new(1,1,1), PlaceholderColor3 = Color3.fromRGB(150,150,150)})
                Input.FocusLost:Connect(function(enter) pcall(Callback, Input.Text) end)
            end

            function Elems:CreateKeybind(Txt, DefKey, Callback)
                Order += 1
                local Key = DefKey
                local BindFrame = CreateInstance("Frame", {LayoutOrder = Order, Parent = Page, BackgroundColor3 = UIConfig.SecondaryColor, Size = UDim2.new(1,0,0,34), BackgroundTransparency = 0.1})
                CreateInstance("UICorner", {Parent = BindFrame, CornerRadius = UDim.new(0,6)}); CreateInstance("UIStroke", {Parent = BindFrame, Color = UIConfig.StrokeColor, Thickness = 1})
                CreateInstance("TextLabel", {Parent = BindFrame, BackgroundTransparency = 1, Text = Txt, Size = UDim2.new(0.6,0,1,0), Position = UDim2.new(0,10,0,0), TextXAlignment = 0, Font = UIConfig.Font, TextColor3 = UIConfig.TextColor, TextSize = 13})
                local BindBtn = CreateInstance("TextButton", {Parent = BindFrame, BackgroundColor3 = Color3.fromRGB(50,50,50), Size = UDim2.new(0,80,0,22), Position = UDim2.new(1,-90,0.5,-11), Text = Key.Name, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(0.9,0.9,0.9), AutoButtonColor = false})
                CreateInstance("UICorner", {Parent = BindBtn, CornerRadius = UDim.new(0,4)})
                BindBtn.MouseButton1Click:Connect(function()
                    BindBtn.Text = "..."; BindBtn.TextColor3 = UIConfig.AccentColor
                    local input = UserInputService.InputBegan:Wait()
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        Key = input.KeyCode; BindBtn.Text = Key.Name; BindBtn.TextColor3 = Color3.new(0.9,0.9,0.9)
                        if Txt == "Menu Keybind" then OpenKey = Key end
                        pcall(Callback, Key)
                    else BindBtn.Text = Key.Name end
                end)
            end
            return Elems
        end
        return Tabs
    end
    return Lib
end)()