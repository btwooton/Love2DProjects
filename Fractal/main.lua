function love.load()
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	branches = {}
	numBranches = 1
	branches[numBranches] = 
		createBranch(0, 0, 0, -150, -math.pi/2)

	leaves = {}
	numLeaves = 0

end

function love.draw()
	love.graphics.translate(screenWidth/2, screenHeight)
	for _, branch in ipairs(branches) do
		drawBranch(branch)
	end

	if numLeaves > 0 then
		for i=1, numLeaves do
			drawLeaf(leaves[i])
		end
	end
end

function love.update(dt)
	if numLeaves > 0 then
		for i = 1, numLeaves do
			if leaves[i].color.r < leaves[i].color.g then
				leaves[i].color.r = leaves[i].color.r + leaves[i].agingRate
			elseif leaves[i].color.g > 75 then
				leaves[i].color.g = leaves[i].color.g - leaves[i].agingRate
			elseif leaves[i].yVelocity == 0 then
				leaves[i].yVelocity = math.random(0.5, 1.5)
				branches[leaves[i].branchI].leaved = false
			end
			if leaves[i].y < 10 then
				leaves[i].y = leaves[i].y + leaves[i].yVelocity
			end
		end
	end
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 then
		for i = numBranches, 1, -1 do
			if not branches[i].branched and 
				not branches[i].leaved and getLength(branches[i]) > 5 then
				numBranches = numBranches + 1
				branches[numBranches] = branchLeft(branches[i])
				numBranches = numBranches + 1
				branches[numBranches] = branchRight(branches[i])
				branches[i].branched = true
			end
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == "l" then
		for i = 1, numBranches do
			if not branches[i].branched and not branches[i].leaved then
				numLeaves = numLeaves + 1
				leaves[numLeaves] = createLeaf(branches[i].x2, branches[i].y2, i)
				branches[i].leaved = true
			end
		end
	end
end

function createBranch(startX, startY, endX, endY, angle)

	return {
		x1 = startX,
		y1 = startY,
		x2 = endX,
		y2 = endY,
		rotation = angle,
		branched = false,
		leaved = false
	}
end

function createLeaf(posX, posY, branchIndex)

	return {
		x = posX,
		y = posY,
		color = {
			r = 68, 
			g = 145,
			b = 13
		},
		yVelocity = 0,
		branchI = branchIndex,
		agingRate = math.random(0.5, 3.5)
	}

end

function drawLeaf(leaf)

	love.graphics.setColor(leaf.color.r, leaf.color.g, leaf.color.b)
	love.graphics.circle("fill", leaf.x, leaf.y, 5)

end

function drawBranch(branch)
	love.graphics.setColor(255, 255, 255)
	love.graphics.line(branch.x1, branch.y1, branch.x2, branch.y2)
end

function getLength(branch)
	local xDist = (branch.x2 - branch.x1)^2
	local yDist = (branch.y2 - branch.y1)^2
	return math.sqrt(xDist + yDist)
end

function branchLeft(branch)
	local currentLength = getLength(branch)
	local newLength = currentLength * 0.75
	local newAngle = branch.rotation + (math.pi/4)
	local newX2 = newLength * math.cos(newAngle) + branch.x2
	local newY2 = newLength * math.sin(newAngle) + branch.y2
	return createBranch(branch.x2, branch.y2, newX2, newY2, newAngle)

end

function branchRight(branch)
	local currentLength = getLength(branch)
	local newLength = currentLength * 0.75
	local newAngle = branch.rotation - (math.pi/4)
	local newX2 = newLength * math.cos(newAngle) + branch.x2
	local newY2 = newLength * math.sin(newAngle) + branch.y2
	return createBranch(branch.x2, branch.y2, newX2, newY2, newAngle)
end

