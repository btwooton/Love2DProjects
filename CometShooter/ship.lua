local ship = {}

function ship.create(screen_width, screen_height) 
	return {
		x = 20,
		y = screen_height/2,
		lives = 3,
		speed = 7,
		boundx = 6,
		boundy = 7,
		score = 0,
		world_height = screen_height,
		world_width = screen_width
	}
end

function ship.draw(ship)
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", ship.x, ship.y - 9, 10, 2)
	love.graphics.rectangle("fill", ship.x, ship.y + 9, 10, 2)

	love.graphics.setColor(0, 255, 0)
	love.graphics.polygon("fill", ship.x - 12, ship.y - 17,
	ship.x + 12, ship.y, ship.x - 12, ship.y + 17)

	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", ship.x - 12, ship.y - 2, 27, 4)
end

function ship.moveUp(ship)
	ship.y = ship.y - ship.speed
	if ship.y < 0 then
		ship.y = 0
	end
end

function ship.moveDown(ship)
	ship.y = ship.y + ship.speed
	if ship.y > ship.world_height then
		ship.y = ship.world_height
	end
end

function ship.moveLeft(ship)
	ship.x = ship.x - ship.speed
	if ship.x < 0 then
		ship.x = 0
	end
end

function ship.moveRight(ship)
	ship.x = ship.x + ship.speed
	if ship.x > 300 then
		ship.x = 300
	end
end


return ship
