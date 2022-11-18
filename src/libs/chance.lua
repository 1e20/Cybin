local Chance, __Chance = {}, newproxy(true);
getmetatable(__Chance).__index = Chance;
Chance.Sleep = task.wait;

function Chance:PercentChance(Percent, Min, Max)
    local Random = Random.new(); 
    return (Random:NextNumber((Min or 0), (Max or 100)) < Percent);
end;

function Chance:WeightedChance(Inputs, Min)
    local Random = Random.new();

    local Sum = 0;
    for _, Input in next, Inputs do Sum = Sum + Input.Bias; end; 

    local Weight = Random:NextNumber((Min or 0), Sum);
    table.sort(Inputs, function(a, b) return (a.Bias > b.Bias) end);
    for _, Input in next, Inputs do 
        Sum = Sum - Input.Bias; 
        if (Weight > Sum) then return Input end;
    end;
end; 

function Chance:Rotater(Data)
    local Rotater = {};
    Rotater.Inputs = Data.Inputs; 
    Rotater.Value = self:WeightedChance(Rotater.Inputs);
    Rotater.Delay = Data.Delay or 0.1;

    coroutine.wrap(function()
        while true do 
            if (Rotater.__Destroyed) then coroutine.yield(); break; end;
            Rotater.Value = self:WeightedChance(Rotater.Inputs);
            self:Sleep(Rotater.Delay);
        end; 
    end)();

    return Rotater;
end; 

return __Chance;
