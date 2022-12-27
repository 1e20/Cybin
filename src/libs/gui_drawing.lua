local COREGUI = game:GetService('CoreGui'); 
local INSTANCE = Instance.new;
local UDIM = UDim2.fromOffset;
local RGB = Color3.fromRGB;
local VECTOR2 = Vector2.new;
local CAMERA = workspace.CurrentCamera;

local Drawing = {};
Drawing.Canvas = Instance.new('ScreenGui', COREGUI); 

Drawing.Classes = {'Square'; 'Line'};

local function CreateInstance(Class, Properties)
    local Object = Instance.new(Class); 
    if (not Properties) then return Object; end; 
    for property, value in next, Properties do 
        Object[property] = value; 
    end;    
    return Object;
end; 

local Structs = {};

function Structs.Line()
    local Line = setmetatable({
        Instance = CreateInstance('Frame', {Parent = Drawing.Canvas; AnchorPoint = VECTOR2(0.5, 0.5)});
        Properties = {Thickness = 1};
    }, {
        __newindex = function(self, key, value)
            if (key == 'From') then 
                self.Properties[key] = VECTOR2(value.X, value.Y - 36);
                if (self.Properties.To) then 
                    local Difference = (self.Properties.To - value);
                    self.Instance.Size = UDim2.new(0, Difference.Magnitude, 0, self.Properties.Thickness);
                    self.Instance.Position = UDim2.new(0, (value.X + self.Properties.To.X) / 2, 0, (value.Y + self.Properties.To.Y) / 2);
                    self.Instance.Rotation = math.atan2(self.Properties.To.Y - value.Y , self.Properties.To.X - value.X) * (180 / math.pi);
                end;
            elseif (key == 'To') then 
                value = VECTOR2(value.X, value.Y - 36);
                local Difference = (value - self.Properties.From);
                self.Instance.Size = UDim2.new(0, Difference.Magnitude, 0, self.Properties.Thickness);
                self.Instance.Position = UDim2.new(0, (self.Properties.From.X + value.X) / 2, 0, (self.Properties.From.Y + value.Y) / 2);
                self.Instance.Rotation = math.atan2(value.Y - self.Properties.From.Y , value.X - self.Properties.From.X) * (180 / math.pi);
            elseif (key == 'Transparency') then 
                self.Instance.Transparency = (1 - value);
            else 
                self.Instance[key] = value;
            end; 

            self.Properties[key] = value;
        end; 
    });

    return Line;
end;

function Structs.Square()
    local Square = setmetatable({
        Instance = CreateInstance('Frame', {Parent = Drawing.Canvas});
        Properties = {Color = RGB(255, 255, 255)};
    }, {
        __newindex = function(self, key, value)
            if (key == 'Size' or key == 'Position') then 
                self.Instance[key] = UDIM(value.X, value.Y);
            elseif (key == 'Filled') then 
                if (not value) then 
                    rawset(self, 'Stroke', CreateInstance('UIStroke', {Parent = self.Instance; Color = self.Instance.BackgroundColor3}));
                    self.Instance.BackgroundTransparency = 1;
                else
                    Stroke:Destroy(); 
                    self.Stroke = nil; 
                    self.Instance.BackgroundTransparency = (self.Properties.Transparency or 0);
                end;
            elseif (key == 'Color' and not self.Filled) then 
                Stroke.Color = value;
            elseif (key == 'Transparency' and not self.Filled) then 
                Stroke.Transparency = (1 - value);
            elseif (key == 'Transparency') then 
                self.Instance.Transparency = (1 - value);
            else 
                self.Instance[key] = value;
            end; 

            self.Properties[key] = value;
        end; 
    });

    return Square;
end; 

function Drawing.new(Class, Properties)
    assert(table.find(Drawing.Classes, Class), 'Drawing Error: Invalid class');
    return Structs[Class]();
end; 

return Drawing;
