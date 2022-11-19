local Stopwatch, __Stopwatch = {}, newproxy(true); 
getmetatable(__Stopwatch).__index = Stopwatch;
Stopwatch.Tick = tick; 

function Stopwatch:StressCall(FuncData)
    local Data = {
        Calls = FuncData.Calls or 1000;
        Times = {};
    };

    for i = 1, Data.Calls do 
        local Time = self:Tick();
        table.insert(Data.Times, self:Tick() - Time); 
    end;

    local Sum = 0; 
    for _, t in next, Data.Times do 
        Sum = Sum + t; 
    end; 
    Data.Average = (Sum / Data.Calls);

    return Data;
end; 

return __Stopwatch;

