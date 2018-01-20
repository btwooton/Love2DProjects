local ship = require "ship"
local bullet = require "bullet"
local comet = require "comet"

function love.load()
	math.randomseed(os.time())
	love.window.setMode(800, 400)
	local screen_width = love.graphics.getWidth()
	local screen_height = love.graphics.getHeight()
	love.graphics.setBackgroundColor(0, 0, 0)
	
	player = ship.create(screen_width, screen_height)
	
	local num_bullets = 5
	bullets = {}
	for i=1, num_bullets do
		bullets[i] = bullet.create(screen_width, screen_height)
	end

	local num_comets = 10
	comets = {}

	for i=1, num_comets do
		comets[i] = comet.create(screen_width, screen_height)
	end
end

function love.draw()
	ship.draw(player)
	for _, b in ipairs(bullets) do
		bullet.draw(b)
	end

	for _, c in ipairs(comets) do
		comet.draw(c)
	end
end

function love.update(dt)
	if love.keyboard.isDown("left") then
		ship.moveLeft(player)
	end

	if love.keyboard.isDown("right") then
		ship.moveRight(player)
	end

	if love.keyboard.isDown("up") then
		ship.moveUp(player)
	end

	if love.keyboard.isDown("down") then
		ship.moveDown(player)
	end

	for _, b in ipairs(bullets) do
		bullet.update(b)
	end

	for _, c in ipairs(comets) do
		comet.start(c)
	end

	for _, c in ipairs(comets) do
		comet.update(c)
		comet.collide(c, player)
	end

	for _, b in ipairs(bullets) do
		if b.live then
			for _, c in ipairs(comets) do
				if c.live then
					bullet.collide(b, c)
				end
			end
		end
	end

end

function love.keypressed(key, scancode, isrepeat)
	if key == "space" and not isrepeat then
		for _, b in ipairs(bullets) do
			if not b.live then
				bullet.fire(b, player)
				break
			end
		end
	end
end
