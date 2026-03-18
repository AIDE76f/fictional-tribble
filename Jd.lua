local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

if guiParent:FindFirstChild("CarScannerGUI") then
    guiParent.CarScannerGUI:Destroy()
end

--------------------------------------------------
-- 1. تصميم الواجهة (نفس التصميم الأنيق)
--------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CarScannerGUI"
screenGui.Parent = guiParent

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 250)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔍 معلومات أغلى سيارة"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 1, -100)
infoLabel.Position = UDim2.new(0, 10, 0, 50)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "جاري البحث العميق..."
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 16
infoLabel.TextWrapped = true
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 100, 0, 35)
closeBtn.Position = UDim2.new(0.5, -50, 1, -45)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "إغلاق"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

--------------------------------------------------
-- 2. منطق البحث الذكي (معدّل ومحسن)
--------------------------------------------------
local mostExpensiveCar = nil
local highestPrice = 0

print("--- بدء الفحص الجديد ---")

for _, object in pairs(workspace:GetDescendants()) do
    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") or object:IsA("BillboardGui") or object:IsA("SurfaceGui") then
        
        -- التأكد من أن الكائن يحتوي على خاصية Text
        pcall(function()
            local text = object.Text
            if text and text ~= "" and (string.find(text, "ريال") or string.find(text, "ر.س")) then
                
                -- تنظيف النص من الفواصل والمسافات
                local cleanText = string.gsub(text, ",", "")
                cleanText = string.gsub(cleanText, " ", "")
                
                -- البحث عن كل الأرقام الموجودة في النص واختيار الأكبر (لتجنب التقاط موديل السيارة بدلاً من السعر)
                local maxNumberInText = 0
                for numberString in string.gmatch(cleanText, "%d+") do
                    local num = tonumber(numberString)
                    if num > maxNumberInText then
                        maxNumberInText = num
                    end
                end
                
                -- إذا وجدنا رقماً منطقياً
                if maxNumberInText > 0 then
                    print("وجدت لوحة بسعر: " .. maxNumberInText .. " | النص الأصلي: " .. text)
                    
                    if maxNumberInText > highestPrice then
                        -- البحث عن المجسم الرئيسي (Model)
                        local parent = object.Parent
                        local carModel = nil
                        local levels = 0
                        
                        while parent and parent ~= workspace and levels < 20 do
                            if parent:IsA("Model") then
                                carModel = parent
                            end
                            parent = parent.Parent
                            levels = levels + 1
                        end
                        
                        -- إذا وجدنا المجسم نقوم بتحديث النتيجة
                        if carModel then
                            highestPrice = maxNumberInText
                            mostExpensiveCar = carModel
                            print("تم التحديث! السيارة الأغلى حالياً هي: " .. carModel.Name)
                        end
                    end
                end
            end
        end)
    end
end

--------------------------------------------------
-- 3. عرض النتائج
--------------------------------------------------
if mostExpensiveCar then
    local carName = mostExpensiveCar.Name
    local pos = mostExpensiveCar:GetPivot().Position
    local formattedPosition = string.format("X: %.1f | Y: %.1f | Z: %.1f", pos.X, pos.Y, pos.Z)
    
    infoLabel.Text = 
        "🚗 الاسم: " .. carName .. "\n\n" ..
        "💰 السعر: " .. tostring(highestPrice) .. " ريال\n\n" ..
        "📍 المكان:\n" .. formattedPosition
else
    infoLabel.Text = "❌ لم يتم العثور على أي بيانات.\nالرجاء الضغط على F9 لرؤية الـ Console لمعرفة المشكلة."
end
