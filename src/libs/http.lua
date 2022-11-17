local Http = {};
Http.Directory = '1e20/Cybin/main/';
Http.__Host = 'https://raw.githubusercontent.com/';

function Http:Import(PaTh, As)
    local Data = loadstring(game:HttpGet(self.__Host .. self.Directory .. Directory))();
    if (As) then getgenv()[As] = Data; end;
    return Data;
end;

function Http:SetDirectory(Directory)
    self.Directory = Directory;
end; 

return Http;
