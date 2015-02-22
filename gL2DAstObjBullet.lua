BULLET = class("BULLET")

function BULLET:initialize(x,y,xDir,yDir,origin)
    self.xPos = x
    self.yPos = y
    self.width = 10
    self.height = 10
    self.lifeTimer = 3
    self.xDirection = xDir
    self.yDirection = yDir
    self.Origin = origin
    self.Collider = Collider:addRectangle(self.xPos,self.yPos,self.width,self.height)
    Collider:addToGroup(self.Origin,self.Collider)
    self.img = love.graphics.newImage('gL2DAsteroidBullet.png')
end

function BULLET:gDraw()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(self.img,self.xPos+self.width/2, self.yPos+self.height/2,self.angle,1,1,self.width/2,self.height/2)
end

function BULLET:gUpdate(dt)
    self.lifeTimer = self.lifeTimer - dt
    self.Collider:move(self.xDirection,self.yDirection)
    local x,y = self.Collider:center()
    self.xPos = x-self.width/2
    self.yPos = y-self.height/2
end

function BULLET:Destroy()
    Collider:removeFromGroup(self.Origin ,self.Collider)
    Collider:remove(self.Collider)
    self.xPos = nil
    self.yPos = nil
    self.width = nil
    self.height = nil
    self = nil
end
