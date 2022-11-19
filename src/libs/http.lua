local Http, __Http = {}, newproxy(true);
getmetatable(__Http).__index = Http;
getmetatable(__Http).__newindex = Http;
getmetatable(__Http).__namecall = Http;
Http.Directory = '1e20/Cybin/main/';
Http.Host = 'https://raw.githubusercontent.com/';

function Http:Import(Directory, As)
    local Data = loadstring(game:HttpGet(self.Host .. self.Directory .. Directory))();
    if (As) then getgenv()[As] = Data; end;
    return Data;
end;

function Http:SetData(Host, Directory)
    self.Directory = Directory;
    self.Host = Host;
end; 

return __Http;
