local crystal = {}

function crystal.create(x_pos, y_pos, _color)

	local colors = {"red", "blue", "green", "orange", "purple", "yellow"}
	
	local random_color = colors[math.random(1, 6)]
	
	local red_level = 0
	local blue_level = 0
	local green_level = 0

	if random_color == "red" then
		red_level = 255
	elseif random_color == "blue" then
		blue_level = 255
	elseif random_color == "green" then
		green_level = 255
	elseif random_color == "orange" then
		red_level = 255
		green_level = 153
	elseif random_color == "purple" then
		red_level = 153
		blue_level = 153
	elseif random_color == "yellow" then
		red_level = 255
		green_level = 204
	end

	if not _color then
		return {
			x = x_pos,
			y = y_pos,
			color = {
				r = red_level,
				g = green_level,
				b = blue_level
			}
			
		}
	else
		return {
			x = x_pos, 
			y = y_pos,
			color = _color
		}
	end

end

function crystal.draw(c, size)
	local angle = 210
	
	local shard_end_x
	local shard_end_y

	local shard_mp_one_x
	local shard_mp_one_y

	local shard_mp_two_x
	local shard_mp_two_y

	love.graphics.setColor(c.color.r, c.color.g, c.color.b)

	for i=1, 5 do

		shard_end_x = c.x + size * math.cos(math.rad(angle))
		shard_end_y = c.y + size * math.sin(math.rad(angle))

		shard_mp_one_x = c.x + (size/2) * math.cos(math.rad(angle-10))
		shard_mp_one_y = c.y + (size/2) * math.sin(math.rad(angle-10))

		shard_mp_two_x = c.x + (size/2) * math.cos(math.rad(angle+10))
		shard_mp_two_y = c.y + (size/2) * math.sin(math.rad(angle+10))
		
		love.graphics.polygon("fill", c.x, c.y, shard_mp_one_x, shard_mp_one_y, 
		shard_end_x, shard_end_y, shard_mp_two_x, shard_mp_two_y)

		angle = angle + 30
	
	end

end

return crystal
