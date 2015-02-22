DEBRIS = class("DEBRIS")

function DEBRIS:initialize(x,y,xDir,yDir,origin, life)
    self.xPos = x
    self.yPos = y
    self.width = 60
    self.height = 60
    self.xDirection = xDir
    self.yDirection = yDir
    self.Origin = origin
    self.Life = life
    if self.Life == 1 then
        self.width = 30
        self.height = 30
    end
    self.Collider = Collider:addRectangle(self.xPos,self.yPos,self.width,self.height)
    Collider:addToGroup(self.Origin,self.Collider)
    self.img = love.graphics.newImage('gL2DAsteroidDebris.png')
end

function DEBRIS:gDraw()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(self.img,self.xPos, self.yPos,0,self.width/60,self.height/60)
end

function DEBRIS:gUpdate(dt)
    self.Collider:move(self.xDirection,self.yDirection)
    local x,y = self.Collider:center()
    self.xPos = x-self.width/2
    self.yPos = y-self.height/2
    local x,y = self.Collider:center()
    if x > 800 then
        self.Collider:moveTo(0,y)
    elseif x<0 then
        self.Collider:moveTo(800,y)
    end
    if y > 600 then
        self.Collider:moveTo(x,0)
    elseif y<0 then
        self.Collider:moveTo(x,600)
    end
end

function DEBRIS:Destroy()
    Collider:removeFromGroup(self.Origin ,self.Collider)
    Collider:remove(self.Collider)
    self.xPos = nil
    self.yPos = nil
    self.width = nil
    self.height = nil
    self = nil
end
