function love.load()
	screenDimension = 75
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	grid = createGrid(screenDimension)
	cells = createCells(screenDimension)
	love.graphics.setBackgroundColor(200, 200, 200)
	timeElapsed = 0
end

function love.update(dt)
	timeElapsed = timeElapsed + dt
	if love.keyboard.isDown("right") then
		if timeElapsed > 0.05 then
			grid = updateGrid()
			mapGOLGrid(screenDimension)
			timeElapsed = 0
		end
	end

	if love.keyboard.isDown("c") then
		for i, row in ipairs(cells) do
			for j, val in ipairs(row) do
				grid[i][j] = 0
			end
		end
		mapGOLGrid(screenDimension)
	end

	if love.mouse.isDown(1) then
		local mouseX = love.mouse.getX()
		local mouseY = love.mouse.getY()
		for i, row in ipairs(cells) do
			for j, cell in ipairs(row) do
				if isIn(cell, mouseX, mouseY) and  not cell.isVisible then
					cell.isVisible = not cell.isVisible
					grid[i][j] = grid[i][j] == 1 and 0 or 1
				end
			end
		end
	end
end

function isIn(cell, x, y) 
	return x > cell.xPos and y > cell.yPos and 
	x < cell.xPos + cell.width and y < cell.yPos + cell.height
end

function love.draw()
	for _, row in ipairs(cells) do
		for _, cell in ipairs(row) do
			if (cell.isVisible) then
				love.graphics.setColor(9, 15, 135)
				drawCell(cell)
			end
		end
	end
	drawGridLines()
end

function createCell(x, y, visible)
	local cell =  {
		width = screenWidth/screenDimension,
		height = screenHeight/screenDimension,
		xPos = x,
		yPos = y,
		isVisible = visible
	}
	return cell
end

function drawCell(cell)
	love.graphics.rectangle("fill", cell.xPos, cell.yPos, cell.width, cell.height)
end

function createCells(amount)
	local cells = {}
	local x = 0
	local y = 0
	local dx = screenWidth/amount
	local dy = screenHeight/amount
	for i=1, amount do
		cells[i] = {}
		for j=1, amount do
			cells[i][j] = createCell(x, y, grid[i][j] == 1 and true or false)
			x = x + dx
		end
		y = y + dy
		x = 0
	end
	return cells
end

function createGrid(amount)
	local grid = {}
	local nextVal = 0
	for i=1, amount do
		grid[i] = {}
		for j=1, amount do
			nextVal = math.random()
			if nextVal >= 0.5 then
				grid[i][j] = 1
			else
				grid[i][j] = 0
			end
		end
	end
	return grid
end


function getNumNeighbors(rowIndex, colIndex)
	if rowIndex == 1 then
		if colIndex == 1 then
			return grid[rowIndex+1][colIndex] +
			grid[rowIndex][colIndex+1] +
			grid[rowIndex+1][colIndex+1]
		elseif colIndex == screenDimension then
			return grid[rowIndex+1][colIndex] +
			grid[rowIndex+1][colIndex-1] +
			grid[rowIndex][colIndex-1]
		else
			return grid[rowIndex+1][colIndex] +
			grid[rowIndex+1][colIndex-1] +
			grid[rowIndex+1][colIndex+1] +
			grid[rowIndex][colIndex+1] +
			grid[rowIndex][colIndex-1]
		end
	elseif colIndex == 1 then
		if rowIndex == screenDimension then
			return grid[rowIndex][colIndex+1] +
			grid[rowIndex-1][colIndex] +
			grid[rowIndex-1][colIndex+1]
		else
			return grid[rowIndex+1][colIndex] +
			grid[rowIndex-1][colIndex] +
			grid[rowIndex][colIndex+1] +
			grid[rowIndex+1][colIndex+1] +
			grid[rowIndex-1][colIndex+1]
		end
	elseif rowIndex == screenDimension then
		if colIndex == screenDimension then
			return grid[rowIndex-1][colIndex] +
			grid[rowIndex-1][colIndex-1] +
			grid[rowIndex][colIndex-1]
		else
			return grid[rowIndex-1][colIndex] +
			grid[rowIndex-1][colIndex-1] +
			grid[rowIndex-1][colIndex+1] +
			grid[rowIndex][colIndex+1] +
			grid[rowIndex][colIndex-1]
		end
	elseif colIndex == screenDimension then
		return grid[rowIndex][colIndex-1] +
		grid[rowIndex+1][colIndex-1] +
		grid[rowIndex-1][colIndex-1] +
		grid[rowIndex+1][colIndex] +
		grid[rowIndex-1][colIndex]
	else
		return grid[rowIndex][colIndex+1] +
		grid[rowIndex][colIndex-1] +
		grid[rowIndex+1][colIndex] +
		grid[rowIndex-1][colIndex] +
		grid[rowIndex-1][colIndex+1] +
		grid[rowIndex-1][colIndex-1] +
		grid[rowIndex+1][colIndex-1] +
		grid[rowIndex+1][colIndex+1]
	end
end

function updateGrid()
	newGrid = createGrid(screenDimension)
	local numNeighbors
	for i, row in ipairs(grid) do
		for j, val in ipairs(row) do
			numNeighbors = getNumNeighbors(i, j)
			if val == 1  and numNeighbors < 2 then
				newGrid[i][j] = 0
			elseif val == 1 and numNeighbors == 2 or numNeighbors == 3 then
				newGrid[i][j] = 1
			elseif val == 1 and numNeighbors > 3 then
				newGrid[i][j] = 0
			elseif val == 0 and numNeighbors == 3 then
				newGrid[i][j] = 1
			else
				newGrid[i][j] = 0
			end
		end
	end
	return newGrid
end
			
function mapGOLGrid(size)
	for i, row in ipairs(grid) do
		for j, val in ipairs(row) do
			cells[i][j].isVisible = val == 1 and true or false
		end
	end
end

function drawHorizontalLines()
	local x1 = 0
	local x2 = screenWidth
	local y = screenHeight/screenDimension
	local dy = screenHeight/screenDimension
	while (y < screenHeight) do
		love.graphics.line(x1, y, x2, y)
		y = y + dy
	end
end

function drawVerticalLines()
	local x = screenWidth/screenDimension
	local dx = screenWidth/screenDimension
	local y1 = 0
	local y2 = screenHeight
	while (x < screenWidth) do
		love.graphics.line(x, y1, x, y2)
		x = x + dx
	end
end

function drawGridLines()
	love.graphics.setColor(0, 0, 0)
	love.graphics.setLineWidth(0.2)
	drawHorizontalLines()
	drawVerticalLines()
end
