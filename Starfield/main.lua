function love.load()
	screenHeight = love.graphics.getHeight()
	screenWidth = love.graphics.getWidth()
	stars = createStars(800)
	speed = 0
	love.graphics.setBackgroundColor(0, 0, 0)
end

function love.draw()
	love.graphics.translate(screenWidth/2, screenHeight/2)
	for _, star in ipairs(stars) do
		drawStar(star)
	end
end

function love.update(dt)
	speed = (love.mouse.getX() / screenWidth) * 50
	for _, star in ipairs(stars) do
		star.pz = star.z
		star.z = star.z - speed
		if star.z < 1 then
			star.z = screenWidth
			star.x = math.random(-screenWidth, screenWidth)
			star.y = math.random(-screenHeight, screenHeight)
			star.pz = star.z
		end
	end
end

function createStar()
	star =  {
		x = math.random(-screenWidth, screenWidth),
		y = math.random(-screenHeight, screenHeight),
		z = math.random(0, screenWidth)
	}
	star.pz = star.z
	return star
end

function createStars(amount)
	stars = {}
	for i=1, amount do
		stars[i] = createStar()
	end
	return stars
end

function drawStar(star)
	love.graphics.setColor(255, 255, 255)
	local sx = (star.x / star.z) * screenWidth
	local sy = (star.y / star.z) * screenHeight
	local r = (screenWidth / star.z) % 64
	--love.graphics.ellipse("fill", sx, sy, r, r)	
	local px = (star.x / star.pz) * screenWidth
	local py = (star.y / star.pz) * screenHeight

	love.graphics.line(px, py, sx, sy)

end
