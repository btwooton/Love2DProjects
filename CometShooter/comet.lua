local comet = {}
	
function comet.create(screen_width, screen_height)
	return {
		x = 0,
		y = 0,
		live = false,
		boundx = 19,
		boundy = 19,
		speed = 5,
		world_width = screen_width,
		world_height = screen_height
	}

end

function comet.draw(comet)
	if comet.live then
		love.graphics.setColor(255, 0, 0)
		love.graphics.circle("fill", comet.x, comet.y, 20)
	end
end

function comet.start(comet)
	if not comet.live then
		if math.random(0, 500) == 0 then
			comet.live = true
			comet.x = comet.world_width
			comet.y = math.random(30, comet.world_height - 60)
		end
	end
end

function comet.update(comet)
	if comet.live then
		comet.x = comet.x - comet.speed
		if comet.x < 0 then
			comet.live = false
		end
	end
end

function comet.collide(comet, ship)
	if comet.live then
		if comet.x - comet.boundx < ship.x + ship.boundx and
			comet.x + comet.boundx > ship.x - ship.boundx and
			comet.y + comet.boundy > ship.y - ship.boundy and
			comet.y - comet.boundy < ship.y + ship.boundy then
			comet.live = false
			ship.lives = ship.lives - 1
			ship.x = 20
			ship.y = ship.world_height/2
		end
	end
end

return comet
