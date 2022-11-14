local Http = {};

local Raw = 'https://raw.githubusercontent.com/';
local Branch = '1e20/Cybin/main/';

function Http:Import(Directory, As)
    local Data = loadstring(game:HttpGet(Raw .. Branch .. Directory))();
    getgenv()[As] = Data;
    return Data;
end;

return Http;
