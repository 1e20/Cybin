local UserInputService = game:GetService('UserInputService');
local Vector2 = Vector2.new;
local Sleep = task.wait;

local Mouse, __Mouse = {}, newproxy(true);
getmetatable(__Mouse).__index = Mouse;
getmetatable(__Mouse).__namecall = Mouse;
Mouse.Position = UserInputService:GetMouseLocation();

function Mouse:Move(Position, Step) Step = Step or 1
    mousemoverel((Position.X - self.Position.X) / Step, (Position.Y - self.Position.Y) / Step);
end;

-- // Spring
Mouse.Spring = {
    TargetPosition = Vector2(0, 0);
    Position = Vector2(0, 0);
    VelocityX = 0;
    VelocityY = 0;
    Tension = 0.05;
    Dampening = 0.1; 
}

function Mouse.Spring:Update()
    local Difference = (self.TargetPosition - self.Position)
    self.VelocityX = (self.VelocityX + self.Tension * Difference.X - self.VelocityX * self.Dampening)
    self.VelocityY = (self.VelocityY + self.Tension * Difference.Y - self.VelocityY * self.Dampening)
    self.Position = Vector2(self.Position.X + self.VelocityX, self.Position.Y + self.VelocityY)
end; 

function Mouse.Spring:Move(Position, Step) Step = Step or 1
    self.TargetPosition = Position;
    self.Position = Mouse.Position;
    self:Update();

    mousemoverel(
        (self.Position.X - Mouse.Position.X) / Step,
        (self.Position.Y - Mouse.Position.Y) / Step
    );
end; 

-- Listeners
Mouse.ChangedListener = UserInputService.InputChanged:Connect(function(Input)
    if (Input.UserInputType == Enum.UserInputType.MouseMovement) then 
        Mouse.Position = UserInputService:GetMouseLocation();
    end; 
end);

return __Mouse;
