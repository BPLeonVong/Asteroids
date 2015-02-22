SHIP = class("SHIP")

function SHIP:initialize(x,y)
    self.xPos = x
    self.yPos = y
    self.width = 40
    self.height = 20
    self.velocityX = 0
    self.velocityY = 0
    
    self.ShootTimer = 0
    self.CanShoot = false
    self.Group = ""
    self.angle = 0;
    
    self.Collider = Collider:addRectangle(self.xPos,self.yPos,self.width,self.height)
    self.img = love.graphics.newImage('gL2DAsteroidShip.png')
end

function SHIP:gDraw()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(self.img,self.xPos+self.width/2, self.yPos+self.height/2,self.angle,1,1,self.width/2,self.height/2)
end

function SHIP:gUpdate()
    self.Collider:move(self.velocityX,self.velocityY)
    local x,y = self.Collider:center()
    self.xPos = x-self.width/2
    self.yPos = y-self.height/2
    if self.velocityX>0 then 
        self.velocityX = self.velocityX - 0.01
    end
    if self.velocityY>0 then 
        self.velocityY = self.velocityY - 0.01
    end
    if self.velocityX > 3 then
        self.velocityX = 3
    end
    if self.velocityY > 3 then
        self.velocityY = 3
    end
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

function SHIP:Destroy()
    Collider:removeFromGroup(self.Group ,self.Collider)
    Collider:remove(self.Collider)
    self.xPos = nil
    self.yPos = nil
    self.width = nil
    self.height = nil
    self = nil
end

function SHIP:SetGroup(Group)
    self.Group = Group
    Collider:addToGroup(self.Group,self.Collider)
end

function SHIP:RemoveGroup()
    Collider:removeFromGroup(self.Group,self.Collider)
end