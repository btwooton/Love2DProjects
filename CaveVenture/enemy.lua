local enemy = {}

function enemy.create(x_pos, y_pos, s)
	return {
		x = x_pos,
		y = y_pos,
		size = s
	}

end

function enemy.draw(_enemy)
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", _enemy.x, _enemy.y, _enemy.size, _enemy.size)
end

function enemy.move(_enemy, _map)
	local direction
	if math.random(1, 100) > 50 then
		direction = 1
	else
		direction = -1
	end

	local next_col = ((_enemy.x + _enemy.size * direction)/_enemy.size) + 1
	local next_row = (_enemy.y/_enemy.size) + 1

	if _map[next_row][next_col] and (_map[next_row][next_col]).val == 0 then
		_enemy.x = _enemy.x + _enemy.size * direction
	elseif next_row - 1 > 0 and 
		_map[next_row-1][next_col] and 
		(_map[next_row-1][next_col]).val == 0 then
		_enemy.x = _enemy.x + _enemy.size * direction
		_enemy.y = _enemy.y - _enemy.size
	end
end

function enemy.fall(_enemy, _map)
	local current_col = _enemy.x/_enemy.size + 1
	local current_row = _enemy.y/_enemy.size + 1
	if current_row + 1 <= table.getn(_map) and 
		(_map[current_row + 1][current_col]).val == 0 then
		_enemy.y = _enemy.y + _enemy.size
	end
end

return enemy
