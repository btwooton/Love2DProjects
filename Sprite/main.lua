function love.load()
	
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	attackImageNum = 8
	walkImageNum = 10

	attackImages = {}
	walkImages = {}

	for i = 1, attackImageNum do
		attackImages[i] = love.graphics.newImage("png/male/Attack ("..i..").png")
	end

	for i = 1, walkImageNum do
		walkImages[i] = love.graphics.newImage("png/male/Walk ("..i..").png")
	end

	imageIndex = 1

	timeElapsed = 0

	currentImage = attackImages[imageIndex]
	walking = false

end

function love.draw()
	love.graphics.draw(currentImage, 5, 5, 0, 0.2)
end

function love.update(dt)
	timeElapsed = timeElapsed + dt

	if timeElapsed > 0.1 then
		timeElapsed = 0
		imageIndex = imageIndex + 1
		if walking then
			if imageIndex > 10 then
				imageIndex = 1
			end
			currentImage = walkImages[imageIndex]
		else
			if imageIndex > 8 then
				imageIndex = 1
			end
			currentImage = attackImages[imageIndex]
		end
	end

	if love.keyboard.isDown("right") then
		walking = true
	else
		walking = false
	end

end

