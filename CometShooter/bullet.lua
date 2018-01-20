local bullet = {}

function bullet.create(screen_width, screen_height)
	return {
		x = 0,
		y = 0,
		live = false,
		speed = 10,
		world_width = screen_width,
		world_height = screen_height
	}

end

function bullet.draw(bullet)
	if bullet.live then
		love.graphics.setColor(255, 255, 255)
		love.graphics.circle("fill", bullet.x, bullet.y, 2)
	end
end

function bullet.fire(bullet, ship)
	bullet.x = ship.x + 17
	bullet.y = ship.y
	bullet.live = true
end

function bullet.update(bullet)
	if bullet.live then
		bullet.x = bullet.x + bullet.speed
		if bullet.x > bullet.world_width + 2 then
			bullet.live = false
		end
	end
end

function bullet.collide(bullet, comet)
	if bullet.x > comet.x - comet.boundx and
		bullet.x < comet.x + comet.boundx and
		bullet.y > comet.y - comet.boundy and
		bullet.y < comet.y + comet.boundy then
		comet.live = false
		bullet.live = false
	end
end

return bullet
