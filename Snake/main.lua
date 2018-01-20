function love.load()
	math.randomseed(os.time())
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	cellWidth = screenWidth/50
	cellHeight = screenHeight/50
	love.graphics.setBackgroundColor(0, 0, 0)
	s = createSnake()
	food = createFood(getXLocation(), getYLocation())
end

function love.draw()
	drawSnake(s)
	drawFood(food)
end

function love.update(dt)
	
	if dt < 1/10 then
		love.timer.sleep(1/10 - dt)
	end

	updateSnake(s)

	if love.keyboard.isDown("up") then
		s.xSpeed = 0
		s.ySpeed = -1
	end
	if love.keyboard.isDown("left") then
		s.xSpeed = -1
		s.ySpeed = 0
	end
	if love.keyboard.isDown("right") then
		s.xSpeed = 1
		s.ySpeed = 0
	end
	if love.keyboard.isDown("down") then
		s.xSpeed = 0
		s.ySpeed = 1
	end

	if s.xSpeed == -1 and s.x == 0 then
		s.x = screenWidth
	end
	if s.xSpeed == 1 and s.x == screenWidth then
		s.x = 0
	end
	if s.ySpeed == -1 and s.y == 0 then
		s.y = screenHeight
	end
	if s.ySpeed == 1 and s.y == screenHeight then
		s.y = 0
	end

	if eat(s, food) then
		s.total = s.total + 1
		food = createFood(getXLocation(), getYLocation())
	end
	death(s)
end

function createSnake()
	return {
		x = 0,
		y = 0,
		xSpeed = 1,
		ySpeed = 0,
		total = 0,
		tail = {}
	}
end

function createFood(posX, posY)
	return {
		x = posX,
		y = posY
	}
end

function updateSnake(snake)
	for i=1, table.getn(snake.tail) - 1 do
		snake.tail[i] = snake.tail[i + 1]
	end
	snake.tail[snake.total] = {x = snake.x, y = snake.y}
	snake.x = snake.x + snake.xSpeed*cellWidth
	snake.y = snake.y + snake.ySpeed*cellHeight
end

function drawSnake(snake)
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill", snake.x, snake.y, cellWidth, cellHeight)
	for _, cell in ipairs(snake.tail) do
		love.graphics.rectangle("fill", cell.x, cell.y, cellWidth, cellHeight)
	end
end

function drawFood(food)
	love.graphics.setColor(255, 0, 100)
	love.graphics.rectangle("fill", food.x, food.y, cellWidth, cellHeight)
end

function getXLocation()
	local column = math.random(0, 49)
	local result = column * cellWidth
	return result
end

function getYLocation()
	local row = math.random(0, 49)
	local result = row * cellHeight
	return result
end

function eat(snake, food)
	local xDelta = (food.x - snake.x)^2
	local yDelta = (food.y - snake.y)^2
	local distance = math.sqrt(xDelta + yDelta)
	if distance < 4 then
		return true
	else
		return false
	end
end

function death(snake)
	local xDelta
	local yDelta
	local distance
	for _, cell in ipairs(snake.tail) do
		xDelta = (cell.x - snake.x)^2
		yDelta = (cell.y - snake.y)^2
		distance = math.sqrt(xDelta + yDelta)
		if distance < 1 then
			snake.total = 0
			snake.tail = {}
		end
	end
end
