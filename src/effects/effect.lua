effects = {}

function effects:spawn(type, x, y, args)

    local effect = {}
    effect.x = x
    effect.y = y
    effect.rot = 0
    effect.dead = false
    effect.scaleX = 1
    effect.scaleY = 1
    effect.layer = 1
    effect.type = type

    if type == "slice" then
        effect.spriteSheet = sprites.effects.slice
        effect.width = 23
        effect.height = 39
        effect.grid = anim8.newGrid(23, 39, effect.spriteSheet:getWidth(), effect.spriteSheet:getHeight())
        effect.anim = anim8.newAnimation(effect.grid(1, 1), 0.12, function() effect.dead = true end)

        if player.dir == "down" then
            effect.x = effect.x + 1
            effect.y = effect.y + 13.5
            effect.rot = math.pi/2
        elseif player.dir == "up" then
            effect.x = effect.x - 1
            effect.y = effect.y - 9.5
            effect.rot = math.pi/-2
        elseif player.dir == "right" then
            effect.x = effect.x + 13.5
            effect.y = effect.y - 2
        elseif player.dir == "left" then
            effect.x = effect.x - 13.5
            effect.y = effect.y - 2
            effect.scaleX = -1
        end
    end

    if type == "explosion" then
        effect.spriteSheet = sprites.effects.explosion
        effect.width = 32
        effect.height = 32
        effect.scaleX = 1.25
        effect.scaleY = 1.25
        effect.grid = anim8.newGrid(32, 32, effect.spriteSheet:getWidth(), effect.spriteSheet:getHeight())
        effect.anim = anim8.newAnimation(effect.grid('1-6', 1), 0.08, function() effect.dead = true end)
    end

    if type == "scorch" then
        effect.sprite = sprites.effects.scorch
        effect.width = 32
        effect.height = 32
        effect.scaleX = 0.6
        effect.scaleY = 0.6
        effect.alpha = 0
        effect.timer = 2
        effect.layer = -1

        function effect:update(dt)
            --self.scaleX = self.scaleX - (dt/10)
            --self.alpha = self.timer / 2
            self.alpha = self.alpha - dt/2
            if self.alpha < -0.1 then
                self.alpha = 0.8
            end
        end

        function effect:draw()
            love.graphics.setColor(0.2, 0.2, 0.2, self.alpha)
            love.graphics.draw(self.sprite, self.x, self.y, nil, self.scaleX, nil, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
            love.graphics.setColor(1,1,1,1)
        end
    end

    if type == "arrowTrail" then
        effect.width = 6
        effect.height = 3
        effect.alpha = 0.2
        effect.timer = 0.6
        effect.layer = -1

        if args == "up" or args == "down" then
            effect.width = 3
            effect.height = 6
        end

        function effect:update(dt)
            self.alpha = self.alpha - dt
        end

        function effect:draw()
            love.graphics.setColor(1, 1, 1, self.alpha)
            love.graphics.rectangle("fill", self.x-(self.width/2), self.y-(self.height/2), self.width, self.height)
            love.graphics.setColor(1,1,1,1)
        end
    end

    if type:find("Death") then
        effect.alpha = 1
        effect.timer = 0.75
        effect.layer = -1

        function effect:update(dt)
            self.alpha = self.alpha - dt*1.5
        end
    end

    if type == "eyeDeath" then
        effect.sprite = sprites.enemies.eyeDead1

        if args and args.form == 2 then
            effect.sprite = sprites.enemies.eyeDead2
        elseif args and args.form == 3 then
            effect.sprite = sprites.enemies.eyeDead3
        end

        function effect:draw()
            love.graphics.setColor(1, 1, 1, self.alpha)
            love.graphics.draw(sprites.enemies.eyeShadow, self.x, self.y+7, nil, nil, nil, sprites.enemies.eyeShadow:getWidth()/2, sprites.enemies.eyeShadow:getHeight()/2)
            love.graphics.draw(self.sprite, self.x, self.y, nil, nil, nil, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
            love.graphics.setColor(1,1,1,1)
        end
    end

    if type == "batDeath" then
        effect.sprite = sprites.enemies.batDead
        effect.scaleX = args.scaleX

        function effect:draw()
            love.graphics.setColor(1, 1, 1, self.alpha)
            love.graphics.draw(sprites.enemies.shadow, self.x, self.y+7, nil, nil, nil, sprites.enemies.shadow:getWidth()/2, sprites.enemies.shadow:getHeight()/2)
            love.graphics.draw(self.sprite, self.x, self.y, nil, self.scaleX, 1, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
            love.graphics.setColor(1,1,1,1)
        end
    end

    if type == "batEntrance" then
        effect.spriteSheet = sprites.enemies.bat
        effect.width = 16
        effect.height = 16
        effect.scaleX = 1
        effect.scaleY = 1
        effect.alpha = 0
        if x > player:getX() then effect.scaleX = -1 end
        effect.grid = anim8.newGrid(16, 16, effect.spriteSheet:getWidth(), effect.spriteSheet:getHeight())
        effect.anim = anim8.newAnimation(effect.grid('1-2', 1), 1.08)
        effect.shadowX = effect.x
        effect.shadowY = effect.y+10

        local finalY = effect.y
        effect.y = effect.y - 24
        flux.to(effect, 0.3, {alpha = 1}):ease("sineout")
        flux.to(effect, 0.3, {y = finalY}):ease("sineout"):oncomplete(function() effect.dead = true spawnEnemy(effect.x-5.5, effect.y-4.5, "bat") end)

        function effect:draw()
            love.graphics.setColor(1,1,1,self.alpha)
            love.graphics.draw(sprites.enemies.shadow, self.shadowX, self.shadowY, nil, nil, nil, sprites.enemies.shadow:getWidth()/2, sprites.enemies.shadow:getHeight()/2)
            self.anim:draw(self.spriteSheet, self.x, self.y, self.rot, self.scaleX, self.scaleY, self.width/2, self.height/2)
        end
    end

    if type == "fuseSmoke" then
        effect.rad = 1
        effect.alpha = 0.2
        effect.timer = 0.75
        effect.sprite = sprites.effects.fuseSmoke
        effect.scaleX = 0.25
        
        -- Define the path that the smoke rises
        local vec = vector(0, -1)
        local pos = math.random()
        if pos > 0.5 then pos = 1 else pos = -1 end
        local mag = math.random()/4

        effect.vec = vec:rotateInplace(mag * pos)

        function effect:update(dt)
            local speed = 15
            self.x = self.x + (speed * self.vec.x * dt)
            self.y = self.y + (speed * self.vec.y * dt)
            self.scaleX = self.scaleX + (dt)
            self.alpha = self.timer / 0.75 * 0.2
        end

        function effect:draw()
            love.graphics.setColor(1, 1, 1, self.alpha)
            love.graphics.draw(self.sprite, self.x, self.y, nil, self.scaleX, nil, self.sprite:getWidth()/2, self.sprite:getHeight()/2)
            love.graphics.setColor(1,1,1,1)
        end
    end

    table.insert(effects, effect)

end

function effects:update(dt)
    for _,e in ipairs(effects) do
        if e.anim then
            e.anim:update(dt)
        end
        if e.timer then
            e.timer = e.timer - dt
            if e.timer < 0 then
                e.dead = true
                if e.type == "eyeDeath" then
                    spawnEnemyLoot(e.x, e.y)
                end
            end
        end
        if e.update then
            e:update(dt)
        end
    end

    local i = #effects
    while i > 0 do
        if effects[i].dead then
            table.remove(effects, i)
        end
        i = i - 1
    end
end

function effects:draw(layer)
    for _,e in ipairs(effects) do
        if e.layer == layer then
            if e.anim then
                if e.alpha then love.graphics.setColor(1,1,1,e.alpha) end
                e.anim:draw(e.spriteSheet, e.x, e.y, e.rot, e.scaleX, e.scaleY, e.width/2, e.height/2)
            end
            if e.draw then
                e:draw()
            end
        end
    end
end
