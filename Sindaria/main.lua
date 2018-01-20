function love.load()
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	foxfire = {}
	foxfireShield = {}
	foxfireSword = {}

	for i=0, 6 do
		local imageString = "assets/sprites/Foxfire/sprite_foxfire"
		imageString = imageString..i..".png"
		foxfire[i] = love.graphics.newImage(imageString)

		imageString = "assets/sprites/Foxfire/shield_foxfire"
		imageString = imageString..i..".png"
		foxfireShield[i] = love.graphics.newImage(imageString)

		imageString = "assets/sprites/Foxfire/sword_foxfire"
		imageString = imageString..i..".png"
		foxfireSword[i] = love.graphics.newImage(imageString)
	end

	currentImage = 0
	currentDuration = 0

	hasShield = false
	hasSword = false
end

function love.update(dt)
	currentDuration = currentDuration + dt
	if currentDuration > 0.1 then
		currentDuration = 0
		currentImage = currentImage + 1
		if currentImage > 6 then
			currentImage = 0
		end
	end

	if love.keyboard.isDown("s") then
		hasShield = true
	else
		hasShield = false
	end

	if love.keyboard.isDown("w") then
		hasSword = true
	else
		hasSword = false
	end
end

function love.draw()
	if hasShield then
		love.graphics.draw(foxfireShield[currentImage], screenWidth/2, screenHeight/2, 0, 3)
	elseif hasSword then
		love.graphics.draw(foxfireSword[currentImage], screenWidth/2, screenHeight/2, 0, 3)
	else
		love.graphics.draw(foxfire[currentImage], screenWidth/2, screenHeight/2, 0, 3)
	end
end
