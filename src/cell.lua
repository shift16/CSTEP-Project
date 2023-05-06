-- Import modules
local enforce_type = require "enforce_type"

-- Define the class constructor
local Cell = {}

-- Define the meta-table
local CellMT = {
	-- Defines the type of object
	__index = function (self, index)
		-- The __type property is always protected and therefore not modifiable
		if (index == "__type") then
			return "Cell"
		else
			error("The property " .. index .. " does not exist in type " .. self.__type)
		end
	end,

	-- Prevents the modification of undefined and protected properties
	__newindex = function (self, index, _)
		if (self[index] ~= nil) then
			error("The property " .. index .. " is not modifiable in type " .. self.__type)
		else
			error("The property " .. index .. " does not exist in type " .. self.__type)
		end
	end,

	-- Locks the meta-table
	__metatable = not nil
}

-- Create a new cell
function Cell.new(size_x, size_y, representing_graph, representing_node, cell_color, edge_color)
	-- Type checking
	enforce_type("number", size_x, size_y)
	enforce_type("table", cell_color, edge_color)
	enforce_type("Node", representing_node)
	enforce_type("Graph", representing_graph)

	return setmetatable({
		draw = function (_, point_x, point_y)
			-- Type checking
			enforce_type("number", point_x, point_y)

			local prev_color = {love.graphics.getColor()}
			-- Draws the cell
			love.graphics.setColor(unpack(cell_color))
			love.graphics.rectangle("fill", point_x, point_y, size_x, size_y)

			-- Draws the edges
			love.graphics.setColor(unpack(edge_color))
			local node_position_func = representing_node.id:gmatch("%d+")
			local x_pos = tonumber(node_position_func())
			local y_pos = tonumber(node_position_func())

			-- Get the nodes
			local left_node = representing_graph:get_node(tostring(x_pos - 1) .. " " .. tostring(y_pos))
			local right_node = representing_graph:get_node(tostring(x_pos + 1) .. " " .. tostring(y_pos))
			local top_node = representing_graph:get_node(tostring(x_pos) .. " " .. tostring(y_pos - 1))
			local bottom_node = representing_graph:get_node(tostring(x_pos) .. " " .. tostring(y_pos + 1))

			if left_node ~= nil then
				-- Left
				if not representing_node:is_linked(left_node) then
					love.graphics.rectangle("fill", point_x, point_y, size_x * .09, size_y)
				end
			else
				love.graphics.rectangle("fill", point_x, point_y, size_x * .09, size_y)				
			end

			if right_node ~= nil then
				-- Right
				if not representing_node:is_linked(right_node) then
					love.graphics.rectangle("fill", point_x + size_x * .91, point_y, size_x * .09, size_y)
				end
			else
				love.graphics.rectangle("fill", point_x + size_x * .91, point_y, size_x * .09, size_y)
			end
			
			if bottom_node ~= nil then
				-- Bottom
				if not representing_node:is_linked(bottom_node) then
					love.graphics.rectangle("fill", point_x, point_y + size_y * .91, size_x, size_y * .09)
				end
			else
				love.graphics.rectangle("fill", point_x, point_y + size_y * .91, size_x, size_y * .09)
			end

			if top_node ~= nil then
				-- Top
				if not representing_node:is_linked(top_node) then
					love.graphics.rectangle("fill", point_x, point_y, size_x, size_y * .09)
				end
			else
				love.graphics.rectangle("fill", point_x, point_y, size_x, size_y * .09)
			end

			love.graphics.setColor(unpack(prev_color))
		end,

		draw_using_node = function (self)
			-- Type checking
			enforce_type("Cell", self)

			local node_position_func = representing_node.id:gmatch("%d+")
			local x_pos = tonumber(node_position_func())
			local y_pos = tonumber(node_position_func())

			self:draw(x_pos * size_x, y_pos * size_y)
		end
	}, CellMT)
end

return Cell