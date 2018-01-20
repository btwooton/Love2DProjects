function love.load()
	math.randomseed(os.time())
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	love.graphics.setBackgroundColor(255, 255, 255)
	gridWidth = 30
	gridHeight = 16
	cellSize = 22
	numBombs = 0
	clicked = false
	gameOver = false
	gameWon = false
	gameGrid = createGrid(gridWidth, gridHeight)

end

function love.draw()
	drawGrid()
	displayBombCount()
	if gameOver then
		displayGameOver()
	end

	if gameWon then
		displayWin()
	end

end

function createCell(xPos, yPos, row, col)
	return {
		x = xPos,
		y = yPos,
		row = row,
		col = col,
		revealed = false,
		hasBomb = false,
		number = 0,
		hasFlag = false
	}
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 then
		if not clicked then
			if x > 60 and y > 50 and x < 720 and y < 402 then
				for _, row in ipairs(gameGrid) do
					for _, cell in ipairs(row) do
						if x > cell.x and y > cell.y and x < cell.x + cellSize
							and y < cell.y + cellSize then
							cell.revealed = true
							placeBombs(100, cell.col, cell.row)
							assignNumbers()
							floodFillCells(cell)
						end
					end
				end

			clicked = true
			end
		else
			for _, row in ipairs(gameGrid) do
				for _, cell in ipairs(row) do
					if x > cell.x and y > cell.y and x < cell.x + cellSize
						and y < cell.y + cellSize then
						if not cell.revealed and not cell.hasFlag then
							cell.revealed = true
							if cell.hasBomb then
								revealGrid()
								gameOver = true
							elseif cell.number == 0 then
								floodFillCells(cell)
							end			
						end
					end
				end
			end
		end
	elseif button == 2 then
		for _, row in ipairs(gameGrid) do
			for _, cell in ipairs(row) do
				if x > cell.x and y > cell.y and x < cell.x + cellSize
					and y < cell.y + cellSize then
					if not cell.revealed then
						cell.hasFlag = not cell.hasFlag
						if cell.hasFlag then
							numBombs = numBombs - 1
						else
							numBombs = numBombs + 1
						end
					end
				end
			end
		end
	end
	gameWon = checkWin()
end

function drawCell(cell)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", cell.x, cell.y, cellSize, cellSize)

	if cell.revealed then
		love.graphics.setColor(9, 59, 140)
	else
		love.graphics.setColor(66, 134, 244)
	end
	
	love.graphics.rectangle("fill", cell.x+1, cell.y+1, cellSize-2, cellSize-2)
	
	if cell.hasBomb and cell.revealed then
		love.graphics.setColor(0, 0, 0)
		love.graphics.circle("fill", cell.x + cellSize/2, cell.y + cellSize/2, 4)
	end

	if cell.number > 0 and cell.revealed and not cell.hasBomb then
		love.graphics.setColor(0, 0, 0)
		love.graphics.print(cell.number, cell.x, cell.y)
	end


	if cell.hasFlag then
		love.graphics.setColor(219, 35, 35)
		love.graphics.rectangle("fill", cell.x+4, cell.y+4, cellSize-8, cellSize-8)
	end
end

function drawGrid()
	for _, row in ipairs(gameGrid) do
		for _, cell in ipairs(row) do
			drawCell(cell)
		end
	end
end

function createGrid(width, height)
	local Xpos = 60
    local Ypos = 50
	local deltaX = cellSize
	local deltaY = cellSize
	local resultGrid = {}

	for i=1, height do
		resultGrid[i] = {}
		for j=1, width do
			resultGrid[i][j] = createCell(Xpos, Ypos, i, j)
			Xpos = Xpos + deltaX
		end
		Xpos = 60
		Ypos = Ypos + deltaY
	end
	return resultGrid
end

function placeBombs(count, safeCol, safeRow)
	while numBombs < count/2 do
		for i=1, gridHeight/2 do
			for j=1, gridWidth do
				if math.random() > 0.8 and not gameGrid[i][j].hasBomb
					and not (i == safeRow and j == safeCol)
					and not (i == safeRow - 1 and j == safeCol)
					and not (i == safeRow + 1 and j == safeCol)
					and not (i == safeRow and j == safeCol + 1)
					and not (i == safeRow and j == safeCol - 1)
					and not (i == safeRow - 1 and j == safeCol - 1)
					and not (i == safeRow + 1 and j == safeCol + 1)
					and not (i == safeRow + 1 and j == safeCol - 1)
					and not (i == safeRow - 1 and j == safeCol + 1)
					and numBombs < count/2 then
					gameGrid[i][j].hasBomb = true
					numBombs = numBombs + 1
				end
			end
		end
	end
	while numBombs < count do
		for i = gridHeight/2 + 1, gridHeight do
			for j=1, gridWidth do
				if math.random() > 0.8 and not gameGrid[i][j].hasBomb
					and not (i == safeRow and j == safeCol)
					and not (i == safeRow - 1 and j == safeCol)
					and not (i == safeRow + 1 and j == safeCol)
					and not (i == safeRow and j == safeCol + 1)
					and not (i == safeRow and j == safeCol - 1)
					and not (i == safeRow - 1 and j == safeCol - 1)
					and not (i == safeRow + 1 and j == safeCol + 1)
					and not (i == safeRow + 1 and j == safeCol - 1)
					and not (i == safeRow - 1 and j == safeCol + 1)
					and numBombs < count then
					gameGrid[i][j].hasBomb = true
					numBombs = numBombs + 1
				end
			end
		end
	end
end

function assignNumbers()
	local number = 0
	for i, row in ipairs(gameGrid) do
		for j, cell in ipairs(row) do
			for _, neighbor in ipairs(getNeighbors(cell, i, j)) do
				if neighbor.hasBomb then
					number = number + 1
				end
			end
			cell.number = number
			number = 0
		end
	end
end

function getNeighbors(cell, row, column)
	local neighbors
	if row == 1 then
		if column == 1 then
			neighbors = {
				gameGrid[row+1][column],
				gameGrid[row+1][column+1],
				gameGrid[row][column+1]
			}
		elseif column == gridWidth then
			neighbors = {
				gameGrid[row+1][column],
				gameGrid[row][column-1],
				gameGrid[row+1][column-1]
			}
		else
			neighbors = {
				gameGrid[row][column+1],
				gameGrid[row][column-1],
				gameGrid[row+1][column-1],
				gameGrid[row+1][column],
				gameGrid[row+1][column+1]
			}
		end
	elseif row == gridHeight then
		if column == 1 then
			neighbors = {
				gameGrid[row][column+1],
				gameGrid[row-1][column],
				gameGrid[row-1][column+1]
			}
		elseif column == gridWidth then
			neighbors = {
				gameGrid[row][column-1],
				gameGrid[row-1][column],
				gameGrid[row-1][column-1]
			}
		else
			neighbors = {
				gameGrid[row][column-1],
				gameGrid[row][column+1],
				gameGrid[row-1][column-1],
				gameGrid[row-1][column],
				gameGrid[row-1][column+1]
			}
		end
	elseif column == 1 then
		neighbors = {
			gameGrid[row+1][column],
			gameGrid[row-1][column],
			gameGrid[row+1][column+1],
			gameGrid[row][column+1],
			gameGrid[row-1][column+1]
		}
	elseif column == gridWidth then
		neighbors = {
			gameGrid[row+1][column],
			gameGrid[row-1][column],
			gameGrid[row+1][column-1],
			gameGrid[row-1][column-1],
			gameGrid[row][column-1]
		}
	else
		neighbors = {
			gameGrid[row][column+1],
			gameGrid[row][column-1],
			gameGrid[row+1][column],
			gameGrid[row-1][column],
			gameGrid[row-1][column-1],
			gameGrid[row-1][column+1],
			gameGrid[row+1][column-1],
			gameGrid[row+1][column+1]
		}
	end
	return neighbors
end

function revealGrid()
	for _, row in ipairs(gameGrid) do
		for _, cell in ipairs(row) do
			cell.revealed = true
		end
	end
end

function displayBombCount()
	love.graphics.setColor(21, 124, 33)
	love.graphics.print("Bombs Left: "..numBombs, 
	screenWidth/4, 
	screenHeight - screenHeight/4)
end

function displayGameOver()
	love.graphics.setColor(150, 20, 45)
	love.graphics.print("GAME OVER!!!",
	(screenWidth * 3)/4,
	screenHeight - screenHeight/4)
end

function displayWin()
	love.graphics.setColor(150, 20, 45)
	love.graphics.print("CONGRATULATIONS!!!",
	(screenWidth * 3)/4,
	screenHeight - screenHeight/4)
end

function floodFillCells(cell)
	local queue = {}
	local n
	local neighbors
	gameGrid[cell.row][cell.col].revealed = true
	table.insert(queue, 1, gameGrid[cell.row][cell.col])
	while not (table.getn(queue) == 0) do
		n = table.remove(queue)
		neighbors = getNeighbors(n, n.row, n.col)
		for _, neighbor in ipairs(neighbors) do
			if not gameGrid[neighbor.row][neighbor.col].revealed
				and not gameGrid[neighbor.row][neighbor.col].hasBomb then
				gameGrid[neighbor.row][neighbor.col].revealed = true
				if gameGrid[neighbor.row][neighbor.col].number == 0 then
					table.insert(queue, 1, gameGrid[neighbor.row][neighbor.col])
				end
			end
		end
	end
end

function checkWin()
	if gameOver then
		return false
	end
	for _, row in ipairs(gameGrid) do
		for _, cell in ipairs(row) do
			if not cell.revealed then
				if cell.hasBomb and not cell.hasFlag then
					return false
				elseif cell.hasFlag and not cell.hasBomb then
					return false
				end
			end
		end
	end
	return true
end
