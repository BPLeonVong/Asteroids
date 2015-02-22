HC = require "HardonCollider"
require 'middleclass'
require 'gL2DAstStateGame'
require 'gL2DAstObjShip'
require 'gL2DAstObjBullet'
require 'gL2DAstObjDebris'

function on_collide(dt,shape_a,shape_b)
    Game:gCollision(dt,shape_a,shape_b)
end

function love.load()
    Collider = HC(100,on_collide)
    GameStart = false
end

function love.draw()
    if GameStart then
        Game:gDraw()
    else
        love.graphics.setColor(255,255,255)
        love.graphics.print("Asteroids",350,280)
        love.graphics.print("Press Return/Enter to Start",350,300)
        love.graphics.print("Asteroids or ESC to Quit",350,330)
    end
end

function love.update(dt)
    Collider:update(dt)
    
    if GameStart then
        Game:gUpdate(dt)
    end
end

function love.keypressed(key)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if not GameStart and love.keyboard.isDown("return") then
        Game = GAME:new()
        GameStart = true
    end
end