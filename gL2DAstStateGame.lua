class = require "middleclass"

GAME = class("GAME")

--to do: art

function GAME:initialize()
    self.gShip = SHIP:new(400,300)
    self.gShip:SetGroup("SHIP")
    self.gBulletArray = {}
    self.gDebrisArray = {}
    self.SpawnRate =  7
    self.spawnTimer = 4
    self.txtScore = 0
    self.txtLife = 5
end

function GAME:gDraw()
    for a, bullet in ipairs(self.gBulletArray)do
        bullet:gDraw()
    end
    for a, debris in ipairs(self.gDebrisArray)do
        debris:gDraw()
    end

    self.gShip:gDraw()
    
    love.graphics.setColor(255,0,255)
    love.graphics.print("Score: "..self.txtScore ,400,10)
    love.graphics.print("Life: "..self.txtLife ,500,10)
end

function GAME:gUpdate(dt)
    
    self.spawnTimer = self.spawnTimer + dt
    
    if self.spawnTimer >= self.SpawnRate then
        local SpawnPoints = {{0,0},{400,0},{800,0},{0,300},{800,300},{0,600},{400,600},{800,600}}
        local index = math.random(1,8)
        local SpawnPoints = SpawnPoints[index]
        table.insert(self.gDebrisArray,DEBRIS:new(SpawnPoints[1],SpawnPoints[2], math.random(-10,10)/10,math.random(-10,10)/10,"ASTEROID",2))
        self.spawnTimer = 0
    end
    
    if self.gShip.ShootTimer < 1 then
        self.gShip.ShootTimer = self.gShip.ShootTimer + dt
    else
        self.gShip.CanShoot = true
    end
    
    for a, bullet in ipairs(self.gBulletArray)do
        bullet:gUpdate(dt)
    end
    
    for a, debris in ipairs(self.gDebrisArray)do
        debris:gUpdate(dt)
    end
    
    self.gShip:gUpdate()
    self:CheckKeyPress()
end

function GAME:gCollision(dt,shapeA,shapeB)
    
    if shapeA == self.gShip.Collider or shapeB == self.gShip.Collider then
        if self.txtLife == 1 then
            Collider:clear() 
            GameStart = false
        else 
            for a, debris in ipairs(self.gDebrisArray)do
                if shapeA == debris.Collider or shapeB == debris.Collider then
                    debris:Destroy()
                    table.remove(self.gDebrisArray,a)
                    self.txtLife = self.txtLife - 1
                    return
                end
            end
        end
        return
    else
        for a, bullet in ipairs(self.gBulletArray)do
            if shapeA == bullet.Collider or shapeB == bullet.Collider then
                bullet:Destroy()
                table.remove(self.gBulletArray,a)
                for a, debris in ipairs(self.gDebrisArray)do
                    if shapeA == debris.Collider or shapeB == debris.Collider then
                        self.txtScore = self.txtScore + debris.Life*50
                        local x,y = debris.Collider:center()
                        local xDir = debris.xDirection
                        local yDir = debris.yDirection
                        debris:Destroy()
                        table.remove(self.gDebrisArray,a)
                        if debris.Life == 2 then
                            table.insert(self.gDebrisArray,DEBRIS:new(x,y,xDir+math.random(-2,2),yDir+math.random(-2,2),"ASTEROID",1))
                            table.insert(self.gDebrisArray,DEBRIS:new(x,y,xDir+math.random(-2,2),yDir+math.random(-2,2),"ASTEROID",1))
                        end
                        return
                    end
                end
            end
        end
    end
end

function GAME:CheckKeyPress()
    if love.keyboard.isDown('w') then
        local x,y = self.gShip.Collider:center()
        self.gShip.velocityX = 2* math.cos(self.gShip.Collider:rotation())
        self.gShip.velocityY = 2* math.sin(self.gShip.Collider:rotation())
    end
    if love.keyboard.isDown('a') then
        self.gShip.Collider:rotate(-math.pi/100)
        self.gShip.angle = self.gShip.angle-math.pi/100
    end
    if love.keyboard.isDown('s') then
        if self.gShip.CanShoot then
            local x,y = self.gShip.Collider:center()
            rotationXPoints = math.cos(self.gShip.Collider:rotation())
            rotationYPoints = math.sin(self.gShip.Collider:rotation())
            table.insert(self.gBulletArray,BULLET:new(x,y,3*rotationXPoints,3*rotationYPoints,"SHIP"))
            self.gShip.CanShoot = false
            self.gShip.ShootTimer = 0
        end
    end
    if love.keyboard.isDown('d') then
        self.gShip.Collider:rotate(math.pi/100)
        self.gShip.angle = self.gShip.angle+math.pi/100
    end
end