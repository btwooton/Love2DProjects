local character = {}

function character.create(pos_x, pos_y, s)
	return {
		x = pos_x,
		y = pos_y,
		size = s,
		falling = false,
		leaping_left = false,
		leaping_right = false,
		jumping = false,
		walking_left = false,
		walking_right = false,
		digging = false,
		look_down = false,
		jump_count = 0,
		leap_count = 0
	}
end

function character.draw(_character)
	local size = _character.size
	love.graphics.setColor(255, 0, 255)
	love.graphics.rectangle("fill", _character.x, _character.y, size, size)
end

function character.move(_character, x_direction, y_direction)
	_character.x = _character.x + x_direction
	_character.y = _character.y + y_direction
end

function character.jump(_character)
	_character.jump_count = _character.jump_count + 4
end

function character.leap(_character)
	_character.leap_count = _character.leap_count + 5
end

function character.dig(_character, map, world_width, world_height)
	if _character.look_down and _character.y ~= world_height - _character.size then
		local next_row = math.floor((_character.y + _character.size)/_character.size) + 1
		local next_col = math.floor(_character.x/_character.size) + 1

		(map[next_row][next_col]).val = 0
		my_character.falling = true
	elseif _character.walking_right and _character.x ~= world_width - _character.size then
		local next_row = math.floor(_character.y/_character.size) + 1
		local next_col = math.floor((_character.x + _character.size)/_character.size) + 1

		(map[next_row][next_col]).val = 0
	elseif _character.walking_left and _character.x ~= 0 then
		local next_row = math.floor(_character.y/_character.size) + 1
		local next_col = math.floor((_character.x - _character.size)/_character.size) + 1

		(map[next_row][next_col]).val = 0
	end
end

function character.gatherCrystals(_character, _map)
	local current_row = math.floor(_character.y/_character.size) + 1
	local current_col = math.floor(_character.x/_character.size) + 1

	if _map[current_row][current_col].has_crystal then
		_map[current_row][current_col].has_crystal = false
		_map[current_row][current_col].crystal = nil
		return true
	else
		return false
	end
end

return character
