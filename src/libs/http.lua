local Http = {};

local Root = 'https://raw.githubusercontent.com/';
local Branch = '1e20/Cybin/main/';

function Http:Import(Directory, As)
    local Data = loadstring(game:HttpGet(Root .. Branch .. Directory))();
    getgenv()[As] = Data;
    return Data;
end;

return Http;
