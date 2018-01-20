function love.load()
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	balls = {}
	createBalls(100)
	
	-- variables responsible for the physics of our balls interaction
	gravity = 1
	airFriction = 0.0001
	friction = 0.1


	love.graphics.setBackgroundColor(255, 255, 255)
end

function love.draw()
	for _, ball in ipairs(balls) do
		drawBall(ball)
	end
end

function love.update(dt)
	applyGravity()
	keepInScreen()
end

function drawBall(ball) 
	love.graphics.setColor(ball.colors[1], ball.colors[2], ball.colors[3])
	love.graphics.circle("fill", ball.x, ball.y, ball.size)
end

function createBall(ballX, ballY, ballSize) 
	return {
		x = ballX,
		y = ballY,
		size = ballSize,
		colors = { 
			math.floor(math.random()*255),
			math.floor(math.random()*255),
			math.floor(math.random()*255)
		},
		speedVert = 0
	}
end

function createBalls(amount)
	for i=1, amount do
		balls[i] = createBall(math.random()*screenWidth,
		math.random()*screenHeight/4, 15)
	end
end

function applyGravity()
	for _, ball in ipairs(balls) do
		ball.speedVert = ball.speedVert + gravity
		ball.y = ball.y + ball.speedVert
		ball.speedVert = ball.speedVert - ball.speedVert * airFriction
	end
end

function makeBounceBottom(ballIndex, surface)
	balls[ballIndex].y = surface - balls[ballIndex].size/2
	balls[ballIndex].speedVert = -balls[ballIndex].speedVert
	balls[ballIndex].speedVert = 
		balls[ballIndex].speedVert - balls[ballIndex].speedVert * friction
end

function makeBounceTop(ballIndex, surface)
	balls[ballIndex].y = surface + balls[ballIndex].size/2
	balls[ballIndex].speedVert = -balls[ballIndex].speedVert
	balls[ballIndex].speedVert =
		balls[ballIndex].speedVert - balls[ballIndex].speedVert * friction
end

function keepInScreen()
	for ballIndex, ball in ipairs(balls) do
		if ball.y + ball.size/2 > screenHeight then
			makeBounceBottom(ballIndex, screenHeight)
		end

		if ball.y - ball.size/2 < 0 then
			makeBounceTop(ballIndex, 0)
		end

	end
end
	
