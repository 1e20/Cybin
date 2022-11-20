local UserInputService = game:GetService('UserInputService');
local HttpService = game:GetService('HttpService');

local Keyboard = {};
Keyboard.Binds = {};

Keyboard.Letters = 'abcdefghijklmnopqrstuvwxyz';
Keyboard.Numbers = '1234567890';
Keyboard.Symbols = [[!@#$%^&*()_+,<.>/?'"[]{}`]];

--[[@Keyboard:Bind()

local Bind = Keyboard:Bind({
    Name = 'Bind';
    Key = 'F';
    Type = 1; -- (1 == Down) (0 == Up)
    Callback = function(Bool)
        print(Bool)
    end; 
})]]
function Keyboard:Bind(Data) -- Binds to a Callback and a Toggle
    local Bind = {
        Debug = Data.Debug or false;
        Name = Data.Name;
        Key = (type(Data.Key) == 'string' and Enum.KeyCode[Data.Key]) or Data.Key;
        Index = 1; -- only for multi binds 

        Type = Data.Type or 1;
        BoolType = Data.BoolType or 1; 

        Bool = Data.DefaultBool or false;
        Callback = Data.Callback;
    };

    function Bind:BoolToggle()
        if (Type == self.BoolType) then self.Bool = not self.Bool end;
    end; 

    function Bind:Invoke(Input, Type)
        if (self.Debug) then warn(('Bind [%s] Invoked'):format(self.Name)) end;

        if (type(self.Key) == 'table' and self.Key[Bind.Index] == Input.KeyCode.Name) then
            if (Bind.Index == #Bind.Key) then 
                self:BoolToggle(); self.Callback(self.Bool);
                Bind.Index = 1;
                return;
            end; 
            Bind.Index = Bind.Index + 1;
        elseif (typeof(self.Key) == 'EnumItem' and Type == self.Type and self.Callback) then 
            self:BoolToggle();
            self.Callback(self.Bool)
        end; 
    end; 

    function Bind:Disconnect()
        self.Binds[self.Name] = nil;
    end;

    self.Binds[Data.Name] = Bind;
    return Bind;
end;

function Keyboard:LoadBindData(BindData)
    if (typeof(BindData) == 'string') then -- json
        BindData = HttpService:JSONDecode(BindData);
    end; 

    for Name, Bind in next, BindData do 
        self.Binds[Name] = Bind;
    end; 
end;

function Keyboard:GetBindData(Encode)
    return HttpService:JSONEncode(Keyboard.Binds);
end;

-- Listeners 
Keyboard.KeyDownListener = UserInputService.InputBegan:Connect(function(Input)
    for Name, Bind in next, Keyboard.Binds do 
        if (type(Bind.Key) ~= 'table' and Input.KeyCode ~= Bind.Key) then continue elseif (type(Bind.Key) == 'table') then Bind:Invoke(Input, 1); end; 
        Bind:Invoke(Input, 1);
    end; 
end);

Keyboard.KeyUpListener = UserInputService.InputEnded:Connect(function(Input)
    for Name, Bind in next, Keyboard.Binds do 
        if (type(Bind.Key) ~= 'table' and Input.KeyCode ~= Bind.Key) then continue elseif (type(Bind.Key) == 'table') then Bind:Invoke(Input, 0); end; 
        Bind:Invoke(Input, 0);
    end; 
end);

return Keyboard;
