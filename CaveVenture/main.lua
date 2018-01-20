local map = require "map"
local character = require "character"
local enemy = require "enemy"

function love.load()
	math.randomseed(os.time())

	WINDOW_WIDTH = 700
	WINDOW_HEIGHT = 700
	DIMENSION = 5
	CRYSTAL_SIZE = 3.75

	time_elapsed = 0

	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

	my_map = map.initialize(WINDOW_WIDTH/DIMENSION, WINDOW_HEIGHT/DIMENSION, 40)

	map.generate(my_map)

	map.addCrystals(my_map, DIMENSION)

	local spawn_coordinates = map.spawnCharacter(my_map, DIMENSION)

	my_character = character.create(spawn_coordinates.x, spawn_coordinates.y, DIMENSION)

	enemies = map.spawnEnemies(my_map, 100, DIMENSION)
end

function love.draw()
	love.graphics.push()
	love.graphics.scale(4, 4)
	love.graphics.translate(-(my_character.x - WINDOW_WIDTH/8), 
	-(my_character.y - WINDOW_HEIGHT/8))
	map.draw(my_map, DIMENSION, CRYSTAL_SIZE)
	character.draw(my_character)
	for _, e in ipairs(enemies) do
		enemy.draw(e)
	end
	love.graphics.pop()
end

function love.update(dt)
	time_elapsed = time_elapsed + dt
	
	if time_elapsed > 0.2 then

		for _, e in ipairs(enemies) do
			enemy.fall(e, my_map)
		end

		if my_character.falling then
			local next_row = math.floor((my_character.y + DIMENSION)/DIMENSION) + 1
			local next_col = math.floor(my_character.x/DIMENSION) + 1
			if next_row * DIMENSION > WINDOW_HEIGHT then
				my_character.y = 0
				my_map = nil
				my_map = map.initialize(WINDOW_WIDTH/DIMENSION, WINDOW_HEIGHT/DIMENSION, 40)
				map.generate(my_map)
				map.addCrystals(my_map, DIMENSION)
				next_row = 1
				(my_map[next_row][next_col]).val = 0
				(my_map[next_row][next_col - 1]).val = 0
				(my_map[next_row][next_col + 1]).val = 0

				enemies = map.spawnEnemies(my_map, 100, DIMENSION)
			elseif (my_map[next_row][next_col]).val == 0 then
				character.move(my_character, 0, DIMENSION)
			else
				my_character.falling = false
			end
		elseif my_character.leaping_right then
			if my_character.leap_count == 0 then
				my_character.leaping_right = false
			else
				local next_row = math.floor(my_character.y/DIMENSION) + 1
				local next_col = math.floor((my_character.x + DIMENSION)/DIMENSION) + 1
				if next_col <= table.getn(my_map[next_row]) and
					(my_map[next_row][next_col]).val == 0 then
					character.move(my_character, DIMENSION, 0)
					my_character.leap_count = my_character.leap_count - 1
				else
					my_character.leaping_right = false
					my_character.leap_count = 0
				end
			end

			if not my_character.leaping_right then
				my_character.falling = true
			end
		elseif my_character.leaping_left then
			if my_character.leap_count == 0 then
				my_character.leaping_left = false
			else
				local next_row = math.floor(my_character.y/DIMENSION) + 1
				local next_col = math.floor((my_character.x - DIMENSION)/DIMENSION) + 1
				if next_col > 0 and (my_map[next_row][next_col]).val == 0 then
					character.move(my_character, -DIMENSION, 0)
					my_character.leap_count = my_character.leap_count - 1
				else
					my_character.leaping_left = false
					my_character.leap_count = 0
				end
			end

			if not my_character.leaping_left then
				my_character.falling = true
			end
		elseif my_character.jumping then
			if my_character.jump_count == 0 then
				my_character.jumping = false
			else
				local next_row = math.floor((my_character.y - DIMENSION)/DIMENSION) + 1
				local next_col = math.floor(my_character.x/DIMENSION) + 1
				if (my_map[next_row][next_col]).val == 0 then
					character.move(my_character, 0, -DIMENSION)
					my_character.jump_count = my_character.jump_count - 1
				else
					my_character.jumping = false
					my_character.jump_count = 0
				end
			end

			if not my_character.jumping then
				my_character.falling = true
			end
		end
	end

	character.gatherCrystals(my_character, my_map)
	
end

function love.keypressed(key, scancode, isrepeat)

	if key == "right" then
		local next_row = math.floor(my_character.y/DIMENSION) + 1
		local next_col = math.floor((my_character.x + DIMENSION)/DIMENSION) + 1
		
		my_character.walking_right = true

		if next_col > table.getn(my_map[1]) then
			my_character.x = 0
			my_map = nil
			my_map = map.initialize(WINDOW_WIDTH/DIMENSION, 
			WINDOW_HEIGHT/DIMENSION, 40)
			map.generate(my_map)
			for i=1, 2 do
				for j=(my_character.y - DIMENSION)/DIMENSION, 
					(my_character.y + DIMENSION)/DIMENSION, 1 do
					(my_map[j][i]).val = 0
				end
			end
			map.addCrystals(my_map, DIMENSION)
			next_col = 1

			enemies = map.spawnEnemies(my_map, 100, DIMENSION)
		elseif (my_map[next_row][next_col]).val == 0 then 
			character.move(my_character, DIMENSION, 0)
		elseif next_row - 1 > 0 and (my_map[next_row-1][next_col]).val == 0 then
			character.move(my_character, DIMENSION, -DIMENSION)
		end

		if (my_map[next_row+1][next_col]).val and 
			(my_map[next_row+1][next_col]).val == 0 and not my_character.jumping
			and not my_character.leaping_right and not my_character.leaping_left then
			my_character.falling = true
		end

		for _, e in ipairs(enemies) do
			enemy.move(e, my_map)
		end

	elseif key == "left" then
		local next_row = math.floor(my_character.y/DIMENSION) + 1
		local next_col = math.floor((my_character.x - DIMENSION)/DIMENSION) + 1

		my_character.walking_left = true

		if next_col < 1 then
			my_character.x = WINDOW_WIDTH - DIMENSION
			my_map = nil
			my_map = map.initialize(WINDOW_WIDTH/DIMENSION, 
			WINDOW_HEIGHT/DIMENSION, 40)
			map.generate(my_map)
			local num_cols = table.getn(my_map[1])
			for i=num_cols-1, num_cols do
				for j=(my_character.y - DIMENSION)/DIMENSION, 
					(my_character.y + DIMENSION)/DIMENSION, 1 do
					(my_map[j][i]).val = 0
				end
			end
			map.addCrystals(my_map, DIMENSION)
			next_col = table.getn(my_map[1])
			enemies = map.spawnEnemies(my_map, 100, DIMENSION)
		elseif (my_map[next_row][next_col]).val == 0 then
			character.move(my_character, -DIMENSION, 0)
		elseif next_row - 1 > 0 and (my_map[next_row-1][next_col]).val == 0 then
			character.move(my_character, -DIMENSION, -DIMENSION)
		end

		if (my_map[next_row+1][next_col]).val and 
			(my_map[next_row+1][next_col]).val == 0 and not my_character.jumping
			and not my_character.leaping_right and not my_character.leaping_left then
			my_character.falling = true
		end


		for _, e in ipairs(enemies) do
			enemy.move(e, my_map)
		end

	end

	if key == "space" then
		if not my_character.falling then
			if my_character.walking_right then
				my_character.leaping_right = true
				character.leap(my_character)
			elseif my_character.walking_left then
				my_character.leaping_left = true
				character.leap(my_character)
			else
				my_character.jumping = true
				character.jump(my_character)
			end
		end

		for _, e in ipairs(enemies) do
			enemy.move(e, my_map)
		end
	end

	if key == "d" then
		character.dig(my_character, my_map, WINDOW_WIDTH, WINDOW_HEIGHT)
		map.updateCrystals(my_map, DIMENSION)
		my_character.digging = true
	end

	if key == "down" then
		my_character.look_down = true
	end
	
end

function love.keyreleased(key, scancode)
	if key == "right" then
		my_character.walking_right = false
	elseif key == "left" then
		my_character.walking_left = false
	elseif key == "d" then
		my_character.digging = false
	elseif key == "down" then
		my_character.look_down = false
	end
end
