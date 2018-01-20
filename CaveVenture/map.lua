local map = {}

local crystal = require "crystal"
local enemy = require "enemy"

function randPick(fill_probability)
	if math.random(0, 100) < fill_probability then
		return 1
	else
		return 0
	end
end

function createCell(value)
	return {
		val = value,
		has_crystal = false,
		_crystal = nil
	}
end

function map.initialize(size_y, size_x, fill)
	local _map = {}

	for yi=1, size_y do
		_map[yi] = {}
	end

	for yi=2, size_y - 1 do
		for xi=2, size_x - 1 do
			_map[yi][xi] = createCell(randPick(fill))
		end
	end


	for yi=1, size_y do
		_map[yi][1] = createCell(1)
		_map[yi][size_x] = createCell(1)
	end


	for xi=1, size_x do
		_map[1][xi] = createCell(1)
		_map[size_y][xi] = createCell(1)
	end
	
	return _map

end

function map.generation(_map, r1_cutoff, r2_cutoff)

	local copy_map = {}

	local adjcount_r1
	local adjcount_r2

	for yi, row in ipairs(_map) do
		copy_map[yi] = {}
		for xi, cell in ipairs(row) do
			copy_map[yi][xi] = createCell(cell.val)
		end
	end

	for yi=2, table.getn(_map)-1 do
		for xi=2, table.getn(_map[1])-1 do
			adjcount_r1 = 0
			adjcount_r2 = 0

			for ii=-1, 1 do
				for jj=-1, 1 do
					if (_map[yi+ii][xi+jj]).val ~= 0 then
						adjcount_r1 = adjcount_r1 + 1
					end
				end
			end

			for ii=yi-2, yi+2 do
				for jj=xi-2, xi+2 do
					if math.abs(ii-yi) == 2 and math.abs(jj-xi) == 2 then
						goto continue
					end
					if ii <= 0 or jj <= 0 or
						ii > table.getn(_map) or jj > table.getn(_map[1]) then
						goto continue
					end
					if (_map[ii][jj]).val ~= 0 then
						adjcount_r2 = adjcount_r2 + 1
					end
					::continue::
				end
			end
			
			if r2_cutoff then
				if adjcount_r1 >= r1_cutoff or adjcount_r2 <= r2_cutoff then
					(copy_map[yi][xi]).val = 1
				else
					(copy_map[yi][xi]).val = 0
				end
			else
				if adjcount_r1 >= r1_cutoff then
					(copy_map[yi][xi]).val = 1
				else
					(copy_map[yi][xi]).val = 0
				end
			end
		end
	end

	for yi=1, table.getn(_map) do
		for xi=1, table.getn(_map[1]) do
			(_map[yi][xi]).val = (copy_map[yi][xi]).val
		end
	end

end

function map.generate(_map)

	local r1_cutoff = 5
	local r2_cutoff = 2

	for i=1, 4 do
		map.generation(_map, r1_cutoff, r2_cutoff)
	end

	for i=1, 3 do
		map.generation(_map, r1_cutoff)
	end

end

function map.draw(_map, dimension, crystal_size)

	local x_pos = 0
	local y_pos = 0

	for i, row in ipairs(_map) do
		for j, cell in ipairs(row) do
			if cell.val == 1 then
				love.graphics.setColor(0, 0, 0)
			else
				love.graphics.setColor(255, 255, 255)
			end
			love.graphics.rectangle("fill", x_pos, y_pos, dimension, dimension)
			if cell.has_crystal and cell._crystal then
				crystal.draw(cell._crystal, crystal_size)
			end
			x_pos = x_pos + dimension
		end
		y_pos = y_pos + dimension
		x_pos = 0
	end
end

function map.addCrystals(_map, dimension)

	local x_pos = 0
	local y_pos = 0

	for i, row in ipairs(_map) do
		for j, cell in ipairs(row) do
			if cell.val == 1 then
				cell.has_crystal = false
			elseif cell.val == 0 and i < table.getn(_map) and (_map[i+1][j]).val == 1 then
				if math.random(0, 500) < 100 then
					cell.has_crystal = true
					cell._crystal = crystal.create(x_pos + dimension/2,
					y_pos + dimension)
				end
			end
			x_pos = x_pos + dimension
		end
		x_pos = 0
		y_pos = y_pos + dimension
	end

end

function map.updateCrystals(_map, dimension)
	for i, row in ipairs(_map) do
		for j, cell in ipairs(row) do
			if i < table.getn(_map) then
				if (_map[i+1][j]).val == 0 and cell.has_crystal then
					cell.has_crystal = false
					(_map[i+1][j]).has_crystal = true
					(_map[i+1][j])._crystal = crystal.create(
						cell._crystal.x,
						cell._crystal.y + dimension,
						cell._crystal.color)
					cell._crystal = nil
				end
			end
		end
	end
end

function map.spawnCharacter(_map, dimension)

	local coordinates = nil

	while coordinates == nil do
		for i=1, #_map do
			for j=1, #(_map[1]) do 
				if i ~= #_map  and (_map[i][j]).val == 0 and (_map[i+1][j]).val == 1 
					and not (_map[i][j]).has_crystal then
					if math.random(0, 500) < 20 then
						coordinates = {
							x = j * dimension - dimension, 
							y = i * dimension - dimension
						}
						goto done
					end
				end
			end
		end
		::done::
	end

	return coordinates

end

function map.spawnEnemies(_map, amount, dimension)

	local enemies = {}
	local current_enemy = 1

	while table.getn(enemies) < amount do
		for i, row in ipairs(_map) do
			for j, cell in ipairs(row) do
				if i ~= table.getn(_map) and (_map[i][j]).val == 0 
					and (_map[i+1][j]).val == 1 
					and not (_map[i][j]).has_crystal then
					if math.random(0, 500) < 20 then
						enemies[current_enemy] =
						enemy.create(
							j * dimension - dimension,
							i * dimension - dimension,
							dimension)
						current_enemy = current_enemy + 1
					end
				end
			end
		end
	end

	return enemies
end



return map
